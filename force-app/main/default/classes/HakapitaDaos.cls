public class HakapitaDaos{
    public static IHakapitaDao GetInstance(){
        return new HakapitaDao();
    }

    public interface IHakapitaDao{
        Hakapita__c selectById(Id id);
        List<Hakapita__c> selectByOppIds(List<Id> oppIds);
        Map<Id,Hakapita__c> selectByOppIdsAsMapByOppId(List<Id> oppIds);
        Map<Id,Hakapita__c> listToMapByOppId(List<Hakapita__c> entries);
    }

    public class HakapitaDao Implements IHakapitaDao{
        private String getQueryBody(){
            return 'SELECT Id, OpportunityRef__c From Hakapita__c WHERE Id != null ';
        }
        public Hakapita__c selectById(Id id){
            List<Hakapita__c> theEntities = Database.query(getQueryBody() + 'AND Id = :id');
            if(theEntities.size()>0){
                return theEntities.get(0);
            }
            return null;
        }
        public List<Hakapita__c> selectByOppIds(List<Id> oppIds){
            return Database.query(getQueryBody() + 'AND OpportunityRef__c IN :oppIds');
        }
        public Map<Id,Hakapita__c> selectByOppIdsAsMapByOppId(List<Id> oppIds){
            return listToMapByOppId(this.selectByOppIds(oppIds));
        }
        public Map<Id,Hakapita__c> listToMapByOppId(List<Hakapita__c> entries){
            Map<Id,Hakapita__c> theMap = new Map<Id,Hakapita__c>();
            for(Hakapita__c aItem : entries)
            {
                theMap.put(aItem.OpportunityRef__c, aItem);
            }
            return theMap;
        }
    }
}