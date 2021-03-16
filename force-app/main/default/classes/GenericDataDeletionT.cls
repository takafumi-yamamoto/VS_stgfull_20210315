@isTest
private class GenericDataDeletionT {
	
	@isTest static void test_method_one() {

		Account a = new Account( Name = '_');
        insert a;

        Test.startTest();
		GenericDataDeletion.executionDelete(a.Id);
		Test.stopTest();
	}
	
}