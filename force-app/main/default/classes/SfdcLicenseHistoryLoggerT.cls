@isTest
private class SfdcLicenseHistoryLoggerT {

    @isTest static void test_method_all() {
        Test.startTest();
        System.schedule('SfdcLicenseHistoryLoggerT',
                        '0 30 * * * ?',
                        new SfdcLicenseHistoryLogger());
        Test.stopTest();
    }
}