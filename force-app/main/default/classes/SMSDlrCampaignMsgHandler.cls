public class SMSDlrCampaignMsgHandler implements ISmsDlrHandler{
/**
    private String pKey;
    private String negotiationID;
    private SMSHistory__c smsHist;

    public SMSDlrCampaignMsgHandler(SMSHistory__c smsHist, String pKey, String negotiationID) {
        this.smsHist = smsHist;
        this.pKey = pKey;
        this.negotiationID = negotiationID;
    }

    public void handle() {
        List<Account> accounts = [SELECT Id FROM Account WHERE Pkey__c =:pKey];
        if(accounts.size() > 0){
            smsHist.Account__c = accounts[0].Id;
        }

        smsHist.NegotiationID__c = negotiationID;
        List<Opportunity> opportunities = [SELECT Id FROM Opportunity WHERE NegotiationID__c =: smsHist.NegotiationID__c];
        if(opportunities.size() > 0){
            smsHist.OppId__c = opportunities[0].Id;
            smsHist.Opportunity__c = opportunities[0].Id;
        }

        insert smsHist;
    }
*/
}