public class SaijoCoreSyncTasks {

    public class TaskScheduler{
        public void scheduleTasksOnShisetsuAfterUpdate(List<Saijo__c> saijoList){
            INSERT SaijoSyncQms.createPostQmses(saijoList);
        }
        public void scheduleTasksOnShisetsuAfterDelete(List<Saijo__c> saijoList){
            INSERT SaijoSyncQms.createDeleteQmses(saijoList);
        }
    }
}