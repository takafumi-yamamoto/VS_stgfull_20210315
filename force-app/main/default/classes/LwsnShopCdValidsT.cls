@isTest
public class LwsnShopCdValidsT {

    private static void beginSetUp(){
		Utility_Common.isMimicExecAsDataIkouProfile = true;
    }
	private static void endSetUp(){
        Insert new TriggerIsActive__c( name='default', isActive__c=true );
        Insert new JizenWariPlan__c( Code__c='Yoriso' );
        Insert new Account(
            RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','null'),
            FirstName = '_', LastName = '_'
        );
		Utility_Common.isMimicExecAsDataIkouProfile = false;
	}

	@isTest public static void validate_oppShoudHaveShopCode(){

		beginSetUp();
        Map<String, Account> theAccounts = new Map<String, Account>{
            '客' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                FirstName = '_', LastName = '_'
            ),
            'ローソン' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Default'),
                Name = '_'
            )
        };
		INSERT theAccounts.values();

		Map<String, Keiyaku__c> theKeiyakus = new Map<String, Keiyaku__c>{
			'ローソンアライアンス' => new Keiyaku__c(
				RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Keiyaku__c','Alliance'),
				Teikeisaki__c = theAccounts.get('ローソン').Id
			)
		};
		INSERT theKeiyakus.values();
		endSetUp();

		Test.startTest();

		Opportunity theOldOne = new Opportunity(
			RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId(),
			AllianceRef__c = null,
			LawsonShopCode__c = null
		);
		Opportunity theNewOne = new Opportunity(
			RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId(),
			AllianceRef__c = theKeiyakus.get('ローソンアライアンス').Id,
			LawsonShopCode__c = null
		);

		new LwsnShopCdValids(
			new LwsnIsLwsnKeiyakus.IsLawsonKeiyakuSvcStub().setKeiyakuId( theKeiyakus.get('ローソンアライアンス').Id )
		).validate_oppShoudHaveShopCode(theNewOne, theOldOne);

		Test.stopTest();
	}
}