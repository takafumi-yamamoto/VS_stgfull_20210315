trigger OkyakusamaSeikyuMeisaiTrigger on OkyakusamaSeikyuMeisai__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

    if(Utility_Common.isDataIkouProfile()){return;}
    
    if(!TriggerIsActive__c.getOrgDefaults().isActive__c){return;}

    Trg_OkyakusamaSeikyuMeisai handler = new Trg_OkyakusamaSeikyuMeisai(Trigger.isExecuting, Trigger.size);

    if(Trigger.isBefore && Trigger.isInsert) handler.OnBeforeInsert(Trigger.new);
    if(Trigger.isBefore && Trigger.isUpdate) handler.OnBeforeUpdate(Trigger.new, Trigger.oldMap);
    if(Trigger.isBefore && Trigger.isDelete) handler.OnBeforeDelete(Trigger.old);
    
    if(Trigger.isAfter && Trigger.isInsert) handler.OnAfterInsert(Trigger.new);
    if(Trigger.isAfter && Trigger.isUpdate) handler.OnAfterUpdate(Trigger.new, Trigger.oldMap);
    if(Trigger.isAfter && Trigger.isDelete) handler.OnAfterDelete(Trigger.old);

}