@isTest
public class SgJzAnMdKrTsNsBatActivatorT {
	@isTest public static void scheduleNew(){
		Test.startTest();
		Integer theInterval = 1;
		String theNextTimeCron = DateTime.now().addMinutes(theInterval).format('s m H d M ? y');
		System.schedule('SgJzAnMdKrTsNsBatActivator : TEST', theNextTimeCron, new SgJzAnMdKrTsNsBatActivator() );
		Test.stopTest();
	}
	@isTest public static void scheduleNew_error(){
		Test.startTest();
		SgJzAnMdKrTsNsBatActivator.to_raise_error_for_test_coverage = true;
		try{
			Integer theInterval = 1;
			String theNextTimeCron = DateTime.now().addMinutes(theInterval).format('s m H d M ? y');
			System.schedule('SgJzAnMdKrTsNsBatActivator : TEST', theNextTimeCron, new SgJzAnMdKrTsNsBatActivator() );
		}catch(Exception ex){
			//ignore
		}
		
		Test.stopTest();
	}
}