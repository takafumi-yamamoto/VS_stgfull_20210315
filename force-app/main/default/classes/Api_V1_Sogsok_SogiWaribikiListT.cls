@isTest
private class Api_V1_Sogsok_SogiWaribikiListT
{
    @isTest
    public static void exception(){
	    Test.startTest();
	        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/api/v1/sogsok/sogiwaribikilist';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
		Api_V1_Sogsok_SogiWaribikiList.doPost();

        Test.stopTest();
    }

	@isTest static void test_method_one() {

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
             ShohinBango__c = 'SBG-0000001',
             DataKubun__c='1:通常商品',        
             k_ServiceRef__c=k_service16.id,        
             k_ShohinSyubetsuRef__c=k_shohinsyubetsu0.id,
             isActive = true
        );
        prodList.add(prod);
        //Create your product
        Product2 prod1 = new Product2(
             Name = 'Product X',
             ProductCode = 'Pro-X',
             DataKubun__c='2:割引プラン',     
             k_ServiceRef__c=k_service16.id,         
             k_ShohinSyubetsuRef__c=k_shohinsyubetsu0.id,
             isActive = true
        );
        prodList.add(prod1);
        //Create your product
        Product2 prod2 = new Product2(
             Name = 'Product X',
             ProductCode = 'Pro-X',
             DataKubun__c='3:クーポン',           
             k_ServiceRef__c=k_service16.id,
             k_ShohinSyubetsuRef__c=k_shohinsyubetsu0.id,
             isActive = true
        );
        prodList.add(prod2);
        //Create your product
        Product2 prod3 = new Product2(
             Name = 'Product X',
             ProductCode = 'Pro-X',
             DataKubun__c='1:通常商品',          
             k_ServiceRef__c=k_service16.id,
             k_ShohinSyubetsuRef__c=k_shohinsyubetsu0.id,
             isActive = true
        );      
        prodList.add(prod3);
        Product2 prod4 = new Product2(
             Name = 'Product Y',
             ProductCode = 'Pro-Y',
             ShohinBango__c = 'SBG-0000002',
             DataKubun__c='1:通常商品',        
             k_ServiceRef__c=k_service16.id,        
             k_ShohinSyubetsuRef__c=k_shohinsyubetsu0.id,
             isActive = true
        );
        prodList.add(prod4);
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

        Case c=new Case();
        c.accountid=acc.id;
        c.description='テスト';
        insert c;
    
        // 商談
        String oppTorihikiShodanRdId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','TorihikiShodan');
        Opportunity opp = new Opportunity(Name = 'テスト商談', AccountId = acc.Id, CaseRef__c=c.id,RecordTypeId = oppTorihikiShodanRdId, StageName = 'フォロー',CloseDate = system.today()); 
        insert opp; 
        String theShodanBango = [SELECT ShodanBango__c FROM Opportunity WHERE Id = :opp.Id ].get(0).ShodanBango__c;

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
        Opportunity oppSimpleYa = [select id,SimpleYasugoRef__c, ShodanBangoF__c from Opportunity where id = :oppSimpleYasugo.Id];
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
        OpportunityLineItem oli1 = new OpportunityLineItem(
             OpportunityId = oppSimpleYasugo.Id,
             Quantity = 5,
             PricebookEntryId = pbEntry1.Id,
             TotalPrice = 100//quantity * pbEntry.UnitPrice
        );
        oliList.add(oli1);
        
        OpportunityLineItem oli2 = new OpportunityLineItem(
             OpportunityId = oppSimpleYasugo.Id,
             Quantity = 5,
             PricebookEntryId = pbEntry2.Id,
             TotalPrice = 100//quantity * pbEntry.UnitPrice
        );
        oliList.add(oli2);
        OpportunityLineItem oli3 = new OpportunityLineItem(
             OpportunityId = oppSimpleYasugo.Id,
             Quantity = 5,
             PricebookEntryId = pbEntry3.Id,
             TotalPrice = 100//quantity * pbEntry.UnitPrice
        );
        oliList.add(oli3);      
        insert oliList;

        SogSok_Sokyaku__c sokyaku = new SogSok_Sokyaku__c(OpportunityRef__c=oppSimpleYasugo.Id);
        insert sokyaku;
        sokyaku = [select id, name from SogSok_Sokyaku__c where id =:sokyaku.Id];

        Api_V1_Sogsok_SogiWaribikiList.Data theData = new Api_V1_Sogsok_SogiWaribikiList.Data();
        theData.opp_code = theShodanBango; theData.plan_code = 'SBG-0000002';
        String json = JSON.serialize(theData);


		// Implement test code
	    Test.startTest();
	        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/api/v1/sogsok/sogiwaribikilist';
        req.httpMethod = 'POST';
	    req.requestBody = Blob.valueof(json);

        RestContext.request = req;
        RestContext.response= res;
        
		Api_V1_Sogsok_SogiWaribikiList.doPost();

        Test.stopTest();
	}
}