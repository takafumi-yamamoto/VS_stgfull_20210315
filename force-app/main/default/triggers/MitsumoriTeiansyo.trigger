trigger MitsumoriTeiansyo on MitsumoriTeiansyo__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

    if(Utility_Common.isDataIkouProfile()){return;}
    if(!TriggerIsActive__c.getOrgDefaults().isActive__c){return;}
    Trg_MitsumoriTeiansyo handler = new Trg_MitsumoriTeiansyo(Trigger.isExecuting, Trigger.size);

    if(Trigger.isBefore && Trigger.isInsert) handler.OnBeforeInsert(Trigger.new);

    if(Trigger.isAfter && Trigger.isInsert) handler.OnAfterInsert(Trigger.new);
}