@isTest
private class JizenKakunin1DBfLineTaskT {

    @isTest
    static void myUnitTest() {

        Test.StartTest();

        JizenKakunin1DBfLineTask__c task = new JizenKakunin1DBfLineTask__c(
                        ShoriStatus__c = 'Created'
            );
        insert task;
        new JizenKakunin1DBfLineTask(task.Id).execute(null);

        Test.StopTest();
    }
}