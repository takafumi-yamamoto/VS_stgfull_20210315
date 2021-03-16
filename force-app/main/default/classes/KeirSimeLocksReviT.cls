@isTest
public class KeirSimeLocksReviT {
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

	@isTest public static void inClosedOpp_anyChgNotAcceptable(){
		Test.startTest();
			new KeirSimeLocksRevi().inClosedOpp_anyChgNotAcceptable( new Opportunity(), new Opportunity() );
		Test.stopTest();
	}
	@isTest public static void OnSougiRevi_onSougiReviBeforeUpdate(){

		beginSetUp();
        Map<String, Account> theAccounts = new Map<String, Account>{
            '客' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                FirstName = '_', LastName = '_'
            ),
            '葬儀社' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Sogisya'),
                Name = '_'
            )
        };
		INSERT theAccounts.values();

		Map<String, Keiyaku__c> theKeiyakus = new Map<String, Keiyaku__c>{
			'レビ' => new Keiyaku__c(
				RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Keiyaku__c','SougiRevi'),
				Teikeisaki__c = theAccounts.get('葬儀社').Id
			)
		};
		INSERT theKeiyakus.values();

        Map<String, SougiRev__c> theRevis = new Map<String, SougiRev__c>{
            'レビ' => new SougiRev__c()
        };
        INSERT theRevis.values();

        Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
            'レビ' => new Opportunity(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SougiRev'),
                Name = '_',
                AccountId = theAccounts.get('客').Id,
                StageName = '商談クローズ',
				CloseDate = Date.newInstance(2000,1,1),
                SogiReviRef__c = theRevis.get('レビ').Id,
				KakuteibiSyodan__c = Datetime.newInstance(2000,1,1,0,0,0)
            )
        };
        INSERT theOpps.values();
		endSetUp();

		List<SougiRev__c> theNewOnes = new List<SougiRev__c>{
			new SougiRev__c( 
				Id = theRevis.get('レビ').Id,
				KetteiSogisya__c = theKeiyakus.get('レビ').Id
			)
		};
		Map<Id, SougiRev__c> theOldOnes = new Map<Id, SougiRev__c>{
			theRevis.get('レビ').Id =>
				new SougiRev__c(
					Id = theRevis.get('レビ').Id,
					KetteiSogisya__c = null
				)
		};
		Test.startTest();
			new KeirSimeLocksRevi.OnSougiRevi( new KeirSimeLocksChgNotAllows() )
				.onSougiReviBeforeUpdate( theNewOnes, theOldOnes );
		Test.stopTest();
	}
}