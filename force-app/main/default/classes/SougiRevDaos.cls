public class SougiRevDaos{
    public static ISougiRevDao GetInstance(){
        return new SougiRevDao();
    }

    public interface ISougiRevDao{
        SougiRev__c selectById(Id id);
        List<SougiRev__c> selectByOppIds(List<Id> oppIds);
        Map<Id,SougiRev__c> selectByOppIdsAsMapByOppId(List<Id> oppIds);
        Map<Id,SougiRev__c> listToMapByOppId(List<SougiRev__c> entries);
    }

    public class SougiRevDao Implements ISougiRevDao{
        private String getQueryBody(){
            return 'SELECT Id, OpportunityRef__c From SougiRev__c WHERE Id != null ';
        }
        public SougiRev__c selectById(Id id){
            List<SougiRev__c> theEntities = Database.query(getQueryBody() + 'AND Id = :id');
            if(theEntities.size()>0){
                return theEntities.get(0);
            }
            return null;
        }
        public List<SougiRev__c> selectByOppIds(List<Id> oppIds){
            return Database.query(getQueryBody() + 'AND OpportunityRef__c IN :oppIds');
        }
        public Map<Id,SougiRev__c> selectByOppIdsAsMapByOppId(List<Id> oppIds){
            return listToMapByOppId(this.selectByOppIds(oppIds));
        }
        public Map<Id,SougiRev__c> listToMapByOppId(List<SougiRev__c> entries){
            Map<Id,SougiRev__c> theMap = new Map<Id,SougiRev__c>();
            for(SougiRev__c aItem : entries)
            {
                theMap.put(aItem.OpportunityRef__c, aItem);
            }
            return theMap;
        }
    }
}