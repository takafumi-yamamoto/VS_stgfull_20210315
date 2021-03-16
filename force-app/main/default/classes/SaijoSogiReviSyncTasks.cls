public class SaijoSogiReviSyncTasks {

    public class TaskScheduler{
        public void scheduleTasksOnShisetsuAfterUpdate(List<Saijo__c> saijoList){
            INSERT SaijoSogiReviSyncQms.createPostQmses(saijoList);
        }
        public void scheduleTasksOnShisetsuAfterDelete(List<Saijo__c> saijoList){
            INSERT SaijoSogiReviSyncQms.createDeleteQmses(saijoList);
        }
    }
}