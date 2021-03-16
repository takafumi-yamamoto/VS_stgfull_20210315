@isTest
public class Tes_ShodanShohinNaviController {
	static testMethod void testCase1(){
        RecordType defualtAccountRT = new RecordTypeDao().selectRecordBySobjectTypeDeveloperName('Account', 'null');
        Account dacc=new Account();
        dacc.LastName='xxxdefualt';
        //acc.LastNameFurigana__pc ='defualt';
        //acc.FirstNameFurigana__pc ='defualt';
        dacc.Phone='088-0000-0001';
        dacc.MobilePhone__c='888-0000-0001';
        dacc.recordTypeId = defualtAccountRT.Id;
        insert dacc;
        
        //取引先のデータ作成
		Account acc=new Account();
		acc.name='defualt';
		insert acc;
	    //取引商談
		String oppTorihikiShodanRdId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','TorihikiShodan');
		Opportunity opp = new Opportunity(Name = 'テスト商談', AccountId = acc.Id, RecordTypeId = oppTorihikiShodanRdId, StageName = 'フォロー',CloseDate = system.today());	
		insert opp;	
				
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
		Product2 prod = new Product2(
		     Name = 'Product X',
		     ProductCode = 'Pro-X',
		     DataKubun__c='2:割引プラン',     
		     isActive = true
		);
		insert prod;
		//Create your product
		Product2 prod1 = new Product2(
		     Name = 'Product X',
		     ProductCode = 'Pro-X',
		     DataKubun__c='3:クーポン',		     
		     isActive = true
		);
		insert prod1;		
		
		//Create your pricebook entry
		PricebookEntry pbEntry = new PricebookEntry(
		     Pricebook2Id = pricebookId,
		     Product2Id = prod.Id,
		     UnitPrice = 100.00,
		     IsActive = true
		);
		insert pbEntry;	
		PricebookEntry pbEntry1 = new PricebookEntry(
		     Pricebook2Id = pricebookId,
		     Product2Id = prod1.Id,
		     UnitPrice = 100.00,
		     IsActive = true
		);
		insert pbEntry1;
		
        opportunity opp1=new opportunity();
        opp1.accountid=acc.id;
        opp1.Name='test';
        opp1.StageName='商談開始';
        opp1.CloseDate=system.today();
        opp1.accountid=acc.id;
        opp1.TorihikiShodanRef__c=opp.id;
        opp1.recordtypeid=RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Seizenkeiyaku');
        insert opp1;
		//create your opportunity line item.  This assumes you already have an opportunity created, called opp
		OpportunityLineItem oli = new OpportunityLineItem(
		     OpportunityId = opp1.Id,
		     Quantity = 5,
		     PricebookEntryId = pbEntry.Id,
		     TotalPrice =100// quantity * pbEntry.UnitPrice
		);
		insert oli;        
        
        Test.startTest();			
		ShodanShohinNaviController.getDataContext(opp.id);
		Test.stopTest();
	}

}