/**

 */
@isTest
private class OboStApi_OfferT {

    @isTest
    static void sendRequest() {
        OboStApi_Auth.ResBody theOboStApi_AuthRes = new OboStApi_Auth.ResBody();
        theOboStApi_AuthRes.token_type = ''; theOboStApi_AuthRes.expires_in = 0; theOboStApi_AuthRes.access_token = '';
        OboStApi_Offer.ResBody theOboStApi_OfferRes = new OboStApi_Offer.ResBody();
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
                        .setBody( JSON.serialize(theOboStApi_OfferRes) )
                )
        );
        Test.StartTest();
        new OboStApi_Offer().sendRequest( new OboStApi_Offer.ReqBody());
        Test.StopTest();
    }

    @isTest
    static void sendRequest_auth_error() {
        Test.setMock( HttpCalloutMock.class,
            new Testing_HttpResMock()
                .addResponder(
                    new Testing_HttpResponders.CatchAll()
                        .setStatusCode(403)
                )
        );
        Test.StartTest();
        new OboStApi_Offer().sendRequest( new OboStApi_Offer.ReqBody() );
        Test.StopTest();
    }

    @isTest
    public static void OboStApi_Offer_Offer_contract(){
        new OboStApi_Offer.Offer_contract()
            .setContractId('_');
    }

    @isTest
    public static void OboStApi_Offer_Place(){
        new OboStApi_Offer.Place()
            .setName('_')
            .setPostalCode('_')
            .setState('_').setCity('_').setStreet('_');
    }

    @isTest
    public static void OboStApi_Offer_Hoyo_detail(){
        new OboStApi_Offer.Hoyo_detail()
            .setKaimyo('_')
            .setServiceContent('_')
            .setPlace(null)
            .setAdditionalPlace(null)
            .addCandidateDatetime( Datetime.newInstance(2020,1,1,0,0,0) );
    }

    @isTest
    public static void OboStApi_Offer_Sogi_detail(){
        new OboStApi_Offer.Sogi_detail()
            .setKaimyo('_')
            .setServiceContent('_')
            .setPlace(null)
            .setMakurakyoDatetime( Datetime.newInstance(2020,1,1,0,0,0) )
            .setTsuyaDatetime( Datetime.newInstance(2020,1,1,0,0,0) )
            .setKokubetsuDatetime( Datetime.newInstance(2020,1,1,0,0,0) )
            .setKasoDatetime( Datetime.newInstance(2020,1,1,0,0,0) )
            .setShonanoka('_')
            .setKasobaName('_');
    }
}