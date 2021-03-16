trigger ShisetsuCoreSyncTaskTrigger on ShisetsuCoreSyncTask__c  (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

    if(Utility_Common.isDataIkouProfile()){return;}
    if(!TriggerIsActive__c.getOrgDefaults().isActive__c){return;}

    if(Trigger.isAfter && Trigger.isUpdate){
        for(ShisetsuCoreSyncTask__c aNewOne : Trigger.new){
            ShisetsuCoreSyncTask__c aOldOne = Trigger.oldMap.get(aNewOne.Id);
            if(aNewOne.Status__c == 'Running' && aNewOne.Status__c != aOldOne.Status__c){
                System.enqueueJob(
                    new ShisetsuCoreSyncTasks.SendingToCore(aNewOne.Id)
                );
            }
        }
    }

}