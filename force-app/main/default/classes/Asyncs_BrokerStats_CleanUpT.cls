@isTest
public class Asyncs_BrokerStats_CleanUpT {

    @isTest public static void CleanUpper_clena_up() {
        Test.startTest();
        new Asyncs_BrokerStats_CleanUp.CleanUpper().clena_up();
        Test.stopTest();
    }
    @isTest public static void CleanUpper_execute_err() {
        Test.startTest();
        Asyncs_BrokerStats_CleanUp.to_raise_error_for_test_coverage = true;
        try{
            new Asyncs_BrokerStats_CleanUp().execute(null);
        }catch(Exception ex){
            //ignore
        }
        Test.stopTest();
    }

}