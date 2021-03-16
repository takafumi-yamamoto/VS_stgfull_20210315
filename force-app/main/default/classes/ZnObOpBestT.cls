@isTest
public class ZnObOpBestT {
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
	public static void getUpdates(){
		beginSetUp();

        Map<String, Account> theAccounts = new Map<String, Account>{
            '客' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                FirstName = '_', LastName = '_'
            ),
            '対象者' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                FirstName = '_', LastName = '_'
            )
        };
		INSERT theAccounts.values();

		Map<String, BestButsudan__c> theBest = new Map<String, BestButsudan__c>{
			'ベスト' => new BestButsudan__c()
		};
		INSERT theBest.values();

		Map<String, Obosanbin__c> theObos = new Map<String, Obosanbin__c>{
			'お坊' => new Obosanbin__c(Taishosha1Ref__c = theAccounts.get('対象者').Id )
		};
		INSERT theObos.values();

        Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
            'ベスト' => new Opportunity(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','KakuyasuButsudan'),
                Name = '_',
                AccountId = theAccounts.get('客').Id,
                StageName = '_',
				CloseDate = Date.newInstance(2000,1,1),
                BestButsudanRef__c = theBest.get('ベスト').Id
            ),
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

		Opportunity theOldOne = theOpps.get('ベスト');
		Opportunity theNewOne = theOldOne.clone(true);
		theNewOne.ZennkaiOboOppRef__c = theOpps.get('お坊').Id ;

		endSetUp();

		Test.startTest();
		List<BestButsudan__c> theUpdates =
			new ZnObOpBest.ZenkaiOboOppBest()
			.getUpdates(
				new List<Opportunity>{ theNewOne },
				new Map<Id, Opportunity>{ theOldOne.Id => theOldOne }
			);
		Test.stopTest();

		System.AssertEquals(
			theAccounts.get('対象者').Id, 
			theUpdates.get(0).TaishoshaRef__c
		);
	}
}