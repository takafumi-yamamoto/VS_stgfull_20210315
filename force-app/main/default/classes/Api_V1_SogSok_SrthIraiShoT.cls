@isTest
private class Api_V1_SogSok_SrthIraiShoT {
	
	@isTest static void test_method_one() {		
		String json = '';
		
	    Test.startTest();
	        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/api/v1/sogsok/srthiraisho';
        req.httpMethod = 'POST';
	    req.requestBody = Blob.valueof(json);

        RestContext.request = req;
        RestContext.response= res;
        
        Api_V1_SogSok_SrthIraiSho.doPost();

	    
        Test.stopTest();
	}
	
	@isTest static void test_method_2() {		
		String json = '{'
+ '\"doc_status\":\"draft\",'
+ '\"kinyu_date\":\"2018-09-17\",'
+ '\"moshu\":{\"addr_city\":\"目黒区\",'
+ '\"addr_postal_code\":\"153-0042\",'
+ '\"addr_state\":\"東京都\",'
+ '\"addr_street\":\"青葉台\",'
+ '\"mei\":\"お客さん\",'
+ '\"mei_kana\":\"お客さん\",'
+ '\"mobile\":\"2018/08/31\",'
+ '\"phone\":\"2018/08/31\",'
+ '\"sei\":\"お客さん\",'
+ '\"sei_kana\":\"お客さん\",'
+ '\"torihikisaki_bango\":\"ACNT-0412831\"},'
+ '\"renrakujiko\":\"aqaaa3333\",'
+ '\"shodan_bango\":\"0427357\",'
+ '\"sodansha\":'
+ '{\"mei\":\"お客さん\",'
+ '\"sei\":\"お客さん\",'
+ '\"torihikisaki_bango\":\"ACNT-0412831\"},'
+ '\"sogi\":{\"kaso_datetime\":null,'
+ '\"kasoba_address\":null,'
+ '\"kasoba_name\":null,'
+ '\"kasoba_phone\":null,'
+ '\"kokubetsushiki_datetime\":\"2018-09-03 00:00:00\",'
+ '\"shikijo_address\":null,'
+ '\"shikijo_name\":null,'
+ '\"shikijo_phone\":null,'
+ '\"shonanoka\":null,'
+ '\"tsuya_datetime\":null},'
+ '\"soryo_tehai\":{\"kaimyo\":\"信女\",'
+ '\"kingaku\":0,'
+ '\"makurakyo\":null,'
+ '\"plan\":null},'
+ '\"soukyaku_bango\":\"SSK-00000133\",'
+ '\"soukyakusaki\":{\"tantosha_fax\":null,'
+ '\"tantosha_name\":null,'
+ '\"tantosha_tel\":null,'
+ '\"torihikisaki_bango\":\"ACNT-0412830\",'
+ '\"torihikisaki_name\":\"金子葬儀社\"},'
+ '\"taishosha\":{\"age\":0,'
+ '\"birth_date\":\"2018-08-31\",'
+ '\"bodaiji_umu\":\"無\",'
+ '\"death_date\":\"2018-08-01\",'
+ '\"mei\":\"お客さん\",'
+ '\"mei_kana\":\"お客さん\",'
+ '\"sei\":\"お客さん\",'
+ '\"sei_kana\":\"お客さん\",'
+ '\"shuha\":\"jodoshinshuhonganjiha\",'
+ '\"shuha_sonotaShuha\":\"2018/08/31\",'
+ '\"torihikisaki_bango\":\"ACNT-0412831\",'
+ '\"zokugara_from_moshu\":\"otto\"}'
+ '}';
		
	    Test.startTest();
	        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/api/v1/sogsok/srthiraisho';
        req.httpMethod = 'POST';
	    req.requestBody = Blob.valueof(json);

        RestContext.request = req;
        RestContext.response= res;
        
        //正常
        Api_V1_SogSok_SrthIraiSho.doPost();

	    
        Test.stopTest();
	}
	
	@isTest static void test_method_3() {
		SogSok_SrthIraiSho__c pSource = new Api_V1_SogSok_SrthIraiSho_Data().createSogSokSrthIraiSho(new Api_V1_SogSok_SrthIraiSho_Data.SrthIraiSho());
		new Api_V1_SogSok_SrthIraiSho_Data().createSrthIraiShoDto(pSource);
	}
	
}