trigger SeizenKeiyakuTrigger on SeizenKeiyaku__c (before insert, before update, after insert, after update) {

    if(Utility_Common.isDataIkouProfile()){return;}
    
    System.debug('★★★SeizenKeiyakuTrigger ★★★');
    if(!TriggerIsActive__c.getOrgDefaults().isActive__c){return;}

    Trg_SeizenKeiyaku handler = new Trg_SeizenKeiyaku();
    
    if((Trigger.isInsert || Trigger.isUpdate) && Trigger.isAfter){
        handler.OnAfterInsertUpdate(Trigger.new, Trigger.oldMap);
    }

    if( Trigger.isAfter && Trigger.isUpdate){
        handler.onAfterUpdate(Trigger.new, Trigger.oldMap);
    }
}