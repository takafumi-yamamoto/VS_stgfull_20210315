trigger AnegKekImpDataTrigger on AnegKekImpData__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

    if(Utility_Common.isDataIkouProfile()){return;}
    if(!TriggerIsActive__c.getOrgDefaults().isActive__c){return;}

    if(Trigger.isAfter && Trigger.isInsert) AnegKekImpQms.onAnegKekImpDataAfterInserted(Trigger.new);
}