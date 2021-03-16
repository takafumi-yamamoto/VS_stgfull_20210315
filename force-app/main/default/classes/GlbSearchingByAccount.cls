public class GlbSearchingByAccount {

    public class ResetAccountInfoTask implements Queueable{
        private Id f_TaskId;
        public ResetAccountInfoTask(Id pTaskId){ this.f_TaskId = pTaskId; }

        public void run(){
            List<GlbSearchingByAccount_ResetAccInfoTask__c> theTasks =
                [
                    select Id, AccountRef__c,
                    AccountRef__r.LastName, AccountRef__r.FirstName, AccountRef__r.NameFurigana__c, 
                    AccountRef__r.Phone, AccountRef__r.MobilePhone__c
                    from GlbSearchingByAccount_ResetAccInfoTask__c 
                    where Id = :this.f_TaskId
                    Limit 1
                ];
            if( theTasks.size() <= 0 ) return;

            GlbSearchingByAccount_ResetAccInfoTask__c theTask = theTasks.get(0);

            if( theTask.AccountRef__c == null ){
                theTask.ShoriStatus__c = 'Completed';
                Update theTask;
                return;
            }

            Map<Id, Opportunity> theOpps = new Map<Id, Opportunity>();

            //相談者
            for(Opportunity aOpp : [select Id from opportunity where AccountId = :theTask.AccountRef__c ]){
                Opportunity theOpp;
                if( theOpps.containsKey(aOpp.Id) ){ theOpp = theOpps.get(aOpp.Id); } else { theOpp = aOpp; theOpps.put(aOpp.Id,aOpp); }
                theOpp.SodanshaNameTxt__c = theTask.AccountRef__r.LastName + ' ' + theTask.AccountRef__r.FirstName; 
                theOpp.SodanshaFuriganaTxt__c = theTask.AccountRef__r.NameFurigana__c; 
                theOpp.SodanshaPhoneTxt__c = theTask.AccountRef__r.Phone;
                theOpp.SodanshaMobilePhoneTxt__c = theTask.AccountRef__r.MobilePhone__c;
            }

            //シンプル安豪-対象者
            Map<Id,SimpleYasugo__c> theSimpleOfTaishosha = 
                new Map<Id,SimpleYasugo__c>( [select Id from SimpleYasugo__c where TaishoshaRef__c =:theTask.AccountRef__c] );

            for(Opportunity aOpp : [ select Id from Opportunity where SimpleYasugoRef__c =:theSimpleOfTaishosha.keySet() ]){
                Opportunity theOpp;
                if( theOpps.containsKey(aOpp.Id) ){ theOpp = theOpps.get(aOpp.Id); } else { theOpp = aOpp; theOpps.put(aOpp.Id,aOpp); }
                theOpp.TaisyousyaNameTxt__c = theTask.AccountRef__r.LastName + ' ' + theTask.AccountRef__r.FirstName;
                theOpp.TaisyousyaFurigana__c = theTask.AccountRef__r.NameFurigana__c;
                theOpp.TaisyousyaPhone__c = theTask.AccountRef__r.Phone;
                theOpp.TaisyousyaMobilePhone__c = theTask.AccountRef__r.MobilePhone__c;
            }

            //シンプル安豪-喪主
            Map<Id,SimpleYasugo__c> theSimpleOfMoshu = 
                new Map<Id,SimpleYasugo__c>( [select Id from SimpleYasugo__c where MoshuRef__c =:theTask.AccountRef__c] );
            for(Opportunity aOpp : [ select Id from Opportunity where SimpleYasugoRef__c =:theSimpleOfMoshu.keySet() ]){
                Opportunity theOpp;
                if( theOpps.containsKey(aOpp.Id) ){ theOpp = theOpps.get(aOpp.Id); } else { theOpp = aOpp; theOpps.put(aOpp.Id,aOpp); }
                theOpp.MosyuNameTxt__c = theTask.AccountRef__r.LastName + ' ' + theTask.AccountRef__r.FirstName;
                theOpp.MosyuFuriganaTxt__c = theTask.AccountRef__r.NameFurigana__c;
                theOpp.MosyuPhoneTxt__c = theTask.AccountRef__r.Phone;
                theOpp.MosyuMobilePhoneTxt__c = theTask.AccountRef__r.MobilePhone__c;
            }

            //お坊さん便-対象者
            Map<Id,Obosanbin__c> theObousanbinsOfTaishosha = 
                new Map<Id,Obosanbin__c>( [select Id from Obosanbin__c where Taishosha1Ref__c =:theTask.AccountRef__c] );
            for(Opportunity aOpp : [ select Id from Opportunity where ObosanbinRef__c =:theObousanbinsOfTaishosha.keySet() ]){
                Opportunity theOpp;
                if( theOpps.containsKey(aOpp.Id) ){ theOpp = theOpps.get(aOpp.Id); } else { theOpp = aOpp; theOpps.put(aOpp.Id,aOpp); }
                theOpp.TaisyousyaNameTxt__c = theTask.AccountRef__r.LastName + ' ' + theTask.AccountRef__r.FirstName;
                theOpp.TaisyousyaFurigana__c = theTask.AccountRef__r.NameFurigana__c;
                theOpp.TaisyousyaPhone__c = theTask.AccountRef__r.Phone;
                theOpp.TaisyousyaMobilePhone__c = theTask.AccountRef__r.MobilePhone__c;
            }
            //お坊さん便-喪主
            Map<Id,Obosanbin__c> theObousanbinsOfMoshu = 
                new Map<Id,Obosanbin__c>( [select Id from Obosanbin__c where MoshuRef__c =:theTask.AccountRef__c] );
            for(Opportunity aOpp : [ select Id from Opportunity where ObosanbinRef__c =:theObousanbinsOfMoshu.keySet() ]){
                Opportunity theOpp;
                if( theOpps.containsKey(aOpp.Id) ){ theOpp = theOpps.get(aOpp.Id); } else { theOpp = aOpp; theOpps.put(aOpp.Id,aOpp); }
                theOpp.MosyuNameTxt__c = theTask.AccountRef__r.LastName + ' ' + theTask.AccountRef__r.FirstName;
                theOpp.MosyuFuriganaTxt__c = theTask.AccountRef__r.NameFurigana__c;
                theOpp.MosyuPhoneTxt__c = theTask.AccountRef__r.Phone;
                theOpp.MosyuMobilePhoneTxt__c = theTask.AccountRef__r.MobilePhone__c;
            }
            Update theOpps.values();   

            Delete [
                select Id from GlbSearchingByAccount_ResetAccInfoTask__c 
                where LastModifiedDate < :DateTime.now().addDays(-60) 
                and ShoriStatus__c = 'Completed'
                limit 50 
                ];

            theTask.ShoriStatus__c = 'Completed';
            Update theTask;
        }
        //implements Queueable Begin
        public void execute(QueueableContext context) {
                this.run();
        }
        //implements Queueable End
    }

    public  void start_ResetAccountInfoTask(){
        List<GlbSearchingByAccount_ResetAccInfoTask__c> theTasks = new List<GlbSearchingByAccount_ResetAccInfoTask__c>(
            [
                select Id
                from GlbSearchingByAccount_ResetAccInfoTask__c 
                where ShoriStatus__c = 'Created'
                and LastModifiedDate >= :DateTime.now().addDays(-30)
                limit 20
                for update
            ]
        );
        for(GlbSearchingByAccount_ResetAccInfoTask__c aTask : theTasks){ aTask.ShoriStatus__c = 'Running'; } 
        Update theTasks;

        for(GlbSearchingByAccount_ResetAccInfoTask__c aTask : theTasks){ System.enqueueJob( new ResetAccountInfoTask(aTask.Id) ); }

        List<GlbSearchingByAccount_ResetAccInfoTask__c> theTaskLeft = new List<GlbSearchingByAccount_ResetAccInfoTask__c>(
            [
                select Id
                from GlbSearchingByAccount_ResetAccInfoTask__c 
                where ShoriStatus__c = 'Created'
                and LastModifiedDate >= :DateTime.now().addDays(-30)
                limit 1
            ]
        );
        if( theTaskLeft.size() >= 1 ) sendStartRequest_ResetAccountInfoTask();
    }

    private static void sendStartRequest_ResetAccountInfoTask(){
        Asyncs_Broker.requestStart( GlbSearchingByAccount.ResetAccountInfoTask.class.toString() );   
    }

    public void subscriveOnAccountAfterUpdated(List<Account> pNewOnes, Map<Id,Account> pOldOnes){

        List<GlbSearchingByAccount_ResetAccInfoTask__c> theTasks = new List<GlbSearchingByAccount_ResetAccInfoTask__c>();
        Set<Id> theAccountIds = new Set<Id>();
        for(Account aNewOne : pNewOnes){
            Account aOldOne = pOldOnes.get(aNewOne.Id);

            if( aNewOne.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId() ){
                continue;
            }
            if(aNewOne.LastName != aOldOne.LastName){ theAccountIds.add(aNewOne.Id); continue; }
            if(aNewOne.FirstName != aOldOne.FirstName){ theAccountIds.add(aNewOne.Id); continue; }
            if(aNewOne.NameFurigana__c != aOldOne.NameFurigana__c){ theAccountIds.add(aNewOne.Id); continue; }
            if(aNewOne.Phone != aOldOne.Phone){ theAccountIds.add(aNewOne.Id); continue; }
            if(aNewOne.MobilePhone__c != aOldOne.MobilePhone__c){ theAccountIds.add(aNewOne.Id); continue; }
        }

        for(Id aAccountId : theAccountIds){
            theTasks.add(
                new GlbSearchingByAccount_ResetAccInfoTask__c( AccountRef__c = aAccountId, ShoriStatus__c = 'Created' )
            );
        }
        Insert theTasks;
    }

    public void subscriveOnGlbSearchingByAccountResetAccInfoTaskAfterInserted(List<GlbSearchingByAccount_ResetAccInfoTask__c> pNewOnes){
        sendStartRequest_ResetAccountInfoTask();
    }
    
    public void subscriveOnAsyncBrokerOnRunRequested(string pRequestName){
        if(pRequestName == GlbSearchingByAccount.ResetAccountInfoTask.class.toString() ){ 
            new GlbSearchingByAccount().start_ResetAccountInfoTask();
        }
    }
}