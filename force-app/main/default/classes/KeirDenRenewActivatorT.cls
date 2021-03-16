@isTest
public class KeirDenRenewActivatorT {
	@isTest static void doTest_scheduleNew(){
		Test.startTest();
		KeirDenRenewActivator.scheduleNew();
		Test.stopTest();
	}
}