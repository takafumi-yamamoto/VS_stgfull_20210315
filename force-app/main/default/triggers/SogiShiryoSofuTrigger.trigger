trigger SogiShiryoSofuTrigger on SogiShiryoSofu__c (after delete, after insert, after undelete,  after update, before delete, before insert, before update) {

    if(Utility_Common.isDataIkouProfile()){return;}

    if(!TriggerIsActive__c.getOrgDefaults().isActive__c && !Test.isRunningTest()){return;}

    if(Trigger.isInsert && Trigger.isBefore){ 
        SogiShiryoSofuInitialProcessing.OnBeforeInsert(Trigger.new);
    }
    else if(Trigger.isUpdate && Trigger.isBefore){
        SogiShiryoSofuInitialProcessing.OnBeforeUpdate(Trigger.new);
    }
    else if(Trigger.isUpdate && Trigger.isAfter){
        SogiShiryoSofuSofuzumiProcessing.OnAfterUpdate(Trigger.new, Trigger.oldMap);
    }
}