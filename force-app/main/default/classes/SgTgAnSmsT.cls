@isTest
public class SgTgAnSmsT {
	private static void beginSetUp(){
		Utility_Common.isMimicExecAsDataIkouProfile = true;
	}
	private static void endSetUp(){
		Insert new TriggerIsActive__c( name='default', isActive__c=true );
		Insert new JizenWariPlan__c( Code__c='Yoriso' );
		Insert new Account(
			RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId(),
			FirstName = '_', LastName = '_'
		);
		Utility_Common.isMimicExecAsDataIkouProfile = false;
	}
	@isTest
	public static void createMsg() {

		beginSetUp();

		Map<String, Account> theAccounts = new Map<String, Account>{
			'客' => new Account(
				RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId(),
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
				RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId(),
				Name = '_', StageName = '_', Pricebook2Id = Test.getStandardPricebookId(),
				CloseDate = Date.newInstance(2020,1,1),
				AccountId = theAccounts.get('客').Id,
				SimpleYasugoRef__c = theSimpleYasugos.get('シンプル安豪').Id
			)
		};
		INSERT theOpps.values();

		Map<String, Product2> the_Product2 = new Map<String, Product2>{
			'the_Product2-Plan' => new Product2(ShohinBango__c = 'SBG-0005002', Name = '【20.11】よりそう家族葬 二日プラン', NameForCustomer__c = 'よりそう家族葬 二日プラン', IsActive = true, LatestFlg__c = true,SougiPlan__c = True),
			'the_Product2-Waribikki' => new Product2(ShohinBango__c = 'SBG-0005102', Name = '【20.11】よりそう会員割 (家族葬 二日プラン)', NameForCustomer__c = 'よりそう会員割 (家族葬 二日プラン)', IsActive = true, LatestFlg__c = true,DataKubun__c = '2:割引プラン'),
			'the_Product2-Coupon' => new Product2(ShohinBango__c = 'SBG-0003533', Name = '【20.11】よりそうお葬式 オファリング 15,000円値引き', NameForCustomer__c = 'よりそう負担特別割引', IsActive = true, LatestFlg__c = true,DataKubun__c = '3:クーポン')
		};
		Insert the_Product2.values();

		Id pricebook2Id = Test.getStandardPricebookId();

		Map<String, PricebookEntry> the_PricebookEntry = new Map<String, PricebookEntry>{
			'PricebookEntry-Plan' => new PricebookEntry(Pricebook2Id = pricebook2Id,Product2Id = the_Product2.get('the_Product2-Plan').Id,UnitPrice = 100.00,IsActive = true),
			'PricebookEntry-Waribikki' => new PricebookEntry(Pricebook2Id = pricebook2Id,Product2Id = the_Product2.get('the_Product2-Waribikki').Id,UnitPrice = 100.00,IsActive = true),
			'PricebookEntry-Coupon' => new PricebookEntry(Pricebook2Id = pricebook2Id,Product2Id = the_Product2.get('the_Product2-Coupon').Id,UnitPrice = 100.00,IsActive = true)
		};
		Insert the_PricebookEntry.values();

		Map<String, OpportunityLineItem> the_OpportunityLineItem = new Map<String, OpportunityLineItem>{
			'OpportunityLineIte-Plan' => new OpportunityLineItem(OpportunityId = theOpps.get('シンプル安豪').Id, PricebookEntryId = the_PricebookEntry.get('PricebookEntry-Plan').Id),
			'OpportunityLineIte-Waribikki' => new OpportunityLineItem(OpportunityId = theOpps.get('シンプル安豪').Id, PricebookEntryId = the_PricebookEntry.get('PricebookEntry-Waribikki').Id),
			'OpportunityLineIte-Coupon' => new OpportunityLineItem(OpportunityId = theOpps.get('シンプル安豪').Id, PricebookEntryId = the_PricebookEntry.get('PricebookEntry-Coupon').Id)
		};
		Insert the_OpportunityLineItem.values();

		endSetUp();

		Test.startTest();
		SgTgAnSms.IMessageCreater mSgTgAnSms = new SgTgAnSms.MessageCreater(new SgTgAnSms.OppLineItemDataPvdr()); 
		String theReq = mSgTgAnSms.createMsg(theOpps.get('シンプル安豪').Id);
		Test.stopTest();
	}
}