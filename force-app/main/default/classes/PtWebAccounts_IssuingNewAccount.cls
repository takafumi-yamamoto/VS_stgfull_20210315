public class PtWebAccounts_IssuingNewAccount {

    private static String f_startRequestName = PtWebAccounts_IssuingNewAccountTask.Class.toString();
    public class PtWebAccounts_IssuingNewAccountTask implements Queueable, Database.AllowsCallouts{
        private Id f_TaskId = null;

        public PtWebAccounts_IssuingNewAccountTask(Id pTaskId){ this.f_TaskId = pTaskId; }

        public void run(){
            List<PtWebAccountIrai__c> theTasks = new List<PtWebAccountIrai__c>(
                [
                    select 
                    Id, MailAddress__c,
                    AccountRef__r.RecordTypeId, AccountRef__r.TorihikisakiBangoF__c, AccountRef__r.Name
                    from PtWebAccountIrai__c 
                    where IraiKubun__c = '新規' and Id = :this.f_TaskId
                    limit 1
                ]
            );
            if( theTasks.size() <= 0 ) return;
            PtWebAccountIrai__c theTask = theTasks.get(0);

            PtWebApi_Account_Issue.ReqArgs theReqArgs = new PtWebApi_Account_Issue.ReqArgs();
            theReqArgs.email = String.isBlank(theTask.MailAddress__c) ? '' : theTask.MailAddress__c;
            theReqArgs.torihikisaki_bango = theTask.AccountRef__r.TorihikisakiBangoF__c;
            theReqArgs.torihikisaki_name = theTask.AccountRef__r.Name;
            theReqArgs.role = '';
            if( theTask.AccountRef__r.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('SoryoAccount').getRecordTypeId() ){
                theReqArgs.role = 'souryo';
            }
            if( theTask.AccountRef__r.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Sogisya').getRecordTypeId() ){
                theReqArgs.role = 'sougisha';
            }    
            PtWebApi_Account_Issue.Result theResult = new PtWebApi_Account_Issue.Agent().sendRequest(theReqArgs);

            Loggings.writeLog(
                Loggings.createLogEntry(
                        theResult.isSuccess ? Loggings.Level.Info : Loggings.Level.Error,
                        '20180713-1733-01', 'PtWeb.Account.Issue'
                    )
                    .setSubjectRecordId(theTask.Id)
                    .putAttr('endPoint', theResult.endPoint )
                    .putAttr('statusCode', String.valueOf(theResult.statusCode) )
                    .putAttr('descr', theResult.descr )
                    .putAttr('reqBodyRaw', theResult.reqBodyRaw )
                    .putAttr('resBodyRaw', theResult.resBodyRaw )
            );
            
            theTask.ShoriStatus__c = theResult.isSuccess ? 'Completed' : 'Faulted';
            Update theTask;
        }

        //implements Queueable Begin
        public void execute(QueueableContext context) {
                this.run();
        }
        //implements Queueable End
    }

    private static void sendStartRequest(){
        Asyncs_Broker.requestStart( f_startRequestName );
    }

    private void start(){

        List<PtWebAccountIrai__c> theTasks = new List<PtWebAccountIrai__c>(
            [
                select Id
                from PtWebAccountIrai__c 
                where ShoriStatus__c = 'Created' and IraiKubun__c = '新規'
                and LastModifiedDate >= :DateTime.now().addDays(-30)
                limit 5
                for update
            ]
        );
        for(PtWebAccountIrai__c aTask : theTasks){ aTask.ShoriStatus__c = 'Running'; } 
        Update theTasks;

        for(PtWebAccountIrai__c aTask : theTasks){ System.enqueueJob( new PtWebAccounts_IssuingNewAccountTask(aTask.Id) ); }

        List<PtWebAccountIrai__c> theTaskLeft = new List<PtWebAccountIrai__c>(
            [
                select Id
                from PtWebAccountIrai__c 
                where ShoriStatus__c = 'Created' and IraiKubun__c = '新規'
                and LastModifiedDate >= :DateTime.now().addDays(-30)
                limit 1
            ]
        );
        if( theTaskLeft.size() >= 1 ) sendStartRequest();
    }

    public static void subscriveOnAyncBrokerOnRunRequested(string pRequestName){
        if(pRequestName == f_startRequestName ){ 
            new PtWebAccounts_IssuingNewAccount().start();
        }
    }

    public void subscrivePtWebAccountIraiOnAfterUpdated(List<PtWebAccountIrai__c> pNewOnes, Map<ID, PtWebAccountIrai__c> pOldOnes, Map<Id,Account> pAccounts){
        Map<Id,PtWebAccountIrai__c> theNewOnesOfNewAccountToBeProceessed = new Map<Id,PtWebAccountIrai__c>();
        for(PtWebAccountIrai__c aNewOne : pNewOnes){
            PtWebAccountIrai__c aOldOne = pOldOnes.get(aNewOne.Id);

            if(aNewOne.ShoriStatus__c != 'Created') continue;
            if(aNewOne.IraiKubun__c != '新規') continue;
            if(aNewOne.IraiStatus__c != '送信') continue;
            if(aNewOne.IraiStatus__c == aOldOne.IraiStatus__c) continue;

            if (pAccounts.get(aNewOne.AccountRef__c).PtWebAccountRef__c != null){
                aNewOne.AccountRef__c.addError('既にPtWebAccountが存在;'); continue;
            }
            if ( String.isBlank(aNewOne.MailAddress__c) ){
                aNewOne.MailAddress__c.addError('メールアドレスを登録してください;'); continue;
            }

            theNewOnesOfNewAccountToBeProceessed.put(aNewOne.Id, aNewOne);
        }

        if(theNewOnesOfNewAccountToBeProceessed.size() > 0){
            Set<String> theMailAddresses = new Set<String>();
            for( PtWebAccountIrai__c aNewOne : theNewOnesOfNewAccountToBeProceessed.values() ){ 
                if( !String.isBlank(aNewOne.MailAddress__c) ) theMailAddresses.add( aNewOne.MailAddress__c );
            }
            Map<Id,PtWebAccount__c> thePtWebAccounts = new Map<Id,PtWebAccount__c>(
                [
                    select Id, MailAddress__c from PtWebAccount__c where MailAddress__c = :theMailAddresses
                ]
            );

            Set<String> theMailAddressesExists = new Set<String>();
            for(PtWebAccount__c aPtWebAccount : thePtWebAccounts.values() ){ theMailAddressesExists.add( aPtWebAccount.MailAddress__c ); }

            for(PtWebAccountIrai__c aNewOne : theNewOnesOfNewAccountToBeProceessed.values()){
                if( theMailAddressesExists.contains(aNewOne.MailAddress__c) ){
                    aNewOne.MailAddress__c.addError('既に使用されているメールアドレス;'); 
                    theNewOnesOfNewAccountToBeProceessed.remove(aNewOne.Id);
                }
            }
        }

        if( theNewOnesOfNewAccountToBeProceessed.size() > 0){ sendStartRequest(); }
    }
}