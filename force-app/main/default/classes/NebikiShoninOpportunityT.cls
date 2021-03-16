@isTest
public class NebikiShoninOpportunityT {

	@isTest static void doTestSimpleYasugo(){
		id defualtAccountRT = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId();
		Account dacc=new Account();
		dacc.LastName='xxxdefualt';
		dacc.Phone='088-0000-0001';
		dacc.MobilePhone__c='888-0000-0001';
		dacc.recordTypeId = defualtAccountRT;
		Database.SaveResult lsracc = Database.insert(dacc);

		Opportunity SimpleYasugoOPP = new Opportunity(
			AccountId = lsracc.getid(),				// お客様・提携先名
			Name = '新規_シンプル安豪',						  // 商談名
			CloseDate = Date.valueOf('2020-06-18'),		 // 完了予定日
			Probability = 0,								// 確度(%)
			StageName = '問合せ受付',							// フェーズ
			RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId()
		);
		Database.SaveResult lSimpleYasugoOPP = Database.insert(SimpleYasugoOPP);

		Id pricebookId = Test.getStandardPricebookId();
		Product2 prod = new Product2(
			ShohinBango__c = 'SBG-0000214',                // 商品番号
			IsActive = true,                                 // 有効
			Name = 'その他お客様向け割引（CS起因）',                       // 商品名
			ShohinKamoku__c = '通常',                           // 商品科目
			SireKingakuKeisanHousiki__c = '設定金額',             // 仕入金額計算方式
			SireKingaku__c = 0,                          // 仕入金額
			TesuryoKingakuKeisanHoushiki__c = '計算しない',        // 手数料金額計算方式
			HanbaiKaishiBi__c = Date.valueOf('2019-12-26'),   // 販売開始日
			HanbaiSyuryoBi__c = Date.valueOf('2100-12-30')   // 販売終了日
		);
		Database.SaveResult prodi = Database.insert(prod);

		PricebookEntry standardPrice = new PricebookEntry(
			Pricebook2Id = pricebookId, Product2Id = prodi.getId(),
			UnitPrice = 0, IsActive = true);
		Database.SaveResult PricebookEntryId = Database.insert(standardPrice);

		Test.startTest();
		OpportunityLineItem SimpleYasugosobj = new OpportunityLineItem(
			Product2Id = prodi.getId(),   // 商品
			UnitPrice = -25000,                  // 販売価格
			Quantity = 1,                  // 数量
			ShohinKamoku__c = '通常',             // 商品科目
			SireKingaku__c = 0,                 // 仕入金額
			OpportunityId = lSimpleYasugoOPP.getId()  // 商談
		);
		Database.SaveResult SimpleYasugoItem = Database.insert(SimpleYasugosobj);
		OpportunityLineItem SimpleYasugoUP = new OpportunityLineItem(
			Id = SimpleYasugoItem.getId(),
			UnitPrice = -16500
		);
		update SimpleYasugoUP;

		Test.stopTest();
		
	}

	@isTest static void doTestObosanbin(){
		id defualtAccountRT = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId();
		Account dacc=new Account();
		dacc.LastName='xxxdefualt';
		dacc.Phone='088-0000-0001';
		dacc.MobilePhone__c='888-0000-0001';
		dacc.recordTypeId = defualtAccountRT;
		Database.SaveResult lsracc = Database.insert(dacc);

		Opportunity ObosanbinOPP = new Opportunity(
			AccountId = lsracc.getid(),				// お客様・提携先名
			Name = '新規_お坊さん便',						  // 商談名
			CloseDate = Date.valueOf('2020-06-18'),		 // 完了予定日
			Probability = 0,								// 確度(%)
			StageName = '問合せ受付',							// フェーズ
			RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Obosanbin').getRecordTypeId()
		);
		Database.SaveResult lObosanbinOPP = Database.insert(ObosanbinOPP);

		Id pricebookId = Test.getStandardPricebookId();
		Product2 prod = new Product2(
			ShohinBango__c = 'SBG-0000188',                // 商品番号
			IsActive = true,                                 // 有効
			Name = 'パートナー手数料調整',                       // 商品名
			ShohinKamoku__c = '通常',                           // 商品科目
			SireKingakuKeisanHousiki__c = '設定金額',             // 仕入金額計算方式
			SireKingaku__c = 0,                          // 仕入金額
			TesuryoKingakuKeisanHoushiki__c = '計算しない',        // 手数料金額計算方式
			HanbaiKaishiBi__c = Date.valueOf('2019-12-26'),   // 販売開始日
			HanbaiSyuryoBi__c = Date.valueOf('2100-12-30')   // 販売終了日
		);
		Database.SaveResult prodi = Database.insert(prod);

		PricebookEntry standardPrice = new PricebookEntry(
			Pricebook2Id = pricebookId, Product2Id = prodi.getId(),
			UnitPrice = 0, IsActive = true);
		Database.SaveResult PricebookEntryId = Database.insert(standardPrice);

		Test.startTest();
		PatnerUriage__c Obosanbinsobj = new PatnerUriage__c(
			Syodan__c = lObosanbinOPP.getId(),// 商談
			Syohin__c = prodi.getId(),  // 商品
			Kingaku__c = -8000,              // 金額
			MeisaiSetsumei__c = 'TEST',     // 明細説明
			ShohinKamoku__c = '通常'         // 商品科目
		);
		Database.SaveResult ObosanbinItem = Database.insert(Obosanbinsobj);
		PatnerUriage__c ObosanbinUP = new PatnerUriage__c(
			Id = ObosanbinItem.getId(),
			Kingaku__c = -3000
		);
		update ObosanbinUP;

		Test.stopTest();
		
	}

	@isTest static void doTestKakuyasuButsudan(){
		id defualtAccountRT = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId();
		Account dacc=new Account();
		dacc.LastName='xxxdefualt';
		dacc.Phone='088-0000-0001';
		dacc.MobilePhone__c='888-0000-0001';
		dacc.recordTypeId = defualtAccountRT;
		Database.SaveResult lsracc = Database.insert(dacc);

		Opportunity KakuyasuButsudanOPP = new Opportunity(
			AccountId = lsracc.getid(),				// お客様・提携先名
			Name = '新規_ベスト仏壇',						  // 商談名
			CloseDate = Date.valueOf('2020-06-18'),		 // 完了予定日
			Probability = 0,								// 確度(%)
			StageName = '問合せ受付',							// フェーズ
			RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('KakuyasuButsudan').getRecordTypeId()
		);
		Database.SaveResult lKakuyasuButsudanOPP = Database.insert(KakuyasuButsudanOPP);

		Id pricebookId = Test.getStandardPricebookId();
		Product2 prod = new Product2(
			ShohinBango__c = 'SBG-0000214',                // 商品番号
			IsActive = true,                                 // 有効
			Name = 'その他お客様向け割引（CS起因）',                       // 商品名
			ShohinKamoku__c = '通常',                           // 商品科目
			SireKingakuKeisanHousiki__c = '設定金額',             // 仕入金額計算方式
			SireKingaku__c = 0,                          // 仕入金額
			TesuryoKingakuKeisanHoushiki__c = '計算しない',        // 手数料金額計算方式
			HanbaiKaishiBi__c = Date.valueOf('2019-12-26'),   // 販売開始日
			HanbaiSyuryoBi__c = Date.valueOf('2100-12-30')   // 販売終了日
		);
		Database.SaveResult prodi = Database.insert(prod);

		PricebookEntry standardPrice = new PricebookEntry(
			Pricebook2Id = pricebookId, Product2Id = prodi.getId(),
			UnitPrice = 0, IsActive = true);
		Database.SaveResult PricebookEntryId = Database.insert(standardPrice);

		Test.startTest();
		OpportunityLineItem KakuyasuButsudansobj = new OpportunityLineItem(
			Product2Id = prodi.getId(),   // 商品
			UnitPrice = -25000,                  // 販売価格
			Quantity = 1,                  // 数量
			ShohinKamoku__c = '通常',             // 商品科目
			SireKingaku__c = 0,                 // 仕入金額
			OpportunityId = lKakuyasuButsudanOPP.getId()  // 商談
		);
		Database.SaveResult KakuyasuButsudanItem = Database.insert(KakuyasuButsudansobj);
		OpportunityLineItem KakuyasuButsudanUP = new OpportunityLineItem(
			Id = KakuyasuButsudanItem.getId(),
			UnitPrice = -3000
		);
		update KakuyasuButsudanUP;

		Test.stopTest();
		
	}

	@isTest static void doTestKaiyoUmie(){
		id defualtAccountRT = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId();
		Account dacc=new Account();
		dacc.LastName='xxxdefualt';
		dacc.Phone='088-0000-0001';
		dacc.MobilePhone__c='888-0000-0001';
		dacc.recordTypeId = defualtAccountRT;
		Database.SaveResult lsracc = Database.insert(dacc);

		Opportunity KaiyoUmieOPP = new Opportunity(
			AccountId = lsracc.getid(),				// お客様・提携先名
			Name = '新規_海洋散骨',						  // 商談名
			CloseDate = Date.valueOf('2020-06-18'),		 // 完了予定日
			Probability = 0,								// 確度(%)
			StageName = '問合せ受付',							// フェーズ
			RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('KaiyoUmie').getRecordTypeId()
		);
		Database.SaveResult lKaiyoUmieOPP = Database.insert(KaiyoUmieOPP);

		Id pricebookId = Test.getStandardPricebookId();
		Product2 prod = new Product2(
			ShohinBango__c = 'SBG-0000214',                // 商品番号
			IsActive = true,                                 // 有効
			Name = 'その他お客様向け割引（CS起因）',                       // 商品名
			ShohinKamoku__c = '通常',                           // 商品科目
			SireKingakuKeisanHousiki__c = '設定金額',             // 仕入金額計算方式
			SireKingaku__c = 0,                          // 仕入金額
			TesuryoKingakuKeisanHoushiki__c = '計算しない',        // 手数料金額計算方式
			HanbaiKaishiBi__c = Date.valueOf('2019-12-26'),   // 販売開始日
			HanbaiSyuryoBi__c = Date.valueOf('2100-12-30')   // 販売終了日
		);
		Database.SaveResult prodi = Database.insert(prod);

		PricebookEntry standardPrice = new PricebookEntry(
			Pricebook2Id = pricebookId, Product2Id = prodi.getId(),
			UnitPrice = 0, IsActive = true);
		Database.SaveResult PricebookEntryId = Database.insert(standardPrice);

		Test.startTest();
		OpportunityLineItem KaiyoUmiesobj = new OpportunityLineItem(
			Product2Id = prodi.getId(),   // 商品
			UnitPrice = -25000,                  // 販売価格
			Quantity = 1,                  // 数量
			ShohinKamoku__c = '通常',             // 商品科目
			SireKingaku__c = 0,                 // 仕入金額
			OpportunityId = lKaiyoUmieOPP.getId()  // 商談
		);
		Database.SaveResult KaiyoUmieItem = Database.insert(KaiyoUmiesobj);
		OpportunityLineItem KaiyoUmieUP = new OpportunityLineItem(
			Id = KaiyoUmieItem.getId(),
			UnitPrice = -3000
		);
		update KaiyoUmieUP;

		Test.stopTest();
		
	}

	@isTest static void doTestPerpetualMemorial(){
		id defualtAccountRT = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId();
		Account dacc=new Account();
		dacc.LastName='xxxdefualt';
		dacc.Phone='088-0000-0001';
		dacc.MobilePhone__c='888-0000-0001';
		dacc.recordTypeId = defualtAccountRT;
		Database.SaveResult lsracc = Database.insert(dacc);

		Opportunity PerpetualMemorialOPP = new Opportunity(
			AccountId = lsracc.getid(),				// お客様・提携先名
			Name = '新規_永代供養',						  // 商談名
			CloseDate = Date.valueOf('2020-06-18'),		 // 完了予定日
			Probability = 0,								// 確度(%)
			StageName = '問合せ受付',							// フェーズ
			RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('PerpetualMemorial').getRecordTypeId()
		);
		Database.SaveResult lPerpetualMemorialOPP = Database.insert(PerpetualMemorialOPP);

		Id pricebookId = Test.getStandardPricebookId();
		Product2 prod = new Product2(
			ShohinBango__c = 'SBG-0000214',                // 商品番号
			IsActive = true,                                 // 有効
			Name = 'その他お客様向け割引（CS起因）',                       // 商品名
			ShohinKamoku__c = '通常',                           // 商品科目
			SireKingakuKeisanHousiki__c = '設定金額',             // 仕入金額計算方式
			SireKingaku__c = 0,                          // 仕入金額
			TesuryoKingakuKeisanHoushiki__c = '計算しない',        // 手数料金額計算方式
			HanbaiKaishiBi__c = Date.valueOf('2019-12-26'),   // 販売開始日
			HanbaiSyuryoBi__c = Date.valueOf('2100-12-30')   // 販売終了日
		);
		Database.SaveResult prodi = Database.insert(prod);

		PricebookEntry standardPrice = new PricebookEntry(
			Pricebook2Id = pricebookId, Product2Id = prodi.getId(),
			UnitPrice = 0, IsActive = true);
		Database.SaveResult PricebookEntryId = Database.insert(standardPrice);

		Test.startTest();

		OpportunityLineItem PerpetualMemorialsobj = new OpportunityLineItem(
			Product2Id = prodi.getId(),   // 商品
			UnitPrice = -25000,                  // 販売価格
			Quantity = 1,                  // 数量
			ShohinKamoku__c = '通常',             // 商品科目
			SireKingaku__c = 0,                 // 仕入金額
			OpportunityId = lPerpetualMemorialOPP.getId()  // 商談
		);
		Database.SaveResult PerpetualMemorialItem = Database.insert(PerpetualMemorialsobj);
		OpportunityLineItem PerpetualMemorialUP = new OpportunityLineItem(
			Id = PerpetualMemorialItem.getId(),
			UnitPrice = -3000
		);
		update PerpetualMemorialUP;

		Test.stopTest();
		
	}

}