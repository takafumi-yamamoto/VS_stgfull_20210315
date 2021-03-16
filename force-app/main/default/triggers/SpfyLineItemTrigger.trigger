trigger SpfyLineItemTrigger on SpfyLineItem__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

    if(Trigger.isBefore && Trigger.isInsert) {
        //this should be applied always
        for(SpfyLineItem__c aNewOne : Trigger.new){
            if(String.isBlank(aNewOne.idfr__c) ) aNewOne.idfr__c = GuidUtil.NewGuid();
        }
    }

    if(Utility_Common.isDataIkouProfile()){return;}
    if(!TriggerIsActive__c.getOrgDefaults().isActive__c){return;}
}