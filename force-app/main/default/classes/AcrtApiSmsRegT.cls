@isTest
public class AcrtApiSmsRegT {

    public class TesterPhones_Stub implements TesterPhones.ITesterPhones{
        public void raiseNotTesterExIfNotAllowed(String pPhone){ return; }
    }

    public class Res{
        public string action;
        public String telno;
        public String delivery_id;
        public String result_code;
        public String message;
        public String register_time;
    }
    @isTest public static void Client_sendRequest(){

        AcrtApiSmsReg.Req theReq = new AcrtApiSmsReg.Req();
        theReq.text_long = '_';
        theReq.shorten_url = 'yes';
        theReq.telno = '00000000000';
        theReq.user_ref = '';
        theReq.timeout = 0;

        String theEndPoint = 'https://api.acrt.jp/ibss/api/this-is-dummy-endpoint/202008062215';

        AcrtApiSmsReg.Res theRes = new AcrtApiSmsReg.Res();
        theRes.action = 'sms_reg';
        theRes.telno = '810000000000';
        theRes.delivery_id = '12345';
        theRes.result_code = '0000';
        theRes.message = 'succeeded';
        theRes.register_time = '2012/01/01 12:34:56';

        AcrtApiSmsReg.Client theClient = new AcrtApiSmsReg.Client( AcrtSmsConf.getConfig(), new TesterPhones_Stub() );

        Test.setMock( HttpCalloutMock.class, 
            new Testing_HttpResMock()
                .addResponder(
                    new Testing_HttpResponders.UrlContains()
                        .setStrUrlContains( theClient.getEndPoint() )
                        .setStatusCode(200)
                        .setBody( JSON.serialize(theRes) )
                )
                .addResponder(
                    new Testing_HttpResponders.CatchAll()
                        .setStatusCode(200)
                )
        );
        
        Test.startTest();
        theClient.sendRequest( theReq );
        Test.stopTest();
    }
}