trigger OboDashinResTaskTrigger on OboDashinResTask__c (before insert, before update, before delete, after insert, after update) {
    if(Utility_Common.isDataIkouProfile()){return;}
    if(!TriggerIsActive__c.getOrgDefaults().isActive__c){return;}

    if(Trigger.isAfter && Trigger.isInsert) OboDashinResTasks.onOboDashinResAfterInseted(Trigger.new);
    if(Trigger.isAfter && Trigger.isUpdate) OboDashinResTasks.onOboDashinResAfterUpdated(Trigger.new, Trigger.oldMap);
}