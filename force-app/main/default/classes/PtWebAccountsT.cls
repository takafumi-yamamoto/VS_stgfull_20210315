@isTest
private class PtWebAccountsT {
	
	@isTest static void test_PtWebAccountIraiTrigger() {
		Insert new TriggerIsActive__c( name='default', isActive__c=true );
		
		Account accountSoryo = new SampleData().getAccountSoryo();
		insert accountSoryo;

		PtWebAccountIrai__c ptWebAccountIrai0 = new PtWebAccountIrai__c();
		ptWebAccountIrai0.IraiKubun__c = '新規';
		ptWebAccountIrai0.MailAddress__c = 'testtest+20180828@yoriso.com';
		ptWebAccountIrai0.IraiStatus__c = '未送信'; //'送信'
		ptWebAccountIrai0.AccountRef__c = accountSoryo.Id;
		ptWebAccountIrai0.ShoriStatus__c = 'Created'; //Completed

		insert ptWebAccountIrai0;

		ptWebAccountIrai0.IraiStatus__c = '送信';
		update ptWebAccountIrai0;

		PtWebAccounts_IssuingNewAccount.PtWebAccounts_IssuingNewAccountTask task = new PtWebAccounts_IssuingNewAccount.PtWebAccounts_IssuingNewAccountTask(ptWebAccountIrai0.Id);
		task.execute(null);

	}
	
	@isTest static void test_PtWebAccounts() {
        Test.startTest(); 
        TriggerIsActive__c TriggerIsActive = new TriggerIsActive__c();
        TriggerIsActive.name='default';
        TriggerIsActive.isActive__c=true;
        insert TriggerIsActive;
		JizenWariPlan__c JizenWariPlan=new JizenWariPlan__c();
        JizenWariPlan.Code__c='Yoriso';
        insert JizenWariPlan;          
        //取引先
        Account acc=new Account();
        acc.Name='テスト用００１';
        acc.BillingCountry='日本';
        acc.BillingState='東京都';
        acc.BillingCity='中央区';
        acc.BillingStreet='１－１－１';
        acc.BillingPostalCode='335-0016';
        insert acc;
        delete acc; 
        Test.stopTest();

	}

	@isTest static void test_PtWebAccounts_IssuingNewAccountTask() {
		PtWebAccounts_IssuingNewAccount.PtWebAccounts_IssuingNewAccountTask task = new PtWebAccounts_IssuingNewAccount.PtWebAccounts_IssuingNewAccountTask(null);
		task.execute(null);

		PtWebAccounts_IssuingNewAccount.subscriveOnAyncBrokerOnRunRequested(PtWebAccounts_IssuingNewAccount.PtWebAccounts_IssuingNewAccountTask.Class.toString());
	}
	

	
	@isTest static void test_PtWebAccounts_InvalidatingWebAccount() {
		Insert new TriggerIsActive__c( name='default', isActive__c=true );
		
		Account accountSoryo = new SampleData().getAccountSoryo();
		insert accountSoryo;

		PtWebAccountIrai__c ptWebAccountIrai0 = new PtWebAccountIrai__c();
		ptWebAccountIrai0.IraiKubun__c = '削除';
		ptWebAccountIrai0.MailAddress__c = 'testtest+20180828@yoriso.com';
		ptWebAccountIrai0.IraiStatus__c = '未送信'; //'送信'
		ptWebAccountIrai0.AccountRef__c = accountSoryo.Id;
		ptWebAccountIrai0.ShoriStatus__c = 'Created'; //Completed

		insert ptWebAccountIrai0;


		PtWebAccounts_InvalidatingWebAccount.subscriveOnAyncBrokerOnRunRequested(PtWebAccounts_InvalidatingWebAccount.PtWebAccounts_InvalidatingWebAccountTask.Class.toString());
		
	}
}