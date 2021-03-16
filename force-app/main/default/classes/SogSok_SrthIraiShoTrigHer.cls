public class SogSok_SrthIraiShoTrigHer {
	private boolean m_isExecuting = false;
	private integer BatchSize = 0;
	public SogSok_SrthIraiShoTrigHer(boolean isExecuting, integer size){
	    m_isExecuting = isExecuting;
	    BatchSize = size;
	}    

    public void OnAfterInsert(List<SogSok_SrthIraiSho__c> pNewOnes){
        SogSok_SrthIraiSho_TorikCre.subscriveOnSogSokSrthIraiShoAfterInserted(pNewOnes);
    }

	public void OnAfterUpdate(List<SogSok_SrthIraiSho__c> pNewOnes, Map<ID, SogSok_SrthIraiSho__c> pOldOnes){
        SogSok_SrthIraiSho_TorikCre.subscriveOnSogSokSrthIraiShoAfterUpdated(pNewOnes, pOldOnes);
	}  
}