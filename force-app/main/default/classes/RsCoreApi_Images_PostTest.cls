@isTest
public class RsCoreApi_Images_PostTest {
    @isTest(SeeAllData=true)
    public static void dotest(){

        RsCoreApi_Images_Post.ReqArgs theArgs = new RsCoreApi_Images_Post.ReqArgs();
        theArgs.base64Data = '';
        theArgs.extension = 'jpg';
        theArgs.published = true;
        theArgs.purpose = 'top';
        theArgs.type = 'facility';
        theArgs.typeAssociateId = 1;

        RsCoreApi_Images_Post.ResBody theRes = new RsCoreApi_Images_Post.ResBody();
        theRes.id = 1;
        theRes.url = '';

        Test.setMock( HttpCalloutMock.class, new Testing_HttpResponseMock().setStatusCode(201).setBody( JSON.serialize( theRes ) ) );

        RsCoreApi_Images_Post.Result theResult = new RsCoreApi_Images_Post.Agent().sendRequest(theArgs);
    }
}