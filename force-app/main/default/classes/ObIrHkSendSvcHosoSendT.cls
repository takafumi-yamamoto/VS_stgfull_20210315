@isTest
public class ObIrHkSendSvcHosoSendT {
    @isTest
    public static void logSendHistoryOnly(){

        ObIrHkSendSvcHosoSend.Req theReq = new ObIrHkSendSvcHosoSend.Req();
        theReq.method = 'sms';
        theReq.account_name = '_';
        theReq.address = '99999999999';
        theReq.opp_id = null;
        theReq.pdf_url = '_';
        theReq.pdf_password = '_';

        Test.startTest();
        ObIrHkSendSvcHosoSend.logSendHistoryOnly(theReq);
        Test.stopTest();

    }

    @isTest
    public static void logSendHistoryOnly_Err(){

        ObIrHkSendSvcHosoSend.Req theReq = new ObIrHkSendSvcHosoSend.Req();
        theReq.method = 'sms';
        theReq.account_name = '_';
        theReq.address = '99999999999';
        theReq.opp_id = 'invalid id';
        theReq.pdf_url = '_';
        theReq.pdf_password = '_';

        Test.startTest();
        try{
            ObIrHkSendSvcHosoSend.logSendHistoryOnly(theReq);
        }catch(Exception ex){ }
        
        Test.stopTest();

    }
}