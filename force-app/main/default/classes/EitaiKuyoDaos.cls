public class EitaiKuyoDaos{
    public static IEitaiKuyoDao GetInstance(){
        return new EitaiKuyoDao();
    }

    public interface IEitaiKuyoDao{
        EitaiKuyo__c selectById(Id id);
        List<EitaiKuyo__c> selectByOppIds(List<Id> oppIds);
        Map<Id,EitaiKuyo__c> selectByOppIdsAsMapByOppId(List<Id> oppIds);
        Map<Id,EitaiKuyo__c> listToMapByOppId(List<EitaiKuyo__c> entries);
    }

    public class EitaiKuyoDao Implements IEitaiKuyoDao{
        private String getQueryBody(){
            return 'SELECT Id, OpportunityRef__c From EitaiKuyo__c WHERE Id != null ';
        }
        public EitaiKuyo__c selectById(Id id){
            List<EitaiKuyo__c> theEntities = Database.query(getQueryBody() + 'AND Id = :id');
            if(theEntities.size()>0){
                return theEntities.get(0);
            }
            return null;
        }
        public List<EitaiKuyo__c> selectByOppIds(List<Id> oppIds){
            return Database.query(getQueryBody() + 'AND OpportunityRef__c IN :oppIds');
        }
        public Map<Id,EitaiKuyo__c> selectByOppIdsAsMapByOppId(List<Id> oppIds){
            return listToMapByOppId(this.selectByOppIds(oppIds));
        }
        public Map<Id,EitaiKuyo__c> listToMapByOppId(List<EitaiKuyo__c> entries){
            Map<Id,EitaiKuyo__c> theMap = new Map<Id,EitaiKuyo__c>();
            for(EitaiKuyo__c aItem : entries)
            {
                theMap.put(aItem.OpportunityRef__c, aItem);
            }
            return theMap;
        }
    }
}