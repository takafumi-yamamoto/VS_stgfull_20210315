@isTest
public class LwsnJizenJunbisScheT {

	@isTest 
	private static void execute() {
		Test.startTest();
		new LwsnJizenJunbisSche().execute(null);
		Test.stopTest();
	}

	@isTest 
	private static void execute_exception() {
		LwsnJizenJunbisSche.i_will_raise_error_in_run_for_errHandleTest = true;
		Test.startTest();
		new LwsnJizenJunbisSche().execute(null);
		Test.stopTest();
	}

	@isTest 
	private static void run() {
		Test.startTest();
		new LwsnJizenJunbisSche().run();
		Test.stopTest();
	}
}