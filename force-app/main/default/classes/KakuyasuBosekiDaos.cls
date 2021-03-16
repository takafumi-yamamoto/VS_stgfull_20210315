public class KakuyasuBosekiDaos{
    public static IKakuyasuBosekiDao GetInstance(){
        return new KakuyasuBosekiDao();
    }

    public interface IKakuyasuBosekiDao{
        KakuyasuBoseki__c selectById(Id id);
        List<KakuyasuBoseki__c> selectByOppIds(List<Id> oppIds);
        Map<Id,KakuyasuBoseki__c> selectByOppIdsAsMapByOppId(List<Id> oppIds);
        Map<Id,KakuyasuBoseki__c> listToMapByOppId(List<KakuyasuBoseki__c> entries);
    }

    public class KakuyasuBosekiDao Implements IKakuyasuBosekiDao{
        private String getQueryBody(){
            return 'SELECT Id, OpportunityRef__c From KakuyasuBoseki__c WHERE Id != null ';
        }
        public KakuyasuBoseki__c selectById(Id id){
            List<KakuyasuBoseki__c> theEntities = Database.query(getQueryBody() + 'AND Id = :id');
            if(theEntities.size()>0){
                return theEntities.get(0);
            }
            return null;
        }
        public List<KakuyasuBoseki__c> selectByOppIds(List<Id> oppIds){
            return Database.query(getQueryBody() + 'AND OpportunityRef__c IN :oppIds');
        }
        public Map<Id,KakuyasuBoseki__c> selectByOppIdsAsMapByOppId(List<Id> oppIds){
            return listToMapByOppId(this.selectByOppIds(oppIds));
        }
        public Map<Id,KakuyasuBoseki__c> listToMapByOppId(List<KakuyasuBoseki__c> entries){
            Map<Id,KakuyasuBoseki__c> theMap = new Map<Id,KakuyasuBoseki__c>();
            for(KakuyasuBoseki__c aItem : entries)
            {
                theMap.put(aItem.OpportunityRef__c, aItem);
            }
            return theMap;
        }
    }
}