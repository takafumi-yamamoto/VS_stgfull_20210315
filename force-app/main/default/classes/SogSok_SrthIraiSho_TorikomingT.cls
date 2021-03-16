@isTest
private class SogSok_SrthIraiSho_TorikomingT {
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
			),
            '葬儀社' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Sogisya'),
                Name = '_'
            )
		};
		INSERT theAccounts.values();

		Map<String, Keiyaku__c> theKeiyakus = new Map<String, Keiyaku__c>{
			'シンプル安豪' => new Keiyaku__c(
				RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Keiyaku__c','SimpleYasugo'),
				Teikeisaki__c = theAccounts.get('葬儀社').Id
			)
		};
		INSERT theKeiyakus.values();

		Map<String, SimpleYasugo__c> theSimpleYasugos = new Map<String, SimpleYasugo__c>{
			'シンプル安豪' => new SimpleYasugo__c(
                SimpleYasugoKeiyakuRef__c = theKeiyakus.get('シンプル安豪').Id,
                TaiouKanouRiyu__c = '対応可能（斎場優先）',
                MoshuRef__c = theAccounts.get('喪主').Id
            )
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

        Map<String, SogSok_SrthIraiSho_Torik__c> theToriks = new Map<String, SogSok_SrthIraiSho_Torik__c>{
            '取込シート' => new SogSok_SrthIraiSho_Torik__c(
                status__c = '未取込', syop_Ref__c = theOpps.get('シンプル安豪').Id, 
                obop_SoudanshaRef__c = theAccounts.get('Customer').Id, obop_TaishoShaRef__c = theAccounts.get('Customer').Id,
                obop_Moshu_Sei__c = '変更', 
                obop_Moshu_SeiKana__c = 'モシュ', obop_Moshu_MeiKana__c = 'モシュ', obop_Moshu_Mobile__c = '080',
                obop_SougishaRef__c = theAccounts.get('葬儀社').Id
            )
          };
        INSERT theToriks.values();
        endSetUp();

        Test.startTest();
        UPDATE new SogSok_SrthIraiSho_Torik__c(Id = theToriks.get('取込シート').Id, status__c = '取込');
        Test.stopTest();
     }

	@isTest static void test_SogSok_SrthIraiSho_Torikoming() {
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

		SogSok_SrthIraiSho__c sogsok_srthIraisho = new SogSok_SrthIraiSho__c();
		insert sogsok_srthIraisho;

		sokyaku.SrthIraiShoRef__c = sogsok_srthIraisho.Id;
		update sokyaku;

		List<SogSok_SrthIraiSho_Torik__c> sogsok_srthiraisho_torikList = new List<SogSok_SrthIraiSho_Torik__c>();
		SogSok_SrthIraiSho_Torik__c sogsok_srthiraisho_torik0 = new SogSok_SrthIraiSho_Torik__c();
		sogsok_srthiraisho_torik0.syop_ref__c = oppSimpleYasugo.Id;
		sogsok_srthiraisho_torik0.SogSok_SrthIraiShoRef__c = sogsok_srthIraisho.Id;
		sogsok_srthiraisho_torik0.obop_soudansharef__c = soudansha.id;
		sogsok_srthiraisho_torik0.obop_soudansha_sei__c = '相談者20180718';
		sogsok_srthiraisho_torik0.obop_soudansha_mei__c = '相談者名';
		sogsok_srthiraisho_torik0.obop_taishosharef__c = taisyousya.Id;
		sogsok_srthiraisho_torik0.obop_taishosha_sei__c = '対象者姓';
		sogsok_srthiraisho_torik0.obop_taishosha_mei__c = '対象者名0817';
		sogsok_srthiraisho_torik0.obop_taishosha_birthdate__c = Date.newInstance(1908, 08, 18);
		sogsok_srthiraisho_torik0.obop_taishosha_deathdate__c = Date.newInstance(2018, 08, 16);
		sogsok_srthiraisho_torik0.obop_taishosha_age__c = 100.0;
		sogsok_srthiraisho_torik0.obop_taishosha_shuha_sonotashuha__c = '真言宗';
		sogsok_srthiraisho_torik0.obop_moshuref__c = moshu.Id;
		sogsok_srthiraisho_torik0.obop_moshu_sei__c = '喪主姓';
		sogsok_srthiraisho_torik0.obop_moshu_mei__c = '喪主太郎20180817';
		sogsok_srthiraisho_torik0.obop_moshu_seikana__c = 'セイ';
		sogsok_srthiraisho_torik0.obop_moshu_meikana__c = 'メイ';
		sogsok_srthiraisho_torik0.obop_moshu_phone__c = '080-0000-0002';
		sogsok_srthiraisho_torik0.obop_moshu_mobile__c = '080-0000-0001';
		sogsok_srthiraisho_torik0.obop_moshu_addr_postalcode__c = '141-0031';
		sogsok_srthiraisho_torik0.obop_moshu_addr_state__c = '東京都';
		sogsok_srthiraisho_torik0.obop_moshu_addr_city__c = '品川区';
		sogsok_srthiraisho_torik0.obop_moshu_addr_street__c = '西五反田';
		sogsok_srthiraisho_torik0.obop_sougisharef__c = sougisya.Id;
		sogsok_srthiraisho_torik0.obop_sogitantoname__c = '担当者A';
		sogsok_srthiraisho_torik0.obop_sogitantotel__c = '05-0001-0001';
		sogsok_srthiraisho_torik0.obop_sogitantofax__c = '05-0001-0002';
		sogsok_srthiraisho_torik0.obop_tsuyadatetime__c = Datetime.newInstance(2018, 08, 17, 03, 00, 00);
		sogsok_srthiraisho_torik0.obop_kokubetsudatetime__c = Datetime.newInstance(2018, 08, 18, 03, 00, 00);
		sogsok_srthiraisho_torik0.obop_kasodatetime__c = Datetime.newInstance(2018, 08, 20, 03, 00, 00);
		sogsok_srthiraisho_torik0.obop_saijoname__c = '五反田斎場';
		sogsok_srthiraisho_torik0.obop_saijoaddress__c = '五反田1-1-1';
		sogsok_srthiraisho_torik0.obop_saijophone__c = '05-0000-0000';
		sogsok_srthiraisho_torik0.obop_kasobaname__c = '火葬場五反田';
		sogsok_srthiraisho_torik0.obop_kaimyokiboumu__c = '戒名の授与を希望する';
		sogsok_srthiraisho_torik0.obop_renrakujiko__c = '重要連絡事項、これはテストです。無視してください。';
		sogsok_srthiraisho_torik0.obop_ryunyumotoservice__c = '格安の墓石';
		sogsok_srthiraisho_torik0.status__c = '未取込';
		sogsok_srthiraisho_torik0.obop_obouplan__c = '戒名・法名のみ';
		sogsok_srthiraisho_torik0.obop_kaimyo__c = '信女';
		sogsok_srthiraisho_torik0.obop_taishosha_shuha__c = '浄土真宗本願寺派';
		sogsok_srthiraisho_torik0.obop_taishosha_bodaiji_umu__c = '無';
		sogsok_srthiraisho_torik0.obop_taishoshazokugarafrommoshu__c = '妻';
		sogsok_srthiraisho_torik0.obop_shonanoka__c = '式中';
		sogsok_srthiraisho_torikList.add(sogsok_srthiraisho_torik0);
		
		insert sogsok_srthiraisho_torikList;
		

		Test.startTest();	
		sogsok_srthiraisho_torik0.status__c = '取込';
		update sogsok_srthiraisho_torik0;
		Test.stopTest();
	}
	
}