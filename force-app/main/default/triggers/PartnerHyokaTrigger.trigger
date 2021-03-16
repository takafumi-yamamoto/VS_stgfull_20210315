trigger PartnerHyokaTrigger on PartnerHyoka__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    

    if(Utility_Common.isDataIkouProfile()){return;}

    if(!TriggerIsActive__c.getOrgDefaults().isActive__c){return;}

    Trg_PartnerHyoka handler = new Trg_PartnerHyoka(Trigger.isExecuting, Trigger.size);

    if(Trigger.isAfter && Trigger.isUpdate) handler.OnAfterUpdate(Trigger.new,Trigger.oldMap);

}