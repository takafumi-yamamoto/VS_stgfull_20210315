@isTest
public class JucyuCoreSyncTasksBatchRunnerTest {

    @isTest(seeAllData=true)
    public static void whenExecuted_thenCreatedTaskShouldBeRunned(){

        Test.startTest();

        new JucyuCoreSyncTasksBatchRunner();

        Test.stopTest();
    }
}