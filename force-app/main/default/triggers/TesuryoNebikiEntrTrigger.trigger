trigger TesuryoNebikiEntrTrigger on TesuryoNebikiEntry__c (after delete, after insert, after undelete,  after update, before delete, before insert, before update) {
    if(Utility_Common.isDataIkouProfile()){return;}
    if(!TriggerIsActive__c.getOrgDefaults().isActive__c){return;}

    Trg_TesuryoNebikiEntry handler = new Trg_TesuryoNebikiEntry(Trigger.isExecuting, Trigger.size);
     if(Trigger.isInsert && Trigger.isBefore){
        handler.OnBeforeInsert(Trigger.new);
    }
    else if(Trigger.isInsert && Trigger.isAfter){
        //handler.OnAfterInsert(Trigger.new);
    }
    else if(Trigger.isUpdate && Trigger.isBefore){
       handler.OnBeforeUpdate(Trigger.new, Trigger.oldMap);
    }
    else if(Trigger.isUpdate && Trigger.isAfter){
        //handler.OnAfterUpdate(Trigger.new,Trigger.oldMap);
    }
    else if(Trigger.isDelete && Trigger.isBefore){
        handler.OnBeforeDelete(Trigger.old);
    }
    else if(Trigger.isDelete && Trigger.isAfter){
    //  handler.OnAfterDelete(Trigger.old, Trigger.oldMap);
    }
    else if(Trigger.isUnDelete){
//      handler.OnUndelete(Trigger.new);
    }
}