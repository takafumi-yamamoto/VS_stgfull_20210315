@isTest
public class Tes_Api_V1_Hakapita {

	static testMethod void testCase1() {
		

	    String json = '{'+
	    '\"uniq_id\":\"11111\",'+
	    '\"req_day\":\"2017-04-10\",'+
	    '\"entrance\":\"資料請求\",'+
	    '\"manage_screen_url\":\"テスト\",'+
	    '\"last_tour_day\":\"111-0011\",'+
	    '\"qa_mail\":\"テストテストテスト\",'+
	    '\"last_name\":\"テスト\",'+
	    '\"first_name\":\"テスト\",'+
	    '\"last_name_kana\":\"テスト\",'+
	    '\"first_name_kana\":\"テスト\",'+
	    '\"mobile\":\"09011112222\",'+
	    '\"email\":\"\",'+
	    '\"address_zip_code\":\"1111111\",'+
	    '\"address_state\":\"東京都\",'+
	    '\"address_city\":\"渋谷区\",'+
	    '\"address_street\":\"高田馬場\"' + 
	    '}';

	    Test.startTest();
	        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest//api/v1/hakapita';
        req.httpMethod = 'POST';
	    req.requestBody = Blob.valueof(json);

        RestContext.request = req;
        RestContext.response= res;
        
        Api_V1_Hakapita.doPost();
	    
	        
        Test.stopTest();
	}

}