trigger EmailMessageTrigger on EmailMessage (after insert,after update) {
    System.Debug( 'EmailMessage' );
    if(Utility_Common.isDataIkouProfile()){return;}
    
    if(!TriggerIsActive__c.getOrgDefaults().isActive__c){return;}

    Trg_EmailMessage handler = new Trg_EmailMessage();

    if(Trigger.isInsert && Trigger.isBefore){
        //System.debug('★★★start-isInsert★★★');
        //handler.OnBeforeInsert(Trigger.new);
    }else if(Trigger.isInsert && Trigger.isAfter){
        //System.debug('★★★start-isAfterInsert★★★');
        handler.OnAfterInsert(Trigger.new);
    // } else if(Trigger.isUpdate && Trigger.isBefore){
    //     //handler.OnBeforeUpdate(Trigger.new, Trigger.oldMap);
    // }
    }else if(Trigger.isUpdate && Trigger.isAfter){
        System.debug('**==**== EmailMessageTrigger after update ==**==**');
        handler.OnAfterUpdate(Trigger.new,Trigger.oldMap);
    // } else if(Trigger.isDelete && Trigger.isBefore){
    //     //handler.OnBeforeDelete(Trigger.old, Trigger.oldMap);
    // } else if(Trigger.isDelete && Trigger.isAfter){
    //     // handler.OnAfterDelete(Trigger.old, Trigger.oldMap);
    // } else if(Trigger.isUnDelete){
    //     // handler.OnUndelete(Trigger.new);
    }
    
}