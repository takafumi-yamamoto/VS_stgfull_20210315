public class ObousanbinDaos{
    public static IObousanbinDao GetInstance(){
        return new ObousanbinDao();
    }

    public interface IObousanbinDao{
        Obosanbin__c selectById(Id id);
        List<Obosanbin__c> selectByOppIds(List<Id> oppIds);
        Map<Id,Obosanbin__c> selectByOppIdsAsMapByOppId(List<Id> oppIds);
        Map<Id,Obosanbin__c> listToMapByOppId(List<Obosanbin__c> entries);
    }

    public class ObousanbinDao Implements IObousanbinDao{
        private String getQueryBody(){
            return 'SELECT Id, OpportunityRef__c, YoyakuUketsukebi__c From Obosanbin__c WHERE Id != null ';
        }
        public Obosanbin__c selectById(Id id){
            List<Obosanbin__c> theEntities = Database.query(getQueryBody() + 'AND Id = :id');
            if(theEntities.size()>0){
                return theEntities.get(0);
            }
            return null;
        }
        public List<Obosanbin__c> selectByOppIds(List<Id> oppIds){
            return Database.query(getQueryBody() + 'AND OpportunityRef__c IN :oppIds');
        }
        public Map<Id,Obosanbin__c> selectByOppIdsAsMapByOppId(List<Id> oppIds){
            return listToMapByOppId(this.selectByOppIds(oppIds));
        }
        public Map<Id,Obosanbin__c> listToMapByOppId(List<Obosanbin__c> entries){
            Map<Id,Obosanbin__c> theMap = new Map<Id,Obosanbin__c>();
            for(Obosanbin__c aItem : entries)
            {
                theMap.put(aItem.OpportunityRef__c, aItem);
            }
            return theMap;
        }
    }
}