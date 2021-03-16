@isTest public class KeirDenSogiFreeesT {
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
	private class setUpOboOpportunity_result{
		Map<String, Opportunity> theOpps;
		Map<String, OpportunityLineItem> theOppItems;
		Map<String, OkyakusamaSeikyuMeisai__c> theSeikMeisais;
		Map<String, PatnerUriage__c> thePatnerUriages;
		Map<String, SimpleYasugo__c> theSimpleYasugos;
	}
	private static setUpOboOpportunity_result setUpOboOpportunity(){

		Map<String, k_ShohinCategory__c> theShohinCategorys = new Map<String, k_ShohinCategory__c>{
			'一般葬' => new k_ShohinCategory__c(Name = '一般葬', ID__c = 'ippansou' )
		};
		Map<String, k_ShohinSyubetsu__c> theShohinSyubetsu = new Map<String,k_ShohinSyubetsu__c>{
			'本体（委託）' => new k_ShohinSyubetsu__c(Name = '本体（委託）', ID__c = '1' ),
			'オプション（手配）' => new k_ShohinSyubetsu__c(Name = 'オプション（手配）', ID__c = '4' )
		};
		DATABASE.INSERT(new SObject[] { 
			theShohinCategorys.get('一般葬'), theShohinSyubetsu.get('本体（委託）')
		});

        Map<String, Product2> theProds = new Map<String, Product2>{
           '葬儀プラン' => new Product2(
               Name = '葬儀プラン', ShohinBango__c = 'SOGI-PLAN', IsActive = true,
			   DataKubun__c = '1:通常商品',
			   k_ShohinCategoryRef__c = theShohinCategorys.get('一般葬').Id,
			   k_ShohinSyubetsuRef__c = theShohinSyubetsu.get('本体（委託）').Id
           ),
           '葬儀オプション' => new Product2(
               Name = '葬儀オプション', ShohinBango__c = 'SOGI-OPTION', IsActive = true,
			   DataKubun__c = '1:通常商品',
			   k_ShohinSyubetsuRef__c = theShohinSyubetsu.get('オプション（手配）').Id
           ),
           '割引プラン' => new Product2(
               Name = '割引プラン', ShohinBango__c = 'WARIBIKI', IsActive = true,
			   DataKubun__c = '3:クーポン'
           ),
           'クーポン' => new Product2(
               Name = 'クーポン', ShohinBango__c = 'COUPON', IsActive = true,
			   DataKubun__c = '2:割引プラン'
           )
        };
		INSERT theProds.Values();

        Map<String, PricebookEntry> theProdEntries = new Map<String, PricebookEntry>{
            '葬儀プラン' => new PricebookEntry(
                Pricebook2Id = Test.getStandardPricebookId(), IsActive = true,
                Product2Id = theProds.get('葬儀プラン').Id, UnitPrice = 100000
           ),
            '葬儀オプション' => new PricebookEntry(
                Pricebook2Id = Test.getStandardPricebookId(), IsActive = true,
                Product2Id = theProds.get('葬儀オプション').Id, UnitPrice = 10000
           ),
            '割引プラン' => new PricebookEntry(
                Pricebook2Id = Test.getStandardPricebookId(), IsActive = true,
                Product2Id = theProds.get('割引プラン').Id, UnitPrice = -10000
           ),
            'クーポン' => new PricebookEntry(
                Pricebook2Id = Test.getStandardPricebookId(), IsActive = true,
                Product2Id = theProds.get('クーポン').Id, UnitPrice = -10000
           )
        };
		INSERT theProdEntries.values();

        Map<String, Account> theAccounts = new Map<String, Account>{
            'Customer' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                FirstName = '_', LastName = '_'
            ),
            'Sogisya' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Sogisya'),
                Name = '_',
				KeiriTorihikiSakiName__c = '_'
            )
        };
		INSERT theAccounts.values();

		Map<String, Keiyaku__c> theKeiyakus = new Map<String, Keiyaku__c>{
			'シンプル安豪契約' => new Keiyaku__c(
				RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Keiyaku__c','SimpleYasugo'),
				Teikeisaki__c = theAccounts.get('Sogisya').Id
			)
		};
		INSERT theKeiyakus.values();

        Map<String, SimpleYasugo__c> theSimpleYasugos = new Map<String, SimpleYasugo__c>{
            'シンプル安豪' => new SimpleYasugo__c(
                SimpleYasugoKeiyakuRef__c = theKeiyakus.get('シンプル安豪契約').Id,
				TaiouKanouRiyu__c = '対応可能（斎場優先）',
				SeikyushojuryoDay__c = Date.newInstance(2020,1,1)
            )
        };
        Insert theSimpleYasugos.values();

        Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
            'シンプル安豪商談' => new Opportunity(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo'),
                Name = '_', StageName = '_', Pricebook2Id = Test.getStandardPricebookId(),
				Utiagebi__c = Date.newInstance(2020,1,1),
				CloseDate = Date.newInstance(2020,1,1),
                AccountId = theAccounts.get('Customer').Id,
                SimpleYasugoRef__c = theSimpleYasugos.get('シンプル安豪').Id,
				TesuryoPartnerForPlan__c = 10000, TesuryoPartnerForOption__c = 5000, JimuTesuryo__c = 2000,
				NyukinSimekiriBiPartner__c = Date.newInstance(2020,1,1),
				ShiharaiKijitsuPartner__c = Date.newInstance(2020,1,1),
                Req_Day__c = Date.newInstance(2020,1,1), KakuteibiSyodan__c = Date.newInstance(2020,1,1)
            )
        };
        Insert theOpps.values();

        Map<String, OpportunityLineItem> theOppItems = new Map<String, OpportunityLineItem>{
            '葬儀プラン' => new OpportunityLineItem(
                OpportunityId = theOpps.get('シンプル安豪商談').Id, Product2Id = theProds.get('葬儀プラン').Id, TotalPrice = 100000
            ),
            '葬儀オプション' => new OpportunityLineItem(
                OpportunityId = theOpps.get('シンプル安豪商談').Id, Product2Id = theProds.get('葬儀オプション').Id, TotalPrice = 10000
            ),
            '割引プラン' => new OpportunityLineItem(
                OpportunityId = theOpps.get('シンプル安豪商談').Id, Product2Id = theProds.get('割引プラン').Id, TotalPrice = -10000
            ),
            'クーポン' => new OpportunityLineItem(
                OpportunityId = theOpps.get('シンプル安豪商談').Id, Product2Id = theProds.get('クーポン').Id, TotalPrice = -10000
            )
        };
        Insert theOppItems.values();

		Map<String, OkyakusamaSeikyuMeisai__c> theSeikMeisais = new Map<String, OkyakusamaSeikyuMeisai__c>{
			'パートナー回収' =>new OkyakusamaSeikyuMeisai__c(
            ServiceSyubetsu__c = 'シンプル安豪',  OpportunityRef__c = theOpps.get('シンプル安豪商談').Id,
            SeikyuHouhou__c = 'Partner', SeikyuKingaku__c = 10000, Kessaibi__c = Date.newInstance(2020,1,1)
        	),
			'振込' =>new OkyakusamaSeikyuMeisai__c(
            ServiceSyubetsu__c = 'シンプル安豪',  OpportunityRef__c = theOpps.get('シンプル安豪商談').Id,
            SeikyuHouhou__c = 'furikomi', SeikyuKingaku__c = 10000, Kessaibi__c = Date.newInstance(2020,1,1)
        	),
			'オリコローン' =>new OkyakusamaSeikyuMeisai__c(
            ServiceSyubetsu__c = 'シンプル安豪',  OpportunityRef__c = theOpps.get('シンプル安豪商談').Id,
            SeikyuHouhou__c = 'orico_loan', SeikyuKingaku__c = 10000, Kessaibi__c = Date.newInstance(2020,1,1)
        	),
			'オリコクレカ' =>new OkyakusamaSeikyuMeisai__c(
            ServiceSyubetsu__c = 'シンプル安豪',  OpportunityRef__c = theOpps.get('シンプル安豪商談').Id,
            SeikyuHouhou__c = 'orico_credit', SeikyuKingaku__c = 10000, Kessaibi__c = Date.newInstance(2020,1,1)
        	),
			'GMOクレカ' =>new OkyakusamaSeikyuMeisai__c(
            ServiceSyubetsu__c = 'シンプル安豪',  OpportunityRef__c = theOpps.get('シンプル安豪商談').Id,
            SeikyuHouhou__c = 'gmo_credit', SeikyuKingaku__c = 10000, Kessaibi__c = Date.newInstance(2020,1,1)
        	),
			'GMO後払い' =>new OkyakusamaSeikyuMeisai__c(
            ServiceSyubetsu__c = 'シンプル安豪',  OpportunityRef__c = theOpps.get('シンプル安豪商談').Id,
            SeikyuHouhou__c = 'gmo_atobarai', SeikyuKingaku__c = 40000, Kessaibi__c = Date.newInstance(2020,1,1)
        	)
		};
		INSERT theSeikMeisais.values();

		Map<String, PatnerUriage__c> thePatnerUriages = new Map<String, PatnerUriage__c>{
			'手数料値引' =>new PatnerUriage__c(
            Syodan__c = theOpps.get('シンプル安豪商談').Id,
			Kingaku__c = -1000
        	)
		};
		INSERT thePatnerUriages.values();

		setUpOboOpportunity_result theResult = new setUpOboOpportunity_result();
		theResult.theOpps = theOpps;
		theResult.theOppItems = theOppItems;
		theResult.theSeikMeisais = theSeikMeisais;
		theResult.thePatnerUriages = thePatnerUriages;
		theResult.theSimpleYasugos = theSimpleYasugos;
		return theResult;
	}
	@isTest static void doTest(){
		beginSetUp();
			setUpOboOpportunity_result the_setUpOboOpportunity_result = setUpOboOpportunity();
			Id theOppId = the_setUpOboOpportunity_result.theOpps.get('シンプル安豪商談').Id;
			UPDATE new Opportunity(Id = theOppId, StageName = '商談クローズ');
			String theShodanBango = [SELECT Id, ShodanBango__c FROM Opportunity WHERE Id = :theOppId].get(0).ShodanBango__c;

			KeirDenSogiTransSlips theKeirDenSogiTransSlips = new KeirDenSogiTransSlips();
			Opportunity theOpp = theKeirDenSogiTransSlips.getOppData(theShodanBango);
			KeirDenSogiTransSlips.TransSlip theTransSlip = theKeirDenSogiTransSlips.createTransSlip(theOpp);
        endSetUp();

		Test.startTest();
			KeirDenSogiFreees theKeirDenSogiFreees = KeirDenSogiFreees.instance();
			List<KeirDenSogiFreees.Deal> theDeals = theKeirDenSogiFreees.createDeals(theTransSlip);
			List<FreDlCsvRow__c> theCsvRows = theKeirDenSogiFreees.toFreDlCsvRows(theDeals, theShodanBango);
			System.AssertEquals(true, theCsvRows.size() > 0 );
		Test.stopTest();
			

	}
}