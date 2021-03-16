trigger KeiyakuTrigger on Keiyaku__c (after delete, after insert, after undelete,  after update, before delete, before insert, before update) {
    if(Utility_Common.isDataIkouProfile()){return;}
    if(!TriggerIsActive__c.getOrgDefaults().isActive__c){return;}
    Trg_Keiyaku handler = new Trg_Keiyaku(Trigger.isExecuting, Trigger.size);

    if(Trigger.isBefore && Trigger.isInsert) handler.OnBeforeInsert(Trigger.new);
    if(Trigger.isBefore && Trigger.isUpdate) handler.OnBeforeUpdate(Trigger.new,Trigger.oldMap);
    if(Trigger.isBefore && Trigger.isDelete) handler.OnBeforeDelete(Trigger.old);

    if(Trigger.isAfter && Trigger.isInsert) handler.OnAfterInsert(Trigger.new);
    if(Trigger.isAfter && Trigger.isUpdate) handler.OnAfterUpdate(Trigger.new,Trigger.oldMap);


}