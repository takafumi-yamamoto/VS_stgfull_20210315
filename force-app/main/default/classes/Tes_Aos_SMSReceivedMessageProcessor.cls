@isTest
private class Tes_Aos_SMSReceivedMessageProcessor {

	@isTest
	static void test_method_one(){

        RestRequest req = new RestRequest();
        RestResponse res = RestContext.response;

        String resparam = '{"moNotification":{"dateTime":"' + Datetime.Now() + '","clientId":"621","smsCode":"80760","phoneNumber":"+811011111111","carrierId":"105","carrierName":"Softbank","message":"あああああ"}}';
        Blob requestBodyBlob = Blob.valueOf(json.serialize(resparam, true));

		req.requestBody = requestBodyBlob;
		req.requestURI = '/v1/aossms/messagereceived';
		req.resourcePath = '/services/apexrest/v1/aossms/messagereceived';
		req.httpMethod = 'POST';
		RestContext.request = req;
		RestCOntext.response = res;


		RecordType customerRecordType = [SELECT Id FROM RecordType WHERE DeveloperName = 'Customer' LIMIT 1];
		RecordType soryoRecordType    = [SELECT Id FROM RecordType WHERE DeveloperName = 'SoryoAccount' LIMIT 1];

	    Account acc = new Account(
	      LastName  = '相談者セイ',
	      FirstName = '相談者メイ',
	      MobilePhone__c = '010-1111-1111',
	      RecordTypeId = customerRecordType.Id
	      );
	    insert acc;

	    Account monk = new Account(
	      Name  = '僧侶セイ 僧侶メイ',
	      MobilePhone__c = '010-1111-1111',
	      RecordTypeId = soryoRecordType.Id
	      );
	    insert monk;

	    Test.startTest();
	    Aos_SMSReceivedMessageProcessor aos = new Aos_SMSReceivedMessageProcessor(); /*Constructor Coverage*/
	    Aos_SMSReceivedMessageProcessor.MessageReceived();
	    Test.stopTest();
	}

	@isTest
	 static void test_method_two() {

	    Test.startTest();
	    Aos_SMSReceivedMessageProcessor.MessageReceived();
	    Test.stopTest();
	}
}