@isTest
public class SogiKessaiHokokushoOutputT {

    private static void beginSetUp(){
		Utility_Common.isMimicExecAsDataIkouProfile = true;
    }
	private static void endSetUp(){
        Insert new TriggerIsActive__c( name='default', isActive__c=true );
        Insert new JizenWariPlan__c( Code__c='Yoriso' );
        Insert new Account(
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId(),
            FirstName = '_', LastName = '_'
        );
		Utility_Common.isMimicExecAsDataIkouProfile = false;
	}

	@isTest 
	public static void doSogiKessaiHokokushoOutput(){
		beginSetUp();
        Map<String, Account> theAccounts = new Map<String, Account>{
            '客' => new Account(
                RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId(),
            	FirstName = '_', LastName = '_'
            )
        };
		INSERT theAccounts.values();
		endSetUp();

        Map<String, SimpleYasugo__c> theSimpleYasugos = new Map<String, SimpleYasugo__c>{
            'シンプル安豪' => new SimpleYasugo__c()
        };
        INSERT theSimpleYasugos.values();

        Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
            'シンプル安豪' => new Opportunity(
                RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId(),
            	Name = '_',
                AccountId = theAccounts.get('客').Id,
                StageName = '_',
				CloseDate = Date.newInstance(2000,1,1),
                SimpleYasugoRef__c = theSimpleYasugos.get('シンプル安豪').Id
            )
        };
        INSERT theOpps.values();

		Test.startTest();

		SogiKessaiHokokushoOutput sogiKessaiHokokushoOutput = new SogiKessaiHokokushoOutput( 
																	new ApexPages.StandardController( theOpps.get('シンプル安豪') )
																 );
		sogiKessaiHokokushoOutput.createSogiKessaiHokokusho();
		Test.stopTest();
	}
}