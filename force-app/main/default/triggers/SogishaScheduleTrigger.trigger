trigger SogishaScheduleTrigger on SogishaSchedule__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

	if(!TriggerIsActive__c.getOrgDefaults().isActive__c){return;}

	Ctl_SogishaSchedule handler = new Ctl_SogishaSchedule();
	if(Trigger.isInsert && Trigger.isBefore){
        handler.onBeforeInsert(Trigger.new);
    }
    else if(Trigger.isUpdate && Trigger.isBefore){
        handler.onBeforeUpdate(Trigger.new, Trigger.oldMap);
    }
}