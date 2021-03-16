public class ShodanShohinNaviTorihikiCtxResolvers{
	/*

    public class TorihikiCtx{
        public String torihikiSakiId { get; private set; }
        public TorihikiCtx SetTorihikiSakiId(String value){
            this.torihikiSakiId = value; return this;
        }
        public String torihikiShodanId { get; private set; }
        public TorihikiCtx SetTorihikiShodanId(String value){
            this.torihikiShodanId = value; return this;
        }
    }

    public static ITorihikiCtxResolver GetResolver(String recordId){
        ITorihikiCtxResolver theResolver = null;
        String objectTypeName = SobjectsExtension.GetObjectApiNameById(recordId);
        theResolver = (objectTypeName == 'Opportunity' 
            ? new TorihikiCtxResolverOnOpportunity(new OpportunityDao(),RecordTypeCachedDao.GetInstance()) 
            : theResolver);
        //theResolver = (objectTypeName == 'Case' ? new TorihikiCtxResolverOnCase() : theResolver);
        return theResolver;
        return null;
    }

    public interface ITorihikiCtxResolver{
        TorihikiCtx ResolveTorihikiCtx(String recordId);
    }
    
    public class TorihikiCtxResolverOnOpportunity Implements ITorihikiCtxResolver{
        private OpportunityDao f_OpportunityDao;
        private RecordTypeCachedDao f_RecordTypeCachedDao;

        public TorihikiCtxResolverOnOpportunity(
            OpportunityDao opportunityDao,
            RecordTypeCachedDao recordTypeCachedDao){
            f_OpportunityDao = opportunityDao;
            f_RecordTypeCachedDao = recordTypeCachedDao;
        }
        public TorihikiCtx ResolveTorihikiCtx(String recordId){
            Opportunity theOpp = f_OpportunityDao.SelectById(recordId);
            TorihikiCtx theCtx = new TorihikiCtx().SetTorihikiSakiId(theOpp.AccountId);
            String recordTypeApiName = this.f_RecordTypeCachedDao.SelectDeveloperNameById(theOpp.RecordTypeId);
            theCtx = theCtx.SetTorihikiShodanId(
                recordTypeApiName == 'TorihikiShodan' ? theOpp.Id : theOpp.TorihikiShodanRef__c
                );
            return theCtx;
        }
    }*/
    /*public class TorihikiCtxResolverOnCase Implements ITorihikiCtxResolver{
        public TorihikiCtx ResolveTorihikiCtx(String recordId){
            return new TorihikiCtx()
                .SetTorihikiSakiId('torihikisakiId')
                .SetTorihikiShodanId('torihikiShodanId');
        }
    }*/
}