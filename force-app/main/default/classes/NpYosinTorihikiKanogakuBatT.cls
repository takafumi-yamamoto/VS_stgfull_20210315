@isTest
private class NpYosinTorihikiKanogakuBatT {
	
	@isTest static void test_method_one() {
        Insert new TriggerIsActive__c( name='default', isActive__c=true );
        Insert new JizenWariPlan__c( Code__c='Yoriso' );
        Insert new Account(
            RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','null'),
            FirstName = '_', LastName = '_'
        );

		SampleData sample = new SampleData();
		Account soryo = sample.getAccountSoryoAccount();
		insert soryo;

		Keiyaku__c keiyaku = new Keiyaku__c(
				Name = 'テスト契約',
				Teikeisaki__c = soryo.Id,
				KeiyakuJokyo__c = '契約中',
				RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Keiyaku__c','Obosanbin')
			);
		insert keiyaku;

        Map<String, Account> theAccounts = new Map<String, Account>{
            '1' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                FirstName = '_', LastName = '_'
            )
        };        
        Insert theAccounts.values();

        Map<String, Obosanbin__c> theObosanbins = new Map<String, Obosanbin__c>{
            '1' => new Obosanbin__c(MemorialServicePlan__c = '四十九日法要', 
            	ObosanbinKeiyakuMadoguchi__c = keiyaku.Id,
            	KokubetsuDateTime_Inp__c = Datetime.now()),
            '2' => new Obosanbin__c(MemorialServicePlan__c = '四十九日法要', 
            	ObosanbinKeiyakuMadoguchi__c = keiyaku.Id,
            	KokubetsuDateTime_Inp__c = Datetime.now())
        };   
        Insert theObosanbins.values();

        Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
            '1' => new Opportunity(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Obosanbin'),
                Name = '_',
                AccountId = theAccounts.get('1').Id,
                StageName = '決定', SubPhase__c = '依頼書・手配報告書送付',
                Utiagebi__c = Date.today(),
                CloseDate = Date.today()
            ),
            '2' => new Opportunity(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Obosanbin'),
                Name = '_',
                AccountId = theAccounts.get('1').Id,
                StageName = '決定', SubPhase__c = '依頼書・手配報告書送付',
                Utiagebi__c = Date.today(),
                CloseDate = Date.today()
            )
        };
        Insert theOpps.values();

        theOpps.get('1').ObosanbinRef__c = theObosanbins.get('1').Id;
        theOpps.get('2').ObosanbinRef__c = theObosanbins.get('2').Id;
        Update theOpps.values();

        Test.StartTest();

        Integer theBatchSize = 200;
        Database.executeBatch(new NpYosinTorihikiKanogakuBat(), theBatchSize);		
        Test.StopTest();
	}
	
}