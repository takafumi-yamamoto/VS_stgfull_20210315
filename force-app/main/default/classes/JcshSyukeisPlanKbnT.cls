@isTest public class JcshSyukeisPlanKbnT {

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
    @isTest public static void PlanKbn_By_OppLine_Mapper_get_plan_kubun(){
        beginSetUp();
        Map<String, Product2> theProds = new Map<String, Product2>{
            '葬儀プラン-1' => new Product2(
                Name = '_',
                IsActive = true,
                ShohinBango__c = '葬儀プラン-1',
                SougiPlan__c = true
            )
         };
         Map<String, PricebookEntry> theProdEntries = new Map<String, PricebookEntry>{
             '葬儀プラン価格-1' => new PricebookEntry(
                 Pricebook2Id = Test.getStandardPricebookId(),
                 Product2 = new Product2(ShohinBango__c = '葬儀プラン-1'),
                 UnitPrice = 1000,
                 IsActive = true
            )
         };
         DATABASE.INSERT(new SObject[] { 
             theProds.get('葬儀プラン-1'), theProdEntries.get('葬儀プラン価格-1')
         });

         Map<String, Account> theAccounts = new Map<String, Account>{
            '客-1' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                FirstName = '_', LastName = '_'
            )
        };
        INSERT theAccounts.values();
        
        Map<String, SimpleYasugo__c> theSimpleYasugos = new Map<String, SimpleYasugo__c>{
            'シンプル-1' => new SimpleYasugo__c()
        };
        INSERT theSimpleYasugos.values();

        Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
            '葬儀商談-1' => new Opportunity(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo'),
                Name = '_',
                AccountId = theAccounts.get('客-1').Id,
                StageName = '_',
				Req_Day__c = Datetime.newInstance(2020,1,1,0,0,0),
				KakuteibiSyodan__c = Datetime.newInstance(2020,1,1,0,0,0),
				CloseDate = Date.newInstance(2020,1,1),
                SimpleYasugoRef__c = theSimpleYasugos.get('シンプル-1').Id,
                Pricebook2Id = Test.getStandardPricebookId()
            )
        };
        INSERT theOpps.values();

        Map<String, OpportunityLineItem> theOppItems = new Map<String, OpportunityLineItem>{
            '商談商品-1' => new OpportunityLineItem(
                OpportunityId = theOpps.get('葬儀商談-1').Id,
                Product2Id = theProds.get('葬儀プラン-1').Id,
                TotalPrice = 10000
            )
        };
        INSERT theOppItems.values();

        Opportunity a_opp = 
            [
                SELECT Id,
                (
                    SELECT Id, 
                    Product2.SougiPlan__c,
                    Product2.ShohinBango__c
                    FROM OpportunityLineItems
                )
                FROM Opportunity
                WHERE Id = :theOpps.get('葬儀商談-1').Id
            ].get(0);
        endSetUp();

        Test.startTest();
        new JcshSyukeisPlanKbn.PlanKbn_By_OppLine_Mapper()
        .get_plan_kubun(
            a_opp
        );
        Test.stopTest();
    }
}