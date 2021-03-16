public class NpTorihikiDataImpTaskTrigher {
	
	private boolean m_isExecuting = false;
	private integer BatchSize = 0;
	public NpTorihikiDataImpTaskTrigher(boolean isExecuting, integer size){
	    m_isExecuting = isExecuting;
	    BatchSize = size;
	}    

    public void onAfterInsert(List<NpTorihikiDataImpTask__c> pNewOnes){
        NpTorihikiDataImpTasks.onNpTorihikiDataImpTaskAfterInserted(pNewOnes);
    }

	public void onAfterUpdate(List<NpTorihikiDataImpTask__c> pNewOnes, Map<ID, NpTorihikiDataImpTask__c> pOldOnes){
        NpTorihikiDataImpTasks.onNpTorihikiDataImpTaskAfterUpdated(pNewOnes, pOldOnes);
	}  
}