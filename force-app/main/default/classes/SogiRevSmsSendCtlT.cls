@isTest
private class SogiRevSmsSendCtlT {
    
    @testSetup
    static void initializeTestData() {

        Account dacc=new Account();
        dacc.LastName='xxxdefualt';
        //acc.LastNameFurigana__pc ='defualt';
        //acc.FirstNameFurigana__pc ='defualt';
        dacc.Phone='088-0000-0001';
        dacc.MobilePhone__c='888-0000-0001';
        dacc.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId();
        insert dacc;

        //カスタム設定のTriggerIsActive__cのデータを作成
        TriggerIsActive__c TriggerIsActive=new TriggerIsActive__c();
        TriggerIsActive.name='default';
        TriggerIsActive.isActive__c=true;
        insert TriggerIsActive;

        JizenWariPlan__c JizenWariPlan=new JizenWariPlan__c();
        JizenWariPlan.Code__c='Yoriso';
        insert JizenWariPlan;        

        //取引先のデータ作成
        Account acc=new Account();
        acc.Lastname='テスト';
        acc.Phone='080-0000-0001';
        acc.MobilePhone__c='080-0000-0001';
        acc.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
        insert acc;
        
        SougiRev__c rev = new SougiRev__c();
        insert rev;

        opportunity opp=new opportunity();
        opp.accountid=acc.id;
        opp.Name='test';
        opp.StageName='商談開始';
        opp.Req_Day__c = Date.today();
        opp.CloseDate = Date.today();
        opp.KakuteibiSyodan__c = Date.today();
        opp.Utiagebi__c = Date.today();
        opp.accountid=acc.id;
        opp.TesuryoPartner__c = 5000;
        opp.TaishoushaJokyo__c = '_';
        opp.recordtypeid=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SougiRev').getRecordTypeId();
        opp.SogiReviRef__c = rev.Id;
        insert opp;
    }

    static testMethod void testMethod_case1(){

        Opportunity opp = [select Id from Opportunity where Name = 'test' limit 1];

        Test.startTest();

        SogiRevSmsSendCtl sIns = new SogiRevSmsSendCtl(new ApexPages.StandardController(opp));
        sIns.sendSms();

        Test.stopTest();
    }

    static testMethod void testMethod_case2(){

        Opportunity opp = [select Id from Opportunity where Name = 'test' limit 1];

        Test.startTest();

        SogiRevSmsSendCtl sIns = new SogiRevSmsSendCtl(new ApexPages.StandardController(opp));

        MockAccreteSmsApi mock = new MockAccreteSmsApi();
        mock.setStatusCodeSmsReg(200);
        Test.setMock(HttpCalloutMock.class, mock);
        sIns.sendSms();

        Test.stopTest();
    }
    
    static testMethod void testMethod_case3(){

        Account acc = [select Id, MobilePhone__c from Account where LastName = 'テスト'];
        acc.MobilePhone__c='08000000000';
        update acc;

        Opportunity opp = [select Id from Opportunity where Name = 'test' limit 1];

        Test.startTest();

        SogiRevSmsSendCtl sIns = new SogiRevSmsSendCtl(new ApexPages.StandardController(opp));

        MockAccreteSmsApi mock = new MockAccreteSmsApi();
        mock.setStatusCodeSmsReg(400);
        Test.setMock(HttpCalloutMock.class, mock);
        sIns.sendSms();

        Test.stopTest();
    }
}