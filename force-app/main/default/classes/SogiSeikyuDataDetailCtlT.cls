@isTest
private class SogiSeikyuDataDetailCtlT {
	
	@testSetup
    static void initializeTestData() {

		Utility_Common.isMimicExecAsDataIkouProfile = true;

		Account dacc=new Account();
		dacc.LastName='xxxdefualt';
		//acc.LastNameFurigana__pc ='defualt';
		//acc.FirstNameFurigana__pc ='defualt';
		dacc.Phone='088-0000-0001';
		dacc.MobilePhone__c='888-0000-0001';
		dacc.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId();
		insert dacc;

		//カスタム設定のTriggerIsActive__cのデータを作成
		TriggerIsActive__c TriggerIsActive=new TriggerIsActive__c();
		TriggerIsActive.name='default';
		TriggerIsActive.isActive__c=false;
		insert TriggerIsActive;

		JizenWariPlan__c JizenWariPlan=new JizenWariPlan__c();
        JizenWariPlan.Code__c='Yoriso';
        insert JizenWariPlan;        

        //取引先のデータ作成
		Account acc=new Account();
		acc.name='defualt';
		//acc.LastNameFurigana__pc ='defualt';
		//acc.FirstNameFurigana__pc ='defualt';
		acc.Phone='080-0000-0001';
		acc.MobilePhone__c='080-0000-0001';
		insert acc;

		//取引先の「葬儀社」データ作成
        Account acc2 = new Account(
            Name ='テスト葬儀社',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Sogisya').getRecordTypeId(),
            Fax = '03-3493-87701',
            Description = 'この葬儀社は、システム内で本番環境で動作確認する際に利用するテストデータの葬儀社です。',
            PersonHasOptedOutOfEmail = FALSE,
            PersonHasOptedOutOfFax = FALSE,
            PersonDoNotCall = FALSE,
            BankAccountType__c = '普通預金',
            // AfterSalesTaisyoFlag__c = FALSE,
            MailAddress2__c = 'a1b2@aa.com',
            MailAddress__c = 'dev-test+2018@yoriso.com',
            MemberTourokuZumi__c = FALSE,
            // NewsLetterHaishinFlag__c = 0,
            // ObonDmSoushinFlag__c = 0,
            // OhakaAri__c = FALSE,
            KoukokuDmNg__c = FALSE,
            KoukokuFaxNg__c = FALSE,
            JizenwariMemberKa__c = FALSE,
            // IsDeleted__c = FALSE,
            IsPersonAccount__c = FALSE,
            BetsuinKatsudoKibo__c = FALSE,
            SomeiTorokuKibo__c = FALSE,
            NayoseMailAddress__c = 'a1b2@aa.com',
            NayoseMailAddress2__c = 'dev-test+2018@yoriso.com',
            JushoFubi__c = FALSE,
            PtWebAcceptedDate__c = Date.today(),
            //PtWebAccountRef__c = lsrPtWeb.getId(),
            IsOboStLineAcnt__c = FALSE,
            //YosinKanriRef__c = lsrYosinKanri.getId(),
            KaihoshiNG__c = FALSE,
            KoukokuMailNg__c = FALSE,
            KoukokuSmsNg__c = FALSE,
            NameYagouFurigana__c = 'システムドウサカクニンヨウ',
            NameShogoFurigana__c = 'システムドウサカクニンヨウ',
            NameShogo__c = 'システム動作確認用',
            SeikyuSakiAtena__c = 'システム動作確認用'
        );
        Database.SaveResult lsracc2 = Database.insert(acc2);

        //パートナー契約の「シンプル安豪契約」データ作成
        Keiyaku__c keiyaku = new Keiyaku__c(
            Name = 'シンプル安豪契約',
            RecordTypeId = Schema.getGlobalDescribe().get('Keiyaku__c').getDescribe().getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId(),
            Teikeisaki__c = lsracc2.getId(),
            AmazonTaioka__c = FALSE,
            AreaTokureiAri__c = FALSE,
            KaiteKiyakuTekiyoZumi__c = FALSE,
            KeiyakuJokyo__c = '契約中',
            KeiyakuMousikomiBi__c = date.valueOf('2015-01-01'),
            KeiyakuSyoSyosiki__c = '2018年1月24改定以前規約',
            Keiyakukaishibi__c = date.valueOf('2015-01-01'),
            KyuTesuryoTaioFlag__c = FALSE,
            NyukinSimekiriJouken__c = '月末締め翌月末',
            SekoHosyoKeiyakuSu__c = 0,
            SekoHosyoYukoKeiyakuSu__c = 0,
            ShikiariNeageKosyoStatus__c = '未着手',
            ShoriStatus__c = '未連携',
            SimpleKeiyakuSu__c = 0,
            SimpleYukoKeiyakuSu__c = 0,
            TesuryoAtobaraiAri__c = FALSE,
            TesuryoCardLoanAri__c = FALSE,
            TesuryoHenreiHinAri__c = FALSE,
            TesuryoOptionAri__c = FALSE,
            TesuryoRyoriAri__c = FALSE,
            TokuyakutenKeiyakuSu__c = 0,
            TokuyakutenYukoKeiyakuSu__c = 0,
            TryCount__c = 0,
            TryLimit__c = 3,
            UnsoKyokasyoHikaeAri__c = FALSE,
            YasugoKeiyakuSu__c = 0,
            YasugoYukoKeiyakuSu__c = 0,
            Jizenkakuninhouhou__c = 'SMS',
            IsSoukyakujiFax__c = TRUE,
            SeikyushoHassoCycle__c = '月末',
            SeikyushoSakuseijiFax__c = FALSE
        );
        insert keiyaku;

		Pricebook2 standardPricebook = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = true
        );
        update standardPricebook;

        Id pricebookId = Test.getStandardPricebookId();
		k_ShohinSyubetsu__c k_ShohinSyubetsu=new k_ShohinSyubetsu__c();
		k_ShohinSyubetsu.ID__c='1';
		insert k_ShohinSyubetsu;
		
		Product2 prod = new Product2(
		     Name = 'Product X',
		     ProductCode = 'Pro-X',
		     DataKubun__c='1:通常商品',  		
		     k_ShohinSyubetsuRef__c=k_ShohinSyubetsu.id,
		     isActive = true
		);
		
		insert prod;

		PricebookEntry pbEntry = new PricebookEntry(
		     Pricebook2Id = pricebookId,
		     Product2Id = prod.Id,
		     UnitPrice = 100.00,
		     IsActive = true
		);
		insert pbEntry;
		
		SimpleYasugo__c simpleYasugo1 = new SimpleYasugo__c();
		simpleYasugo1.SeikyushojuryoDay__c = Date.today();
		insert simpleYasugo1;

		Opportunity opp1 = new Opportunity();
        opp1.accountid=acc.id;
        opp1.Name='test1';
        opp1.StageName='商談開始';
        opp1.Req_Day__c = Date.today();
        opp1.CloseDate = Date.today();
        opp1.KakuteibiSyodan__c = Date.today();
        opp1.Utiagebi__c = Date.today();
        opp1.accountid=acc.id;
        opp1.TesuryoPartner__c = 5000;
		opp1.TaishoushaJokyo__c = '_';
		opp1.SimpleYasugoRef__c = simpleYasugo1.Id;
        opp1.recordtypeid=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId();
        insert opp1;
		
		OpportunityLineItem oli1 = new OpportunityLineItem(
		     OpportunityId = opp1.Id,
		     Quantity = 1,
		     PricebookEntryId = pbEntry.Id,
		     TotalPrice =10000// quantity * pbEntry.UnitPrice
		);
		insert oli1;
		
		OkyakusamaSeikyuMeisai__c oOkyakusamaSeikyuMeisai=new OkyakusamaSeikyuMeisai__c();
		oOkyakusamaSeikyuMeisai.OpportunityRef__c=opp1.id;
		oOkyakusamaSeikyuMeisai.SeikyuHouhou__c = 'Partner';
		oOkyakusamaSeikyuMeisai.SeikyuKingaku__c = 10000;
		oOkyakusamaSeikyuMeisai.Kessaibi__c = Date.today();
        insert oOkyakusamaSeikyuMeisai;

        Opportunity opp1_2 = [SELECT Id, ShodanBango__c, SimpleYasugoRef__c FROM Opportunity WHERE Id = :opp1.Id];
        opp1_2.StageName='商談クローズ';
		update opp1_2;
		
		SimpleYasugo__c simpleYasugo2 = new SimpleYasugo__c();
		simpleYasugo2.SeikyushojuryoDay__c = Date.today();
		insert simpleYasugo2;

		Opportunity opp2 = new Opportunity();
        opp2.accountid=acc.id;
        opp2.Name='test2';
        opp2.StageName='商談開始';
        opp2.Req_Day__c = Date.today();
        opp2.CloseDate = Date.today();
        opp2.KakuteibiSyodan__c = Date.today();
        opp2.Utiagebi__c = Date.today();
        opp2.accountid=acc.id;
        opp2.TesuryoPartner__c = 5000;
		opp2.TaishoushaJokyo__c = '_';
		opp2.SimpleYasugoRef__c = simpleYasugo2.Id;
        opp2.recordtypeid=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId();
        insert opp2;
		
		OpportunityLineItem oli2 = new OpportunityLineItem(
		     OpportunityId = opp2.Id,
		     Quantity = 1,
		     PricebookEntryId = pbEntry.Id,
		     TotalPrice =10000// quantity * pbEntry.UnitPrice
		);
		insert oli2;
		
		OkyakusamaSeikyuMeisai__c oOkyakusamaSeikyuMeisai2 = new OkyakusamaSeikyuMeisai__c();
		oOkyakusamaSeikyuMeisai2.OpportunityRef__c=opp2.id;
		oOkyakusamaSeikyuMeisai2.SeikyuHouhou__c = 'Partner';
		oOkyakusamaSeikyuMeisai2.SeikyuKingaku__c = 10000;
		oOkyakusamaSeikyuMeisai2.Kessaibi__c = Date.today();
        insert oOkyakusamaSeikyuMeisai2;

		Opportunity opp2_2 = [SELECT Id, ShodanBangoF__c, SimpleYasugoRef__c FROM Opportunity WHERE Id = :opp2.Id];
        opp2_2.StageName='商談クローズ';
        update opp2_2;
    }

	@isTest static void testMethod_case1(){
		Opportunity o = [select Id, ShodanBango__c from Opportunity where Name = 'test1'];
		ApexPages.currentPage().getParameters().put('openType','new');
		ApexPages.currentPage().getParameters().put('seikyuNumber', o.ShodanBango__c);
		ApexPages.currentPage().getParameters().put('seikyuNumbers', o.ShodanBango__c + ',');
		
		SogiSeikyuDataDetailCtl ssdd = new SogiSeikyuDataDetailCtl();
		ssdd.init();
		ssdd.doKakuminIrai();
		ssdd.doSeikyuSoshin();
		ssdd.doSashimodoshi();
		ssdd.doSaiseikyu();
	}
	
	@isTest static void testMethod_case2(){
		Opportunity o = [select Id, ShodanBango__c from Opportunity where Name = 'test1'];
		ApexPages.currentPage().getParameters().put('openType','new');
		ApexPages.currentPage().getParameters().put('seikyuNumber', o.ShodanBango__c);
		ApexPages.currentPage().getParameters().put('seikyuNumbers', o.ShodanBango__c + ',');
		
		SogiSeikyuDataDetailCtl ssdd = new SogiSeikyuDataDetailCtl();
		ssdd.init();
		ssdd.doKakuminIrai();

		Opportunity o1 = [select Id, ShodanBango__c from Opportunity where Name = 'test1'];
		Opportunity o2 = [select Id, ShodanBango__c from Opportunity where Name = 'test2'];
		PartnerSeikyuSogisha__c pss = [select Id from PartnerSeikyuSogisha__c];
		PartnerSeikyuMeisaiSogisha__c psms = [select Id from PartnerSeikyuMeisaiSogisha__c];
		ApexPages.currentPage().getParameters().put('openType','add');
		ApexPages.currentPage().getParameters().put('seikyuId', pss.Id);
		ApexPages.currentPage().getParameters().put('seikyuDetailIds', psms.Id + ',');
		ApexPages.currentPage().getParameters().put('seikyuNumber', o1.ShodanBango__c);
		ApexPages.currentPage().getParameters().put('seikyuNumbers', o1.ShodanBango__c + ',' + o2.ShodanBango__c + ',');

		SogiSeikyuDataDetailCtl ssdd2 = new SogiSeikyuDataDetailCtl();
		ssdd2.init();
		ssdd2.doAddKakuminIrai();
	}
}