public with sharing class ShodanShohinNavigaterController {

    @AuraEnabled
    public static DataContext getDataContext(String recordId) {

        ShodanNavigaterTorihikiCtxResolvers.ITorihikiCtxResolver torihikiCtxResolver =
            ShodanNavigaterTorihikiCtxResolvers.GetResolver(recordId);
        if(torihikiCtxResolver == null) return null;

        ShodanNavigaterTorihikiCtxResolvers.TorihikiCtx torihikiCtx =
            torihikiCtxResolver.ResolveTorihikiCtx(recordId);

        return new DataContextProvider
            (
            new OpportunityDao(), 
            RecordTypeCachedDaos.GetInstance()
            )
            .GetDataCtx(torihikiCtx);
    }

    public class DataContextProvider{
        private OpportunityDao f_OpportunityDao;
        private RecordTypeCachedDaos.IRecordTypeCachedDao f_RecordTypeCachedDao;

        public DataContextProvider(
            OpportunityDao opportunityDao, 
            RecordTypeCachedDaos.IRecordTypeCachedDao recordTypeCachedDao
            ){
            this.f_OpportunityDao = opportunityDao;
            this.f_RecordTypeCachedDao = recordTypeCachedDao;
        }

        public DataContext GetDataCtx(
            ShodanNavigaterTorihikiCtxResolvers.TorihikiCtx torihikiCtx){
            String accountId = torihikiCtx.torihikiSakiId;

            List<Opportunity> opps = this.f_OpportunityDao.SelectByAccountId(accountId);
            
            List<ShodanNaviTorihiki> shodanNaviTorihikis = new List<ShodanNaviTorihiki>();

            for (Opportunity aOpp : opps) {
                String recordTypeApiName = this.f_RecordTypeCachedDao.SelectDeveloperNameById(aOpp.RecordTypeId);
                if(recordTypeApiName == 'TorihikiShodan'){
                    shodanNaviTorihikis.add(
                        new ShodanNaviTorihiki()
                            .SetShodanId(aOpp.Id)
                            .SetShodanBango(aOpp.ShodanBangoF__c)
                            .SetShodanName(aOpp.Name)
                    );
                }
            }

            return new DataContext()
                .SetViewContext(new ViewContext()
                    .SetTorihikiSakiId(accountId)
                    .SetTorihikiShodanId(torihikiCtx.torihikiShodanId)
                    .SetCurrentViewingShodanId('1001')
                )
                .SetShodanNaviTorihikis(shodanNaviTorihikis)
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
        @AuraEnabled public List<ShodanNaviTorihiki> shodanNaviTorihikis {
            get { 
                if(this.shodanNaviTorihikis == null) this.shodanNaviTorihikis = new List<ShodanNaviTorihiki>();
                return this.shodanNaviTorihikis; 
            }
            set { shodanNaviTorihikis = value; }
        }
        public DataContext SetViewContext(ViewContext viewContext){
            this.viewContext = viewContext; return this;
        }
        public DataContext SetShodanNaviTorihikis(List<ShodanNaviTorihiki> shodanNaviTorihikis){
            this.shodanNaviTorihikis = shodanNaviTorihikis;
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
        @AuraEnabled public String currentViewingShodanId {
            get { return currentViewingShodanId; }
            set { currentViewingShodanId = value; }
        }

        public ViewContext SetTorihikiSakiId(String recordId){
            this.torihikisakiId = recordId; return this;
        }
        public ViewContext SetTorihikiShodanId(String recordId){
            this.torihikiShodanId = recordId; return this;
        }
        public ViewContext SetCurrentViewingShodanId(String recordId){
            this.currentViewingShodanId = recordId; return this;
        }
    }

    public class ShodanNaviTorihiki{
        @AuraEnabled public String shodanId {
            get { return shodanId; }
            set { shodanId = value; }
        }
        @AuraEnabled public String shodanBango {
            get { return shodanBango; }
            set { shodanBango = value; }
        }
        @AuraEnabled public String shodanName {
            get { return shodanName; }
            set { shodanName = value; }
        }
        public ShodanNaviTorihiki SetShodanId(String recordId){
            this.shodanId = recordId; return this;
        }
        public ShodanNaviTorihiki SetShodanBango(String shodanBango){
            this.shodanBango = shodanBango; return this;
        }
        public ShodanNaviTorihiki SetShodanName(String shodanName){
            this.shodanName = shodanName; return this;
        }
    }
}