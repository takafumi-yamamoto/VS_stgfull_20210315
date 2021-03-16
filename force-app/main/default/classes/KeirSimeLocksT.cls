@isTest
public class KeirSimeLocksT {

	private class setUpOboOpportunity_result{
		Map<String, Opportunity> theOpps;
		Map<String, OpportunityLineItem> theOppItems;
		Map<String, OkyakusamaSeikyuMeisai__c> theSeikMeisais;
		Map<String, PatnerUriage__c> thePatnerUriages;
		Map<String, Obosanbin__c> theObosanbins;
	}
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

	@isTest static void when_simekiri_then_lineitems_should_be_uninsertable(){
		beginSetUp();
		setUpOboOpportunity_result the_setUpOboOpportunity_result = setUpOboOpportunity();
		Id theOppId = the_setUpOboOpportunity_result.theOpps.get('1').Id;
		Id theProdId = the_setUpOboOpportunity_result.theOppItems.get('1').Product2Id;
		INSERT NEW KeirSimekiri__c( Target__c = 'OBO_OPPS', SimekiriDate__c = Date.newInstance(2019,10,31) );
		UPDATE New Opportunity(Id = theOppId, StageName = '商談クローズ', Utiagebi__c = Date.newInstance(2019,10,31) );
        endSetUp();

		Boolean isExpectedDmlExOccured = false;
		Test.startTest();
		try{
			INSERT new OpportunityLineItem( OpportunityId = theOppId, Product2Id = theProdId, TotalPrice = 1000 );
		}catch(DmlException e){
			isExpectedDmlExOccured = true;
		}
		Test.stopTest();
		System.assertEquals(true, isExpectedDmlExOccured);
	}
	@isTest static void when_simekiri_then_lineitems_should_be_unupdatable(){
		beginSetUp();
		setUpOboOpportunity_result the_setUpOboOpportunity_result = setUpOboOpportunity();
		Id theOppId = the_setUpOboOpportunity_result.theOpps.get('1').Id;
		Id theOppItemId = the_setUpOboOpportunity_result.theOppItems.get('1').Id;
		INSERT NEW KeirSimekiri__c( Target__c = 'OBO_OPPS', SimekiriDate__c = Date.newInstance(2019,10,31) );
		UPDATE New Opportunity(Id = theOppId, StageName = '商談クローズ', Utiagebi__c = Date.newInstance(2019,10,31) );
        endSetUp();

		Boolean isExpectedDmlExOccured = false;
		Test.startTest();
		try{
			UPDATE new OpportunityLineItem( Id = theOppItemId, Quantity = 20 );
		}catch(DmlException e){
			isExpectedDmlExOccured = true;
		}
		Test.stopTest();
		System.assertEquals(true, isExpectedDmlExOccured);
	}
	@isTest static void when_simekiri_then_lineitems_should_be_undeletable(){
		beginSetUp();
		setUpOboOpportunity_result the_setUpOboOpportunity_result = setUpOboOpportunity();
		Id theOppId = the_setUpOboOpportunity_result.theOpps.get('1').Id;
		Id theOppItemId = the_setUpOboOpportunity_result.theOppItems.get('1').Id;
		INSERT NEW KeirSimekiri__c( Target__c = 'OBO_OPPS', SimekiriDate__c = Date.newInstance(2019,10,31) );
		UPDATE New Opportunity(Id = theOppId, StageName = '商談クローズ', Utiagebi__c = Date.newInstance(2019,10,31) );
        endSetUp();

		Boolean isExpectedDmlExOccured = false;
		Test.startTest();
		try{
			DELETE new OpportunityLineItem(Id = theOppItemId);
		}catch(DmlException e){
			isExpectedDmlExOccured = true;
		}
		Test.stopTest();
		System.assertEquals(true, isExpectedDmlExOccured);
	}
	@isTest static void given_oppClosed_then_lineitems_should_be_unchangeable(){
		beginSetUp();
		setUpOboOpportunity_result the_setUpOboOpportunity_result = setUpOboOpportunity();
		Id theOppId = the_setUpOboOpportunity_result.theOpps.get('1').Id;
		Id theOppItemId = the_setUpOboOpportunity_result.theOppItems.get('1').Id;
		INSERT NEW KeirSimekiri__c( Target__c = 'OBO_OPPS', SimekiriDate__c = Date.newInstance(2000,01,01) );
		UPDATE New Opportunity(Id = theOppId, StageName = '商談クローズ', Utiagebi__c = Date.newInstance(2019,10,31) );
        endSetUp();

		Boolean isExpectedDmlExOccured = false;
		Test.startTest();
		try{
			DELETE new OpportunityLineItem(Id = theOppItemId);
		}catch(DmlException e){
			isExpectedDmlExOccured = true;
		}
		Test.stopTest();
		System.assertEquals(true, isExpectedDmlExOccured);
	}

	@isTest static void when_simekiri_then_seikyumeisais_should_get_into_uninsertable(){
		beginSetUp();
		setUpOboOpportunity_result the_setUpOboOpportunity_result = setUpOboOpportunity();
		Id theOppId = the_setUpOboOpportunity_result.theOpps.get('1').Id;
		Map<String, OkyakusamaSeikyuMeisai__c> theSeikMeisais = new Map<String, OkyakusamaSeikyuMeisai__c>{
			'1' =>new OkyakusamaSeikyuMeisai__c(
            ServiceSyubetsu__c = 'お坊さん便',
            SeikyuKingaku__c = 1000,
            OpportunityRef__c = theOppId,
            SeikyuHouhou__c = '_',
            Kessaibi__c = Date.today()
        	)
		};
		INSERT NEW KeirSimekiri__c( Target__c = 'OBO_OPPS', SimekiriDate__c = Date.newInstance(2019,10,31) );
		UPDATE New Opportunity(Id = theOppId, StageName = '商談クローズ', Utiagebi__c = Date.newInstance(2019,10,31) );
        endSetUp();

		Boolean isExpectedDmlExOccured = false;
		Test.startTest();
		try{
			INSERT theSeikMeisais.get('1');
		}catch(DmlException e){
			isExpectedDmlExOccured = true;
		}
		Test.stopTest();
		System.assertEquals(true, isExpectedDmlExOccured);
	}
	@isTest static void when_simekiri_then_seikyumeisais_should_get_into_unupdatable(){
		beginSetUp();
		setUpOboOpportunity_result the_setUpOboOpportunity_result = setUpOboOpportunity();
		Id theOppId = the_setUpOboOpportunity_result.theOpps.get('1').Id;
		Map<String, OkyakusamaSeikyuMeisai__c> theSeikMeisais = new Map<String, OkyakusamaSeikyuMeisai__c>{
			'1' =>new OkyakusamaSeikyuMeisai__c(
            ServiceSyubetsu__c = 'お坊さん便',
            SeikyuKingaku__c = 1000,
            OpportunityRef__c = theOppId,
            SeikyuHouhou__c = '_',
            Kessaibi__c = Date.today()
        	)
		};
		INSERT theSeikMeisais.get('1');
		INSERT NEW KeirSimekiri__c( Target__c = 'OBO_OPPS', SimekiriDate__c = Date.newInstance(2019,10,31) );
		UPDATE New Opportunity(Id = theOppId, StageName = '商談クローズ', Utiagebi__c = Date.newInstance(2019,10,31) );
        endSetUp();

		Boolean isExpectedDmlExOccured = false;
		Test.startTest();
		try{
			theSeikMeisais.get('1').SeikyuKingaku__c = 2000;
			UPDATE theSeikMeisais.get('1');
		}catch(DmlException e){
			isExpectedDmlExOccured = true;
		}
		Test.stopTest();
		System.assertEquals(true, isExpectedDmlExOccured);
	}
	@isTest static void when_simekiri_then_seikyumeisais_should_get_into_undeletable(){
		beginSetUp();
		setUpOboOpportunity_result the_setUpOboOpportunity_result = setUpOboOpportunity();
		Id theOppId = the_setUpOboOpportunity_result.theOpps.get('1').Id;
		Map<String, OkyakusamaSeikyuMeisai__c> theSeikMeisais = new Map<String, OkyakusamaSeikyuMeisai__c>{
			'1' =>new OkyakusamaSeikyuMeisai__c(
            ServiceSyubetsu__c = 'お坊さん便',
            SeikyuKingaku__c = 1000,
            OpportunityRef__c = theOppId,
            SeikyuHouhou__c = '_',
            Kessaibi__c = Date.today()
        	)
		};
		INSERT theSeikMeisais.values();
		INSERT NEW KeirSimekiri__c( Target__c = 'OBO_OPPS', SimekiriDate__c = Date.newInstance(2019,10,31) );
		UPDATE New Opportunity(Id = theOppId, StageName = '商談クローズ', Utiagebi__c = Date.newInstance(2019,10,31) );
        endSetUp();

		Boolean isExpectedDmlExOccured = false;
		Test.startTest();
		try{
			DELETE theSeikMeisais.get('1');
		}catch(DmlException e){
			isExpectedDmlExOccured = true;
		}
		Test.stopTest();
		System.assertEquals(true, isExpectedDmlExOccured);
	}
	@isTest static void given_oppClosed_then_seikyumeisais_should_get_into_unchageable(){
		beginSetUp();
		setUpOboOpportunity_result the_setUpOboOpportunity_result = setUpOboOpportunity();
		Id theOppId = the_setUpOboOpportunity_result.theOpps.get('1').Id;
		Map<String, OkyakusamaSeikyuMeisai__c> theSeikMeisais = new Map<String, OkyakusamaSeikyuMeisai__c>{
			'1' =>new OkyakusamaSeikyuMeisai__c(
            ServiceSyubetsu__c = 'お坊さん便',
            SeikyuKingaku__c = 1000,
            OpportunityRef__c = theOppId,
            SeikyuHouhou__c = '_',
            Kessaibi__c = Date.today()
        	)
		};
		INSERT theSeikMeisais.values();
		INSERT NEW KeirSimekiri__c( Target__c = 'OBO_OPPS', SimekiriDate__c = Date.newInstance(2000,01,01) );
		UPDATE New Opportunity(Id = theOppId, StageName = '商談クローズ', Utiagebi__c = Date.newInstance(2019,10,31) );
        endSetUp();

		Boolean isExpectedDmlExOccured = false;
		Test.startTest();
		try{
			DELETE theSeikMeisais.get('1');
		}catch(DmlException e){
			isExpectedDmlExOccured = true;
		}
		Test.stopTest();
		System.assertEquals(true, isExpectedDmlExOccured);
	}

	@isTest static void when_simekiri_then_partneruriages_should_get_into_uninsertable(){
		beginSetUp();
		setUpOboOpportunity_result the_setUpOboOpportunity_result = setUpOboOpportunity();
		Id theOppId = the_setUpOboOpportunity_result.theOpps.get('1').Id;
		INSERT NEW KeirSimekiri__c( Target__c = 'OBO_OPPS', SimekiriDate__c = Date.newInstance(2019,10,31) );
		UPDATE New Opportunity(Id = theOppId, StageName = '商談クローズ', Utiagebi__c = Date.newInstance(2019,10,31) );

        endSetUp();

		Boolean isExpectedDmlExOccured = false;
		Test.startTest();
		Map<String, PatnerUriage__c> thePatnerUriages = new Map<String, PatnerUriage__c>{
			'1' =>new PatnerUriage__c(
            Syodan__c = theOppId,
			Kingaku__c = -1000
        	)
		};
		try{
			INSERT thePatnerUriages.get('1');
		}catch(DmlException e){
			isExpectedDmlExOccured = true;
		}
		Test.stopTest();
		System.assertEquals(true, isExpectedDmlExOccured);
	}
	@isTest static void when_simekiri_then_partneruriages_should_get_into_unupdatable(){
		beginSetUp();
		setUpOboOpportunity_result the_setUpOboOpportunity_result = setUpOboOpportunity();
		Id theOppId = the_setUpOboOpportunity_result.theOpps.get('1').Id;
		Map<String, PatnerUriage__c> thePatnerUriages = new Map<String, PatnerUriage__c>{
			'1' =>new PatnerUriage__c(
            Syodan__c = theOppId,
			Kingaku__c = -1000
        	)
		};
		INSERT thePatnerUriages.get('1');
		INSERT NEW KeirSimekiri__c( Target__c = 'OBO_OPPS', SimekiriDate__c = Date.newInstance(2019,10,31) );
		UPDATE New Opportunity(Id = theOppId, StageName = '商談クローズ', Utiagebi__c = Date.newInstance(2019,10,31) );
        endSetUp();

		Boolean isExpectedDmlExOccured = false;
		Test.startTest();
		try{
			thePatnerUriages.get('1').Kingaku__c = -2000;
			UPDATE thePatnerUriages.get('1');
		}catch(DmlException e){
			isExpectedDmlExOccured = true;
		}
		Test.stopTest();
		System.assertEquals(true, isExpectedDmlExOccured);
	}
	@isTest static void when_simekiri_then_partneruriages_should_get_into_undeletable(){
		beginSetUp();
		setUpOboOpportunity_result the_setUpOboOpportunity_result = setUpOboOpportunity();
		Id theOppId = the_setUpOboOpportunity_result.theOpps.get('1').Id;
		Map<String, PatnerUriage__c> thePatnerUriages = new Map<String, PatnerUriage__c>{
			'1' =>new PatnerUriage__c(
            Syodan__c = theOppId,
			Kingaku__c = -1000
        	)
		};
		INSERT thePatnerUriages.values();
		INSERT NEW KeirSimekiri__c( Target__c = 'OBO_OPPS', SimekiriDate__c = Date.newInstance(2019,10,31) );
		UPDATE New Opportunity(Id = theOppId, StageName = '商談クローズ', Utiagebi__c = Date.newInstance(2019,10,31) );
        endSetUp();

		Boolean isExpectedDmlExOccured = false;
		Test.startTest();
		try{
			DELETE thePatnerUriages.get('1');
		}catch(DmlException e){
			isExpectedDmlExOccured = true;
		}
		Test.stopTest();
		System.assertEquals(true, isExpectedDmlExOccured);
	}
	@isTest static void given_oppClosed_then_partneruriages_should_get_into_unchangeable(){
		beginSetUp();
		setUpOboOpportunity_result the_setUpOboOpportunity_result = setUpOboOpportunity();
		Id theOppId = the_setUpOboOpportunity_result.theOpps.get('1').Id;
		Map<String, PatnerUriage__c> thePatnerUriages = new Map<String, PatnerUriage__c>{
			'1' =>new PatnerUriage__c(
            Syodan__c = theOppId,
			Kingaku__c = -1000
        	)
		};
		INSERT thePatnerUriages.values();
		INSERT NEW KeirSimekiri__c( Target__c = 'OBO_OPPS', SimekiriDate__c = Date.newInstance(2000,01,01) );
		UPDATE New Opportunity(Id = theOppId, StageName = '商談クローズ', Utiagebi__c = Date.newInstance(2019,10,31) );
        endSetUp();

		Boolean isExpectedDmlExOccured = false;
		Test.startTest();
		try{
			DELETE thePatnerUriages.get('1');
		}catch(DmlException e){
			isExpectedDmlExOccured = true;
		}
		Test.stopTest();
		System.assertEquals(true, isExpectedDmlExOccured);
	}

	@isTest static void given_simekiri_then_winlose_should_not_be_changable(){
		beginSetUp();
		setUpOboOpportunity_result the_setUpOboOpportunity_result = setUpOboOpportunity();
		Id theOppId = the_setUpOboOpportunity_result.theOpps.get('1').Id;
		INSERT NEW KeirSimekiri__c( Target__c = 'OBO_OPPS', SimekiriDate__c = Date.newInstance(2019,10,31) );
		UPDATE New Opportunity(Id = theOppId, StageName = '商談クローズ', Utiagebi__c = Date.newInstance(2019,10,31) );
        endSetUp();

		Boolean isExpectedDmlExOccured = false;
		Test.startTest();
		try{
			UPDATE New Opportunity(Id = theOppId, StageName = '決定');
		}catch(DmlException e){
			isExpectedDmlExOccured = true;
		}
		Test.stopTest();
		System.assertEquals(true, isExpectedDmlExOccured);
	}
	@isTest static void before_simekiri_then_winlose_should_be_changable(){
		beginSetUp();
		setUpOboOpportunity_result the_setUpOboOpportunity_result = setUpOboOpportunity();
		Id theOppId = the_setUpOboOpportunity_result.theOpps.get('1').Id;
		INSERT NEW KeirSimekiri__c( Target__c = 'OBO_OPPS', SimekiriDate__c = Date.newInstance(2000,01,01) );
		UPDATE New Opportunity(Id = theOppId, StageName = '商談クローズ', Utiagebi__c = Date.newInstance(2019,10,31) );
        endSetUp();

		Boolean isDmlExOccured = false;
		Test.startTest();
		try{
			UPDATE New Opportunity(Id = theOppId, StageName = '決定');
		}catch(DmlException e){
			isDmlExOccured = true;
		}
		Test.stopTest();
		System.assertEquals(false, isDmlExOccured);
	}

	@isTest static void uriage_into_simekiri_date_is_not_acceptable(){
		beginSetUp();
		setUpOboOpportunity_result the_setUpOboOpportunity_result = setUpOboOpportunity();
		Id theOppId = the_setUpOboOpportunity_result.theOpps.get('1').Id;
		INSERT NEW KeirSimekiri__c( Target__c = 'OBO_OPPS', SimekiriDate__c = Date.newInstance(2019,10,31) );
		UPDATE New Opportunity(Id = theOppId, StageName = '商談クローズ', Utiagebi__c = Date.newInstance(2019,11,01) );
        endSetUp();

		Boolean isExpectedDmlExOccured = false;
		Test.startTest();
		try{
			UPDATE New Opportunity(Id = theOppId, Utiagebi__c = Date.newInstance(2019,10,31) );
		}catch(DmlException e){
			isExpectedDmlExOccured = true;
		}
		Test.stopTest();
		System.assertEquals(true, isExpectedDmlExOccured);
	}

	@isTest static void given_simekiri_then_sokyakusaki_soryo_not_be_changable(){
		beginSetUp();
		setUpOboOpportunity_result the_setUpOboOpportunity_result = setUpOboOpportunity();
		Id theOppId = the_setUpOboOpportunity_result.theOpps.get('1').Id;
		Id theObosanbinId = the_setUpOboOpportunity_result.theObosanbins.get('1').Id;
		INSERT NEW KeirSimekiri__c( Target__c = 'OBO_OPPS', SimekiriDate__c = Date.newInstance(2019,10,31) );
		UPDATE New Opportunity(Id = theOppId, StageName = '商談クローズ', Utiagebi__c = Date.newInstance(2019,10,31) );
        endSetUp();

		Boolean isExpectedDmlExOccured = false;
		Test.startTest();
		try{
			UPDATE New Obosanbin__c(Id = theObosanbinId, ObosanbinKeiyakuMadoguchi__c = null);
		}catch(DmlException e){
			isExpectedDmlExOccured = true;
		}
		Test.stopTest();
		System.assertEquals(true, isExpectedDmlExOccured);
	}
	@isTest static void given_oppClosed_then_sokyakusaki_soryo_not_be_changable(){
		beginSetUp();
		setUpOboOpportunity_result the_setUpOboOpportunity_result = setUpOboOpportunity();
		Id theOppId = the_setUpOboOpportunity_result.theOpps.get('1').Id;
		Id theObosanbinId = the_setUpOboOpportunity_result.theObosanbins.get('1').Id;
		INSERT NEW KeirSimekiri__c( Target__c = 'OBO_OPPS', SimekiriDate__c = Date.newInstance(2000,01,01) );
		UPDATE New Opportunity(Id = theOppId, StageName = '商談クローズ', Utiagebi__c = Date.newInstance(2019,10,31) );
        endSetUp();

		Boolean isExpectedDmlExOccured = false;
		Test.startTest();
		try{
			UPDATE New Obosanbin__c(Id = theObosanbinId, ObosanbinKeiyakuMadoguchi__c = null);
		}catch(DmlException e){
			isExpectedDmlExOccured = true;
		}
		Test.stopTest();
		System.assertEquals(true, isExpectedDmlExOccured);
	}

	@isTest static void lock_rule_should_be_deactivatable_exceptionally(){
		beginSetUp();
		setUpOboOpportunity_result the_setUpOboOpportunity_result = setUpOboOpportunity();
		Id theOppId = the_setUpOboOpportunity_result.theOpps.get('1').Id;
		Map<String, OkyakusamaSeikyuMeisai__c> theSeikMeisais = new Map<String, OkyakusamaSeikyuMeisai__c>{
			'1' =>new OkyakusamaSeikyuMeisai__c(
            ServiceSyubetsu__c = 'お坊さん便',
            SeikyuKingaku__c = 1000,
            OpportunityRef__c = theOppId,
            SeikyuHouhou__c = '_',
            Kessaibi__c = Date.today()
        	)
		};
		INSERT theSeikMeisais.get('1');
		INSERT NEW KeirSimekiri__c( Target__c = 'OBO_OPPS', SimekiriDate__c = Date.newInstance(2019,10,31) );
		UPDATE New Opportunity(Id = theOppId, StageName = '商談クローズ', Utiagebi__c = Date.newInstance(2019,10,31) );
        endSetUp();

		Boolean isDmlExOccured = false;
		Test.startTest();
		try{
			KeirSimeLocks.turnOffLockRule();
			theSeikMeisais.get('1').SeikyuKingaku__c = 2000;
			UPDATE theSeikMeisais.get('1');
			KeirSimeLocks.turnOnLockRule();
		}catch(DmlException e){
			isDmlExOccured = true;
		}
		Test.stopTest();
		System.assertEquals(false, isDmlExOccured);
	}
}