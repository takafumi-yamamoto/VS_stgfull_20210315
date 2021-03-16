trigger NpTorihikiDataImpTaskTrigger on NpTorihikiDataImpTask__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    if(Utility_Common.isDataIkouProfile()){return;}
    if(!TriggerIsActive__c.getOrgDefaults().isActive__c){return;}
    NpTorihikiDataImpTaskTrigher handler = new NpTorihikiDataImpTaskTrigher(Trigger.isExecuting, Trigger.size);

    if(Trigger.isAfter && Trigger.isInsert) handler.onAfterInsert(Trigger.new);
    
    if(Trigger.isAfter && Trigger.isUpdate) handler.onAfterUpdate(Trigger.new, Trigger.oldMap);
}