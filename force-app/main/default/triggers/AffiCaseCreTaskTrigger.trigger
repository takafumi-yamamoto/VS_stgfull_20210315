trigger AffiCaseCreTaskTrigger on AffiCaseCreTask__c (before insert, before update, before delete, after insert, after update) {
    if(Utility_Common.isDataIkouProfile()){return;}
    if(!TriggerIsActive__c.getOrgDefaults().isActive__c){return;}
    AffiCaseCreTaskTrigHer handler = new AffiCaseCreTaskTrigHer(Trigger.isExecuting, Trigger.size);

    if(Trigger.isAfter && Trigger.isInsert) handler.OnAfterInsert(Trigger.new);
    
    if(Trigger.isAfter && Trigger.isUpdate) handler.OnAfterUpdate(Trigger.new, Trigger.oldMap);
}