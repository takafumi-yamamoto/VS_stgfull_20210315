@isTest
public class Tes_Opportunity {

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

        KaiinkibanSetting__c Kaiinkibandefault = new KaiinkibanSetting__c(
			Name = 'default',
			client_id__c = '5',
			client_secret__c = 'EwbX0FwZGwnOHuvjty9PvjVIxbbNGeLDpeEqnmPh',
			grant_type__c = 'client_credentials',
			timeOutPeriod__c = 60000,
			Endpoint__c = 'https://dev-rakuso-core-api-external.minrevi.jp',
			KeiyakuCoreFlag__c = TRUE,
			IsShisetsuRenkeiYuko__c= TRUE,
			isActive__c= TRUE
		);
		insert Kaiinkibandefault;

        KaiinkibanSetting__c Kaiinkibandev = new KaiinkibanSetting__c(
			Name = 'dev',
			client_id__c = '5',
			client_secret__c = 'EwbX0FwZGwnOHuvjty9PvjVIxbbNGeLDpeEqnmPh',
			grant_type__c = 'client_credentials',
			timeOutPeriod__c = 60000,
			Endpoint__c = 'https://dev-rakuso-core-api-external.minrevi.jp',
			KeiyakuCoreFlag__c = TRUE,
			IsShisetsuRenkeiYuko__c= TRUE,
			isActive__c= TRUE
		);
		insert Kaiinkibandev;

        KaiinkibanSetting__c Kaiinkibanprod = new KaiinkibanSetting__c(
			Name = 'prod',
			client_id__c = '5',
			client_secret__c = 'EwbX0FwZGwnOHuvjty9PvjVIxbbNGeLDpeEqnmPh',
			grant_type__c = 'client_credentials',
			timeOutPeriod__c = 60000,
			Endpoint__c = 'https://dev-rakuso-core-api-external.minrevi.jp',
			KeiyakuCoreFlag__c = TRUE,
			IsShisetsuRenkeiYuko__c= TRUE,
			isActive__c= TRUE
		);
		insert Kaiinkibanprod;
	
		//カスタム設定のTriggerIsActive__cのデータを作成
		TriggerIsActive__c TriggerIsActive=new TriggerIsActive__c();
		TriggerIsActive.name='default';
		TriggerIsActive.isActive__c=true;
		insert TriggerIsActive;

		JizenWariPlan__c JizenWariPlan=new JizenWariPlan__c();
        JizenWariPlan.Code__c='Yoriso';
        insert JizenWariPlan;        

    }

	static testMethod void testCase1(){

        //取引先のデータ作成
		Account acc=new Account();
		acc.name='defualt';
		//acc.LastNameFurigana__pc ='defualt';
		//acc.FirstNameFurigana__pc ='defualt';
		acc.Phone='080-0000-0001';
		acc.MobilePhone__c='080-0000-0001';
		insert acc;

        // サービス特定用レコードID定義取得
	    Map<String, Schema.RecordTypeInfo> recordTypeInfos = Schema.SObjectType.Case.getRecordTypeInfosByName();
	    //ベスト仏壇
	    //id RecordTypeId1 = recordTypeInfos.get('ベスト仏壇').getRecordTypeId();
        //case c1=new case(accountid=acc.id,RecordTypeId=RecordTypeId1,Firstname__c=prex+'Firstname' + prex,Lastname__c='Lastnametest9'+prex,FirstNameKana__c='ファストカナ9'+prex,LastNameKana__c='ラストカナ9'+prex,TelNo__c='080-3727-7779',KiboAreaState__c='東京都',KiboAreaCity__c='中央区',MailAddress__c='test@i.ss.com');

        opportunity opp=new opportunity();
        opp.accountid=acc.id;
        opp.Name='test';
        opp.StageName='商談開始';
        opp.CloseDate=system.today();
		opp.TaishoushaJokyo__c = '_';
        Test.startTest();	
        insert opp;
        update opp;
        Test.stopTest();
    }

	static testMethod void testCase2(){

        //取引先のデータ作成
		Account acc=new Account();
		acc.name='defualt';
		//acc.LastNameFurigana__pc ='defualt';
		//acc.FirstNameFurigana__pc ='defualt';
		acc.Phone='080-0000-0001';
		acc.MobilePhone__c='080-0000-0001';
		insert acc;

		Pricebook2 standardPricebook = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = true
        );
        update standardPricebook;

        standardPricebook = [SELECT IsStandard FROM Pricebook2 WHERE Id = :standardPricebook.Id];
        system.debug('***standardPricebook='+standardPricebook);

        // Get standard price book ID.
        // This is available irrespective of the state of SeeAllData.
        Id pricebookId = Test.getStandardPricebookId();
		
        standardPricebook = [SELECT IsStandard FROM Pricebook2 WHERE Id = :standardPricebook.Id];
        system.debug('***standardPricebook='+standardPricebook);

		//Create your product
		Product2 prod = new Product2(
		     Name = 'Product X',
		     ProductCode = 'Pro-X',
		     DataKubun__c='2:割引プラン',     
		     isActive = true
		);
		insert prod;
		//Create your product
		Product2 prod1 = new Product2(
		     Name = 'Product X',
		     ProductCode = 'Pro-X',
		     DataKubun__c='3:クーポン',		     
		     isActive = true
		);
		insert prod1;		
		
		//Create your pricebook entry
		PricebookEntry pbEntry = new PricebookEntry(
		     Pricebook2Id = pricebookId,
		     Product2Id = prod.Id,
		     UnitPrice = 100.00,
		     IsActive = true
		);
		insert pbEntry;	
		PricebookEntry pbEntry1 = new PricebookEntry(
		     Pricebook2Id = pricebookId,
		     Product2Id = prod1.Id,
		     UnitPrice = 100.00,
		     IsActive = true
		);
		insert pbEntry1;
		
        opportunity opp = new opportunity();
        opp.accountid = acc.id;
        opp.Name = 'test';
        opp.StageName = '商談開始';
        opp.Req_Day__c = Date.today();
        opp.CloseDate = Date.today();
        opp.accountid = acc.id;
		opp.TaishoushaJokyo__c = '_';
        insert opp;
        
		PatnerUriage__c oPatnerUriage=new PatnerUriage__c();
		oPatnerUriage.Kingaku__c=100;
		oPatnerUriage.Syodan__c  =opp.id;
		oPatnerUriage.Syohin__c=prod1.id;
		insert oPatnerUriage;
		
		//create your opportunity line item.  This assumes you already have an opportunity created, called opp
		List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();
		OpportunityLineItem oli = new OpportunityLineItem(
		     OpportunityId = opp.Id,
		     Quantity = 5,
		     PricebookEntryId = pbEntry.Id,
		     TotalPrice =100// quantity * pbEntry.UnitPrice
		);
		oliList.add(oli);
		//insert oli;
		OpportunityLineItem oli1 = new OpportunityLineItem(
		     OpportunityId = opp.Id,
		     Quantity = 5,
		     PricebookEntryId = pbEntry1.Id,
		     TotalPrice = 100//quantity * pbEntry.UnitPrice
		);
		oliList.add(oli1);
		insert oliList;		
        
		// 商談クローズするために「請求方法」「請求金額」「決済日」を設定
		OkyakusamaSeikyuMeisai__c oOkyakusamaSeikyuMeisai = new OkyakusamaSeikyuMeisai__c();
		oOkyakusamaSeikyuMeisai.OpportunityRef__c = opp.id;
		oOkyakusamaSeikyuMeisai.SeikyuHouhou__c = 'orico_credit';
		oOkyakusamaSeikyuMeisai.SeikyuKingaku__c = 200;
		oOkyakusamaSeikyuMeisai.Kessaibi__c = Date.today();
		insert oOkyakusamaSeikyuMeisai;

        Test.startTest();	
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());     

		// 商談クローズするためにシンプル安豪の請求書受領日を設定
		// startTest 前に以下の update を実行すると「Too many SOQL queries」に引っかかるため、一時的にここに記載
        Opportunity opp1 = [SELECT SimpleYasugoRef__c FROM Opportunity WHERE Name = 'test'];
        SimpleYasugo__c simpleYasugo = new SimpleYasugo__c();
        simpleYasugo.Id = opp1.SimpleYasugoRef__c;
        simpleYasugo.SeikyushojuryoDay__c = Date.today();
		update simpleYasugo;

        opp.StageName = '商談クローズ';
        opp.ShoriStatus__c = '連携中';
        opp.KakuteibiSyodan__c = Date.today();
        opp.Utiagebi__c = Date.today();
        update opp;
        opp.StageName='商談開始';
        opp.ShoriStatus__c='連携中';
        update opp;
		System.Debug('Limits.getQueries()x01;' + Limits.getQueries());
        Test.stopTest();
    }

	static testMethod void testCase3(){

        //取引先のデータ作成
		Account acc=new Account();
		acc.name='defualt';
		//acc.LastNameFurigana__pc ='defualt';
		//acc.FirstNameFurigana__pc ='defualt';
		acc.Phone='080-0000-0001';
		acc.MobilePhone__c='080-0000-0001';
		insert acc;

		Pricebook2 standardPricebook = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = true
        );
        update standardPricebook;

        standardPricebook = [SELECT IsStandard FROM Pricebook2 WHERE Id = :standardPricebook.Id];
        system.debug('***standardPricebook='+standardPricebook);

        // Get standard price book ID.
        // This is available irrespective of the state of SeeAllData.
        List<k_ShohinSyubetsu__c> insK_ShohinSyubetsuList = new List<k_ShohinSyubetsu__c>();
        Id pricebookId = Test.getStandardPricebookId();
		k_ShohinSyubetsu__c k_ShohinSyubetsu=new k_ShohinSyubetsu__c();
		k_ShohinSyubetsu.ID__c='1';
		insK_ShohinSyubetsuList.add(k_ShohinSyubetsu);
		k_ShohinSyubetsu__c k_ShohinSyubetsu3=new k_ShohinSyubetsu__c();
		k_ShohinSyubetsu3.ID__c='3';
		insK_ShohinSyubetsuList.add(k_ShohinSyubetsu3);
		insert insK_ShohinSyubetsuList;
		
		//Create your product
		List<Product2> insProduct2List = new List<Product2>();
		Product2 prod = new Product2(
		     Name = 'Product X',
		     ProductCode = 'Pro-X',
		     DataKubun__c='1:通常商品',  		
		     k_ShohinSyubetsuRef__c=k_ShohinSyubetsu.id,
		     isActive = true
		);
		
		insProduct2List.add(prod);
		//Create your product
		Product2 prod1 = new Product2(
		     Name = 'Product X',
		     ProductCode = 'Pro-X',
		     DataKubun__c='3:クーポン',		     
		     isActive = true
		);
		insProduct2List.add(prod1);
		//Create your product
		Product2 prod2 = new Product2(
		     Name = 'Product X',
		     ProductCode = 'Pro-X',
		     DataKubun__c='2:割引プラン',		     
		     isActive = true
		);
		insProduct2List.add(prod2);
		//Create your product
		Product2 prod3 = new Product2(
		     Name = 'Product X',
		     ProductCode = 'Pro-X',
		     DataKubun__c='1:通常商品',  		
		     k_ShohinSyubetsuRef__c=k_ShohinSyubetsu3.id,
		     isActive = true
		);		
		insProduct2List.add(prod3);
		insert insProduct2List;

		//Create your pricebook entry
		List<PricebookEntry> insPricebookEntryList = new List<PricebookEntry>();
		PricebookEntry pbEntry = new PricebookEntry(
		     Pricebook2Id = pricebookId,
		     Product2Id = prod.Id,
		     UnitPrice = 100.00,
		     IsActive = true
		);
		insPricebookEntryList.add(pbEntry);	
		PricebookEntry pbEntry1 = new PricebookEntry(
		     Pricebook2Id = pricebookId,
		     Product2Id = prod1.Id,
		     UnitPrice = 100.00,
		     IsActive = true
		);
		insPricebookEntryList.add(pbEntry1);
		PricebookEntry pbEntry2 = new PricebookEntry(
		     Pricebook2Id = pricebookId,
		     Product2Id = prod2.Id,
		     UnitPrice = 100.00,
		     IsActive = true
		);
		insPricebookEntryList.add(pbEntry2);
		PricebookEntry pbEntry3 = new PricebookEntry(
		     Pricebook2Id = pricebookId,
		     Product2Id = prod3.Id,
		     UnitPrice = 100.00,
		     IsActive = true
		);		
		insPricebookEntryList.add(pbEntry3);
		insert insPricebookEntryList;
			
        opportunity opp=new opportunity();
        opp.accountid=acc.id;
        opp.Name='test';
        opp.StageName='商談開始';
        opp.Req_Day__c = Date.today();
        opp.CloseDate = Date.today();
        opp.accountid=acc.id;
		opp.TaishoushaJokyo__c = '_';
        opp.recordtypeid=RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo');
        insert opp;
        	
		PatnerUriage__c oPatnerUriage=new PatnerUriage__c();
		oPatnerUriage.Kingaku__c=100;
		oPatnerUriage.Syodan__c  =opp.id;
		oPatnerUriage.Syohin__c=prod1.id;
		insert oPatnerUriage;
		
		//create your opportunity line item.  This assumes you already have an opportunity created, called opp
		List<OpportunityLineItem> oliList =new List<OpportunityLineItem>();
		OpportunityLineItem oli = new OpportunityLineItem(
		     OpportunityId = opp.Id,
		     Quantity = 5,
		     PricebookEntryId = pbEntry.Id,
		     TotalPrice =100// quantity * pbEntry.UnitPrice
		);
		oliList.add(oli);
		OpportunityLineItem oli1 = new OpportunityLineItem(
		     OpportunityId = opp.Id,
		     Quantity = 5,
		     PricebookEntryId = pbEntry1.Id,
		     TotalPrice = 100//quantity * pbEntry.UnitPrice
		);
		oliList.add(oli1);
		
		OpportunityLineItem oli2 = new OpportunityLineItem(
		     OpportunityId = opp.Id,
		     Quantity = 5,
		     PricebookEntryId = pbEntry2.Id,
		     TotalPrice = 100//quantity * pbEntry.UnitPrice
		);
		oliList.add(oli2);
		insert oliList;
		/*	
		OpportunityLineItem oli3 = new OpportunityLineItem(
		     OpportunityId = opp.Id,
		     Quantity = 5,
		     PricebookEntryId = pbEntry3.Id,
		     TotalPrice = 100//quantity * pbEntry.UnitPrice
		);
		insert oli3;*/
		
		List<OkyakusamaSeikyuMeisai__c> insOkyakusamaSeikyuMeisaiList = new List<OkyakusamaSeikyuMeisai__c>();
		OkyakusamaSeikyuMeisai__c oOkyakusamaSeikyuMeisai=new OkyakusamaSeikyuMeisai__c();
		oOkyakusamaSeikyuMeisai.OpportunityRef__c=opp.id;
		oOkyakusamaSeikyuMeisai.SeikyuHouhou__c = 'orico_credit';
		oOkyakusamaSeikyuMeisai.SeikyuKingaku__c = 300;
		oOkyakusamaSeikyuMeisai.Kessaibi__c = Date.today();
		insOkyakusamaSeikyuMeisaiList.add(oOkyakusamaSeikyuMeisai);
		
		OkyakusamaSeikyuMeisai__c oOkyakusamaSeikyuMeisai1=new OkyakusamaSeikyuMeisai__c();
		oOkyakusamaSeikyuMeisai1.OpportunityRef__c=opp.id;
		oOkyakusamaSeikyuMeisai1.SeikyuHouhou__c='sousai';
		insOkyakusamaSeikyuMeisaiList.add(oOkyakusamaSeikyuMeisai1);
        insert insOkyakusamaSeikyuMeisaiList;

		Test.startTest();

		// 商談クローズするためにシンプル安豪の請求書受領日を設定
		// startTest 前に以下の update を実行すると「Too many SOQL queries」に引っかかるため、一時的にここに記載
        Opportunity opp1 = [SELECT SimpleYasugoRef__c FROM Opportunity WHERE Name = 'test'];
        SimpleYasugo__c simpleYasugo = new SimpleYasugo__c();
        simpleYasugo.Id = opp1.SimpleYasugoRef__c;
        simpleYasugo.SeikyushojuryoDay__c = Date.today();
		update simpleYasugo;

		opp.KakuteibiSyodan__c = Date.today();
        opp.Utiagebi__c = Date.today();
        update opp;

        opp.StageName='商談クローズ';
        update opp;
        Test.stopTest();
    }

	static testMethod void testCase4(){

        //取引先のデータ作成
		Account acc=new Account();
		acc.name='defualt';
		//acc.LastNameFurigana__pc ='defualt';
		//acc.FirstNameFurigana__pc ='defualt';
		acc.Phone='080-0000-0001';
		acc.MobilePhone__c='080-0000-0001';
		insert acc;

		Pricebook2 standardPricebook = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = true
        );
        update standardPricebook;

        standardPricebook = [SELECT IsStandard FROM Pricebook2 WHERE Id = :standardPricebook.Id];
        system.debug('***standardPricebook='+standardPricebook);

        // Get standard price book ID.
        // This is available irrespective of the state of SeeAllData.
        List<k_ShohinSyubetsu__c> insK_ShohinSyubetsuList = new List<k_ShohinSyubetsu__c>();
        Id pricebookId = Test.getStandardPricebookId();
		k_ShohinSyubetsu__c k_ShohinSyubetsu=new k_ShohinSyubetsu__c();
		k_ShohinSyubetsu.ID__c='1';
		insK_ShohinSyubetsuList.add(k_ShohinSyubetsu);
		k_ShohinSyubetsu__c k_ShohinSyubetsu3=new k_ShohinSyubetsu__c();
		k_ShohinSyubetsu3.ID__c='3';
		insK_ShohinSyubetsuList.add(k_ShohinSyubetsu3);		
		insert insK_ShohinSyubetsuList;
		//Create your product

		List<Product2> prodList = new List<Product2>();
		Product2 prod = new Product2(
		     Name = 'Product X',
		     ProductCode = 'Pro-X',
		     DataKubun__c='1:通常商品',  		
		     k_ShohinSyubetsuRef__c=k_ShohinSyubetsu.id,
		     isActive = true
		);
		prodList.add(prod);
		//Create your product
		Product2 prod1 = new Product2(
		     Name = 'Product X',
		     ProductCode = 'Pro-X',
		     DataKubun__c='2:割引プラン',		     
		     isActive = true
		);
		prodList.add(prod1);
		//Create your product
		Product2 prod2 = new Product2(
		     Name = 'Product X',
		     ProductCode = 'Pro-X',
		     DataKubun__c='2:割引プラン',		     
		     isActive = true
		);
		prodList.add(prod2);
		//Create your product
		Product2 prod3 = new Product2(
		     Name = 'Product X',
		     ProductCode = 'Pro-X',
		     DataKubun__c='1:通常商品',  		
		     k_ShohinSyubetsuRef__c=k_ShohinSyubetsu3.id,
		     isActive = true
		);		
		prodList.add(prod3);
		insert prodList;		

		//Create your pricebook entry
		List<PricebookEntry> pbEntryList = new List<PricebookEntry>();
		PricebookEntry pbEntry = new PricebookEntry(
		     Pricebook2Id = pricebookId,
		     Product2Id = prod.Id,
		     UnitPrice = 100.00,
		     IsActive = true
		);
		pbEntryList.add(pbEntry);
		PricebookEntry pbEntry1 = new PricebookEntry(
		     Pricebook2Id = pricebookId,
		     Product2Id = prod1.Id,
		     UnitPrice = 100.00,
		     IsActive = true
		);
		pbEntryList.add(pbEntry1);
		PricebookEntry pbEntry2 = new PricebookEntry(
		     Pricebook2Id = pricebookId,
		     Product2Id = prod2.Id,
		     UnitPrice = 100.00,
		     IsActive = true
		);
		pbEntryList.add(pbEntry2);
		PricebookEntry pbEntry3 = new PricebookEntry(
		     Pricebook2Id = pricebookId,
		     Product2Id = prod3.Id,
		     UnitPrice = 100.00,
		     IsActive = true
		);		
		pbEntryList.add(pbEntry3);
		insert pbEntryList;	
			
        opportunity opp=new opportunity();
        opp.accountid=acc.id;
        opp.Name='test';
        opp.StageName='商談開始';
        opp.Req_Day__c = Date.today();
        opp.CloseDate = Date.today();
		opp.TaishoushaJokyo__c = '_';
        opp.accountid=acc.id;
        opp.recordtypeid=RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo');
        insert opp;
        	
		PatnerUriage__c oPatnerUriage=new PatnerUriage__c();
		oPatnerUriage.Kingaku__c=100;
		oPatnerUriage.Syodan__c  =opp.id;
		oPatnerUriage.Syohin__c=prod1.id;
		insert oPatnerUriage;        
        
		//create your opportunity line item.  This assumes you already have an opportunity created, called opp
		List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();
		OpportunityLineItem oli = new OpportunityLineItem(
		     OpportunityId = opp.Id,
		     Quantity = 5,
		     PricebookEntryId = pbEntry.Id,
		     TotalPrice =100// quantity * pbEntry.UnitPrice
		);
		oliList.add(oli);
		OpportunityLineItem oli1 = new OpportunityLineItem(
		     OpportunityId = opp.Id,
		     Quantity = 5,
		     PricebookEntryId = pbEntry1.Id,
		     TotalPrice = 100//quantity * pbEntry.UnitPrice
		);
		oliList.add(oli1);
		
		OpportunityLineItem oli2 = new OpportunityLineItem(
		     OpportunityId = opp.Id,
		     Quantity = 5,
		     PricebookEntryId = pbEntry2.Id,
		     TotalPrice = 100//quantity * pbEntry.UnitPrice
		);
		oliList.add(oli2);
		insert oliList;
		/*	
		OpportunityLineItem oli3 = new OpportunityLineItem(
		     OpportunityId = opp.Id,
		     Quantity = 5,
		     PricebookEntryId = pbEntry3.Id,
		     TotalPrice = 100//quantity * pbEntry.UnitPrice
		);
		insert oli3;*/
		
		List<OkyakusamaSeikyuMeisai__c> insOkyakusamaSeikyuMeisai = new List<OkyakusamaSeikyuMeisai__c>();
		OkyakusamaSeikyuMeisai__c oOkyakusamaSeikyuMeisai=new OkyakusamaSeikyuMeisai__c();
		oOkyakusamaSeikyuMeisai.OpportunityRef__c=opp.id;
		oOkyakusamaSeikyuMeisai.SeikyuHouhou__c = 'orico_loan';
		oOkyakusamaSeikyuMeisai.SeikyuKingaku__c = 300;
		oOkyakusamaSeikyuMeisai.Kessaibi__c = Date.today();
		insOkyakusamaSeikyuMeisai.add(oOkyakusamaSeikyuMeisai);
		
		OkyakusamaSeikyuMeisai__c oOkyakusamaSeikyuMeisai1=new OkyakusamaSeikyuMeisai__c();
		oOkyakusamaSeikyuMeisai1.OpportunityRef__c=opp.id;
		oOkyakusamaSeikyuMeisai1.SeikyuHouhou__c='sousai';
		insOkyakusamaSeikyuMeisai.add(oOkyakusamaSeikyuMeisai1);
        insert insOkyakusamaSeikyuMeisai;

		Test.startTest();

		// 商談クローズするためにシンプル安豪の請求書受領日を設定
		// startTest 前に以下の update を実行すると「Too many SOQL queries」に引っかかるため、一時的にここに記載
        Opportunity opp1 = [SELECT SimpleYasugoRef__c FROM Opportunity WHERE Name = 'test'];
        SimpleYasugo__c simpleYasugo = new SimpleYasugo__c();
        simpleYasugo.Id = opp1.SimpleYasugoRef__c;
        simpleYasugo.SeikyushojuryoDay__c = Date.today();
		update simpleYasugo;

		opp.KakuteibiSyodan__c = Date.today();
        opp.Utiagebi__c = Date.today();
        update opp;

        opp.StageName='商談クローズ';
        update opp;
        Test.stopTest();
    }     
    /**
     * クロスセル提案がある場合に売上日更新された場合
     */
    static testMethod void testCase5(){

        Account Acc=new Account();
		Acc.name='テスト';
		insert Acc;
		
		Case c=new Case();
		c.accountid=Acc.id;
		c.description='テスト';
		insert c;
	
	    // 商談
		String oppTorihikiShodanRdId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','TorihikiShodan');
		Opportunity opp = new Opportunity(Name = 'テスト商談', AccountId = acc.Id, CaseRef__c=c.id,RecordTypeId = oppTorihikiShodanRdId, StageName = 'フォロー',CloseDate = system.today());	
		insert opp;	

        //==============SimpleYasugo__c===============
        SimpleYasugo__c simpleYasugo = new SimpleYasugo__c(CaseRef__c = c.Id);
		insert simpleYasugo;			
	    String oppSimpleYasugoRdId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo');
		Opportunity oppSimpleYasugo = new Opportunity(
			Name = 'テスト商談', AccountId = acc.Id, CaseRef__c=c.id,RecordTypeId = oppSimpleYasugoRdId, SimpleYasugoRef__c=simpleYasugo.id, 
			TorihikiShodanRef__c=opp.id,StageName = 'フォロー',CloseDate = system.today(), TaishoushaJokyo__c = '_'
			);
        	
		insert oppSimpleYasugo;
		
		//クロスセル提案をInsertする
		CrossSellingTeian__c csteian = new CrossSellingTeian__c();
		csteian.OpportunityRef__c = oppSimpleYasugo.Id;
		csteian.TeianShohin__c = '永代供養';
		csteian.TeianKekka__c = 'クロスセル希望あり';
		insert csteian;

		Test.startTest();
		//クロスセル元の商談の売上日を更新する
		oppSimpleYasugo.Utiagebi__c = date.today();
		update oppSimpleYasugo;
		Test.stopTest();

		//クロスセル先の商談の「よりそうのお葬式施工日」を更新していることを確認する
		CrossSellingTeian__c resultCsteian = [SELECT ID,CrossSellingSakiOpportunityRef__c FROM CrossSellingTeian__c WHERE ID =:csteian.Id];
		
		if(resultCsteian.CrossSellingSakiOpportunityRef__c!=null){
			Opportunity resultCrossSellSakiOpportunity = [SELECT ID,YorisonoOsoshikiSekobi__c FROM Opportunity WHERE ID = :resultCsteian.CrossSellingSakiOpportunityRef__c];
			System.assertEquals(oppSimpleYasugo.Utiagebi__c, resultCrossSellSakiOpportunity.YorisonoOsoshikiSekobi__c);
		}

    }

    /**
     * 商談商品を更新した場合
     */
    static testMethod void testCase6(){

        Account Acc=new Account();
		Acc.name='テスト';
		insert Acc;
		
		Case c=new Case();
		c.accountid=Acc.id;
		c.description='テスト';
		insert c;

		Pricebook2 standardPricebook = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = true
        );
        update standardPricebook;

        standardPricebook = [SELECT IsStandard FROM Pricebook2 WHERE Id = :standardPricebook.Id];
        system.debug('***standardPricebook='+standardPricebook);

        // Get standard price book ID.
        // This is available irrespective of the state of SeeAllData.
        List<k_ShohinSyubetsu__c> insK_ShohinSyubetsuList = new List<k_ShohinSyubetsu__c>();
        Id pricebookId = Test.getStandardPricebookId();
		k_ShohinSyubetsu__c k_ShohinSyubetsu=new k_ShohinSyubetsu__c();
		k_ShohinSyubetsu.ID__c='1';
		insK_ShohinSyubetsuList.add(k_ShohinSyubetsu);
		k_ShohinSyubetsu__c k_ShohinSyubetsu3=new k_ShohinSyubetsu__c();
		k_ShohinSyubetsu3.ID__c='3';
		insK_ShohinSyubetsuList.add(k_ShohinSyubetsu3);		
		insert insK_ShohinSyubetsuList;
		//Create your product

		List<Product2> prodList = new List<Product2>();
		Product2 prod = new Product2(
		     Name = 'Product X',
		     ProductCode = 'Pro-X',
		     DataKubun__c='1:通常商品',  		
		     k_ShohinSyubetsuRef__c=k_ShohinSyubetsu.id,
		     isActive = true
		);
		prodList.add(prod);
		//Create your product
		Product2 prod1 = new Product2(
		     Name = 'Product X',
		     ProductCode = 'Pro-X',
		     DataKubun__c='2:割引プラン',		     
		     isActive = true
		);
		prodList.add(prod1);
		//Create your product
		Product2 prod2 = new Product2(
		     Name = 'Product X',
		     ProductCode = 'Pro-X',
		     DataKubun__c='2:割引プラン',		     
		     isActive = true
		);
		prodList.add(prod2);
		//Create your product
		Product2 prod3 = new Product2(
		     Name = 'Product X',
		     ProductCode = 'Pro-X',
		     DataKubun__c='1:通常商品',  		
		     k_ShohinSyubetsuRef__c=k_ShohinSyubetsu3.id,
		     isActive = true
		);		
		prodList.add(prod3);
		insert prodList;		

		//Create your pricebook entry
		List<PricebookEntry> pbEntryList = new List<PricebookEntry>();
		PricebookEntry pbEntry = new PricebookEntry(
		     Pricebook2Id = pricebookId,
		     Product2Id = prod.Id,
		     UnitPrice = 100.00,
		     IsActive = true
		);
		pbEntryList.add(pbEntry);
		PricebookEntry pbEntry1 = new PricebookEntry(
		     Pricebook2Id = pricebookId,
		     Product2Id = prod1.Id,
		     UnitPrice = 100.00,
		     IsActive = true
		);
		pbEntryList.add(pbEntry1);
		PricebookEntry pbEntry2 = new PricebookEntry(
		     Pricebook2Id = pricebookId,
		     Product2Id = prod2.Id,
		     UnitPrice = 100.00,
		     IsActive = true
		);
		pbEntryList.add(pbEntry2);
		PricebookEntry pbEntry3 = new PricebookEntry(
		     Pricebook2Id = pricebookId,
		     Product2Id = prod3.Id,
		     UnitPrice = 100.00,
		     IsActive = true
		);		
		pbEntryList.add(pbEntry3);
		insert pbEntryList;	



	    // 商談
		String oppTorihikiShodanRdId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','TorihikiShodan');
		Opportunity opp = new Opportunity(Name = 'テスト商談', AccountId = acc.Id, CaseRef__c=c.id,RecordTypeId = oppTorihikiShodanRdId, StageName = 'フォロー',CloseDate = system.today());	
		insert opp;	

        //==============SimpleYasugo__c===============
        SimpleYasugo__c simpleYasugo = new SimpleYasugo__c(CaseRef__c = c.Id);
		insert simpleYasugo;			
	    String oppSimpleYasugoRdId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo');
		Opportunity oppSimpleYasugo = new Opportunity(
			Name = 'テスト商談', AccountId = acc.Id, CaseRef__c=c.id,RecordTypeId = oppSimpleYasugoRdId, SimpleYasugoRef__c=simpleYasugo.id, 
			TorihikiShodanRef__c=opp.id,StageName = 'フォロー',CloseDate = system.today(), TaishoushaJokyo__c = '_'
			);
        	
		insert oppSimpleYasugo;
		
		//商談商品
		List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();
		OpportunityLineItem oli = new OpportunityLineItem(
		     OpportunityId = opp.Id,
		     Quantity = 5,
		     PricebookEntryId = pbEntry.Id,
			 HinmokuBunrui__c = '返礼品',
		     TotalPrice =100// quantity * pbEntry.UnitPrice
		);
		oliList.add(oli);
		OpportunityLineItem oli1 = new OpportunityLineItem(
		     OpportunityId = opp.Id,
		     Quantity = 5,
		     PricebookEntryId = pbEntry1.Id,
			 HinmokuBunrui__c = '祭壇',
		     TotalPrice = 100//quantity * pbEntry.UnitPrice
		);
		oliList.add(oli1);
		
		OpportunityLineItem oli2 = new OpportunityLineItem(
		     OpportunityId = opp.Id,
		     Quantity = 5,
		     PricebookEntryId = pbEntry2.Id,
			 HinmokuBunrui__c = 'エンバーミング',
		     TotalPrice = 100//quantity * pbEntry.UnitPrice
		);
		oliList.add(oli2);
		insert oliList;


		Test.startTest();
		//商談商品を更新・削除する
		List<OpportunityLineItem> updateOliList = new List<OpportunityLineItem>();
		for(OpportunityLineItem olitem:oliList){
			OpportunityLineItem updateolitem = new OpportunityLineItem();
			updateolitem.Id = olitem.Id;
			updateolitem.Quantity = 1;
			updateOliList.add(updateolitem);
		}
		update updateOliList;
		delete updateOliList.get(0);
		Test.stopTest();
    }

    /**
     * 商談フェーズを（以下の通りに）更新した際に確定日がクリアされることを確認する
	 * （シンプル安豪の場合）
	 *  変更前：「決定」「施行待ち」「施行完了」「商談クローズ」
	 *  変更後：上記以外のフェーズ
     */
    static testMethod void testCase7(){
		Account Acc=new Account();
		Acc.name='テスト';
		insert Acc;
		
		Case c=new Case();
		c.accountid=Acc.id;
		c.description='テスト';
		insert c;
	
	    // 商談
		String oppTorihikiShodanRdId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','TorihikiShodan');
		Opportunity opp = new Opportunity(Name = 'テスト商談', AccountId = acc.Id, CaseRef__c=c.id,RecordTypeId = oppTorihikiShodanRdId, StageName = 'フォロー',CloseDate = system.today());	
		insert opp;	

        //==============SimpleYasugo__c===============
        SimpleYasugo__c simpleYasugo = new SimpleYasugo__c(CaseRef__c = c.Id);
		insert simpleYasugo;			
	    String oppSimpleYasugoRdId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo');
		Opportunity oppSimpleYasugo = new Opportunity(
			Name = 'テスト商談', AccountId = acc.Id, CaseRef__c=c.id,RecordTypeId = oppSimpleYasugoRdId, SimpleYasugoRef__c=simpleYasugo.id, 
			TorihikiShodanRef__c=opp.id,StageName = '決定',CloseDate = system.today(), TaishoushaJokyo__c = '_',KiboShiharaiHouhou__c='現金',KakuteibiSyodan__c = system.today(), SurveyDiscountAgreeStatus__c = '同意済'
			);
        	
		insert oppSimpleYasugo;
		
		Test.startTest();
		//フェーズをフォローに変える
		oppSimpleYasugo.StageName = 'フォロー';
		update oppSimpleYasugo;
		Test.stopTest();

		Opportunity resultOpp = [SELECT Id,KakuteibiSyodan__c FROM Opportunity WHERE Id =:oppSimpleYasugo.Id];
		System.assertEquals(null, resultOpp.KakuteibiSyodan__c);
	}
}