@isTest
private class Bat_SouryoClaimAggregateT {
	
	@isTest static void test_method_one() {
		//お客様
		SampleData sampledata = new sampleData();
		List<Account> accList = new List<Account>();
		insert sampledata.getAccountNull();
		
		Account soryo = sampledata.getAccountSoryoAccount();
		insert soryo;


		Account acc = sampledata.getAccountCustomer();
        acc.FirstNameFurigana__pc = 'テスト';
        acc.LastNameFurigana__pc = 'テスト';
        acc.Phone = '080-0000-1111';
        acc.MobilePhone__c = '090-0000-1111';
		insert acc;

		Account taisyousya = sampledata.getAccountCustomer();
        taisyousya.FirstNameFurigana__pc = 'テスト2';
        taisyousya.LastNameFurigana__pc = 'テスト2';
        taisyousya.PersonBirthdate = date.today().addYears(-80);
        taisyousya.PersonDeathDate__pc = date.today();
        taisyousya.Phone = '080-0000-1113';
        taisyousya.MobilePhone__c = '090-0000-1114';
        insert taisyousya;

		Opportunity opportunity = new Opportunity();
		opportunity.Name = '8IC7yhz商談名' ;    //商談名
		opportunity.AccountId = acc.Id ;    //商談名
		opportunity.StageName = '格安の墓石-受注';    //フェーズ
		opportunity.CloseDate = Date.today();    //完了予定日

		insert opportunity;
		
		Insert new Claim__c(TaishoSoryoRef__c = soryo.Id, OkyakusamaRef__c=acc.Id, OpportunityRef__c=opportunity.Id);
		Test.startTest();
		String theNextTimeCron = DateTime.now().addMinutes(1).format('s m H d M ? y');
        System.schedule('Test' + '(' + theNextTimeCron + ')', theNextTimeCron, new Bat_SouryoClaimAggregate() );
        Test.stopTest();
	}
	
	
}