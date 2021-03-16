public class OboKeirDenTrigher {
	private boolean m_isExecuting = false;
	private integer BatchSize = 0;
	public OboKeirDenTrigher(boolean isExecuting, integer size){
	    m_isExecuting = isExecuting;
	    BatchSize = size;
	}

	public void onBeforeInsert(List<OboKeirDen__c> pNewOnes){
		for(OboKeirDen__c aNewOne : pNewOnes){
			if( aNewOne.LastVersion__c == null ) aNewOne.LastVersion__c = '0';
			if( aNewOne.LastSyncVersion__c == null ) aNewOne.LastSyncVersion__c = '0';
			aNewOne.ToBeSync__c = aNewOne.LastVersion__c > aNewOne.LastSyncVersion__c;
		}
	}

	public void onBeforeUpdate(List<OboKeirDen__c> pNewOnes, Map<ID, OboKeirDen__c> pOldOnes){
		for(OboKeirDen__c aNewOne : pNewOnes){
			if( aNewOne.LastVersion__c == null ) aNewOne.LastVersion__c = '0';
			if( aNewOne.LastSyncVersion__c == null ) aNewOne.LastSyncVersion__c = '0';
			aNewOne.ToBeSync__c = aNewOne.LastVersion__c > aNewOne.LastSyncVersion__c;
		}
	}
}