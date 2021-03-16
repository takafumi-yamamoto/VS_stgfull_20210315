trigger TeiHehDaiKakinSchEntTrigger on TeiHehDaiKakinSchEnt__c (before insert, before update) {

    if(Utility_Common.isDataIkouProfile()){return;}

    if(!TriggerIsActive__c.getOrgDefaults().isActive__c && !Test.isRunningTest()){return;}

    TeiHehDaiKakinSchEntTrg handler = new TeiHehDaiKakinSchEntTrg(Trigger.isExecuting, Trigger.size);
    if(Trigger.isInsert && Trigger.isBefore){
        handler.OnBeforeInsert(Trigger.new);
    }
    else if(Trigger.isUpdate && Trigger.isBefore){
        handler.OnBeforeUpdate(Trigger.new, Trigger.oldMap);
    }
}