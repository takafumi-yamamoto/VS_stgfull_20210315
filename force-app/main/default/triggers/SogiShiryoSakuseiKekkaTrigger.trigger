trigger SogiShiryoSakuseiKekkaTrigger on SogiShiryoSakuseiKekka__c (after delete, after insert, after undelete,  after update, before delete, before insert, before update) {
    if(Utility_Common.isDataIkouProfile()){return;}

    if(!TriggerIsActive__c.getOrgDefaults().isActive__c && !Test.isRunningTest()){return;}

    if(Trigger.isUpdate && Trigger.isAfter){
        SogiShiryoSakuseiKekkaTsuchi.OnAfterUpdate(Trigger.new, Trigger.oldMap);
    }
}