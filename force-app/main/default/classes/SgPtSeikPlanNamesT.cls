@isTest
public class SgPtSeikPlanNamesT {
	@isTest
	static void doTest(){
		String theShohinBango = 'SBG-0001108';
		Decimal theAmount = 100000;
		String theDefault = '_';
		String theActual = null;
		Test.startTest();
			theActual = SgPtSeikPlanNames.getPlanName(theShohinBango, theAmount, theDefault);
		Test.stopTest();
	}
}