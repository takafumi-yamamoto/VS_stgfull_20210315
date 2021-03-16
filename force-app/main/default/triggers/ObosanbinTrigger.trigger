trigger ObosanbinTrigger on Obosanbin__c (after delete, after insert, after undelete,  after update, before delete, before insert, before update) {

    if(Utility_Common.isDataIkouProfile()){return;}
    
    if(!TriggerIsActive__c.getOrgDefaults().isActive__c){return;}

    Trg_Obosanbin handler = new Trg_Obosanbin(Trigger.isExecuting, Trigger.size);
    if(Trigger.isInsert && Trigger.isBefore){      
        handler.OnBeforeInsert(Trigger.new);    
    }
    else if(Trigger.isInsert && Trigger.isAfter){
        handler.OnAfterInsert(Trigger.new);
    }
    else if(Trigger.isUpdate && Trigger.isBefore){    
        handler.OnBeforeUpdate(Trigger.new,Trigger.oldMap);    
    }
    else if(Trigger.isUpdate && Trigger.isAfter){
        handler.OnAfterUpdate(Trigger.new,Trigger.oldMap);
    
    }
    else if(Trigger.isDelete && Trigger.isBefore){
       
    }
    else if(Trigger.isDelete && Trigger.isAfter){

    }
    else if(Trigger.isUnDelete){
    }

}