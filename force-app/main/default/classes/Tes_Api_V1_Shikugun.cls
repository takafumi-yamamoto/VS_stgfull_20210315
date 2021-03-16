@isTest
private class Tes_Api_V1_Shikugun {
    static testMethod void testMethod1() {
        
	    Test.startTest();
	        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/api/v1/city_master';
        req.httpMethod = 'GET';

        RestContext.request = req;
        RestContext.response= res;
        
        Api_V1_Shikugun.getAllData();
	    
	        
        Test.stopTest();
    }
}