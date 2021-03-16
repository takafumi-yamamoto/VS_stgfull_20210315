public class KeirDenVerTrigher {
	private boolean m_isExecuting = false;
	private integer BatchSize = 0;
	public KeirDenVerTrigher(boolean isExecuting, integer size){
	    m_isExecuting = isExecuting;
	    BatchSize = size;
	}

	public void onBeforeInsert(List<KeirDenVer__c> pNewOnes){
		for(KeirDenVer__c aNewOne : pNewOnes){
			if( aNewOne.VersionToBeRenewed__c == null ) aNewOne.VersionToBeRenewed__c = KeirDenVers.genNewVerNo();
			if( aNewOne.VersionLastRenewed__c == null ) aNewOne.VersionLastRenewed__c = '0';
			aNewOne.ToBeRenewed__c = aNewOne.VersionToBeRenewed__c > aNewOne.VersionLastRenewed__c;
		}
	}

	public void onBeforeUpdate(List<KeirDenVer__c> pNewOnes, Map<ID, KeirDenVer__c> pOldOnes){
		for(KeirDenVer__c aNewOne : pNewOnes){
			if( aNewOne.VersionToBeRenewed__c == null ) aNewOne.VersionToBeRenewed__c = KeirDenVers.genNewVerNo();
			if( aNewOne.VersionLastRenewed__c == null ) aNewOne.VersionLastRenewed__c = '0';
			aNewOne.ToBeRenewed__c = aNewOne.VersionToBeRenewed__c > aNewOne.VersionLastRenewed__c;
		}
	}
}