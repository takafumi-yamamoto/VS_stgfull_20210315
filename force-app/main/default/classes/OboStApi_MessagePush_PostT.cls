@isTest
private class OboStApi_MessagePush_PostT {

    @isTest static void test_method_one() {
        
        OboStApi_Auth.ResBody theOboStApi_AuthRes = new OboStApi_Auth.ResBody();
        theOboStApi_AuthRes.token_type = ''; theOboStApi_AuthRes.expires_in = 0; theOboStApi_AuthRes.access_token = '';
        Test.setMock( HttpCalloutMock.class, 
            new Testing_HttpResMock()
                .addResponder(
                    new Testing_HttpResponders.UrlContains()
                        .setStrUrlContains( new OboStConfig().getBaseEndPoint() + '/api/oauth/token' )
                        .setStatusCode(200)
                        .setBody( JSON.serialize(theOboStApi_AuthRes) )
                )
                .addResponder(
                    new Testing_HttpResponders.CatchAll()
                        .setStatusCode(200)
                )
        );
        Test.startTest();
        
        OboStApi_MessagePush_Post.ReqBody pReqBody = new OboStApi_MessagePush_Post.ReqBody();
        pReqBody.setPartnerId('abc').addTextMsg('hello');
        new OboStApi_MessagePush_Post().sendRequest(pReqBody);

        Test.stopTest();
    }
}