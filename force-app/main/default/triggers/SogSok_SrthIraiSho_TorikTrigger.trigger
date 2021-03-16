trigger SogSok_SrthIraiSho_TorikTrigger on SogSok_SrthIraiSho_Torik__c (before update, after update) {
    if(Utility_Common.isDataIkouProfile()){return;}
    SogSok_SrthIraiSho_TorikTrigHer handler = new SogSok_SrthIraiSho_TorikTrigHer(Trigger.isExecuting, Trigger.size);

    if(Trigger.isBefore && Trigger.isUpdate) handler.OnBeforeUpdate(Trigger.new, Trigger.newMap, Trigger.oldMap);
}