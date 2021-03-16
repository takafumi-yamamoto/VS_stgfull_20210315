@isTest
public class SpfyOppLitmsSvcT {
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
    @isTest public static void getOppLineItems() {
        beginSetUp();
        Map<String, Product2> theProds = new Map<String, Product2>{
            'test-code' => new Product2(
                Name = '_',
                IsActive = true,
                ShohinBango__c = 'test-code'
            )
        };
        INSERT theProds.values();

        Map<String, PricebookEntry> theProdEntries = new Map<String, PricebookEntry>{
            '1' => new PricebookEntry(
                Pricebook2Id = Test.getStandardPricebookId(),
                Product2 = new Product2(ShohinBango__c = 'test-code'),
                UnitPrice = 1000,
                IsActive = true
           )
        };
        INSERT theProdEntries.values();

        Map<String, Account> theAccounts = new Map<String, Account>{
            '客' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                FirstName = '_', LastName = '_'
            )
        };
        INSERT theAccounts.values();

        Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
            'ベスト' => new Opportunity(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','KakuyasuButsudan'),
                Name = '_',
                AccountId = theAccounts.get('客').Id,
                StageName = '_',
                CloseDate = Date.newInstance(2000,1,1),
                Pricebook2Id = Test.getStandardPricebookId()
            )
        };
        INSERT theOpps.values();

        Map<String, OpportunityLineItem> theOppItems = new Map<String, OpportunityLineItem>{
            '1' => new OpportunityLineItem(
                OpportunityId = theOpps.get('ベスト').Id,
                Product2Id = theProds.get('test-code').Id,
                TotalPrice = 1000
            )
        };
        INSERT theOppItems.values();
        endSetUp();

        Test.startTest();
        SpfyOppLitmsSvc.getOppLineItems( theOpps.get('ベスト').Id );
        Test.stopTest();

    }
}