@isTest
private class DashinIraiHistControllerT {

    @testSetup
    static void setup() {
        DashinTestData.dashin_test_data_init();
        DashinTestData.init_DashIraiHist();
    }

    @isTest
    static void myUnitTest() {
        Test.StartTest();
        Id oppId = [Select Id, OppRef__c From DashIraiHist__c Limit 1].get(0).OppRef__c;
        DashinIraiHistController.doInit(oppId);
        Test.StopTest();
    }
}