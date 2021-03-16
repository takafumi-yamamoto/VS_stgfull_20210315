@isTest
private class AsyncBrokerRetryerT {
	
	@isTest static void test_method_one() {

		Insert new AsyncBrokerReqPended__c(RequestName__c = 'TestRequest', ShoriStatus__c = 'Created');
		Test.startTest();
		String theNextTimeCron = DateTime.now().addMinutes(1).format('s m H d M ? y');
        System.schedule('AsyncBrokerRetryer' + '(' + theNextTimeCron + ')', theNextTimeCron, new AsyncBrokerRetryer() );
        Test.stopTest();
	}
	
	
}