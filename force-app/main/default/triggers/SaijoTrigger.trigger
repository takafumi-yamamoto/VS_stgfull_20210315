trigger SaijoTrigger on Saijo__c (	before insert, before update, after insert, after update, after delete) {

	if(Utility_Common.isDataIkouProfile()){return;}
    if(!TriggerIsActive__c.getOrgDefaults().isActive__c){return;}

    Trg_Saijo handler = new Trg_Saijo(Trigger.isExecuting, Trigger.size);

    if(Trigger.isBefore && Trigger.isInsert) handler.OnBeforeInsert(Trigger.new);
    if(Trigger.isBefore && Trigger.isUpdate) handler.OnBeforeUpdate(Trigger.new, Trigger.oldMap);
    if(Trigger.isAfter && Trigger.isInsert) handler.OnAfterInsert(Trigger.new);
    if(Trigger.isAfter && Trigger.isUpdate) handler.OnAfterUpdate(Trigger.new, Trigger.oldMap);
    if(Trigger.isAfter && Trigger.isDelete) handler.OnAfterDelete(Trigger.oldMap);
    
}