@isTest
public class ShukeiyoKiboPlanConversionT {

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


	@isTest public static void OnAfterInsert(){
		beginSetUp();
		endSetUp();
		Test.startTest();
		INSERT NEW SimpleYasugo__c();
		Test.stopTest();
	}

	@isTest public static void OnAfterUpdate(){
		beginSetUp();

		Map<String, Account> theAccounts = new Map<String, Account>{
			'客' => new Account(
				RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
				FirstName = '_', LastName = '_'
			)
		};
		INSERT theAccounts.values();

		Map<String, SimpleYasugo__c> theSimpleYasugos = new Map<String, SimpleYasugo__c>{
			'葬儀' => new SimpleYasugo__c()
		};
		INSERT theSimpleYasugos.values();

		Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
			'葬儀' => new Opportunity(
				RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo'),
				Name = '_',
				AccountId = theAccounts.get('客').Id,
				StageName = '_',
				CloseDate = Date.newInstance(2000,1,1),
				SimpleYasugoRef__c = theSimpleYasugos.get('葬儀').Id
			)
		};
		Insert theOpps.values();
		endSetUp();
		UPDATE new SimpleYasugo__c(Id = theSimpleYasugos.get('葬儀').Id );
		UPDATE new SimpleYasugo__c(Id = theSimpleYasugos.get('葬儀').Id ,SogiPlanUketsuke__c = '【20.11】よりそう家族葬 一日プラン');
	}
}