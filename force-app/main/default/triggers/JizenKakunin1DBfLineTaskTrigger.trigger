trigger JizenKakunin1DBfLineTaskTrigger on JizenKakunin1DBfLineTask__c (after insert, after update) {

    if(Trigger.isInsert && Trigger.isAfter){
        JizenKakunin1DBfLineTasks.onJizenKakunin1DBfLineTaskAfterInsert(Trigger.new);
    }
    else if(Trigger.isUpdate && Trigger.isAfter){
        JizenKakunin1DBfLineTasks.onJizenKakunin1DBfLineTaskAfterUpdate(Trigger.new, Trigger.oldMap);
    }
}