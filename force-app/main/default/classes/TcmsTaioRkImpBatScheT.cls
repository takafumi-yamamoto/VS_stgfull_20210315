@isTest
public class TcmsTaioRkImpBatScheT {
    @isTest public static void execute_error() {
        Test.startTest();
        TcmsTaioRkImpBatSche.to_raise_error_for_test_coverage = true;
        new TcmsTaioRkImpBatSche().execute(null);
        Test.stopTest();
    }
}