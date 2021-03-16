@isTest
public class WaribikiShohinAdd_201912T {
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
            '後払い手数料' => new Product2(
               Name = '後払いご利用料金', ShohinBango__c = 'SBG-0002010', IsActive = true
            ),
            'クーポン' => new Product2(
            Name = 'クーポン', ShohinBango__c = 'SBG-TEST002', IsActive = true, DataKubun__c = '3:クーポン'
            )
        };
        INSERT theProds.Values();

        Map<String, PricebookEntry> theProdEntries = new Map<String, PricebookEntry>{
            '通常商品' => new PricebookEntry(
                Pricebook2Id = Test.getStandardPricebookId(), IsActive = true,
                Product2Id = theProds.get('通常商品').Id, UnitPrice = 100000
            ),
            'クーポン' => new PricebookEntry(
                Pricebook2Id = Test.getStandardPricebookId(), IsActive = true,
                Product2Id = theProds.get('クーポン').Id, UnitPrice = -10000
            ),
            '後払い手数料' => new PricebookEntry(
                Pricebook2Id = Test.getStandardPricebookId(), IsActive = true,
                Product2Id = theProds.get('後払い手数料').Id, UnitPrice = 10000
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
        String theShodanBango = [SELECT Id,ShodanBango__c FROM Opportunity WHERE Id = : theOpps.get('シンプル安豪').Id ].get(0).ShodanBango__c;

        Map<String, OpportunityLineItem> theOppItems = new Map<String, OpportunityLineItem>{
            '通常商品' => new OpportunityLineItem(
                OpportunityId = theOpps.get('シンプル安豪').Id, Product2Id = theProds.get('通常商品').Id, TotalPrice = 100000
            ),
            'クーポン' => new OpportunityLineItem(
                OpportunityId = theOpps.get('シンプル安豪').Id, Product2Id = theProds.get('クーポン').Id, TotalPrice = -10000
            )
        };
        INSERT theOppItems.values();

    	Api_V1_Sogsok_SogiWaribikiList.Data theReqBody = new Api_V1_Sogsok_SogiWaribikiList.Data();
        theReqBody.opp_code = theShodanBango;
        theReqBody.plan_code = theProds.get('通常商品').ShohinBango__c;

        RestRequest theReq = new RestRequest();
		theReq.httpMethod = 'POST';
		theReq.requestBody = Blob.valueof( JSON.Serialize(theReqBody) );

        RestContext.request = theReq;
        RestContext.response= new RestResponse();

        endSetUp();
        Test.startTest();
        Api_V1_Sogsok_SogiWaribikiList.doPost();
        Test.stopTest();
    }

    @isTest
    public static void setBenefitPlanSet(){
        new WaribikiShohinAdd_201912().setBenefitPlanSet();
    }
}