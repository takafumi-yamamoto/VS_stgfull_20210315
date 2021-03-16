public class ClaimApproval {
	
	@future
	public static void doUnlock(List<Id> claimIdList){
		List<Claim__c> claimList = [select Id from Claim__c where Id in :claimIdList];
		Approval.unlock(claimIdList, false);
	}
}