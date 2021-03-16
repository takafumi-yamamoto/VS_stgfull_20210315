trigger JizenKakunin7DBfLineTaskTrigger on JizenKakunin7DBfLineTask__c (after insert, after update) {

    if(Trigger.isInsert && Trigger.isAfter){
        JizenKakunin7DBfLineTasks.onJizenKakunin7DBfLineTaskAfterInsert(Trigger.new);
    }
    else if(Trigger.isUpdate && Trigger.isAfter){
        JizenKakunin7DBfLineTasks.onJizenKakunin7DBfLineTaskAfterUpdate(Trigger.new, Trigger.oldMap);
    }
}