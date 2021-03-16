@isTest
public class AutoCreateOkyakusamaSeikyuMeisaiT {
    private static void setUp(){
        Insert new TriggerIsActive__c( name='default', isActive__c=true );
        Insert new JizenWariPlan__c( Code__c='Yoriso' );
        Insert new Account(
            RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','null'),
            FirstName = '_', LastName = '_'
        );
    }

    @isTest static void okyakusamaMeisaiShouldBeCreatedPartner(){
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
               Name = '_',
               IsActive = true
           )
        };
        Insert theProds.values();

        Map<String, PricebookEntry> theProdEntries = new Map<String, PricebookEntry>{
            '1' => new PricebookEntry(
                Pricebook2Id = Test.getStandardPricebookId(),
                Product2Id = theProds.get('1').Id,
                UnitPrice = 1000,
                IsActive = true
           )
        };
        Insert theProdEntries.values();

        Map<String, Obosanbin__c> theObosanbins = new Map<String, Obosanbin__c>{
            '1' => new Obosanbin__c(
                MemorialServicePlan__c = '四十九日法要',
                KokubetsuDateTime_Inp__c = system.today()
            )
        };

        Insert theObosanbins.values();

        Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
            '1' => new Opportunity(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Obosanbin'),
                Name = '_',
                AccountId = theAccounts.get('1').Id,
                StageName = '予約',
                CloseDate = system.today(),
                ObosanbinRef__c = theObosanbins.get('1').Id,
                Req_Day__c = Date.today(),
                Iriguchi__c = 'メール'
            )
        };

        Insert theOpps.values();

        theObosanbins.get('1').KokubetsuDateTime_Inp__c = Date.today();
        Update theObosanbins.get('1');

         Map<String, OpportunityLineItem> theOppItems = new Map<String, OpportunityLineItem>{
            '1' => new OpportunityLineItem(
                OpportunityId = theOpps.get('1').Id,
                Product2Id = theProds.get('1').Id,
                TotalPrice = 1000
           )
        };

        Insert theOppItems.values();

        Test.StartTest();
        theOpps.get('1').StageName = '施行待ち';
        Update theOpps.get('1');
        Test.StopTest();
    }

    @isTest static void okyakusamaMeisaiShouldBeCreatedAmazon(){
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
                Name = '_',
                IsActive = true
            )
        };
        Insert theProds.values();

        Map<String, PricebookEntry> theProdEntries = new Map<String, PricebookEntry>{
            '1' => new PricebookEntry(
                Pricebook2Id = Test.getStandardPricebookId(),
                Product2Id = theProds.get('1').Id,
                UnitPrice = 1000,
                IsActive = true
            )
        };
        Insert theProdEntries.values();

        Map<String, Obosanbin__c> theObosanbins = new Map<String, Obosanbin__c>{
            '1' => new Obosanbin__c(
                MemorialServicePlan__c = '四十九日法要',
                KokubetsuDateTime_Inp__c = system.today()
            )
        };

        Insert theObosanbins.values();

        Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
            '1' => new Opportunity(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Obosanbin'),
                Name = '_',
                AccountId = theAccounts.get('1').Id,
                StageName = '予約',
                CloseDate = system.today(),
                ObosanbinRef__c = theObosanbins.get('1').Id,
                Req_Day__c = Date.today(),
                Iriguchi__c = 'Amazon'
            )
        };

        Insert theOpps.values();

        theObosanbins.get('1').KokubetsuDateTime_Inp__c = Date.today();
        Update theObosanbins.get('1');

        Map<String, OpportunityLineItem> theOppItems = new Map<String, OpportunityLineItem>{
            '1' => new OpportunityLineItem(
                OpportunityId = theOpps.get('1').Id,
                Product2Id = theProds.get('1').Id,
                TotalPrice = 1000
           )
        };

        Insert theOppItems.values();

        Test.StartTest();
        theOpps.get('1').StageName = '施行待ち';
        Update theOpps.get('1');
        Test.StopTest();
    }

    @isTest static void okyakusamaMeisaiShouldBeCreatedYahoo(){
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
                Name = '_',
                IsActive = true
           )
        };
        Insert theProds.values();

        Map<String, PricebookEntry> theProdEntries = new Map<String, PricebookEntry>{
            '1' => new PricebookEntry(
                Pricebook2Id = Test.getStandardPricebookId(),
                Product2Id = theProds.get('1').Id,
                UnitPrice = 1000,
                IsActive = true
            )
        };
        Insert theProdEntries.values();

        Map<String, Obosanbin__c> theObosanbins = new Map<String, Obosanbin__c>{
            '1' => new Obosanbin__c(
                MemorialServicePlan__c = '四十九日法要',
                KokubetsuDateTime_Inp__c = system.today()
            )
        };

        Insert theObosanbins.values();

        Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
            '1' => new Opportunity(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Obosanbin'),
                Name = '_',
                AccountId = theAccounts.get('1').Id,
                StageName = '予約',
                CloseDate = system.today(),
                ObosanbinRef__c = theObosanbins.get('1').Id,
                Req_Day__c = Date.today(),
                Iriguchi__c = 'Yahoo'
            )
        };

        Insert theOpps.values();

        theObosanbins.get('1').KokubetsuDateTime_Inp__c = Date.today();
        Update theObosanbins.get('1');

        Map<String, OpportunityLineItem> theOppItems = new Map<String, OpportunityLineItem>{
            '1' => new OpportunityLineItem(
                OpportunityId = theOpps.get('1').Id,
                Product2Id = theProds.get('1').Id,
                TotalPrice = 1000
           )
        };

        Insert theOppItems.values();

        Test.StartTest();
        theOpps.get('1').StageName = '施行待ち';
        Update theOpps.get('1');
        Test.StopTest();
    }

    @isTest static void okyakusamaMeisaiShouldBeCreatedSousai(){
        setUp();

        Map<String, Account> theAccounts = new Map<String, Account>{
            '1' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                FirstName = '_', LastName = '_'
            )
        };        
        Insert theAccounts.values();

        Map<String, Product2> theProds = new Map<String, Product2>{
            '売上商品' => new Product2(
                Name = '_',
                IsActive = true,
                ShohinKamoku__c = '通常'
            ),
            '申込金商品' => new Product2(
                Name = '_',
                IsActive = true,
                ShohinKamoku__c = '申込金'
            )
        };
        Insert theProds.values();

        Map<String, PricebookEntry> theProdEntries = new Map<String, PricebookEntry>{
            '売上商品' => new PricebookEntry(
                Pricebook2Id = Test.getStandardPricebookId(),
                Product2Id = theProds.get('売上商品').Id,
                UnitPrice = 1000,
                IsActive = true
            ),
            '申込金商品' => new PricebookEntry(
                Pricebook2Id = Test.getStandardPricebookId(),
                Product2Id = theProds.get('申込金商品').Id,
                UnitPrice = 1000,
                IsActive = true
            )
        };
        Insert theProdEntries.values();

        Map<String, Obosanbin__c> theObosanbins = new Map<String, Obosanbin__c>{
            '1' => new Obosanbin__c(
                MemorialServicePlan__c = '四十九日法要',
                KokubetsuDateTime_Inp__c = system.today()
            )
        };

        Insert theObosanbins.values();

        Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
            'お坊商談' => new Opportunity(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Obosanbin'),
                Name = '_',
                AccountId = theAccounts.get('1').Id,
                StageName = '予約',
                CloseDate = system.today(),
                ObosanbinRef__c = theObosanbins.get('1').Id,
                Req_Day__c = Date.today(),
                Iriguchi__c = 'メール'
            )
        };

        Insert theOpps.values();

        Opportunity theObouOppRetrieved = 
        [
            select 
            Id, ObosanbinRef__c, TorihikiShodanRef__c, TorihikiShodanRef__r.RecordType.DeveloperName
            from Opportunity
            where Id = :theOpps.get('お坊商談').Id
        ].get(0);

        Opportunity theSeizenOpp = new Opportunity(
            Id = theObouOppRetrieved.TorihikiShodanRef__c,   
            RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Seizenkeiyaku')
            );
        Update theSeizenOpp;

        theObosanbins.get('1').KokubetsuDateTime_Inp__c = Date.today();
        Update theObosanbins.get('1');

        Map<String, OpportunityLineItem> theOppItems = new Map<String, OpportunityLineItem>{
            '売上' => new OpportunityLineItem(
                OpportunityId = theOpps.get('お坊商談').Id,
                Product2Id = theProds.get('売上商品').Id,
                TotalPrice = 1000
            ),
            '申込金' => new OpportunityLineItem(
                OpportunityId = theSeizenOpp.Id,
                Product2Id = theProds.get('申込金商品').Id,
                TotalPrice = 1000
            )
        };
        Insert theOppItems.values();

        INSERT new OkyakusamaSeikyuMeisai__c(
            ServiceSyubetsu__c = 'お坊さん便',
            SeikyuKingaku__c = 1000,
            OpportunityRef__c = theSeizenOpp.Id,
            SeikyuHouhou__c = 'furikomi',
            Kessaibi__c = Date.today()
        );

        Test.StartTest();
        theOpps.get('お坊商談').StageName = '施行待ち';
        Update theOpps.get('お坊商談');
        Test.StopTest();
    }
}