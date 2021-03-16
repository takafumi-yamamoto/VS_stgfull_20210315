@isTest
private class Tes_Aos_SMSSendingMessage {

	@isTest
	static void test_method_one() {

    Account acc = new Account(
      Name = 'TEST',
      MobilePhone__c = '020-1111-11111'
      );
    insert acc;

    Opportunity opp = new Opportunity(
      Name = 'TEST',
      StageName = '問合せ受付',
      CloseDate =  date.Today(),
      AccountId = acc.Id,
      TaishoushaJokyo__c = '_'
      );

    insert opp;

    SMSHistory__c aos = new SMSHistory__c();
    insert aos;

    Test.setMock(HttpCalloutMock.class, new Tes_AosSMSMockHttpResponseGenerator());
      PageReference pageRef = Page.AosSMSSendingMessage;
      pageRef.getParameters().put('id', opp.Id);
    Test.setCurrentPage(pageRef);

    Test.StartTest();
     ApexPages.StandardController stdController = new ApexPages.StandardController(opp);
    Aos_SMSSendingMessage aosSend = new Aos_SMSSendingMessage(stdController);
    aosSend.sendText = 'TEST';
    aosSend.SendAosSMSMessage();

      Test.StopTest();
    }


}