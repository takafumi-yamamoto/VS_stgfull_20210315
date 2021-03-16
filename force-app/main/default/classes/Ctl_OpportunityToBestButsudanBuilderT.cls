@isTest
public class Ctl_OpportunityToBestButsudanBuilderT {

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

    @isTest public static void getOpportunityServicePairList() {
        beginSetUp();
        Map<String, Account> theAccounts = new Map<String, Account>{
            '客' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                FirstName = '_', LastName = '_'
            )
        };
        INSERT theAccounts.values();

        Map<String, Case> theCases = new Map<String, Case>{
            'Case' => new Case(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','BestButsudanOtoiawase'),
                CreatedDate = Datetime.now(),
                Origin = 'メール',
                Description = 'test'
            )
        };
        INSERT theCases.values();

        Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
            'ベスト' => new Opportunity(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','KakuyasuButsudan'),
                Name = '_',
                AccountId = theAccounts.get('客').Id,
                StageName = '_',
                CloseDate = Date.newInstance(2000,1,1),
                Pricebook2Id = Test.getStandardPricebookId(),
                CaseRef__c = theCases.get('Case').Id
            )
        };
        endSetUp();

        Test.startTest();
        Ctl_OpportunityToBestButsudanBuilder theBuilder = new Ctl_OpportunityToBestButsudanBuilder();
        theBuilder.addOpp( theOpps.get('ベスト') );
        theBuilder.getOpportunityServicePairList();
        Test.stopTest();
    }
}