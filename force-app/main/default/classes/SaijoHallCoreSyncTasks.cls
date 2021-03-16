public class SaijoHallCoreSyncTasks {

    public class TaskScheduler{
    	public void scheduleTasksOnShisetsuAfterInsert(List<SaijoHall__c> saijoHallList){
            INSERT SaijoHallSyncQms.createPostQmses(saijoHallList);
        }
        public void scheduleTasksOnShisetsuAfterUpdate(List<SaijoHall__c> saijoHallList){
            INSERT SaijoHallSyncQms.createPostQmses(saijoHallList);
        }
        public void scheduleTasksOnShisetsuAfterDelete(List<SaijoHall__c> saijoHallList){
            INSERT SaijoHallSyncQms.createDeleteQmses(saijoHallList);
        }
    }
}