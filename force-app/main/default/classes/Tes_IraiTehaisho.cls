@isTest
public class Tes_IraiTehaisho {

	private static Opportunity setUp(){
		Id accRecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer');
		Map<String, Account> theAccounts = new Map<String, Account>{
			'sodansha' => new Account(LastName = '相談者',FirstName = 'テスト',RecordTypeId = accRecordTypeId),
			'moshu' => new Account(LastName = '喪主',FirstName = 'テスト',RecordTypeId = accRecordTypeId),
			'taishosha' => new Account(LastName = '対象者',FirstName = 'テスト',RecordTypeId = accRecordTypeId)
		};
		Insert theAccounts.values();

		Map<String, Obosanbin__c> theObousanbins = new Map<String, Obosanbin__c>{
			'1' => new Obosanbin__c(
				Taishosha1Ref__c = theAccounts.get('taishosha').Id, 
				MoshuRef__c = theAccounts.get('moshu').Id
			)
		};
		Insert theObousanbins.values();

		Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
			'1' => new Opportunity(
				Name = 'テスト商談',
				AccountId = theAccounts.get('sodansha').Id,
				StageName = '問合せ受付',
				CloseDate = date.Today(),
				RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Obosanbin'),
				ObosanbinRef__c = theObousanbins.get('1').Id
			)
		};
		Insert theOpps.values();
		return theOpps.get('1');
	} 

	@isTest
	static void createSoukyakusyo(){
		Opportunity aOpp = setUp();
		Test.startTest();
	    new Ctl_IraiTehaisho( new ApexPages.StandardController(aOpp) ).createSoukyakusyo();
		Test.stopTest();
	}

	@isTest
	static void createAmazonHoyo(){
		Opportunity aOpp = setUp();
		Test.startTest();
	    new Ctl_IraiTehaisho( new ApexPages.StandardController(aOpp) ).createAmazonHoyo();
		Test.stopTest();
	}
	@isTest
	static void createAmazonKaimyo(){
		Opportunity aOpp = setUp();
		Test.startTest();
	    new Ctl_IraiTehaisho( new ApexPages.StandardController(aOpp) ).createAmazonKaimyo();
		Test.stopTest();
	}

	@isTest
	static void createYahooHoyo(){
		Opportunity aOpp = setUp();
		Test.startTest();
	    new Ctl_IraiTehaisho( new ApexPages.StandardController(aOpp) ).createYahooHoyo();
		Test.stopTest();
	}
	@isTest
	static void createYahooKaimyo(){
		Opportunity aOpp = setUp();
		Test.startTest();
	    new Ctl_IraiTehaisho( new ApexPages.StandardController(aOpp) ).createYahooKaimyo();
		Test.stopTest();
	}

	@isTest
	static void createYoyakuTicket(){
		Opportunity aOpp = setUp();
		Test.startTest();
	    new Ctl_IraiTehaisho( new ApexPages.StandardController(aOpp) ).createYoyakuTicket();
		Test.stopTest();
	}
}