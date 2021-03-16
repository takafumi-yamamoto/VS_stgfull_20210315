@isTest
public class TeiHehDaiKakinsT {

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

	@isTest static void toribunRate_shouldBe_50Per_when_iraikensu_le_1_eg1(){
		Integer theIraiKensu = 0;
		Decimal theRate_shouldBe = 50;
		Decimal theRate_actual = new TeiHehDaiKakins.IraiCounter().getSougishaToribunRate(theIraiKensu);
		System.AssertEquals(theRate_shouldBe, theRate_actual, 'theRate_actual');
	}
	@isTest static void toribunRate_shouldBe_50Per_when_iraikensu_le_1_eg2(){
		Integer theIraiKensu = 1;
		Decimal theRate_shouldBe = 50;
		Decimal theRate_actual = new TeiHehDaiKakins.IraiCounter().getSougishaToribunRate(theIraiKensu);
		System.AssertEquals(theRate_shouldBe, theRate_actual, 'theRate_actual');
	}
	@isTest static void toribunRate_shouldBe_55Per_when_iraikensu_eq_2(){
		Integer theIraiKensu = 2;
		Decimal theRate_shouldBe = 55;
		Decimal theRate_actual = new TeiHehDaiKakins.IraiCounter().getSougishaToribunRate(theIraiKensu);
		System.AssertEquals(theRate_shouldBe, theRate_actual, 'theRate_actual');
	}
	@isTest static void toribunRate_shouldBe_60Per_when_iraikensu_ge_3_eg1(){
		Integer theIraiKensu = 3;
		Decimal theRate_shouldBe = 60;
		Decimal theRate_actual = new TeiHehDaiKakins.IraiCounter().getSougishaToribunRate(theIraiKensu);
		System.AssertEquals(theRate_shouldBe, theRate_actual, 'theRate_actual');
	}
	@isTest static void toribunRate_shouldBe_60Per_when_iraikensu_ge_3_eg2(){
		Integer theIraiKensu = 4;
		Decimal theRate_shouldBe = 60;
		Decimal theRate_actual = new TeiHehDaiKakins.IraiCounter().getSougishaToribunRate(theIraiKensu);
		System.AssertEquals(theRate_shouldBe, theRate_actual, 'theRate_actual');
	}

	@isTest static void if_LastKakinCanNotBeIdentified_Then_reportErr(){

		beginSetUp();
		Map<String, Account> theAccounts = new Map<String, Account>{
			'Sogisya' => new Account(
				RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Sogisya').getRecordTypeId(),
				Name = '_'
			)
		};
		INSERT theAccounts.values();

		Map<String, Keiyaku__c> theKeiyakus = new Map<String, Keiyaku__c>{
			'TeraPass' => new Keiyaku__c(
				RecordTypeId = Schema.SObjectType.Keiyaku__c.getRecordTypeInfosByDeveloperName().get('SouryoTehaiDaiko').getRecordTypeId(),
				KeiyakuType__c = 'てらぱす-定額課金',
				Teikeisaki__c = theAccounts.get('Sogisya').Id,
				KeiyakuJokyo__c = '契約中'
			)
		};
		INSERT theKeiyakus.values();
		
		endSetUp();

		String theKeiyakuBango = 
			[SELECT Id, KeiyakuBango__c FROM Keiyaku__c WHERE Id = :theKeiyakus.get('TeraPass').Id ].get(0).KeiyakuBango__c;

		Boolean theExpected = true;
		Boolean theActual;

		Test.startTest();
		try{
			TeiHehDaiKakins.renew( theKeiyakuBango, Date.newInstance(2019,12,21) );
		}catch(TeiHehDaiKakins.LastKakinCanNotBeIdentifiedException ex){
			theActual = true;
		}
		Test.stopTest();

		System.AssertEquals(theExpected, theActual, 'theActual');
	}

	@isTest static void renew(){

		beginSetUp();
		Map<String, Account> theAccounts = new Map<String, Account>{
			'Sogisya' => new Account(
				RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Sogisya').getRecordTypeId(),
				Name = '_'
			),
			'Customer' => new Account(
				RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId(),
				FirstName = '_', LastName = '_'
			)
		};
		INSERT theAccounts.values();

		Map<String, Keiyaku__c> theKeiyakus = new Map<String, Keiyaku__c>{
			'TeraPass' => new Keiyaku__c(
				RecordTypeId = Schema.SObjectType.Keiyaku__c.getRecordTypeInfosByDeveloperName().get('SouryoTehaiDaiko').getRecordTypeId(),
				KeiyakuType__c = 'てらぱす-定額課金',
				Teikeisaki__c = theAccounts.get('Sogisya').Id,
				KeiyakuJokyo__c = '契約中'
			)
		};
		INSERT theKeiyakus.values();
		
		Map<String, TeiHehDaiKakinSchEnt__c> theKakins = new Map<String, TeiHehDaiKakinSchEnt__c>{
			'Last' => new TeiHehDaiKakinSchEnt__c(
				KeiyakuRef__c = theKeiyakus.get('TeraPass').Id,
				BeginDate__c = Date.newInstance(2019,12,1),
				EndDate__c = Date.newInstance(2019,12,31),
				Kingaku__c = 10000
			)
		};
		INSERT theKakins.values();

		String theSogishaBango = [SELECT TorihikisakiBango__c FROM Account WHERE Id = :theAccounts.get('Sogisya').Id].get(0).TorihikisakiBango__c;
		Map<String, TerapToiRec__c> theTerapToiRecs = new Map<String, TerapToiRec__c>{
			'1' => new TerapToiRec__c(
				SogishaTorihikisakiBango__c = theSogishaBango, ToribunRateYmApplyingFor__c = Date.newInstance(2020,1,1)
			),
			'2' => new TerapToiRec__c(
				SogishaTorihikisakiBango__c = theSogishaBango, ToribunRateYmApplyingFor__c = Date.newInstance(2020,1,1)
			)
		};
		INSERT theTerapToiRecs.values();
		Todays.setInstance( new Todays.TodayStub().setNow( Date.newInstance(2019,12,1) ) );
		endSetUp();

		String theKeiyakuBango = 
			[SELECT Id, KeiyakuBango__c FROM Keiyaku__c WHERE Id = :theKeiyakus.get('TeraPass').Id ].get(0).KeiyakuBango__c;

		Boolean theExpected = true;
		Boolean theActual = false;

		Test.startTest();
		TeiHehDaiKakins.renew( theKeiyakuBango, Date.newInstance(2019,12,21) );
		Test.stopTest();

		theActual = 
			[
				SELECT Id
				FROM TeiHehDaiKakinSchEnt__c
				WHERE KeiyakuRef__c = :theKeiyakus.get('TeraPass').Id
				AND BeginDate__c = :Date.newInstance(2020,1,1)
				AND EndDate__c = :Date.newInstance(2020,1,31)
				AND Kingaku__c = 10000
				AND SogishaTesuryoToribunRitsu__c = 55
			]
			.size() == 1;
		
		System.AssertEquals(theExpected, theActual, 'theActual');
	}

	@isTest static void newKakin_should_NotBeCreated_if_SamePeriodIsDefined(){

		beginSetUp();
		Map<String, Account> theAccounts = new Map<String, Account>{
			'Sogisya' => new Account(
				RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Sogisya').getRecordTypeId(),
				Name = '_'
			)
		};
		INSERT theAccounts.values();

		Map<String, Keiyaku__c> theKeiyakus = new Map<String, Keiyaku__c>{
			'TeraPass' => new Keiyaku__c(
				RecordTypeId = Schema.SObjectType.Keiyaku__c.getRecordTypeInfosByDeveloperName().get('SouryoTehaiDaiko').getRecordTypeId(),
				KeiyakuType__c = 'てらぱす-定額課金',
				Teikeisaki__c = theAccounts.get('Sogisya').Id,
				KeiyakuJokyo__c = '契約中'
			)
		};
		INSERT theKeiyakus.values();
		
		Map<String, TeiHehDaiKakinSchEnt__c> theKakins = new Map<String, TeiHehDaiKakinSchEnt__c>{
			'Last' => new TeiHehDaiKakinSchEnt__c(
				KeiyakuRef__c = theKeiyakus.get('TeraPass').Id,
				BeginDate__c = Date.newInstance(2019,12,1),
				EndDate__c = Date.newInstance(2100,12,31)
			),
			'PreDefined' => new TeiHehDaiKakinSchEnt__c(
				KeiyakuRef__c = theKeiyakus.get('TeraPass').Id,
				BeginDate__c = Date.newInstance(2020,1,1),
				EndDate__c = Date.newInstance(2020,1,31)
			)
		};
		INSERT theKakins.values();
		endSetUp();

		String theKeiyakuBango = 
			[SELECT Id, KeiyakuBango__c FROM Keiyaku__c WHERE Id = :theKeiyakus.get('TeraPass').Id ].get(0).KeiyakuBango__c;

		Integer theCount_Expected = 1;
		Integer theCount_Actual = 0;

		Test.startTest();
		TeiHehDaiKakins.renew( theKeiyakuBango, Date.newInstance(2019,12,21) );
		Test.stopTest();

		theCount_Actual = 
			[
				SELECT Id
				FROM TeiHehDaiKakinSchEnt__c
				WHERE KeiyakuRef__c = :theKeiyakus.get('TeraPass').Id
				AND BeginDate__c = :Date.newInstance(2020,1,1)
				AND EndDate__c = :Date.newInstance(2020,1,31)
			]
			.size();
		
		System.AssertEquals(theCount_Expected, theCount_Actual, 'theCount_Actual');
	}

	@isTest static void start(){
		beginSetUp();
		Map<String, Account> theAccounts = new Map<String, Account>{
			'Sogisya' => new Account(
				RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Sogisya').getRecordTypeId(),
				Name = '_'
			)
		};
		INSERT theAccounts.values();

		Map<String, Keiyaku__c> theKeiyakus = new Map<String, Keiyaku__c>{
			'TeraPass' => new Keiyaku__c(
				RecordTypeId = Schema.SObjectType.Keiyaku__c.getRecordTypeInfosByDeveloperName().get('SouryoTehaiDaiko').getRecordTypeId(),
				KeiyakuType__c = 'てらぱす-定額課金',
				Teikeisaki__c = theAccounts.get('Sogisya').Id,
				KeiyakuJokyo__c = '契約中'
			)
		};
		INSERT theKeiyakus.values();
        endSetUp();

		Test.startTest();
		TeiHehDaiKakins.start( Todays.date() );
		Test.stopTest();
	}
}