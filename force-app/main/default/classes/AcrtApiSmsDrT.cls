@isTest
public class AcrtApiSmsDrT {
    @isTest public static void Client_sendRequest() {

        AcrtApiSmsDr.Req theReq = new AcrtApiSmsDr.Req();

        String theEndPoint = 'https://api.acrt.jp/ibss/api/this-is-dummy-endpoint/202008062247';

        AcrtApiSmsDr.Res theRes = new AcrtApiSmsDr.Res();
        Test.setMock( HttpCalloutMock.class, 
        new Testing_HttpResMock()
            .addResponder(
                new Testing_HttpResponders.UrlContains()
                    .setStrUrlContains( theEndPoint )
                    .setStatusCode(200)
                    .setBody( JSON.serialize(theRes) )
            )
            .addResponder(
                new Testing_HttpResponders.CatchAll()
                    .setStatusCode(200)
            )
        );

        Test.startTest();
        new AcrtApiSmsDr.Client().sendRequest(theEndPoint, theReq);

        Test.stopTest();
    }
}