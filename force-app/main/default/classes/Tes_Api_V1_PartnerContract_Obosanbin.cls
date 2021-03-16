@isTest
public class Tes_Api_V1_PartnerContract_Obosanbin {
	static testMethod void testCase1() {
String json = '{'+

	    '\"moshikomisha_moshikomishasei_kana\":\"タナカ\",'+
        '\"moshikomisha_moshikomishamei_kana\":\"タロウ\",'+
        '\"moshikomisha_moshikomishase\":\"田中\",'+
        '\"moshikomisha_moshikomishamei\":\"太郎\",'+
        '\"johosha\":[{'+
        '\"johosha_johoshasei_kana\":\"タナカ\",'+
        '\"johosha_johoshamei_kana\":\"タロウ\"'+
        '}]'+
        '}';
	    Test.startTest();
	        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/api/v1/partnercontract_obosanbin';
        req.httpMethod = 'POST';
	    req.requestBody = Blob.valueof(json);

        RestContext.request = req;
        RestContext.response= res;
        
        Api_V1_PartnerContract_Obosanbin.doPost();
	    
	        
        Test.stopTest();        
    }
}