@isTest
private class Tes_SampleData {
	
	@isTest static void test_method_one() {
        Pricebook2 standardPricebook = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = true
        );
        update standardPricebook;
        
        standardPricebook = [SELECT IsStandard FROM Pricebook2 WHERE Id = :standardPricebook.Id];
        system.debug('***standardPricebook='+standardPricebook);
        
        // Get standard price book ID.
        // This is available irrespective of the state of SeeAllData.
        Id pricebookId = Test.getStandardPricebookId();

		//Create your product
		List<Product2> productList = new List<Product2>{
			new Product2(Name = 'Product X1', ShohinBango__c = 'SBG-0000060',ProductCode = 'Pro-X',DataKubun__c='3:クーポン',isActive = true),
			new Product2(Name = 'Product X2', ShohinBango__c = 'SBG-0000061',ProductCode = 'Pro-X',DataKubun__c='3:クーポン',isActive = true),
			new Product2(Name = 'Product X3', ShohinBango__c = 'SBG-0000062',ProductCode = 'Pro-X',DataKubun__c='3:クーポン',isActive = true),
			new Product2(Name = 'Product X4', ShohinBango__c = 'SBG-0000063',ProductCode = 'Pro-X',DataKubun__c='3:クーポン',isActive = true),
			new Product2(Name = 'Product X5', ShohinBango__c = 'SBG-0000064',ProductCode = 'Pro-X',DataKubun__c='3:クーポン',isActive = true),
			new Product2(Name = 'Product X6', ShohinBango__c = 'SBG-0000065',ProductCode = 'Pro-X',DataKubun__c='3:クーポン',isActive = true),
			new Product2(Name = 'Product X7', ShohinBango__c = 'SBG-0000066',ProductCode = 'Pro-X',DataKubun__c='3:クーポン',isActive = true),
			new Product2(Name = 'Product X8', ShohinBango__c = 'SBG-0000039',ProductCode = 'Pro-X',DataKubun__c='3:クーポン',isActive = true),
			new Product2(Name = 'Product X9', ShohinBango__c = 'SBG-0000286',ProductCode = 'Pro-X',DataKubun__c='3:クーポン',isActive = true),
			new Product2(Name = 'Product X10', ShohinBango__c = 'SBG-0000038',ProductCode = 'Pro-X',DataKubun__c='2:割引プラン',isActive = true)
		};
		insert productList;
        // 1. Insert a price book entry for the standard price book.
        // Standard price book entries require the standard price book ID we got earlier.
        List<PricebookEntry> pricebookEntryList = new List<PricebookEntry>{
        	new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = productList[0].Id, UnitPrice = 10000, IsActive = true),
        	new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = productList[1].Id, UnitPrice = 10000, IsActive = true),
        	new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = productList[2].Id, UnitPrice = 10000, IsActive = true),
        	new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = productList[3].Id, UnitPrice = 10000, IsActive = true),
        	new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = productList[4].Id, UnitPrice = 10000, IsActive = true),
        	new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = productList[5].Id, UnitPrice = 10000, IsActive = true),
        	new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = productList[6].Id, UnitPrice = 10000, IsActive = true),
        	new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = productList[7].Id, UnitPrice = 10000, IsActive = true),
        	new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = productList[8].Id, UnitPrice = 10000, IsActive = true),
        	new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = productList[9].Id, UnitPrice = 10000, IsActive = true)
        };
        insert pricebookEntryList;


		SampleData targetClass = new SampleData();
		// テスト実行
		Test.testSandboxPostCopyScript(targetClass,                  // テスト対象クラス
		UserInfo.getOrganizationId(), // contextに渡す組織ID
		UserInfo.getOrganizationId(), // contextに渡すSandboxID
		'SampleDev');                // contextに渡すSandbox名
	}
}