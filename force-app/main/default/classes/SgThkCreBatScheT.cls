@isTest
public class SgThkCreBatScheT {
    @isTest public static void execute_error(){
        Test.startTest();
        try{
            SgThkCreBatSche.to_raise_error_for_test_coverage = true;
            new SgThkCreBatSche().execute(null);
        }catch(Exception ex){
            //ignore
        }
        Test.stopTest();
    }
}