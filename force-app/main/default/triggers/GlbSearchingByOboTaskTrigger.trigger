trigger GlbSearchingByOboTaskTrigger on GlbSearchingByOboTask__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    if(Utility_Common.isDataIkouProfile()){return;}
    if(!TriggerIsActive__c.getOrgDefaults().isActive__c){return;}
    GlbSearchingByOboTaskTrigher handler = new GlbSearchingByOboTaskTrigher(Trigger.isExecuting, Trigger.size);

    if(Trigger.isAfter && Trigger.isInsert) handler.OnAfterInsert(Trigger.new);
    
    if(Trigger.isAfter && Trigger.isUpdate) handler.OnAfterUpdate(Trigger.new, Trigger.oldMap);
}