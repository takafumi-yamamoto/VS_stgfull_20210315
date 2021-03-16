public class SMSDlrMsgHandler implements ISmsDlrHandler {
    private String phoneNumber; 
    private SMSHistory__c smsHist;

    public SMSDlrMsgHandler(SMSHistory__c smsHist) {
        this.smsHist = smsHist;
    }

    public void handle() {
        //キャンペーンでもお坊さん施行でも無い場合 取引先を検索して紐づける。
        
        // 4桁の電話番号
        String phNum = '0'+smsHist.phoneNumber__c.substring(3);

        // マッチする取引先の検索
        List<Account> accountsPhoneNoMatched = [SELECT Id FROM Account WHERE MobilePhoneFormula__c =:phNum];

        // マッチする取引先にDLRを紐づける
        for (Account itrOfAccount : accountsPhoneNoMatched) {
            // TODO check
            // SMSHistory__c historyToBeInserted = smsHist.clone(false, false, false, false);
            // historyToBeInserted.Account__c = itrOfAccount.Id;

            smsHist.Account__c = itrOfAccount.Id;
        }

        insert smsHist;
    }
}