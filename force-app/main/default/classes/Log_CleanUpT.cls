@isTest
public class Log_CleanUpT {
    @isTest public static void CleanUpper_clena_up() {
        Test.startTest();
        new Log_CleanUp.CleanUpper().clena_up();
        Test.stopTest();
    }
    @isTest public static void CleanUpper_execute_err() {
        Test.startTest();
        Log_CleanUp.to_raise_error_for_test_coverage = true;
        try{
            new Log_CleanUp().execute(null);
        }catch(Exception ex){
            //ignore
        }
        Test.stopTest();
    }
}