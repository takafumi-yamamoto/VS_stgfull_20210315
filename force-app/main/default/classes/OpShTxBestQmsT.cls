@isTest
public class OpShTxBestQmsT {
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
	public static void Runner_getUpdate(){
		beginSetUp();

        Map<String, Account> theAccounts = new Map<String, Account>{
            '客' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                FirstName = '_', LastName = '_'
            )
        };
		INSERT theAccounts.values();

		Map<String, BestButsudan__c> theBest = new Map<String, BestButsudan__c>{
			'ベスト' => new BestButsudan__c(TodokesakiName__c = '届け先名' )
		};
		INSERT theBest.values();
	
        Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
            'ベスト' => new Opportunity(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','KakuyasuButsudan'),
                Name = '_',
                AccountId = theAccounts.get('客').Id,
                StageName = '_',
				CloseDate = Date.newInstance(2000,1,1),
                BestButsudanRef__c = theBest.get('ベスト').Id
            )
        };
        INSERT theOpps.values();

		String theShodanBango = 
			[ SELECT Id, ShodanBango__c FROM Opportunity WHERE Id = :theOpps.get('ベスト').Id ]
			.get(0)
			.ShodanBango__c;

		endSetUp();
		Test.startTest();
		Opportunity theUpdate = new OpShTxBestQms.Runner().getUpdate(theShodanBango);
		Test.stopTest();

		System.AssertEquals(
			'届け先名',
			theUpdate.NohinSakiMei__c
		);
	}

	@isTest
	public static void Queuing_getQueues(){
		beginSetUp();

        Map<String, Account> theAccounts = new Map<String, Account>{
            '客' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                FirstName = '_', LastName = '_'
            )
        };
		INSERT theAccounts.values();

		Map<String, BestButsudan__c> theBest = new Map<String, BestButsudan__c>{
			'ベスト' => new BestButsudan__c()
		};
		INSERT theBest.values();
	
        Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
            'ベスト' => new Opportunity(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','KakuyasuButsudan'),
                Name = '_',
                AccountId = theAccounts.get('客').Id,
                StageName = '_',
				CloseDate = Date.newInstance(2000,1,1),
                BestButsudanRef__c = theBest.get('ベスト').Id
            )
        };
        INSERT theOpps.values();
		endSetUp();

		BestButsudan__c theOldOne = theBest.get('ベスト');
		BestButsudan__c theNewOne = theOldOne.clone(true);
		theNewOne.TodokesakiTelNo__c = '届け先電話番号';

		Test.startTest();
		List<Qms__c> theQmses = 
			new OpShTxBestQms.Queuing().getQueues(
				new List<BestButsudan__c>{ theNewOne },
				new Map<Id, BestButsudan__c>{ theOldOne.Id => theOldOne }
			);
		Test.stopTest();

		System.AssertEquals(
			1,
			theQmses.size()
		);
	}

	@isTest
	public static void handleQms_exception(){

		beginSetUp();
		Qms__c aQms = new Qms__c();
		INSERT aQms;
		endSetUp();

		Test.startTest();
			new OpShTxBestQms().handleQms(aQms);
		Test.stopTest();

		String theShoriStatus = 
			[ SELECT Id, ShoriStatus__c FROM Qms__c WHERE Id = :aQms.Id ]
			.get(0)
			.ShoriStatus__c;
		System.AssertEquals( 'Failed', theShoriStatus);
	}

}