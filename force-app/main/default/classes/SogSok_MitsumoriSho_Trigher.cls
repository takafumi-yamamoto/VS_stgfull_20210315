public class SogSok_MitsumoriSho_Trigher {
	private boolean m_isExecuting = false;
	private integer BatchSize = 0;
	public SogSok_MitsumoriSho_Trigher(boolean isExecuting, integer size){
	    m_isExecuting = isExecuting;
	    BatchSize = size;
	}    

    public void OnAfterInsert(List<SogSok_MitsumoriSho__c> pNewOnes){
        SogSok_MitsumoriSho_TorikCre.subscriveOnSogSokMitsumoriShoAfterInserted(pNewOnes);
    }

	public void OnAfterUpdate(List<SogSok_MitsumoriSho__c> pNewOnes, Map<ID, SogSok_MitsumoriSho__c> pOldOnes){
        SogSok_MitsumoriSho_TorikCre.subscriveOnSogSokMitsumoriShoAfterUpdated(pNewOnes, pOldOnes);
	}  
}