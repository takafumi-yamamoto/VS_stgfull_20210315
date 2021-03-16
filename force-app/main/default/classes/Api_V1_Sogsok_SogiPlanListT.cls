@isTest
private class Api_V1_Sogsok_SogiPlanListT {
	
	@isTest static void test_method_one() {

		k_ShohinSyubetsu__c k_shohinsyubetsu = new k_ShohinSyubetsu__c();
		k_shohinsyubetsu.ID__c = '1';
		insert k_shohinsyubetsu;

		k_Service__c k_service = new k_Service__c();
		k_service.ID__c = '1';
		insert k_service;
		
        List<Product2> prodList = new List<Product2>();
        Product2 prod = new Product2(
             Name = 'Product X',
             ProductCode = 'Pro-X',
             DataKubun__c='1:通常商品', 
             HanbaiKaishiBi__c = date.today(),
             HanbaiSyuryoBi__c = date.today(),
             k_ShohinSyubetsuRef__c = k_ShohinSyubetsu.Id,
             k_ServiceRef__c = k_Service.Id,
             isActive = true
        );
        prodList.add(prod);
        //Create your product
        Product2 prod1 = new Product2(
             Name = 'Product X',
             ProductCode = 'Pro-X',
             DataKubun__c='2:割引プラン',   
             HanbaiKaishiBi__c = date.today(),
             HanbaiSyuryoBi__c = date.today(),
             k_ShohinSyubetsuRef__c = k_ShohinSyubetsu.Id,
             k_ServiceRef__c = k_Service.Id,          
             isActive = true
        );
        prodList.add(prod1);
        //Create your product
        Product2 prod2 = new Product2(
             Name = 'Product X',
             ProductCode = 'Pro-X',
             DataKubun__c='3:クーポン',      
             HanbaiKaishiBi__c = date.today(),
             HanbaiSyuryoBi__c = date.today(),
             k_ShohinSyubetsuRef__c = k_ShohinSyubetsu.Id,
             k_ServiceRef__c = k_Service.Id,    
             isActive = true
        );
        prodList.add(prod2);
        //Create your product
        Product2 prod3 = new Product2(
             Name = 'Product X',
             ProductCode = 'Pro-X',
             DataKubun__c='1:通常商品',      
             HanbaiKaishiBi__c = date.today(),
             HanbaiSyuryoBi__c = date.today(),
             k_ShohinSyubetsuRef__c = k_ShohinSyubetsu.Id,
             k_ServiceRef__c = k_Service.Id,   
             isActive = true
        );      
        prodList.add(prod3);
        insert prodList;


		Id pricebookId = Test.getStandardPricebookId();

        // Instantiate the Pricebook2 record first, setting the Id
        Pricebook2 standardPricebook = new Pricebook2(
            Id = pricebookId,
            IsActive = true
        );

        // Run an update DML on the Pricebook2 record
        // This is the weird workaround that enables IsStandard to become true
        // on the PricebookEntry record
        update standardPricebook;

        //Create your pricebook entry
        List<PricebookEntry> pbEntryList = new List<PricebookEntry>();
        PricebookEntry pbEntry = new PricebookEntry(
             Pricebook2Id = pricebookId,
             Product2Id = prod.Id,
             UnitPrice = 100.00,
             IsActive = true
        );
        pbEntryList.add(pbEntry);
        PricebookEntry pbEntry1 = new PricebookEntry(
             Pricebook2Id = pricebookId,
             Product2Id = prod1.Id,
             UnitPrice = 100.00,
             IsActive = true
        );
        pbEntryList.add(pbEntry1);
        PricebookEntry pbEntry2 = new PricebookEntry(
             Pricebook2Id = pricebookId,
             Product2Id = prod2.Id,
             UnitPrice = 100.00,
             IsActive = true
        );
        pbEntryList.add(pbEntry2);
        PricebookEntry pbEntry3 = new PricebookEntry(
             Pricebook2Id = pricebookId,
             Product2Id = prod3.Id,
             UnitPrice = 100.00,
             IsActive = true
        );      
        pbEntryList.add(pbEntry3);
        insert pbEntryList; 


		// Implement test code
	    Test.startTest();
	        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/api/v1/sogsok/sogiplanlist';
        req.httpMethod = 'GET';

        RestContext.request = req;
        RestContext.response= res;
        
	   Api_V1_Sogsok_SogiPlanList.doGet();

        Test.stopTest();
	}
     
     @isTest static void test_method_2() {

          // Implement test code
	     Test.startTest();
	        
	     Api_V1_Sogsok_SogiPlanList.getEntries('000000');

          Test.stopTest();
     }

     @isTest static void test_method_3() {

          Account dacc=new Account();
          dacc.LastName='xxxdefualt';
          dacc.Phone='088-0000-0001';
          dacc.MobilePhone__c='888-0000-0001';
          dacc.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId();
          insert dacc;

          TriggerIsActive__c TriggerIsActive=new TriggerIsActive__c();
          TriggerIsActive.name='default';
          TriggerIsActive.isActive__c=true;
          insert TriggerIsActive;

          JizenWariPlan__c JizenWariPlan=new JizenWariPlan__c();
          JizenWariPlan.Code__c='Yoriso';
          insert JizenWariPlan;        

          //取引先のデータ作成
          Account acc=new Account();
          acc.LastName='姓';
          acc.FirstName='名';
          acc.Phone='080-0000-0001';
          acc.MobilePhone__c='080-0000-0001';
          acc.MailAddress__c = 'test@yoriso.com';
          acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
          insert acc;

          List<k_Service__c> kServiceList = new List<k_Service__c>{
               new k_Service__c(name='シンプルなお葬式', ID__c = '1' ),
               new k_Service__c(name='安くて豪華なお葬式', ID__c = '2' ),
               new k_Service__c(name='お坊さん便', ID__c = '3' )
          };
          insert kServiceList;

          Id pricebookId = Test.getStandardPricebookId();

          k_ShohinSyubetsu__c k_ShohinSyubetsu=new k_ShohinSyubetsu__c();
          k_ShohinSyubetsu.ID__c='1';
          insert k_ShohinSyubetsu;

          Product2 p = new Product2();
          p.Name = '一日葬';
          p.IsActive = true;
          p.ShohinBango__c = 'SBG-0005008';
          p.k_ServiceRef__c = kServiceList.get(1).Id;
          p.k_ShohinSyubetsuRef__c = k_ShohinSyubetsu.Id;
          insert p;

          PricebookEntry pbEntry = new PricebookEntry();
          pbEntry.Pricebook2Id = pricebookId;
          pbEntry.Product2Id = p.Id;
          pbEntry.UnitPrice = 1000;
          pbEntry.IsActive = true;
          insert pbEntry;

          Case c = new Case();
          c.Status = '対応中';
          c.Origin = '電話';
          c.Priority = '中';
          c.Type = 'サービス利用';
          c.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SimpleYasugoOtoiawase').getRecordTypeId();
          c.ToiawaseDate__c = datetime.now();
          insert c;

          SimpleYasugo__c simpleYasugo = new SimpleYasugo__c();
          insert simpleYasugo;
                    
          opportunity opp=new opportunity();
          opp.CaseRef__c=c.Id;
          opp.accountid=acc.id;
          opp.Name='test';
          opp.StageName='商談開始';
          opp.Req_Day__c = Date.today();
          opp.CloseDate = Date.today();
          opp.KakuteibiSyodan__c = datetime.newInstance(2021, 2, 28, 12, 00, 00);
          opp.Utiagebi__c = Date.today();
          opp.accountid=acc.id;
          opp.TesuryoPartner__c = 5000;
          opp.TaishoushaJokyo__c = '_';
          opp.SimpleYasugoRef__c = simpleYasugo.Id;
          opp.recordtypeid=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId();
          insert opp;

          OpportunityLineItem oppli = new opportunityLineItem();
          oppli.OpportunityId = opp.Id;
          oppli.Product2Id = p.Id;
          oppli.Quantity = 1;
          insert oppli;

          Test.startTest();
	     
          Opportunity aOpp = [select Id, ShodanBango__c from Opportunity where Id = :opp.Id];
	     Api_V1_Sogsok_SogiPlanList.getEntries(aOpp.ShodanBango__c);

          Test.stopTest();

     }

     
     @isTest static void test_method_4() {

          Account dacc=new Account();
          dacc.LastName='xxxdefualt';
          dacc.Phone='088-0000-0001';
          dacc.MobilePhone__c='888-0000-0001';
          dacc.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId();
          insert dacc;

          TriggerIsActive__c TriggerIsActive=new TriggerIsActive__c();
          TriggerIsActive.name='default';
          TriggerIsActive.isActive__c=true;
          insert TriggerIsActive;

          JizenWariPlan__c JizenWariPlan=new JizenWariPlan__c();
          JizenWariPlan.Code__c='Yoriso';
          insert JizenWariPlan;        

          //取引先のデータ作成
          Account acc=new Account();
          acc.LastName='姓';
          acc.FirstName='名';
          acc.Phone='080-0000-0001';
          acc.MobilePhone__c='080-0000-0001';
          acc.MailAddress__c = 'test@yoriso.com';
          acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
          insert acc;

          List<k_Service__c> kServiceList = new List<k_Service__c>{
               new k_Service__c(name='シンプルなお葬式', ID__c = '1' ),
               new k_Service__c(name='安くて豪華なお葬式', ID__c = '2' ),
               new k_Service__c(name='お坊さん便', ID__c = '3' )
          };
          insert kServiceList;

          Id pricebookId = Test.getStandardPricebookId();

          k_ShohinSyubetsu__c k_ShohinSyubetsu=new k_ShohinSyubetsu__c();
          k_ShohinSyubetsu.ID__c='1';
          insert k_ShohinSyubetsu;

          Product2 p = new Product2();
          p.Name = '一日葬';
          p.IsActive = true;
          p.ShohinBango__c = 'SBG-0005008';
          p.k_ServiceRef__c = kServiceList.get(1).Id;
          p.k_ShohinSyubetsuRef__c = k_ShohinSyubetsu.Id;
          insert p;

          PricebookEntry pbEntry = new PricebookEntry();
          pbEntry.Pricebook2Id = pricebookId;
          pbEntry.Product2Id = p.Id;
          pbEntry.UnitPrice = 1000;
          pbEntry.IsActive = true;
          insert pbEntry;

          Case c = new Case();
          c.Status = '対応中';
          c.Origin = '電話';
          c.Priority = '中';
          c.Type = 'サービス利用';
          c.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SimpleYasugoOtoiawase').getRecordTypeId();
          c.ToiawaseDate__c = datetime.now();
          insert c;

          SimpleYasugo__c simpleYasugo = new SimpleYasugo__c();
          insert simpleYasugo;
                    
          opportunity opp=new opportunity();
          opp.CaseRef__c=c.Id;
          opp.accountid=acc.id;
          opp.Name='test';
          opp.StageName='商談開始';
          opp.Req_Day__c = Date.today();
          opp.CloseDate = Date.today();
          opp.KakuteibiSyodan__c = datetime.newInstance(2021, 3, 2, 12, 00, 00);
          opp.Utiagebi__c = Date.today();
          opp.accountid=acc.id;
          opp.TesuryoPartner__c = 5000;
          opp.TaishoushaJokyo__c = '_';
          opp.SimpleYasugoRef__c = simpleYasugo.Id;
          opp.recordtypeid=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId();
          insert opp;

          OpportunityLineItem oppli = new opportunityLineItem();
          oppli.OpportunityId = opp.Id;
          oppli.Product2Id = p.Id;
          oppli.Quantity = 1;
          insert oppli;

          Test.startTest();
	     
          Opportunity aOpp = [select Id, ShodanBango__c from Opportunity where Id = :opp.Id];
	     Api_V1_Sogsok_SogiPlanList.getEntries(aOpp.ShodanBango__c);

          Test.stopTest();

     }
}