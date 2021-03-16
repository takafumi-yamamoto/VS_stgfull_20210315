trigger TerapSgSeikTasksCmdTrigger on TerapSgSeikTasksCmd__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

    if(Utility_Common.isDataIkouProfile()){return;}
    if(!TriggerIsActive__c.getOrgDefaults().isActive__c){return;}

    if(Trigger.isBefore && Trigger.isInsert){
        Date theBillingYm;
        for(TerapSgSeikTasksCmd__c aNewOne : Trigger.new){
            theBillingYm = aNewOne.BillingYm__c;
        }
        TerapSgSeikTasks.start(theBillingYm.toStartOfMonth() );
    }

}