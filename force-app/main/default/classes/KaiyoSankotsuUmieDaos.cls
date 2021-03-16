public class KaiyoSankotsuUmieDaos{
    public static IKaiyoSankotsuUmieDao GetInstance(){
        return new KaiyoSankotsuUmieDao();
    }

    public interface IKaiyoSankotsuUmieDao{
        KaiyoSankotsuUmie__c selectById(Id id);
        List<KaiyoSankotsuUmie__c> selectByOppIds(List<Id> oppIds);
        Map<Id,KaiyoSankotsuUmie__c> selectByOppIdsAsMapByOppId(List<Id> oppIds);
        Map<Id,KaiyoSankotsuUmie__c> listToMapByOppId(List<KaiyoSankotsuUmie__c> entries);
    }

    public class KaiyoSankotsuUmieDao Implements IKaiyoSankotsuUmieDao{
        private String getQueryBody(){
            return 'SELECT Id, OpportunityRef__c From KaiyoSankotsuUmie__c WHERE Id != null ';
        }
        public KaiyoSankotsuUmie__c selectById(Id id){
            List<KaiyoSankotsuUmie__c> theEntities = Database.query(getQueryBody() + 'AND Id = :id');
            if(theEntities.size()>0){
                return theEntities.get(0);
            }
            return null;
        }
        public List<KaiyoSankotsuUmie__c> selectByOppIds(List<Id> oppIds){
            return Database.query(getQueryBody() + 'AND OpportunityRef__c IN :oppIds');
        }
        public Map<Id,KaiyoSankotsuUmie__c> selectByOppIdsAsMapByOppId(List<Id> oppIds){
            return listToMapByOppId(this.selectByOppIds(oppIds));
        }
        public Map<Id,KaiyoSankotsuUmie__c> listToMapByOppId(List<KaiyoSankotsuUmie__c> entries){
            Map<Id,KaiyoSankotsuUmie__c> theMap = new Map<Id,KaiyoSankotsuUmie__c>();
            for(KaiyoSankotsuUmie__c aItem : entries)
            {
                theMap.put(aItem.OpportunityRef__c, aItem);
            }
            return theMap;
        }
    }
}