@isTest
public class Ctl_WaribikiShouhinT {

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

          Map<String, Product2> theProds = new Map<String, Product2>{
               '通常商品' => new Product2(
               Name = '火葬式 無宗教プラン', ShohinBango__c = 'SBG-0003002', IsActive = true
               ),
               '割引商品' => new Product2(
               Name = '後払いご利用料金', ShohinBango__c = 'SBG-0002010', IsActive = true
               )
          };
		INSERT theProds.Values();

          Map<String, PricebookEntry> theProdEntries = new Map<String, PricebookEntry>{
               '通常商品' => new PricebookEntry(
                    Pricebook2Id = Test.getStandardPricebookId(), IsActive = true,
                    Product2Id = theProds.get('通常商品').Id, UnitPrice = 100000
               ),
               '割引商品' => new PricebookEntry(
                    Pricebook2Id = Test.getStandardPricebookId(), IsActive = true,
                    Product2Id = theProds.get('割引商品').Id, UnitPrice = -10000
               )
          };
		INSERT theProdEntries.values();

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
                    SimpleYasugoRef__c = theSimpleYasugos.get('シンプル安豪').Id,
                    KiboShiharaiHouhou__c = '後払い（GMO）'
               )
          };
          INSERT theOpps.values();

          endSetUp();
          Test.startTest();
               INSERT New OpportunityLineItem(
                    OpportunityId = theOpps.get('シンプル安豪').Id, Product2Id = theProds.get('通常商品').Id
               );
          Test.stopTest();
     }
}