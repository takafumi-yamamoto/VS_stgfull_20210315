@isTest
private class DashinViewT {

    @testSetup
    static void setup() {
        DashinTestData.dashin_test_data_init();
        DashinTestData.init_DashIraiHist();
    }

    @isTest
    static void test_doInit() {
        Test.StartTest();
        Id oppId = [Select Id, OppRef__c From DashIraiHist__c Limit 1].get(0).OppRef__c;
        DashinView.doInit(oppId);

        Test.StopTest();
    }

    @isTest
    static void test_doOfferCancel() {
        Test.StartTest();
        Id oppId = [Select Id, OppRef__c From DashIraiHist__c Limit 1].get(0).OppRef__c;
        DashinView.doOfferCancel(oppId);
        Test.StopTest();
    }

    @isTest
    static void test_doOfferCancel_null() {
        Test.StartTest();
        Id oppId = [Select Id From Opportunity Where Name like 'NULL%' Limit 1].get(0).Id;
        DashinView.doOfferCancel(oppId);
        Test.StopTest();
    }
}