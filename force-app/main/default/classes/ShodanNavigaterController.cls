public with sharing class ShodanNavigaterController {

    // STERN LECTURE ABOUT WHAT'S MISSING HERE COMING SOON


    @AuraEnabled
    public static DataContext getDataContext(String recordId) {

        ShodanNavigaterTorihikiCtxResolvers.ITorihikiCtxResolver torihikiCtxResolver =
            ShodanNavigaterTorihikiCtxResolvers.GetResolver(recordId);
        if(torihikiCtxResolver == null) return null;

        ShodanNavigaterTorihikiCtxResolvers.TorihikiCtx torihikiCtx =
            torihikiCtxResolver.ResolveTorihikiCtx(recordId);
        
        return new DataContextProvider().GetDataCtx(torihikiCtx);
    }

    public class DataContextProvider{


        public DataContext GetDataCtx(
            ShodanNavigaterTorihikiCtxResolvers.TorihikiCtx torihikiCtx){
            String accountId = torihikiCtx.torihikiSakiId;

            Account account = (Account)SobjectsExtension.firstOrNull([Select Id, RecordTypeId From Account Where id = :accountId and id <> null]);
            if(account == null || account.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId()){
                return new DataContext();
            }

            List<Opportunity> opps = [SELECT Id, ShodanBangoF__c, Name, StageName, TorihikiShodanRef__c, CloseDate, TorihikiShodanFlag__c 
                                      FROM Opportunity WHERE AccountId = :accountId ORDER BY Req_Day__c DESC Limit 50];

            List<ShodanEntry> shodanNaviTorihikis = new List<ShodanEntry>();
            List<ShodanEntry> shodanNaviServices = new List<ShodanEntry>();
            
            for (Opportunity aOpp : opps) {

                ShodanEntry theShodanEntry = 
                    new ShodanEntry()
                        .SetShodanId(aOpp.Id)
                        .SetShodanBango(aOpp.ShodanBangoF__c)
                        .SetShodanName(aOpp.Name)
                        .SetPhase(aOpp.StageName)
                        .SetKanryoYoteiBi(aOpp.CloseDate)
                        .SetTorihikiShodanId(aOpp.TorihikiShodanRef__c);

                if(aOpp.TorihikiShodanFlag__c){
                    shodanNaviTorihikis.add(theShodanEntry);
                }else{
                    shodanNaviServices.add(theShodanEntry);
                }
            }

            return new DataContext()
                .SetViewContext(new ViewContext()
                    .SetTorihikiSakiId(accountId)
                    .SetTorihikiShodanId(torihikiCtx.torihikiShodanId)
                )
                .SetShodanNaviTorihikis(shodanNaviTorihikis)
                .SetShodanNaviServices(shodanNaviServices)
                ;
        }
    }

    public class DataContext{
        @AuraEnabled public ViewContext viewContext {
            get { 
                if(this.viewContext == null) this.viewContext = new ViewContext();
                return this.viewContext; 
            }
            set { viewContext = value; }
        }
        @AuraEnabled public List<ShodanEntry> shodanNaviTorihikis {
            get { 
                if(this.shodanNaviTorihikis == null) this.shodanNaviTorihikis = new List<ShodanEntry>();
                return this.shodanNaviTorihikis; 
            }
            set { shodanNaviTorihikis = value; }
        }
        @AuraEnabled public List<ShodanEntry> shodanNaviServices {
            get { 
                if(this.shodanNaviServices == null) this.shodanNaviServices = new List<ShodanEntry>();
                return this.shodanNaviServices;
            }
            set { shodanNaviServices = value; }
        }
        public DataContext SetViewContext(ViewContext viewContext){
            this.viewContext = viewContext; return this;
        }
        public DataContext SetShodanNaviTorihikis(List<ShodanEntry> shodanNaviTorihikis){
            this.shodanNaviTorihikis = shodanNaviTorihikis;
            return this;
        }
        public DataContext SetShodanNaviServices(List<ShodanEntry> shodanNaviServices){
            this.shodanNaviServices = shodanNaviServices;
            return this;
        }
    }

    public class ViewContext{
        @AuraEnabled public String torihikisakiId {
            get { return torihikisakiId; }
            set { torihikisakiId = value; }
        }
        @AuraEnabled public String torihikiShodanId {
            get { return torihikiShodanId; }
            set { torihikiShodanId = value; }
        }

        public ViewContext SetTorihikiSakiId(String recordId){
            this.torihikisakiId = recordId; return this;
        }
        public ViewContext SetTorihikiShodanId(String recordId){
            this.torihikiShodanId = recordId; return this;
        }
    }

    public class ShodanEntry{
        @AuraEnabled public String shodanId {
            get { if(shodanId==null){shodanId='';} return shodanId; }
            set { shodanId = value; }
        }
        public ShodanEntry SetShodanId(String recordId){
            this.shodanId = recordId; return this;
        }

        @AuraEnabled public String shodanBango {
            get { if(shodanBango==null){shodanBango='';} return shodanBango; }
            set { shodanBango = value; }
        }
        public ShodanEntry SetShodanBango(String shodanBango){
            this.shodanBango = shodanBango; return this;
        }

        @AuraEnabled public String shodanName {
            get { if(shodanName==null){shodanName='';} return shodanName; }
            set { shodanName = value; }
        }
        public ShodanEntry SetShodanName(String shodanName){
            this.shodanName = shodanName; return this;
        }

        @AuraEnabled public String torihikiShodanId {
            get { if(torihikiShodanId==null){torihikiShodanId='';} return torihikiShodanId; }
            set { torihikiShodanId = value; }
        }
        public ShodanEntry SetTorihikiShodanId(String recordId){
            this.torihikiShodanId = recordId; return this;
        }

        @AuraEnabled public String serviceId {
            get { if(serviceId==null){serviceId='';} return serviceId; }
            set { serviceId = value; }
        }

        @AuraEnabled public String phase {
            get { if(phase==null){phase='';} return phase; }
            set { this.phase = value; }
        }
        public ShodanEntry setPhase(String value){
            this.phase = value; return this;
        }

        @AuraEnabled public Date kanryoYoteiBi {
            get { return kanryoYoteiBi; }
            set { kanryoYoteiBi = value; }
        }
        public ShodanEntry SetKanryoYoteiBi(Date value){
            this.kanryoYoteiBi = value; return this;
        }
    }

}