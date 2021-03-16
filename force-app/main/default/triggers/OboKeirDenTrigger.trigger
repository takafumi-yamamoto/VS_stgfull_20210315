trigger OboKeirDenTrigger on OboKeirDen__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    if(Utility_Common.isDataIkouProfile()){return;}
    if(!TriggerIsActive__c.getOrgDefaults().isActive__c){return;}
    OboKeirDenTrigher handler = new OboKeirDenTrigher(Trigger.isExecuting, Trigger.size);

    if(Trigger.isBefore && Trigger.isInsert) handler.onBeforeInsert(Trigger.new);
    if(Trigger.isBefore && Trigger.isUpdate) handler.onBeforeUpdate(Trigger.new, Trigger.oldMap);
}