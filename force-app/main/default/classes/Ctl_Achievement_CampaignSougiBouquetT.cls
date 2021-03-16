@isTest
public class Ctl_Achievement_CampaignSougiBouquetT {

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
		Map<String, Account> theAccounts = new Map<String, Account>{
			'客' => new Account(
				RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId(),
				FirstName = '_', 
				LastName = '_',
				MemberTourokuZumi__c = True,
				JizenJizenSheetTeishutsuzumi__c = True
			)
		};
		INSERT theAccounts.values();

		Date testDate = date.today();
	}

	@isTest public static void OnAfterUpdate(){
		beginSetUp();

		Date testDate = date.today();

		Map<String, Account> theAccounts = new Map<String, Account>{
			'客' => new Account(
				RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId(),
				FirstName = '_', 
				LastName = '_',
				MemberTourokuZumi__c = True
			)
		};
		INSERT theAccounts.values();

		Achievement__c theAchievement = new Achievement__c(
			Syubetsu__c = 'YorisoJizenWari',
			YukoFlag__c = true,
			TorihikiSakiRef__c = theAccounts.get('客').Id,
			JizenwariMemberKisanbi__c = testDate
		);
		INSERT theAchievement;

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
		Test.startTest();
		UPDATE new SimpleYasugo__c(
				Id = theSimpleYasugos.get('葬儀').Id ,
				JizenJunbiSheetGoannaiJokyo__c = '受領',
				JizenJunbiSheetGoteishutsuShudan__c = '郵送',
				PreliminaryConsultationDate__c = testDate
				);
		Test.stopTest();
	}
}