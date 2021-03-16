@isTest
public class AcrtSmsSenderT {

    public class AcrtApiSmsRegClient_Stub implements AcrtApiSmsReg.IClient{
        public AcrtApiSmsReg.Result sendRequest(AcrtApiSmsReg.Req pReq){
            AcrtApiSmsReg.Result theResult = new AcrtApiSmsReg.Result();
            theResult.statusCode = 200;
            theResult.isSuccess = true;
            return theResult;
        }
    }
    @isTest public static void Client_sendSms(){

        AcrtSmsSender.Req theReq = 
            new AcrtSmsSender.Req()
            .set_text_long('')
            .set_shorten_url(true)
            .set_telno('00000000000')
            .set_msg_type('test_sms')
            .set_user_ref('_')
            .set_msg_meta_data('_')
            .set_account_id('')
            .set_opp_id('')
            .set_timeout(30000);

        Test.startTest();
        new AcrtSmsSender.Client( new AcrtApiSmsRegClient_Stub() ).sendSms(theReq);
        Test.stopTest();
    }

    @isTest public static void getClient(){
        AcrtSmsSender.getClient();
    }
}