@isTest
private class ShukeiyoKetteiPlanConversionT {

	@testSetup
	static void initializeTestData() {

		RecordType defualtAccountRT = new RecordTypeDao().selectRecordBySobjectTypeDeveloperName('Account', 'null');
		Account dacc=new Account();
		dacc.LastName='xxxdefualt';
		dacc.Phone='088-0000-0001';
		dacc.MobilePhone__c='888-0000-0001';
		dacc.recordTypeId = defualtAccountRT.Id;
		insert dacc;
		
		JizenWariPlan__c JizenWariPlan=new JizenWariPlan__c();
		JizenWariPlan.Code__c='Yoriso';
		insert JizenWariPlan;

		//カスタム設定のTriggerIsActive__cのデータを作成
		TriggerIsActive__c TriggerIsActive=new TriggerIsActive__c();
		TriggerIsActive.name='default';
		TriggerIsActive.isActive__c=false;
		insert TriggerIsActive;

		Insert new List<LoggingsConfig__c>{
			new LoggingsConfig__c(
				name='dev', LevelsToWrite__c='Error, Warn, Info', WriteLogAttributeRecords__c=true,
				DmlStatementsLeftToStopLogging__c = 10, DmlStatementsLeftToWarn__c = 20,
				DmlRowsLeftToStopLogging__c = 100, DmlRowsLeftToWarn__c = 200
				),
			new LoggingsConfig__c(
				name='prod', LevelsToWrite__c='Error, Warn, Info', WriteLogAttributeRecords__c=true,
				DmlStatementsLeftToStopLogging__c = 10, DmlStatementsLeftToWarn__c = 20,
				DmlRowsLeftToStopLogging__c = 100, DmlRowsLeftToWarn__c = 200
				)
		};

		String pMailAddress = 'thisIsTest@thisIsTest.com';
		TesterMails.f_instance = new TesterMails(new TesterMailEnts.TesterMailEntriesStub().addEntry(pMailAddress),
											new Environments.Env());


	}

	static testMethod void testCase(){

		//取引先の「お客様」データ作成
		Account acc = new Account(
			LastName ='TEST',
			FirstName ='お客様',
			PersonBirthdate = Date.newInstance(2020, 6, 1),
			SeinengappiWareki__c = '令和2年06月01日',
			BotsunengappiWareki__c = '令和2年06月01日',
			PersonDeathDate__pc = Date.newInstance(2020, 6, 1),
			RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId()
		);
		Database.SaveResult lsracc = Database.insert(acc);

		//標準価格表取得
		Id lsrstandardPricebook = Test.getStandardPricebookId();

		k_Service__c MainSsobj = new k_Service__c(
			Name = 'シンプルなお葬式',// サービス名
			ID__c = '1'			 // ID
		);
		Database.SaveResult MainService = Database.insert(MainSsobj);

		k_ShohinCategory__c MainCsobj = new k_ShohinCategory__c(
			Name = '火葬式',	// 商品カテゴリ名
			ID__c = 'kasou' // ID
		);
		Database.SaveResult MainCategory = Database.insert(MainCsobj);

		k_ShohinCategory__c MainCIchinichisobj = new k_ShohinCategory__c(
			Name = '一日葬',	   // 商品カテゴリ名
			 ID__c = 'ichinichi'  // ID
		);
		Database.SaveResult MainCategoryIchinichi = Database.insert(MainCIchinichisobj);

		k_ShohinSyubetsu__c MainShohin = new k_ShohinSyubetsu__c(
			Name = '本体（委託）',					// 商品種別名
			ID__c = '1',								// ID
			KeijouSyubetsu__c = 'グロス'   // 計上種別
		);
		Database.SaveResult MainSyubetsu = Database.insert(MainShohin);

		Product2 SBG0005003 = new Product2(
			ShohinBango__c = 'SBG-0005003',										// 商品番号
			IsActive = true,													// 有効
			Name = '【20.11】よりそう家族葬 華やかプラン',						// 商品名
			NameForCustomer__c = 'よりそう家族葬 華やかプラン',					// お客様向け商品名
			LatestFlg__c = true,												// 新商品
			ShohinKamoku__c = '通常',											// 商品科目
			SireKingakuKeisanHousiki__c = '設定金額',							// 仕入金額計算方式
			SireKingaku__c = 707300,											// 仕入金額
			TesuryoKingakuKeisanHoushiki__c = '計算しない',						// 手数料金額計算方式
			TesuryoKingaku__c = 0,												// 手数料金額
			TesuryoCyoseiKingakuKeisanHoushiki__c = '計算しない',				// 手数料調整金額計算方式
			HanbaiKaishiBi__c = Date.valueOf('2020-09-01'),						// 販売開始日
			HanbaiSyuryoBi__c = Date.valueOf('2100-12-30'),						// 販売終了日
			DataKubun__c = '1:通常商品',										// データ区分
			k_ServiceRef__c = MainService.getId(),								// k_サービス
			k_ShohinCategoryRef__c = MainCategoryIchinichi.getId(),				// k_商品カテゴリ
			k_ShohinSyubetsuRef__c = MainSyubetsu.getId(),						// k_商品種別
			BunruiKensakuTag__c = '@@',											// 分類検索タグ
			IsKingakuHenkouFuka__c = false,										// 金額変更不可
			HinmokuBunrui__c = '本体',											// 品目分類
			SougiPlan__c = true													// 葬儀プラン
		);
		Database.SaveResult SBG0005003P = Database.insert(SBG0005003);

		//価格表エントリオブジェクトに価格エントリ番号「StandardSBG-0005003」のデータを作成
		PricebookEntry sSBG0005003 = new PricebookEntry(
			Pricebook2Id = lsrstandardPricebook,
			Product2Id = SBG0005003P.getId(),
			UnitPrice = 162800,
			UseStandardPrice = FALSE,
			IsActive = true,
			KakakuEntryBango__c = 'StandardSBG-0005003'
		);
		Database.SaveResult SBG0005003Entry = Database.insert(sSBG0005003);

		Product2 SBG0003002 = new Product2(
			ShohinBango__c = 'SBG-0003002',										// 商品番号
			IsActive = true,													// 有効
			Name = '【19.12】よりそうのお葬式 火葬式 無宗教プラン',				// 商品名
			NameForCustomer__c = 'よりそうのお葬式 火葬式 無宗教プラン',		// お客様向け商品名
			LatestFlg__c = true,												// 新商品
			ShohinKamoku__c = '通常',											// 商品科目
			SireKingakuKeisanHousiki__c = '設定金額',							// 仕入金額計算方式
			SireKingaku__c = 162800,											// 仕入金額
			TesuryoKingakuKeisanHoushiki__c = '計算しない',						// 手数料金額計算方式
			TesuryoKingaku__c = 0,												// 手数料金額
			TesuryoCyoseiKingakuKeisanHoushiki__c = '計算しない',				// 手数料調整金額計算方式
			HanbaiKaishiBi__c = Date.valueOf('2019-12-01'),						// 販売開始日
			HanbaiSyuryoBi__c = Date.valueOf('2100-12-31'),						// 販売終了日
			DataKubun__c = '1:通常商品',										// データ区分
			k_ServiceRef__c = MainService.getId(),								// k_サービス
			k_ShohinCategoryRef__c = MainCategory.getId(),						// k_商品カテゴリ
			k_ShohinSyubetsuRef__c = MainSyubetsu.getId(),						// k_商品種別
			BunruiKensakuTag__c = '@@SCU',										// 分類検索タグ
			IsKingakuHenkouFuka__c = false,										// 金額変更不可
			HinmokuBunrui__c = '本体',											// 品目分類
			SougiPlan__c = true													// 葬儀プラン
		);
		Database.SaveResult SBG0003002P = Database.insert(SBG0003002);

		//価格表エントリオブジェクトに価格エントリ番号「StandardSBG-0003002」のデータを作成
		PricebookEntry sSBG0003002 = new PricebookEntry(
			Pricebook2Id = lsrstandardPricebook,
			Product2Id = SBG0003002P.getId(),
			UnitPrice = 162800,
			UseStandardPrice = FALSE,
			IsActive = true,
			KakakuEntryBango__c = 'StandardSBG-0003002'
		);
		Database.SaveResult SBG0003002Entry = Database.insert(sSBG0003002);

		//商談のデータ作成
		opportunity opp1 = new opportunity(
			AccountId = lsracc.getid(),
			RecordTypeId = Schema.getGlobalDescribe().get('Opportunity').getDescribe().getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId(),
			Pricebook2Id = lsrstandardPricebook,
			Name = 'TEST特約店手数料',
			StageName = '問合せ受付',
			IsPrivate = FALSE,
			Probability = 0,
			TotalOpportunityQuantity = 1,
			ForecastCategoryName = 'パイプライン',
			BodaijiKyokaAri__c = FALSE,
			FBNaiyoKakunin__c = FALSE,
			OppEditDate__c = Date.today(),
			Req_Day__c = Date.today(),
			CloseDate = Date.today(),
			Utiagebi__c = date.today(),
			JimuTesuryo__c = 0
		);

		Database.SaveResult lsropp = Database.insert(opp1);

		opportunity opp2 = new opportunity(
			AccountId = lsracc.getid(),
			RecordTypeId = Schema.getGlobalDescribe().get('Opportunity').getDescribe().getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId(),
			Pricebook2Id = lsrstandardPricebook,
			Name = 'TEST特約店手数料',
			StageName = '問合せ受付',
			IsPrivate = FALSE,
			Probability = 0,
			TotalOpportunityQuantity = 1,
			ForecastCategoryName = 'パイプライン',
			BodaijiKyokaAri__c = FALSE,
			FBNaiyoKakunin__c = FALSE,
			OppEditDate__c = Date.today(),
			Req_Day__c = Date.today(),
			CloseDate = Date.today(),
			Utiagebi__c = date.today(),
			JimuTesuryo__c = 0
		);

		Database.SaveResult lsropp2 = Database.insert(opp2);

        TriggerIsActive__c TriggerIsActive= [select Id from TriggerIsActive__c where name = 'default'];
		TriggerIsActive.isActive__c=true;
		update TriggerIsActive;

		System.test.startTest();  
		
		// 商談商品のデータ作成
		OpportunityLineItem oli = new OpportunityLineItem(
			Product2Id = SBG0005003P.getId(),
			OpportunityId = lsropp.getId(),
			Quantity = 1,
			PricebookEntryId = SBG0005003Entry.Id,
			UnitPrice = 707300
		);
		Database.SaveResult item1 = Database.insert(oli);

		OpportunityLineItem oli2 = new OpportunityLineItem(
			Product2Id = SBG0003002P.getId(),
			OpportunityId = lsropp.getId(),
			Quantity = 1,
			PricebookEntryId = SBG0003002Entry.Id,
			UnitPrice = 162800
		);
		Database.SaveResult item2 = Database.insert(oli2);

		OpportunityLineItem oli3 = new OpportunityLineItem(
			Product2Id = SBG0003002P.getId(),
			OpportunityId = lsropp2.getId(),
			Quantity = 1,
			PricebookEntryId = SBG0003002Entry.Id,
			UnitPrice = 162800
		);
		Database.SaveResult item3 = Database.insert(oli3);

		OpportunityLineItem TestItm3 = [SELECT Id, UnitPrice FROM OpportunityLineItem WHERE Id = :item3.getId() Limit 1];
		Delete TestItm3;

		System.test.stopTest();
	}

}