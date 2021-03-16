@isTest
private class LineMsgSenderT {
    
    @isTest static void test_method_one() {
        Account acc = new SampleData().getAccountSoryoAccount();
        insert acc;
        Account acc1 = [select 
                Id, TorihikisakiBango__c from Account 
                where id = :acc.Id
                limit 1];

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
        
        LineMsgSender.ReqArg pReqArg = new LineMsgSender.ReqArg();
        pReqArg.torihikisakiBango = acc1.TorihikisakiBango__c;
        pReqArg.text = 'hello wrold';
        pReqArg.accountIdToRelate = acc1.Id;
        pReqArg.oppIdToRelate = null;
        new LineMsgSender().sendTextMsg(pReqArg);

        Test.stopTest();
    }
}