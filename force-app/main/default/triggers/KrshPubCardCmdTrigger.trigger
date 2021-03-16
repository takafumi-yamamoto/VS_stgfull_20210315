trigger KrshPubCardCmdTrigger on KrshPubCardCmd__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

    if(Utility_Common.isDataIkouProfile()){return;}
    if(!TriggerIsActive__c.getOrgDefaults().isActive__c){return;}

    KrshPubCardCmdTrg.IHandler handler = KrshPubCardCmdTrg.get_Handler_instane(Trigger.isExecuting, Trigger.size);

    if(Trigger.isBefore && Trigger.isInsert) handler.onBeforeInsert(Trigger.new);

}