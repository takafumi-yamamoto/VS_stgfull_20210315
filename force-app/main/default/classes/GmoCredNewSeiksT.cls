@isTest
private class GmoCredNewSeiksT {

    private static void setUp(){
        Insert new Account(
            RecordTypeId = new RecordTypeDao().selectRecordBySobjectTypeDeveloperName('Account', 'null').Id,
            LastName = '_',
            FirstName = '_'
        );
        Insert new TriggerIsActive__c(
            name = 'default',
            isActive__c = true
        );
        Insert new JizenWariPlan__c(
            Code__c='Yoriso'
        );

        Insert new List<KaiinkibanSetting__c>{
            new KaiinkibanSetting__c(
                name='dev',
                client_id__c='',
                client_secret__c='',
                grant_type__c='',
                timeOutPeriod__c=60000,
                Endpoint__c='http://dev2-rakuso-coreapi-external-alb-767861573.ap-northeast-1.elb.amazonaws.com/',
                KeiyakuCoreFlag__c=true,
                isActive__c=true
            ),
            new KaiinkibanSetting__c(
                name='prod',
                client_id__c='',
                client_secret__c='',
                grant_type__c='',
                timeOutPeriod__c=60000,
                Endpoint__c='http://dev2-rakuso-coreapi-external-alb-767861573.ap-northeast-1.elb.amazonaws.com/',
                KeiyakuCoreFlag__c=true,
                isActive__c=true
            )
        };

        Insert new List<LoggingsConfig__c>{
            new LoggingsConfig__c(
                name='dev', LevelsToWrite__c='Error, Warn, Info', WriteLogAttributeRecords__c=true,
                DmlStatementsLeftToStopLogging__c = 10, DmlStatementsLeftToWarn__c = 20,
                DmlRowsLeftToStopLogging__c = 100, DmlRowsLeftToWarn__c = 200
                ),
            new LoggingsConfig__c(
                name='prod', LevelsToWrite__c='Error, Warn, Info', WriteLogAttributeRecords__c=true,
                DmlStatementsLeftToStopLogging__c = 10, DmlStatementsLeftToWarn__c = 20,
                DmlRowsLeftToStopLogging__c = 100, DmlRowsLeftToWarn__c = 200
                )
        };

        String pMailAddress = 'thisIsTest@thisIsTest.com';
        TesterMails.f_instance = new TesterMails(new TesterMailEnts.TesterMailEntriesStub().addEntry(pMailAddress),
                                            new Environments.Env());

    }

    @isTest
    static void myUnitTest() {
        setUp();

        Map<String, Account> theAccounts = new Map<String, Account>{
            '1' => new Account(
                RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId(),
                FirstName = '_', LastName = '_',
                FirstNameFurigana__pc = '_', LastNameFurigana__pc = '_'
            )
        };
        Insert theAccounts.values();

        Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
            '1' => new Opportunity(
            RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Obosanbin').getRecordTypeId(),
            AccountId = theAccounts.get('1').Id, Name = '_',
            StageName = '_', CloseDate = Date.Today()
            )
        };
        Insert theOpps.values();

        Map<String, Product2> theProds = new Map<String, Product2>{
            '1' => new Product2(
                Name = '_',
                IsActive = true
            )
        };
        Insert theProds.values();

        Map<String, PricebookEntry> theProdEntries = new Map<String, PricebookEntry>{
            '1' => new PricebookEntry(
                Pricebook2Id = Test.getStandardPricebookId(),
                Product2Id = theProds.get('1').Id,
                UnitPrice = 1000,
                IsActive = true
            )
        };
        Insert theProdEntries.values();

        Map<String, OpportunityLineItem> theOppItems = new Map<String, OpportunityLineItem>{
            '1' => new OpportunityLineItem(
                OpportunityId = theOpps.get('1').Id,
                Product2Id = theProds.get('1').Id,
                TotalPrice = 1000
            )
        };
        Insert theOppItems.values();

        String theSeikyuLineOption = 'obou-multi-select';
        SeikyusyoSakuseiController.DataCtx theDataCtx = SeikyusyoSakuseiController.getDataCtx( theOpps.get('1').Id, theSeikyuLineOption );

        Test.startTest();
        Test.setMock( HttpCalloutMock.class, new Testing_HttpResponseMock().setStatusCode(200) );
        try {
            GmoCredNewSeiks.SeikyuRequest theRequest = new GmoCredNewSeiks.SeikyuRequest();
            theRequest.recordId = theDataCtx.recordId;
            theRequest.torihikiShodanId = theDataCtx.torihikiShodanId;
            theRequest.seikyuBango = theDataCtx.seikyuBango;
            theRequest.torihikisakiBango = theDataCtx.torihikisakiBango;
            theRequest.seikyusakiName = theDataCtx.seikyuSakiName;
            theRequest.seikyusakiMail = 'thisIsTest@thisIsTest.com';
            theRequest.seikyusakiPhone = null;
            theRequest.seikyusakiChannel = 'MAIL';
            theRequest.sokujiUriage = false;

            GmoCredNewSeiks.SeikyuLine theSeikyuLine = new GmoCredNewSeiks.SeikyuLine();
            theSeikyuLine.shodanId = theDataCtx.recordId;
            theSeikyuLine.hinmei = '_';
            theSeikyuLine.kingaku = 1000;
            theRequest.seikyuLines = new List<GmoCredNewSeiks.SeikyuLine>();
            theRequest.seikyuLines.add(theSeikyuLine);
            GmoCredNewSeiks.ProcessAnSeikyuRes res = new GmoCredNewSeiks().processNewSeikyu(theRequest);
        } catch(Exception ex) {
            System.debug(ex);
        }

        Test.stopTest();
    }
}