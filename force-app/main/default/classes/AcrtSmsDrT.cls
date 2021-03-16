@isTest
public class AcrtSmsDrT {

    public class AcrtApiSmsDrClient_Stub implements AcrtApiSmsDr.IClient{
        public AcrtApiSmsDr.Result sendRequest(String pEndPoint, AcrtApiSmsDr.Req pReq){
            AcrtApiSmsDr.Result theResult = new AcrtApiSmsDr.Result();
            return theResult;
        }
    }
    @isTest public static void Client_sendRequest() {

        AcrtSmsDr.Req theReq = new AcrtSmsDr.Req();

        Test.startTest();
        new AcrtSmsDr.Client( new AcrtApiSmsDrClient_Stub() ).sendRequest( theReq );
        Test.stopTest();
    }
}