trigger CaseSurveyViscaTrigger on CaseSurveyVisca__c (after insert) {

    if(Utility_Common.isDataIkouProfile()){return;}
    if(!TriggerIsActive__c.getOrgDefaults().isActive__c){return;}

    Trg_CaseSurveyVisca handler = new Trg_CaseSurveyVisca(Trigger.isExecuting, Trigger.size);
    if (Trigger.isAfter && Trigger.isInsert) {
        handler.OnAfterInsert(Trigger.new);
    }
}