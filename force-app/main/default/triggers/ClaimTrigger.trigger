trigger ClaimTrigger on Claim__c (
	before insert, 
	before update, 
	before delete, 
	after insert, 
	after update, 
	after delete, 
	after undelete) {

	if(Utility_Common.isDataIkouProfile()){return;}

    if(!TriggerIsActive__c.getOrgDefaults().isActive__c){return;}

    Trg_Claim handler = new Trg_Claim();

	if (Trigger.isUpdate && Trigger.isAfter) {
	   	handler.OnAfterUpdate(Trigger.new, Trigger.oldMap);
	}
}