public class KasojoSogiReviSyncTasks {

    public class TaskScheduler{
        public void scheduleTasksOnShisetsuAfterUpdate(List<Shisetsu__c> kasojoList){
            INSERT KasojoSogiReviSyncQms.createPostQmses(kasojoList);
        }
        public void scheduleTasksOnShisetsuAfterDelete(List<Shisetsu__c> kasojoList){
            INSERT KasojoSogiReviSyncQms.createDeleteQmses(kasojoList);
        }
    }
}