@isTest
public class AcrtDrTackBatActivatorT {
    @isTest public static void scheduleNew(){
        Test.startTest();
        AcrtDrTackBatActivator.scheduleNew();
        Test.stopTest();
    }
    @isTest public static void scheduleNew_error(){
        Test.startTest();
        AcrtDrTackBatActivator.to_raise_error_for_test_coverage = true;
        try{
            AcrtDrTackBatActivator.scheduleNew();
        }catch(Exception ex){
            //ignore
        }
        
        Test.stopTest();
    }
}