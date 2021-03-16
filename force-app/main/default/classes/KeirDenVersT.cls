@isTest
public class KeirDenVersT {
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
        Map<String, Product2> theProds = new Map<String, Product2>{
           '1' => new Product2(
               Name = '_',
               IsActive = true,
			   ShohinBango__c = '1'
           )
        };
        Map<String, PricebookEntry> theProdEntries = new Map<String, PricebookEntry>{
            '1' => new PricebookEntry(
                Pricebook2Id = Test.getStandardPricebookId(),
                Product2 = new Product2(ShohinBango__c = '1'),
                UnitPrice = 1000,
                IsActive = true
           )
        };
		DATABASE.INSERT(new SObject[] { 
			theProds.get('1'), theProdEntries.get('1')
		});

        Map<String, Account> theAccounts01 = new Map<String, Account>{
            'Customer' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                FirstName = '_', LastName = '_'
            ),
            'Sogisya' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Sogisya'),
                Name = '_'
            )
        };
		INSERT theAccounts01.values();

		Map<String, Keiyaku__c> theKeiyakus = new Map<String, Keiyaku__c>{
			'1' => new Keiyaku__c(
				RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Keiyaku__c','SimpleYasugo'),
				Teikeisaki__c = theAccounts01.get('Sogisya').Id
			)
		};
		INSERT theKeiyakus.values();

		Map<String, TesuryoPlan__c> theTesuryoPlans = new Map<String, TesuryoPlan__c>{
			'1' => new TesuryoPlan__c( CoreTesuryoPlanId__c = 6 )
		};
		INSERT theTesuryoPlans.values();

		Map<String, TesuryoTekiyo__c> theTesuryoTekiyos = new Map<String, TesuryoTekiyo__c>{
			'1' => new TesuryoTekiyo__c(
				KeiyakuRef__c = theKeiyakus.get('1').Id,
				TekiyoKaishiBi__c = Date.newInstance(2000,1,1),
				TesuryoPlanRef__c = theTesuryoPlans.get('1').Id, 
				ShoninStatus__c = '承認済')
		};
		INSERT theTesuryoTekiyos.values();

        Map<String, SimpleYasugo__c> theSimpleYasugos = new Map<String, SimpleYasugo__c>{
            '1' => new SimpleYasugo__c(
                SimpleYasugoKeiyakuRef__c = theKeiyakus.get('1').Id,
				TaiouKanouRiyu__c = '対応可能（斎場優先）',
				SeikyushojuryoDay__c = Date.newInstance(2000,1,1)
            )
        };
        Insert theSimpleYasugos.values();

        Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
            '1' => new Opportunity(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo'),
                Name = '_',
                AccountId = theAccounts01.get('Customer').Id,
                StageName = '_',
				Req_Day__c = Datetime.newInstance(2000,1,1,0,0,0),
				KakuteibiSyodan__c = Datetime.newInstance(2000,1,1,0,0,0),
				Utiagebi__c =  Date.newInstance(2000,1,1),
				CloseDate = Date.newInstance(2000,1,1),
                SimpleYasugoRef__c = theSimpleYasugos.get('1').Id,
                Pricebook2Id = Test.getStandardPricebookId(),
                KiboShiharaiHouhou__c = '現金'
            )
        };
        Insert theOpps.values();

        Map<String, OpportunityLineItem> theOppItems = new Map<String, OpportunityLineItem>{
            '1' => new OpportunityLineItem(
                OpportunityId = theOpps.get('1').Id,
                Product2Id = theProds.get('1').Id,
                TotalPrice = 1000
            )
        };
        Insert theOppItems.values();

		Map<String, OkyakusamaSeikyuMeisai__c> theSeikMeisais = new Map<String, OkyakusamaSeikyuMeisai__c>{
			'1' =>new OkyakusamaSeikyuMeisai__c(
            ServiceSyubetsu__c = 'シンプル安豪',
            SeikyuKingaku__c = 1000,
            OpportunityRef__c = theOpps.get('1').Id,
            SeikyuHouhou__c = '_',
            Kessaibi__c = Date.today()
        	)
		};
		INSERT theSeikMeisais.values();

		Map<String, PatnerUriage__c> thePatnerUriages = new Map<String, PatnerUriage__c>{
			'1' =>new PatnerUriage__c(
            Syodan__c = theOpps.get('1').Id,
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

	@isTest static void onOppAfterUpdated(){
		beginSetUp();
		setUpOboOpportunity_result the_setUpOboOpportunity_result = setUpOboOpportunity();
		Id theOppId = the_setUpOboOpportunity_result.theOpps.get('1').Id;
        endSetUp();

		Test.startTest();
		UPDATE New Opportunity(Id = theOppId, StageName = '商談クローズ');
		Test.stopTest();
	}
	@isTest static void renew(){
		beginSetUp();
		setUpOboOpportunity_result the_setUpOboOpportunity_result = setUpOboOpportunity();
		Id theOppId = the_setUpOboOpportunity_result.theOpps.get('1').Id;
		UPDATE New Opportunity(Id = theOppId, StageName = '決定', SurveyDiscountAgreeStatus__c = '同意済');
		String theShodanBango = [SELECT Id, ShodanBango__c FROM Opportunity WHERE Id = :theOppId].get(0).ShodanBango__c;
        endSetUp();

		Test.startTest();
		KeirDenVers.renew(theShodanBango,'1');
		Test.stopTest();
	}
	@isTest static void renew_exception(){
		beginSetUp();
		setUpOboOpportunity_result the_setUpOboOpportunity_result = setUpOboOpportunity();
		Id theOppId = the_setUpOboOpportunity_result.theOpps.get('1').Id;
		UPDATE New Opportunity(Id = theOppId, StageName = '決定', SurveyDiscountAgreeStatus__c = '同意済');
		String theShodanBango = [SELECT Id, ShodanBango__c FROM Opportunity WHERE Id = :theOppId].get(0).ShodanBango__c;
        DELETE New Opportunity(Id = theOppId);
        endSetUp();

		Test.startTest();
		KeirDenVers.renew(theShodanBango,'1');
		Test.stopTest();
	}
}