public class SogSok_SrthIraiSho_TorikCreTaskTrigHer {
	private boolean m_isExecuting = false;
	private integer BatchSize = 0;
	public SogSok_SrthIraiSho_TorikCreTaskTrigHer(boolean isExecuting, integer size){
	    m_isExecuting = isExecuting;
	    BatchSize = size;
	}    

    public void OnAfterInsert(List<SogSok_SrthIraiSho_TorikCreTask__c> pNewOnes){
        SogSok_SrthIraiSho_TorikCre.subscriveOnSogSokSrthIraiShoTorikCreTaskAfterInserted(pNewOnes);
    }

	public void OnAfterUpdate(List<SogSok_SrthIraiSho_TorikCreTask__c> pNewOnes, Map<ID, SogSok_SrthIraiSho_TorikCreTask__c> pOldOnes){
        SogSok_SrthIraiSho_TorikCre.subscriveOnSogSokSrthIraiShoTorikCreTaskAfterUpdated(pNewOnes, pOldOnes);
	}  
}