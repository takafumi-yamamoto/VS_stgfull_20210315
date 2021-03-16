trigger LeadTrigger on Lead (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    

    if(Utility_Common.isDataIkouProfile()){return;}
    if(!TriggerIsActive__c.getOrgDefaults().isActive__c){return;}
    Trg_Lead handler = new Trg_Lead(Trigger.isExecuting, Trigger.size);


    if(Trigger.isBefore && Trigger.isInsert) handler.OnBeforeInsert(Trigger.new);
    if(Trigger.isAfter && Trigger.isUpdate) handler.OnAfterUpdated(Trigger.new, Trigger.oldMap);
}