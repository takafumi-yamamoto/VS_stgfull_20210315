trigger ContactTrigger on Contact (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    

    if(Utility_Common.isDataIkouProfile()){return;}

    if(!TriggerIsActive__c.getOrgDefaults().isActive__c){return;}

    Trg_Contact handler = new Trg_Contact(Trigger.isExecuting, Trigger.size);


    if(Trigger.isInsert && Trigger.isBefore){
        handler.OnBeforeInsert(Trigger.new, null);
    }
    else if(Trigger.isUpdate && Trigger.isBefore){
    	handler.OnBeforeUpdate(Trigger.new, Trigger.oldMap);
    }
    /*else if(Trigger.isInsert && Trigger.isAfter){

    }
    else if(Trigger.isUpdate && Trigger.isAfter){

    }
    else if(Trigger.isDelete && Trigger.isBefore){

    }
    else if(Trigger.isDelete && Trigger.isAfter){

    }
    else if(Trigger.isUnDelete){

    }*/

}