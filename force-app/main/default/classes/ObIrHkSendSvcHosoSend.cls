public class ObIrHkSendSvcHosoSend {

    public class Req{
        @AuraEnabled public String method {get; set;}
        @AuraEnabled public String account_name {get; set;}
        @AuraEnabled public String address {get; set;}
        @AuraEnabled public String opp_id {get; set;}
        @AuraEnabled public String pdf_url {get; set;}
        @AuraEnabled public String pdf_password {get; set;}
    }
    public class Res{
        @AuraEnabled public Boolean isSuccess = false;
    }

    @AuraEnabled 
    public static Res logSendHistoryOnly(Req pReq) {
        try{
            logSendHistory(pReq);
            Res theRes = new Res();
            theRes.isSuccess = true;
            return theRes;
        }catch(Exception ex){
            Loggings.writeLog(
                Loggings.createLogEntry(Loggings.Level.Warn, '20201009-1919', 'ObIrHkSendSvcHosoSend.logSendHistoryOnly')
                .putAttr('ex.getTypeName()', ex.getTypeName() )
                .putAttr('ex.getMessage()', ex.getMessage())
                .putAttr('ex.getLineNumber()', '' + ex.getLineNumber())
                .putAttr('ex.getStackTraceString()', ex.getStackTraceString())
                .putAttr('JSON.serializePretty(pReq)', pReq == null ? '' : JSON.serializePretty(pReq) )
            );
            throw ex;
        }
    }

    private static void logSendHistory(Req pReq) {
        INSERT new ObIrHkSendHist__c(
            send_dt__c = Datetime.now(),
            OppRef__c = pReq.opp_id,
            purpose_kubun__c = '手配報告書送付/葬儀社',
            to_name__c = pReq.account_name,
            to_method__c = pReq.method,
            to_address__c = String.isBlank(pReq.address) ? null : pReq.address.left(200),
            pdf_url__c = pReq.pdf_url,
            pdf_password__c = pReq.pdf_password
        );
    }
}