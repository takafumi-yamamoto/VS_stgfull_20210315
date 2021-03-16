@isTest
private class ObouYoyakuCaseToShodanTaskFlbT {
	
	@isTest static void test_method_one() {
		Insert new ObouYoyakuCaseToShodanTask__c(ShoriStatus__c = 'Created');
		Test.startTest();
		new ObouYoyakuCaseToShodanTaskFlb().scheduleNew();
        Test.stopTest();
	}
}