public class SogSok_SeikyuSho_TrigHer {
	private boolean m_isExecuting = false;
	private integer BatchSize = 0;
	public SogSok_SeikyuSho_Trigher(boolean isExecuting, integer size){
	    m_isExecuting = isExecuting;
	    BatchSize = size;
	}    

    public void OnAfterInsert(List<SogSok_SeikyuSho__c> pNewOnes){
        SogSok_SeikyuSho_TorikCre.subscriveOnSogSokSeikyuShoAfterInserted(pNewOnes);
    }

	public void OnAfterUpdate(List<SogSok_SeikyuSho__c> pNewOnes, Map<ID, SogSok_SeikyuSho__c> pOldOnes){
        SogSok_SeikyuSho_TorikCre.subscriveOnSogSokSeikyuShoAfterUpdated(pNewOnes, pOldOnes);
	}  
}