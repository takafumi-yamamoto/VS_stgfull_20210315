trigger SurveyQuestionRespTrigger on SurveyQuestionResponse__c (after insert) {
    if(Utility_Common.isDataIkouProfile()){return;}
    if(!TriggerIsActive__c.getOrgDefaults().isActive__c){return;}

    Trg_SurveyQuestionResp handler = new Trg_SurveyQuestionResp(Trigger.isExecuting, Trigger.size);
    if(Trigger.isAfter && Trigger.isInsert) {
        handler.OnAfterInsert(Trigger.new);
    }
}