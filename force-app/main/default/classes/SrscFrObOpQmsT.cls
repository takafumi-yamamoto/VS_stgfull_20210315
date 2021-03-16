@isTest
public class SrscFrObOpQmsT {

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

	@isTest
	public static void handleQms_exception(){
		Qms__c aQms = new Qms__c();
		INSERT aQms;
		new SrscFrObOpQms().handleQms(aQms);
	}

	@isTest
	public static void QueuingByObo_getQueues(){
		beginSetUp();
        Map<String, Account> theAccounts = new Map<String, Account>{
            '客' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                FirstName = '_', LastName = '_'
            )
        };
		INSERT theAccounts.values();

		Map<String, Obosanbin__c> theObos = new Map<String, Obosanbin__c>{
			'お坊' => new Obosanbin__c(
				ObosanbinKeiyakuMadoguchi__c = null,
				KokubetsuDateTime_Inp__c = null,
				TsuyaDateTime_Inp__c = null,
				KokubetsushikiNichiji__c = null,
				KasoDateTime_Inp__c = null
			)
		};
		INSERT theObos.values();

		Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
			'お坊' => new Opportunity(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Obosanbin'),
                Name = '_',
                AccountId = theAccounts.get('客').Id,
                StageName = '_',
				CloseDate = Date.newInstance(2000,1,1),
				ObosanbinRef__c = theObos.get('お坊').Id
			)
		};
		INSERT theOpps.values();

		Obosanbin__c theOldOne = theObos.get('お坊').clone(true);
		Obosanbin__c theNewOne = theObos.get('お坊').clone(true);
		theNewOne.TsuyaDateTime_Inp__c = Datetime.newInstance(2020,1,1,12,30,0);
		endSetUp();

		Test.startTest();
		List<Qms__c> theQmses = 
			new SrscFrObOpQms.QueuingByObo()
			.getQueues(
				new List<Obosanbin__c>{ theNewOne },
				new Map<Id, Obosanbin__c>{ theOldOne.Id => theOldOne }
			);
		Test.stopTest();

		System.AssertEquals( 1, theQmses.size() );
	}

	@isTest 
	public static void QueuingByOpp_getQueues(){
		beginSetUp();
        Map<String, Account> theAccounts = new Map<String, Account>{
            '客' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                FirstName = '_', LastName = '_'
            )
        };
		INSERT theAccounts.values();

		Map<String, Obosanbin__c> theObos = new Map<String, Obosanbin__c>{
			'お坊' => new Obosanbin__c()
		};
		INSERT theObos.values();

		Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
			'お坊' => new Opportunity(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Obosanbin'),
                Name = '_',
                AccountId = theAccounts.get('客').Id,
                StageName = '除外',
				CloseDate = Date.newInstance(2000,1,1),
				ObosanbinRef__c = theObos.get('お坊').Id
			)
		};
		INSERT theOpps.values();

		Opportunity theOldOne = theOpps.get('お坊').clone(true);
		Opportunity theNewOne = theOpps.get('お坊').clone(true);
		theNewOne.StageName = '決定';
		endSetUp();

		Test.startTest();
		List<Qms__c> theQmses = 
			new SrscFrObOpQms.QueuingByOpp(
				new SrscFrObOpPhase.StageToSchedule()
			)
			.getQueues(
				new List<Opportunity>{ theNewOne },
				new Map<Id, Opportunity>{ theOldOne.Id => theOldOne }
			);
		Test.stopTest();

		System.AssertEquals( 1, theQmses.size() );
	}
}