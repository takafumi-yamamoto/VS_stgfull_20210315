@isTest
private class PtWebApi_SeikyuTsuchiT {
	
	@isTest
	static void test_case1() {
		Insert new TriggerIsActive__c( name='default', isActive__c=true );

		PtWebApi_SeikyuTsuchi.ReqArgs theArgs = new PtWebApi_SeikyuTsuchi.ReqArgs();
		theArgs.torihikisaki_bango = '1234';
		theArgs.seikyu_bango = '5678';
		theArgs.kokyaku_id = '90';

	    Test.startTest();
	        
        PtWebApi_SeikyuTsuchi.Agent theAgent = new PtWebApi_SeikyuTsuchi.Agent();
        theAgent.sendRequest(theArgs);
		
        Test.stopTest();
	}
}