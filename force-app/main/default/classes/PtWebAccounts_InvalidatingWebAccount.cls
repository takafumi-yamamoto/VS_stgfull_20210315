public class PtWebAccounts_InvalidatingWebAccount {
    private static String f_startRequestName = PtWebAccounts_InvalidatingWebAccountTask.Class.toString();

    public class PtWebAccounts_InvalidatingWebAccountTask implements Queueable, Database.AllowsCallouts{

        private Id f_TaskId = null;

        public PtWebAccounts_InvalidatingWebAccountTask(Id pTaskId){ this.f_TaskId = pTaskId; }

        public void run(){
            List<PtWebAccountIrai__c> theTasks = new List<PtWebAccountIrai__c>(
                [
                    select 
                    Id
                    ,AccountRef__c
                    ,AccountRef__r.TorihikisakiBangoF__c
                    ,MailAddress__c
                    ,isSendDeleteMail__c
                    from PtWebAccountIrai__c 
                    where Id = :this.f_TaskId and IraiKubun__c = '削除'
                    limit 1
                ]
            );
            if( theTasks.size() <= 0 ) return;

            PtWebAccountIrai__c theTask = theTasks.get(0);
            PtWebApi_Account_invalidate.ReqArgs theReqArgs = new PtWebApi_Account_invalidate.ReqArgs();
            theReqArgs.torihikisaki_bango = String.isBlank(theTask.AccountRef__r.TorihikisakiBangoF__c) ? '' : theTask.AccountRef__r.TorihikisakiBangoF__c;
            theReqArgs.email = theTask.MailAddress__c;
            theReqArgs.is_send_mail = theTask.isSendDeleteMail__c;
            PtWebApi_Account_invalidate.Result theResult = new PtWebApi_Account_invalidate.Agent().sendRequest(theReqArgs);

            Loggings.writeLog(
                Loggings.createLogEntry(
                        theResult.isSuccess ? Loggings.Level.Info : Loggings.Level.Error,
                        '20180713-1907-01', 'PtWeb.Account.Invalidate'
                    )
                    .setSubjectRecordId(theTask.Id)
                    .putAttr('endPoint', theResult.endPoint )
                    .putAttr('statusCode', String.valueOf(theResult.statusCode) )
                    .putAttr('descr', theResult.descr )
                    .putAttr('reqBodyRaw', theResult.reqBodyRaw )
                    .putAttr('resBodyRaw', theResult.resBodyRaw )
            );
            

            if(theResult.isSuccess){
                List<PtWebAccount__c> ptWebAccs = [
                    SELECT
                        Id
                    FROM
                        PtWebAccount__c
                    WHERE
                        MailAddress__c = :theTask.MailAddress__c
                    AND
                        AccountRef__r.TorihikisakiBangoF__c = :theTask.AccountRef__r.TorihikisakiBangoF__c
                ];

                if(ptWebAccs.size() > 0){
                    for (PtWebAccount__c ptWebAcc : ptWebAccs) {
                        Delete ptWebAcc;
                    }
                }
            }
            
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
                where ShoriStatus__c = 'Created' and IraiKubun__c = '削除'
                and LastModifiedDate >= :DateTime.now().addDays(-30)
                limit 20
                for update
            ]
        );
        for(PtWebAccountIrai__c aTask : theTasks){
            aTask.ShoriStatus__c = 'Running';
        }
        Update theTasks;
        for(PtWebAccountIrai__c aTask : theTasks){
            System.enqueueJob( new PtWebAccounts_InvalidatingWebAccountTask(aTask.Id) );
        }

        List<PtWebAccountIrai__c> theTaskLeft = new List<PtWebAccountIrai__c>(
            [
                select Id
                from PtWebAccountIrai__c 
                where ShoriStatus__c = 'Created' and IraiKubun__c = '削除'
                and LastModifiedDate >= :DateTime.now().addDays(-30)
                limit 1
            ]
        );
        if( theTaskLeft.size() >= 1 ) sendStartRequest();
    }

    public static void subscriveOnAyncBrokerOnRunRequested(string pRequestName){
        if(pRequestName == f_startRequestName ){ 
            new PtWebAccounts_InvalidatingWebAccount().start();
        }
    }

    public void subscrivePtWebAccountIraiOnAfterUpdated(List<PtWebAccountIrai__c> pNewOnes, Map<ID, PtWebAccountIrai__c> pOldOnes){
        Map<Id,PtWebAccountIrai__c> theNewOnesToBeProceessed = new Map<Id,PtWebAccountIrai__c>();
        for(PtWebAccountIrai__c aNewOne : pNewOnes){
            PtWebAccountIrai__c aOldOne = pOldOnes.get(aNewOne.Id);

            if(aNewOne.ShoriStatus__c != 'Created') continue;
            if(aNewOne.IraiKubun__c != '削除') continue;
            if(aNewOne.IraiStatus__c != '送信') continue;
            if(aNewOne.IraiStatus__c == aOldOne.IraiStatus__c) continue;

            theNewOnesToBeProceessed.put(aNewOne.Id, aNewOne);
        }

        if( theNewOnesToBeProceessed.size() > 0){ sendStartRequest(); }
    }
}