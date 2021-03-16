trigger NebikiShoninShinseiTrigger on NebikiShoninShinsei__c  (
	before insert, 
	before update, 
	before delete, 
	after insert, 
	after update, 
	after delete, 
	after undelete) {

	if(Utility_Common.isDataIkouProfile()){return;}

	if(!TriggerIsActive__c.getOrgDefaults().isActive__c){return;}

	NebikiShoninShinsei handler = new NebikiShoninShinsei();

	if (Trigger.isUpdate && Trigger.isAfter) {
		handler.OnAfterUpdate(Trigger.new, Trigger.oldMap);
	}
}