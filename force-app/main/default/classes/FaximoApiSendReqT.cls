@isTest
public class FaximoApiSendReqT {
    @isTest static void requestSuccess() {

        String faximoProcesskey = datetime.now().format('yyyy-MM-dd HH:mm:sss');
        FaximoConfs.Config theConfig = FaximoConfs.getConfig(faximoProcesskey);
        String theApiBaseUrl = theConfig.api_base_url;
        FaximoApiSendReq.Response theApiResponse = new FaximoApiSendReq.Response();
        Test.setMock( HttpCalloutMock.class, 
        new Testing_HttpResMock()
            .addResponder(
                new Testing_HttpResponders.UrlContains()
                    .setStrUrlContains( 
                        theApiBaseUrl + '/snd/v1/request.json'
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
        FaximoApiSendReq.Request theRequest = new FaximoApiSendReq.Request();
        new FaximoApiSendReq.Client()
            .sendRequest(
                'pBasicAuth_Username', 'pBasicAuth_Password', theApiBaseUrl, 'pFaximoNumber', theRequest
            );
        Test.stopTest();
    }

    @isTest static void requestException() {

        String faximoProcesskey = datetime.now().format('yyyy-MM-dd HH:mm:sss');
        FaximoConfs.Config theConfig = FaximoConfs.getConfig(faximoProcesskey);
        String theApiBaseUrl = theConfig.api_base_url;

        Test.startTest();
        FaximoApiSendReq.Request theRequest = new FaximoApiSendReq.Request();
        new FaximoApiSendReq.Client()
            .sendRequest(
                'pBasicAuth_Username', 'pBasicAuth_Password', theApiBaseUrl, 'pFaximoNumber', theRequest
            );
        Test.stopTest();
    }
}