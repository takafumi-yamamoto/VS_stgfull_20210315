@isTest
public class Trg_MitsumoriTeiansyoT {

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
	public static void OnBeforeInsert(){

		beginSetUp();

        Map<String, Account> theAccounts = new Map<String, Account>{
            'Customer' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                FirstName = '_', LastName = '_'
            )
        };
		INSERT theAccounts.values();

		Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
			'1' => new Opportunity(
				Name = '_',
				StageName = '_',
				CloseDate = Date.newInstance(2020,1,1),
				AccountId = theAccounts.get('Customer').Id
			)
		};
		INSERT theOpps.values();

		endSetUp();

		Test.startTest();
		INSERT New MitsumoriTeiansyo__c( ShodanRef__c = theOpps.get('1').Id );
		Test.stopTest();

	}

}