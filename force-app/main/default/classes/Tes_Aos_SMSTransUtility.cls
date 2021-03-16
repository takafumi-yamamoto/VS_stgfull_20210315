@isTest
private class Tes_Aos_SMSTransUtility {

	@isTest
	static void test_method_one() {

		RecordType customerRecordType = [SELECT Id FROM RecordType WHERE DeveloperName = 'Customer' LIMIT 1];

	    // 相談者
	    Account acc = new Account(
							      LastName  = '相談者セイ',
							      FirstName = '相談者メイ',
							      MobilePhone__c = '010-1111-1111',
							      RecordTypeId = customerRecordType.Id
					     	    );
		insert acc;

		Opportunity opp = new Opportunity(
											Name = 'シンプル安豪-商談',
											StageName = '問合せ受付',
											AccountId = acc.Id,
											CloseDate = Date.today(),
											TaishoushaJokyo__c = '_'
										 );

	    insert opp;


	    SMSHistory__c aos = new SMSHistory__c();
	    insert aos;

	    List<Aos_SMSTransUtility.AosSmsMessage> theAosSmsMessages = new List<Aos_SMSTransUtility.AosSmsMessage>();

	    Aos_SMSTransUtility.AosSmsMessage smsM = new Aos_SMSTransUtility.AosSmsMessage();  
	    smsM.ClientTag ='"Campaign,20170619103746,0000001,3209,270516,' + acc.TorihikisakiBangoF__c + '"';
	    smsM.PhoneNumber = '08037653209';
	    smsM.Message = 'テスト本文';
	    theAosSmsMessages.add(smsM);

	    Test.setMock(HttpCalloutMock.class, new Tes_AosSMSMockHttpResponseGenerator());

	    Test.StartTest();
	    Aos_SMSTransUtility.sendAosSmsMessages(theAosSmsMessages);
        Test.StopTest();
	}

}