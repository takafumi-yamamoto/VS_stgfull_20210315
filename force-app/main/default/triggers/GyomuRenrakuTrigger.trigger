trigger GyomuRenrakuTrigger on GyomuRenraku__c (before insert, before update) {

	if(Utility_Common.isDataIkouProfile()){return;}
    if(!TriggerIsActive__c.getOrgDefaults().isActive__c){return;}

    Trg_GyomuRenraku handler = new Trg_GyomuRenraku(Trigger.isExecuting, Trigger.size);

    if(Trigger.isBefore && Trigger.isInsert) handler.OnBeforeInsert(Trigger.new);
    if(Trigger.isBefore && Trigger.isUpdate) handler.OnBeforeUpdate(Trigger.new, Trigger.oldMap);
}