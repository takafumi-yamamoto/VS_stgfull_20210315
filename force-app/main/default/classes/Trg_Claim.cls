public with sharing class Trg_Claim {
	
	public Trg_Claim() {}

	public void OnAfterUpdate(List<Claim__c> newList, Map<ID, Claim__c> oldMap){
		List<Id> claimIdList = new List<Id>();
		for(Claim__c c : newList){
			if(c.IsUnlock__c && !oldMap.get(c.Id).IsUnlock__c){
				claimIdList.add(c.Id);
			}
		}

		if(claimIdList.size() > 0){
			ClaimApproval.doUnlock(claimIdList);
		}
	}
}