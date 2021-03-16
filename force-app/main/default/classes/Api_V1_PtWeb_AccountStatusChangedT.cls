@isTest
private class Api_V1_PtWeb_AccountStatusChangedT {
	
	@isTest static void test_Api_V1_PtWeb_AccountStatusChanged() {
		Insert new TriggerIsActive__c( name='default', isActive__c=true );

		String json =  '{'
+ '        \"torihikisaki_bango\": \"202\",'
+ '        \"email\": \"203\",'
+ '        \"status\": \"201\"'
+ '      }';

	    Test.startTest();
	        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/api/v1/ptwebs/account_statuschanged';
        req.httpMethod = 'POST';
	    req.requestBody = Blob.valueof(json);

        RestContext.request = req;
        RestContext.response= res;
        
		Api_V1_PtWeb_AccountStatusChanged.doPost();

		Api_V1_PtWeb_AccountStatusChanged.ResBodyOnErr resBodyOnErr = new Api_V1_PtWeb_AccountStatusChanged.ResBodyOnErr();
		resBodyOnErr.addEntry('code', 'msg');
		
        Test.stopTest();

	}


	@isTest static void test_PtWebAccounts_ActivatingWebAccount() {
		Insert new TriggerIsActive__c( name='default', isActive__c=true );

		PtWebAccountStatusChanged__c ptWebAccountStatusChanged0 = new PtWebAccountStatusChanged__c();
		ptWebAccountStatusChanged0.torihikisaki_bango__c = 'ACNT-0412384';
		ptWebAccountStatusChanged0.mailaddress__c = 'test+etsdtet20180904@yoriso.com';
		ptWebAccountStatusChanged0.status__c = 'activated';
		ptWebAccountStatusChanged0.ShoriStatus__c = 'Created';
		insert ptWebAccountStatusChanged0;
		
	    Test.startTest();
	    PtWebAccounts_ActivatingWebAccount.subscriveOnAyncBrokerOnRunRequested(PtWebAccounts_ActivatingWebAccount.PtWebAccounts_ActivatingWebAccountTask.Class.toString());
		
        Test.stopTest();

	}
}