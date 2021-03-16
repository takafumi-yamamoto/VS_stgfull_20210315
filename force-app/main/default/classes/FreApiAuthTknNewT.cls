@isTest
public class FreApiAuthTknNewT {
    @isTest public static void Client_sendRequest(){

        FreApiConfs.Config a_config = FreApiConfs.getConfig();

        FreApiAuthTknNew.Response a_res = new FreApiAuthTknNew.Response();
        Test.setMock( HttpCalloutMock.class, 
        new Testing_HttpResMock()
            .addResponder(
                new Testing_HttpResponders.UrlContains()
                    .setStrUrlContains( a_config.api_base_url )
                    .setBody(JSON.serialize(a_res))
                    .setStatusCode(200)
            )
        );

        FreApiAuthTknNew.Request a_req = new FreApiAuthTknNew.Request();
        a_req.client_id = '';
        a_req.client_secret = '';
        a_req.grant_type = '';
        a_req.redirect_uri = '';
        a_req.code = '';

        Test.startTest();
        FreApiAuthTknNew.get_IClient_Instance().sendRequest(a_config.api_base_url, a_req);
        Test.stopTest();
    }
}