trigger SogSok_SeikyuSho_TorikTrigger on SogSok_SeikyuSho_Torik__c (after update) {
    if(Utility_Common.isDataIkouProfile()){return;}
    SogSok_SeikyuSho_TorikTrigHer handler = new SogSok_SeikyuSho_TorikTrigHer(Trigger.isExecuting, Trigger.size);

    if(Trigger.isAfter && Trigger.isUpdate) handler.OnAfterUpdate(Trigger.new, Trigger.oldMap);
}