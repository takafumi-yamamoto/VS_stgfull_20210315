trigger ShisetsuTrigger  on Shisetsu__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

    if(Utility_Common.isDataIkouProfile()){return;}

    if(!TriggerIsActive__c.getOrgDefaults().isActive__c){return;}
    Trg_Shisetsu handler = new Trg_Shisetsu(Trigger.isExecuting, Trigger.size);

    if(Trigger.isBefore && Trigger.isInsert) handler.OnBeforeInsert(Trigger.new);
    if(Trigger.isBefore && Trigger.isUpdate) handler.OnBeforeUpdate(Trigger.new, Trigger.oldMap);

    if(Trigger.isAfter && Trigger.isInsert) handler.OnAfterInsert(Trigger.new, Trigger.oldMap);
    if(Trigger.isAfter && Trigger.isUpdate) handler.OnAfterUpdate(Trigger.new, Trigger.oldMap);
    if(Trigger.isAfter && Trigger.isDelete) handler.OnAfterDelete(Trigger.oldMap); 
}