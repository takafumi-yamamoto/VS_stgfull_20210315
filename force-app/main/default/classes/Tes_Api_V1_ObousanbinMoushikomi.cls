@isTest
public class Tes_Api_V1_ObousanbinMoushikomi {

	private static void setUp(){
		Insert new Account(
			RecordTypeId = new RecordTypeDao().selectRecordBySobjectTypeDeveloperName('Account', 'null').Id,
			LastName = '_',
			FirstName = '_'
		);
		Insert new TriggerIsActive__c(
			name = 'default',
			isActive__c = true
		);
		Insert new JizenWariPlan__c(
			Code__c='Yoriso'
		);
	}

	static testMethod void testCase1() {
	
		setUp();

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
	    '\"customer_mail\":\"\",'+
	    '\"customer_postal_code\":\"335-0017\",'+
	    '\"customer_state\":\"埼玉\",'+
	    '\"customer_city\":\"戸田\",'+
	    '\"customer_street\":\"１－１－１\",'+
	    '\"siryo_sofu_postal_code\":\"335-0017\",'+
	    '\"siryo_sofu_state\":\"\",'+
	    '\"siryo_sofu_city\":\"\",'+
	    '\"siryo_sofu_street\":\"\",'+
	    '\"taisyosya_sei\":\"\",'+
	    '\"taisyosya_mei\":\"\",'+
	    '\"taisyosya_sei_kana\":\"\",'+
	    '\"taisyosya_mei_kana\":\"\",'+
	    '\"taisyosya_birthday\":\"\",'+
	    '\"taisyosya_seikyodate\":\"\",'+
	    '\"taisyosya_syuha\":\"\",'+
	    '\"taisyosya_bodaiji_umu\":\"\",'+
	    '\"hoyo_basyo_name\":\"\",'+
	    '\"hoyo_basyo_postal_code\":\"\",'+
	    '\"hoyo_basyo_state\":\"\",'+
	    '\"hoyo_basyo_city\":\"\",'+
	    '\"hoyo_basyo_street\":\"\",'+
	    '\"hoyo_basyo2_name\":\"\",'+	    
	    '\"hoyo_basyo2_postal_code\":\"\",'+
	    '\"hoyo_basyo2_state\":\"\",'+
	    '\"hoyo_basyo2_city\":\"\",'+
	    '\"hoyo_basyo2_street\":\"\",'+
	    '\"hoyo_date1\":\"\",'+
	    '\"hoyo_hour1\":\"\",'+
	    '\"hoyo_date2\":\"\",'+
	    '\"hoyo_hour2\":\"\",'+
	    '\"hoyo_date3\":\"\",'+	    
	    '\"hoyo_hour3\":\"\",'+
	    '\"hoyo\":\"\",'+
	    '\"tsuika_hoyo\":\"\",'+
	    '\"kaimyo_kibo\":\"\",'+
	    '\"kaimyo_plan\":\"\",'+
	    '\"customer_comment\":\"\",'+
	    '\"kakunin_renraku_kibo\":\"高田馬場\"' + 
	    '}';

	    Test.startTest();
	        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/api/v1/obousanbin_moushikomi';
        req.httpMethod = 'POST';
	    req.requestBody = Blob.valueof(json);

        RestContext.request = req;
        RestContext.response= res;
        
        Api_V1_ObousanbinMoushikomi.doPost();
	    
	        
        Test.stopTest();
	}

}