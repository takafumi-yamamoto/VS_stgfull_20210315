public class SogSok_SrthIraiSho_TorikTrigHer {
	private boolean m_isExecuting = false;
	private integer BatchSize = 0;
	public SogSok_SrthIraiSho_TorikTrigHer(boolean isExecuting, integer size){
	    m_isExecuting = isExecuting;
	    BatchSize = size;
	}  

	public void OnBeforeUpdate(List<SogSok_SrthIraiSho_Torik__c> pNewOnes, Map<ID, SogSok_SrthIraiSho_Torik__c> pNewMap, Map<ID, SogSok_SrthIraiSho_Torik__c> pOldOnes){
		new SogSok_SrthIraiSho_Torikoming().subscriveOnSogSokSrthIraiShoTorikBeforeUpdated(pNewOnes, pNewMap, pOldOnes);
	}  
}