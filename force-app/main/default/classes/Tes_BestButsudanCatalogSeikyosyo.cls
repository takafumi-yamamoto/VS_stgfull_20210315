/**
* クラス名      :   Tes_BestButsudanCatalogSeikyosyo
* クラス概要     :   ベスト仏壇請求書作成コントローラテストクラス
* @created  :   2019/04/16
* @modified :   
*/
@isTest
public with sharing class Tes_BestButsudanCatalogSeikyosyo {
    static testMethod void testMethod_BestButsudanCatalogSeikyosyo(){
        RecordType defualtAccountRT = new RecordTypeDao().selectRecordBySobjectTypeDeveloperName('Account', 'null');
        Account dacc=new Account();
        dacc.LastName='xxxdefualt';
        // dacc.LastNameFurigana__pc ='defualt';
        // dacc.FirstNameFurigana__pc ='defualt';
        dacc.Phone='088-0000-0001';
        dacc.MobilePhone__c='888-0000-0001';
        dacc.recordTypeId = defualtAccountRT.Id;
        insert dacc;

		Test.startTest();

		// 取引先
		Account acc = new Account( Name = 'アカウントtest');
	    insert acc;

		Date today = date.today();

        //ベスト仏壇
		BestButsudan__c bestButsudan = new BestButsudan__c();
        bestButsudan.ChumonId__c = '000000';
		insert bestButsudan;

	    // 商談
		String oppBestButsudanRdId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','KakuyasuButsudan');
		Opportunity opp = new Opportunity(
			Name = 'テスト商談', AccountId = acc.Id, RecordTypeId = oppBestButsudanRdId, 
			StageName = 'フォロー',CloseDate = today, BestButsudanRef__c = bestButsudan.Id,
			TaishoushaJokyo__c = '_'
			);
     	insert opp;

		k_Service__c theService = new k_Service__c(ID__c = '4', Name = 'ベスト仏壇');
		Insert theService;
		k_ShohinSyubetsu__c theShohinSyubetsu = new k_ShohinSyubetsu__c(ID__c = '1', Name = '本体（委託）');
		Insert theShohinSyubetsu;

     	// 葬儀プラン商品
		Product2 bestButsudanpro = new Product2(
			Name = 'ベスト仏壇',ProductCode = '12345',ShohinBango__c = '1', 
			k_ServiceRef__c = theService.Id,  k_ShohinSyubetsuRef__c = theShohinSyubetsu.Id);
		insert bestButsudanpro;

		// 割引商品
		Product2 waribiki = new Product2(Name = '割引',ProductCode = '1111',DataKubun__c = '2:割引プラン', ShohinBango__c = '2');
		insert waribiki;

		// クーポン商品
		Product2 coupon = new Product2(Name = 'クーポン',ProductCode = '55555',DataKubun__c = '3:クーポン', ShohinBango__c = '3');
		insert coupon;

		// 価格表
		Id pricebook2Id = Test.getStandardPricebookId();

		PricebookEntry pde1 = new PricebookEntry(Product2Id = bestButsudanpro.Id, KakakuEntryBango__c = '00001', Pricebook2Id = pricebook2Id, UnitPrice = 15000,IsActive = true);
		insert pde1;

		PricebookEntry pde2 = new PricebookEntry(Product2Id = waribiki.Id, Pricebook2Id = pricebook2Id, KakakuEntryBango__c = '00002', UnitPrice = 15000,IsActive = true);
		insert pde2;

		PricebookEntry pde3 = new PricebookEntry(Product2Id = coupon.Id, Pricebook2Id = pricebook2Id,  KakakuEntryBango__c = '00003', UnitPrice = 15000,IsActive = true);
		insert pde3;

		// 商談商品
		OpportunityLineItem syoudanSyouhin1 = new OpportunityLineItem(Quantity = 1,OpportunityId = opp.Id,PricebookEntryId = pde1.Id);
		insert syoudanSyouhin1;

		OpportunityLineItem syoudanSyouhin2 = new OpportunityLineItem(Quantity = 1,OpportunityId = opp.Id,PricebookEntryId = pde2.Id);
		insert syoudanSyouhin2;

		OpportunityLineItem syoudanSyouhin3 = new OpportunityLineItem(Quantity = 1,OpportunityId = opp.Id,PricebookEntryId = pde3.Id);
		insert syoudanSyouhin3;


		ApexPages.StandardController sc = new ApexPages.StandardController(opp);

		BestButsudanCatalogSeikyosyo bestbutsudanseikyusyo = new BestButsudanCatalogSeikyosyo(sc);
		bestbutsudanseikyusyo.createBestButsudanSeikyusyo();

        Test.stopTest();
    }

}