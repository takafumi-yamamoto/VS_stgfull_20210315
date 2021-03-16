@isTest
private class Api_V1_SogSok_SrthIraiSho_PlanT {
	
	@isTest static void test_method_one() {
	    Test.startTest();
	        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/api/v1/sogsok/srthiraisho/plan';
        req.httpMethod = 'GET';
	    //req.requestBody = Blob.valueof(json);

        RestContext.request = req;
        RestContext.response= res;
        
		Api_V1_SogSok_SrthIraiSho_Plan.doGet();

        Test.stopTest();
	}
	
}