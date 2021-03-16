@isTest
public class Tes_Api_V1_SimpleYasugoToiawase {

	static testMethod void testCase(){

	    String json = '{'+
	    '\"gaclient_id\":\"1111111111.2222222222\",'+
	    '\"mail_syori_id\":\"11111\",'+
	    '\"toiawase_date\":\"2017-04-10\",'+
	    '\"iriguchi_name\":\"資料請求\",'+	    
	    '\"customer_sei\":\"テスト\",'+
	    '\"customer_mei\":\"テスト\",'+
	    '\"customer_sei_kana\":\"テスト\",'+
	    '\"customer_mei_kana\":\"テスト\",'+
	    '\"customer_mail\":\"hikaru-ebina@minrevi.jp\",'+
	    '\"customer_comment\":\"テストです\"'+
	    '}';

	    Test.startTest();
	        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/api/v1/simple_yasugo_toiawase';
        req.httpMethod = 'POST';
	    req.requestBody = Blob.valueof(json);

        RestContext.request = req;
        RestContext.response= res;
        
        Api_V1_SimpleYasugoToiawase.doPost();
    
        Test.stopTest();
	}

}