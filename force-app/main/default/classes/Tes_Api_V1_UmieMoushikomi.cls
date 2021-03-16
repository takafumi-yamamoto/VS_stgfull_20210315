@isTest
public class Tes_Api_V1_UmieMoushikomi {

	static testMethod void testCase1(){

	    String json = '{'+
	    '\"uniq_id\":\"11111\",'+
	    '\"req_day\":\"2017-04-10\",'+
	    '\"entrance\":\"資料請求\",'+
	    '\"customer_sei\":\"テスト\",'+
	    '\"customer_mei\":\"テスト\",'+
	    '\"customer_sei_kana\":\"テスト\",'+
	    '\"customer_mei_kana\":\"テスト\",'+
	    '\"customer_keitai_denwa\":\"09011112222\",'+
	    '\"customer_kotei_denwa\":\"0311112222\",'+
	    '\"customer_mail\":\"test@minrevi.jp\",'+
	    '\"customer_postal_code\":\"1111111\",'+
	    '\"customer_state\":\"東京都\",'+
	    '\"customer_city\":\"渋谷区\",'+
	    '\"customer_street\":\"高田馬場\",' + 
	    '\"taisyosya_sei\":\"テスト\",'+
	    '\"taisyosya_mei\":\"テスト\",'+
	    '\"taisyosya_sei_kana\":\"テスト\",'+
	    '\"taisyosya_mei_kana\":\"テスト\",'+
	    '\"taisyosya_from_customer\":\"父\",'+
	    '\"taisyosya_from_customer_sonota\":\"テスト\",'+
	    '\"sankotsu_kaiiki\":\"東京湾\",'+
	    '\"customer_comment\":\"テスト\",'+
	    '\"sozoku_sodan_kibo\":\"希望しない\"'+
	    '}';

	    Test.startTest();
	        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/api/v1/umie_moushikomi/';
        req.httpMethod = 'POST';
	    req.requestBody = Blob.valueof(json);

        RestContext.request = req;
        RestContext.response= res;
        
        Api_V1_UmieMoushikomi.doPost();
	    
	        
        Test.stopTest();



	}

}