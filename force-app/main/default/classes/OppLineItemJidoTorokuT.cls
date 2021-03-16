@isTest
public class OppLineItemJidoTorokuT {
    
    private static void setUp(){
        Insert new TriggerIsActive__c( name='default', isActive__c=true );
        Insert new JizenWariPlan__c( Code__c='Yoriso' );
        Insert new Account(
            RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','null'),
            FirstName = '_', LastName = '_'
        );
    }

	@isTest 
	static void doTest(){
		setUp();

        Map<String, Account> theAccounts = new Map<String, Account>{
            '1' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                FirstName = '_', LastName = '_'
            )
        };        
        Insert theAccounts.values();

        Map<String, Product2> theProds = new Map<String, Product2>{
           '1' => new Product2(
               Name = '_', ShohinBango__c = 'SBG-0000291',
               IsActive = true
           )
       	};
       	Insert theProds.values();

       	Map<String, PricebookEntry> theProdEntries = new Map<String, PricebookEntry>{
           '1' => new PricebookEntry(
               Pricebook2Id = Test.getStandardPricebookId(),
               Product2Id = theProds.get('1').Id,
               UnitPrice = 0,
               IsActive = true
           )
       	};
       	Insert theProdEntries.values();

        Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
            '1' => new Opportunity(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Obosanbin'),
                Name = '_',
                AccountId = theAccounts.get('1').Id,
                StageName = '予約',
                CloseDate = system.today()
            )
        };

        Insert theOpps.values();

        Test.StartTest();
        theOpps.get('1').RyunyumotoService__c = '定額僧侶手配代行';
        Update theOpps.get('1');
        Test.StopTest();
	}
}