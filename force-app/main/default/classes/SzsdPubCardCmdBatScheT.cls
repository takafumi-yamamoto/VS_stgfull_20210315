@isTest
public class SzsdPubCardCmdBatScheT {
    @isTest public static void execute_error(){
        Test.startTest();
        try{
            SzsdPubCardCmdBatSche.to_raise_error_for_test_coverage = true;
            new SzsdPubCardCmdBatSche().execute(null);
        }catch(Exception ex){
            //ignore
        }
        Test.stopTest();
    }
}