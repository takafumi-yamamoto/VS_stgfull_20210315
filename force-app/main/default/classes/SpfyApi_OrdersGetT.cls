@isTest
public class SpfyApi_OrdersGetT {
    @isTest static void Client_sendRequest() {

        String theApiBaseUrl = SpfyConfs.getConfig().api_base_url;
        SpfyApi_OrdersGet.Response theApiResponse = new SpfyApi_OrdersGet.Response();
        Test.setMock( HttpCalloutMock.class, 
        new Testing_HttpResMock()
            .addResponder(
                new Testing_HttpResponders.UrlContains()
                    .setStrUrlContains( 
                        theApiBaseUrl + '/admin/api/2020-04/orders.json'
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
        SpfyApi_OrdersGet.Request theRequest = new SpfyApi_OrdersGet.Request();
        theRequest.ids = '1';
        new SpfyApi_OrdersGet.Client()
            .sendRequest(
                'pBasicAuth_Username', 'pBasicAuth_Password', theApiBaseUrl, theRequest
            );
        Test.stopTest();
    }
}