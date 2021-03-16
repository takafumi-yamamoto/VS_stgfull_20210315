public class Trg_BestButsudan {
    
	public void onAfterUpdate(List<BestButsudan__c> newOnes, Map<ID, BestButsudan__c> oldOnes){
		new Ctl_BestButsudan_UriageDate().onBestButsudanAfterUpdate(newOnes, oldOnes);
		new OpShTxBestQms.Queuing().onBestAfterUpdate(newOnes, oldOnes);
	}
	
}