public class StageNameShicchu {
	
	private static String OPP_RECORDTYPE_ID_SIMPLEYASUGO = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId();

	public void onOpportunityBeforeUpdate(List<Opportunity> pNewOnes, Map<Id, Opportunity> oldMap){

		List<Opportunity> ListOpp = New List<Opportunity>();
		
		for(Opportunity aNewOne : pNewOnes){
			if(aNewOne.RecordTypeId == OPP_RECORDTYPE_ID_SIMPLEYASUGO){
				Opportunity chkOpp = oldMap.get(aNewOne.ID);
				if((aNewOne.StageName != chkOpp.StageName)){
					ListOpp.add(aNewOne);
				}
			}
		}
		SetShicchuKakuteibiSyodanSimpleShodan(ListOpp);
	}

	public void SetShicchuKakuteibiSyodanSimpleShodan(List<Opportunity> pNewOnes){
		for(Opportunity aNewOne : pNewOnes){
			if(aNewOne.StageName == '失注'){
				aNewOne.ShicchuKakuteibiSyodan__c = system.now();
			}else{
				aNewOne.ShicchuKakuteibiSyodan__c = null;
			}
		}
	}
}