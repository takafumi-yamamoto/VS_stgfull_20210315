trigger NcpSzkSdnShkCardTrigger on NcpSzkSdnShkCard__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    if(Utility_Common.isDataIkouProfile()){return;}
    if(!TriggerIsActive__c.getOrgDefaults().isActive__c){return;}

    NcpSzkSdnShkCardTrg.IHandler handler = NcpSzkSdnShkCardTrg.get_Handler_instane(Trigger.isExecuting, Trigger.size);

    if(Trigger.isBefore && Trigger.isInsert) handler.on_before_insert(Trigger.new);
}