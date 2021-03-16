@isTest
public class FreApiDealsGetT {

    @isTest public static void Client_sendRequest(){

        String the_endpoint = FreApiConfs.getConfig().api_base_url;
        FreApiDealsGet.Response the_res = new FreApiDealsGet.Response();

        Test.setMock( HttpCalloutMock.class, 
        new Testing_HttpResMock()
            .addResponder(
                new Testing_HttpResponders.UrlContains()
                    .setStrUrlContains( the_endpoint )
                    .setStatusCode(200)
                    .setBody( JSON.serialize(the_res) )
            )
        );

        Test.startTest();
        FreApiDealsGet.Request the_req = new FreApiDealsGet.Request();
        new FreApiDealsGet.Client(
            'access_token',
            the_endpoint
        )
        .sendRequest(the_req);
        Test.stopTest();
    }
}