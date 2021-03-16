@isTest
private class SogSokSrthIraiShoTorikCreTaskFlbT {
	
	@isTest static void test_method_one() {
		Insert new SogSok_SrthIraiSho_TorikCreTask__c(ShoriStatus__c = 'Created');
		Test.startTest();
		new SogSokSrthIraiShoTorikCreTaskFlb().scheduleNew();
        Test.stopTest();
	}
	
}