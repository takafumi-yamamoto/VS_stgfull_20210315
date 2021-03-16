@isTest
private class Tes_AccountChangeTaskProcessReqTrigger {
	
	@isTest static void test_method_one() {
		AccountChangedTask__c task = new AccountChangedTask__c();
		insert task;
		AccountChangeTaskProcessReq__e e = new AccountChangeTaskProcessReq__e();
		e.TaskId__c = task.Id;

		Test.startTest();
		Database.SaveResult theSaveResults = EventBus.publish(e);
		Test.stopTest();

		System.assertEquals(true, theSaveResults.isSuccess());

	}
	
	
}