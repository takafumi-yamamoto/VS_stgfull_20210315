public class KyokaHaitatsuRevDaos{
    public static IKyokaHaitatsuRevDao GetInstance(){
        return new KyokaHaitatsuRevDao();
    }

    public interface IKyokaHaitatsuRevDao{
        KyokaHaitatsuRev__c selectById(Id id);
        List<KyokaHaitatsuRev__c> selectByOppIds(List<Id> oppIds);
        Map<Id,KyokaHaitatsuRev__c> selectByOppIdsAsMapByOppId(List<Id> oppIds);
        Map<Id,KyokaHaitatsuRev__c> listToMapByOppId(List<KyokaHaitatsuRev__c> entries);
    }

    public class KyokaHaitatsuRevDao Implements IKyokaHaitatsuRevDao{
        private String getQueryBody(){
            return 'SELECT Id, OpportunityRef__c From KyokaHaitatsuRev__c WHERE Id != null ';
        }
        public KyokaHaitatsuRev__c selectById(Id id){
            List<KyokaHaitatsuRev__c> theEntities = Database.query(getQueryBody() + 'AND Id = :id');
            if(theEntities.size()>0){
                return theEntities.get(0);
            }
            return null;
        }
        public List<KyokaHaitatsuRev__c> selectByOppIds(List<Id> oppIds){
            return Database.query(getQueryBody() + 'AND OpportunityRef__c IN :oppIds');
        }
        public Map<Id,KyokaHaitatsuRev__c> selectByOppIdsAsMapByOppId(List<Id> oppIds){
            return listToMapByOppId(this.selectByOppIds(oppIds));
        }
        public Map<Id,KyokaHaitatsuRev__c> listToMapByOppId(List<KyokaHaitatsuRev__c> entries){
            Map<Id,KyokaHaitatsuRev__c> theMap = new Map<Id,KyokaHaitatsuRev__c>();
            for(KyokaHaitatsuRev__c aItem : entries)
            {
                theMap.put(aItem.OpportunityRef__c, aItem);
            }
            return theMap;
        }
    }
}