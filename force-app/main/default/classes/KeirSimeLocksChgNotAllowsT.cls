@isTest
public class KeirSimeLocksChgNotAllowsT {
	@isTest public static void isOppChgNotAllowedForSimekiri(){
		Test.startTest();
		String theRecTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Obosanbin');
		Date theDate = Date.newInstance(2000,1,1);
		new KeirSimeLocksChgNotAllows().isOppChgNotAllowedForSimekiri(theRecTypeId, theDate, true);
		Test.stopTest();
	}
	@isTest public static void isOppChgNotAllowedForClosedOpp(){
		Test.startTest();
		String theRecTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Obosanbin');
		new KeirSimeLocksChgNotAllows().isOppChgNotAllowedForClosedOpp(theRecTypeId, true);
		Test.stopTest();
	}
}