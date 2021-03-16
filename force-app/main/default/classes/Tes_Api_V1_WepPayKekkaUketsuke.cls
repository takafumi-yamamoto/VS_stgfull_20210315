@isTest
private class Tes_Api_V1_WepPayKekkaUketsuke {
    static testMethod void testMethod1() {


        String json = '{' +
'    \"seikyu_bango\":\"SKBG-0000000155\",' +
'    \"status\":\"error\",' +
'    \"errors\":[' +
'        {' +
'            \"error_code\":\"42G020000\",' +
'            \"error_descr\":\"カード会社オーソリエラー\"' +
'        },' +
'        {' +
'            \"error_code\":\"42G020000\",' +
'            \"error_descr\":\"カード会社オーソリエラー\"' +
'        }' +
'    ]' +
'}';

	    Test.startTest();
	        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/api/v1/webpay/kekka';
        req.httpMethod = 'POST';
	    req.requestBody = Blob.valueof(json);

        RestContext.request = req;
        RestContext.response= res;
        
        Api_V1_WepPayKekkaUketsuke.kekka();
	    
	        
        Test.stopTest();
    }


    static testMethod void testMethod2() {


        String json = '{' +
'    \"seikyu_bango\":\"SKBG-0000000155\",' +
'    \"status\":\"error\",' +
'    \"errors\":[' +
'        {' +
'            \"error_code\":\"42G020000\",' +
'            \"error_descr\":\"カード会社オーソリエラー\"' +
'        },' +
'        {' +
'            \"error_code\":\"42G020000\",' +
'            \"error_descr\":\"カード会社オーソリエラー\"' +
'        }' +
'    ]' ;

        Test.startTest();
            
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/api/v1/webpay/kekka';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(json);

        RestContext.request = req;
        RestContext.response= res;
        
        Api_V1_WepPayKekkaUketsuke.kekka();
        
            
        Test.stopTest();
    }
}