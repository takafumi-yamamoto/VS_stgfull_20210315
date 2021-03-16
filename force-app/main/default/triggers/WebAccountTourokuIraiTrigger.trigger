trigger WebAccountTourokuIraiTrigger on WebAccountTourokuIrai__c (after insert,before insert, before update) {
    
    System.debug('★★★WebAccountTourokuIraiTrigger★★★');
    if(!TriggerIsActive__c.getOrgDefaults().isActive__c){return;}

    Trg_WebAccountTourokuIrai handler = new Trg_WebAccountTourokuIrai();

    if(Trigger.isInsert && Trigger.isBefore){
         handler.OnBeforeInsert(Trigger.new);
    }
    if(Trigger.isUpdate && Trigger.isBefore) handler.OnBeforeUpdate(Trigger.new);

    if(Trigger.isInsert && Trigger.isAfter){
         handler.OnAfterInsert(Trigger.new);
    }
}