public class Trg_AccountChangedTask {
    
	public void OnAfterInsert(List<AccountChangedTask__c> newList){
		List<AccountChangeTaskProcessReq__e> events = new List<AccountChangeTaskProcessReq__e>();
		for(AccountChangedTask__c aTask : newList){
			events.add(new AccountChangeTaskProcessReq__e(TaskId__c=aTask.Id));
		}
        List<Database.SaveResult> theSaveResults = EventBus.publish(events);
        for (Database.SaveResult aResult : theSaveResults) {
            if(!aResult.isSuccess()){
                for(Database.Error aError : aResult.getErrors()) {
                    System.debug('Error returned: ' + aError.getStatusCode() + ' - ' + aError.getMessage());
                }
            }
        }
	}
}