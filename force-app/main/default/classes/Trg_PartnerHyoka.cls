public class Trg_PartnerHyoka 
{	
    private boolean m_isExecuting = false;
    private integer BatchSize = 0;

    public Trg_PartnerHyoka(boolean isExecuting, integer size){
        m_isExecuting = isExecuting;
        BatchSize = size;
    }

	public void OnAfterUpdate(List<PartnerHyoka__c> newList, Map<ID, PartnerHyoka__c> oldMap){     
        new OboStSynVer().OnPartnerHyokaAfterUpdate(newList, oldMap);
	}
}