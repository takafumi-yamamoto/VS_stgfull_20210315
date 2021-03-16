@isTest
private class Api_V1_PtWeb_PartnerSeikyushoDetailT {
	
	@testSetup
    static void initializeTestData() {

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
		TriggerIsActive.isActive__c=true;
		insert TriggerIsActive;

		//JizenWariPlan__c JizenWariPlan=new JizenWariPlan__c();
  //      JizenWariPlan.Code__c='Yoriso';
  //      insert JizenWariPlan;

    	//取引先のデータ作成
		Account acc=new Account();
		acc.Lastname='test';
		//acc.LastNameFurigana__pc ='defualt';
		//acc.FirstNameFurigana__pc ='defualt';
		acc.Phone='080-0000-0001';
		acc.MobilePhone__c='080-0000-0001';
		acc.recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
		insert acc;

    	//Pricebook2 standardPricebook = new Pricebook2(
     //       Id = Test.getStandardPricebookId(),
     //       IsActive = true
     //   );
     //   update standardPricebook;

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
			
        opportunity opp=new opportunity();
        opp.accountid=acc.id;
        opp.Name='test';
        opp.StageName='商談開始';
        opp.Req_Day__c = Date.today();
        opp.CloseDate = Date.today();
        opp.KakuteibiSyodan__c = Date.today();
        opp.Utiagebi__c = Date.today();
        opp.TesuryoPartner__c = 5000;
		opp.TaishoushaJokyo__c = '_';
        opp.recordtypeid=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId();
        insert opp;
        	
		PatnerUriage__c oPatnerUriage=new PatnerUriage__c();
		oPatnerUriage.Kingaku__c=10000;
		oPatnerUriage.Syodan__c =opp.id;
		oPatnerUriage.Syohin__c=prod.id;
		insert oPatnerUriage;
		
		OpportunityLineItem oli = new OpportunityLineItem(
		     OpportunityId = opp.Id,
		     Quantity = 1,
		     PricebookEntryId = pbEntry.Id,
		     TotalPrice =10000// quantity * pbEntry.UnitPrice
		);
		insert oli;
		
		OkyakusamaSeikyuMeisai__c oOkyakusamaSeikyuMeisai=new OkyakusamaSeikyuMeisai__c();
		oOkyakusamaSeikyuMeisai.OpportunityRef__c=opp.id;
		oOkyakusamaSeikyuMeisai.SeikyuHouhou__c = 'Partner';
		oOkyakusamaSeikyuMeisai.SeikyuKingaku__c = 10000;
		oOkyakusamaSeikyuMeisai.Kessaibi__c = Date.today();
        insert oOkyakusamaSeikyuMeisai;

		// 商談クローズするためにシンプル安豪の請求書受領日を設定
		// startTest 前に以下の update を実行すると「Too many SOQL queries」に引っかかるため、一時的にここに記載
  //      Opportunity opp1 = [SELECT SimpleYasugoRef__c FROM Opportunity WHERE Id = :opp.Id];
  //      SimpleYasugo__c simpleYasugo = new SimpleYasugo__c();
  //      simpleYasugo.Id = opp1.SimpleYasugoRef__c;
  //      simpleYasugo.SeikyushojuryoDay__c = Date.today();
		//update simpleYasugo;

  //      opp.StageName='商談クローズ';
  //      update opp;

        Account sacc=new Account();
		sacc.Name='xxxdefualt';
		sacc.Phone='088-0000-0001';
		sacc.MobilePhone__c='888-0000-0001';
		sacc.KinyukikanCodeTosha__c = '_'; 
		sacc.KinyukikanMeiTosha__c = '_'; 
		sacc.KozaShubetsuTosha__c = '普通'; 
		sacc.KozaBangoTosha__c = '_'; 
		sacc.KozaMeigiKanaTosha__c = '_';
		sacc.KozaMeigiTosha__c = '_'; 
		sacc.ShitenCodeTosha__c = '_';
		sacc.ShitenMeiTosha__c = '_';
		sacc.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Sogisya').getRecordTypeId();
		insert sacc;

        Keiyaku__c keiyaku = new Keiyaku__c();
		keiyaku.KeiyakuJokyo__c = '未契約';
		keiyaku.Teikeisaki__c = sacc.Id;
		keiyaku.recordTypeId = Schema.SObjectType.Keiyaku__c.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId();
		keiyaku.SeikyushoHassoCycle__c = '20日&月末';
		keiyaku.NyukinSimekiriJouken__c = '請求書発送日から7日後';
		insert keiyaku;

		k_Service__c kService = new k_Service__c( name='_', ID__c = '1' );
        insert kService;

        TesuryoPlan__c tesuryoPlan = new TesuryoPlan__c( 
            Name = '_',  CoreTesuryoPlanId__c = 1, ServiceRef__c = kService.Id,
            KobetsuPlanFlag__c = false, TesuryoNebikiSetteiKa__c = false );
        insert tesuryoPlan;

        TesuryoTekiyo__c tesuryoTekiyo = new TesuryoTekiyo__c(
            KeiyakuRef__c = keiyaku.Id,  
            ShoninStatus__c = 'ドラフト',
            TekiyoKaishiBi__c = Date.valueOf('1900-01-01'),
            TesuryoPlanRef__c = tesuryoPlan.Id,
            ServiceRef__c = kService.Id);
        insert tesuryoTekiyo;

        tesuryoTekiyo.ShoninStatus__c = '承認済';
        update tesuryoTekiyo;

        keiyaku.KeiyakuJokyo__c = '契約中';
        keiyaku.Keiyakukaishibi__c = Date.today();
        update keiyaku;

        PartnerSeikyuSogisha__c pss = new PartnerSeikyuSogisha__c();
        pss.KokyakuId__c = '0002';
        pss.TorihikisakiBango__c = '1234';
        pss.SeikyuStatus__c = '請求済';
        pss.SeikyuKingaku__c = 10000;
        pss.Seikyubi__c = date.today();
        pss.ShiharaiKijitsu__c = date.today();
        pss.NyukinShimekiribi__c = date.today();
        pss.PartnerKeiyakuRef__c = keiyaku.Id;
        insert pss;

        PartnerSeikyuMeisaiSogisha__c psms = new PartnerSeikyuMeisaiSogisha__c();
        psms.PartnerSeikyuSogishaRef__c = pss.Id;
        psms.OpportunityRef__c = opp.Id;
        insert psms;
    }

	@isTest
	static void test_method_one() {

		PartnerSeikyuSogisha__c sltPss = [select Id, Name from PartnerSeikyuSogisha__c];

        Test.startTest();
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/api/v1/partnerseikyusho/detail';
        req.httpMethod = 'GET';
        req.params.put('seikyu_bango', sltPss.Name);

        RestContext.request = req;
        RestContext.response= res;
    
		Api_V1_PtWeb_PartnerSeikyushoDetail.doGet();

        Test.stopTest();
	}
}