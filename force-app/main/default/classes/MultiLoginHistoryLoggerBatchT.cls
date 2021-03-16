@isTest
private class MultiLoginHistoryLoggerBatchT {

    @isTest static void test_method_all() {
        Test.startTest();
        System.schedule('MultiLoginHistoryLoggerBatchT',
                        '0 30 * * * ?',
                        new MultiLoginHistoryLoggerBatch());
        Test.stopTest();
    }
}