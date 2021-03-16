@isTest
public class JizenKakuninSmsTask_CleanUpT {

    @isTest public static void CleanUpper_clena_up() {
        Test.startTest();
        new JizenKakuninSmsTask_CleanUp.CleanUpper().clena_up();
        Test.stopTest();
    }
    @isTest public static void CleanUpper_execute_err() {
        Test.startTest();
        JizenKakuninSmsTask_CleanUp.to_raise_error_for_test_coverage = true;
        try{
            new JizenKakuninSmsTask_CleanUp().execute(null);
        }catch(Exception ex){
            //ignore
        }
        Test.stopTest();
    }
}