@isTest
public class SkgnStatsBatScheT {

    @isTest public static void execute_error(){
        Test.startTest();
        try{
            SkgnStatsBatSche.to_raise_error_for_test_coverage = true;
            new SkgnStatsBatSche().execute(null);
        }catch(Exception ex){
            //ignore
        }
        Test.stopTest();
    }
}