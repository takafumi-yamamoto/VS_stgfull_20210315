trigger KrshTesRyoMeiTrigger on KrshTesRyoMei__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

    if(Utility_Common.isDataIkouProfile()){return;}
    if(!TriggerIsActive__c.getOrgDefaults().isActive__c){return;}
    KrshTesRyoMeiTrg handler = new KrshTesRyoMeiTrg(Trigger.isExecuting, Trigger.size);

    if(Trigger.isBefore && Trigger.isInsert) handler.onBeforeInsert(Trigger.new);
    if(Trigger.isBefore && Trigger.isUpdate) handler.onBeforeUpdate(Trigger.new, Trigger.oldMap);
    if(Trigger.isAfter && Trigger.isInsert) handler.onAfterInsert(Trigger.new);
    if(Trigger.isAfter && Trigger.isUpdate) handler.onAfterUpdate(Trigger.new, Trigger.oldMap);
}