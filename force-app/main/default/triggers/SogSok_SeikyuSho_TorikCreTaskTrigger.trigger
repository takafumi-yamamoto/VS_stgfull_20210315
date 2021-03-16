trigger SogSok_SeikyuSho_TorikCreTaskTrigger on SogSok_SeikyuSho_TorikCreTask__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    if(Utility_Common.isDataIkouProfile()){return;}
    if(!TriggerIsActive__c.getOrgDefaults().isActive__c){return;}
    SogSok_SeikyuSho_TorikCreTaskTrigHer handler = new SogSok_SeikyuSho_TorikCreTaskTrigHer(Trigger.isExecuting, Trigger.size);

    if(Trigger.isAfter && Trigger.isInsert) handler.OnAfterInsert(Trigger.new);
    
    if(Trigger.isAfter && Trigger.isUpdate) handler.OnAfterUpdate(Trigger.new, Trigger.oldMap);
}