@isTest
private class Api_V1_SogSok_ZokugaraT {
	
	@isTest static void test_method_one() {
		// Implement test code
	    Test.startTest();
	        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/api/v1/sogsok/zokugara';
        req.httpMethod = 'GET';
	    //req.requestBody = Blob.valueof(json);

        RestContext.request = req;
        RestContext.response= res;
        
		Api_V1_SogSok_Zokugara.doGet();

        Test.stopTest();
	}
	
}