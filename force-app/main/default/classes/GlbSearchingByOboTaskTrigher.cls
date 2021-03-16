public class GlbSearchingByOboTaskTrigher {
	private boolean m_isExecuting = false;
	private integer BatchSize = 0;
	public GlbSearchingByOboTaskTrigher(boolean isExecuting, integer size){
	    m_isExecuting = isExecuting;
	    BatchSize = size;
	}    

    public void OnAfterInsert(List<GlbSearchingByOboTask__c> pNewOnes){
        GlbSearchingByObo.subscriveOnGlbSearchingByOboTaskAfterInserted(pNewOnes);
    }

	public void OnAfterUpdate(List<GlbSearchingByOboTask__c> pNewOnes, Map<ID, GlbSearchingByOboTask__c> pOldOnes){
        GlbSearchingByObo.subscriveOnGlbSearchingByOboTaskAfterUpdated(pNewOnes, pOldOnes);
	}  
}