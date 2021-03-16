trigger ShisetsuCoreSyncTaskRunReqTrigger on ShisetsuCoreSyncTaskRunReq__e (after insert) {

    for(ShisetsuCoreSyncTaskRunReq__e event : Trigger.New){
        Set<String> theTaskIds = new Set<String>();
        if(event.TaskId__c != null) theTaskIds.add(event.TaskId__c);

        List<ShisetsuCoreSyncTask__c> theTasks = new List<ShisetsuCoreSyncTask__c>(
            [
                select Id, Status__c
                from ShisetsuCoreSyncTask__c 
                where Id = :theTaskIds
            ]
        );

        for(ShisetsuCoreSyncTask__c aTask : theTasks){
            aTask.Status__c = 'Running';
        }

        Update theTasks;
    }
}