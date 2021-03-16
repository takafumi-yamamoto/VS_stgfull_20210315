@isTest
public class Tes_OpportunityLinqs {

	static testMethod void testCase1(){
		List<Opportunity> oppList = new List<Opportunity>();
		OpportunityLinqs.FirstOrDefault(oppList);
	}

	static testMethod void testCase2(){
		//カスタム設定のTriggerIsActive__cのデータを作成
		//TriggerIsActive__c TriggerIsActive=new TriggerIsActive__c();
		//TriggerIsActive.name='default';
		//TriggerIsActive.isActive__c=true;
		//insert TriggerIsActive;
        
        //取引先のデータ作成
		Account acc=new Account();
		acc.name='defualt';
		insert acc;
        
        opportunity opp=new opportunity();
        opp.accountid=acc.id;
        opp.Name='test';
        opp.StageName='商談開始';
        opp.CloseDate=system.today();
        opp.TaishoushaJokyo__c = '_';
        insert opp;

        Test.startTest();

        List<Opportunity> oppList = new List<Opportunity>();
        oppList.add(opp);

        new OpportunityLinqs.OpportunityLinq(oppList)
        		.AddWhere(new OpportunityLinqs.WhereCloseDate(new LinqOpes.DateGtOrEq(),Date.newInstance(2017,12,01)))
                .AddOrderBy(new OpportunityLinqs.OrderByCloseDate(true))
                .AddOrderBy(new OpportunityLinqs.OrderByShodanBango(true))
                .ToList();

        Test.stopTest();
	}
}