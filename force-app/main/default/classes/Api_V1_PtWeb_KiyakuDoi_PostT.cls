@isTest
private class Api_V1_PtWeb_KiyakuDoi_PostT {
	
	@isTest static void test_Api_V1_PtWeb_KiyakuDoi_Post() {
		String json = '{ \"torihikisaki_bango\" : \"abc\" }';
		// Implement test code
	    Test.startTest();
	        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/api/v1/ptwebs/kiyakudoi';
        req.httpMethod = 'POST';
	    req.requestBody = Blob.valueof(json);

        RestContext.request = req;
        RestContext.response= res;
        
		Api_V1_PtWeb_KiyakuDoi_Post.doPost();

        Test.stopTest();
	}
	
}