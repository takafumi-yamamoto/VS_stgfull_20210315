@isTest
public with sharing class Tes_OrderSyohin {

	//static testMethod void testMethod_OrderSyohin(){

	//	TriggerIsActive__c customSetting = new TriggerIsActive__c(Name = 'defualt',isActive__c = true);
	//	insert customSetting;

	//	Account acc = new Account( Name = 'アカウントtest');
	//    insert acc;
		
	//	Date today = date.today();

	//	Id   oppRdId    = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('シンプル安豪').getRecordTypeId();
	//	Opportunity opp1 = new Opportunity(Name = '商談1', AccountId = acc.Id, RecordTypeId = oppRdId, StageName = 'フォロー',CloseDate = today);

 //    	insert opp1;

	//	Opportunity opp2 = new Opportunity(Name = '商談2', AccountId = acc.Id, RecordTypeId = oppRdId, StageName = 'フォロー',CloseDate = today);

	//	insert opp2;

	//	Product2 syohin = new Product2(Name = 'テスト商品',ProductCode = '12345',IsActive = true);
	//	insert syohin;

	//	Id pricebook2Id = Test.getStandardPricebookId();

	//	PricebookEntry pde = new PricebookEntry(Product2Id = syohin.Id, Pricebook2Id = pricebook2Id,UnitPrice = 15000,IsActive = true);
	//	insert pde;

	//	OpportunityLineItem syoudanSyouhin = new OpportunityLineItem(Quantity = 1,OpportunityId = opp1.Id,PricebookEntryId = pde.Id);
	//	insert syoudanSyouhin;
		
	//	opp1.TorihikiShodanRef__c = opp2.Id;
	//	update opp1;

	//	syoudanSyouhin.Quantity = 2;
	//	update syoudanSyouhin;

	//	delete syoudanSyouhin;

	//}

}