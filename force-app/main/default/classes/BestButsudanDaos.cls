public class BestButsudanDaos{
    public static IBestButsudanDao GetInstance(){
        return new BestButsudanDao();
    }

    public interface IBestButsudanDao{
        BestButsudan__c selectById(Id id);
        List<BestButsudan__c> selectByOppIds(List<Id> oppIds);
        Map<Id,BestButsudan__c> selectByOppIdsAsMapByOppId(List<Id> oppIds);
        Map<Id,BestButsudan__c> listToMapByOppId(List<BestButsudan__c> entries);
    }

    public class BestButsudanDao Implements IBestButsudanDao{
        private String getQueryBody(){
            return 'SELECT Id, OpportunityRef__c From BestButsudan__c WHERE Id != null ';
        }
        public BestButsudan__c selectById(Id id){
            List<BestButsudan__c> theEntities = Database.query(getQueryBody() + 'AND Id = :id');
            if(theEntities.size()>0){
                return theEntities.get(0);
            }
            return null;
        }
        public List<BestButsudan__c> selectByOppIds(List<Id> oppIds){
            return Database.query(getQueryBody() + 'AND OpportunityRef__c IN :oppIds');
        }
        public Map<Id,BestButsudan__c> selectByOppIdsAsMapByOppId(List<Id> oppIds){
            return listToMapByOppId(this.selectByOppIds(oppIds));
        }
        public Map<Id,BestButsudan__c> listToMapByOppId(List<BestButsudan__c> entries){
            Map<Id,BestButsudan__c> theMap = new Map<Id,BestButsudan__c>();
            for(BestButsudan__c aItem : entries)
            {
                theMap.put(aItem.OpportunityRef__c, aItem);
            }
            return theMap;
        }
    }
}