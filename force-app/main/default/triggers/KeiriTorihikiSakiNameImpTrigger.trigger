trigger KeiriTorihikiSakiNameImpTrigger on KeiriTorihikiSakiNameImp__c (before insert) {

    if(Utility_Common.isDataIkouProfile()){return;}

    if(!TriggerIsActive__c.getOrgDefaults().isActive__c && !Test.isRunningTest()){return;}

    KeiriTorihikiSakiNameImpTrg handler = new KeiriTorihikiSakiNameImpTrg(Trigger.isExecuting, Trigger.size);
     if(Trigger.isInsert && Trigger.isBefore){
        handler.OnBeforeInsert(Trigger.new);
    }
}