@isTest
private class OpportunityLineItemCheckT {
	
	@testSetup
    private static void setUp(){

		Utility_Common.isMimicExecAsDataIkouProfile = true;

        Insert new TriggerIsActive__c( name='default', isActive__c=true );
        Insert new JizenWariPlan__c( Code__c='Yoriso' );
        Insert new Account(
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId(),
            FirstName = '_', LastName = '_'
		);
		
		List<Product2> theProducts = new List<Product2>{
			new Product2(ShohinBango__c = 'SBG-0004001', Name = '旧商品', IsActive = true, LatestFlg__c = false),
            new Product2(ShohinBango__c = 'SBG-0005001', Name = '【20.11】よりそう家族葬 一日プラン', IsActive = true, LatestFlg__c = true),
			new Product2(ShohinBango__c = 'SBG-0005002', Name = '【20.11】よりそう家族葬 二日プラン', IsActive = true, LatestFlg__c = true),
			new Product2(ShohinBango__c = 'SBG-0005003', Name = '【20.11】よりそう家族葬 華やかプラン', IsActive = true, LatestFlg__c = true),
			new Product2(ShohinBango__c = 'SBG-0005004', Name = '【20.11】よりそう火葬式 直葬プラン', IsActive = true, LatestFlg__c = true),
			new Product2(ShohinBango__c = 'SBG-0005005', Name = '【20.11】よりそう火葬式 標準プラン', IsActive = true, LatestFlg__c = true),
			new Product2(ShohinBango__c = 'SBG-0005401', Name = '【20.11】祭壇アップグレード M (家族葬 一日プラン)', IsActive = true, LatestFlg__c = true),
			new Product2(ShohinBango__c = 'SBG-0005402', Name = '【20.11】祭壇アップグレード L (家族葬 一日プラン)', IsActive = true, LatestFlg__c = true),
			new Product2(ShohinBango__c = 'SBG-0005403', Name = '【20.11】祭壇アップグレード LL (家族葬 一日プラン)', IsActive = true, LatestFlg__c = true),
			new Product2(ShohinBango__c = 'SBG-0005404', Name = '【20.11】祭壇アップグレード L (家族葬 二日プラン)', IsActive = true, LatestFlg__c = true),
			new Product2(ShohinBango__c = 'SBG-0005405', Name = '【20.11】祭壇アップグレード LL (家族葬 二日プラン)', IsActive = true, LatestFlg__c = true),
			new Product2(ShohinBango__c = 'SBG-0005406', Name = '【20.11】祭壇アップグレード LL (家族葬 華やかプラン)', IsActive = true, LatestFlg__c = true),
			new Product2(ShohinBango__c = 'SBG-0005108', Name = '【20.11】よりそうお葬式 仏具なし割引', IsActive = true, LatestFlg__c = true)
        };
        Insert theProducts;

		Id pricebookId = Test.getStandardPricebookId();
		List<PricebookEntry> pbEntryList = new List<PricebookEntry>{
        	new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = theProducts.get(0).Id,UnitPrice = 100.00,IsActive = true),
			new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = theProducts.get(1).Id,UnitPrice = 100.00,IsActive = true),
			new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = theProducts.get(2).Id,UnitPrice = 100.00,IsActive = true),
			new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = theProducts.get(3).Id,UnitPrice = 100.00,IsActive = true),
			new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = theProducts.get(4).Id,UnitPrice = 100.00,IsActive = true),
			new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = theProducts.get(5).Id,UnitPrice = 100.00,IsActive = true),
			new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = theProducts.get(6).Id,UnitPrice = 100.00,IsActive = true),
			new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = theProducts.get(7).Id,UnitPrice = 100.00,IsActive = true),
			new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = theProducts.get(8).Id,UnitPrice = 100.00,IsActive = true),
			new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = theProducts.get(9).Id,UnitPrice = 100.00,IsActive = true),
			new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = theProducts.get(10).Id,UnitPrice = 100.00,IsActive = true),
			new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = theProducts.get(11).Id,UnitPrice = 100.00,IsActive = true),
			new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = theProducts.get(12).Id,UnitPrice = 100.00,IsActive = true)
        };
		insert pbEntryList;
		
		Utility_Common.isMimicExecAsDataIkouProfile = false;

		Case c = new Case();
	    c.Status = '対応中';
	    c.Origin = '電話';
	    c.Priority = '中';
	    c.Type = 'サービス利用';
	    c.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SimpleYasugoOtoiawase').getRecordTypeId();
	    c.ToiawaseDate__c = datetime.now();
	    insert c;
    }

	@isTest 
	static void test1(){
		String uniqueUserName = 'OpportunityLineItemAddCheck@testyoriso.com';
        Profile p = [SELECT Id FROM Profile WHERE Name='CS一般'];
        User u = new User(Alias = 'Opp', 
        					Email=uniqueUserName,
        					EmailEncodingKey='ISO-2022-JP', 
        					LastName='Testing', 
        					LanguageLocaleKey='ja',
        					LocaleSidKey='ja_JP', 
        					ProfileId = p.Id,
        					TimeZoneSidKey='Asia/Tokyo',
        					UserName=uniqueUserName);
		Opportunity opp = [select Id from Opportunity where RecordTypeId = :Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId()];
		
		Map<String, Product2> pMap = new Map<String, Product2>();
		for(Product2 p2 : [select Id, ShohinBango__c from Product2]){
			pMap.put(p2.ShohinBango__c, p2);
		}
		System.runAs(u) {
	        try{
	        	insert new OpportunityLineItem(OpportunityId = opp.Id, Product2Id = pMap.get('SBG-0004001').Id);
	        }catch(Exception e){
				Boolean expectedExceptionThrown = e.getMessage().contains('旧商品は設定できません') ? true : false;
				System.AssertEquals(expectedExceptionThrown, true);
			}
        }
	}

	@isTest 
	static void test2(){
		String uniqueUserName = 'OpportunityLineItemAddCheck@testyoriso.com';
        Profile p = [SELECT Id FROM Profile WHERE Name='CS一般'];
        User u = new User(Alias = 'Opp', 
        					Email=uniqueUserName,
        					EmailEncodingKey='ISO-2022-JP', 
        					LastName='Testing', 
        					LanguageLocaleKey='ja',
        					LocaleSidKey='ja_JP', 
        					ProfileId = p.Id,
        					TimeZoneSidKey='Asia/Tokyo',
							UserName=uniqueUserName);
		Opportunity opp = [select Id from Opportunity where RecordTypeId = :Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId()];

		Map<String, Product2> pMap = new Map<String, Product2>();
		for(Product2 p2 : [select Id, ShohinBango__c from Product2]){
			pMap.put(p2.ShohinBango__c, p2);
		}
		insert new OpportunityLineItem(OpportunityId = opp.Id, Product2Id = pMap.get('SBG-0005108').Id);
        System.runAs(u) {
	        try{
				insert new OpportunityLineItem(OpportunityId = opp.Id, Product2Id = pMap.get('SBG-0005004').Id);
	        }catch(Exception e){
				Boolean expectedExceptionThrown = e.getMessage().contains('直葬プランと仏具なし割引は併用できません') ? true : false;
				System.AssertEquals(expectedExceptionThrown, true);
			}
        }
	}

	@isTest 
	static void test4(){
		String uniqueUserName = 'OpportunityLineItemAddCheck@testyoriso.com';
        Profile p = [SELECT Id FROM Profile WHERE Name='CS一般'];
        User u = new User(Alias = 'Opp', 
        					Email=uniqueUserName,
        					EmailEncodingKey='ISO-2022-JP', 
        					LastName='Testing', 
        					LanguageLocaleKey='ja',
        					LocaleSidKey='ja_JP', 
        					ProfileId = p.Id,
        					TimeZoneSidKey='Asia/Tokyo',
							UserName=uniqueUserName);
		Opportunity opp = [select Id from Opportunity where RecordTypeId = :Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId()];

		Map<String, Product2> pMap = new Map<String, Product2>();
		for(Product2 p2 : [select Id, ShohinBango__c from Product2]){
			pMap.put(p2.ShohinBango__c, p2);
		}
		insert new OpportunityLineItem(OpportunityId = opp.Id, Product2Id = pMap.get('SBG-0005406').Id);
        System.runAs(u) {
	        try{
				insert new OpportunityLineItem(OpportunityId = opp.Id, Product2Id = pMap.get('SBG-0005001').Id);
	        }catch(Exception e){
				Boolean expectedExceptionThrown = e.getMessage().contains('プランと祭壇アップグレードが一致していません') ? true : false;
				System.AssertEquals(expectedExceptionThrown, true);
			}
        }
	}

	@isTest 
	static void test6(){
		String uniqueUserName = 'OpportunityLineItemAddCheck@testyoriso.com';
        Profile p = [SELECT Id FROM Profile WHERE Name='CS一般'];
        User u = new User(Alias = 'Opp', 
        					Email=uniqueUserName,
        					EmailEncodingKey='ISO-2022-JP', 
        					LastName='Testing', 
        					LanguageLocaleKey='ja',
        					LocaleSidKey='ja_JP', 
        					ProfileId = p.Id,
        					TimeZoneSidKey='Asia/Tokyo',
							UserName=uniqueUserName);
		Opportunity opp = [select Id from Opportunity where RecordTypeId = :Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId()];

		Map<String, Product2> pMap = new Map<String, Product2>();
		for(Product2 p2 : [select Id, ShohinBango__c from Product2]){
			pMap.put(p2.ShohinBango__c, p2);
		}
		insert new OpportunityLineItem(OpportunityId = opp.Id, Product2Id = pMap.get('SBG-0005406').Id);
        System.runAs(u) {
	        try{
				insert new OpportunityLineItem(OpportunityId = opp.Id, Product2Id = pMap.get('SBG-0005002').Id);
	        }catch(Exception e){
				Boolean expectedExceptionThrown = e.getMessage().contains('プランと祭壇アップグレードが一致していません') ? true : false;
				System.AssertEquals(expectedExceptionThrown, true);
			}
        }
	}

	@isTest 
	static void test8(){
		String uniqueUserName = 'OpportunityLineItemAddCheck@testyoriso.com';
        Profile p = [SELECT Id FROM Profile WHERE Name='CS一般'];
        User u = new User(Alias = 'Opp', 
        					Email=uniqueUserName,
        					EmailEncodingKey='ISO-2022-JP', 
        					LastName='Testing', 
        					LanguageLocaleKey='ja',
        					LocaleSidKey='ja_JP', 
        					ProfileId = p.Id,
        					TimeZoneSidKey='Asia/Tokyo',
							UserName=uniqueUserName);
		Opportunity opp = [select Id from Opportunity where RecordTypeId = :Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId()];

		Map<String, Product2> pMap = new Map<String, Product2>();
		for(Product2 p2 : [select Id, ShohinBango__c from Product2]){
			pMap.put(p2.ShohinBango__c, p2);
		}
		insert new OpportunityLineItem(OpportunityId = opp.Id, Product2Id = pMap.get('SBG-0005405').Id);
        System.runAs(u) {
	        try{
				insert new OpportunityLineItem(OpportunityId = opp.Id, Product2Id = pMap.get('SBG-0005003').Id);
	        }catch(Exception e){
				Boolean expectedExceptionThrown = e.getMessage().contains('プランと祭壇アップグレードが一致していません') ? true : false;
				System.AssertEquals(expectedExceptionThrown, true);
			}
        }
	}

	@isTest 
	static void test10(){
		String uniqueUserName = 'OpportunityLineItemAddCheck@testyoriso.com';
        Profile p = [SELECT Id FROM Profile WHERE Name='CS一般'];
        User u = new User(Alias = 'Opp', 
        					Email=uniqueUserName,
        					EmailEncodingKey='ISO-2022-JP', 
        					LastName='Testing', 
        					LanguageLocaleKey='ja',
        					LocaleSidKey='ja_JP', 
        					ProfileId = p.Id,
        					TimeZoneSidKey='Asia/Tokyo',
							UserName=uniqueUserName);
		Opportunity opp = [select Id from Opportunity where RecordTypeId = :Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId()];

		Map<String, Product2> pMap = new Map<String, Product2>();
		for(Product2 p2 : [select Id, ShohinBango__c from Product2]){
			pMap.put(p2.ShohinBango__c, p2);
		}
		insert new OpportunityLineItem(OpportunityId = opp.Id, Product2Id = pMap.get('SBG-0005406').Id);
        System.runAs(u) {
	        try{
				insert new OpportunityLineItem(OpportunityId = opp.Id, Product2Id = pMap.get('SBG-0005004').Id);
	        }catch(Exception e){
				Boolean expectedExceptionThrown = e.getMessage().contains('プランと祭壇アップグレードが一致していません') ? true : false;
				System.AssertEquals(expectedExceptionThrown, true);
			}
        }
	}
	
	@isTest 
	static void test12(){
		String uniqueUserName = 'OpportunityLineItemAddCheck@testyoriso.com';
        Profile p = [SELECT Id FROM Profile WHERE Name='CS一般'];
        User u = new User(Alias = 'Opp', 
        					Email=uniqueUserName,
        					EmailEncodingKey='ISO-2022-JP', 
        					LastName='Testing', 
        					LanguageLocaleKey='ja',
        					LocaleSidKey='ja_JP', 
        					ProfileId = p.Id,
        					TimeZoneSidKey='Asia/Tokyo',
							UserName=uniqueUserName);
		Opportunity opp = [select Id from Opportunity where RecordTypeId = :Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId()];

		Map<String, Product2> pMap = new Map<String, Product2>();
		for(Product2 p2 : [select Id, ShohinBango__c from Product2]){
			pMap.put(p2.ShohinBango__c, p2);
		}
		insert new OpportunityLineItem(OpportunityId = opp.Id, Product2Id = pMap.get('SBG-0005406').Id);
        System.runAs(u) {
	        try{
				insert new OpportunityLineItem(OpportunityId = opp.Id, Product2Id = pMap.get('SBG-0005005').Id);
	        }catch(Exception e){
				Boolean expectedExceptionThrown = e.getMessage().contains('プランと祭壇アップグレードが一致していません') ? true : false;
				System.AssertEquals(expectedExceptionThrown, true);
			}
        }
	}
}