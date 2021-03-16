public class SogSok_SeikyuSho_TorikTrigHer {
	private boolean m_isExecuting = false;
	private integer BatchSize = 0;
	public SogSok_SeikyuSho_TorikTrigHer(boolean isExecuting, integer size){
	    m_isExecuting = isExecuting;
	    BatchSize = size;
	}  

	public void OnAfterUpdate(List<SogSok_SeikyuSho_Torik__c> pNewOnes, Map<ID, SogSok_SeikyuSho_Torik__c> pOldOnes){
		new SogSok_SeikyuSho_Torikoming().subscriveOnSogSokSeikyuShoTorikAfterUpdated(pNewOnes, pOldOnes);
	}  
}