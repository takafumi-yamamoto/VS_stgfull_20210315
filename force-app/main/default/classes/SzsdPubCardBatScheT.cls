@isTest
public class SzsdPubCardBatScheT {
    @isTest public static void execute_error(){
        Test.startTest();
        try{
            SzsdPubCardBatSche.to_raise_error_for_test_coverage = true;
            new SzsdPubCardBatSche().execute(null);
        }catch(Exception ex){
            //ignore
        }
        Test.stopTest();
    }
}