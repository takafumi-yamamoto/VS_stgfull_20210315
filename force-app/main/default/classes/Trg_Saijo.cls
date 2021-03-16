public class Trg_Saijo {

	private boolean m_isExecuting = false;
	private integer BatchSize = 0;
	public Trg_Saijo(boolean isExecuting, integer size){
	    m_isExecuting = isExecuting;
	    BatchSize = size;
	}

	public void OnBeforeInsert(List<Saijo__c> newList){
		SaijoValidation.validate(newList);
		SaijoInitialProcessing.processingInsert(newList);
	}

	public void OnBeforeUpdate(List<Saijo__c> newList, Map<Id, Saijo__c> oldMap){
		SaijoValidation.validate(newList);
		SaijoShokaiCheck.OnBeforeUpdate(newList);
		SaijoInitialProcessing.processingUpdate(newList, oldMap);
	}

	public void OnAfterInsert(List<Saijo__c> newList){
        //緯度経度を設定        
        Com_LatitudeAndLongitude.setLatitudeAndLongitudeMain(Saijo__c.getSObjectType().getDescribe().getName(), newList, null);
	}
	public void OnAfterUpdate(List<Saijo__c> newList, Map<ID, Saijo__c> oldMap){
        //緯度経度を設定        
    	Com_LatitudeAndLongitude.setLatitudeAndLongitudeMain(Saijo__c.getSObjectType().getDescribe().getName(), newList, oldMap);
		new SaijoCoreSyncTasks.TaskScheduler().scheduleTasksOnShisetsuAfterUpdate(newList);
		new SaijoSogiReviSyncTasks.TaskScheduler().scheduleTasksOnShisetsuAfterUpdate(newList);
	}
	public void OnAfterDelete(Map<ID, Saijo__c> oldMap){
		new SaijoCoreSyncTasks.TaskScheduler().scheduleTasksOnShisetsuAfterDelete(oldMap.values());
		new SaijoSogiReviSyncTasks.TaskScheduler().scheduleTasksOnShisetsuAfterDelete(oldMap.values());
	}
}