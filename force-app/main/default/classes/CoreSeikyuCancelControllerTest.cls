@isTest
public class CoreSeikyuCancelControllerTest {


    @isTest(SeeAllData=true)
    public static void whenCancelSuccess_thenSeikyuAndChildrenShouldBeDeleted(){

        Account theAccount = new Account( Name = '_');
        Insert theAccount;

        Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
            '1' => new Opportunity(
                AccountId = theAccount.Id, 
                Name = '_', StageName = '_', CloseDate = Date.valueOf('1900-01-01')
                ),
            '2' => new Opportunity(
                AccountId = theAccount.Id, 
                Name = '_', StageName = '_', CloseDate = Date.valueOf('1900-01-01')
                ),
            '3' => new Opportunity(
                AccountId = theAccount.Id, 
                Name = '_', StageName = '_', CloseDate = Date.valueOf('1900-01-01')
                )
        };
        Insert theOpps.values();

        OkyakusamaSeikyuMeisai__c theParent = new OkyakusamaSeikyuMeisai__c(
            OpportunityRef__c = theOpps.get('1').Id
            ,SeikyuHouhou__c = 'gmo_credit'
        );
        Insert theParent;

        Map<String, OkyakusamaSeikyuMeisai__c> theChildren = new Map<String,OkyakusamaSeikyuMeisai__c>{
            'child01' => new OkyakusamaSeikyuMeisai__c(
            OpportunityRef__c = theOpps.get('2').Id
            ,SeikyuOya__c = theParent.Id
            ,SeikyuHouhou__c = 'gmo_credit'
            ),
            'child02' => new OkyakusamaSeikyuMeisai__c(
            OpportunityRef__c = theOpps.get('3').Id
            ,SeikyuOya__c = theParent.Id
            ,SeikyuHouhou__c = 'gmo_credit'
            )
        };
        Insert theChildren.values();

        Test.setMock( HttpCalloutMock.class, new Testing_HttpResponseMock().setStatusCode(200) );
        Test.startTest();
        CoreSeikyuCancelController.CancelResult theCancelResult = CoreSeikyuCancelController.processCancel( theParent.Id );
        Test.stopTest();

        System.assertEquals(true, theCancelResult.is_success, 'CancelResult shoul be success');
        
        OkyakusamaSeikyuMeisai__c[] theActuals = [
            select id
            from OkyakusamaSeikyuMeisai__c
            where Id = :theParent.Id or SeikyuOya__c = :theParent.Id
        ];
        System.assertEquals(0, theActuals.size(), 'seikyumeisais should be deleted');
    }

    @isTest(SeeAllData=true)
    public static void whenCancelFail_thenSeikyuAndChildrenShouldNotBeDeleted(){

        Account theAccount = new Account( Name = '_');
        Insert theAccount;

        Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
            '1' => new Opportunity(
                AccountId = theAccount.Id, 
                Name = '_', StageName = '_', CloseDate = Date.valueOf('1900-01-01')
                ),
            '2' => new Opportunity(
                AccountId = theAccount.Id, 
                Name = '_', StageName = '_', CloseDate = Date.valueOf('1900-01-01')
                ),
            '3' => new Opportunity(
                AccountId = theAccount.Id, 
                Name = '_', StageName = '_', CloseDate = Date.valueOf('1900-01-01')
                )
        };
        Insert theOpps.values();

        OkyakusamaSeikyuMeisai__c theParent = new OkyakusamaSeikyuMeisai__c(
            OpportunityRef__c = theOpps.get('1').Id
            ,SeikyuHouhou__c = 'gmo_credit'
        );
        Insert theParent;

        Map<String, OkyakusamaSeikyuMeisai__c> theChildren = new Map<String,OkyakusamaSeikyuMeisai__c>{
            'child01' => new OkyakusamaSeikyuMeisai__c(
            OpportunityRef__c = theOpps.get('2').Id
            ,SeikyuOya__c = theParent.Id
            ,SeikyuHouhou__c = 'gmo_credit'
            ),
            'child02' => new OkyakusamaSeikyuMeisai__c(
            OpportunityRef__c = theOpps.get('3').Id
            ,SeikyuOya__c = theParent.Id
            ,SeikyuHouhou__c = 'gmo_credit'
            )
        };
        Insert theChildren.values();

        Test.setMock( HttpCalloutMock.class, new Testing_HttpResponseMock().setStatusCode(500) );
        Test.startTest();
        CoreSeikyuCancelController.CancelResult theCancelResult = CoreSeikyuCancelController.processCancel( theParent.Id );
        Test.stopTest();

        System.assertEquals(false, theCancelResult.is_success, 'CancelResult shoul be error');
        
        OkyakusamaSeikyuMeisai__c[] theActuals = [
            select id
            from OkyakusamaSeikyuMeisai__c
            where Id = :theParent.Id or SeikyuOya__c = :theParent.Id
        ];
        System.assertEquals(3, theActuals.size(), 'seikyumeisais should not be deleted');
    }

    @isTest(SeeAllData=true)
    public static void whenChild_thenShouldBeError(){

        Account theAccount = new Account( Name = '_');
        Insert theAccount;

        Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
            '1' => new Opportunity(
                AccountId = theAccount.Id, 
                Name = '_', StageName = '_', CloseDate = Date.valueOf('1900-01-01')
                )
        };
        Insert theOpps.values();

        OkyakusamaSeikyuMeisai__c theParent = new OkyakusamaSeikyuMeisai__c(
            OpportunityRef__c = theOpps.get('1').Id
            ,SeikyuHouhou__c = 'gmo_credit'
        );
        Insert theParent;

        Map<String, OkyakusamaSeikyuMeisai__c> theChildren = new Map<String,OkyakusamaSeikyuMeisai__c>{
            'child01' => new OkyakusamaSeikyuMeisai__c(
            OpportunityRef__c = theOpps.get('1').Id
            ,SeikyuOya__c = theParent.Id
            ,SeikyuHouhou__c = 'gmo_credit'
            )
        };
        Insert theChildren.values();

        Test.setMock( HttpCalloutMock.class, new Testing_HttpResponseMock().setStatusCode(200) );
        Test.startTest();
        CoreSeikyuCancelController.CancelResult theCancelResult = CoreSeikyuCancelController.processCancel( theChildren.get('child01').Id );
        Test.stopTest();

        System.assertEquals(false, theCancelResult.is_success, 'CancelResult shoul be error');
        
    }

    @isTest(SeeAllData=true)
    public static void whenUriageKakuteiZumi_thenShouldBeError(){

        Account theAccount = new Account( Name = '_');
        Insert theAccount;

        Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
            '1' => new Opportunity(
                AccountId = theAccount.Id, 
                Name = '_', StageName = '_', CloseDate = Date.valueOf('1900-01-01')
                )
        };
        Insert theOpps.values();

        OkyakusamaSeikyuMeisai__c theParent = new OkyakusamaSeikyuMeisai__c(
            OpportunityRef__c = theOpps.get('1').Id
            ,SeikyuStatus__c = '売上確定済'
            ,SeikyuHouhou__c = 'gmo_credit'
        );
        Insert theParent;

        Test.setMock( HttpCalloutMock.class, new Testing_HttpResponseMock().setStatusCode(200) );
        Test.startTest();
        CoreSeikyuCancelController.CancelResult theCancelResult = CoreSeikyuCancelController.processCancel( theParent.Id );
        Test.stopTest();

        System.assertEquals(false, theCancelResult.is_success, 'CancelResult shoul be error');
        
    }
}