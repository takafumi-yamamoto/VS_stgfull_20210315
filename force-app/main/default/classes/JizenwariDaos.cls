public class JizenwariDaos{
    public static IJizenwariDao GetInstance(){
        return new JizenwariDao();
    }

    public interface IJizenwariDao{
        Jizenwari__c selectById(Id id);
        List<Jizenwari__c> selectByOppIds(List<Id> oppIds);
        Map<Id,Jizenwari__c> selectByOppIdsAsMapByOppId(List<Id> oppIds);
        Map<Id,Jizenwari__c> listToMapByOppId(List<Jizenwari__c> entries);
    }

    public class JizenwariDao Implements IJizenwariDao{
        private String getQueryBody(){
            return 'SELECT Id, OpportunityRef__c From Jizenwari__c WHERE Id != null ';
        }
        public Jizenwari__c selectById(Id id){
            List<Jizenwari__c> theEntities = Database.query(getQueryBody() + 'AND Id = :id');
            if(theEntities.size()>0){
                return theEntities.get(0);
            }
            return null;
        }
        public List<Jizenwari__c> selectByOppIds(List<Id> oppIds){
            return Database.query(getQueryBody() + 'AND OpportunityRef__c IN :oppIds');
        }
        public Map<Id,Jizenwari__c> selectByOppIdsAsMapByOppId(List<Id> oppIds){
            return listToMapByOppId(this.selectByOppIds(oppIds));
        }
        public Map<Id,Jizenwari__c> listToMapByOppId(List<Jizenwari__c> entries){
            Map<Id,Jizenwari__c> theMap = new Map<Id,Jizenwari__c>();
            for(Jizenwari__c aItem : entries)
            {
                theMap.put(aItem.OpportunityRef__c, aItem);
            }
            return theMap;
        }
    }
}