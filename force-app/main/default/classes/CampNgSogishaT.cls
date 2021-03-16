@isTest
public class CampNgSogishaT {

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

	@isTest static void OppLineItemValidator_OppLineItemValidator(){
		beginSetUp();
		Map<String, Account> the_accounts = new Map<String, Account>{
			'客-1' => new Account(
				RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId(),
				FirstName = '_', LastName = '_',
				MemberTourokuZumi__c = true, JizenJizenSheetTeishutsuzumi__c = true
			),
			'葬儀社-1' => new Account(
				RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Sogisya').getRecordTypeId(),
				Name ='システム動作確認用'
			)
		};
		INSERT the_accounts.values();

		Map<String, Achievement__c> the_Achievement = new Map<String, Achievement__c>{
			'よりそう会員-1' => new Achievement__c(
				Syubetsu__c = 'YorisoJizenWari',
				YukoFlag__c = true,
				TorihikiSakiRef__c = the_accounts.get('客-1').Id,
				JizenwariMemberKisanbi__c = Date.valueOf('2020-11-24')
			)
		};
		INSERT the_Achievement.values();

		Map<String, Keiyaku__c> the_Keiyaku = new Map<String, Keiyaku__c>{
			'契約-1' => new Keiyaku__c(
				Name = 'シンプル安豪契約',
				RecordTypeId = Schema.SObjectType.Keiyaku__c.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId(),
				Teikeisaki__c = the_accounts.get('葬儀社-1').Id,
				KeiyakuJokyo__c = '契約中',
				KeiyakuMousikomiBi__c = date.valueOf('2015-01-01'),
				campaign_sougi_bouquet__c = '対応不可'
			)
		};
		INSERT the_Keiyaku.values();

		Map<String, SimpleYasugo__c> the_SimpleYasugo = new Map<String, SimpleYasugo__c>{
			'シンプル-1' => new SimpleYasugo__c(
				SimpleYasugoKeiyakuRef__c = the_Keiyaku.get('契約-1').Id,
				TaiouKanouRiyu__c = '対応可能（距離優先）'
			)
		};
		INSERT the_SimpleYasugo.values();

		Map<String, Opportunity> the_opps = new Map<String, Opportunity>{
			'葬儀商談-1' => new Opportunity(
				RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId(),
				AccountId = the_accounts.get('客-1').Id,
				Name = '_',
				StageName = '_',
				CloseDate = Date.newInstance(2020, 1, 1),
				SimpleYasugoRef__c = the_SimpleYasugo.get('シンプル-1').Id
			)
		};
		INSERT the_opps.values();

		Map<String, Product2> the_Product2 = new Map<String, Product2>{
			'the_Product2-Plan' => new Product2(ShohinBango__c = 'SBG-0005006', Name = '【20.11】よりそう家族葬 一日プラン', IsActive = true, LatestFlg__c = true),
			'the_Product2-パートナー' => new Product2(ShohinBango__c = 'SBG-0000246', Name = 'その他お客様向け割引（パートナー起因）', IsActive = true, LatestFlg__c = true),
			'the_Product2-キャンペーン' => new Product2(ShohinBango__c = 'SBG-0005420', Name = '【20.11】よりそうオプション 葬儀用ブーケ (2020年11月開始キャンペーン)', IsActive = true, LatestFlg__c = true)
		};
		Insert the_Product2.values();

		Id pricebook2Id = Test.getStandardPricebookId();

		Map<String, PricebookEntry> the_PricebookEntry = new Map<String, PricebookEntry>{
			'PricebookEntry-Plan' => new PricebookEntry(Pricebook2Id = pricebook2Id,Product2Id = the_Product2.get('the_Product2-Plan').Id,UnitPrice = 100.00,IsActive = true),
			'PricebookEntry-パートナー' => new PricebookEntry(Pricebook2Id = pricebook2Id,Product2Id = the_Product2.get('the_Product2-パートナー').Id,UnitPrice = 100.00,IsActive = true),
			'PricebookEntry-キャンペーン' => new PricebookEntry(Pricebook2Id = pricebook2Id,Product2Id = the_Product2.get('the_Product2-キャンペーン').Id,UnitPrice = 100.00,IsActive = true)
		};
		Insert the_PricebookEntry.values();

		Map<String, OpportunityLineItem> the_OpportunityLineItem = new Map<String, OpportunityLineItem>{
			'OpportunityLineIte-Plan' => new OpportunityLineItem(OpportunityId = the_opps.get('葬儀商談-1').Id, PricebookEntryId = the_PricebookEntry.get('PricebookEntry-Plan').Id),
			'OpportunityLineIte-キャンペーン' => new OpportunityLineItem(OpportunityId = the_opps.get('葬儀商談-1').Id, PricebookEntryId = the_PricebookEntry.get('PricebookEntry-キャンペーン').Id)
		};
		Insert the_OpportunityLineItem.values();

		endSetUp();

		Test.startTest();
		Boolean returnBoolean = new CampNgSogisha.OppLineItemValidator().any_invalids(the_opps.get('葬儀商談-1').Id);
		Test.stopTest();
	}
}