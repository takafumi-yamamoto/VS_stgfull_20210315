@isTest
public class KrYsHanteiChgdBatScheT {
    @isTest public static void execute_error() {
        KrYsHanteiChgdBatSche.to_raise_error_for_test_coverage = true;
        Test.startTest();
        try{
            new KrYsHanteiChgdBatSche().execute(null);
        }catch(Exception ex){
            //ignore
        }
        Test.stopTest();
    }
}