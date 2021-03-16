public class SogSok_MitsumoriSho_TorikTrigHer {
	private boolean m_isExecuting = false;
	private integer BatchSize = 0;
	public SogSok_MitsumoriSho_TorikTrigHer(boolean isExecuting, integer size){
	    m_isExecuting = isExecuting;
	    BatchSize = size;
	}  

	public void OnAfterUpdate(List<SogSok_MitsumoriSho_Torik__c> pNewOnes, Map<ID, SogSok_MitsumoriSho_Torik__c> pOldOnes){
		new SogSok_MitsumoriSho_Torikoming().subscriveOnSogSokMitsumoriShoTorikAfterUpdated(pNewOnes, pOldOnes);
	}  
}