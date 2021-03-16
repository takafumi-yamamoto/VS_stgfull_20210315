@isTest
public class OkyakusamaSeikyuMeisaiCrudPolicyTest {

    @isTest(SeeAllData=true)
    public static void whenUpdate_WithPolicyViolation_ThenPolicyErrorShouldBeOccured(){

        Map<String, Account> theAccounts = new Map<String, Account>{
            '1' => new Account(Name = '1')
        };
        Insert theAccounts.values();

        Map<String,Opportunity> theOpps = new Map<String, Opportunity>{
            '1' => new Opportunity(
                AccountId = theAccounts.get('1').Id,
                Name = '_',
                StageName = '_',
                CloseDate = Date.today()
            )
        };
        Insert theOpps.values();

        Map<String, OkyakusamaSeikyuMeisai__c> theSeikyus = new Map<String, OkyakusamaSeikyuMeisai__c>{
            '1' => new OkyakusamaSeikyuMeisai__c(
                OpportunityRef__c = theOpps.get('1').Id,
                SeikyuHouhou__c = 'gmo_credit'
            )
        };
        Insert theSeikyus.values();

        OkyakusamaSeikyuMeisai__c theSeikyuInWork =[
            select id
            from
            OkyakusamaSeikyuMeisai__c where Id = :theSeikyus.get('1').Id
        ].get(0);

        Test.startTest();
        theSeikyuInWork.SeikyuBango__c = 'new SeikyuBango';

        String theExceptionMsg = '';
        try{
                    Update theSeikyuInWork;
        }catch (DmlException e){
            theExceptionMsg = e.getMessage();
        }
        Test.stopTest();

        System.assertEquals(true, theExceptionMsg.contains('更新ポリシー'), 'Policy Error should be occured');
    }

    @isTest(SeeAllData=true)
    public static void whenUpdate_OnPolicySkipSignedRecord_ThenUpdateShoudBeSuccess(){

        Map<String, Account> theAccounts = new Map<String, Account>{
            '1' => new Account(Name = '1')
        };
        Insert theAccounts.values();

        Map<String,Opportunity> theOpps = new Map<String, Opportunity>{
            '1' => new Opportunity(
                AccountId = theAccounts.get('1').Id,
                Name = '_',
                StageName = '_',
                CloseDate = Date.today()
            )
        };
        Insert theOpps.values();

        Map<String, OkyakusamaSeikyuMeisai__c> theSeikyus = new Map<String, OkyakusamaSeikyuMeisai__c>{
            '1' => new OkyakusamaSeikyuMeisai__c(
                OpportunityRef__c = theOpps.get('1').Id,
                SeikyuHouhou__c = 'gmo_credit'
            )
        };
        Insert theSeikyus.values();

        OkyakusamaSeikyuMeisai__c theSeikyuInWork =[
            select id, SeikyuBango__c
            from
            OkyakusamaSeikyuMeisai__c where Id = :theSeikyus.get('1').Id
        ].get(0);

        Test.startTest();
        theSeikyuInWork.SeikyuBango__c = 'new SeikyuBango';
        theSeikyuInWork.isSkipCrudPlicy__c = true;
        Update theSeikyuInWork;
        Test.stopTest();

        OkyakusamaSeikyuMeisai__c theSeikyuCommited =[
            select id, SeikyuBango__c
            from
            OkyakusamaSeikyuMeisai__c where Id = :theSeikyus.get('1').Id
        ].get(0);

        System.assertEquals('new SeikyuBango', theSeikyuCommited.SeikyuBango__c, 'update should be success');

    }

    @isTest(SeeAllData=true)
    public static void whenDelete_WithPolicyViolation_ThenPolicyErrorShouldBeOccured(){

        Map<String, Account> theAccounts = new Map<String, Account>{
            '1' => new Account(Name = '1')
        };
        Insert theAccounts.values();

        Map<String,Opportunity> theOpps = new Map<String, Opportunity>{
            '1' => new Opportunity(
                AccountId = theAccounts.get('1').Id,
                Name = '_',
                StageName = '_',
                CloseDate = Date.today()
            )
        };
        Insert theOpps.values();

        Map<String, OkyakusamaSeikyuMeisai__c> theSeikyus = new Map<String, OkyakusamaSeikyuMeisai__c>{
            '1' => new OkyakusamaSeikyuMeisai__c(
                OpportunityRef__c = theOpps.get('1').Id,
                SeikyuHouhou__c = 'gmo_credit'
            )
        };
        Insert theSeikyus.values();

        OkyakusamaSeikyuMeisai__c theSeikyuInWork =[
            select id
            from
            OkyakusamaSeikyuMeisai__c where Id = :theSeikyus.get('1').Id
        ].get(0);

        Test.startTest();
        String theExceptionMsg = '';
        try{
            Delete theSeikyuInWork;
        }catch (DmlException e){
            theExceptionMsg = e.getMessage();
        }
        Test.stopTest();

        System.assertEquals(true, theExceptionMsg.contains('削除ポリシー'), 'Policy Error should be occured');
    }

    @isTest(SeeAllData=true)
    public static void whenDelete_OnPolicySkipSignedRecord_ThenUpdateShoudBeSuccess(){

        Map<String, Account> theAccounts = new Map<String, Account>{
            '1' => new Account(Name = '1')
        };
        Insert theAccounts.values();

        Map<String,Opportunity> theOpps = new Map<String, Opportunity>{
            '1' => new Opportunity(
                AccountId = theAccounts.get('1').Id,
                Name = '_',
                StageName = '_',
                CloseDate = Date.today()
            )
        };
        Insert theOpps.values();

        Map<String, OkyakusamaSeikyuMeisai__c> theSeikyus = new Map<String, OkyakusamaSeikyuMeisai__c>{
            '1' => new OkyakusamaSeikyuMeisai__c(
                OpportunityRef__c = theOpps.get('1').Id,
                SeikyuHouhou__c = 'gmo_credit'
            )
        };
        Insert theSeikyus.values();

        OkyakusamaSeikyuMeisai__c theSeikyuInWork =[
            select id, SeikyuBango__c
            from
            OkyakusamaSeikyuMeisai__c where Id = :theSeikyus.get('1').Id
        ].get(0);

        Test.startTest();
        OkyakusamaSeikyuMeisaiCrudPolicy.DeleteInNoPolicy( new List<OkyakusamaSeikyuMeisai__c>{theSeikyuInWork} ); 
        Test.stopTest();

        List<OkyakusamaSeikyuMeisai__c> theSeikyusCommited =[
            select id, SeikyuBango__c
            from
            OkyakusamaSeikyuMeisai__c where Id = :theSeikyus.get('1').Id
        ];

        System.assertEquals(0, theSeikyusCommited.size(), 'delete should be success');

    }

}