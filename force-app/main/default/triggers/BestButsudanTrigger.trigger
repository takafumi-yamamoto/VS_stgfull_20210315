trigger BestButsudanTrigger on BestButsudan__c (after delete, after insert, after undelete,  after update, before delete, before insert, before update) {

    if(Utility_Common.isDataIkouProfile()){return;}
    if(!TriggerIsActive__c.getOrgDefaults().isActive__c){return;}

    Trg_BestButsudan handler = new Trg_BestButsudan();
    if(Trigger.isAfter && Trigger.isUpdate) handler.onAfterUpdate(Trigger.new,Trigger.oldMap);

}