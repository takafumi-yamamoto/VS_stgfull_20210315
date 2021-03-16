trigger EventTrigger on Event (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

    if(Utility_Common.isDataIkouProfile()){return;}
    
    if(!TriggerIsActive__c.getOrgDefaults().isActive__c){return;}

    Trg_Event handler = new Trg_Event();

    if(Trigger.isInsert && Trigger.isBefore){
        handler.OnBeforeInsert(Trigger.new, null);
    }
    else if(Trigger.isInsert && Trigger.isAfter){
        handler.OnAfterInsert(Trigger.new);
    }
    else if(Trigger.isUpdate && Trigger.isAfter){
        handler.OnAfterUpdate(Trigger.new,Trigger.oldMap);
    }
    else if(Trigger.isDelete && Trigger.isAfter){
        handler.OnAfterDelete(Trigger.old, Trigger.oldMap);
    }
    /*
    else if(Trigger.isUpdate && Trigger.isBefore){
        
    }
    else if(Trigger.isDelete && Trigger.isBefore){
        
    }
    else if(Trigger.isUnDelete){
    
    }*/
}