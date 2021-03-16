@isTest
public class SlackApiPostMsgT {

    @isTest public static void Client_sendRequest() {

        String a_endpoint = SlackApiPostMsgConf.get_IProvider_instance().getConfig().endpoint;
        
        Test.setMock( HttpCalloutMock.class, 
        new Testing_HttpResMock()
            .addResponder(
                new Testing_HttpResponders.UrlContains()
                    .setStrUrlContains( a_endpoint )
                    .setStatusCode(200)
            )
            .addResponder(
                new Testing_HttpResponders.CatchAll()
                    .setStatusCode(200)
            )
        );

        Test.startTest();
        new SlackApiPostMsg.Client(
            a_endpoint
        ).sendRequest(
            new SlackApiPostMsg.Req()
        );
        Test.stopTest();
    }
}