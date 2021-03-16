@isTest
private class SogSok_SrthIraiSho_TorikCreT{

	@isTest static void test_method_1() {

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

		Insert new TriggerIsActive__c( name='default', isActive__c=true );
		Test.startTest();
		SogSok_Sokyaku__c sokyaku = new SogSok_Sokyaku__c(OpportunityRef__c=oppSimpleYasugo.Id);
		insert sokyaku;
		sokyaku = [select id, name from SogSok_Sokyaku__c where id =:sokyaku.Id];
		

		SogSok_MitsumoriSho__c sogsok_mitsumorisho = new SogSok_MitsumoriSho__c(DocStatus__c = 'draft', SokyakuBango__c=sokyaku.Name);
		insert sogsok_mitsumorisho;

		SogSok_SrthIraiSho__c sogsok_srthiraisho0 = new SogSok_SrthIraiSho__c();
		// sogsok_srthiraisho0.id = 'a2R0k0000001w6QEAQ'; 
		sogsok_srthiraisho0.sokyakubango__c = sokyaku.Name;
		sogsok_srthiraisho0.shodanbango__c = '0426755';
		sogsok_srthiraisho0.docstatus__c = 'activated';
		sogsok_srthiraisho0.kinyudate__c = Date.newInstance(2018, 08, 28);
		sogsok_srthiraisho0.renrakujiko__c = 'テスト連絡事項';
		sogsok_srthiraisho0.soukyakusaki_torihikisakibango__c = 'ACNT-0412384';
		sogsok_srthiraisho0.soukyakusaki_torihikisakiname__c = 'テスト梅崎葬儀社';
		sogsok_srthiraisho0.soukyakusaki_tantosha_name__c = 'テスト送客先担当者名';
		sogsok_srthiraisho0.soukyakusaki_tantosha_tel__c = '000-0000-0001';
		sogsok_srthiraisho0.soukyakusaki_tantosha_fax__c = '000-0000-0005';
		sogsok_srthiraisho0.sodansha_torihikisakibango__c = 'ACNT-0412774';
		sogsok_srthiraisho0.sodansha_sei__c = 'テスト梅崎姓';
		sogsok_srthiraisho0.sodansha_mei__c = '相談者名';
		sogsok_srthiraisho0.taishosha_torihikisakibango__c = 'ACNT-0412775';
		sogsok_srthiraisho0.taishosha_sei__c = 'テスト梅崎姓';
		sogsok_srthiraisho0.taishosha_mei__c = '対象者名';
		sogsok_srthiraisho0.taishosha_seikana__c = 'テストウメザキ';
		sogsok_srthiraisho0.taishosha_meikana__c = 'タイショウシャ';
		sogsok_srthiraisho0.taishosha_birthdate__c = Date.newInstance(1900, 01, 11);
		sogsok_srthiraisho0.taishosha_deathdate__c = Date.newInstance(2018, 01, 11);
		sogsok_srthiraisho0.taishosha_age__c = 111.0;
		sogsok_srthiraisho0.taishosha_shuha__c = 'tendaishu';
		// sogsok_srthiraisho0.taishosha_shuha_sonota__c = ''; 
		sogsok_srthiraisho0.taishosha_bodaiji_umu__c = '有';
		sogsok_srthiraisho0.taishosha_zokugarafrommoshu__c = 'chijin';
		sogsok_srthiraisho0.moshu_torihikisakibango__c = 'ACNT-0412776';
		sogsok_srthiraisho0.moshu_sei__c = 'テスト梅崎姓';
		sogsok_srthiraisho0.moshu_mei__c = '喪主名';
		sogsok_srthiraisho0.moshu_seikana__c = 'テストウメザキセイ';
		sogsok_srthiraisho0.moshu_meikana__c = 'モシュメイ';
		sogsok_srthiraisho0.moshu_mobile__c = '000-0000-0003';
		sogsok_srthiraisho0.moshu_phone__c = '00-000-0003';
		sogsok_srthiraisho0.moshu_addr_postalcode__c = '000-0003';
		sogsok_srthiraisho0.moshu_addr_state__c = '熊本県';
		sogsok_srthiraisho0.moshu_addr_city__c = '熊本市';
		sogsok_srthiraisho0.moshu_addr_street__c = '熊本１－１';
		sogsok_srthiraisho0.sogi_tsuyadatetime__c = Datetime.newInstance(2018, 08, 28, 02, 00, 00);
		sogsok_srthiraisho0.sogi_kokubetsudatetime__c = Datetime.newInstance(2018, 08, 28, 03, 00, 00);
		sogsok_srthiraisho0.sogi_kasodatetime__c = Datetime.newInstance(2018, 08, 28, 05, 00, 00);
		sogsok_srthiraisho0.sogi_shonanoka__c = '式中';
		sogsok_srthiraisho0.sogi_shikijo_name__c = 'テスト式場名';
		sogsok_srthiraisho0.sogi_shikijo_address__c = 'テスト式場住所';
		sogsok_srthiraisho0.sogi_shikijo_phone__c = '000-0000-0006';
		sogsok_srthiraisho0.sogi_kasoba_name__c = 'テスト火葬場名';
		sogsok_srthiraisho0.sogi_kasoba_address__c = 'テスト火葬場住所';
		sogsok_srthiraisho0.sogi_kasoba_phone__c = '000-0000-0007';
		sogsok_srthiraisho0.soryotehai_kaimyo__c = '信士';
		sogsok_srthiraisho0.soryotehai_makurakyo__c = 'kasoshiki';
		sogsok_srthiraisho0.soryotehai_kingaku__c = 90000.0;
		sogsok_srthiraisho0.soryotehai_plan__c = 'kaso';
		sogsok_srthiraisho0.juryodatetime__c = Datetime.newInstance(2018, 08, 30, 13, 50, 50);

		insert sogsok_srthiraisho0;




		try{
			new SogSok_SrthIraiSho_TorikCreTask().runTask(null);
		}catch(Exception ex){
			System.debug(ex);
		}

		try{
			new SogSok_SrthIraiSho_TorikCreTask().run(null);
		}catch(Exception ex){
			System.debug(ex);
		}
        Test.stopTest();
        
	}
}