@isTest
public class FaximoApiSendRsltReqExT {
    
    public class ApiClientMock implements FaximoApiSendRsltReq.IClient{
        public FaximoApiSendRsltReq.Result sendRequest(
            String pBasicAuth_Username, String pBasicAuth_Password, String pBaseUrl, String pFaximoNumber, FaximoApiSendRsltReq.Request pReq
        ){
            FaximoApiSendRsltReq.Result theResult = new FaximoApiSendRsltReq.Result();
            theResult.response = new FaximoApiSendRsltReq.Response();
            theResult.response.SendResultList = new List<FaximoApiSendRsltReq.SendResultListInfo>();
            theResult.response.SendResultList.add(new FaximoApiSendRsltReq.SendResultListInfo());
            return theResult;
        }
    }

    @isTest public static void Client_sendRequest() {

        String faximoProcesskey = datetime.now().format('yyyy-MM-dd HH:mm:sss');

        FaximoApiSendRsltReqEx.Request theReq = new FaximoApiSendRsltReqEx.Request();

        Test.startTest();
        
        new FaximoApiSendRsltReqEx.Client(
            FaximoConfs.getConfig(faximoProcesskey),
            new ApiClientMock(),
            new FaximoApiSendRsltReqEx.ResponseConverter()
        ).sendRequest(theReq);
    
        Test.stopTest();
    }
}