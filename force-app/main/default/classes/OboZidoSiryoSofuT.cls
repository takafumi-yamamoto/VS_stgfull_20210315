@isTest
public class OboZidoSiryoSofuT {
    private static void setUp(){
        Insert new TriggerIsActive__c( name='default', isActive__c=true );
        Insert new JizenWariPlan__c( Code__c='Yoriso' );
        Insert new Account(
            RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','null'),
            FirstName = '_', LastName = '_'
        );
    }

    @isTest
    public static void when_KetteiPhaseChangedToSekomachi_Then_IraishoSofuBi_ShouldBeSet(){
        setUp();

        Map<String, Account> theAccounts = new Map<String, Account>{
            '1' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                FirstName = '_', LastName = '_'
            )
        };        
        Insert theAccounts.values();

        Map<String, Obosanbin__c> theObosanbins = new Map<String, Obosanbin__c>{
            '1' => new Obosanbin__c(MemorialServicePlan__c = '四十九日法要', KokubetsuDateTime_Inp__c = Datetime.now())
        };   
        Insert theObosanbins.values();

        Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
            '1' => new Opportunity(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Obosanbin'),
                Name = '_',
                AccountId = theAccounts.get('1').Id,
                StageName = '決定', SubPhase__c = '依頼書・手配報告書送付',
                CloseDate = system.today()
            )
        };
        Insert theOpps.values();

        theOpps.get('1').ObosanbinRef__c = theObosanbins.get('1').Id;
        Update theOpps.get('1');

        theOpps.get('1').Iriguchi__c = '_';
        Update theOpps.get('1');

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

        List<Obosanbin__c> theActuals =
        [
            SELECT 
            Id, IraiTehaiDate__c
            FROM Obosanbin__c
            WHERE Id = :theObosanbins.get('1').Id
        ];

        System.assertEquals(1, theActuals.size() );
        System.assertEquals(true, theActuals.get(0).IraiTehaiDate__c != null, 'IraiTehaiDate__c should be setted' );
    }
}