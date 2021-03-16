trigger ShikugunTrigger  on Shikugun__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    if(!TriggerIsActive__c.getOrgDefaults().isActive__c){return;}
    Trg_Shikugun handler = new Trg_Shikugun(Trigger.isExecuting, Trigger.size);
    if(Trigger.isInsert && Trigger.isBefore){
        //handler.OnBeforeInsert(Trigger.new);
    }
    else if(Trigger.isInsert && Trigger.isAfter){
        handler.OnAfterInsert(Trigger.new);
    }
    else if(Trigger.isUpdate && Trigger.isBefore){
        //handler.OnBeforeUpdate(Trigger.old, Trigger.new, Trigger.newMap);
    }
    else if(Trigger.isUpdate && Trigger.isAfter){
        handler.OnAfterUpdate(Trigger.new,Trigger.oldMap);
    }
    else if(Trigger.isDelete && Trigger.isBefore){
        //handler.OnBeforeDelete(Trigger.old);
    }
    else if(Trigger.isDelete && Trigger.isAfter){
       //handler.OnAfterDelete(Trigger.old, Trigger.oldMap);
    }
    else if(Trigger.isUnDelete){
       //handler.OnUndelete(Trigger.new);
    }   
}