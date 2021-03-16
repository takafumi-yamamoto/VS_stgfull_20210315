@isTest
public class CoreManageApiT {
    @isTest
    public static void testAll() {

        String theEndPoint = 'https://api.core.yoriso.com-dummmmy/';

        Test.setMock( HttpCalloutMock.class, 
        new Testing_HttpResMock()
            .addResponder(
                new Testing_HttpResponders.UrlContains()
                    .setStrUrlContains( theEndPoint )
                    .setStatusCode(200)
                    .setBody( '{"msg":""}' )
            )
            .addResponder(
                new Testing_HttpResponders.CatchAll()
                    .setStatusCode(200)
            )
        );


        Test.startTest();
            CoreManageApi coreManageApi = new CoreManageApi();
            Map<String, Object> reqBody = new Map<String, Object>();
            reqBody.put('id', 'aaaaaaa11112222');
            coreManageApi.surveyPost(reqBody, theEndPoint);
            coreManageApi.surveyPatch(reqBody, theEndPoint);
            coreManageApi.surveyDelete('aaaaaaaa11112222', theEndPoint);
        Test.stopTest();
    }
}