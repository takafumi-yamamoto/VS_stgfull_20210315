trigger SogiShaTokuyakutenTesuryoTrigger on SogiShaTokuyakutenTesuryo__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    if(Utility_Common.isDataIkouProfile()){return;}
    if(!TriggerIsActive__c.getOrgDefaults().isActive__c){return;}

    Trg_SogiShaTokuyakutenTesuryo.IHandler handler = Trg_SogiShaTokuyakutenTesuryo.get_Handler_instane(Trigger.isExecuting, Trigger.size);

    if(Trigger.isAfter && Trigger.isInsert) handler.on_after_insert(Trigger.new);
    if(Trigger.isAfter && Trigger.isUpdate) handler.on_after_update(Trigger.new, Trigger.oldMap);
    if(Trigger.isAfter && Trigger.isDelete) handler.on_after_delete(Trigger.oldMap);

}