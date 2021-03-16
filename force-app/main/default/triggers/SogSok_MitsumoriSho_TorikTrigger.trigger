trigger SogSok_MitsumoriSho_TorikTrigger on SogSok_MitsumoriSho_Torik__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    if(Utility_Common.isDataIkouProfile()){return;}
    SogSok_MitsumoriSho_TorikTrigHer handler = new SogSok_MitsumoriSho_TorikTrigHer(Trigger.isExecuting, Trigger.size);

    if(Trigger.isAfter && Trigger.isUpdate) handler.OnAfterUpdate(Trigger.new, Trigger.oldMap);
}