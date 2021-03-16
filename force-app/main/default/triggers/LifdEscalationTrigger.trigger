trigger LifdEscalationTrigger on LifdEscalation__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    if(Utility_Common.isDataIkouProfile()){return;}
    if(!TriggerIsActive__c.getOrgDefaults().isActive__c){return;}

    LifdEscalationTrg.IHandler handler = LifdEscalationTrg.get_Handler_instane(Trigger.isExecuting, Trigger.size);

    if(Trigger.isAfter && Trigger.isInsert) handler.onAfterInsert(Trigger.new);
}