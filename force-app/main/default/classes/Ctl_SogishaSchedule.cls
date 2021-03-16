public class Ctl_SogishaSchedule {

    public void onBeforeInsert(List<SogishaSchedule__c> newList) {
        initialProcessing(newList, null);
    }

    public void onBeforeUpdate(List<SogishaSchedule__c> newList, Map<Id, SogishaSchedule__c> oldMap) {
        initialProcessing(newList, oldMap);
    }

    private void initialProcessing(List<SogishaSchedule__c> newList, Map<Id, SogishaSchedule__c> oldMap){

        Set<Id> sogishaIdSet = new Set<Id>();
        for(SogishaSchedule__c ss : newList){
            if(oldMap == null || ss.Sogisha__c != oldMap.get(ss.Id).Sogisha__c){
                sogishaIdSet.add(ss.Sogisha__c);
            }
        }

        Map<Id, Account> accountMap = new Map<Id, Account>([select Id, (select Id from KeiyakusTeikeisaki__r where Recordtype.DeveloperName = 'SimpleYasugo' order by Keiyakukaishibi__c desc) from Account where Id = :sogishaIdSet]);
        for(SogishaSchedule__c ss : newList){
            if(accountMap.containsKey(ss.Sogisha__c)){
                Account accTemp = accountMap.get(ss.Sogisha__c);
                if(accTemp.KeiyakusTeikeisaki__r.size() > 0){
                    ss.SimpleYasugoKeiyaku__c = accTemp.KeiyakusTeikeisaki__r.get(0).Id;
                }
            }
        }
    }
}