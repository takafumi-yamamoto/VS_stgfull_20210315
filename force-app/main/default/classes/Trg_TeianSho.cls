public class Trg_TeianSho {
	private boolean m_isExecuting = false;
	private integer BatchSize = 0;
	public Trg_TeianSho(boolean isExecuting, integer size){
	    m_isExecuting = isExecuting;
	    BatchSize = size;
	}

	public void OnBeforeInsert(List<TeianSho__c> newOnes){
        TeianshoValidation.validate(newOnes);
	}
	public void OnBeforeUpdate(List<TeianSho__c> newOnes,  Map<Id,TeianSho__c> oldOnes){
        TeianshoValidation.validate(newOnes);
	}

    public void OnBeforeDelete(List<TeianSho__c> oldOnes){
        TeianshoValidation.validate(oldOnes);
	}
}