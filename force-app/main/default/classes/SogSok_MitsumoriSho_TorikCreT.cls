@isTest
private class SogSok_MitsumoriSho_TorikCreT {
    
    @isTest static void test_method_one() {
        Insert new TriggerIsActive__c( name='default', isActive__c=true );

        SogSok_MitsumoriSho__c sogsok_mitsumorisho = new SogSok_MitsumoriSho__c(DocStatus__c = 'draft');
        insert sogsok_mitsumorisho;
        
        sogsok_mitsumorisho.DocStatus__c = 'Activated';
        update sogsok_mitsumorisho;
    }

    @isTest static void test_method_2() {
        Insert new TriggerIsActive__c( name='default', isActive__c=true );
        
        SogSok_MitsumoriSho__c sogsok_mitsumorisho = new SogSok_MitsumoriSho__c(DocStatus__c = 'Activated');
        insert sogsok_mitsumorisho;
        
        SogSok_MitsumoriSho_TorikCre.run();
    }

    @isTest static void test_method_3() {

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
        sougisya.recordTypeId = new RecordTypeDao().selectRecordBySobjectTypeDeveloperName('Account', 'Sogisya').Id;
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

        List<k_ShohinSyubetsu__c> k_shohinsyubetsuList = new List<k_ShohinSyubetsu__c>();
        k_ShohinSyubetsu__c k_shohinsyubetsu0 = new k_ShohinSyubetsu__c();
        k_shohinsyubetsu0.name = '本体（委託）';   // 商品種別名
        k_shohinsyubetsu0.id__c = '1';   // ID
        k_shohinsyubetsu0.keijousyubetsu__c = 'グロス';   // 計上種別
        k_shohinsyubetsuList.add(k_shohinsyubetsu0);

        k_ShohinSyubetsu__c k_shohinsyubetsu2 = new k_ShohinSyubetsu__c();
        k_shohinsyubetsu2.name = 'オプション（委託）';   // 商品種別名
        k_shohinsyubetsu2.id__c = '3';   // ID
        k_shohinsyubetsu2.keijousyubetsu__c = 'グロス';   // 計上種別
        k_shohinsyubetsuList.add(k_shohinsyubetsu2);
        insert k_shohinsyubetsuList;

        List<Product2> prodList = new List<Product2>();
        Product2 prod = new Product2(
             Name = 'Product X',
             ProductCode = 'Pro-X',
             DataKubun__c='1:通常商品',        
             k_ServiceRef__c=k_service16.id,        
             k_ShohinSyubetsuRef__c=k_shohinsyubetsuList.get(0).id,
             isActive = true
        );
        prodList.add(prod);
        //Create your product
        Product2 prod1 = new Product2(
             Name = 'Product X',
             ProductCode = 'Pro-X',
             DataKubun__c='2:割引プラン',     
             k_ServiceRef__c=k_service16.id,         
             k_ShohinSyubetsuRef__c=k_shohinsyubetsuList.get(0).id,
             isActive = true
        );
        prodList.add(prod1);
        //Create your product
        Product2 prod2 = new Product2(
             Name = 'Product X',
             ProductCode = 'Pro-X',
             DataKubun__c='3:クーポン',           
             k_ServiceRef__c=k_service16.id,
             k_ShohinSyubetsuRef__c=k_shohinsyubetsuList.get(0).id,
             isActive = true
        );
        prodList.add(prod2);
        //Create your product
        Product2 prod3 = new Product2(
             Name = 'Product X',
             ProductCode = 'Pro-X',
             DataKubun__c='1:通常商品',          
             k_ServiceRef__c=k_service16.id,
             k_ShohinSyubetsuRef__c=k_shohinsyubetsuList.get(0).id,
             isActive = true
        );      
        prodList.add(prod3);

        Product2 prod4 = new Product2(
             Name = '【20.11】よりそうオプション 付添安置 (1泊)',
             ShohinBango__c = 'SBG-0005417',
             DataKubun__c='1:通常商品',          
             k_ServiceRef__c=k_service16.id,
             k_ShohinSyubetsuRef__c=k_shohinsyubetsuList.get(1).id,
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
        PricebookEntry pbEntry4 = new PricebookEntry(
             Pricebook2Id = pricebookId,
             Product2Id = prod4.Id,
             UnitPrice = 100.00,
             IsActive = true
        );      
        pbEntryList.add(pbEntry4);
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
                                    SimpleYasugoKeiyakuRef__c = keiyaku.Id,
                                    TaiouKanouRiyu__c = '対応可能（斎場優先）',
                                    MoshuRef__c = moshu.Id, 
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
        OpportunityLineItem oli4 = new OpportunityLineItem(
             OpportunityId = oppSimpleYasugo.Id,
             Quantity = 5,
             PricebookEntryId = pbEntry4.Id,
             TotalPrice = 100//quantity * pbEntry.UnitPrice
        );
        oliList.add(oli4);      
        insert oliList;


        Test.startTest();

        SogSok_Sokyaku__c sokyaku = new SogSok_Sokyaku__c(OpportunityRef__c=oppSimpleYasugo.Id);
        insert sokyaku;
        sokyaku = [select id, name from SogSok_Sokyaku__c where id =:sokyaku.Id];
        
        SogSok_MitsumoriSho__c sogsok_mitsumorisho = new SogSok_MitsumoriSho__c(DocStatus__c = 'draft', SokyakuBango__c=sokyaku.Name);
        insert sogsok_mitsumorisho;

        SogSok_Mitsumorisho_TsuikaHinLine__c tsuikaHinLine = new SogSok_Mitsumorisho_TsuikaHinLine__c(
            MitsumoriShoRef__c = sogsok_mitsumorisho.Id, 
            HinmokuBunrui__c = '付添安置 (1泊)', 
            Amount__c = 5500, 
            ShohinBango__c = 'SBG-0005417', 
            Quantity__c = 1, 
            UnitPrice__c = 5500
        );
        insert tsuikaHinLine;


        sogsok_mitsumorisho.DocStatus__c = 'Activated';
        update sogsok_mitsumorisho;
        
        SogSok_MitsumoriSho_TorikCre.run();

        SogSok_MitsumoriSho_TorikCreTask task = new SogSok_MitsumoriSho_TorikCreTask();
        task.run(sogsok_mitsumorisho.Id);
        task.run(null);
        
        try{
            task.runTask(null);
            
        }catch(Exception ex){
            System.debug(ex);
        }

        try{

            SogSok_Mitsumorisho_TsuikaHinLine__c sogsok_mitsumorisho_tsuikahinline = new SogSok_Mitsumorisho_TsuikaHinLine__c(HinmokuBunrui__c='テスト', Amount__c=100,MitsumoriShoRef__c=sogsok_mitsumorisho.Id);
            insert sogsok_mitsumorisho_tsuikahinline;
            SogSok_Mitsumorisho_WaribikiLine__c sogsok_mitsumorisho_waribikiline = new SogSok_Mitsumorisho_WaribikiLine__c(MitsumoriShoRef__c=sogsok_mitsumorisho.Id); 
            insert sogsok_mitsumorisho_waribikiline;
            task.run(sogsok_mitsumorisho.Id);

        }catch(Exception ex){
            System.debug(ex);

        }


        Test.stopTest();
        
    }


}