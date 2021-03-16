@isTest
public class FaximoApiSendRsltReqT {
    @isTest static void requestSuccess() {

        String faximoProcesskey = datetime.now().format('yyyy-MM-dd HH:mm:sss');
        FaximoConfs.Config theConfig = FaximoConfs.getConfig(faximoProcesskey);
        String theApiBaseUrl = theConfig.api_base_url;
        FaximoApiSendRsltReq.Response theApiResponse = new FaximoApiSendRsltReq.Response();
        theApiResponse.SendResultList = new List<FaximoApiSendRsltReq.SendResultListInfo>();

        Test.setMock( HttpCalloutMock.class, 
        new Testing_HttpResMock()
            .addResponder(
                new Testing_HttpResponders.UrlContains()
                    .setStrUrlContains( 
                        theApiBaseUrl + '/snd/v2/record_query.json'
                        )
                    .setStatusCode(200)
                    .setBody( JSON.serialize(theApiResponse) )
            )
            .addResponder(
                new Testing_HttpResponders.CatchAll()
                    .setStatusCode(200)
            )
        );

        Test.startTest();
        FaximoApiSendRsltReq.Request theRequest = new FaximoApiSendRsltReq.Request();
        new FaximoApiSendRsltReq.Client()
            .sendRequest(
                'pBasicAuth_Username', 'pBasicAuth_Password', theApiBaseUrl, 'pFaximoNumber', theRequest
            );
        Test.stopTest();
    }

    @isTest static void requestException() {

        String faximoProcesskey = datetime.now().format('yyyy-MM-dd HH:mm:sss');
        FaximoConfs.Config theConfig = FaximoConfs.getConfig(faximoProcesskey);
        String theApiBaseUrl = theConfig.api_base_url;

        FaximoApiSendRsltReq.Request theRequest = new FaximoApiSendRsltReq.Request();

        Test.startTest();
        
        new FaximoApiSendRsltReq.Client()
            .sendRequest(
                'pBasicAuth_Username', 'pBasicAuth_Password', theApiBaseUrl, 'pFaximoNumber', theRequest
            );

        Test.stopTest();
    }
}