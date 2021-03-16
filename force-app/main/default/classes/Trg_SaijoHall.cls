public with sharing class Trg_SaijoHall {
	private boolean m_isExecuting = false;
	private integer BatchSize = 0;
	public Trg_SaijoHall(boolean isExecuting, integer size){
	    m_isExecuting = isExecuting;
	    BatchSize = size;
	}

	public void OnBeforeInsert(List<SaijoHall__c> newList){
        SaijoHallRyokinUpdate.ryokinKoshinbiUpdate(newList, null);
	}
	public void OnBeforeUpdate(List<SaijoHall__c> newList, Map<ID, SaijoHall__c> oldMap){
        SaijoHallRyokinUpdate.ryokinKoshinbiUpdate(newList, oldMap);
	}
	public void OnAfterInsert(List<SaijoHall__c> newList){
        new SaijoHallCoreSyncTasks.TaskScheduler().scheduleTasksOnShisetsuAfterInsert(newList);
	}
	public void OnAfterUpdate(List<SaijoHall__c> newList, Map<ID, SaijoHall__c> oldMap){
        new SaijoHallCoreSyncTasks.TaskScheduler().scheduleTasksOnShisetsuAfterUpdate(newList);
	}
	public void OnAfterDelete(Map<ID, SaijoHall__c> oldMap){
		new SaijoHallCoreSyncTasks.TaskScheduler().scheduleTasksOnShisetsuAfterDelete(oldMap.values());
	}
}