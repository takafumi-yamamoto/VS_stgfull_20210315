trigger JizenwariTrigger on Jizenwari__c (before insert, before update, after insert, after update) {

    if(Utility_Common.isDataIkouProfile()){return;}
    
    System.debug('★★★JizenwariTrigger★★★');
    if(!TriggerIsActive__c.getOrgDefaults().isActive__c){return;}

    Trg_Jizenwari handler = new Trg_Jizenwari();

    if( Trigger.isAfter && Trigger.isUpdate){
        handler.onAfterUpdate(Trigger.new, Trigger.oldMap);
    }
}