@isTest
private class Ctl_OpportunityLineItemTest{

    @isTest
    static void RegisteringTesuryoCyoseiMeisais_getEntriestoProcess(){
        //SetUp
        List<Product2> theProducts = new List<Product2>{
            new Product2
                (
                    ShohinBango__c = 'Test201803072120-01',
                    Name = 'Test201803072120-01',
                    TesuryoCyoseiKingakuKeisanHoushiki__c = '販売金額_符号反転'
                ),
            new Product2
                (
                    ShohinBango__c = 'Test201803072120-02',
                    Name = 'Test201803072120-02'
                )
        };
        Insert theProducts;

        List<OpportunityLineItem> theLineItems = new List<OpportunityLineItem>
        {
            new OpportunityLineItem( Product2Id = theProducts.get(0).Id ),
            new OpportunityLineItem( Product2Id = theProducts.get(1).Id )
        };

        Ctl_OpportunityLineItem.RegisteringTesuryoCyoseiMeisais theTarget = new Ctl_OpportunityLineItem.RegisteringTesuryoCyoseiMeisais();
        theTarget.f_ProductsMapByid = 
            new Map<Id,SObject>{
                theProducts.get(0).Id => theProducts.get(0),
                theProducts.get(1).Id => theProducts.get(1)
            };
        //Test
        Integer theExpected = 1;
        List<OpportunityLineItem> theEntriesToBeProcessed = theTarget.getEntriestoProcess(theLineItems);
        System.Debug(theEntriesToBeProcessed);

        Integer theResult = theEntriesToBeProcessed.size();
        
        System.assertEquals(theResult, theExpected);
    }

    @isTest
    static void RegisteringTesuryoCyoseiMeisais_createTesuryoCyoseiMeisais(){

        List<Product2> theProducts01 = new List<Product2>{
            new Product2
                (
                    ShohinBango__c = 'Test201803072130-03',
                    Name = '手数料調整'
                )
        };
        Insert theProducts01;

        List<Product2> theProducts = new List<Product2>{
            new Product2
                (
                    ShohinBango__c = 'Test201803072130-01',
                    Name = 'パートナー起因割引',
                    TesuryoCyoseiKingakuKeisanHoushiki__c = '販売金額_符号反転',
                    TesuryoCyoseiShohin__c = theProducts01.get(0).Id
                ),
            new Product2
                (
                    ShohinBango__c = 'Test201803072130-02',
                    Name = 'Test201803072130-02'
                )
        };
        Insert theProducts;

        List<OpportunityLineItem> theLineItems = new List<OpportunityLineItem>
        {
            new OpportunityLineItem( Product2Id = theProducts.get(0).Id, UnitPrice = 1000, Quantity = 1 )
        };

        Ctl_OpportunityLineItem.RegisteringTesuryoCyoseiMeisais theTarget = new Ctl_OpportunityLineItem.RegisteringTesuryoCyoseiMeisais();
        theTarget.f_ProductsMapByid = 
            new Map<Id,SObject>{
                theProducts.get(0).Id => theProducts.get(0),
                theProducts.get(1).Id => theProducts.get(1)
            };

        Decimal theExpected = -1000;
        List<PatnerUriage__c> theTesuryoMeisais = theTarget.createTesuryoCyoseiMeisais(theLineItems);
        System.debug(theTesuryoMeisais);

        Decimal theResult = theTesuryoMeisais.get(0).Kingaku__c;
        System.assertEquals(theExpected, theResult);

    }

    @isTest
    static void RegisteringTesuryoCyoseiMeisais_onOpportunityLineItemAfterInsert(){
        RecordType defualtAccountRT = new RecordTypeDao().selectRecordBySobjectTypeDeveloperName('Account', 'null');
        Account dacc=new Account();
        dacc.LastName='xxxdefualt';
        //acc.LastNameFurigana__pc ='defualt';
        //acc.FirstNameFurigana__pc ='defualt';
        dacc.Phone='088-0000-0001';
        dacc.MobilePhone__c='888-0000-0001';
        dacc.recordTypeId = defualtAccountRT.Id;
        insert dacc;

        //SetUp
        List<Product2> theProducts01 = new List<Product2>{
            new Product2
                (
                    ShohinBango__c = 'Test201803072130-03',
                    Name = '手数料調整'
                )
        };
        Insert theProducts01;

        List<Product2> theProducts02 = new List<Product2>{
            new Product2
                (
                    ShohinBango__c = 'Test201803081042-01',
                    Name = 'パートナー起因割引',
                    TesuryoCyoseiKingakuKeisanHoushiki__c = '販売金額_符号反転',
                    TesuryoCyoseiShohin__c = theProducts01.get(0).Id
                )
        };
        Insert theProducts02;

        Account theAccount = new Account(Name = '_');
        insert theAccount;
        Opportunity theOpp = new Opportunity(
            AccountId = theAccount.Id,
            Name = '_', StageName = '_', CloseDate = date.valueOf('1900-01-01'), TaishoushaJokyo__c = '_'
            );
        Insert theOpp;

        List<OpportunityLineItem> theLineItems = new List<OpportunityLineItem>
        {
            new OpportunityLineItem(OpportunityId = theOpp.Id, Product2Id = theProducts02.get(0).Id, UnitPrice = 1000, Quantity = 1 )
        };

        Ctl_OpportunityLineItem.RegisteringTesuryoCyoseiMeisais theTarget = new Ctl_OpportunityLineItem.RegisteringTesuryoCyoseiMeisais();

        //Test
        Id theExpectedProdId = theProducts01.get(0).Id;
        Decimal theExpectedKingaku = -1000;
        Id theExpectedOppId = theOpp.Id;

        theTarget.onOpportunityLineItemAfterInsert(theLineItems);
        List<PatnerUriage__c> theTesuryoCyoseiMeisais = 
            [select Id, Syodan__c, Syohin__c, ShohinKamoku__c, Kingaku__c, MeisaiSetsumei__c from PatnerUriage__c where Syodan__c = :theOpp.Id];
        System.debug(theTesuryoCyoseiMeisais);
        
        System.assertEquals( theExpectedProdId, theTesuryoCyoseiMeisais.get(0).Syohin__c);
        System.assertEquals( theExpectedKingaku, theTesuryoCyoseiMeisais.get(0).Kingaku__c);
        System.assertEquals( theExpectedOppId, theTesuryoCyoseiMeisais.get(0).Syodan__c);

    }

}