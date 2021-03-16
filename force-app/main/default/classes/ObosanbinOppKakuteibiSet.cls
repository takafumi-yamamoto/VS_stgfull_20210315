public class ObosanbinOppKakuteibiSet {

    public void onOppBeforeUpdate(List<Opportunity> newOppList, Map<ID, Opportunity> oldOppMap){
        
        ID rtObosanbinOpportunity = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Obosanbin').getRecordTypeId();
        for(Opportunity newOpp : newOppList){
            if(newOpp.RecordTypeId == rtObosanbinOpportunity){
                Opportunity oldOpp = oldOppMap.get(newOpp.Id);
                if(oldOpp.StageName != '施行待ち' && 
                    newOpp.StageName == '施行待ち' && 
                    newOpp.KakuteibiSyodan__c == null){
                    newOpp.KakuteibiSyodan__c = system.now();
                }
                else if((newOpp.StageName == '除外' ||
                    newOpp.StageName == '失注' ||
                    newOpp.StageName == 'キャンセル') && 
                    newOpp.KakuteibiSyodan__c != null){
                    newOpp.KakuteibiSyodan__c = null;
                }
            }
        }
	}
	
}