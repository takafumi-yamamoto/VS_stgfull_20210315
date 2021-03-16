@isTest
private class SogSok_MitsumoriSho_TorikomingT {
     private static void beginSetUp(){
          Utility_Common.isMimicExecAsDataIkouProfile = true;
     }
	private static void endSetUp(){
        Insert new TriggerIsActive__c( name='default', isActive__c=true );
        Insert new JizenWariPlan__c( Code__c='Yoriso' );
        Insert new Account(
            RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','null'),
            FirstName = '_', LastName = '_'
        );
		Utility_Common.isMimicExecAsDataIkouProfile = false;
	}

     @isTest
     public static void doTest(){
          beginSetUp();
		Map<String, Account> theAccounts = new Map<String, Account>{
			'Customer' => new Account(
				RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
				FirstName = '_', LastName = '_'
			)
		};
		INSERT theAccounts.values();
		Map<String, SimpleYasugo__c> theSimpleYasugos = new Map<String, SimpleYasugo__c>{
			'シンプル安豪' => new SimpleYasugo__c()
		};
		INSERT theSimpleYasugos.values();

		Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
			'シンプル安豪' => new Opportunity(
				RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo'),
				Name = '_', StageName = '_', Pricebook2Id = Test.getStandardPricebookId(),
				CloseDate = Date.newInstance(2020,1,1),
				AccountId = theAccounts.get('Customer').Id,
				SimpleYasugoRef__c = theSimpleYasugos.get('シンプル安豪').Id
			)
		};
		INSERT theOpps.values();

          Map<String, SogSok_MitsumoriSho_Torik__c> theToriks = new Map<String, SogSok_MitsumoriSho_Torik__c>{
               '取込シート' => new SogSok_MitsumoriSho_Torik__c(
                    status__c = '未取込', syop_Ref__c = theOpps.get('シンプル安豪').Id, 
                    syop_SoudanshaRef__c = theAccounts.get('Customer').Id, syop_TaishoShaRef__c = theAccounts.get('Customer').Id,
                    syop_Moshu_Mobile__c = '_'
               )
          };
          INSERT theToriks.values();
          endSetUp();

          Test.startTest();
          UPDATE new SogSok_MitsumoriSho_Torik__c(Id = theToriks.get('取込シート').Id, status__c = '取込');
          Test.stopTest();
     }

     @isTest
     public static void moshu_duplication_will_occur(){
          beginSetUp();
		Map<String, Account> theAccounts = new Map<String, Account>{
			'Customer' => new Account(
				RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
				FirstName = '_', LastName = '_'
			),
			'喪主' => new Account(
				RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
				FirstName = '喪主', LastName = '喪主',
                    FirstNameFurigana__pc = 'モシュ', LastNameFurigana__pc = 'モシュ', NayosePhone1__c = '080'
			)
		};
		INSERT theAccounts.values();
		Map<String, SimpleYasugo__c> theSimpleYasugos = new Map<String, SimpleYasugo__c>{
			'シンプル安豪' => new SimpleYasugo__c(MoshuRef__c = theAccounts.get('喪主').Id)
		};
		INSERT theSimpleYasugos.values();

		Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
			'シンプル安豪' => new Opportunity(
				RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo'),
				Name = '_', StageName = '_', Pricebook2Id = Test.getStandardPricebookId(),
				CloseDate = Date.newInstance(2020,1,1),
				AccountId = theAccounts.get('Customer').Id,
				SimpleYasugoRef__c = theSimpleYasugos.get('シンプル安豪').Id
			)
		};
		INSERT theOpps.values();

          Map<String, SogSok_MitsumoriSho_Torik__c> theToriks = new Map<String, SogSok_MitsumoriSho_Torik__c>{
               '取込シート' => new SogSok_MitsumoriSho_Torik__c(
                    status__c = '未取込', syop_Ref__c = theOpps.get('シンプル安豪').Id, 
                    syop_SoudanshaRef__c = theAccounts.get('Customer').Id, syop_TaishoShaRef__c = theAccounts.get('Customer').Id,
                    syop_Moshu_Sei__c = '変更', 
                    syop_Moshu_SeiKana__c = 'モシュ', syop_Moshu_MeiKana__c = 'モシュ', syop_Moshu_Mobile__c = '080'
               )
          };
          INSERT theToriks.values();
          endSetUp();

          Test.startTest();
          UPDATE new SogSok_MitsumoriSho_Torik__c(Id = theToriks.get('取込シート').Id, status__c = '取込');
          Test.stopTest();
     }

	@isTest static void test_SogSok_MitsumoriSho_Torikoming() {
		PtWebAccount__c ptWebAccount = new PtWebAccount__c(mailAddress__c='completedtest@yoriso.com');
        insert ptWebAccount;

        SampleData sampledata = new sampleData();

        List<Account> accList = new List<Account>();
        accList.add(sampledata.getAccountNull());
        accList.add(sampledata.getAccountSoryo());

        Account soudansha = sampledata.getAccountCustomer();
        soudansha.FirstNameFurigana__pc = 'テスト1';
        soudansha.LastNameFurigana__pc = 'テスト1';
        soudansha.Phone = '080-0000-1111';
        soudansha.MobilePhone__c = '090-0000-1112';
        accList.add(soudansha);


        Account taisyousya = sampledata.getAccountCustomer();
        taisyousya.FirstNameFurigana__pc = 'テスト2';
        taisyousya.LastNameFurigana__pc = 'テスト2';
        taisyousya.PersonBirthdate = date.today().addYears(-80);
        taisyousya.PersonDeathDate__pc = date.today();
        taisyousya.Phone = '080-0000-1113';
        taisyousya.MobilePhone__c = '090-0000-1114';
        accList.add(taisyousya);

        Account moshu = sampledata.getAccountCustomer();
        moshu.FirstNameFurigana__pc = 'テストmoshu';
        moshu.LastNameFurigana__pc = 'テスト';
        moshu.Phone = '080-0000-1113';
        moshu.MobilePhone__c = '090-0000-1113';
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
             ShohinBango__c = 'SBG-0000001',      
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
             ShohinBango__c = 'SBG-0000002',      
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
             ShohinBango__c = 'SBG-0000003',   
             k_ShohinSyubetsuRef__c=k_shohinsyubetsu0.id,
             isActive = true
        );
        prodList.add(prod2);
        //Create your product
        Product2 prod3 = new Product2(
             Name = 'Product X',
             ProductCode = 'Pro-X',
             DataKubun__c='1:通常商品',          
             ShohinBango__c = 'SBG-0000018',   
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

	    // 商談
		String oppTorihikiShodanRdId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','TorihikiShodan');
		Opportunity opp = new Opportunity(Name = 'テスト商談', AccountId = soudansha.Id, RecordTypeId = oppTorihikiShodanRdId, StageName = 'フォロー',CloseDate = system.today());	
		insert opp;	
		Opportunity oppSimpleYasugo = new Opportunity(
			Name = 'テスト商談', 
			AccountId = soudansha.Id, 
			TaishosyaRef__c = taisyousya.Id, 
			RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo'),
			TorihikiShodanRef__c=opp.id,
			StageName = 'フォロー',
			CloseDate = system.today(), 
			TaishoushaJokyo__c = '_',
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

		SogSok_MitsumoriSho__c sogsok_mitsumorisho = new SogSok_MitsumoriSho__c();
		insert sogsok_mitsumorisho;

		sokyaku.MitsumoriShoRef__c = sogsok_mitsumorisho.Id;
		update sokyaku;
		
		List<SogSok_MitsumoriSho_Torik__c> sogsok_mitsumorisho_torikList = new List<SogSok_MitsumoriSho_Torik__c>();
		SogSok_MitsumoriSho_Torik__c sogsok_mitsumorisho_torik0 = new SogSok_MitsumoriSho_Torik__c();
		sogsok_mitsumorisho_torik0.syop_ref__c = oppSimpleYasugo.Id;
		sogsok_mitsumorisho_torik0.MitsumoriShoRef__c = sogsok_mitsumorisho.Id;
		sogsok_mitsumorisho_torik0.syop_soudansha_sei__c = '更新テスト姓';
		sogsok_mitsumorisho_torik0.syop_soudansha_mei__c = '更新テスト名';
		sogsok_mitsumorisho_torik0.status__c = '未取込';
		sogsok_mitsumorisho_torik0.syop_soudansharef__c = soudansha.Id;
		sogsok_mitsumorisho_torik0.syop_taishosharef__c = taisyousya.Id;
		// sogsok_mitsumorisho_torik0.syop_taishosha_shuha_sonota__c = '';    // syop_TaishoSha_Shuha_Sonota
		sogsok_mitsumorisho_torik0.syop_taishosha_sei__c = '対象者姓';
		sogsok_mitsumorisho_torik0.syop_taishosha_mei__c = '名0809';
		sogsok_mitsumorisho_torik0.syop_taishosha_birthdate__c = Date.newInstance(2018, 08, 08);
		sogsok_mitsumorisho_torik0.syop_taishosha_deathdate__c = Date.newInstance(2018, 08, 07);
		sogsok_mitsumorisho_torik0.syop_taishosha_age__c = 21.0;
		sogsok_mitsumorisho_torik0.syop_taishosha_addr_postalcode__c = '1500001';
		sogsok_mitsumorisho_torik0.syop_taishosha_addr_state__c = '東京';
		sogsok_mitsumorisho_torik0.syop_taishosha_addr_city__c = '品川区';
		sogsok_mitsumorisho_torik0.syop_taishosha_addr_street__c = '五反田';
		sogsok_mitsumorisho_torik0.syop_taishosha_jumh_state__c = '埼玉';
		sogsok_mitsumorisho_torik0.syop_taishosha_jumh_city__c = '蕨';
		sogsok_mitsumorisho_torik0.syop_moshuref__c = moshu.Id;
		sogsok_mitsumorisho_torik0.syop_moshu_sei__c = '喪主喪主';
		sogsok_mitsumorisho_torik0.syop_moshu_mei__c = '命名';
		sogsok_mitsumorisho_torik0.syop_moshu_seikana__c = 'モシュウ';
		sogsok_mitsumorisho_torik0.syop_moshu_meikana__c = 'タロウ';
		sogsok_mitsumorisho_torik0.syop_taishosha_shuha__c = '浄土真宗本願寺派';
		sogsok_mitsumorisho_torik0.syop_moshu_phone__c = '080-0000-0002';
		sogsok_mitsumorisho_torik0.syop_moshu_mobile__c = '080-0000-0001';
		sogsok_mitsumorisho_torik0.syop_moshu_addr_postalcode__c = '130-0001';
		sogsok_mitsumorisho_torik0.syop_moshu_addr_state__c = '東京';
		sogsok_mitsumorisho_torik0.syop_moshu_addr_city__c = '渋谷区';
		sogsok_mitsumorisho_torik0.syop_moshu_addr_street__c = '渋谷１－１';
		sogsok_mitsumorisho_torik0.syop_tsuyadatetime__c = Datetime.newInstance(2018, 07, 01, 03, 00, 00);
		sogsok_mitsumorisho_torik0.syop_kokubetsudatetime__c = Datetime.newInstance(2018, 07, 02, 03, 00, 00);
		sogsok_mitsumorisho_torik0.syop_shukkandatetime__c = Datetime.newInstance(2018, 07, 03, 03, 00, 00);
		sogsok_mitsumorisho_torik0.syop_kasodatetime__c = Datetime.newInstance(2018, 07, 04, 03, 00, 00);
		sogsok_mitsumorisho_torik0.syop_sonotasaijoname__c = '斎場名１１１';
		sogsok_mitsumorisho_torik0.syop_sonotakasobaname__c = 'その他火葬場';
		sogsok_mitsumorisho_torik0.syop_sogitantoname__c = '葬儀担当者';
		sogsok_mitsumorisho_torik0.syop_mitsumorijuryodate__c = Date.newInstance(2018, 07, 09);
		sogsok_mitsumorisho_torik0.syop_ryos_atena__c = '渋谷区１－１';
		sogsok_mitsumorisho_torik0.syop_ryos_postalcode__c = '15000001';
		sogsok_mitsumorisho_torik0.syop_ryos_state__c = '東京';
		sogsok_mitsumorisho_torik0.syop_ryos_city__c = '渋谷区';
		sogsok_mitsumorisho_torik0.syop_ryos_street__c = '渋谷区１－１';
		sogsok_mitsumorisho_torik0.syop_moshu_birthdate__c = Date.newInstance(2018, 08, 01);
		sogsok_mitsumorisho_torik0.syop_ryos_ryosyushohitsuyo__c = False;
		sogsok_mitsumorisho_torik0.syop_planhenkouumu__c = False;
		// sogsok_mitsumorisho_torik0.syop_taishosha_bodaiji_umu__c = '';    // syop_TaishoSha_Bodaiji_Umu
		sogsok_mitsumorisho_torik0.syop_taishosha_gender__c = '男性';
		sogsok_mitsumorisho_torik0.syop_moshu_gender__c = '女性';
		sogsok_mitsumorisho_torik0.syop_moshuzokugarafromsoudansha__c = '知人';
		sogsok_mitsumorisho_torik0.syop_soryotehaikiboumu__c = '要';
		sogsok_mitsumorisho_torik0.syop_kaimyokiboumu__c = '有';
		sogsok_mitsumorisho_torik0.syop_kaimyo__c = '釋尼';
		sogsok_mitsumorisho_torikList.add(sogsok_mitsumorisho_torik0);
		insert sogsok_mitsumorisho_torikList;
		
		Test.startTest();	
		sogsok_mitsumorisho_torik0.status__c = '取込';
		update sogsok_mitsumorisho_torik0;
		Test.stopTest();

     }
     
     @isTest static void test_SogSok_MitsumoriSho() {
		PtWebAccount__c ptWebAccount = new PtWebAccount__c(mailAddress__c='completedtest@yoriso.com');
        insert ptWebAccount;

        SampleData sampledata = new sampleData();

        List<Account> accList = new List<Account>();
        accList.add(sampledata.getAccountNull());
        accList.add(sampledata.getAccountSoryo());

        Account soudansha = sampledata.getAccountCustomer();
        soudansha.FirstNameFurigana__pc = 'テスト1';
        soudansha.LastNameFurigana__pc = 'テスト1';
        soudansha.Phone = '080-0000-1111';
        soudansha.MobilePhone__c = '090-0000-1112';
        accList.add(soudansha);


        Account taisyousya = sampledata.getAccountCustomer();
        taisyousya.FirstNameFurigana__pc = 'テスト2';
        taisyousya.LastNameFurigana__pc = 'テスト2';
        taisyousya.PersonBirthdate = date.today().addYears(-80);
        taisyousya.PersonDeathDate__pc = date.today();
        taisyousya.Phone = '080-0000-1113';
        taisyousya.MobilePhone__c = '090-0000-1114';
        accList.add(taisyousya);

        Account moshu = sampledata.getAccountCustomer();
        moshu.FirstNameFurigana__pc = 'テストmoshu';
        moshu.LastNameFurigana__pc = 'テスト';
        moshu.Phone = '080-0000-1113';
        moshu.MobilePhone__c = '090-0000-1113';
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
             ShohinBango__c = 'SBG-0005006',      
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
             ShohinBango__c = 'SBG-0005101',      
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
             ShohinBango__c = 'SBG-0003531',   
             k_ShohinSyubetsuRef__c=k_shohinsyubetsu0.id,
             isActive = true
        );
        prodList.add(prod2);
        //Create your product
        Product2 prod3 = new Product2(
             Name = 'Product X',
             ProductCode = 'Pro-X',
             DataKubun__c='1:通常商品',          
             ShohinBango__c = 'SBG-0005501',   
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

	    // 商談
		String oppTorihikiShodanRdId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','TorihikiShodan');
		Opportunity opp = new Opportunity(Name = 'テスト商談', AccountId = soudansha.Id, RecordTypeId = oppTorihikiShodanRdId, StageName = 'フォロー',CloseDate = system.today());	
		insert opp;	
		Opportunity oppSimpleYasugo = new Opportunity(
			Name = 'テスト商談', 
			AccountId = soudansha.Id, 
			TaishosyaRef__c = taisyousya.Id, 
			RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo'),
			TorihikiShodanRef__c=opp.id,
			StageName = 'フォロー',
			CloseDate = system.today(), 
			TaishoushaJokyo__c = '_',
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

          Insert new TriggerIsActive__c( name='default', isActive__c=true );
          
          Test.startTest();

          SogSok_MitsumoriSho__c sogsok_mitsumorisho = new SogSok_MitsumoriSho__c();
          sogsok_mitsumorisho.moshu_addr_city__c = '横浜市青葉区';   // Moshu_Addr_City
		sogsok_mitsumorisho.soukyakusaki_tantosha_tel__c = '080-1234-5678';   // SoukyakuSaki_Tantosha_Tel
		sogsok_mitsumorisho.sogi_tsuyadatetime__c = Datetime.newInstance(2018, 08, 28, 15, 00, 00);   // Sogi_TsuyaDateTime
		sogsok_mitsumorisho.shiharai_loankingaku__c = 0.0;   // Shiharai_LoanKingaku
		sogsok_mitsumorisho.moshu_gender__c = '男性';   // Moshu_Gender
		sogsok_mitsumorisho.soukyakusaki_torihikisakiname__c = 'テスト梅崎葬儀社';   // SoukyakuSaki_TorihikiSakiName
		sogsok_mitsumorisho.sogiplan_amount__c = 298000.0;   // SogiPlan_Amount
		sogsok_mitsumorisho.moshu_mobile__c = '0123-456-7890';   // Moshu_Mobile
		sogsok_mitsumorisho.soukyakusaki_torihikisakibango__c = 'ACNT-0412384';   // Soukyakusaki_TorihikisakiBango
		sogsok_mitsumorisho.shiharaisha_addr_city__c = '品川区';   // ShiharaiSha_Addr_City
		sogsok_mitsumorisho.shiharaisha_addr_postalcode__c = '1410031';   // ShiharaiSha_Addr_PostalCode
		sogsok_mitsumorisho.taishosha_shuha__c = 'sonota';   // TaishoSha_Shuha
		// sogsok_seikyusho0.taishosha_zokugarafrommoshu__c = '';    // TaishoSha_ZokugaraFromMoshu
		sogsok_mitsumorisho.taishosha_torihikisakibango__c = 'ACNT-0404620';   // TaishoSha_TorihikiSakiBango
		sogsok_mitsumorisho.sogi_shikijo_name__c = '梅﨑斎場';   // Sogi_Shikijo_Name
		sogsok_mitsumorisho.shiharaisha_addr_street__c = '西五反田１１１';   // ShiharaiSha_Addr_Street
		sogsok_mitsumorisho.taishosha_sei__c = 'テスト対象者';   // TaishoSha_Sei
		sogsok_mitsumorisho.taishosha_age__c = 38.0;   // TaishoSha_Age
		sogsok_mitsumorisho.sogiplan_planname__c = 'よりそうのお葬式　一日葬　仏式プラン';   // SogiPlan_PlanName
		sogsok_mitsumorisho.taishosha_addr_city__c = '横浜市青葉区';   // TaishoSha_Addr_City
		sogsok_mitsumorisho.taishosha_deathdate__c = Date.newInstance(2018, 08, 13);   // TaishoSha_DeathDate
		sogsok_mitsumorisho.moshu_mei__c = '手巣都';   // Moshu_Mei
		sogsok_mitsumorisho.taishosha_birthdate__c = Date.newInstance(1980, 08, 01);   // TaishoSha_BirthDate
		sogsok_mitsumorisho.kinyudate__c = Date.newInstance(2018, 08, 29);   // KinyuDate
		sogsok_mitsumorisho.taishosha_jumhyo_street__c = '西五反田１１１';   // TaishoSha_JumHyo_Street
		sogsok_mitsumorisho.taishosha_addr_state__c = '神奈川県';   // TaishoSha_Addr_State
		sogsok_mitsumorisho.soryotehai_kaimyo__c = '釋';   // SoryoTehai_Kaimyo
		sogsok_mitsumorisho.moshu_sei__c = '寄僧';   // Moshu_Sei
		sogsok_mitsumorisho.shiharai_maeukekingaku__c = 0.0;   // Shiharai_MaeukeKingaku
		sogsok_mitsumorisho.shodanbango__c = '0423182';   // ShodanBango
		sogsok_mitsumorisho.shiharaisha_mail__c = 'testtestt@yorisottesetsetsetet.com';   // ShiharaiSha_Mail
		sogsok_mitsumorisho.shiharaisha_addr_state__c = '東京都';   // ShiharaiSha_Addr_State
		sogsok_mitsumorisho.moshu_addr_state__c = '神奈川県';   // Moshu_Addr_State
		sogsok_mitsumorisho.moshu_seikana__c = 'ヨリソウ';   // Moshu_SeiKana
		sogsok_mitsumorisho.sogiplan_shohinbango__c = 'SBG-0005006';   // SogiPlan_ShohinBango
		sogsok_mitsumorisho.sogi_kokubetsudatetime__c = Datetime.newInstance(2018, 08, 29, 15, 00, 00);   // Sogi_KokubetsuDateTime
		sogsok_mitsumorisho.moshu_addr_street__c = '藤が丘２－１';   // Moshu_Addr_Street
		sogsok_mitsumorisho.moshu_addr_postalcode__c = '2270000';   // Moshu_Addr_PostalCode
		sogsok_mitsumorisho.taishosha_shuha_sonota__c = '高野山真言宗 その他宗派備考';   // TaishoSha_Shuha_Sonota
		sogsok_mitsumorisho.taishosha_jumhyo_postalcode__c = '1410031';   // TaishoSha_JumHyo_PostalCode
		sogsok_mitsumorisho.taishosha_jumhyo_state__c = '東京都';   // TaishoSha_JumHyo_State
		sogsok_mitsumorisho.taishosha_meikana__c = 'テストタイショウシャ';   // TaishoSha_MeiKana
		sogsok_mitsumorisho.sodansha_mei__c = '手巣都';   // SodanSha_Mei
		sogsok_mitsumorisho.sokyakubango__c = sokyaku.name;   // SokyakuBango
		sogsok_mitsumorisho.moshu_meikana__c = 'テスト';   // Moshu_MeiKana
		sogsok_mitsumorisho.sogi_shukkandatetime__c = Datetime.newInstance(2018, 08, 28, 15, 00, 00);   // Sogi_ShukkanDateTime
		sogsok_mitsumorisho.taishosha_addr_street__c = '藤が丘２－１';   // TaishoSha_Addr_Street
		sogsok_mitsumorisho.sogi_kasodatetime__c = Datetime.newInstance(2018, 08, 29, 15, 00, 00);   // Sogi_KasoDateTime
		sogsok_mitsumorisho.Sign_Url__c = 'https://127.0.0.1.jp/api/file/9';   // Sign_Url
		sogsok_mitsumorisho.taishosha_bodaiji_umu__c = '有';   // TaishoSha_Bodaiji_Umu
		sogsok_mitsumorisho.soryotehai__c = '未定';   // SoryoTehai_KiboUmu
		sogsok_mitsumorisho.taishosha_seikana__c = 'テストタイショウシャ';   // TaishoSha_SeiKana
		sogsok_mitsumorisho.sodansha_sei__c = '寄僧';   // SodanSha_Sei
		sogsok_mitsumorisho.taishosha_mei__c = 'テスト２０１８０３１６０１';   // TaishoSha_Mei
		sogsok_mitsumorisho.sogi_kasoba_name__c = '梅﨑火葬場';   // Sogi_Kasoba_Name
		sogsok_mitsumorisho.taishosha_addr_postalcode__c = '2270043';   // Taishosha_Addr_PostalCode
		sogsok_mitsumorisho.taishosha_gender__c = '女性';   // TaishoSha_Gender
		sogsok_mitsumorisho.docstatus__c = 'Created';   // DocStatus
		sogsok_mitsumorisho.moshu_birthdate__c = Date.newInstance(2018, 08, 08);   // Moshu_BirthDate
		sogsok_mitsumorisho.shiharai_creditkingaku__c = 298000.0;   // Shiharai_CreditKingaku
		sogsok_mitsumorisho.moshu_phone__c = '0123-456-7890';   // Moshu_Phone
		sogsok_mitsumorisho.shiharai_genkinkingaku__c = 0.0;   // Shiharai_GenkinKingaku
		sogsok_mitsumorisho.taishosha_jumhyo_city__c = '品川区';   // TaishoSha_JumHyo_City
		sogsok_mitsumorisho.moshu_torihikisakibango__c = 'ACNT-0310878';   // Moshu_TorihikiSakiBango
		sogsok_mitsumorisho.sodansha_torihikisakibango__c = 'ACNT-0310878';   // SodanSha_TorihikiSakiBango
		sogsok_mitsumorisho.moshu_zokugarafromsoudansha__c = 'otto';   // Moshu_ZokugaraFromSoudanSha
		sogsok_mitsumorisho.soukyakusaki_tantosha_name__c = '梅﨑 テスト';   // SoukyakuSaki_Tantosha_Name
		sogsok_mitsumorisho.shiharaisha_name__c = 'いしい　てすと';   // ShiharaiSha_Name
		sogsok_mitsumorisho.shiharaisha_ryosyuatena__c = 'いしい　てすと';   // ShiharaiSha_RyosyuAtena
          insert sogsok_mitsumorisho;
          
          SogSok_Mitsumorisho_WaribikiLine__c sogsok_mitsumorisho_waribikiline0 = new SogSok_Mitsumorisho_WaribikiLine__c();
		sogsok_mitsumorisho_waribikiline0.MitsumoriShoRef__c = sogsok_mitsumorisho.Id;   // SogSok_SeikyuShoRef
		sogsok_mitsumorisho_waribikiline0.amount__c = -2000.0;   // Amount
		sogsok_mitsumorisho_waribikiline0.unitprice__c = -2000.0;   // UnitPrice
		sogsok_mitsumorisho_waribikiline0.quantity__c = 1.0;   // Quantity
		sogsok_mitsumorisho_waribikiline0.hinmei__c = '特別割引';   // Hinmei
		sogsok_mitsumorisho_waribikiline0.shohinbango__c = 'SBG-0005101';   // ShohinBango
		insert sogsok_mitsumorisho_waribikiline0;


		List<SogSok_Mitsumorisho_TsuikaHinLine__c> sogsok_seikyusho_tsuikahinlineList = new List<SogSok_Mitsumorisho_TsuikaHinLine__c>();
		SogSok_Mitsumorisho_TsuikaHinLine__c sogsok_mitsumorisho_tsuikahinline0 = new SogSok_Mitsumorisho_TsuikaHinLine__c();
		sogsok_mitsumorisho_tsuikahinline0.MitsumoriShoRef__c = sogsok_mitsumorisho.Id;   // SogSok_SeikyuShoRef
		sogsok_mitsumorisho_tsuikahinline0.hinmokubunrui__c = '料理';   // HinmokuBunrui
		sogsok_mitsumorisho_tsuikahinline0.unitprice__c = 10000.0;   // UnitPrice
		sogsok_mitsumorisho_tsuikahinline0.amount__c = 30000.0;   // Amount
		sogsok_mitsumorisho_tsuikahinline0.hinmei__c = '料理';   // Hinmei
		sogsok_mitsumorisho_tsuikahinline0.quantity__c = 3.0;   // Quantity
		sogsok_mitsumorisho_tsuikahinline0.shohinbango__c = 'SBG-0005501';
		sogsok_seikyusho_tsuikahinlineList.add(sogsok_mitsumorisho_tsuikahinline0);
		upsert sogsok_seikyusho_tsuikahinlineList;
          
          sogsok_mitsumorisho.docstatus__c = 'activated';   // DocStatus
		update sogsok_mitsumorisho;

        Test.getEventBus().deliver();
        Test.stopTest();

	}
	
}