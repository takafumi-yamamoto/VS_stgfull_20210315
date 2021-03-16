@isTest
private class Api_V1_SogSok_SrthIraiSho_MakurakyoT {
	
	@isTest static void test_method_one() {
		// Implement test code
	    Test.startTest();
	        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/api/v1/sogsok/srthiraisho/makurakyo';
        req.httpMethod = 'GET';
	    //req.requestBody = Blob.valueof(json);

        RestContext.request = req;
        RestContext.response= res;
        
		Api_V1_SogSok_SrthIraiSho_Makurakyo.doGet();

        Test.stopTest();
	}
	
	
}