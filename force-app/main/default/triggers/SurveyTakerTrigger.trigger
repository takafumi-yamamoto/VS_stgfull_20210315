trigger SurveyTakerTrigger on SurveyTaker__c (before insert, after update) {

    if(Utility_Common.isDataIkouProfile()){return;}
    if(!TriggerIsActive__c.getOrgDefaults().isActive__c){return;}

    Trg_SurveyTaker handler = new Trg_SurveyTaker(Trigger.isExecuting, Trigger.size);
    if (Trigger.isBefore && Trigger.isInsert) {
        handler.OnBeforeInsert(Trigger.new);
    }
    if (Trigger.isAfter && Trigger.isUpdate) {
        handler.OnAfterUpdate(Trigger.new, Trigger.oldMap);
    }
}