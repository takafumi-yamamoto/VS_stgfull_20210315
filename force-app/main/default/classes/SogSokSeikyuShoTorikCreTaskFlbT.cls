@isTest
private class SogSokSeikyuShoTorikCreTaskFlbT {
	
	@isTest static void test_method_one() {
		Insert new SogSok_SeikyuSho_TorikCreTask__c(ShoriStatus__c = 'Created');
		Test.startTest();
		new SogSokSeikyuShoTorikCreTaskFlb().scheduleNew();
        Test.stopTest();
	}
	
}