public class Trg_PartnerSeikyuSendHistory {

    private boolean m_isExecuting = false;
    private integer BatchSize = 0;

    public Trg_PartnerSeikyuSendHistory(boolean isExecuting, integer size){
        m_isExecuting = isExecuting;
        BatchSize = size;
    }

    public void OnAfterInsert(List<PartnerSeikyuSendHistory__c> newList){     
        new SgSeikyuFaxSendCatterNotification().sgSeikyuFaxSendReqCatterNotification(newList);
	}

	public void OnAfterUpdate(List<PartnerSeikyuSendHistory__c> newList, Map<ID, PartnerSeikyuSendHistory__c> oldMap){     
        new SgSeikyuFaxSendCatterNotification().sgSeikyuFaxSendRsltCatterNotification(newList);
	}
}