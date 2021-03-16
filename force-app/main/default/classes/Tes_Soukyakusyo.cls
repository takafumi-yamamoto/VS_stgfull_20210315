@isTest
public class Tes_Soukyakusyo {

    @testSetup
	static void initializeTestData() {
        RecordType defualtAccountRT = new RecordTypeDao().selectRecordBySobjectTypeDeveloperName('Account', 'null');
        Account dacc=new Account();
        dacc.LastName='xxxdefualt';
        //acc.LastNameFurigana__pc ='defualt';
        //acc.FirstNameFurigana__pc ='defualt';
        dacc.Phone='088-0000-0001';
        dacc.MobilePhone__c='888-0000-0001';
        dacc.recordTypeId = defualtAccountRT.Id;
        insert dacc;

		// シンプル安豪
		SimpleYasugo__c simpleYasgo = new SimpleYasugo__c();
		insert simpleYasgo;

		// 取引先
		Account acc = new Account( Name = 'アカウントtest');
	    insert acc;

		Date today = date.today();

	    // 商談
		String oppSimpleYasugoRdId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo');
		Opportunity opp = new Opportunity(
			Name = 'テスト商談', AccountId = acc.Id, RecordTypeId = oppSimpleYasugoRdId, 
			StageName = 'フォロー',CloseDate = today, SimpleYasugoRef__c = simpleYasgo.Id,
			TaishoushaJokyo__c = '_'
			);
     	insert opp;

		k_Service__c theService = new k_Service__c(ID__c = '1', Name = 'シンプル安豪');
		Insert theService;
		k_ShohinSyubetsu__c theShohinSyubetsu = new k_ShohinSyubetsu__c(ID__c = '1', Name = '本体（委託）');
		Insert theShohinSyubetsu;

     	// 葬儀プラン商品
		Product2 sogiPlan = new Product2(
			Name = '葬儀プラン',ProductCode = '12345',ShohinBango__c = '1', 
			k_ServiceRef__c = theService.Id,  k_ShohinSyubetsuRef__c = theShohinSyubetsu.Id);
		insert sogiPlan;

		// 割引商品・クーポン商品
		List<Product2> productList = new List<Product2>();
		Product2 waribiki = new Product2(Name = '割引',ProductCode = '1111',DataKubun__c = '2:割引プラン', ShohinBango__c = '2');
		Product2 waribiki2 = new Product2(Name = '割引2',ProductCode = '2222',DataKubun__c = '2:割引プラン', ShohinBango__c = '4');
		Product2 waribiki3 = new Product2(Name = '割引3',ProductCode = '3333',DataKubun__c = '2:割引プラン', ShohinBango__c = '6');
		productList.add(waribiki);
		productList.add(waribiki2);
		productList.add(waribiki3);
		insert productList;
 
		List<Product2> couponList = new List<Product2>();
		Product2 coupon = new Product2(Name = 'クーポン',ProductCode = '55555',DataKubun__c = '3:クーポン', ShohinBango__c = '3');
		Product2 coupon2 = new Product2(Name = 'クーポン2',ProductCode = '66666',DataKubun__c = '3:クーポン', ShohinBango__c = '7');
		couponList.add(coupon);
		couponList.add(coupon2);
		insert couponList;

		// 価格表
		Id pricebook2Id = Test.getStandardPricebookId();

		List<PricebookEntry> pbeList = new List<PricebookEntry>();
		PricebookEntry pde1 = new PricebookEntry(Product2Id = sogiPlan.Id, KakakuEntryBango__c = '00001', Pricebook2Id = pricebook2Id, UnitPrice = 15000,IsActive = true);
		PricebookEntry pde2 = new PricebookEntry(Product2Id = waribiki.Id, Pricebook2Id = pricebook2Id, KakakuEntryBango__c = '00002', UnitPrice = 11000,IsActive = true);
		PricebookEntry pde3 = new PricebookEntry(Product2Id = waribiki2.Id, Pricebook2Id = pricebook2Id,  KakakuEntryBango__c = '00003', UnitPrice = 5000,IsActive = true);
		PricebookEntry pde4 = new PricebookEntry(Product2Id = waribiki3.Id, Pricebook2Id = pricebook2Id,  KakakuEntryBango__c = '00004', UnitPrice = 5500,IsActive = true);
		PricebookEntry pde5 = new PricebookEntry(Product2Id = coupon.Id, Pricebook2Id = pricebook2Id,  KakakuEntryBango__c = '00005', UnitPrice = 15000,IsActive = true);
		PricebookEntry pde6 = new PricebookEntry(Product2Id = coupon2.Id, Pricebook2Id = pricebook2Id,  KakakuEntryBango__c = '00007', UnitPrice = 5500,IsActive = true);
		pbeList.add(pde1);
		pbeList.add(pde2);
		pbeList.add(pde3);
		pbeList.add(pde4);
		pbeList.add(pde5);
		pbeList.add(pde6);
		insert pbeList;

		// 商談商品
		List<OpportunityLineItem> olineItemLIst = new List<OpportunityLineItem>();
		OpportunityLineItem syoudanSyouhin1 = new OpportunityLineItem(Quantity = 1,OpportunityId = opp.Id,PricebookEntryId = pde1.Id);
		OpportunityLineItem syoudanSyouhin2 = new OpportunityLineItem(Quantity = 1,OpportunityId = opp.Id,PricebookEntryId = pde2.Id);
		OpportunityLineItem syoudanSyouhin3 = new OpportunityLineItem(Quantity = 1,OpportunityId = opp.Id,PricebookEntryId = pde3.Id);
		OpportunityLineItem syoudanSyouhin4 = new OpportunityLineItem(Quantity = 1,OpportunityId = opp.Id,PricebookEntryId = pde4.Id);
		OpportunityLineItem syoudanSyouhin5 = new OpportunityLineItem(Quantity = 1,OpportunityId = opp.Id,PricebookEntryId = pde5.Id);		
		OpportunityLineItem syoudanSyouhin6 = new OpportunityLineItem(Quantity = 1,OpportunityId = opp.Id,PricebookEntryId = pde6.Id);		
		
		olineItemLIst.add(syoudanSyouhin1);
		olineItemLIst.add(syoudanSyouhin2);
		olineItemLIst.add(syoudanSyouhin3);
		olineItemLIst.add(syoudanSyouhin4);
		olineItemLIst.add(syoudanSyouhin5);
		olineItemLIst.add(syoudanSyouhin6);
		insert olineItemLIst;
	}
	static testMethod void testMethod_Soukyakusyo(){

		Test.startTest();
		Opportunity opp = [SELECT ID FROM Opportunity WHERE Name = 'テスト商談'];
		ApexPages.StandardController sc = new ApexPages.StandardController(opp);

		Ctl_Soukyakusyo soukyakusyo = new Ctl_Soukyakusyo(sc);
		soukyakusyo.createSoukyakusyo();

        list<Opportunity> opp2 = [SELECT ID,SimpleYasugoRef__c FROM Opportunity WHERE Name = 'テスト商談'];
        List<id> idList = new List<id>();
        for(Opportunity Sopp :opp2){
			idList.add(Sopp.SimpleYasugoRef__c);           
        }
		Map<ID, SimpleYasugo__c> TESTSimpleYasugo = Dao_SimpleYasugo.getMapByIds(idList);
		list<SimpleYasugo__c> TESTSimpleYasugo2 = Dao_SimpleYasugo.getByIds(idList);
        list<SimpleYasugo__c> TESTSimpleYasugo3 = Dao_SimpleYasugo.getList('','');

        Test.stopTest();

	}
	static testMethod void testMethod_Soukyakusyo2(){
		
		//OsoshikiYoyaku パターン
		Test.startTest();
		Account acc = [SELECT ID FROM Account WHERE Name = 'アカウントtest'];
		acc.MemberTourokuZumi__c = true;
		update acc;
		Achievement__c acv =new Achievement__c(
            TorihikiSakiRef__c = acc.Id,
            Syubetsu__c = 'OsoshikiYoyaku',
            YukoFlag__c = true, 
            YukoKaishiBi__c = Date.today().addDays(-1)
        ) ;
		insert acv;

		Opportunity opp = [SELECT ID FROM Opportunity WHERE Name = 'テスト商談'];
		ApexPages.StandardController sc = new ApexPages.StandardController(opp);

		Ctl_Soukyakusyo soukyakusyo = new Ctl_Soukyakusyo(sc);
		soukyakusyo.createSoukyakusyo();
        Test.stopTest();
	}

	static testMethod void testMethod_Soukyakusyo3(){
		
		//Jizenwari パターン
		Test.startTest();
		Account acc = [SELECT ID FROM Account WHERE Name = 'アカウントtest'];
		acc.MemberTourokuZumi__c = true;
		update acc;
		Achievement__c acv =new Achievement__c(
            TorihikiSakiRef__c = acc.Id,
            Syubetsu__c = 'JizenJunbiWeb',
            YukoFlag__c = true, 
            YukoKaishiBi__c = Date.today().addDays(-1)
        ) ;
		insert acv;

		Opportunity opp = [SELECT ID FROM Opportunity WHERE Name = 'テスト商談'];
		ApexPages.StandardController sc = new ApexPages.StandardController(opp);

		Ctl_Soukyakusyo soukyakusyo = new Ctl_Soukyakusyo(sc);
		soukyakusyo.createSoukyakusyo();

        Test.stopTest();
	}
}