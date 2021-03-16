@isTest
public class GlbSearchingByAccountTest {

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
    }

    @isTest
    public static void whenAccountModified_thenSoudanshaInfoOfOppShouldBeUpdated(){

        setUp();

        Map<String,Account> theAccounts = new Map<String, Account>{
            '1' => new Account( 
                RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId(),
                FirstName = 'FirstName', LastName = 'LastName',
                FirstNameFurigana__pc = 'FirstKana', LastNameFurigana__pc = 'LastKana',
                MobilePhone__c = '090-0000-0000', Phone = '03-0000-0000'
                )
        };
        Insert theAccounts.values();

        Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
            '1' => new Opportunity(
                AccountId = theAccounts.get('1').Id, Name = '_',
                StageName = '_', CloseDate = Date.Today()
            )
        };
        Insert theOpps.values();

        Test.startTest();

        Account theAccountAfter = new Account( 
            Id =  theAccounts.get('1').Id, FirstName = 'FirstNameAfter', LastName = 'LastNameAfter',
            FirstNameFurigana__pc = 'FirstKanaAfter', LastNameFurigana__pc = 'LastKanaAfter',
            MobilePhone__c = '090-0000-0000-2', Phone = '03-0000-0000-2'
            );
        Update theAccountAfter;

        Test.getEventBus().deliver();
        Test.stopTest();

        Opportunity theOpp = [
            select Id ,
            SodanshaNameTxt__c, SodanshaFuriganaTxt__c, SodanshaPhoneTxt__c, SodanshaMobilePhoneTxt__c
            from Opportunity 
            where Id = :theOpps.get('1').Id 
            ].get(0);

        System.assertEquals(true, theOpp.SodanshaNameTxt__c.contains(theAccountAfter.FirstName) );
        System.assertEquals(true, theOpp.SodanshaNameTxt__c.contains(theAccountAfter.LastName) );
        System.assertEquals(true, theOpp.SodanshaFuriganaTxt__c.contains(theAccountAfter.FirstNameFurigana__pc) );
        System.assertEquals(true, theOpp.SodanshaFuriganaTxt__c.contains(theAccountAfter.LastNameFurigana__pc) );
        System.assertEquals(true, theOpp.SodanshaPhoneTxt__c.contains(theAccountAfter.Phone) );
        System.assertEquals(true, theOpp.SodanshaMobilePhoneTxt__c.contains(theAccountAfter.MobilePhone__c) );
    }

    @isTest
    public static void whenAccountModified_thenTaishoshaInfoOfOppOfSimpleShouldBeUpdated(){

        setUp();

        Map<String,Account> theAccounts = new Map<String, Account>{
            '1' => new Account( 
                RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId(),
                FirstName = 'FirstName', LastName = 'LastName',
                FirstNameFurigana__pc = 'FirstKana', LastNameFurigana__pc = 'LastKana',
                MobilePhone__c = '090-0000-0000', Phone = '03-0000-0000'
                )
        };
        Insert theAccounts.values();

        Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
            '1' => new Opportunity(
                AccountId = theAccounts.get('1').Id, Name = '_',
                StageName = '_', CloseDate = Date.Today()
            )
        };
        Insert theOpps.values();

        Map<String, SimpleYasugo__c> theSimples = new Map<String,SimpleYasugo__c>{
            '1' => new SimpleYasugo__c( TaishoshaRef__c = theAccounts.get('1').Id )
        };
        Insert theSimples.values();
        
        theOpps.get('1').SimpleYasugoRef__c = theSimples.get('1').Id;
        Update theOpps.get('1');

        Test.startTest();

        Account theAccountAfter = new Account( 
            Id =  theAccounts.get('1').Id, FirstName = 'FirstNameAfter', LastName = 'LastNameAfter',
            FirstNameFurigana__pc = 'FirstKanaAfter', LastNameFurigana__pc = 'LastKanaAfter',
            MobilePhone__c = '090-0000-0000-2', Phone = '03-0000-0000-2'
            );
        Update theAccountAfter;

        Test.getEventBus().deliver();
        Test.stopTest();

        Opportunity theOpp = [
            select Id ,SimpleYasugoRef__c,
            TaisyousyaNameTxt__c, TaisyousyaFurigana__c, TaisyousyaPhone__c, TaisyousyaMobilePhone__c
            from Opportunity 
            where Id = :theOpps.get('1').Id 
            ].get(0);

        System.assertEquals(true, theOpp.TaisyousyaNameTxt__c.contains(theAccountAfter.FirstName) );
        System.assertEquals(true, theOpp.TaisyousyaNameTxt__c.contains(theAccountAfter.LastName) );
        System.assertEquals(true, theOpp.TaisyousyaFurigana__c.contains(theAccountAfter.FirstNameFurigana__pc) );
        System.assertEquals(true, theOpp.TaisyousyaFurigana__c.contains(theAccountAfter.LastNameFurigana__pc) );
        System.assertEquals(true, theOpp.TaisyousyaPhone__c.contains(theAccountAfter.Phone) );
        System.assertEquals(true, theOpp.TaisyousyaMobilePhone__c.contains(theAccountAfter.MobilePhone__c) );
    }

    @isTest
    public static void whenAccountModified_thenMoshuInfoOfOppOfSimpleShouldBeUpdated(){

        setUp();

        Map<String,Account> theAccounts = new Map<String, Account>{
            '1' => new Account( 
                RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId(),
                FirstName = 'FirstName', LastName = 'LastName',
                FirstNameFurigana__pc = 'FirstKana', LastNameFurigana__pc = 'LastKana',
                MobilePhone__c = '090-0000-0000', Phone = '03-0000-0000'
                )
        };
        Insert theAccounts.values();

        Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
            '1' => new Opportunity(
                AccountId = theAccounts.get('1').Id, Name = '_',
                StageName = '_', CloseDate = Date.Today()
            )
        };
        Insert theOpps.values();

        Map<String, SimpleYasugo__c> theSimples = new Map<String,SimpleYasugo__c>{
            '1' => new SimpleYasugo__c( MoshuRef__c = theAccounts.get('1').Id )
        };
        Insert theSimples.values();
        
        theOpps.get('1').SimpleYasugoRef__c = theSimples.get('1').Id;
        Update theOpps.get('1');

        Test.startTest();

        Account theAccountAfter = new Account( 
            Id =  theAccounts.get('1').Id, FirstName = 'FirstNameAfter', LastName = 'LastNameAfter',
            FirstNameFurigana__pc = 'FirstKanaAfter', LastNameFurigana__pc = 'LastKanaAfter',
            MobilePhone__c = '090-0000-0000-2', Phone = '03-0000-0000-2'
            );
        Update theAccountAfter;

        Test.getEventBus().deliver();
        Test.stopTest();

        Opportunity theOpp = [
            select Id ,SimpleYasugoRef__c,
            MosyuNameTxt__c, MosyuFuriganaTxt__c, MosyuPhoneTxt__c, MosyuMobilePhoneTxt__c
            from Opportunity 
            where Id = :theOpps.get('1').Id 
            ].get(0);

        System.assertEquals(true, theOpp.MosyuNameTxt__c.contains(theAccountAfter.FirstName) );
        System.assertEquals(true, theOpp.MosyuNameTxt__c.contains(theAccountAfter.LastName) );
        System.assertEquals(true, theOpp.MosyuFuriganaTxt__c.contains(theAccountAfter.FirstNameFurigana__pc) );
        System.assertEquals(true, theOpp.MosyuFuriganaTxt__c.contains(theAccountAfter.LastNameFurigana__pc) );
        System.assertEquals(true, theOpp.MosyuPhoneTxt__c.contains(theAccountAfter.Phone) );
        System.assertEquals(true, theOpp.MosyuMobilePhoneTxt__c.contains(theAccountAfter.MobilePhone__c) );
    }

    @isTest
    public static void whenAccountModified_thenTaishoshaInfoOfOppOfObouShouldBeUpdated(){

        setUp();

        Map<String,Account> theAccounts = new Map<String, Account>{
            '1' => new Account( 
                RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId(),
                FirstName = 'FirstName', LastName = 'LastName',
                FirstNameFurigana__pc = 'FirstKana', LastNameFurigana__pc = 'LastKana',
                MobilePhone__c = '090-0000-0000', Phone = '03-0000-0000'
                )
        };
        Insert theAccounts.values();

        Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
            '1' => new Opportunity(
                AccountId = theAccounts.get('1').Id, Name = '_',
                StageName = '_', CloseDate = Date.Today()
            )
        };
        Insert theOpps.values();

        Map<String, Obosanbin__c> theObous = new Map<String,Obosanbin__c>{
            '1' => new Obosanbin__c( Taishosha1Ref__c = theAccounts.get('1').Id )
        };
        Insert theObous.values();
        
        theOpps.get('1').ObosanbinRef__c = theObous.get('1').Id;
        Update theOpps.get('1');

        Test.startTest();

        Account theAccountAfter = new Account( 
            Id =  theAccounts.get('1').Id, FirstName = 'FirstNameAfter', LastName = 'LastNameAfter',
            FirstNameFurigana__pc = 'FirstKanaAfter', LastNameFurigana__pc = 'LastKanaAfter',
            MobilePhone__c = '090-0000-0000-2', Phone = '03-0000-0000-2'
            );
        Update theAccountAfter;

        Test.getEventBus().deliver();
        Test.getEventBus().deliver();
        Test.stopTest();

        Opportunity theOpp = [
            select Id ,ObosanbinRef__c,
            TaisyousyaNameTxt__c, TaisyousyaFurigana__c, TaisyousyaPhone__c, TaisyousyaMobilePhone__c
            from Opportunity 
            where Id = :theOpps.get('1').Id 
            ].get(0);
        System.assertEquals(true, theOpp.TaisyousyaNameTxt__c.contains(theAccountAfter.FirstName) );
        System.assertEquals(true, theOpp.TaisyousyaNameTxt__c.contains(theAccountAfter.LastName) );
        System.assertEquals(true, theOpp.TaisyousyaFurigana__c.contains(theAccountAfter.FirstNameFurigana__pc) );
        System.assertEquals(true, theOpp.TaisyousyaFurigana__c.contains(theAccountAfter.LastNameFurigana__pc) );
        System.assertEquals(true, theOpp.TaisyousyaPhone__c.contains(theAccountAfter.Phone) );
        System.assertEquals(true, theOpp.TaisyousyaMobilePhone__c.contains(theAccountAfter.MobilePhone__c) );
    }

    @isTest
    public static void whenAccountModified_thenMoshuInfoOfOppOfObouShouldBeUpdated(){

        setUp();

        Map<String,Account> theAccounts = new Map<String, Account>{
            '1' => new Account( 
                RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId(),
                FirstName = 'FirstName', LastName = 'LastName',
                FirstNameFurigana__pc = 'FirstKana', LastNameFurigana__pc = 'LastKana',
                MobilePhone__c = '090-0000-0000', Phone = '03-0000-0000'
                )
        };
        Insert theAccounts.values();

        Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
            '1' => new Opportunity(
                AccountId = theAccounts.get('1').Id, Name = '_',
                StageName = '_', CloseDate = Date.Today()
            )
        };
        Insert theOpps.values();

        Map<String, Obosanbin__c> theObous = new Map<String,Obosanbin__c>{
            '1' => new Obosanbin__c( MoshuRef__c = theAccounts.get('1').Id )
        };
        Insert theObous.values();
        
        theOpps.get('1').ObosanbinRef__c = theObous.get('1').Id;
        Update theOpps.get('1');

        Test.startTest();

        Account theAccountAfter = new Account( 
            Id =  theAccounts.get('1').Id, FirstName = 'FirstNameAfter', LastName = 'LastNameAfter',
            FirstNameFurigana__pc = 'FirstKanaAfter', LastNameFurigana__pc = 'LastKanaAfter',
            MobilePhone__c = '090-0000-0000-2', Phone = '03-0000-0000-2'
            );
        Update theAccountAfter;

        Test.getEventBus().deliver();
        Test.getEventBus().deliver();
        Test.stopTest();

        Opportunity theOpp = [
            select Id ,ObosanbinRef__c,
            MosyuNameTxt__c, MosyuFuriganaTxt__c, MosyuPhoneTxt__c, MosyuMobilePhoneTxt__c
            from Opportunity 
            where Id = :theOpps.get('1').Id 
            ].get(0);

        System.assertEquals(true, theOpp.MosyuNameTxt__c.contains(theAccountAfter.FirstName) );
        System.assertEquals(true, theOpp.MosyuNameTxt__c.contains(theAccountAfter.LastName) );
        System.assertEquals(true, theOpp.MosyuFuriganaTxt__c.contains(theAccountAfter.FirstNameFurigana__pc) );
        System.assertEquals(true, theOpp.MosyuFuriganaTxt__c.contains(theAccountAfter.LastNameFurigana__pc) );
        System.assertEquals(true, theOpp.MosyuPhoneTxt__c.contains(theAccountAfter.Phone) );
        System.assertEquals(true, theOpp.MosyuMobilePhoneTxt__c.contains(theAccountAfter.MobilePhone__c) );
    }
}