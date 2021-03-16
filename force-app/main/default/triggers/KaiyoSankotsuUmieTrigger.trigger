trigger KaiyoSankotsuUmieTrigger on KaiyoSankotsuUmie__c (after delete, after insert, after undelete,  after update, before delete, before insert, before update) {

    if(Utility_Common.isDataIkouProfile()){return;}
    
    if(!TriggerIsActive__c.getOrgDefaults().isActive__c){return;}


    Trg_KaiyoSankotsuUmie handler = new Trg_KaiyoSankotsuUmie();
    if(Trigger.isInsert && Trigger.isBefore){
        //System.debug('★★★start-isInsert★★★');
        // handler.OnBeforeInsert(Trigger.new);
    }
    else if(Trigger.isInsert && Trigger.isAfter){
        //System.debug('★★★start-isAfterInsert★★★');
        handler.OnAfterInsert(Trigger.new);
    }
    else if(Trigger.isUpdate && Trigger.isBefore){
        handler.OnBeforeUpdate(Trigger.new, Trigger.oldMap);
    }
    else if(Trigger.isUpdate && Trigger.isAfter){
        handler.OnAfterUpdate(Trigger.new,Trigger.oldMap);
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