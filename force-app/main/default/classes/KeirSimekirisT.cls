@isTest
public class KeirSimekirisT {
	
	@isTest public static void isAcceptableDate(){
		Test.startTest();
		KeirSimekiris.isAcceptableDate(
			KeirSimekiris.Targets.SOGI_OPPS, 
			Date.newInstance(2010,1,1)
		);
	}

	@isTest public static void resolveKeirSimekiriTargetByOppRecTypeId(){
		Test.startTest();
		KeirSimekiris.resolveKeirSimekiriTargetByOppRecTypeId(
			Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId()
		);
		Test.stopTest();
	}
}