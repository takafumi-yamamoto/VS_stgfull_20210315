@isTest
private class Api_V1_PtWeb_Account_GetT {
	
	@isTest static void test_Api_V1_PtWeb_Account_Get() {
		// Implement test code
	    Test.startTest();
	        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/api/v1/ptwebs/account';
        req.httpMethod = 'GET';
	    //req.requestBody = Blob.valueof(json);

        RestContext.request = req;
        RestContext.response= res;
        
		Api_V1_PtWeb_Account_Get.doGet();

        Test.stopTest();
	}
	
	
	@isTest static void test_Api_V1_PtWeb_Account_Get2() {
		// Implement test code
	    Test.startTest();
	        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/api/v1/ptwebs/account';
        req.httpMethod = 'GET';
	    req.params.put('torihikisaki_bango', 'sokyaku.name');

        RestContext.request = req;
        RestContext.response= res;
        
		Api_V1_PtWeb_Account_Get.doGet();

        Test.stopTest();
	}
	
	
}