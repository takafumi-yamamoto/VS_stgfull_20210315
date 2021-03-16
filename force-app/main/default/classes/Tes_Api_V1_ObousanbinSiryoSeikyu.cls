@isTest
public class Tes_Api_V1_ObousanbinSiryoSeikyu {
	static testMethod void testCase1() {
	
	    String json = '{'+
	    '\"gaclient_id\":\"1111111111.2222222222\",'+
	    '\"mail_syori_id\":\"11111\",'+
	    '\"toiawase_date\":\"2017-04-10\",'+
	    '\"iriguchi_name\":\"資料請求\",'+	    
	    '\"customer_sei\":\"テスト\",'+
	    '\"customer_mei\":\"テスト\",'+
	    '\"customer_sei_kana\":\"テスト\",'+
	    '\"customer_mei_kana\":\"テスト\",'+
	    '\"customer_tel\":\"09011112222\",'+
	    '\"customer_mail\":\"hikaru-ebina@minrevi.jp\",'+
	    '\"hoyo_yotei_jokyo\":\"kimatte_iru\",'+
		'\"shiryo_soufu_hoho\" : \"post\",' +
		'\"shiryo_soufusaki_atena\" : \"資料送付 宛名\",' +
		'\"shiryo_soufusaki_atenakana\" : \"資料送付先 宛名(カナ)\",' +
		'\"shiryo_soufusaki_postalcode\" : \"1500001\",' +
		'\"shiryo_soufusaki_state\" : \"東京\",' +
		'\"shiryo_soufusaki_city\" : \"品川区\",' +
		'\"shiryo_soufusaki_street\" : \"西五反田1-1-1\",' +
		'\"shiryo_soufusaki_mailaddress\" : \"huang-exia+201809203333@yoriso.com\",' +
	    '\"verify\":\"false\"' + 
	    '}';

	    Test.startTest();
	        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/api/v1/Api_V1_ObousanbinSiryoSeikyu';
        req.httpMethod = 'POST';
	    req.requestBody = Blob.valueof(json);

        RestContext.request = req;
        RestContext.response= res;
        
        Api_V1_ObousanbinSiryoSeikyu.doPost();
	    
	        
        Test.stopTest();
	}

}