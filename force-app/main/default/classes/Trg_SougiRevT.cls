@isTest
public class Trg_SougiRevT {

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

	@isTest public static void OnAfterInsert(){
		beginSetUp();
		endSetUp();
		Test.startTest();
		INSERT NEW SougiRev__c();
		Test.stopTest();
	}
	@isTest public static void OnAfterUpdate(){
		beginSetUp();

        Map<String, Account> theAccounts = new Map<String, Account>{
            '客' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                FirstName = '_', LastName = '_'
            )
        };
		INSERT theAccounts.values();

        Map<String, SougiRev__c> theRevis = new Map<String, SougiRev__c>{
            'レビ' => new SougiRev__c()
        };
        INSERT theRevis.values();

        Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
            'レビ' => new Opportunity(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SougiRev'),
                Name = '_',
                AccountId = theAccounts.get('客').Id,
                StageName = '_',
				CloseDate = Date.newInstance(2000,1,1),
                SogiReviRef__c = theRevis.get('レビ').Id
            )
        };
        Insert theOpps.values();
		endSetUp();
		Test.startTest();
		UPDATE new SougiRev__c(Id = theRevis.get('レビ').Id );
		Test.stopTest();
	}
}