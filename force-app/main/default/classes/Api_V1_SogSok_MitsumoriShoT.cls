@isTest
private class Api_V1_SogSok_MitsumoriShoT {
	
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

        SogSok_Sokyaku__c sokyaku = new SogSok_Sokyaku__c(OpportunityRef__c=oppSimpleYasugo.Id,SoukyakuStatus__c='wait_for_mitsumorisho');
        insert sokyaku;
        sokyaku = [select id, name from SogSok_Sokyaku__c where id =:sokyaku.Id];


		String json =  '{\"doc_status\":\"activated\",'
+ '  \"kinyu_date\":\"2018-08-28\",'
+ '  '
+ '  \"moshu\":{'
+ '  \"addr_city\":\"横浜市青葉区\",'
+ '  \"addr_postal_code\":\"2270000\",'
+ '  \"addr_state\":\"神奈川県\",'
+ '  \"addr_street\":\"藤が丘２－１\",'
+ '  \"age\":null,'
+ '  \"birth_date\":\"2018-08-08\",'
+ '  \"gender\":\"男性\",'
+ '  \"mei\":\"手巣都\",'
+ '  \"mei_kana\":\"テスト\",'
+ '  \"mobile\":\"0123-456-7890\",'
+ '  \"phone\":\"0123-456-7890\",'
+ '  \"sei\":\"寄僧\",'
+ '  \"sei_kana\":\"ヨリソウ\",'
+ '  \"zokugara_from_soudansha\":\"otto\"'
+ '  },'
+ ''
+ '  \"sign_url\":\"https://127.0.0.1.jp/api/file/8\",'
+ '  '
+ '  \"shiharai\":{'
+ '  \"card_kingaku\":298000,'
+ '  \"genkin_kingaku\":0,'
+ '  \"loan_kingaku\":0,'
+ '  \"maeuke_kingaku\":0,'
+ '  \"gmo_kingaku\":0'
+ '  },'
+ ''
+ '  '
+ '  \"shiharaisha\":{'
+ '  \"addr_city\":\"品川区\",'
+ '  \"addr_postal_code\":\"1410031\",'
+ '  \"addr_state\":\"東京都\",'
+ '  \"addr_street\":\"西五反田１１１\",'
+ '  \"atena\":\"いしい　てすと\",'
+ '  \"email\":\"testtest+20180828@yoriso.com\",'
+ '  \"name\":\"いしい　てすと\"'
+ '  },'
+ ''
+ '  \"yoriso_option_kibo\":{'
+ '  \"saidan\":\"希望する\",'
+ '  \"owakare_bana\":\"希望する\",'
+ '  \"kanjo_hanataba\":\"希望する\",'
+ '  \"makura_bana\":\"希望する\"'
+ '  },'
+ ''
+ '  \"shodan_bango\":\"0423182\",'
+ '  '
+ '  \"sodansha\":{'
+ '  \"mei\":\"手巣都\",'
+ '  \"sei\":\"寄僧\",'
+ '  \"torihikisaki_bango\":\"ACNT-0310878\"'
+ '  },'
+ ''
+ '  '
+ '  \"sogi\":{'
+ '  \"kaso_datetime\":\"2018-08-30 00:00:00\",'
+ '  \"kasoba_name\":\"梅﨑火葬場\",'
+ '  \"kokubetsushiki_datetime\":\"2018-08-30 00:00:00\",'
+ '  \"shikijo_name\":\"梅﨑斎場\",'
+ '  \"shukkan_datetime\":\"2018-08-29 00:00:00\",'
+ '  \"tsuya_datetime\":\"2018-08-29 00:00:00\"'
+ '  },'
+ ''
+ '  '
+ '  \"sogi_plan\":{'
+ '  \"kingaku\":298000,'
+ '  \"name\":\"よりそうのお葬式　一日葬　仏式プラン\",'
+ '  \"shohin_bango\":\"SBG-0000006\"'
+ '  },'
+ ''
+ '  '
+ '  \"soryo_tehai\":{'
+ '  \"kaimyo\":\"釋\",'
+ '  \"tehai_umu\":\"未定\"'
+ '  },'
+ ''
+ '  \"soukyaku_bango\":\"{!soukyaku_bango}\",'
+ '  '
+ '  \"soukyakusaki\":{'
+ '  \"tantosha_name\":\"梅﨑 丈晴\",'
+ '  \"tantosha_tel\":\"080-1234-5678\",'
+ '  \"torihikisaki_bango\":\"ACNT-0412384\",'
+ '  \"torihikisaki_name\":\"テスト梅崎葬儀社\"'
+ '  },'
+ ''
+ '  '
+ '  \"taishosha\":{'
+ '  \"addr_city\":\"横浜市青葉区\",'
+ '  \"addr_postal_code\":\"2270043\",'
+ '  \"addr_state\":\"神奈川県\",'
+ '  \"addr_street\":\"藤が丘２－１\",'
+ '  \"age\":38,'
+ '  \"birth_date\":\"1980-08-01\",'
+ '  \"bodaiji_umu\":\"有\",'
+ '  \"death_date\":\"2018-08-13\",'
+ '  \"gender\":\"女性\",'
+ '  \"jumhyo_city\":\"品川区\",'
+ '  \"jumhyo_postal_code\":\"1410031\",'
+ '  \"jumhyo_state\":\"東京都\",'
+ '  \"jumhyo_street\":\"西五反田１１１\",'
+ '  \"mei\":\"テスト２０１８０３１６０１\",'
+ '  \"mei_kana\":\"テストタイショウシャ\",'
+ '  \"sei\":\"テスト対象者\",'
+ '  \"sei_kana\":\"テストタイショウシャ\",'
+ '  \"shuha\":\"sonota\",'
+ '  \"shuha_sonotaShuha\":\"高野山真言宗 その他宗派備考\",'
+ '  \"torihikisaki_bango\":\"ACNT-0404620\"'
+ '  },'

+ '    \"tsuika_hinmokus\": ['
+ '      {'
+ '        \"unit_price\": \"202\",'
+ '        \"quantity\": \"203\",'
+ '        \"name\": \"201\",'
+ '        \"hinmoku_bunrui\": [\"葬儀社様\",\"葬儀社_料理\"],'
+ '        \"hinmoku_bunrui_name\" : \"test品目\",'
+ '        \"amount\": \"204\"'
+ '      }'
+ '    ],'
+ ''
+ '  \"tekiyo_waribikis\":['
+ '	  {\"amount\":\"1\",'
+ '	  \"name\":\"よりそうのお葬式　事前割メンバー割引 (直葬)\",'
+ '	  \"quantity\":\"1\",'
+ '	  \"shohin_bango\":\"SBG-0000190\",'
+ '	  \"unit_price\":\"-5000\"'
+ '	  },'
+ ''
+ '	  {\"amount\":1,'
+ '	  \"name\":\"よりそうのお葬式　事前割メンバー割引 (家族葬)\",'
+ '	  \"quantity\":1,'
+ '	  \"shohin_bango\":\"SBG-0000190\",'
+ '	  \"unit_price\":\"555000\"'
+ '	  }'
+ '   ]'
+ '}';
		json = json.replace('{!soukyaku_bango}', sokyaku.Name);
		
	    Test.startTest();
	        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/api/v1/sogsok/mitsumorisho';
        req.httpMethod = 'POST';
	    req.requestBody = Blob.valueof(json);

        RestContext.request = req;
        RestContext.response= res;
        
        //正常
        Api_V1_SogSok_MitsumoriSho.doPost();

	    
        Test.stopTest();
	}
	
	@isTest static void test_method_two() {
		String json =  '{\"doc_status\":\"draft\",'
+ '  \"kinyu_date\":\"2018-08-28\",'
+ '  '
+ '  \"moshu\":{'
+ '  \"addr_city\":\"横浜市青葉区\",'
+ '  \"addr_postal_code\":\"2270000\",'
+ '  \"addr_state\":\"神奈川県\",'
+ '  \"addr_street\":\"藤が丘２－１\",'
+ '  \"age\":null,'
+ '  \"birth_date\":\"2018-08-08\",'
+ '  \"gender\":\"男性\",'
+ '  \"mei\":\"手巣都\",'
+ '  \"mei_kana\":\"テスト\",'
+ '  \"mobile\":\"0123-456-7890\",'
+ '  \"phone\":\"0123-456-7890\",'
+ '  \"sei\":\"寄僧\",'
+ '  \"sei_kana\":\"ヨリソウ\",'
+ '  \"zokugara_from_soudansha\":\"otto\"'
+ '  },'
+ ''
+ '  \"original_copy_url\":\"https://127.0.0.1.jp/api/file/8\",'
+ '  '
+ '  \"shiharai\":{'
+ '  \"card_kingaku\":298000,'
+ '  \"genkin_kingaku\":0,'
+ '  \"loan_kingaku\":0,'
+ '  \"maeuke_kingaku\":0,'
+ '  \"gmo_kingaku\":0'
+ '  },'
+ ''
+ '  '
+ '  \"shiharaisha\":{'
+ '  \"addr_city\":\"品川区\",'
+ '  \"addr_postal_code\":\"1410031\",'
+ '  \"addr_state\":\"東京都\",'
+ '  \"addr_street\":\"西五反田１１１\",'
+ '  \"atena\":\"いしい　てすと\",'
+ '  \"email\":\"testtest+20180828@yoriso.com\",'
+ '  \"name\":\"いしい　てすと\"'
+ '  },'
+ ''
+ '  \"yoriso_option_kibo\":{'
+ '  \"saidan\":\"希望する\",'
+ '  \"owakare_bana\":\"希望する\",'
+ '  \"kanjo_hanataba\":\"希望する\",'
+ '  \"makura_bana\":\"希望する\"'
+ '  },'
+ ''
+ '  \"shodan_bango\":\"0423182\",'
+ '  '
+ '  \"sodansha\":{'
+ '  \"mei\":\"手巣都\",'
+ '  \"sei\":\"寄僧\",'
+ '  \"torihikisaki_bango\":\"ACNT-0310878\"'
+ '  },'
+ ''
+ '  '
+ '  \"sogi\":{'
+ '  \"kaso_datetime\":\"2018-08-30 00:00:00\",'
+ '  \"kasoba_name\":\"梅﨑火葬場\",'
+ '  \"kokubetsushiki_datetime\":\"2018-08-30 00:00:00\",'
+ '  \"shikijo_name\":\"梅﨑斎場\",'
+ '  \"shukkan_datetime\":\"2018-08-29 00:00:00\",'
+ '  \"tsuya_datetime\":\"2018-08-29 00:00:00\"'
+ '  },'
+ ''
+ '  '
+ '  \"sogi_plan\":{'
+ '  \"kingaku\":298000,'
+ '  \"name\":\"よりそうのお葬式　一日葬　仏式プラン\",'
+ '  \"shohin_bango\":\"SBG-0000006\"'
+ '  },'
+ ''
+ '  '
+ '  \"soryo_tehai\":{'
+ '  \"kaimyo\":\"釋\",'
+ '  \"tehai_umu\":\"未定\"'
+ '  },'
+ ''
+ '  \"soukyaku_bango\":\"SSK-00000107\",'
+ '  '
+ '  \"soukyakusaki\":{'
+ '  \"tantosha_name\":\"梅﨑 丈晴\",'
+ '  \"tantosha_tel\":\"080-1234-5678\",'
+ '  \"torihikisaki_bango\":\"ACNT-0412384\",'
+ '  \"torihikisaki_name\":\"テスト梅崎葬儀社\"'
+ '  },'
+ ''
+ '  '
+ '  \"taishosha\":{'
+ '  \"addr_city\":\"横浜市青葉区\",'
+ '  \"addr_postal_code\":\"2270043\",'
+ '  \"addr_state\":\"神奈川県\",'
+ '  \"addr_street\":\"藤が丘２－１\",'
+ '  \"age\":38,'
+ '  \"birth_date\":\"1980-08-01\",'
+ '  \"bodaiji_umu\":\"有\",'
+ '  \"death_date\":\"2018-08-13\",'
+ '  \"gender\":\"女性\",'
+ '  \"jumhyo_city\":\"品川区\",'
+ '  \"jumhyo_postal_code\":\"1410031\",'
+ '  \"jumhyo_state\":\"東京都\",'
+ '  \"jumhyo_street\":\"西五反田１１１\",'
+ '  \"mei\":\"テスト２０１８０３１６０１\",'
+ '  \"mei_kana\":\"テストタイショウシャ\",'
+ '  \"sei\":\"テスト対象者\",'
+ '  \"sei_kana\":\"テストタイショウシャ\",'
+ '  \"shuha\":\"sonota\",'
+ '  \"shuha_sonotaShuha\":\"高野山真言宗 その他宗派備考\",'
+ '  \"torihikisaki_bango\":\"ACNT-0404620\"'
+ '  },'
+ ''
+ '  \"tekiyo_waribikis\":['
+ '	  {\"amount\":\"1\",'
+ '	  \"name\":\"よりそうのお葬式　事前割メンバー割引 (直葬)\",'
+ '	  \"quantity\":\"1\",'
+ '	  \"shohin_bango\":\"SBG-0000190\",'
+ '	  \"unit_price\":\"-5000\"'
+ '	  },'
+ ''
+ '	  {\"amount\":1,'
+ '	  \"name\":\"よりそうのお葬式　事前割メンバー割引 (家族葬)\",'
+ '	  \"quantity\":1,'
+ '	  \"shohin_bango\":\"SBG-0000190\",'
+ '	  \"unit_price\":\"555000\"'
+ '	  }'
+ '   ]'
+ '}';

	    Test.startTest();
	        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/api/v1/sogsok/mitsumorisho';
        req.httpMethod = 'POST';
	    req.requestBody = Blob.valueof(json);

        RestContext.request = req;
        RestContext.response= res;
        
        //正常
        Api_V1_SogSok_MitsumoriSho.doPost();

	    
        Test.stopTest();
	}

    @isTest static void test_method_3() {
        Api_V1_SogSok_MitsumoriSho_Data data = new Api_V1_SogSok_MitsumoriSho_Data();
        SogSok_MitsumoriSho__c  mitsumorisho = data.createSogSokMitsumoriSho(new Api_V1_SogSok_MitsumoriSho_Data.MitsumoriSho());
        List<SogSok_Mitsumorisho_TsuikaHinLine__c> lines = data.createSogSokMitsumoriShoTsuikaHinLines(new Api_V1_SogSok_MitsumoriSho_Data.MitsumoriSho(), null);
        data.createMitsumoriSho(new SogSok_MitsumoriSho__c());

    }
     
    @isTest static void test_method_4() {

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

     SogSok_Sokyaku__c sokyaku = new SogSok_Sokyaku__c(OpportunityRef__c=oppSimpleYasugo.Id,SoukyakuStatus__c='wait_for_mitsumorisho');
     insert sokyaku;
     sokyaku = [select id, name from SogSok_Sokyaku__c where id =:sokyaku.Id];


       String json =  '{\"doc_status\":\"activated\",'
+ '  \"kinyu_date\":\"2018-08-28\",'
+ '  '
+ '  \"moshu\":{'
+ '  \"addr_city\":\"横浜市青葉区\",'
+ '  \"addr_postal_code\":\"2270000\",'
+ '  \"addr_state\":\"神奈川県\",'
+ '  \"addr_street\":\"藤が丘２－１\",'
+ '  \"age\":null,'
+ '  \"birth_date\":\"2018-08-08\",'
+ '  \"gender\":\"男性\",'
+ '  \"mei\":\"手巣都\",'
+ '  \"mei_kana\":\"テスト\",'
+ '  \"mobile\":\"0123-456-7890\",'
+ '  \"phone\":\"0123-456-7890\",'
+ '  \"sei\":\"寄僧\",'
+ '  \"sei_kana\":\"ヨリソウ\",'
+ '  \"zokugara_from_soudansha\":\"otto\"'
+ '  },'
+ ''
+ '  \"sign_url\":\"https://127.0.0.1.jp/api/file/8\",'
+ '  '
+ '  \"shiharai\":{'
+ '  \"card_kingaku\":298000,'
+ '  \"genkin_kingaku\":0,'
+ '  \"loan_kingaku\":0,'
+ '  \"maeuke_kingaku\":0,'
+ '  \"gmo_kingaku\":0'
+ '  },'
+ ''
+ '  '
+ '  \"shiharaisha\":{'
+ '  \"addr_city\":\"品川区\",'
+ '  \"addr_postal_code\":\"1410031\",'
+ '  \"addr_state\":\"東京都\",'
+ '  \"addr_street\":\"西五反田１１１\",'
+ '  \"atena\":\"いしい　てすと\",'
+ '  \"email\":\"testtest+20180828@yoriso.com\",'
+ '  \"name\":\"いしい　てすと\"'
+ '  },'
+ ''
+ '  \"yoriso_option_kibo\":{'
+ '  \"saidan\":\"希望する\",'
+ '  \"owakare_bana\":\"希望する\",'
+ '  \"kanjo_hanataba\":\"希望する\",'
+ '  \"makura_bana\":\"希望する\"'
+ '  },'
+ ''
+ '  \"shodan_bango\":\"0423182\",'
+ '  '
+ '  \"sodansha\":{'
+ '  \"mei\":\"手巣都\",'
+ '  \"sei\":\"寄僧\",'
+ '  \"torihikisaki_bango\":\"ACNT-0310878\"'
+ '  },'
+ ''
+ '  '
+ '  \"sogi\":{'
+ '  \"kaso_datetime\":\"2018-08-30 00:00:00\",'
+ '  \"kasoba_name\":\"梅﨑火葬場\",'
+ '  \"kokubetsushiki_datetime\":\"2018-08-30 00:00:00\",'
+ '  \"shikijo_name\":\"梅﨑斎場\",'
+ '  \"shukkan_datetime\":\"2018-08-29 00:00:00\",'
+ '  \"tsuya_datetime\":\"2018-08-29 00:00:00\"'
+ '  },'
+ ''
+ '  '
+ '  \"sogi_plan\":{'
+ '  \"kingaku\":298000,'
+ '  \"name\":\"よりそうのお葬式　一日葬　仏式プラン\",'
+ '  \"shohin_bango\":\"SBG-0005006\"'
+ '  },'
+ ''
+ '  '
+ '  \"soryo_tehai\":{'
+ '  \"kaimyo\":\"釋\",'
+ '  \"tehai_umu\":\"未定\"'
+ '  },'
+ ''
+ '  \"soukyaku_bango\":\"{!soukyaku_bango}\",'
+ '  '
+ '  \"soukyakusaki\":{'
+ '  \"tantosha_name\":\"梅﨑 丈晴\",'
+ '  \"tantosha_tel\":\"080-1234-5678\",'
+ '  \"torihikisaki_bango\":\"ACNT-0412384\",'
+ '  \"torihikisaki_name\":\"テスト梅崎葬儀社\"'
+ '  },'
+ ''
+ '  '
+ '  \"taishosha\":{'
+ '  \"addr_city\":\"横浜市青葉区\",'
+ '  \"addr_postal_code\":\"2270043\",'
+ '  \"addr_state\":\"神奈川県\",'
+ '  \"addr_street\":\"藤が丘２－１\",'
+ '  \"age\":38,'
+ '  \"birth_date\":\"1980-08-01\",'
+ '  \"bodaiji_umu\":\"有\",'
+ '  \"death_date\":\"2018-08-13\",'
+ '  \"gender\":\"女性\",'
+ '  \"jumhyo_city\":\"品川区\",'
+ '  \"jumhyo_postal_code\":\"1410031\",'
+ '  \"jumhyo_state\":\"東京都\",'
+ '  \"jumhyo_street\":\"西五反田１１１\",'
+ '  \"mei\":\"テスト２０１８０３１６０１\",'
+ '  \"mei_kana\":\"テストタイショウシャ\",'
+ '  \"sei\":\"テスト対象者\",'
+ '  \"sei_kana\":\"テストタイショウシャ\",'
+ '  \"shuha\":\"sonota\",'
+ '  \"shuha_sonotaShuha\":\"高野山真言宗 その他宗派備考\",'
+ '  \"torihikisaki_bango\":\"ACNT-0404620\"'
+ '  },'

+ '    \"tsuika_hinmokus\": ['
+ '      {'
+ '        \"unit_price\": \"202\",'
+ '        \"quantity\": \"203\",'
+ '        \"name\": \"201\",'
+ '        \"hinmoku_bunrui\": [\"よりそう\",\"よりそう_祭壇アップグレード L (家族葬 二日プラン)\"],'
+ '        \"hinmoku_bunrui_name\" : \"test品目\",'
+ '        \"amount\": \"204\",'
+ '        \"shohin_bango\": \"SBG-0005404\"'
+ '      },'
+ '      {'
+ '        \"unit_price\": \"202\",'
+ '        \"quantity\": \"203\",'
+ '        \"name\": \"201\",'
+ '        \"hinmoku_bunrui\": [\"よりそう\",\"よりそう_祭壇アップグレード LL (家族葬 二日プラン)\"],'
+ '        \"hinmoku_bunrui_name\" : \"test品目\",'
+ '        \"amount\": \"204\",'
+ '        \"shohin_bango\": \"SBG-0005405\"'
+ '      },'
+ '      {'
+ '        \"unit_price\": \"202\",'
+ '        \"quantity\": \"203\",'
+ '        \"name\": \"201\",'
+ '        \"hinmoku_bunrui\": [\"よりそう\",\"よりそう_祭壇アップグレード LL (家族葬 華やかプラン)\"],'
+ '        \"hinmoku_bunrui_name\" : \"test品目\",'
+ '        \"amount\": \"204\",'
+ '        \"shohin_bango\": \"SBG-0005406\"'
+ '      },'
+ '      {'
+ '        \"unit_price\": \"202\",'
+ '        \"quantity\": \"203\",'
+ '        \"name\": \"201\",'
+ '        \"hinmoku_bunrui\": [\"よりそう\",\"よりそう_遺影写真\"],'
+ '        \"hinmoku_bunrui_name\" : \"test品目\",'
+ '        \"amount\": \"204\",'
+ '        \"shohin_bango\": \"SBG-0005416\"'
+ '      }'
+ '    ],'
+ ''
+ '  \"tekiyo_waribikis\":['
+ '	  {\"amount\":\"1\",'
+ '	  \"name\":\"よりそうのお葬式　事前割メンバー割引 (直葬)\",'
+ '	  \"quantity\":\"1\",'
+ '	  \"shohin_bango\":\"SBG-0000190\",'
+ '	  \"unit_price\":\"-5000\"'
+ '	  },'
+ ''
+ '	  {\"amount\":1,'
+ '	  \"name\":\"よりそうのお葬式　事前割メンバー割引 (家族葬)\",'
+ '	  \"quantity\":1,'
+ '	  \"shohin_bango\":\"SBG-0000190\",'
+ '	  \"unit_price\":\"555000\"'
+ '	  }'
+ '   ]'
+ '}';
       json = json.replace('{!soukyaku_bango}', sokyaku.Name);
       
      Test.startTest();
          
     RestRequest req = new RestRequest();
     RestResponse res = new RestResponse();
     
     req.requestURI = '/services/apexrest/api/v1/sogsok/mitsumorisho';
     req.httpMethod = 'POST';
      req.requestBody = Blob.valueof(json);

     RestContext.request = req;
     RestContext.response= res;
     
     //正常
     Api_V1_SogSok_MitsumoriSho.doPost();

      
     Test.stopTest();
  }

  @isTest static void test_method_5() {

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

     SogSok_Sokyaku__c sokyaku = new SogSok_Sokyaku__c(OpportunityRef__c=oppSimpleYasugo.Id,SoukyakuStatus__c='wait_for_mitsumorisho');
     insert sokyaku;
     sokyaku = [select id, name from SogSok_Sokyaku__c where id =:sokyaku.Id];


       String json =  '{\"doc_status\":\"activated\",'
+ '  \"kinyu_date\":\"2018-08-28\",'
+ '  '
+ '  \"moshu\":{'
+ '  \"addr_city\":\"横浜市青葉区\",'
+ '  \"addr_postal_code\":\"2270000\",'
+ '  \"addr_state\":\"神奈川県\",'
+ '  \"addr_street\":\"藤が丘２－１\",'
+ '  \"age\":null,'
+ '  \"birth_date\":\"2018-08-08\",'
+ '  \"gender\":\"男性\",'
+ '  \"mei\":\"手巣都\",'
+ '  \"mei_kana\":\"テスト\",'
+ '  \"mobile\":\"0123-456-7890\",'
+ '  \"phone\":\"0123-456-7890\",'
+ '  \"sei\":\"寄僧\",'
+ '  \"sei_kana\":\"ヨリソウ\",'
+ '  \"zokugara_from_soudansha\":\"otto\"'
+ '  },'
+ ''
+ '  \"sign_url\":\"https://127.0.0.1.jp/api/file/8\",'
+ '  '
+ '  \"shiharai\":{'
+ '  \"card_kingaku\":298000,'
+ '  \"genkin_kingaku\":0,'
+ '  \"loan_kingaku\":0,'
+ '  \"maeuke_kingaku\":0,'
+ '  \"gmo_kingaku\":0'
+ '  },'
+ ''
+ '  '
+ '  \"shiharaisha\":{'
+ '  \"addr_city\":\"品川区\",'
+ '  \"addr_postal_code\":\"1410031\",'
+ '  \"addr_state\":\"東京都\",'
+ '  \"addr_street\":\"西五反田１１１\",'
+ '  \"atena\":\"いしい　てすと\",'
+ '  \"email\":\"testtest+20180828@yoriso.com\",'
+ '  \"name\":\"いしい　てすと\"'
+ '  },'
+ ''
+ '  \"yoriso_option_kibo\":{'
+ '  \"saidan\":\"希望する\",'
+ '  \"owakare_bana\":\"希望する\",'
+ '  \"kanjo_hanataba\":\"希望する\",'
+ '  \"makura_bana\":\"希望する\"'
+ '  },'
+ ''
+ '  \"shodan_bango\":\"0423182\",'
+ '  '
+ '  \"sodansha\":{'
+ '  \"mei\":\"手巣都\",'
+ '  \"sei\":\"寄僧\",'
+ '  \"torihikisaki_bango\":\"ACNT-0310878\"'
+ '  },'
+ ''
+ '  '
+ '  \"sogi\":{'
+ '  \"kaso_datetime\":\"2018-08-30 00:00:00\",'
+ '  \"kasoba_name\":\"梅﨑火葬場\",'
+ '  \"kokubetsushiki_datetime\":\"2018-08-30 00:00:00\",'
+ '  \"shikijo_name\":\"梅﨑斎場\",'
+ '  \"shukkan_datetime\":\"2018-08-29 00:00:00\",'
+ '  \"tsuya_datetime\":\"2018-08-29 00:00:00\"'
+ '  },'
+ ''
+ '  '
+ '  \"sogi_plan\":{'
+ '  \"kingaku\":298000,'
+ '  \"name\":\"よりそうお葬式　二日プラン\",'
+ '  \"shohin_bango\":\"SBG-0005002\"'
+ '  },'
+ ''
+ '  '
+ '  \"soryo_tehai\":{'
+ '  \"kaimyo\":\"釋\",'
+ '  \"tehai_umu\":\"未定\"'
+ '  },'
+ ''
+ '  \"soukyaku_bango\":\"{!soukyaku_bango}\",'
+ '  '
+ '  \"soukyakusaki\":{'
+ '  \"tantosha_name\":\"梅﨑 丈晴\",'
+ '  \"tantosha_tel\":\"080-1234-5678\",'
+ '  \"torihikisaki_bango\":\"ACNT-0412384\",'
+ '  \"torihikisaki_name\":\"テスト梅崎葬儀社\"'
+ '  },'
+ ''
+ '  '
+ '  \"taishosha\":{'
+ '  \"addr_city\":\"横浜市青葉区\",'
+ '  \"addr_postal_code\":\"2270043\",'
+ '  \"addr_state\":\"神奈川県\",'
+ '  \"addr_street\":\"藤が丘２－１\",'
+ '  \"age\":38,'
+ '  \"birth_date\":\"1980-08-01\",'
+ '  \"bodaiji_umu\":\"有\",'
+ '  \"death_date\":\"2018-08-13\",'
+ '  \"gender\":\"女性\",'
+ '  \"jumhyo_city\":\"品川区\",'
+ '  \"jumhyo_postal_code\":\"1410031\",'
+ '  \"jumhyo_state\":\"東京都\",'
+ '  \"jumhyo_street\":\"西五反田１１１\",'
+ '  \"mei\":\"テスト２０１８０３１６０１\",'
+ '  \"mei_kana\":\"テストタイショウシャ\",'
+ '  \"sei\":\"テスト対象者\",'
+ '  \"sei_kana\":\"テストタイショウシャ\",'
+ '  \"shuha\":\"sonota\",'
+ '  \"shuha_sonotaShuha\":\"高野山真言宗 その他宗派備考\",'
+ '  \"torihikisaki_bango\":\"ACNT-0404620\"'
+ '  },'

+ '    \"tsuika_hinmokus\": ['
+ '      {'
+ '        \"unit_price\": \"202\",'
+ '        \"quantity\": \"203\",'
+ '        \"name\": \"201\",'
+ '        \"hinmoku_bunrui\": [\"よりそう\",\"よりそう_祭壇アップグレード M (家族葬 一日プラン)\"],'
+ '        \"hinmoku_bunrui_name\" : \"test品目\",'
+ '        \"amount\": \"204\",'
+ '        \"shohin_bango\": \"SBG-0005401\"'
+ '      },'
+ '      {'
+ '        \"unit_price\": \"202\",'
+ '        \"quantity\": \"203\",'
+ '        \"name\": \"201\",'
+ '        \"hinmoku_bunrui\": [\"よりそう\",\"よりそう_祭壇アップグレード L (家族葬 一日プラン)\"],'
+ '        \"hinmoku_bunrui_name\" : \"test品目\",'
+ '        \"amount\": \"204\",'
+ '        \"shohin_bango\": \"SBG-0005402\"'
+ '      },'
+ '      {'
+ '        \"unit_price\": \"202\",'
+ '        \"quantity\": \"203\",'
+ '        \"name\": \"201\",'
+ '        \"hinmoku_bunrui\": [\"よりそう\",\"よりそう_祭壇アップグレード LL (家族葬 一日プラン)\"],'
+ '        \"hinmoku_bunrui_name\" : \"test品目\",'
+ '        \"amount\": \"204\",'
+ '        \"shohin_bango\": \"SBG-0005403\"'
+ '      },'
+ '      {'
+ '        \"unit_price\": \"202\",'
+ '        \"quantity\": \"203\",'
+ '        \"name\": \"201\",'
+ '        \"hinmoku_bunrui\": [\"よりそう\",\"よりそう_祭壇アップグレード LL (家族葬 華やかプラン)\"],'
+ '        \"hinmoku_bunrui_name\" : \"test品目\",'
+ '        \"amount\": \"204\",'
+ '        \"shohin_bango\": \"SBG-0005406\"'
+ '      },'
+ '      {'
+ '        \"unit_price\": \"202\",'
+ '        \"quantity\": \"203\",'
+ '        \"name\": \"201\",'
+ '        \"hinmoku_bunrui\": [\"よりそう\",\"よりそう_遺影写真\"],'
+ '        \"hinmoku_bunrui_name\" : \"test品目\",'
+ '        \"amount\": \"204\",'
+ '        \"shohin_bango\": \"SBG-0005416\"'
+ '      }'
+ '    ],'
+ ''
+ '  \"tekiyo_waribikis\":['
+ '	  {\"amount\":\"1\",'
+ '	  \"name\":\"よりそうのお葬式　事前割メンバー割引 (直葬)\",'
+ '	  \"quantity\":\"1\",'
+ '	  \"shohin_bango\":\"SBG-0000190\",'
+ '	  \"unit_price\":\"-5000\"'
+ '	  },'
+ ''
+ '	  {\"amount\":1,'
+ '	  \"name\":\"よりそうのお葬式　事前割メンバー割引 (家族葬)\",'
+ '	  \"quantity\":1,'
+ '	  \"shohin_bango\":\"SBG-0000190\",'
+ '	  \"unit_price\":\"555000\"'
+ '	  }'
+ '   ]'
+ '}';
       json = json.replace('{!soukyaku_bango}', sokyaku.Name);
       
      Test.startTest();
          
     RestRequest req = new RestRequest();
     RestResponse res = new RestResponse();
     
     req.requestURI = '/services/apexrest/api/v1/sogsok/mitsumorisho';
     req.httpMethod = 'POST';
      req.requestBody = Blob.valueof(json);

     RestContext.request = req;
     RestContext.response= res;
     
     //正常
     Api_V1_SogSok_MitsumoriSho.doPost();

      
     Test.stopTest();
  }

  @isTest static void test_method_6() {

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

     SogSok_Sokyaku__c sokyaku = new SogSok_Sokyaku__c(OpportunityRef__c=oppSimpleYasugo.Id,SoukyakuStatus__c='wait_for_mitsumorisho');
     insert sokyaku;
     sokyaku = [select id, name from SogSok_Sokyaku__c where id =:sokyaku.Id];


       String json =  '{\"doc_status\":\"activated\",'
+ '  \"kinyu_date\":\"2018-08-28\",'
+ '  '
+ '  \"moshu\":{'
+ '  \"addr_city\":\"横浜市青葉区\",'
+ '  \"addr_postal_code\":\"2270000\",'
+ '  \"addr_state\":\"神奈川県\",'
+ '  \"addr_street\":\"藤が丘２－１\",'
+ '  \"age\":null,'
+ '  \"birth_date\":\"2018-08-08\",'
+ '  \"gender\":\"男性\",'
+ '  \"mei\":\"手巣都\",'
+ '  \"mei_kana\":\"テスト\",'
+ '  \"mobile\":\"0123-456-7890\",'
+ '  \"phone\":\"0123-456-7890\",'
+ '  \"sei\":\"寄僧\",'
+ '  \"sei_kana\":\"ヨリソウ\",'
+ '  \"zokugara_from_soudansha\":\"otto\"'
+ '  },'
+ ''
+ '  \"sign_url\":\"https://127.0.0.1.jp/api/file/8\",'
+ '  '
+ '  \"shiharai\":{'
+ '  \"card_kingaku\":298000,'
+ '  \"genkin_kingaku\":0,'
+ '  \"loan_kingaku\":0,'
+ '  \"maeuke_kingaku\":0,'
+ '  \"gmo_kingaku\":0'
+ '  },'
+ ''
+ '  '
+ '  \"shiharaisha\":{'
+ '  \"addr_city\":\"品川区\",'
+ '  \"addr_postal_code\":\"1410031\",'
+ '  \"addr_state\":\"東京都\",'
+ '  \"addr_street\":\"西五反田１１１\",'
+ '  \"atena\":\"いしい　てすと\",'
+ '  \"email\":\"testtest+20180828@yoriso.com\",'
+ '  \"name\":\"いしい　てすと\"'
+ '  },'
+ ''
+ '  \"yoriso_option_kibo\":{'
+ '  \"saidan\":\"希望する\",'
+ '  \"owakare_bana\":\"希望する\",'
+ '  \"kanjo_hanataba\":\"希望する\",'
+ '  \"makura_bana\":\"希望する\"'
+ '  },'
+ ''
+ '  \"shodan_bango\":\"0423182\",'
+ '  '
+ '  \"sodansha\":{'
+ '  \"mei\":\"手巣都\",'
+ '  \"sei\":\"寄僧\",'
+ '  \"torihikisaki_bango\":\"ACNT-0310878\"'
+ '  },'
+ ''
+ '  '
+ '  \"sogi\":{'
+ '  \"kaso_datetime\":\"2018-08-30 00:00:00\",'
+ '  \"kasoba_name\":\"梅﨑火葬場\",'
+ '  \"kokubetsushiki_datetime\":\"2018-08-30 00:00:00\",'
+ '  \"shikijo_name\":\"梅﨑斎場\",'
+ '  \"shukkan_datetime\":\"2018-08-29 00:00:00\",'
+ '  \"tsuya_datetime\":\"2018-08-29 00:00:00\"'
+ '  },'
+ ''
+ '  '
+ '  \"sogi_plan\":{'
+ '  \"kingaku\":298000,'
+ '  \"name\":\"よりそうお葬式　華やかプラン\",'
+ '  \"shohin_bango\":\"SBG-0005003\"'
+ '  },'
+ ''
+ '  '
+ '  \"soryo_tehai\":{'
+ '  \"kaimyo\":\"釋\",'
+ '  \"tehai_umu\":\"未定\"'
+ '  },'
+ ''
+ '  \"soukyaku_bango\":\"{!soukyaku_bango}\",'
+ '  '
+ '  \"soukyakusaki\":{'
+ '  \"tantosha_name\":\"梅﨑 丈晴\",'
+ '  \"tantosha_tel\":\"080-1234-5678\",'
+ '  \"torihikisaki_bango\":\"ACNT-0412384\",'
+ '  \"torihikisaki_name\":\"テスト梅崎葬儀社\"'
+ '  },'
+ ''
+ '  '
+ '  \"taishosha\":{'
+ '  \"addr_city\":\"横浜市青葉区\",'
+ '  \"addr_postal_code\":\"2270043\",'
+ '  \"addr_state\":\"神奈川県\",'
+ '  \"addr_street\":\"藤が丘２－１\",'
+ '  \"age\":38,'
+ '  \"birth_date\":\"1980-08-01\",'
+ '  \"bodaiji_umu\":\"有\",'
+ '  \"death_date\":\"2018-08-13\",'
+ '  \"gender\":\"女性\",'
+ '  \"jumhyo_city\":\"品川区\",'
+ '  \"jumhyo_postal_code\":\"1410031\",'
+ '  \"jumhyo_state\":\"東京都\",'
+ '  \"jumhyo_street\":\"西五反田１１１\",'
+ '  \"mei\":\"テスト２０１８０３１６０１\",'
+ '  \"mei_kana\":\"テストタイショウシャ\",'
+ '  \"sei\":\"テスト対象者\",'
+ '  \"sei_kana\":\"テストタイショウシャ\",'
+ '  \"shuha\":\"sonota\",'
+ '  \"shuha_sonotaShuha\":\"高野山真言宗 その他宗派備考\",'
+ '  \"torihikisaki_bango\":\"ACNT-0404620\"'
+ '  },'

+ '    \"tsuika_hinmokus\": ['
+ '      {'
+ '        \"unit_price\": \"202\",'
+ '        \"quantity\": \"203\",'
+ '        \"name\": \"201\",'
+ '        \"hinmoku_bunrui\": [\"よりそう\",\"よりそう_祭壇アップグレード M (家族葬 一日プラン)\"],'
+ '        \"hinmoku_bunrui_name\" : \"test品目\",'
+ '        \"amount\": \"204\",'
+ '        \"shohin_bango\": \"SBG-0005401\"'
+ '      },'
+ '      {'
+ '        \"unit_price\": \"202\",'
+ '        \"quantity\": \"203\",'
+ '        \"name\": \"201\",'
+ '        \"hinmoku_bunrui\": [\"よりそう\",\"よりそう_祭壇アップグレード L (家族葬 一日プラン)\"],'
+ '        \"hinmoku_bunrui_name\" : \"test品目\",'
+ '        \"amount\": \"204\",'
+ '        \"shohin_bango\": \"SBG-0005402\"'
+ '      },'
+ '      {'
+ '        \"unit_price\": \"202\",'
+ '        \"quantity\": \"203\",'
+ '        \"name\": \"201\",'
+ '        \"hinmoku_bunrui\": [\"よりそう\",\"よりそう_祭壇アップグレード LL (家族葬 一日プラン)\"],'
+ '        \"hinmoku_bunrui_name\" : \"test品目\",'
+ '        \"amount\": \"204\",'
+ '        \"shohin_bango\": \"SBG-0005403\"'
+ '      },'
+ '      {'
+ '        \"unit_price\": \"202\",'
+ '        \"quantity\": \"203\",'
+ '        \"name\": \"201\",'
+ '        \"hinmoku_bunrui\": [\"よりそう\",\"よりそう_祭壇アップグレード L (家族葬 二日プラン)\"],'
+ '        \"hinmoku_bunrui_name\" : \"test品目\",'
+ '        \"amount\": \"204\",'
+ '        \"shohin_bango\": \"SBG-0005404\"'
+ '      },'
+ '      {'
+ '        \"unit_price\": \"202\",'
+ '        \"quantity\": \"203\",'
+ '        \"name\": \"201\",'
+ '        \"hinmoku_bunrui\": [\"よりそう\",\"よりそう_祭壇アップグレード LL (家族葬 二日プラン)\"],'
+ '        \"hinmoku_bunrui_name\" : \"test品目\",'
+ '        \"amount\": \"204\",'
+ '        \"shohin_bango\": \"SBG-0005405\"'
+ '      },'
+ '      {'
+ '        \"unit_price\": \"202\",'
+ '        \"quantity\": \"203\",'
+ '        \"name\": \"201\",'
+ '        \"hinmoku_bunrui\": [\"よりそう\",\"よりそう_遺影写真\"],'
+ '        \"hinmoku_bunrui_name\" : \"test品目\",'
+ '        \"amount\": \"204\",'
+ '        \"shohin_bango\": \"SBG-0005416\"'
+ '      }'
+ '    ],'
+ ''
+ '  \"tekiyo_waribikis\":['
+ '	  {\"amount\":\"1\",'
+ '	  \"name\":\"よりそうのお葬式　事前割メンバー割引 (直葬)\",'
+ '	  \"quantity\":\"1\",'
+ '	  \"shohin_bango\":\"SBG-0000190\",'
+ '	  \"unit_price\":\"-5000\"'
+ '	  },'
+ ''
+ '	  {\"amount\":1,'
+ '	  \"name\":\"よりそうのお葬式　事前割メンバー割引 (家族葬)\",'
+ '	  \"quantity\":1,'
+ '	  \"shohin_bango\":\"SBG-0000190\",'
+ '	  \"unit_price\":\"555000\"'
+ '	  }'
+ '   ]'
+ '}';
       json = json.replace('{!soukyaku_bango}', sokyaku.Name);
       
      Test.startTest();
          
     RestRequest req = new RestRequest();
     RestResponse res = new RestResponse();
     
     req.requestURI = '/services/apexrest/api/v1/sogsok/mitsumorisho';
     req.httpMethod = 'POST';
      req.requestBody = Blob.valueof(json);

     RestContext.request = req;
     RestContext.response= res;
     
     //正常
     Api_V1_SogSok_MitsumoriSho.doPost();

      
     Test.stopTest();
  }

  @isTest static void test_method_7() {

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

     SogSok_Sokyaku__c sokyaku = new SogSok_Sokyaku__c(OpportunityRef__c=oppSimpleYasugo.Id,SoukyakuStatus__c='wait_for_mitsumorisho');
     insert sokyaku;
     sokyaku = [select id, name from SogSok_Sokyaku__c where id =:sokyaku.Id];


       String json =  '{\"doc_status\":\"activated\",'
+ '  \"kinyu_date\":\"2018-08-28\",'
+ '  '
+ '  \"moshu\":{'
+ '  \"addr_city\":\"横浜市青葉区\",'
+ '  \"addr_postal_code\":\"2270000\",'
+ '  \"addr_state\":\"神奈川県\",'
+ '  \"addr_street\":\"藤が丘２－１\",'
+ '  \"age\":null,'
+ '  \"birth_date\":\"2018-08-08\",'
+ '  \"gender\":\"男性\",'
+ '  \"mei\":\"手巣都\",'
+ '  \"mei_kana\":\"テスト\",'
+ '  \"mobile\":\"0123-456-7890\",'
+ '  \"phone\":\"0123-456-7890\",'
+ '  \"sei\":\"寄僧\",'
+ '  \"sei_kana\":\"ヨリソウ\",'
+ '  \"zokugara_from_soudansha\":\"otto\"'
+ '  },'
+ ''
+ '  \"sign_url\":\"https://127.0.0.1.jp/api/file/8\",'
+ '  '
+ '  \"shiharai\":{'
+ '  \"card_kingaku\":298000,'
+ '  \"genkin_kingaku\":0,'
+ '  \"loan_kingaku\":0,'
+ '  \"maeuke_kingaku\":0,'
+ '  \"gmo_kingaku\":0'
+ '  },'
+ ''
+ '  '
+ '  \"shiharaisha\":{'
+ '  \"addr_city\":\"品川区\",'
+ '  \"addr_postal_code\":\"1410031\",'
+ '  \"addr_state\":\"東京都\",'
+ '  \"addr_street\":\"西五反田１１１\",'
+ '  \"atena\":\"いしい　てすと\",'
+ '  \"email\":\"testtest+20180828@yoriso.com\",'
+ '  \"name\":\"いしい　てすと\"'
+ '  },'
+ ''
+ '  \"yoriso_option_kibo\":{'
+ '  \"saidan\":\"希望する\",'
+ '  \"owakare_bana\":\"希望する\",'
+ '  \"kanjo_hanataba\":\"希望する\",'
+ '  \"makura_bana\":\"希望する\"'
+ '  },'
+ ''
+ '  \"shodan_bango\":\"0423182\",'
+ '  '
+ '  \"sodansha\":{'
+ '  \"mei\":\"手巣都\",'
+ '  \"sei\":\"寄僧\",'
+ '  \"torihikisaki_bango\":\"ACNT-0310878\"'
+ '  },'
+ ''
+ '  '
+ '  \"sogi\":{'
+ '  \"kaso_datetime\":\"2018-08-30 00:00:00\",'
+ '  \"kasoba_name\":\"梅﨑火葬場\",'
+ '  \"kokubetsushiki_datetime\":\"2018-08-30 00:00:00\",'
+ '  \"shikijo_name\":\"梅﨑斎場\",'
+ '  \"shukkan_datetime\":\"2018-08-29 00:00:00\",'
+ '  \"tsuya_datetime\":\"2018-08-29 00:00:00\"'
+ '  },'
+ ''
+ '  '
+ '  \"sogi_plan\":{'
+ '  \"kingaku\":298000,'
+ '  \"name\":\"よりそうお葬式　標準プラン\",'
+ '  \"shohin_bango\":\"SBG-0005007\"'
+ '  },'
+ ''
+ '  '
+ '  \"soryo_tehai\":{'
+ '  \"kaimyo\":\"釋\",'
+ '  \"tehai_umu\":\"未定\"'
+ '  },'
+ ''
+ '  \"soukyaku_bango\":\"{!soukyaku_bango}\",'
+ '  '
+ '  \"soukyakusaki\":{'
+ '  \"tantosha_name\":\"梅﨑 丈晴\",'
+ '  \"tantosha_tel\":\"080-1234-5678\",'
+ '  \"torihikisaki_bango\":\"ACNT-0412384\",'
+ '  \"torihikisaki_name\":\"テスト梅崎葬儀社\"'
+ '  },'
+ ''
+ '  '
+ '  \"taishosha\":{'
+ '  \"addr_city\":\"横浜市青葉区\",'
+ '  \"addr_postal_code\":\"2270043\",'
+ '  \"addr_state\":\"神奈川県\",'
+ '  \"addr_street\":\"藤が丘２－１\",'
+ '  \"age\":38,'
+ '  \"birth_date\":\"1980-08-01\",'
+ '  \"bodaiji_umu\":\"有\",'
+ '  \"death_date\":\"2018-08-13\",'
+ '  \"gender\":\"女性\",'
+ '  \"jumhyo_city\":\"品川区\",'
+ '  \"jumhyo_postal_code\":\"1410031\",'
+ '  \"jumhyo_state\":\"東京都\",'
+ '  \"jumhyo_street\":\"西五反田１１１\",'
+ '  \"mei\":\"テスト２０１８０３１６０１\",'
+ '  \"mei_kana\":\"テストタイショウシャ\",'
+ '  \"sei\":\"テスト対象者\",'
+ '  \"sei_kana\":\"テストタイショウシャ\",'
+ '  \"shuha\":\"sonota\",'
+ '  \"shuha_sonotaShuha\":\"高野山真言宗 その他宗派備考\",'
+ '  \"torihikisaki_bango\":\"ACNT-0404620\"'
+ '  },'

+ '    \"tsuika_hinmokus\": ['
+ '      {'
+ '        \"unit_price\": \"202\",'
+ '        \"quantity\": \"203\",'
+ '        \"name\": \"201\",'
+ '        \"hinmoku_bunrui\": [\"よりそう\",\"よりそう_祭壇アップグレード M (家族葬 一日プラン)\"],'
+ '        \"hinmoku_bunrui_name\" : \"test品目\",'
+ '        \"amount\": \"204\",'
+ '        \"shohin_bango\": \"SBG-0005401\"'
+ '      },'
+ '      {'
+ '        \"unit_price\": \"202\",'
+ '        \"quantity\": \"203\",'
+ '        \"name\": \"201\",'
+ '        \"hinmoku_bunrui\": [\"よりそう\",\"よりそう_祭壇アップグレード L (家族葬 一日プラン)\"],'
+ '        \"hinmoku_bunrui_name\" : \"test品目\",'
+ '        \"amount\": \"204\",'
+ '        \"shohin_bango\": \"SBG-0005402\"'
+ '      },'
+ '      {'
+ '        \"unit_price\": \"202\",'
+ '        \"quantity\": \"203\",'
+ '        \"name\": \"201\",'
+ '        \"hinmoku_bunrui\": [\"よりそう\",\"よりそう_祭壇アップグレード LL (家族葬 一日プラン)\"],'
+ '        \"hinmoku_bunrui_name\" : \"test品目\",'
+ '        \"amount\": \"204\",'
+ '        \"shohin_bango\": \"SBG-0005403\"'
+ '      },'
+ '      {'
+ '        \"unit_price\": \"202\",'
+ '        \"quantity\": \"203\",'
+ '        \"name\": \"201\",'
+ '        \"hinmoku_bunrui\": [\"よりそう\",\"よりそう_祭壇アップグレード L (家族葬 二日プラン)\"],'
+ '        \"hinmoku_bunrui_name\" : \"test品目\",'
+ '        \"amount\": \"204\",'
+ '        \"shohin_bango\": \"SBG-0005404\"'
+ '      },'
+ '      {'
+ '        \"unit_price\": \"202\",'
+ '        \"quantity\": \"203\",'
+ '        \"name\": \"201\",'
+ '        \"hinmoku_bunrui\": [\"よりそう\",\"よりそう_祭壇アップグレード LL (家族葬 二日プラン)\"],'
+ '        \"hinmoku_bunrui_name\" : \"test品目\",'
+ '        \"amount\": \"204\",'
+ '        \"shohin_bango\": \"SBG-0005405\"'
+ '      },'
+ '      {'
+ '        \"unit_price\": \"202\",'
+ '        \"quantity\": \"203\",'
+ '        \"name\": \"201\",'
+ '        \"hinmoku_bunrui\": [\"よりそう\",\"よりそう_祭壇アップグレード LL (家族葬 華やかプラン)\"],'
+ '        \"hinmoku_bunrui_name\" : \"test品目\",'
+ '        \"amount\": \"204\",'
+ '        \"shohin_bango\": \"SBG-0005406\"'
+ '      }'
+ '    ],'
+ ''
+ '  \"tekiyo_waribikis\":['
+ '	  {\"amount\":\"1\",'
+ '	  \"name\":\"よりそうのお葬式　事前割メンバー割引 (直葬)\",'
+ '	  \"quantity\":\"1\",'
+ '	  \"shohin_bango\":\"SBG-0000190\",'
+ '	  \"unit_price\":\"-5000\"'
+ '	  },'
+ ''
+ '	  {\"amount\":1,'
+ '	  \"name\":\"よりそうのお葬式　事前割メンバー割引 (家族葬)\",'
+ '	  \"quantity\":1,'
+ '	  \"shohin_bango\":\"SBG-0000190\",'
+ '	  \"unit_price\":\"555000\"'
+ '	  }'
+ '   ]'
+ '}';
       json = json.replace('{!soukyaku_bango}', sokyaku.Name);
       
      Test.startTest();
          
     RestRequest req = new RestRequest();
     RestResponse res = new RestResponse();
     
     req.requestURI = '/services/apexrest/api/v1/sogsok/mitsumorisho';
     req.httpMethod = 'POST';
      req.requestBody = Blob.valueof(json);

     RestContext.request = req;
     RestContext.response= res;
     
     //正常
     Api_V1_SogSok_MitsumoriSho.doPost();

      
     Test.stopTest();
  }

  @isTest static void test_method_8() {

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

     SogSok_Sokyaku__c sokyaku = new SogSok_Sokyaku__c(OpportunityRef__c=oppSimpleYasugo.Id,SoukyakuStatus__c='wait_for_mitsumorisho');
     insert sokyaku;
     sokyaku = [select id, name from SogSok_Sokyaku__c where id =:sokyaku.Id];


       String json =  '{\"doc_status\":\"activated\",'
+ '  \"kinyu_date\":\"2018-08-28\",'
+ '  '
+ '  \"moshu\":{'
+ '  \"addr_city\":\"横浜市青葉区\",'
+ '  \"addr_postal_code\":\"2270000\",'
+ '  \"addr_state\":\"神奈川県\",'
+ '  \"addr_street\":\"藤が丘２－１\",'
+ '  \"age\":null,'
+ '  \"birth_date\":\"2018-08-08\",'
+ '  \"gender\":\"男性\",'
+ '  \"mei\":\"手巣都\",'
+ '  \"mei_kana\":\"テスト\",'
+ '  \"mobile\":\"0123-456-7890\",'
+ '  \"phone\":\"0123-456-7890\",'
+ '  \"sei\":\"寄僧\",'
+ '  \"sei_kana\":\"ヨリソウ\",'
+ '  \"zokugara_from_soudansha\":\"otto\"'
+ '  },'
+ ''
+ '  \"sign_url\":\"https://127.0.0.1.jp/api/file/8\",'
+ '  '
+ '  \"shiharai\":{'
+ '  \"card_kingaku\":298000,'
+ '  \"genkin_kingaku\":0,'
+ '  \"loan_kingaku\":0,'
+ '  \"maeuke_kingaku\":0,'
+ '  \"gmo_kingaku\":0'
+ '  },'
+ ''
+ '  '
+ '  \"shiharaisha\":{'
+ '  \"addr_city\":\"品川区\",'
+ '  \"addr_postal_code\":\"1410031\",'
+ '  \"addr_state\":\"東京都\",'
+ '  \"addr_street\":\"西五反田１１１\",'
+ '  \"atena\":\"いしい　てすと\",'
+ '  \"email\":\"testtest+20180828@yoriso.com\",'
+ '  \"name\":\"いしい　てすと\"'
+ '  },'
+ ''
+ '  \"yoriso_option_kibo\":{'
+ '  \"saidan\":\"希望する\",'
+ '  \"owakare_bana\":\"希望する\",'
+ '  \"kanjo_hanataba\":\"希望する\",'
+ '  \"makura_bana\":\"希望する\"'
+ '  },'
+ ''
+ '  \"shodan_bango\":\"0423182\",'
+ '  '
+ '  \"sodansha\":{'
+ '  \"mei\":\"手巣都\",'
+ '  \"sei\":\"寄僧\",'
+ '  \"torihikisaki_bango\":\"ACNT-0310878\"'
+ '  },'
+ ''
+ '  '
+ '  \"sogi\":{'
+ '  \"kaso_datetime\":\"2018-08-30 00:00:00\",'
+ '  \"kasoba_name\":\"梅﨑火葬場\",'
+ '  \"kokubetsushiki_datetime\":\"2018-08-30 00:00:00\",'
+ '  \"shikijo_name\":\"梅﨑斎場\",'
+ '  \"shukkan_datetime\":\"2018-08-29 00:00:00\",'
+ '  \"tsuya_datetime\":\"2018-08-29 00:00:00\"'
+ '  },'
+ ''
+ '  '
+ '  \"sogi_plan\":{'
+ '  \"kingaku\":298000,'
+ '  \"name\":\"よりそうお葬式　標準プラン\",'
+ '  \"shohin_bango\":\"SBG-0005007\",'
+ '  \"butsugu_kibo":\"仏具なし\",'
+ '  \"last_message":\"希望する\",'
+ '  \"ohanaire":\"希望する\",'
+ '  \"memorial_corner":\"希望する\",'
+ '  \"iei_hanakazari":\"希望する\"'
+ '  },'
+ ''
+ '  '
+ '  \"soryo_tehai\":{'
+ '  \"kaimyo\":\"釋\",'
+ '  \"tehai_umu\":\"未定\"'
+ '  },'
+ ''
+ '  \"soukyaku_bango\":\"{!soukyaku_bango}\",'
+ '  '
+ '  \"soukyakusaki\":{'
+ '  \"tantosha_name\":\"梅﨑 丈晴\",'
+ '  \"tantosha_tel\":\"080-1234-5678\",'
+ '  \"torihikisaki_bango\":\"ACNT-0412384\",'
+ '  \"torihikisaki_name\":\"テスト梅崎葬儀社\"'
+ '  },'
+ ''
+ '  '
+ '  \"taishosha\":{'
+ '  \"addr_city\":\"横浜市青葉区\",'
+ '  \"addr_postal_code\":\"2270043\",'
+ '  \"addr_state\":\"神奈川県\",'
+ '  \"addr_street\":\"藤が丘２－１\",'
+ '  \"age\":38,'
+ '  \"birth_date\":\"1980-08-01\",'
+ '  \"bodaiji_umu\":\"有\",'
+ '  \"death_date\":\"2018-08-13\",'
+ '  \"gender\":\"女性\",'
+ '  \"jumhyo_city\":\"品川区\",'
+ '  \"jumhyo_postal_code\":\"1410031\",'
+ '  \"jumhyo_state\":\"東京都\",'
+ '  \"jumhyo_street\":\"西五反田１１１\",'
+ '  \"mei\":\"テスト２０１８０３１６０１\",'
+ '  \"mei_kana\":\"テストタイショウシャ\",'
+ '  \"sei\":\"テスト対象者\",'
+ '  \"sei_kana\":\"テストタイショウシャ\",'
+ '  \"shuha\":\"sonota\",'
+ '  \"shuha_sonotaShuha\":\"高野山真言宗 その他宗派備考\",'
+ '  \"torihikisaki_bango\":\"ACNT-0404620\"'
+ '  },'

+ '    \"tsuika_hinmokus\": ['
+ '      {'
+ '        \"unit_price\": \"202\",'
+ '        \"quantity\": \"203\",'
+ '        \"name\": \"201\",'
+ '        \"hinmoku_bunrui\": [\"よりそう\",\"よりそう_祭壇アップグレード M (家族葬 一日プラン)\"],'
+ '        \"hinmoku_bunrui_name\" : \"test品目\",'
+ '        \"amount\": \"204\",'
+ '        \"shohin_bango\": \"SBG-0005401\"'
+ '      },'
+ '      {'
+ '        \"unit_price\": \"202\",'
+ '        \"quantity\": \"203\",'
+ '        \"name\": \"201\",'
+ '        \"hinmoku_bunrui\": [\"よりそう\",\"よりそう_祭壇アップグレード L (家族葬 一日プラン)\"],'
+ '        \"hinmoku_bunrui_name\" : \"test品目\",'
+ '        \"amount\": \"204\",'
+ '        \"shohin_bango\": \"SBG-0005402\"'
+ '      },'
+ '      {'
+ '        \"unit_price\": \"202\",'
+ '        \"quantity\": \"203\",'
+ '        \"name\": \"201\",'
+ '        \"hinmoku_bunrui\": [\"よりそう\",\"よりそう_祭壇アップグレード LL (家族葬 一日プラン)\"],'
+ '        \"hinmoku_bunrui_name\" : \"test品目\",'
+ '        \"amount\": \"204\",'
+ '        \"shohin_bango\": \"SBG-0005403\"'
+ '      },'
+ '      {'
+ '        \"unit_price\": \"202\",'
+ '        \"quantity\": \"203\",'
+ '        \"name\": \"201\",'
+ '        \"hinmoku_bunrui\": [\"よりそう\",\"よりそう_祭壇アップグレード L (家族葬 二日プラン)\"],'
+ '        \"hinmoku_bunrui_name\" : \"test品目\",'
+ '        \"amount\": \"204\",'
+ '        \"shohin_bango\": \"SBG-0005404\"'
+ '      },'
+ '      {'
+ '        \"unit_price\": \"202\",'
+ '        \"quantity\": \"203\",'
+ '        \"name\": \"201\",'
+ '        \"hinmoku_bunrui\": [\"よりそう\",\"よりそう_祭壇アップグレード LL (家族葬 二日プラン)\"],'
+ '        \"hinmoku_bunrui_name\" : \"test品目\",'
+ '        \"amount\": \"204\",'
+ '        \"shohin_bango\": \"SBG-0005405\"'
+ '      },'
+ '      {'
+ '        \"unit_price\": \"202\",'
+ '        \"quantity\": \"203\",'
+ '        \"name\": \"201\",'
+ '        \"hinmoku_bunrui\": [\"よりそう\",\"よりそう_祭壇アップグレード LL (家族葬 華やかプラン)\"],'
+ '        \"hinmoku_bunrui_name\" : \"test品目\",'
+ '        \"amount\": \"204\",'
+ '        \"shohin_bango\": \"SBG-0005406\"'
+ '      },'
+ '      {'
+ '        \"unit_price\": \"202\",'
+ '        \"quantity\": \"203\",'
+ '        \"name\": \"201\",'
+ '        \"hinmoku_bunrui\": [\"よりそう\",\"よりそう_付添安置 (1泊)\"],'
+ '        \"hinmoku_bunrui_name\" : \"test品目\",'
+ '        \"amount\": \"204\",'
+ '        \"shohin_bango\": \"SBG-0005417\"'
+ '      }'
+ '    ],'
+ ''
+ '  \"tekiyo_waribikis\":['
+ '	  {\"amount\":\"1\",'
+ '	  \"name\":\"よりそうのお葬式　事前割メンバー割引 (直葬)\",'
+ '	  \"quantity\":\"1\",'
+ '	  \"shohin_bango\":\"SBG-0000190\",'
+ '	  \"unit_price\":\"-5000\"'
+ '	  },'
+ ''
+ '	  {\"amount\":1,'
+ '	  \"name\":\"よりそうのお葬式　事前割メンバー割引 (家族葬)\",'
+ '	  \"quantity\":1,'
+ '	  \"shohin_bango\":\"SBG-0000190\",'
+ '	  \"unit_price\":\"555000\"'
+ '	  }'
+ '   ]'
+ '}';
       json = json.replace('{!soukyaku_bango}', sokyaku.Name);
       
      Test.startTest();
          
     RestRequest req = new RestRequest();
     RestResponse res = new RestResponse();
     
     req.requestURI = '/services/apexrest/api/v1/sogsok/mitsumorisho';
     req.httpMethod = 'POST';
      req.requestBody = Blob.valueof(json);

     RestContext.request = req;
     RestContext.response= res;
     
     //正常
     Api_V1_SogSok_MitsumoriSho.doPost();

      
     Test.stopTest();
  }

  @isTest static void test_method_9() {

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

     SogSok_Sokyaku__c sokyaku = new SogSok_Sokyaku__c(OpportunityRef__c=oppSimpleYasugo.Id,SoukyakuStatus__c='wait_for_mitsumorisho');
     insert sokyaku;
     sokyaku = [select id, name from SogSok_Sokyaku__c where id =:sokyaku.Id];


       String json =  '{\"doc_status\":\"activated\",'
+ '  \"kinyu_date\":\"2018-08-28\",'
+ '  '
+ '  \"moshu\":{'
+ '  \"addr_city\":\"横浜市青葉区\",'
+ '  \"addr_postal_code\":\"2270000\",'
+ '  \"addr_state\":\"神奈川県\",'
+ '  \"addr_street\":\"藤が丘２－１\",'
+ '  \"age\":null,'
+ '  \"birth_date\":\"2018-08-08\",'
+ '  \"gender\":\"男性\",'
+ '  \"mei\":\"手巣都\",'
+ '  \"mei_kana\":\"テスト\",'
+ '  \"mobile\":\"0123-456-7890\",'
+ '  \"phone\":\"0123-456-7890\",'
+ '  \"sei\":\"寄僧\",'
+ '  \"sei_kana\":\"ヨリソウ\",'
+ '  \"zokugara_from_soudansha\":\"otto\"'
+ '  },'
+ ''
+ '  \"sign_url\":\"https://127.0.0.1.jp/api/file/8\",'
+ '  '
+ '  \"shiharai\":{'
+ '  \"card_kingaku\":298000,'
+ '  \"genkin_kingaku\":0,'
+ '  \"loan_kingaku\":0,'
+ '  \"maeuke_kingaku\":0,'
+ '  \"gmo_kingaku\":0'
+ '  },'
+ ''
+ '  '
+ '  \"shiharaisha\":{'
+ '  \"addr_city\":\"品川区\",'
+ '  \"addr_postal_code\":\"1410031\",'
+ '  \"addr_state\":\"東京都\",'
+ '  \"addr_street\":\"西五反田１１１\",'
+ '  \"atena\":\"いしい　てすと\",'
+ '  \"email\":\"testtest+20180828@yoriso.com\",'
+ '  \"name\":\"いしい　てすと\"'
+ '  },'
+ ''
+ '  \"yoriso_option_kibo\":{'
+ '  \"saidan\":\"希望する\",'
+ '  \"owakare_bana\":\"希望する\",'
+ '  \"kanjo_hanataba\":\"希望する\",'
+ '  \"makura_bana\":\"希望する\"'
+ '  },'
+ ''
+ '  \"shodan_bango\":\"0423182\",'
+ '  '
+ '  \"sodansha\":{'
+ '  \"mei\":\"手巣都\",'
+ '  \"sei\":\"寄僧\",'
+ '  \"torihikisaki_bango\":\"ACNT-0310878\"'
+ '  },'
+ ''
+ '  '
+ '  \"sogi\":{'
+ '  \"kaso_datetime\":\"2018-08-30 00:00:00\",'
+ '  \"kasoba_name\":\"梅﨑火葬場\",'
+ '  \"kokubetsushiki_datetime\":\"2018-08-30 00:00:00\",'
+ '  \"shikijo_name\":\"梅﨑斎場\",'
+ '  \"shukkan_datetime\":\"2018-08-29 00:00:00\",'
+ '  \"tsuya_datetime\":\"2018-08-29 00:00:00\"'
+ '  },'
+ ''
+ '  '
+ '  \"sogi_plan\":{'
+ '  \"kingaku\":298000,'
+ '  \"name\":\"よりそうお葬式　標準プラン\",'
+ '  \"shohin_bango\":\"SBG-0005005\",'
+ '  \"butsugu_kibo":\"仏具なし\",'
+ '  \"last_message":\"希望する\",'
+ '  \"ohanaire":\"希望する\",'
+ '  \"memorial_corner":\"希望する\",'
+ '  \"iei_hanakazari":\"希望する\"'
+ '  },'
+ ''
+ '  '
+ '  \"soryo_tehai\":{'
+ '  \"kaimyo\":\"釋\",'
+ '  \"tehai_umu\":\"未定\"'
+ '  },'
+ ''
+ '  \"soukyaku_bango\":\"{!soukyaku_bango}\",'
+ '  '
+ '  \"soukyakusaki\":{'
+ '  \"tantosha_name\":\"梅﨑 丈晴\",'
+ '  \"tantosha_tel\":\"080-1234-5678\",'
+ '  \"torihikisaki_bango\":\"ACNT-0412384\",'
+ '  \"torihikisaki_name\":\"テスト梅崎葬儀社\"'
+ '  },'
+ ''
+ '  '
+ '  \"taishosha\":{'
+ '  \"addr_city\":\"横浜市青葉区\",'
+ '  \"addr_postal_code\":\"2270043\",'
+ '  \"addr_state\":\"神奈川県\",'
+ '  \"addr_street\":\"藤が丘２－１\",'
+ '  \"age\":38,'
+ '  \"birth_date\":\"1980-08-01\",'
+ '  \"bodaiji_umu\":\"有\",'
+ '  \"death_date\":\"2018-08-13\",'
+ '  \"gender\":\"女性\",'
+ '  \"jumhyo_city\":\"品川区\",'
+ '  \"jumhyo_postal_code\":\"1410031\",'
+ '  \"jumhyo_state\":\"東京都\",'
+ '  \"jumhyo_street\":\"西五反田１１１\",'
+ '  \"mei\":\"テスト２０１８０３１６０１\",'
+ '  \"mei_kana\":\"テストタイショウシャ\",'
+ '  \"sei\":\"テスト対象者\",'
+ '  \"sei_kana\":\"テストタイショウシャ\",'
+ '  \"shuha\":\"sonota\",'
+ '  \"shuha_sonotaShuha\":\"高野山真言宗 その他宗派備考\",'
+ '  \"torihikisaki_bango\":\"ACNT-0404620\"'
+ '  },'

+ '    \"tsuika_hinmokus\": ['
+ '      {'
+ '        \"unit_price\": \"202\",'
+ '        \"quantity\": \"203\",'
+ '        \"name\": \"201\",'
+ '        \"hinmoku_bunrui\": [\"よりそう\",\"よりそう_祭壇アップグレード M (家族葬 一日プラン)\"],'
+ '        \"hinmoku_bunrui_name\" : \"test品目\",'
+ '        \"amount\": \"204\",'
+ '        \"shohin_bango\": \"SBG-0005401\"'
+ '      },'
+ '      {'
+ '        \"unit_price\": \"202\",'
+ '        \"quantity\": \"203\",'
+ '        \"name\": \"201\",'
+ '        \"hinmoku_bunrui\": [\"よりそう\",\"よりそう_祭壇アップグレード L (家族葬 一日プラン)\"],'
+ '        \"hinmoku_bunrui_name\" : \"test品目\",'
+ '        \"amount\": \"204\",'
+ '        \"shohin_bango\": \"SBG-0005402\"'
+ '      },'
+ '      {'
+ '        \"unit_price\": \"202\",'
+ '        \"quantity\": \"203\",'
+ '        \"name\": \"201\",'
+ '        \"hinmoku_bunrui\": [\"よりそう\",\"よりそう_祭壇アップグレード LL (家族葬 一日プラン)\"],'
+ '        \"hinmoku_bunrui_name\" : \"test品目\",'
+ '        \"amount\": \"204\",'
+ '        \"shohin_bango\": \"SBG-0005403\"'
+ '      },'
+ '      {'
+ '        \"unit_price\": \"202\",'
+ '        \"quantity\": \"203\",'
+ '        \"name\": \"201\",'
+ '        \"hinmoku_bunrui\": [\"よりそう\",\"よりそう_祭壇アップグレード L (家族葬 二日プラン)\"],'
+ '        \"hinmoku_bunrui_name\" : \"test品目\",'
+ '        \"amount\": \"204\",'
+ '        \"shohin_bango\": \"SBG-0005404\"'
+ '      },'
+ '      {'
+ '        \"unit_price\": \"202\",'
+ '        \"quantity\": \"203\",'
+ '        \"name\": \"201\",'
+ '        \"hinmoku_bunrui\": [\"よりそう\",\"よりそう_祭壇アップグレード LL (家族葬 二日プラン)\"],'
+ '        \"hinmoku_bunrui_name\" : \"test品目\",'
+ '        \"amount\": \"204\",'
+ '        \"shohin_bango\": \"SBG-0005405\"'
+ '      },'
+ '      {'
+ '        \"unit_price\": \"202\",'
+ '        \"quantity\": \"203\",'
+ '        \"name\": \"201\",'
+ '        \"hinmoku_bunrui\": [\"よりそう\",\"よりそう_祭壇アップグレード LL (家族葬 華やかプラン)\"],'
+ '        \"hinmoku_bunrui_name\" : \"test品目\",'
+ '        \"amount\": \"204\",'
+ '        \"shohin_bango\": \"SBG-0005406\"'
+ '      }'
+ '    ],'
+ ''
+ '  \"tekiyo_waribikis\":['
+ '	  {\"amount\":\"1\",'
+ '	  \"name\":\"よりそうのお葬式　事前割メンバー割引 (直葬)\",'
+ '	  \"quantity\":\"1\",'
+ '	  \"shohin_bango\":\"SBG-0000190\",'
+ '	  \"unit_price\":\"-5000\"'
+ '	  },'
+ ''
+ '	  {\"amount\":1,'
+ '	  \"name\":\"よりそうのお葬式　事前割メンバー割引 (家族葬)\",'
+ '	  \"quantity\":1,'
+ '	  \"shohin_bango\":\"SBG-0000190\",'
+ '	  \"unit_price\":\"555000\"'
+ '	  }'
+ '   ]'
+ '}';
       json = json.replace('{!soukyaku_bango}', sokyaku.Name);
       
      Test.startTest();
          
     RestRequest req = new RestRequest();
     RestResponse res = new RestResponse();
     
     req.requestURI = '/services/apexrest/api/v1/sogsok/mitsumorisho';
     req.httpMethod = 'POST';
      req.requestBody = Blob.valueof(json);

     RestContext.request = req;
     RestContext.response= res;
     
     //正常
     Api_V1_SogSok_MitsumoriSho.doPost();

      
     Test.stopTest();
  }
}