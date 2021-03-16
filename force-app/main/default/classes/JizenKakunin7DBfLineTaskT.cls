@isTest
private class JizenKakunin7DBfLineTaskT {

    @isTest
    static void myUnitTest() {

        Test.StartTest();

        JizenKakunin7DBfLineTask__c task = new JizenKakunin7DBfLineTask__c(
                        ShoriStatus__c = 'Created'
            );
        insert task;
        new JizenKakunin7DBfLineTask(task.Id).execute(null);

        Test.StopTest();
    }
}