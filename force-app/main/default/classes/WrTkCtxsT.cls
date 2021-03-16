@isTest
public class WrTkCtxsT {
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
    public static void doTest(){
        beginSetUp();
        Map<String, Account> theAccounts = new Map<String, Account>{
            'Customer' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                FirstName = '_', LastName = '_'
            )
        };
        INSERT theAccounts.values();

        Map<String, SimpleYasugo__c> theSimpleYasugos = new Map<String, SimpleYasugo__c>{
            'シンプル安豪' => new SimpleYasugo__c()
        };
        INSERT theSimpleYasugos.values();

        Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
            'シンプル安豪' => new Opportunity(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo'),
                Name = '_', StageName = '_', Pricebook2Id = Test.getStandardPricebookId(),
                CloseDate = Date.newInstance(2020,1,1),
                AccountId = theAccounts.get('Customer').Id,
                SimpleYasugoRef__c = theSimpleYasugos.get('シンプル安豪').Id
            )
        };
        INSERT theOpps.values();
		endSetUp();

		Test.startTest();
		new WrTkCtxs().selectContextDataByOppIds( new List<String>{ theOpps.get('シンプル安豪').Id } );
		Test.stopTest();
	}
}