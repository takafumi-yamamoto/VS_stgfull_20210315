trigger SmsDlrTrigger on SmsDlr__c (after insert) {
    if(Utility_Common.isDataIkouProfile()){return;}

    if(!TriggerIsActive__c.getOrgDefaults().isActive__c){return;}

    SmsDlrTrigher handler = new SmsDlrTrigher();

    if(Trigger.isInsert && Trigger.isAfter){
        handler.OnAfterInsert(Trigger.new);
    }

}