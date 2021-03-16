@isTest
public class AnegKekImpQmsT {

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

	@isTest static void run(){

		beginSetUp();

        Map<String, Account> theAccounts01 = new Map<String, Account>{
            'Customer' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                FirstName = '_', LastName = '_'
            )
        };
		INSERT theAccounts01.values();

        Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
            '1' => new Opportunity(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Obosanbin'),
                Name = '_',
                AccountId = theAccounts01.get('Customer').Id,
                StageName = '_',
                CloseDate = system.today(),
                Req_Day__c = Date.today()
            )
        };
        Insert theOpps.values();

		Opportunity theOppVer01 = [SELECT Id, ShodanBango__c FROM Opportunity WHERE Id = :theOpps.get('1').Id ].get(0);

		AnegKekImpData__c theImpData = new AnegKekImpData__c(
			KameitenTorihikiId__c = theOppVer01.ShodanBango__c,
			NpTorihikiId__c = '201910291650',
			KakuteiDate__c = Date.newInstance(2019,10,29),
			KakuteiKingaku__c = 50000,
			SaiteiKingaku__c = 45000,
			AddonKingaku1__c = 1000, AddonKingaku2__c = 2000, AddonKingaku3__c = 3000, AddonKingaku4__c = 4000
		);
		INSERT theImpData;

        endSetUp();
		Test.startTest();
			AnegKekImpQms.run(theImpData.Id);
		Test.stopTest();

		Decimal theExpectedPartnerAzukariKingaku = (theImpData.AddonKingaku1__c + theImpData.AddonKingaku2__c);
		String theExpectedShoriStatus = 'Completed';

		Opportunity theOppVer02 = [SELECT Id, ShodanBango__c, PartnerAzukariKingaku__c FROM Opportunity WHERE Id = :theOpps.get('1').Id ].get(0);
		AnegKekImpData__c theImpDataVer02 = [SELECT Id, ShoriStatus__c FROM AnegKekImpData__c WHERE Id = :theImpData.Id].get(0);
		
		System.assertEquals( theExpectedPartnerAzukariKingaku, theOppVer02.PartnerAzukariKingaku__c );
		System.assertEquals( theExpectedShoriStatus, theImpDataVer02.ShoriStatus__c );
	}

	@isTest static void onAnegKekImpDataAfterInserted(){

		beginSetUp();

        Map<String, Account> theAccounts01 = new Map<String, Account>{
            'Customer' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                FirstName = '_', LastName = '_'
            )
        };
		INSERT theAccounts01.values();

        Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
            '1' => new Opportunity(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Obosanbin'),
                Name = '_',
                AccountId = theAccounts01.get('Customer').Id,
                StageName = '_',
                CloseDate = system.today(),
                Req_Day__c = Date.today()
            )
        };
        Insert theOpps.values();

		Opportunity theOppVer01 = [SELECT Id, ShodanBango__c FROM Opportunity WHERE Id = :theOpps.get('1').Id ].get(0);

		AnegKekImpData__c theImpData = new AnegKekImpData__c(
			KameitenTorihikiId__c = theOppVer01.ShodanBango__c,
			NpTorihikiId__c = '201910291650',
			KakuteiDate__c = Date.newInstance(2019,10,29),
			KakuteiKingaku__c = 50000,
			SaiteiKingaku__c = 45000,
			AddonKingaku1__c = 1000, AddonKingaku2__c = 2000, AddonKingaku3__c = 3000, AddonKingaku4__c = 4000
		);

        endSetUp();
		Test.startTest();
			INSERT theImpData;
		Test.stopTest();
	}
}