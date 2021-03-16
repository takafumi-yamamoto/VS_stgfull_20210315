public class ObIrHkSendSvcHokoSend {

    @TestVisible
    private static ObHokoMl.IObHokoMl mObHokoMl = new ObHokoMl( new ObHokoMl.OppDataPvdr() );

    @TestVisible
    private static ObHokoSm.IObHokoSm mObHokoSm = new ObHokoSm( new ObHokoSm.OppDataPvdr() );

    @TestVisible
    private static AcrtSmsSender.IClient mAcrtSmsSenderClient = AcrtSmsSender.getClient();

    @TestVisible
    private static AcrtDrTackRegister.IRegister mAcrtDrTackRegister = new AcrtDrTackRegister.Register();

    @TestVisible
    private static AcrtSmsSendHistLogr.IAcrtSmsSendHistLogr mIAcrtSmsSendHistLogr = AcrtSmsSendHistLogr.get_IAcrtSmsSendHistLogr_instance();

    public class Req{
        @AuraEnabled public String method {get; set;}
        @AuraEnabled public String account_id {get; set;}
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
    public static Res sendHokokushoMessage(Req pReq) {
        try{
            return run_sendHokokushoMessage(pReq);
        }catch(Exception ex){
            Loggings.writeLog(
                Loggings.createLogEntry(Loggings.Level.Warn, '20200828-1818', 'ObIrHkSendSvcHokoSend.sendHokokushoMessage')
                .putAttr('ex.getTypeName()', ex.getTypeName() )
                .putAttr('ex.getMessage()', ex.getMessage())
                .putAttr('ex.getLineNumber()', '' + ex.getLineNumber())
                .putAttr('ex.getStackTraceString()', ex.getStackTraceString())
                .putAttr('JSON.serializePretty(pReq)', pReq == null ? '' : JSON.serializePretty(pReq) )
            );
            throw ex;
        }
    }

    private static Res run_sendHokokushoMessage(Req pReq) {

        if(pReq.method == 'mail'){
            ObHokoMl.Req theReq = new ObHokoMl.Req();
            theReq.account_id = pReq.account_id;
            theReq.account_name = pReq.account_name;
            theReq.mailaddress = pReq.address;
            theReq.opp_id = pReq.opp_id;
            theReq.pdf_url = pReq.pdf_url;
            theReq.pdf_password =pReq.pdf_password;

            MailAlert__c theMailAlert = mObHokoMl.createMail(theReq);
            INSERT theMailAlert;
        }

        if(pReq.method == 'sms'){
            ObHokoSm.Req theReq = new ObHokoSm.Req();
            
            theReq.account_id = pReq.account_id;
            theReq.account_name = pReq.account_name;
            theReq.telno = pReq.address;
            theReq.opp_id = pReq.opp_id;
            theReq.pdf_url = pReq.pdf_url;
            theReq.pdf_password =pReq.pdf_password;

            AcrtSmsSender.Req theAcrtSmsSenderReq = mObHokoSm.createAcrtSmsSenderReq(theReq);
            AcrtSmsSender.Result theSendResult = mAcrtSmsSenderClient.sendSms(theAcrtSmsSenderReq);
            mIAcrtSmsSendHistLogr.logSmsHistory(theSendResult);
            mAcrtDrTackRegister.InsertEntry(theSendResult);
        }

        logSendHistory(pReq);

        Res theRes = new Res();
        theRes.isSuccess = true;
        return theRes;
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
                Loggings.createLogEntry(Loggings.Level.Warn, '20201009-1735', 'ObIrHkSendSvcHokoSend.logSendHistoryOnly')
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
            purpose_kubun__c = '手配報告書送付/お客様',
            to_name__c = pReq.account_name,
            to_method__c = pReq.method,
            to_address__c = String.isBlank(pReq.address) ? null : pReq.address.left(200),
            pdf_url__c = pReq.pdf_url,
            pdf_password__c = pReq.pdf_password
        );
    }
}