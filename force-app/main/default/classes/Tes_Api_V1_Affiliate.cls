@isTest
private class Tes_Api_V1_Affiliate {
    static testMethod void testMethod1() {
        Test.startTest();
    	try {
    	    Api_V1_Affiliate.create();
    	}
    	catch (Exception ex) {
    		System.debug(ex);
    	}
    	Test.stopTest();
    }

    static testMethod void testMethod2() {
    	Insert new TriggerIsActive__c( name='default', isActive__c=true );

    	String json = '{ '
+ ' "client_id"  : "123456789000", '
+ ' "mailshori_id"  : "test201809071300", '
+ ' "parent_mailshori_id"  : "mail_syori_id_201809071300", '
+ ' "toiawase_date"  : "2018-09-07 15:04:01", '
+ ' "cust_name_sei"  : "姓姓姓201809071300", '
+ ' "cust_name_mei"  : "めいめいめい201809071300", '
+ ' "cust_name_sei_kana"  : "かなかなせい201809071300", '
+ ' "cust_name_mei_kana"  : "かなかなめい201809071300", '
+ ' "mail_address"  : "testtest+201809071300@yoriso.com", '
+ ' "tel_no"  : "080-8888-1000", '
+ ' "postal_code"  : "150-0001", '
+ ' "state"  : "東京都", '
+ ' "city"  : "品川区", '
+ ' "street"  : "五反田", '
+ ' "cust_comment"  : "cust_comment: test20180502-1000", '
+ ' "service"  : "相続相談" '
+ ' }';

    	Test.startTest();

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/api/v1/affiliate_uketsuke';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(json);

        RestContext.request = req;
        RestContext.response= res;
        
    	try {
    	    Api_V1_Affiliate.create();
    	}
    	catch (Exception ex) {
    		System.debug(ex);
    	}
    	Test.getEventBus().deliver();
    	Test.stopTest();
    }

    static testMethod void testMethod3() {
    	Insert new case(uniq_id__c='mail_syori_id_201809071300');
    	Insert new TriggerIsActive__c( name='default', isActive__c=true );

    	String json = '{ '
+ ' "client_id"  : "123456789000", '
+ ' "mailshori_id"  : "test201809071300", '
+ ' "parent_mailshori_id"  : "mail_syori_id_201809071300", '
+ ' "toiawase_date"  : "2018-09-07 15:04:01", '
+ ' "cust_name_sei"  : "姓姓姓201809071300", '
+ ' "cust_name_mei"  : "めいめいめい201809071300", '
+ ' "cust_name_sei_kana"  : "かなかなせい201809071300", '
+ ' "cust_name_mei_kana"  : "かなかなめい201809071300", '
+ ' "mail_address"  : "testtest+201809071300@yoriso.com", '
+ ' "tel_no"  : "080-8888-1000", '
+ ' "postal_code"  : "150-0001", '
+ ' "state"  : "東京都", '
+ ' "city"  : "品川区", '
+ ' "street"  : "五反田", '
+ ' "cust_comment"  : "cust_comment: test20180502-1000", '
+ ' "service"  : "相続相談" '
+ ' }';

    	Test.startTest();

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/api/v1/affiliate_uketsuke';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(json);

        RestContext.request = req;
        RestContext.response= res;
        
    	try {
    	    Api_V1_Affiliate.create();
    	}
    	catch (Exception ex) {
    		System.debug(ex);
    	}
    	Test.getEventBus().deliver();
    	Test.stopTest();
    }
}