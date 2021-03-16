trigger SogSok_SokyakuTrigger on SogSok_Sokyaku__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

    if(Utility_Common.isDataIkouProfile()){return;}

    SogSok_SokyakuTrigher handler = new SogSok_SokyakuTrigher(Trigger.isExecuting, Trigger.size);
    
    if(Trigger.isBefore && Trigger.isInsert) handler.OnBeforeInsert(Trigger.new);
    if(Trigger.isBefore && Trigger.isDelete) handler.OnBeforeDelete(Trigger.oldMap);
    
    if(Trigger.isAfter && Trigger.isInsert) handler.OnAfterInsert(Trigger.new);

    
}