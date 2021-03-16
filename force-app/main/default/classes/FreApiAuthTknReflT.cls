@isTest
public class FreApiAuthTknReflT {
    @isTest public static void Client_sendRequest(){

        FreApiConfs.Config a_config = FreApiConfs.getConfig();

        FreApiAuthTknRefl.Response a_res = new FreApiAuthTknRefl.Response();
        Test.setMock( HttpCalloutMock.class, 
        new Testing_HttpResMock()
            .addResponder(
                new Testing_HttpResponders.UrlContains()
                    .setStrUrlContains( a_config.api_base_url )
                    .setBody(JSON.serialize(a_res))
                    .setStatusCode(200)
            )
        );

        FreApiAuthTknRefl.Request a_req = new FreApiAuthTknRefl.Request();
        a_req.client_id = '';
        a_req.client_secret = '';
        a_req.grant_type = '';
        a_req.redirect_uri = '';
        a_req.refresh_token = '';

        Test.startTest();
        FreApiAuthTknRefl.get_IClient_Instance().sendRequest(a_config.api_base_url, a_req);
        Test.stopTest();
    }
}