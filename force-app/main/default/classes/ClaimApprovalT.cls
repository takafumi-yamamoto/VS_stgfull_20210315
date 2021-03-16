@isTest
private class ClaimApprovalT {
	
	@testSetup
    static void initializeTestData() {

        RecordType defualtAccountRT = new RecordTypeDao().selectRecordBySobjectTypeDeveloperName('Account', 'null');
		Account dacc=new Account();
		dacc.LastName='xxxdefualt';
		//acc.LastNameFurigana__pc ='defualt';
		//acc.FirstNameFurigana__pc ='defualt';
		dacc.Phone='088-0000-0001';
		dacc.MobilePhone__c='888-0000-0001';
		dacc.recordTypeId = defualtAccountRT.Id;
		insert dacc;

		//カスタム設定のTriggerIsActive__cのデータを作成
		TriggerIsActive__c TriggerIsActive=new TriggerIsActive__c();
		TriggerIsActive.name='default';
		TriggerIsActive.isActive__c=true;
		insert TriggerIsActive;

		JizenWariPlan__c JizenWariPlan=new JizenWariPlan__c();
        JizenWariPlan.Code__c='Yoriso';
        insert JizenWariPlan;        

    }

    static testMethod void testCase1(){

		id redtpId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
		Account acc=new Account();
		acc.Lastname='テスト';
		acc.recordtypeid=redtpId;
		insert acc;

        opportunity opp=new opportunity();
        opp.accountid=acc.id;
        opp.Name='test';
        opp.StageName='商談開始';
        opp.CloseDate=system.today();
		opp.TaishoushaJokyo__c = '_';
		insert opp;

		Claim__c claim = new Claim__c();
		claim.OkyakusamaRef__c = acc.Id;
		claim.OpportunityRef__c = opp.Id;
		insert claim;

        Test.startTest();

        claim.IsUnlock__c = true;
        update claim;

        Test.stopTest();
	}
}