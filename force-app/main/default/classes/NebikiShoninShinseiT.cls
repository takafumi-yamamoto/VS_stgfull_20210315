@isTest
public class NebikiShoninShinseiT {

	@isTest static void doTest(){
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

		OpportunityLineItem SimpleYasugosobj = new OpportunityLineItem(
			Product2Id = prodi.getId(),   // 商品
			UnitPrice = -25000,                  // 販売価格
			Quantity = 1,                  // 数量
			ShohinKamoku__c = '通常',             // 商品科目
			SireKingaku__c = 0,                 // 仕入金額
			OpportunityId = lSimpleYasugoOPP.getId()  // 商談
		);
		insert SimpleYasugosobj;


		NebikiShoninShinsei__c Nebikisobj = new NebikiShoninShinsei__c(
			OpportunityRef__c = lSimpleYasugoOPP.getId(),// 商談
			NebikiShoninStatus__c = '未申請',           // 値引き承認ステータス
			NebikiKingaku__c = -22000,               // 値引き金額
			ShoinZumiNebikiKingaku__c = 0          // 承認済値引き金額
		);
		Database.SaveResult SaveNebiki = Database.insert(Nebikisobj);

		Test.startTest();

		Insert new TriggerIsActive__c( name='default', isActive__c=true );
		
		NebikiShoninShinsei__c updateNbiki1 = [SELECT Id, ShoinZumiNebikiKingaku__c, NebikiShoninStatus__c FROM NebikiShoninShinsei__c WHERE Id =:SaveNebiki.getId() limit 1];
		updateNbiki1.NebikiShoninStatus__c = '申請中';
		update updateNbiki1;

		NebikiShoninShinsei__c updateNbiki2 = [SELECT Id, ShoinZumiNebikiKingaku__c, NebikiShoninStatus__c FROM NebikiShoninShinsei__c WHERE Id =:SaveNebiki.getId() limit 1];
		updateNbiki2.NebikiShoninStatus__c = '承認';
		update updateNbiki2;

		NebikiShoninShinsei__c updateNbiki3 = [SELECT Id, ShoinZumiNebikiKingaku__c, NebikiShoninStatus__c FROM NebikiShoninShinsei__c WHERE Id =:SaveNebiki.getId() limit 1];
		updateNbiki3.NebikiShoninStatus__c = '却下';
		update updateNbiki3;

		NebikiShoninShinsei__c updateNbiki4 = [SELECT Id, ShoinZumiNebikiKingaku__c, NebikiShoninStatus__c FROM NebikiShoninShinsei__c WHERE Id =:SaveNebiki.getId() limit 1];
		updateNbiki4.NebikiShoninStatus__c = '申請中';
		update updateNbiki4;

		Test.stopTest();

		}
}