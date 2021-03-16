@isTest
private class SogSokMitsumoriShoTorikCreTaskFlbT {
	
	@isTest static void test_method_one() {
		Insert new SogSok_MitsumoriSho_TorikCreTask__c(ShoriStatus__c = 'Created');
		Test.startTest();
		new SogSokMitsumoriShoTorikCreTaskFlb().scheduleNew();
        Test.stopTest();
	}
	
}