@isTest
public class SgJzAnBatActivatorT {
	@isTest public static void scheduleNew(){
		Test.startTest();
		SgJzAnBatActivator.scheduleNew();
		Test.stopTest();
	}
	@isTest public static void scheduleNew_error(){
		Test.startTest();
		SgJzAnBatActivator.to_raise_error_for_test_coverage = true;
		try{
			SgJzAnBatActivator.scheduleNew();
		}catch(Exception ex){
			//ignore
		}
		
		Test.stopTest();
	}
}