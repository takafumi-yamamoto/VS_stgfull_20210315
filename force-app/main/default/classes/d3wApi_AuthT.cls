@isTest
public class d3wApi_AuthT {
    @isTest public static void Client_send_request(){
        String a_base_url = d3wConf.get_IProvider_instance().getConfig().api_base_url;

        d3wApi_Auth.Res a_res = new d3wApi_Auth.Res();
        Test.setMock( HttpCalloutMock.class, 
        new Testing_HttpResMock()
            .addResponder(
                new Testing_HttpResponders.UrlContains()
                    .setStrUrlContains( a_base_url )
                    .setStatusCode(200)
                    .setBody( JSON.serialize(a_res) )
            )
            .addResponder(
                new Testing_HttpResponders.CatchAll()
                    .setStatusCode(200)
            )
        );
        Test.startTest();
        d3wApi_Auth.get_IClient_instance().send_request(
            new d3wApi_Auth.Req()
            .set_UID('a-uid')
            .set_UPW('a-upw')
        );
        Test.stopTest();
    }
}