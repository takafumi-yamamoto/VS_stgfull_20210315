@isTest
public class OboKeirDenRenewsT {

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
		Map<String, Obosanbin__c> theObosanbins;
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
            'Jiin' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Jiin'),
                Name = '_'
            )
        };
		INSERT theAccounts01.values();

        Map<String, Account> theAccounts02 = new Map<String, Account>{
            'Soryo' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','SoryoAccount'),
                Name = '_', ShozokuSangouSangoJiin__c = theAccounts01.get('Jiin').Id
            )
        };
		INSERT theAccounts02.values();

		Map<String, Keiyaku__c> theKeiyakus = new Map<String, Keiyaku__c>{
			'1' => new Keiyaku__c(
				RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Keiyaku__c','Obosanbin'),
				Teikeisaki__c = theAccounts02.get('Soryo').Id
			)
		};
		INSERT theKeiyakus.values();

		Map<String, TesuryoPlan__c> theTesuryoPlans = new Map<String, TesuryoPlan__c>{
			'1' => new TesuryoPlan__c( CoreTesuryoPlanId__c = 3 )
		};
		INSERT theTesuryoPlans.values();

		Map<String, TesuryoTekiyo__c> theTesuryoTekiyos = new Map<String, TesuryoTekiyo__c>{
			'1' => new TesuryoTekiyo__c(
				KeiyakuRef__c = theKeiyakus.get('1').Id,
				TesuryoPlanRef__c = theTesuryoPlans.get('1').Id, 
				ShoninStatus__c = '承認済')
		};
		INSERT theTesuryoTekiyos.values();

        Map<String, Obosanbin__c> theObosanbins = new Map<String, Obosanbin__c>{
            '1' => new Obosanbin__c(
                MemorialServicePlan__c = '_',
                KokubetsuDateTime_Inp__c = system.today(),
                ObosanbinKeiyakuMadoguchi__c = theKeiyakus.get('1').Id
            )
        };
        Insert theObosanbins.values();

        Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
            '1' => new Opportunity(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Obosanbin'),
                Name = '_',
                AccountId = theAccounts01.get('Customer').Id,
                StageName = '_',
                CloseDate = system.today(),
                ObosanbinRef__c = theObosanbins.get('1').Id,
                Req_Day__c = Date.today(),
                Pricebook2Id = Test.getStandardPricebookId()
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
            ServiceSyubetsu__c = 'お坊さん便',
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
		theResult.theObosanbins = theObosanbins;
		return theResult;
	}
	@isTest static void tsujo_denpyo(){
		beginSetUp();
		setUpOboOpportunity_result the_setUpOboOpportunity_result = setUpOboOpportunity();
		Id theOppId = the_setUpOboOpportunity_result.theOpps.get('1').Id;
		UPDATE New Opportunity(Id = theOppId, StageName = '商談クローズ');
		String theShodanBango = [SELECT Id, ShodanBango__c FROM Opportunity WHERE Id = :theOppId].get(0).ShodanBango__c;
        endSetUp();

		Test.startTest();
		OboKeirDenRenews.renew(theShodanBango);
		Test.stopTest();

		OboKeirDen__c actual_OboKeirDen = [SELECT Id, RenkeiShoriKbn__c FROM OboKeirDen__c WHERE ShodanBango__c = :theShodanBango].get(0);
		System.assertEquals('通常', actual_OboKeirDen.RenkeiShoriKbn__c);
	}
	@isTest static void torikeshi_denpyo(){
		beginSetUp();
		setUpOboOpportunity_result the_setUpOboOpportunity_result = setUpOboOpportunity();
		Id theOppId = the_setUpOboOpportunity_result.theOpps.get('1').Id;
		UPDATE New Opportunity(Id = theOppId, StageName = '決定');
		String theShodanBango = [SELECT Id, ShodanBango__c FROM Opportunity WHERE Id = :theOppId].get(0).ShodanBango__c;
		UPSERT new OboKeirDen__c(RenkeiShoriKbn__c = '通常', ShodanBango__c = theShodanBango, LastSyncVersion__c = '0') ShodanBango__c;
        endSetUp();

		Test.startTest();
		OboKeirDenRenews.renew(theShodanBango);
		Test.stopTest();

		OboKeirDen__c actual_OboKeirDen = [SELECT Id, RenkeiShoriKbn__c FROM OboKeirDen__c WHERE ShodanBango__c = :theShodanBango].get(0);
		System.assertEquals('取消', actual_OboKeirDen.RenkeiShoriKbn__c);
	}
	@isTest static void error_denpyo(){
		beginSetUp();
		setUpOboOpportunity_result the_setUpOboOpportunity_result = setUpOboOpportunity();
		Id theOppId = the_setUpOboOpportunity_result.theOpps.get('1').Id;
		Id theOboId = the_setUpOboOpportunity_result.theObosanbins.get('1').Id;
		UPDATE New Obosanbin__c(Id = theOboId, ObosanbinKeiyakuMadoguchi__c = null);
		UPDATE New Opportunity(Id = theOppId, StageName = '商談クローズ');
		String theShodanBango = [SELECT Id, ShodanBango__c FROM Opportunity WHERE Id = :theOppId].get(0).ShodanBango__c;
        endSetUp();

		Test.startTest();
		OboKeirDenRenews.renew(theShodanBango);
		Test.stopTest();

		OboKeirDen__c actual_OboKeirDen = [SELECT Id, RenkeiShoriKbn__c FROM OboKeirDen__c WHERE ShodanBango__c = :theShodanBango].get(0);
		System.assertEquals('エラー', actual_OboKeirDen.RenkeiShoriKbn__c);
	}
	@isTest static void lastSyncVersion_should_be_copied_to_new_denpyo(){
		beginSetUp();
		setUpOboOpportunity_result the_setUpOboOpportunity_result = setUpOboOpportunity();
		Id theOppId = the_setUpOboOpportunity_result.theOpps.get('1').Id;
		UPDATE New Opportunity(Id = theOppId, StageName = '決定');
		String theShodanBango = [SELECT Id, ShodanBango__c FROM Opportunity WHERE Id = :theOppId].get(0).ShodanBango__c;
		UPSERT new OboKeirDen__c(RenkeiShoriKbn__c = '通常', ShodanBango__c = theShodanBango, LastSyncVersion__c = '1') ShodanBango__c;
        endSetUp();

		Test.startTest();
		OboKeirDenRenews.renew(theShodanBango);
		Test.stopTest();

		OboKeirDen__c actual_OboKeirDen = [SELECT Id, RenkeiShoriKbn__c, LastSyncVersion__c FROM OboKeirDen__c WHERE ShodanBango__c = :theShodanBango].get(0);
		System.assertEquals('1', actual_OboKeirDen.LastSyncVersion__c);
	}
}