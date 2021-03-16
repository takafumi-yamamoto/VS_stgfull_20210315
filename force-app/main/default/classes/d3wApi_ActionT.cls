@isTest public class d3wApi_ActionT {

    @isTest public static void Client_send_request(){
        String a_base_url = d3wConf.get_IProvider_instance().getConfig().api_base_url;

        d3wApi_Action.Res a_res = new d3wApi_Action.Res();
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
        d3wApi_Action.get_IClient_instance().send_request(
            new d3wApi_Action.Req()
            .set_UID('a-uid')
            .set_UPW('a-upw')
            .set_work('a-work')
            .set_data('a-csv-data')
        );
        Test.stopTest();
    }
}