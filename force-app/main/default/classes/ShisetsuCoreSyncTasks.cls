public class ShisetsuCoreSyncTasks {

    public class SendingToCore implements Queueable,Database.AllowsCallouts{
        public Id TaskId { get; private set; }

        public SendingToCore(Id pTaskId){ this.TaskId = pTaskId; }

        public void execute(QueueableContext context) { this.run(); }

        public void run(){

            List<ShisetsuCoreSyncTask__c> theTasks = new List<ShisetsuCoreSyncTask__c>(
                [
                    select Id, MessageBody__c, EndPoint__c
                    from ShisetsuCoreSyncTask__c
                    where Id = :this.TaskId
                ]
            );
            if(theTasks.size() <= 0) return;
            ShisetsuCoreSyncTask__c theTask = theTasks.get(0);

            Boolean isError = false;
            try{
                if(RsCoreApi_Configs.getConfig().IsShisetsuRenkeiYuko__c){  
                    HttpRequest request = new HttpRequest();
                    request.setEndpoint(theTask.EndPoint__c);
                    request.setMethod('PUT');
                    request.setHeader('Content-Type', 'application/json;charset=UTF-8');
                    request.setBody(theTask.MessageBody__c);
                    RsCoreApi_AuthClients.getInstance().setAuthHeader(request);
                    HttpResponse response = new http().send(request);
                    Integer theStatusCode = response.getStatusCode();
                    theTask.ResponseDateTime__c = Datetime.now();
                    theTask.ResponseStatusCode__c = theStatusCode;
                    if(theStatusCode!=200) isError = true;
                }
            }catch(Exception e){
                isError = true;
                theTask.StausDescr__c = e.getMessage();
                System.Debug(theTask.StausDescr__c);
            }
            theTask.Status__c = isError ? 'Faulted' : 'Completed';
            Update theTask;
        }
    }

    public class TaskScheduler{

        private void scheduleRunningOfTasks(List<ShisetsuCoreSyncTask__c> pTasks){
            Insert pTasks;
            List<ShisetsuCoreSyncTaskRunReq__e> theRunReqs = new List<ShisetsuCoreSyncTaskRunReq__e>();
            for(ShisetsuCoreSyncTask__c aTask : pTasks){
                theRunReqs.add( new ShisetsuCoreSyncTaskRunReq__e(TaskId__c = aTask.Id) );
            }
            List<Database.SaveResult> theSaveResults = EventBus.publish(theRunReqs);
            for (Database.SaveResult aResult : theSaveResults) {
                if(!aResult.isSuccess()){
                    for(Database.Error aError : aResult.getErrors()) {
                        System.debug('Error returned: ' + aError.getStatusCode() + ' - ' + aError.getMessage());
                    }
                }
            }
        }
        public void scheduleTasksOnShisetsuAfterUpdate(List<Shisetsu__c> newOnes, Map<ID, Shisetsu__c> oldOnes){
            this.scheduleRunningOfTasks( this.createSyncTasks(newOnes, false) );
        }
        public void scheduleTasksOnShisetsuAfterDelete(List<Shisetsu__c> oldOnes){
            this.scheduleRunningOfTasks( this.createSyncTasks(oldOnes, true) );
        }
        private List<ShisetsuCoreSyncTask__c> createSyncTasks(List<Shisetsu__c> pShisetsus, Boolean pIsDelete){
            List<ShisetsuCoreSyncTask__c> theTasks = new List<ShisetsuCoreSyncTask__c>();
            for(Shisetsu__c aShisetsu : pShisetsus){
                theTasks.add( this.createSyncTaskForKasoba( aShisetsu, pIsDelete ) );
                theTasks.add( this.createSyncTaskForSaijo( aShisetsu, pIsDelete ) );
            }
            return theTasks;
        }
        private ShisetsuCoreSyncTask__c createSyncTaskForKasoba(Shisetsu__c aShisetsu, Boolean pIsDelete){
            Long theFacilityId = aShisetsu.KasobaKeisaiJohoId__c == null ? 0 : Long.valueOf(aShisetsu.KasobaKeisaiJohoId__c);
            return new ShisetsuCoreSyncTask__c(
                EndPoint__c=RsCoreApi_Configs.getConfig().EndPoint__c + '/manager/api/facility/' +  theFacilityId,
                facilityId__c = theFacilityId,
                ShisetsuRef__c = pIsDelete ? null : aShisetsu.Id,
                MessageBody__c = new RsCoreApi_Facilities().createFacilityInfoKasobaJson(aShisetsu, pIsDelete)
            );
        }
        private ShisetsuCoreSyncTask__c createSyncTaskForSaijo(Shisetsu__c aShisetsu, Boolean pIsDelete){
            Long theFacilityId = aShisetsu.SaijoKeisaiJohoId__c == null ? 0 : Long.valueOf(aShisetsu.SaijoKeisaiJohoId__c);
            return new ShisetsuCoreSyncTask__c(
                EndPoint__c=RsCoreApi_Configs.getConfig().EndPoint__c + '/manager/api/facility/' + theFacilityId,
                facilityId__c = theFacilityId,
                ShisetsuRef__c = pIsDelete ? null : aShisetsu.Id,
                MessageBody__c = new RsCoreApi_Facilities().createFacilityInfoSaijoJson(aShisetsu, pIsDelete)
            );
        }
    }
}