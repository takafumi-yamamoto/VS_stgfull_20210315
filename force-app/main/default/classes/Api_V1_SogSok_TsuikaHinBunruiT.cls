@isTest
private class Api_V1_SogSok_TsuikaHinBunruiT {
	
	@isTest static void test_method_one() {

		// Implement test code
	    Test.startTest();
	        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/api/v1/sogsok/waribiki';
        req.httpMethod = 'GET';
	    //req.requestBody = Blob.valueof(json);

        RestContext.request = req;
        RestContext.response= res;
        
		Api_V1_SogSok_TsuikaHinBunrui.doGet();

        Test.stopTest();
	}

	@isTest static void test_method_two() {

		PtWebAccount__c ptWebAccount = new PtWebAccount__c(mailAddress__c='completedtest@yoriso.com');
        insert ptWebAccount;

        SampleData sampledata = new sampleData();

        List<Account> accList = new List<Account>();
        accList.add(sampledata.getAccountNull());
        accList.add(sampledata.getAccountSoryo());

        Account acc = sampledata.getAccountCustomer();
        acc.FirstNameFurigana__pc = 'テスト1';
        acc.LastNameFurigana__pc = 'テスト1';
        acc.Phone = '080-0000-1111';
        acc.MobilePhone__c = '090-0000-1112';
        accList.add(acc);


        Account taisyousya = sampledata.getAccountCustomer();
        taisyousya.FirstNameFurigana__pc = 'テスト2';
        taisyousya.LastNameFurigana__pc = 'テスト2';
        taisyousya.PersonBirthdate = date.today().addYears(-80);
        taisyousya.PersonDeathDate__pc = date.today();
        taisyousya.Phone = '080-0000-1113';
        taisyousya.MobilePhone__c = '090-0000-1114';
        accList.add(taisyousya);


        Account moshu = sampledata.getAccountCustomer();
        moshu.FirstNameFurigana__pc = 'テスト3';
        moshu.LastNameFurigana__pc = 'テスト3';
        moshu.PersonBirthdate = date.today().addYears(-80);
        moshu.PersonDeathDate__pc = date.today();
        moshu.Phone = '080-2019-0122';
        moshu.MobilePhone__c = '090-2019-0122';
        accList.add(moshu);


        accList.add(sampledata.getAccountDefault());
        accList.add(sampledata.getAccountJiin());
        accList.add(sampledata.getAccountMosyuDaikoSya());

        Account sougisya = sampledata.getAccountSogisya();
        sougisya.PtWebAccountRef__c = ptWebAccount.Id;
        sougisya.PtWebAcceptedDate__c = Date.today();
        accList.add(sougisya);
        insert accList;

        Keiyaku__c keiyaku = new Keiyaku__c();
        RecordType keiyakuRT = new RecordTypeDao().selectRecordBySobjectTypeDeveloperName('Keiyaku__c', 'SimpleYasugo');
        keiyaku.recordTypeId = keiyakuRT.Id;
        keiyaku.Teikeisaki__c = sougisya.Id;
        insert keiyaku;


        k_Service__c k_service16 = new k_Service__c();
        k_service16.name = 'シンプルなお葬式';   // サービス名
        k_service16.id__c = '1';   // ID
        insert k_service16;
        k_ShohinSyubetsu__c k_shohinsyubetsu0 = new k_ShohinSyubetsu__c();
        k_shohinsyubetsu0.name = '本体（委託）';   // 商品種別名
        k_shohinsyubetsu0.id__c = '1';   // ID
        k_shohinsyubetsu0.keijousyubetsu__c = 'グロス';   // 計上種別
        insert k_shohinsyubetsu0;

        List<Product2> prodList = new List<Product2>();
        Product2 prod = new Product2(
             Name = 'Product X',
             ProductCode = 'Pro-X',
             DataKubun__c='1:通常商品',        
             k_ServiceRef__c=k_service16.id,        
             k_ShohinSyubetsuRef__c=k_shohinsyubetsu0.id,
             isActive = true,
             HanbaiKaishiBi__c=date.newInstance(2019, 9, 30)
        );
        prodList.add(prod);
        insert prodList;

        Id pricebookId = Test.getStandardPricebookId();
        //Create your pricebook entry
        List<PricebookEntry> pbEntryList = new List<PricebookEntry>();
        PricebookEntry pbEntry = new PricebookEntry(
             Pricebook2Id = pricebookId,
             Product2Id = prod.Id,
             UnitPrice = 100.00,
             IsActive = true
        );
        pbEntryList.add(pbEntry);
        insert pbEntryList; 

        Case c=new Case();
        c.accountid=acc.id;
        c.description='テスト';
        insert c;
    
        // 商談
        String oppTorihikiShodanRdId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','TorihikiShodan');
        Opportunity opp = new Opportunity(Name = 'テスト商談', AccountId = acc.Id, CaseRef__c=c.id,RecordTypeId = oppTorihikiShodanRdId, StageName = 'フォロー',CloseDate = system.today()); 
        insert opp; 

        //==============SimpleYasugo__c===============
        //SimpleYasugo__c simpleYasugo = new SimpleYasugo__c(CaseRef__c = c.Id,
        //  SimpleYasugoKeiyakuRef__c = keiyaku.Id
        //  );
        //insert simpleYasugo;          
        String oppSimpleYasugoRdId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo');
        Opportunity oppSimpleYasugo = new Opportunity(
            Name = 'テスト商談', 
            AccountId = acc.Id, 
            TaishosyaRef__c = taisyousya.Id, 
            CaseRef__c=c.id,RecordTypeId = oppSimpleYasugoRdId, 
            TorihikiShodanRef__c=opp.id,StageName = 'フォロー',CloseDate = system.today(), TaishoushaJokyo__c = '_',
            KiboShiharaiHouhou__c='銀行振込',
            KakuteibiSyodan__c = date.today()
            );  
        insert oppSimpleYasugo; 

        //SimpleYasugoRef__c=simpleYasugo.id, 
        Opportunity oppSimpleYa = [select id,SimpleYasugoRef__c from Opportunity where id = :oppSimpleYasugo.Id];
        update new SimpleYasugo__c(Id=oppSimpleYa.SimpleYasugoRef__c, 
                                    TaishoshaRef__c = taisyousya.Id, 
                                    MoshuRef__c = moshu.Id, 
                                    SimpleYasugoKeiyakuRef__c = keiyaku.Id,
                                    TaiouKanouRiyu__c = '対応可能（斎場優先）',
                                    OmukaeSakiName__c='東京',
                                    OmukaeSakiCity__c='東京',
                                    OmukaeSakiState__c='港区',
                                    OmukaeSakiStreet__c='五反田',
                                    OmukaeSakiZipcode__c='150-0001',
                                    KiboGoanchisaki__c='不明',
                                    GoanchisakiJusho__c='不明'
            );


        //create your opportunity line item.  This assumes you already have an opportunity created, called opp
        List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();
        OpportunityLineItem oli = new OpportunityLineItem(
             OpportunityId = oppSimpleYasugo.Id,
             Quantity = 5,
             PricebookEntryId = pbEntry.Id,
             TotalPrice =100// quantity * pbEntry.UnitPrice
        );
        oliList.add(oli);    
        insert oliList;

        Opportunity sltOpp = [select Id, ShodanBango__c from Opportunity where Id = :oppSimpleYa.Id];

		// Implement test code
	    Test.startTest();
	        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/api/v1/sogsok/tsuikahin_bunrui';
        req.httpMethod = 'GET';
	    req.params.put('opp_code', sltOpp.ShodanBango__c);

        RestContext.request = req;
        RestContext.response= res;
        
		Api_V1_SogSok_TsuikaHinBunrui.doGet();

        Test.stopTest();
	}
	
}