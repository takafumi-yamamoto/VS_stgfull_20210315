trigger QmsTrigger on Qms__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

    if(Utility_Common.isDataIkouProfile()){return;}
    if(!TriggerIsActive__c.getOrgDefaults().isActive__c){return;}

    if(Trigger.isBefore && Trigger.isInsert){
        QmsChain.onQmsBeforeInsert(Trigger.new);

        for(Qms__c aQms : Trigger.new){
            if(aQms.ScheduledAt__c == null) aQms.ScheduledAt__c = Datetime.now();
        }
    }

    if(Trigger.isAfter && Trigger.isInsert) QmsEvtPublisher.onQmsAfterInserted(Trigger.new);

}