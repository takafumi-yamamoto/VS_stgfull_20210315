@isTest
public class TeiHehDaiKakinsSchT {
	@isTest 
	private static void execute() {
		Test.startTest();
		new TeiHehDaiKakinsSch().execute(null);
		Test.stopTest();
	}

	@isTest 
	private static void execute_exception() {
		TeiHehDaiKakinsSch.i_will_raise_error_in_run_for_errHandleTest = true;
		Test.startTest();
		new TeiHehDaiKakinsSch().execute(null);
		Test.stopTest();
	}

	@isTest 
	private static void run() {
		Test.startTest();
		new TeiHehDaiKakinsSch().run();
		Test.stopTest();
	}
}