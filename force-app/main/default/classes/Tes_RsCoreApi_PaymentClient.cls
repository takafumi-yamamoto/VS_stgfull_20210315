@isTest
private class Tes_RsCoreApi_PaymentClient {

    @isTest(SeeAllData=true)
    static void testMethod1() {
        Test.setMock( HttpCalloutMock.class, new Testing_HttpResponseMock().setStatusCode(200) );
        Test.startTest();

        String url = 'http://minrevi.jp/payments/seikyuBango/';
        RsCoreApi_PaymentClient client = new RsCoreApi_PaymentClient(url, null);
        RsCoreApi_Util.doGet(client);
        RsCoreApi_Util.doPost(client);
        RsCoreApi_Util.doDelete(client);
        RsCoreApi_Util.doPatch(client);

        Test.stopTest();

    }
}