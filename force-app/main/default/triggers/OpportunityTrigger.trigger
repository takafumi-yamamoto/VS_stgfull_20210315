trigger OpportunityTrigger on Opportunity (after delete, after insert, after undelete,  after update, before delete, before insert, before update) {
    
    if(Utility_Common.isDataIkouProfile()){return;}

    if(!TriggerIsActive__c.getOrgDefaults().isActive__c && !Test.isRunningTest()){return;}

    if(!Trg_Opportunity.isActive) {return;}

    Trg_Opportunity handler = new Trg_Opportunity(Trigger.isExecuting, Trigger.size);
     if(Trigger.isInsert && Trigger.isBefore){
        handler.OnBeforeInsert(Trigger.new);
    }
    else if(Trigger.isInsert && Trigger.isAfter){
        handler.OnAfterInsert(Trigger.new);
    }
    else if(Trigger.isUpdate && Trigger.isBefore){
        handler.OnBeforeUpdate(Trigger.new, Trigger.oldMap);
    }
    else if(Trigger.isUpdate && Trigger.isAfter){
        handler.OnAfterUpdate(Trigger.new,Trigger.old,Trigger.oldMap);
    }
    else if(Trigger.isDelete && Trigger.isBefore){
        //handler.OnBeforeDelete(Trigger.old, Trigger.oldMap);
    }
    else if(Trigger.isDelete && Trigger.isAfter){
    //  handler.OnAfterDelete(Trigger.old, Trigger.oldMap);
    }
    else if(Trigger.isUnDelete){
//      handler.OnUndelete(Trigger.new);
    }

}