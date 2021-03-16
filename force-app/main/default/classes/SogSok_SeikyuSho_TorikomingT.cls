@isTest
private class SogSok_SeikyuSho_TorikomingT {
	
	@isTest static void test_method_one() {
		Insert new TriggerIsActive__c( name='default', isActive__c=true );

		try{

			SogSok_SeikyuSho_Torik__c sogsok_seikyusho_torik0 = new SogSok_SeikyuSho_Torik__c();
			// sogsok_seikyusho_torik0.seikyushoref__c = 'a2L0k0000001uDnEAI';   // SeikyuShoRef
			// sogsok_seikyusho_torik0.syop_ref__c = '0060k000006n7OKAAY';   // syop_Ref
			sogsok_seikyusho_torik0.status__c = '未取込';   // Status
			sogsok_seikyusho_torik0.syop_tsuyadatetime__c = Datetime.newInstance(2018, 09, 01, 05, 30, 00);   // syop_TsuyaDateTime
			sogsok_seikyusho_torik0.syop_kokubetsudatetime__c = Datetime.newInstance(2018, 09, 01, 06, 30, 00);   // syop_KokubetsuDateTime
			sogsok_seikyusho_torik0.syop_shukkandatetime__c = Datetime.newInstance(2018, 09, 01, 07, 30, 00);   // syop_ShukkanDateTime
			sogsok_seikyusho_torik0.syop_kasodatetime__c = Datetime.newInstance(2018, 09, 01, 08, 30, 00);   // syop_KasoDateTime
			sogsok_seikyusho_torik0.syop_genkinkingaku__c = 278000.0;   // syop_GenkinKingaku
			sogsok_seikyusho_torik0.syop_seikyusshojuryodate__c = Date.newInstance(2018, 08, 31);   // syop_SeikyusShoJuryoDate
			insert sogsok_seikyusho_torik0;

			sogsok_seikyusho_torik0.status__c = '取込';
			update sogsok_seikyusho_torik0;
		} catch(Exception ex){
			System.debug(ex);
		}


	}
	
	@isTest static void test_SogSok_SeikyuSho() {
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
        //	SimpleYasugoKeiyakuRef__c = keiyaku.Id
        //	);
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
        insert oliList;

		SogSok_Sokyaku__c sokyaku = new SogSok_Sokyaku__c(OpportunityRef__c=oppSimpleYasugo.Id);
		insert sokyaku;
		sokyaku = [select id, name from SogSok_Sokyaku__c where id =:sokyaku.Id];

		Insert new TriggerIsActive__c( name='default', isActive__c=true );
        Test.startTest();
		SogSok_SeikyuSho__c sogSok_SeikyuSho0 = new SogSok_SeikyuSho__c();

		// sogsok_seikyusho0.soukyakusaki_tantosha_fax__c = '';    // SoukyakuSaki_Tantosha_Fax
		sogsok_seikyusho0.moshu_addr_city__c = '横浜市青葉区';   // Moshu_Addr_City
		sogsok_seikyusho0.soukyakusaki_tantosha_tel__c = '080-1234-5678';   // SoukyakuSaki_Tantosha_Tel
		sogsok_seikyusho0.sogi_tsuyadatetime__c = Datetime.newInstance(2018, 08, 28, 15, 00, 00);   // Sogi_TsuyaDateTime
		sogsok_seikyusho0.shiharai_loankingaku__c = 0.0;   // Shiharai_LoanKingaku
		sogsok_seikyusho0.moshu_gender__c = '男性';   // Moshu_Gender
		sogsok_seikyusho0.soukyakusaki_torihikisakiname__c = 'テスト梅崎葬儀社';   // SoukyakuSaki_TorihikiSakiName
		sogsok_seikyusho0.sogiplan_amount__c = 298000.0;   // SogiPlan_Amount
		sogsok_seikyusho0.moshu_mobile__c = '0123-456-7890';   // Moshu_Mobile
		sogsok_seikyusho0.soukyakusaki_torihikisakibango__c = 'ACNT-0412384';   // Soukyakusaki_TorihikisakiBango
		sogsok_seikyusho0.shiharaisha_addr_city__c = '品川区';   // ShiharaiSha_Addr_City
		sogsok_seikyusho0.shiharaisha_addr_postalcode__c = '1410031';   // ShiharaiSha_Addr_PostalCode
		sogsok_seikyusho0.taishosha_shuha__c = 'sonota';   // TaishoSha_Shuha
		// sogsok_seikyusho0.taishosha_zokugarafrommoshu__c = '';    // TaishoSha_ZokugaraFromMoshu
		sogsok_seikyusho0.taishosha_torihikisakibango__c = 'ACNT-0404620';   // TaishoSha_TorihikiSakiBango
		sogsok_seikyusho0.sogi_shikijo_name__c = '梅﨑斎場';   // Sogi_Shikijo_Name
		sogsok_seikyusho0.shiharaisha_addr_street__c = '西五反田１１１';   // ShiharaiSha_Addr_Street
		sogsok_seikyusho0.taishosha_sei__c = 'テスト対象者';   // TaishoSha_Sei
		sogsok_seikyusho0.taishosha_age__c = 38.0;   // TaishoSha_Age
		sogsok_seikyusho0.sogiplan_planname__c = 'よりそうのお葬式　一日葬　仏式プラン';   // SogiPlan_PlanName
		sogsok_seikyusho0.taishosha_addr_city__c = '横浜市青葉区';   // TaishoSha_Addr_City
		sogsok_seikyusho0.taishosha_deathdate__c = Date.newInstance(2018, 08, 13);   // TaishoSha_DeathDate
		sogsok_seikyusho0.moshu_mei__c = '手巣都';   // Moshu_Mei
		sogsok_seikyusho0.taishosha_birthdate__c = Date.newInstance(1980, 08, 01);   // TaishoSha_BirthDate
		sogsok_seikyusho0.kinyudate__c = Date.newInstance(2018, 08, 29);   // KinyuDate
		sogsok_seikyusho0.taishosha_jumhyo_street__c = '西五反田１１１';   // TaishoSha_JumHyo_Street
		sogsok_seikyusho0.taishosha_addr_state__c = '神奈川県';   // TaishoSha_Addr_State
		sogsok_seikyusho0.soryotehai_kaimyo__c = '釋';   // SoryoTehai_Kaimyo
		sogsok_seikyusho0.moshu_sei__c = '寄僧';   // Moshu_Sei
		sogsok_seikyusho0.shiharai_maeukekingaku__c = 0.0;   // Shiharai_MaeukeKingaku
		sogsok_seikyusho0.shodanbango__c = '0423182';   // ShodanBango
		sogsok_seikyusho0.shiharaisha_mail__c = 'testtestt@yorisottesetsetsetet.com';   // ShiharaiSha_Mail
		sogsok_seikyusho0.shiharaisha_addr_state__c = '東京都';   // ShiharaiSha_Addr_State
		sogsok_seikyusho0.moshu_addr_state__c = '神奈川県';   // Moshu_Addr_State
		sogsok_seikyusho0.moshu_seikana__c = 'ヨリソウ';   // Moshu_SeiKana
		sogsok_seikyusho0.sogiplan_shohinbango__c = 'SBG-0005006';   // SogiPlan_ShohinBango
		sogsok_seikyusho0.sogi_kokubetsudatetime__c = Datetime.newInstance(2018, 08, 29, 15, 00, 00);   // Sogi_KokubetsuDateTime
		sogsok_seikyusho0.moshu_addr_street__c = '藤が丘２－１';   // Moshu_Addr_Street
		sogsok_seikyusho0.moshu_addr_postalcode__c = '2270000';   // Moshu_Addr_PostalCode
		sogsok_seikyusho0.taishosha_shuha_sonota__c = '高野山真言宗 その他宗派備考';   // TaishoSha_Shuha_Sonota
		sogsok_seikyusho0.taishosha_jumhyo_postalcode__c = '1410031';   // TaishoSha_JumHyo_PostalCode
		sogsok_seikyusho0.taishosha_jumhyo_state__c = '東京都';   // TaishoSha_JumHyo_State
		sogsok_seikyusho0.taishosha_meikana__c = 'テストタイショウシャ';   // TaishoSha_MeiKana
		sogsok_seikyusho0.sodansha_mei__c = '手巣都';   // SodanSha_Mei
		sogsok_seikyusho0.sokyakubango__c = sokyaku.name;   // SokyakuBango
		sogsok_seikyusho0.moshu_meikana__c = 'テスト';   // Moshu_MeiKana
		sogsok_seikyusho0.sogi_shukkandatetime__c = Datetime.newInstance(2018, 08, 28, 15, 00, 00);   // Sogi_ShukkanDateTime
		sogsok_seikyusho0.taishosha_addr_street__c = '藤が丘２－１';   // TaishoSha_Addr_Street
		sogsok_seikyusho0.sogi_kasodatetime__c = Datetime.newInstance(2018, 08, 29, 15, 00, 00);   // Sogi_KasoDateTime
		sogsok_seikyusho0.Sign_Url__c = 'https://127.0.0.1.jp/api/file/9';   // Sign_Url
		sogsok_seikyusho0.taishosha_bodaiji_umu__c = '有';   // TaishoSha_Bodaiji_Umu
		sogsok_seikyusho0.soryotehai__c = '未定';   // SoryoTehai_KiboUmu
		sogsok_seikyusho0.taishosha_seikana__c = 'テストタイショウシャ';   // TaishoSha_SeiKana
		sogsok_seikyusho0.sodansha_sei__c = '寄僧';   // SodanSha_Sei
		sogsok_seikyusho0.taishosha_mei__c = 'テスト２０１８０３１６０１';   // TaishoSha_Mei
		sogsok_seikyusho0.sogi_kasoba_name__c = '梅﨑火葬場';   // Sogi_Kasoba_Name
		sogsok_seikyusho0.taishosha_addr_postalcode__c = '2270043';   // Taishosha_Addr_PostalCode
		sogsok_seikyusho0.taishosha_gender__c = '女性';   // TaishoSha_Gender
		sogsok_seikyusho0.docstatus__c = 'Created';   // DocStatus
		sogsok_seikyusho0.moshu_birthdate__c = Date.newInstance(2018, 08, 08);   // Moshu_BirthDate
		sogsok_seikyusho0.shiharai_creditkingaku__c = 298000.0;   // Shiharai_CreditKingaku
		sogsok_seikyusho0.moshu_phone__c = '0123-456-7890';   // Moshu_Phone
		sogsok_seikyusho0.shiharai_genkinkingaku__c = 0.0;   // Shiharai_GenkinKingaku
		sogsok_seikyusho0.taishosha_jumhyo_city__c = '品川区';   // TaishoSha_JumHyo_City
		sogsok_seikyusho0.moshu_torihikisakibango__c = 'ACNT-0310878';   // Moshu_TorihikiSakiBango
		sogsok_seikyusho0.sodansha_torihikisakibango__c = 'ACNT-0310878';   // SodanSha_TorihikiSakiBango
		sogsok_seikyusho0.moshu_zokugarafromsoudansha__c = 'otto';   // Moshu_ZokugaraFromSoudanSha
		sogsok_seikyusho0.soukyakusaki_tantosha_name__c = '梅﨑 テスト';   // SoukyakuSaki_Tantosha_Name
		sogsok_seikyusho0.shiharaisha_name__c = 'いしい　てすと';   // ShiharaiSha_Name
		sogsok_seikyusho0.shiharaisha_ryosyuatena__c = 'いしい　てすと';   // ShiharaiSha_RyosyuAtena
		insert sogsok_seikyusho0;

		SogSok_Seikyusho_WaribikiLine__c sogsok_seikyusho_waribikiline0 = new SogSok_Seikyusho_WaribikiLine__c();
		sogsok_seikyusho_waribikiline0.sogsok_seikyushoref__c = sogsok_seikyusho0.Id;   // SogSok_SeikyuShoRef
		sogsok_seikyusho_waribikiline0.amount__c = -2000.0;   // Amount
		sogsok_seikyusho_waribikiline0.unitprice__c = -2000.0;   // UnitPrice
		sogsok_seikyusho_waribikiline0.quantity__c = 1.0;   // Quantity
		sogsok_seikyusho_waribikiline0.hinmei__c = '特別割引';   // Hinmei
		sogsok_seikyusho_waribikiline0.shohinbango__c = 'SBG-0005101';   // ShohinBango
		insert sogsok_seikyusho_waribikiline0;


		List<SogSok_Seikyusho_TsuikaHinLine__c> sogsok_seikyusho_tsuikahinlineList = new List<SogSok_Seikyusho_TsuikaHinLine__c>();
		SogSok_Seikyusho_TsuikaHinLine__c sogsok_seikyusho_tsuikahinline0 = new SogSok_Seikyusho_TsuikaHinLine__c();
		sogsok_seikyusho_tsuikahinline0.sogsok_seikyushoref__c = sogsok_seikyusho0.Id;   // SogSok_SeikyuShoRef
		sogsok_seikyusho_tsuikahinline0.hinmokubunrui__c = '料理';   // HinmokuBunrui
		sogsok_seikyusho_tsuikahinline0.unitprice__c = 10000.0;   // UnitPrice
		sogsok_seikyusho_tsuikahinline0.amount__c = 30000.0;   // Amount
		sogsok_seikyusho_tsuikahinline0.hinmei__c = '料理';   // Hinmei
		sogsok_seikyusho_tsuikahinline0.quantity__c = 3.0;   // Quantity
		sogsok_seikyusho_tsuikahinline0.shohinbango__c = 'SBG-0005501';
		sogsok_seikyusho_tsuikahinlineList.add(sogsok_seikyusho_tsuikahinline0);
		upsert sogsok_seikyusho_tsuikahinlineList;



		sogsok_seikyusho0.docstatus__c = 'activated';   // DocStatus
		update sogsok_seikyusho0;

        Test.getEventBus().deliver();
        Test.stopTest();
	}
	
	
	@isTest static void test_SogSok_SeikyuSho_Exception() {
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
             ShohinBango__c = 'SBG-0000004',   
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
        //	SimpleYasugoKeiyakuRef__c = keiyaku.Id
        //	);
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
        insert oliList;

		SogSok_Sokyaku__c sokyaku = new SogSok_Sokyaku__c(OpportunityRef__c=oppSimpleYasugo.Id);
		insert sokyaku;
		sokyaku = [select id, name from SogSok_Sokyaku__c where id =:sokyaku.Id];

		Insert new TriggerIsActive__c( name='default', isActive__c=true );
        Test.startTest();
		SogSok_SeikyuSho__c sogSok_SeikyuSho0 = new SogSok_SeikyuSho__c();

		// sogsok_seikyusho0.soukyakusaki_tantosha_fax__c = '';    // SoukyakuSaki_Tantosha_Fax
		sogsok_seikyusho0.moshu_addr_city__c = '横浜市青葉区';   // Moshu_Addr_City
		sogsok_seikyusho0.soukyakusaki_tantosha_tel__c = '080-1234-5678';   // SoukyakuSaki_Tantosha_Tel
		sogsok_seikyusho0.sogi_tsuyadatetime__c = Datetime.newInstance(2018, 08, 28, 15, 00, 00);   // Sogi_TsuyaDateTime
		sogsok_seikyusho0.shiharai_loankingaku__c = 0.0;   // Shiharai_LoanKingaku
		sogsok_seikyusho0.moshu_gender__c = '男性';   // Moshu_Gender
		sogsok_seikyusho0.soukyakusaki_torihikisakiname__c = 'テスト梅崎葬儀社';   // SoukyakuSaki_TorihikiSakiName
		sogsok_seikyusho0.sogiplan_amount__c = 298000.0;   // SogiPlan_Amount
		sogsok_seikyusho0.moshu_mobile__c = '0123-456-7890';   // Moshu_Mobile
		sogsok_seikyusho0.soukyakusaki_torihikisakibango__c = 'ACNT-0412384';   // Soukyakusaki_TorihikisakiBango
		sogsok_seikyusho0.shiharaisha_addr_city__c = '品川区';   // ShiharaiSha_Addr_City
		sogsok_seikyusho0.shiharaisha_addr_postalcode__c = '1410031';   // ShiharaiSha_Addr_PostalCode
		sogsok_seikyusho0.taishosha_shuha__c = 'sonota';   // TaishoSha_Shuha
		// sogsok_seikyusho0.taishosha_zokugarafrommoshu__c = '';    // TaishoSha_ZokugaraFromMoshu
		sogsok_seikyusho0.taishosha_torihikisakibango__c = 'ACNT-0404620';   // TaishoSha_TorihikiSakiBango
		sogsok_seikyusho0.sogi_shikijo_name__c = '梅﨑斎場';   // Sogi_Shikijo_Name
		sogsok_seikyusho0.shiharaisha_addr_street__c = '西五反田１１１';   // ShiharaiSha_Addr_Street
		sogsok_seikyusho0.taishosha_sei__c = 'テスト対象者';   // TaishoSha_Sei
		sogsok_seikyusho0.taishosha_age__c = 38.0;   // TaishoSha_Age
		sogsok_seikyusho0.sogiplan_planname__c = 'よりそうのお葬式　一日葬　仏式プラン';   // SogiPlan_PlanName
		sogsok_seikyusho0.taishosha_addr_city__c = '横浜市青葉区';   // TaishoSha_Addr_City
		sogsok_seikyusho0.taishosha_deathdate__c = Date.newInstance(2018, 08, 13);   // TaishoSha_DeathDate
		sogsok_seikyusho0.moshu_mei__c = '手巣都';   // Moshu_Mei
		sogsok_seikyusho0.taishosha_birthdate__c = Date.newInstance(1980, 08, 01);   // TaishoSha_BirthDate
		sogsok_seikyusho0.kinyudate__c = Date.newInstance(2018, 08, 29);   // KinyuDate
		sogsok_seikyusho0.taishosha_jumhyo_street__c = '西五反田１１１';   // TaishoSha_JumHyo_Street
		sogsok_seikyusho0.taishosha_addr_state__c = '神奈川県';   // TaishoSha_Addr_State
		sogsok_seikyusho0.soryotehai_kaimyo__c = '釋';   // SoryoTehai_Kaimyo
		sogsok_seikyusho0.moshu_sei__c = '寄僧';   // Moshu_Sei
		sogsok_seikyusho0.shiharai_maeukekingaku__c = 0.0;   // Shiharai_MaeukeKingaku
		sogsok_seikyusho0.shodanbango__c = '0423182';   // ShodanBango
		sogsok_seikyusho0.shiharaisha_mail__c = 'testtestt@yorisottesetsetsetet.com';   // ShiharaiSha_Mail
		sogsok_seikyusho0.shiharaisha_addr_state__c = '東京都';   // ShiharaiSha_Addr_State
		sogsok_seikyusho0.moshu_addr_state__c = '神奈川県';   // Moshu_Addr_State
		sogsok_seikyusho0.moshu_seikana__c = 'ヨリソウ';   // Moshu_SeiKana
		sogsok_seikyusho0.sogiplan_shohinbango__c = 'SBG-000000XXX';   // SogiPlan_ShohinBango
		sogsok_seikyusho0.sogi_kokubetsudatetime__c = Datetime.newInstance(2018, 08, 29, 15, 00, 00);   // Sogi_KokubetsuDateTime
		sogsok_seikyusho0.moshu_addr_street__c = '藤が丘２－１';   // Moshu_Addr_Street
		sogsok_seikyusho0.moshu_addr_postalcode__c = '2270000';   // Moshu_Addr_PostalCode
		sogsok_seikyusho0.taishosha_shuha_sonota__c = '高野山真言宗 その他宗派備考';   // TaishoSha_Shuha_Sonota
		sogsok_seikyusho0.taishosha_jumhyo_postalcode__c = '1410031';   // TaishoSha_JumHyo_PostalCode
		sogsok_seikyusho0.taishosha_jumhyo_state__c = '東京都';   // TaishoSha_JumHyo_State
		sogsok_seikyusho0.taishosha_meikana__c = 'テストタイショウシャ';   // TaishoSha_MeiKana
		sogsok_seikyusho0.sodansha_mei__c = '手巣都';   // SodanSha_Mei
		sogsok_seikyusho0.sokyakubango__c = sokyaku.name;   // SokyakuBango
		sogsok_seikyusho0.moshu_meikana__c = 'テスト';   // Moshu_MeiKana
		sogsok_seikyusho0.sogi_shukkandatetime__c = Datetime.newInstance(2018, 08, 28, 15, 00, 00);   // Sogi_ShukkanDateTime
		sogsok_seikyusho0.taishosha_addr_street__c = '藤が丘２－１';   // TaishoSha_Addr_Street
		sogsok_seikyusho0.sogi_kasodatetime__c = Datetime.newInstance(2018, 08, 29, 15, 00, 00);   // Sogi_KasoDateTime
		sogsok_seikyusho0.Sign_Url__c = 'https://127.0.0.1.jp/api/file/9'; 
		sogsok_seikyusho0.taishosha_bodaiji_umu__c = '有';   // TaishoSha_Bodaiji_Umu
		sogsok_seikyusho0.soryotehai__c = '未定';   // SoryoTehai_KiboUmu
		sogsok_seikyusho0.taishosha_seikana__c = 'テストタイショウシャ';   // TaishoSha_SeiKana
		sogsok_seikyusho0.sodansha_sei__c = '寄僧';   // SodanSha_Sei
		sogsok_seikyusho0.taishosha_mei__c = 'テスト２０１８０３１６０１';   // TaishoSha_Mei
		sogsok_seikyusho0.sogi_kasoba_name__c = '梅﨑火葬場';   // Sogi_Kasoba_Name
		sogsok_seikyusho0.taishosha_addr_postalcode__c = '2270043';   // Taishosha_Addr_PostalCode
		sogsok_seikyusho0.taishosha_gender__c = '女性';   // TaishoSha_Gender
		sogsok_seikyusho0.docstatus__c = 'Created';   // DocStatus
		sogsok_seikyusho0.moshu_birthdate__c = Date.newInstance(2018, 08, 08);   // Moshu_BirthDate
		sogsok_seikyusho0.shiharai_creditkingaku__c = 298000.0;   // Shiharai_CreditKingaku
		sogsok_seikyusho0.moshu_phone__c = '0123-456-7890';   // Moshu_Phone
		sogsok_seikyusho0.shiharai_genkinkingaku__c = 0.0;   // Shiharai_GenkinKingaku
		sogsok_seikyusho0.taishosha_jumhyo_city__c = '品川区';   // TaishoSha_JumHyo_City
		sogsok_seikyusho0.moshu_torihikisakibango__c = 'ACNT-0310878';   // Moshu_TorihikiSakiBango
		sogsok_seikyusho0.sodansha_torihikisakibango__c = 'ACNT-0310878';   // SodanSha_TorihikiSakiBango
		sogsok_seikyusho0.moshu_zokugarafromsoudansha__c = 'otto';   // Moshu_ZokugaraFromSoudanSha
		sogsok_seikyusho0.soukyakusaki_tantosha_name__c = '梅﨑 テスト';   // SoukyakuSaki_Tantosha_Name
		sogsok_seikyusho0.shiharaisha_name__c = 'いしい　てすと';   // ShiharaiSha_Name
		sogsok_seikyusho0.shiharaisha_ryosyuatena__c = 'いしい　てすと';   // ShiharaiSha_RyosyuAtena
		insert sogsok_seikyusho0;



		sogsok_seikyusho0.docstatus__c = 'activated';   // DocStatus
		update sogsok_seikyusho0;

        Test.getEventBus().deliver();
        Test.stopTest();
	}
	
	@isTest static void test_SogSok_SeikyuSho_TorikCreTask() {
		try{
			SogSok_SeikyuSho_TorikCreTask task = new SogSok_SeikyuSho_TorikCreTask();
			task.run(null);
			task.execute(null);
		}catch(Exception ex){
			System.debug(ex);
		}

	}
}