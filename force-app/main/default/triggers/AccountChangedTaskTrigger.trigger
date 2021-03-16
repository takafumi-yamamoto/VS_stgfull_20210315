trigger AccountChangedTaskTrigger on AccountChangedTask__c (after insert) {
    if(Utility_Common.isDataIkouProfile()){return;}

    if(!TriggerIsActive__c.getOrgDefaults().isActive__c){return;}
    
    Trg_AccountChangedTask handler = new Trg_AccountChangedTask();
    
    if(Trigger.isInsert && Trigger.isAfter){
        System.debug('----Insert_After----');
        handler.OnAfterInsert(Trigger.new);
    }
}