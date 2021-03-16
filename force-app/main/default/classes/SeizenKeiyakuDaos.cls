public class SeizenKeiyakuDaos{
    public static ISeizenKeiyakuDao GetInstance(){
        return new SeizenKeiyakuDao();
    }

    public interface ISeizenKeiyakuDao{
        SeizenKeiyaku__c selectById(Id id);
        List<SeizenKeiyaku__c> selectByOppIds(List<Id> oppIds);
        Map<Id,SeizenKeiyaku__c> selectByOppIdsAsMapByOppId(List<Id> oppIds);
        Map<Id,SeizenKeiyaku__c> listToMapByOppId(List<SeizenKeiyaku__c> entries);
    }

    public class SeizenKeiyakuDao Implements ISeizenKeiyakuDao{
        private String getQueryBody(){
            return 'SELECT Id, OpportunityRef__c From SeizenKeiyaku__c WHERE Id != null ';
        }
        public SeizenKeiyaku__c selectById(Id id){
            List<SeizenKeiyaku__c> theEntities = Database.query(getQueryBody() + 'AND Id = :id');
            if(theEntities.size()>0){
                return theEntities.get(0);
            }
            return null;
        }
        public List<SeizenKeiyaku__c> selectByOppIds(List<Id> oppIds){
            return Database.query(getQueryBody() + 'AND OpportunityRef__c IN :oppIds');
        }
        public Map<Id,SeizenKeiyaku__c> selectByOppIdsAsMapByOppId(List<Id> oppIds){
            return listToMapByOppId(this.selectByOppIds(oppIds));
        }
        public Map<Id,SeizenKeiyaku__c> listToMapByOppId(List<SeizenKeiyaku__c> entries){
            Map<Id,SeizenKeiyaku__c> theMap = new Map<Id,SeizenKeiyaku__c>();
            for(SeizenKeiyaku__c aItem : entries)
            {
                theMap.put(aItem.OpportunityRef__c, aItem);
            }
            return theMap;
        }
    }
}