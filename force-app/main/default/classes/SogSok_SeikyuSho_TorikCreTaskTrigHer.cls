public class SogSok_SeikyuSho_TorikCreTaskTrigHer {
	private boolean m_isExecuting = false;
	private integer BatchSize = 0;
	public SogSok_SeikyuSho_TorikCreTaskTrigHer(boolean isExecuting, integer size){
	    m_isExecuting = isExecuting;
	    BatchSize = size;
	}    

    public void OnAfterInsert(List<SogSok_SeikyuSho_TorikCreTask__c> pNewOnes){
        SogSok_SeikyuSho_TorikCre.subscriveOnSogSokSeikyuShoTorikCreTaskAfterInserted(pNewOnes);
    }

	public void OnAfterUpdate(List<SogSok_SeikyuSho_TorikCreTask__c> pNewOnes, Map<ID, SogSok_SeikyuSho_TorikCreTask__c> pOldOnes){
        SogSok_SeikyuSho_TorikCre.subscriveOnSogSokSeikyuShoTorikCreTaskAfterUpdated(pNewOnes, pOldOnes);
	}  
}