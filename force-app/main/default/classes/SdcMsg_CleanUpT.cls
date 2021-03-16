@isTest
public class SdcMsg_CleanUpT {
    @isTest public static void CleanUpper_clena_up() {
        Test.startTest();
        new SdcMsg_CleanUp.CleanUpper().clena_up();
        Test.stopTest();
    }
    @isTest public static void CleanUpper_execute_err() {
        Test.startTest();
        SdcMsg_CleanUp.to_raise_error_for_test_coverage = true;
        try{
            new SdcMsg_CleanUp().execute(null);
        }catch(Exception ex){
            //ignore
        }
        Test.stopTest();
    }
}