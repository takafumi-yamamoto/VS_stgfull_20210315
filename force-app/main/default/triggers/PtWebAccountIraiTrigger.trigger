trigger PtWebAccountIraiTrigger on PtWebAccountIrai__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    if(Utility_Common.isDataIkouProfile()){return;}
    if(!TriggerIsActive__c.getOrgDefaults().isActive__c){return;}
    Trg_PtWebAccountIrai handler = new Trg_PtWebAccountIrai(Trigger.isExecuting, Trigger.size);

    if(Trigger.isBefore && Trigger.isInsert) handler.OnBeforeInsert(Trigger.new);
 
    if(Trigger.isAfter && Trigger.isUpdate) handler.OnBeforeUpdate(Trigger.new);
    if(Trigger.isAfter && Trigger.isUpdate) handler.OnAfterUpdate(Trigger.new, Trigger.oldMap);
}