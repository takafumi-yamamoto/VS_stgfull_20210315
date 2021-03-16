@isTest
private class Api_V1_SogSok_SrthIraiSho_RyokinCalcT {
	
	@isTest static void test_method_one() {	    
		String json = '{'
        + '\"plan_code\" : \"kaso\",'
        + '\"makurakyo_code\" : \"tsuya_zenzitsu\",'
        + '\"kaimyo_code\" : \"釋\" }';

		Test.startTest();
	        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/api/v1/sogsok/srthiraisho/ryokincalc';
        req.httpMethod = 'POST';
	    req.requestBody = Blob.valueof(json);

        RestContext.request = req;
        RestContext.response= res;

		Api_V1_SogSok_SrthIraiSho_RyokinCalc.doPost();

        Test.stopTest();
	}
	
	@isTest static void test_method_2() {	    
		String json = '{'
        + '\"plan_code\" : \"kaxxso\",'
        + '\"makurakyo_code\" : \"tsuya_zenzitsxxu\",'
        + '\"kaimyo_code\" : \"釋xx\" }';

		Test.startTest();
	        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/api/v1/sogsok/srthiraisho/ryokincalc';
        req.httpMethod = 'POST';
	    req.requestBody = Blob.valueof(json);

        RestContext.request = req;
        RestContext.response= res;
        
		Api_V1_SogSok_SrthIraiSho_RyokinCalc.doPost();

        Test.stopTest();
	}
	
}