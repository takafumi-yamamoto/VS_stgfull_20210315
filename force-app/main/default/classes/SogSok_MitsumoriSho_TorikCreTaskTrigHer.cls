public class SogSok_MitsumoriSho_TorikCreTaskTrigHer {
	private boolean m_isExecuting = false;
	private integer BatchSize = 0;
	public SogSok_MitsumoriSho_TorikCreTaskTrigHer(boolean isExecuting, integer size){
	    m_isExecuting = isExecuting;
	    BatchSize = size;
	}    

    public void OnAfterInsert(List<SogSok_MitsumoriSho_TorikCreTask__c> pNewOnes){
        SogSok_MitsumoriSho_TorikCre.subscriveOnSogSokMitsumoriShoTorikCreTaskAfterInserted(pNewOnes);
    }

	public void OnAfterUpdate(List<SogSok_MitsumoriSho_TorikCreTask__c> pNewOnes, Map<ID, SogSok_MitsumoriSho_TorikCreTask__c> pOldOnes){
        SogSok_MitsumoriSho_TorikCre.subscriveOnSogSokMitsumoriShoTorikCreTaskAfterUpdated(pNewOnes, pOldOnes);
	}  
}