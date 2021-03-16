public class ShodanNavigaterTorihikiSakiResolvers{

   /* public static ITorihikiSakiResolver GetResolver(String recordId){
        ITorihikiSakiResolver theResolver = null;
        String objectTypeName = SobjectsExtension.GetObjectApiNameById(recordId);
        theResolver = (objectTypeName == 'Opportunity' 
            ? new TorihikisakiResolverOnOpportunity(new OpportunityDao(),RecordTypeCachedDao.GetInstance()) 
            : theResolver);
        theResolver = (objectTypeName == 'Case' ? new TorihikisakiResolverOnCase() : theResolver);
        return theResolver;
    }

    public interface ITorihikiSakiResolver{
        String ResolveTorihikiSakiId(String recordId);
        String ResolveTorihikiShodanId(String recordId);
    }
    public class TorihikisakiResolverOnOpportunity Implements ITorihikiSakiResolver{
        private OpportunityDao f_OpportunityDao;
        private RecordTypeCachedDao f_RecordTypeCachedDao;

        public TorihikisakiResolverOnOpportunity(
            OpportunityDao opportunityDao,
            RecordTypeCachedDao recordTypeCachedDao){
            f_OpportunityDao = opportunityDao;
            f_RecordTypeCachedDao = recordTypeCachedDao;
        }
        public String ResolveTorihikiSakiId(String recordId){
            Opportunity theOpp = f_OpportunityDao.SelectById(recordId);
            return (theOpp == null ? '' : theOpp.AccountId);
        }
        public String ResolveTorihikiShodanId(String recordId){
            String recordTypeApiName = this.f_RecordTypeCachedDao.SelectDeveloperNameById(recordId);
            if(recordTypeApiName == 'TorihikiShodan') return recordId;
            Opportunity theOpp = f_OpportunityDao.SelectById(recordId);
            return theOpp.TorihikiShodanRef__c;
        }
    }
    public class TorihikisakiResolverOnCase Implements ITorihikiSakiResolver{
        public String ResolveTorihikiSakiId(String recordId){
            return 'torihikisakiId';
        }
        public String ResolveTorihikiShodanId(String recordId){
            return 'torihikiShodanId';
        }
    }*/
}