public class UchusoSoraeDaos{
    public static IUchusoSoraeDao GetInstance(){
        return new UchusoSoraeDao();
    }

    public interface IUchusoSoraeDao{
        UchusoSorae__c selectById(Id id);
        List<UchusoSorae__c> selectByOppIds(List<Id> oppIds);
        Map<Id,UchusoSorae__c> selectByOppIdsAsMapByOppId(List<Id> oppIds);
        Map<Id,UchusoSorae__c> listToMapByOppId(List<UchusoSorae__c> entries);
    }

    public class UchusoSoraeDao Implements IUchusoSoraeDao{
        private String getQueryBody(){
            return 'SELECT Id, OpportunityRef__c From UchusoSorae__c WHERE Id != null ';
        }
        public UchusoSorae__c selectById(Id id){
            List<UchusoSorae__c> theEntities = Database.query(getQueryBody() + 'AND Id = :id');
            if(theEntities.size()>0){
                return theEntities.get(0);
            }
            return null;
        }
        public List<UchusoSorae__c> selectByOppIds(List<Id> oppIds){
            return Database.query(getQueryBody() + 'AND OpportunityRef__c IN :oppIds');
        }
        public Map<Id,UchusoSorae__c> selectByOppIdsAsMapByOppId(List<Id> oppIds){
            return listToMapByOppId(this.selectByOppIds(oppIds));
        }
        public Map<Id,UchusoSorae__c> listToMapByOppId(List<UchusoSorae__c> entries){
            Map<Id,UchusoSorae__c> theMap = new Map<Id,UchusoSorae__c>();
            for(UchusoSorae__c aItem : entries)
            {
                theMap.put(aItem.OpportunityRef__c, aItem);
            }
            return theMap;
        }
    }
}