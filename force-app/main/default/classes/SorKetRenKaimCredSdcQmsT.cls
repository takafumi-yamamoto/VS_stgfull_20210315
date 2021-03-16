@isTest
private class SorKetRenKaimCredSdcQmsT {

    private static void setUp(){
        Insert new TriggerIsActive__c( name='default', isActive__c=true );
        Insert new JizenWariPlan__c( Code__c='Yoriso' );
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
        Insert new Account(
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId(),
            FirstName = '_', LastName = '_'
        );
        String pPhoneAddress = '088-1010-1234';
        TesterPhones.f_instance = new TesterPhones(new TesterPhoneEnts.TesterPhoneEntriesStub(),
                                            new Environments.EnvStub().setIsSandBoxFalse());
        TesterPhones.getInstance().raiseNotTesterExIfNotAllowed(pPhoneAddress);
    }

    @isTest
    static void doTest(){
        setUp();

        Map<String,Account> theAccounts = new Map<String, Account>{

            'お客様' => new Account(
                RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId(),
                FirstName = '_', LastName = '_',
                FirstNameFurigana__pc = '_', LastNameFurigana__pc = '_',
                MailAddress__c = 'yoriso-yoriso@yoriso-yoriso.test'
            ),
            'お坊契約者' => new Account(
                RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('SoryoAccount').getRecordTypeId(),
                Name = '_',
                BillingState = '東京都', BillingCity = '品川区', BillingStreet = '西五反田', BillingPostalCode = '1410031',
                BillingLatitude = 35.6253858D, BillingLongitude = 139.7072703D
                ),
            '寺院' => new Account(
                RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Jiin').getRecordTypeId(),
                Name = '_', JiinSyusi__c = '天台系', JiinSyuha__c = '天台宗', SangoJiinMeiFurigana__c= 'フリガナ'
                ),
            '助法者' => new Account(
                RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('SoryoAccount').getRecordTypeId(),
                Name = '_'
                )
        };
        Insert theAccounts.values();
        theAccounts.get('お坊契約者').ShozokuSangouSangoJiin__c = theAccounts.get('寺院').Id;
        UPDATE theAccounts.get('お坊契約者');

        Map<String, Keiyaku__c> theKeiyakus = new Map<String, Keiyaku__c>{
            'お坊契約' => new Keiyaku__c(
                Teikeisaki__c = theAccounts.get('お坊契約者').Id,
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Keiyaku__c','Obosanbin'),
                KeiyakuJokyo__c = '契約中',
                TaioufukaDay__c = '平日不可', Kaimyojuyonomiirai__c = '不可能'
            ),
            '助法者契約' => new Keiyaku__c(
                Teikeisaki__c = theAccounts.get('助法者').Id,
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Keiyaku__c','ObousanBinJohouSya'),
                KeiyakuJokyo__c = '契約中'
            )
        };
        Insert theKeiyakus.values();
        theKeiyakus.get('助法者契約').SyuKeiyakuRef__c = theKeiyakus.get('お坊契約').Id;
        UPDATE theKeiyakus.get('助法者契約');

        Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
            '1' => new Opportunity(
            RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Obosanbin').getRecordTypeId(),
            AccountId = theAccounts.get('お客様').Id, Name = '_',
            StageName = '_', CloseDate = Date.Today(),
            SoryoKetteiRenrakuHoho__c= 'メール',
            SubPhase__c = '僧侶決定連絡',
            Amount=123456
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

        Id oppId = theOpps.get('1').Id;
        Opportunity theOpp = [Select id, ShodanBango__c, ObosanbinRef__c From Opportunity Where Id=:oppId ];
        update new Obosanbin__c(Id=theOpp.ObosanbinRef__c,
            KokubetsuDateTime_Inp__c = Datetime.now().addDays(1),
            HoyoBashoMei__c = 'HoyoBashoMei__c',
            hoyo_postcode__c = 'test',
            hoyo_todofuken__c = 'test',
            hoyo_shikugun__c = 'test',
            hoyo_tyoumei__c = 'test',
            hoyo_banchi__c = 'test',
            ObosanbinKeiyakuMadoguchi__c = theKeiyakus.get('お坊契約').Id
            );


        Test.startTest();
        SorKetRenKaimCredSdcQms.InsertAsRoot(theOpp.ShodanBango__c);
        Test.stopTest();
    }
    @isTest
    static void doTest_Exception(){
        setUp();

        Map<String,Account> theAccounts = new Map<String, Account>{

            'お客様' => new Account(
                RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId(),
                FirstName = '_', LastName = '_',
                FirstNameFurigana__pc = '_', LastNameFurigana__pc = '_',
                MailAddress__c = 'yoriso-yoriso@yoriso-yoriso.test'
            ),
            'お坊契約者' => new Account(
                RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('SoryoAccount').getRecordTypeId(),
                Name = '_',
                BillingState = '東京都', BillingCity = '品川区', BillingStreet = '西五反田', BillingPostalCode = '1410031',
                BillingLatitude = 35.6253858D, BillingLongitude = 139.7072703D
                ),
            '寺院' => new Account(
                RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Jiin').getRecordTypeId(),
                Name = '_', JiinSyusi__c = '天台系', JiinSyuha__c = '天台宗', SangoJiinMeiFurigana__c= 'フリガナ'
                ),
            '助法者' => new Account(
                RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('SoryoAccount').getRecordTypeId(),
                Name = '_'
                )
        };
        Insert theAccounts.values();
        theAccounts.get('お坊契約者').ShozokuSangouSangoJiin__c = theAccounts.get('寺院').Id;
        UPDATE theAccounts.get('お坊契約者');

        Map<String, Keiyaku__c> theKeiyakus = new Map<String, Keiyaku__c>{
            'お坊契約' => new Keiyaku__c(
                Teikeisaki__c = theAccounts.get('お坊契約者').Id,
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Keiyaku__c','Obosanbin'),
                KeiyakuJokyo__c = '契約中',
                TaioufukaDay__c = '平日不可', Kaimyojuyonomiirai__c = '不可能'
            ),
            '助法者契約' => new Keiyaku__c(
                Teikeisaki__c = theAccounts.get('助法者').Id,
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Keiyaku__c','ObousanBinJohouSya'),
                KeiyakuJokyo__c = '契約中'
            )
        };
        Insert theKeiyakus.values();
        theKeiyakus.get('助法者契約').SyuKeiyakuRef__c = theKeiyakus.get('お坊契約').Id;
        UPDATE theKeiyakus.get('助法者契約');

        Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
            '1' => new Opportunity(
            RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Obosanbin').getRecordTypeId(),
            AccountId = theAccounts.get('お客様').Id, Name = '_',
            StageName = '_', CloseDate = Date.Today(),
            SoryoKetteiRenrakuHoho__c= 'メール',
            SubPhase__c = '僧侶決定連絡'
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

        Id oppId = theOpps.get('1').Id;
        Opportunity theOpp = [Select id, ShodanBango__c, ObosanbinRef__c From Opportunity Where Id=:oppId ];
        update new Obosanbin__c(Id=theOpp.ObosanbinRef__c,
            KokubetsuDateTime_Inp__c = Datetime.now().addDays(1),
            HoyoBashoMei__c = 'HoyoBashoMei__c',
            hoyo_postcode__c = 'test',
            hoyo_todofuken__c = 'test',
            hoyo_shikugun__c = 'test',
            hoyo_tyoumei__c = 'test',
            hoyo_banchi__c = 'test',
            ObosanbinKeiyakuMadoguchi__c = theKeiyakus.get('お坊契約').Id
            );


        Test.startTest();
        SorKetRenKaimCredSdcQms.InsertAsRoot(theOpp.ShodanBango__c);
        Test.stopTest();
    }
}