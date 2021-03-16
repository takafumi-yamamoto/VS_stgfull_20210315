@isTest
private class TerapToiRecBatT {

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
    @isTest
    static void myUnitTest() {
        

		beginSetUp();
		Map<String, Account> theAccounts = new Map<String, Account>{
			'Sogisya' => new Account(
				RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Sogisya').getRecordTypeId(),
				Name = '_'
			),
			'Customer' => new Account(
				RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId(),
				FirstName = '_', LastName = '_'
			)
		};
		INSERT theAccounts.values();

		Map<String, Keiyaku__c> theKeiyakus = new Map<String, Keiyaku__c>{
			'TeraPass' => new Keiyaku__c(
				RecordTypeId = Schema.SObjectType.Keiyaku__c.getRecordTypeInfosByDeveloperName().get('SouryoTehaiDaiko').getRecordTypeId(),
				KeiyakuType__c = 'てらぱす-定額課金',
				Teikeisaki__c = theAccounts.get('Sogisya').Id,
				KeiyakuJokyo__c = '契約中'
			)
		};
		INSERT theKeiyakus.values();
		
		Map<String, TeiHehDaiKakinSchEnt__c> theKakins = new Map<String, TeiHehDaiKakinSchEnt__c>{
			'Last' => new TeiHehDaiKakinSchEnt__c(
				KeiyakuRef__c = theKeiyakus.get('TeraPass').Id,
				BeginDate__c = Date.newInstance(2019,12,1),
				EndDate__c = Date.newInstance(2019,12,31),
				Kingaku__c = 10000
			)
		};
		INSERT theKakins.values();

		Map<String, Obosanbin__c> theObos = new Map<String, Obosanbin__c>{
			'1' => new Obosanbin__c( Sogisha__c = theAccounts.get('Sogisya').Id ),
			'2' => new Obosanbin__c( Sogisha__c = theAccounts.get('Sogisya').Id )
		};
		INSERT theObos.values();

		Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
			'1' => new Opportunity(
				RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Obosanbin').getRecordTypeId(),
				AccountId = theAccounts.get('Customer').Id,
				Name = '_', StageName = '_', CloseDate = Date.newInstance(2000,1,1),
				ObosanbinRef__c = theObos.get('1').Id,
				Req_Day__c = Date.today().toStartOfMonth(),
				RyunyumotoService__c = '定額僧侶手配代行'
			),
			'2' => new Opportunity(
				RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Obosanbin').getRecordTypeId(),
				AccountId = theAccounts.get('Customer').Id,
				Name = '_', StageName = '_', CloseDate = Date.newInstance(2000,1,1),
				ObosanbinRef__c = theObos.get('2').Id,
				Req_Day__c = Date.today().toStartOfMonth(),
				RyunyumotoService__c = '定額僧侶手配代行'
			)
		};
		INSERT theOpps.values();
		endSetUp();

        Test.startTest();
        Integer theBatchSize = 200;
        Database.executeBatch(new TerapToiRecBat(date.today()), theBatchSize);
        Test.stopTest();
    }
}