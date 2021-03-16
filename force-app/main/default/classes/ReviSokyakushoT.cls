@isTest
public class ReviSokyakushoT {

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
    
    @isTest public static void print(){
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
            '商談' => new Opportunity(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SougiRev'),
                Name = '_',
                AccountId = theAccounts.get('客').Id,
                StageName = '_',
				Req_Day__c = Datetime.newInstance(2000,1,1,0,0,0),
				CloseDate = Date.newInstance(2000,1,1),
                SogiReviRef__c = theRevis.get('レビ').Id
            )
        };
        INSERT theOpps.values();
        endSetUp();

        Test.startTest();
        new ReviSokyakusho().print( theOpps.get('商談').Id, 'a_file_name' );
        Test.stopTest();
    }
}