@isTest
public class KeirSimeLocksSogiT {
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
			new KeirSimeLocksSogi().inClosedOpp_anyChgNotAcceptable( new Opportunity(), new Opportunity() );
		Test.stopTest();
	}
	@isTest public static void OnSimpleYasugo_onSimpleYasugoBeforeUpdate(){

		beginSetUp();
        Map<String, Account> theAccounts = new Map<String, Account>{
            '客' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                FirstName = '_', LastName = '_'
            )
        };
		INSERT theAccounts.values();

        Map<String, SimpleYasugo__c> theSimpleYasugos = new Map<String, SimpleYasugo__c>{
            '葬儀' => new SimpleYasugo__c(
				SeikyushojuryoDay__c = Date.newInstance(2000,1,1)
			)
        };
        INSERT theSimpleYasugos.values();

        Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
            '葬儀' => new Opportunity(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo'),
                Name = '_',
                AccountId = theAccounts.get('客').Id,
                StageName = '商談クローズ',
				CloseDate = Date.newInstance(2000,1,1),
                SimpleYasugoRef__c = theSimpleYasugos.get('葬儀').Id,
				Req_Day__c = Datetime.newInstance(2000,1,1,0,0,0),
				KakuteibiSyodan__c = Datetime.newInstance(2000,1,1,0,0,0),
				Utiagebi__c =  Date.newInstance(2000,1,1)
            )
        };
        INSERT theOpps.values();
		endSetUp();

		List<SimpleYasugo__c> theNewOnes = new List<SimpleYasugo__c>{
			new SimpleYasugo__c( 
				Id = theSimpleYasugos.get('葬儀').Id,
				TaishoshaRef__c = theAccounts.get('客').Id
			)
		};
		Map<Id, SimpleYasugo__c> theOldOnes = new Map<Id, SimpleYasugo__c>{
			theSimpleYasugos.get('葬儀').Id =>
				new SimpleYasugo__c(
					Id = theSimpleYasugos.get('葬儀').Id,
					TaishoshaRef__c = null
				)
		};
		Test.startTest();
			new KeirSimeLocksSogi.OnSimpleYasugo( new KeirSimeLocksChgNotAllows() )
				.onSimpleYasugoBeforeUpdate( theNewOnes, theOldOnes );
		Test.stopTest();
	}
}