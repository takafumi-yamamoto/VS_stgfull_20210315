@isTest
public class IhaiGenkoOproT {

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
	public static void IhaiGenkoCreation_print(){
		beginSetUp();
        Map<String, Account> theAccounts = new Map<String, Account>{
            '客' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                FirstName = '_', LastName = '_'
            )
        };
		INSERT theAccounts.values();
		endSetUp();

        Map<String, BestButsudan__c> theButsudans = new Map<String, BestButsudan__c>{
            '仏壇' => new BestButsudan__c()
        };
        INSERT theButsudans.values();

        Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
            '仏壇' => new Opportunity(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','KakuyasuButsudan'),
                Name = '_',
                AccountId = theAccounts.get('客').Id,
                StageName = '_',
				CloseDate = Date.newInstance(2000,1,1),
                BestButsudanRef__c = theButsudans.get('仏壇').Id
            )
        };
        INSERT theOpps.values();

		Test.startTest();
		new IhaiGenkoOpro.IhaiGenkoCreation().print( theOpps.get('仏壇').Id );
		Test.stopTest();
	}
}