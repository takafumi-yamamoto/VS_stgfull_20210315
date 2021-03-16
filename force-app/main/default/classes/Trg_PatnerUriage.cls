public class Trg_PatnerUriage{

	private boolean m_isExecuting = false;
    	private integer BatchSize = 0;

	public Trg_PatnerUriage(boolean isExecuting, integer size){
	m_isExecuting = isExecuting;
	BatchSize = size;
	}

	public void OnBeforeInsert(List<PatnerUriage__c> newOnes){
        KeirSimeLocks.onPatnerUriageBeforeInsert(newOnes);
	}
	public void OnBeforeUpdate(List<PatnerUriage__c> newOnes, Map<ID, PatnerUriage__c> oldOnes){
        KeirSimeLocks.onPatnerUriageBeforeUpdate(newOnes,oldOnes);
	}
	public void OnBeforeDelete(List<PatnerUriage__c> oldOnes){
        KeirSimeLocks.onPatnerUriageBeforeDelete(oldOnes);
	}

    public void OnAfterInsert(List<PatnerUriage__c> newOnes){
        this.get_ISogiShiharaitsuchisyo_instance().updateShiharaitsuchisyo(newOnes);
    }
    public void OnAfterUpdate(List<PatnerUriage__c> newOnes, Map<ID, PatnerUriage__c> oldOnes){
        this.get_ISogiShiharaitsuchisyo_instance().updateShiharaitsuchisyo(newOnes);
    }

	public void OnAfterDelete(List<PatnerUriage__c> oldOnes){
        this.get_ISogiShiharaitsuchisyo_instance().updateShiharaitsuchisyo(oldOnes);
	}

    @TestVisible
    private static SogiShiharaitsuchisyo.ISogiShiharaitsuchisyo m_ISogiShiharaitsuchisyo_instance;
    private SogiShiharaitsuchisyo.ISogiShiharaitsuchisyo get_ISogiShiharaitsuchisyo_instance(){
        if(m_ISogiShiharaitsuchisyo_instance == null){ m_ISogiShiharaitsuchisyo_instance = new SogiShiharaitsuchisyo(); }
        return m_ISogiShiharaitsuchisyo_instance;
    }
}