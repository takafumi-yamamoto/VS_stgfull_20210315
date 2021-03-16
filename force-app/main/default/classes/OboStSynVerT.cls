@isTest
public class OboStSynVerT {

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

    @isTest static void whenAccountChanged_thenActiveObouKeiyaku_ShouldBe_Versioned(){
    	setup();
    	
        Map<String,Account> theAccounts = new Map<String, Account>{
            '1' => new Account( 
                RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('SoryoAccount').getRecordTypeId(),
                Name = 'Before'
                )
        };
        Insert theAccounts.values();

        Map<String, Keiyaku__c> theKeiyakus = new Map<String, Keiyaku__c>{
             '未契約' => new Keiyaku__c( 
                Teikeisaki__c = theAccounts.get('1').Id,
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Keiyaku__c','Obosanbin'),
                KeiyakuJokyo__c = '未契約'
            ),
            '契約中' => new Keiyaku__c( 
                Teikeisaki__c = theAccounts.get('1').Id,
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Keiyaku__c','Obosanbin'),
                KeiyakuJokyo__c = '契約中'
            )
        };
        Insert theKeiyakus.values();

        DELETE [ SELECT Id FROM OboStSynVersion__c ];
        Test.startTest();
        theAccounts.get('1').Name = 'After';
        UPDATE theAccounts.get('1');
        Test.stopTest();

        List<OboStSynVersion__c> theOboStSynVersionsAfter = [ SELECT Id,KeiyakuBango__c FROM OboStSynVersion__c ];
        System.assertEquals(1, theOboStSynVersionsAfter.size());
        Keiyaku__c theActiveKeiyaku = [SELECT Id, KeiyakuBango__c From Keiyaku__c WHERE Id = :theKeiyakus.get('契約中').Id LIMIT 1];
        System.assertEquals(
        	theActiveKeiyaku.KeiyakuBango__c , 
        	theOboStSynVersionsAfter.get(0).KeiyakuBango__c,
        	'契約中の契約だけVersion登録されること'
    	);
        
    }


    @isTest static void whenAccountDeleted_thenActiveObouKeiyaku_ShouldBe_Versioned(){
    	setup();
    	
        Map<String,Account> theAccounts = new Map<String, Account>{
            '1' => new Account( 
                RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('SoryoAccount').getRecordTypeId(),
                Name = '_'
                )
        };
        Insert theAccounts.values();

        Map<String, Keiyaku__c> theKeiyakus = new Map<String, Keiyaku__c>{
             '未契約' => new Keiyaku__c( 
                Teikeisaki__c = theAccounts.get('1').Id,
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Keiyaku__c','Obosanbin'),
                KeiyakuJokyo__c = '未契約'
            ),
            '契約中' => new Keiyaku__c( 
                Teikeisaki__c = theAccounts.get('1').Id,
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Keiyaku__c','Obosanbin'),
                KeiyakuJokyo__c = '契約中'
            )
        };
        Insert theKeiyakus.values();
        Keiyaku__c theActiveKeiyaku = [SELECT Id, KeiyakuBango__c From Keiyaku__c WHERE Id = :theKeiyakus.get('契約中').Id LIMIT 1];

        DELETE [ SELECT Id FROM OboStSynVersion__c ];
        Test.startTest();
        DELETE theAccounts.get('1');
        Test.stopTest();

        List<OboStSynVersion__c> theOboStSynVersionsAfter = [ SELECT Id,KeiyakuBango__c FROM OboStSynVersion__c ];
        System.assertEquals(1, theOboStSynVersionsAfter.size());
        
        System.assertEquals(
        	theActiveKeiyaku.KeiyakuBango__c , 
        	theOboStSynVersionsAfter.get(0).KeiyakuBango__c,
        	'契約中の契約だけVersion登録されること'
    	);
        
    }

    @isTest static void whenObouKeiyakuUpdated_thenTheKeiyaku_ShouldBe_Versioned(){
    	setup();
    	
        Map<String,Account> theAccounts = new Map<String, Account>{
            '1' => new Account( 
                RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('SoryoAccount').getRecordTypeId(),
                Name = '_'
                )
        };
        Insert theAccounts.values();

        Map<String, Keiyaku__c> theKeiyakus = new Map<String, Keiyaku__c>{
             '未契約' => new Keiyaku__c( 
                Teikeisaki__c = theAccounts.get('1').Id,
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Keiyaku__c','Obosanbin'),
                KeiyakuJokyo__c = '未契約'
            ),
            '契約中' => new Keiyaku__c( 
                Teikeisaki__c = theAccounts.get('1').Id,
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Keiyaku__c','Obosanbin'),
                KeiyakuJokyo__c = '契約中'
            )
        };
        Insert theKeiyakus.values();
        Keiyaku__c theKeiyakuToBeVersioned = [SELECT Id, KeiyakuBango__c From Keiyaku__c WHERE Id = :theKeiyakus.get('未契約').Id LIMIT 1];

        DELETE [ SELECT Id FROM OboStSynVersion__c ];
        Test.startTest();
        theKeiyakus.get('未契約').KeiyakuJokyo__c = '失効中';
        UPDATE theKeiyakus.get('未契約');
        Test.stopTest();

        List<OboStSynVersion__c> theOboStSynVersionsAfter = [ SELECT Id,KeiyakuBango__c FROM OboStSynVersion__c ];
        System.assertEquals(1, theOboStSynVersionsAfter.size());
        
        System.assertEquals(
        	theKeiyakuToBeVersioned.KeiyakuBango__c , 
        	theOboStSynVersionsAfter.get(0).KeiyakuBango__c,
        	'変更された契約がVersion登録されること'
    	);
        
    }

    @isTest static void whenJohoshaKeiyakuUpdated_thenObouKeiyaku_ShouldBe_Versioned(){
        setup();
        
        Map<String,Account> theAccounts = new Map<String, Account>{
            'お坊契約者' => new Account( 
                RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('SoryoAccount').getRecordTypeId(),
                Name = '_'
                ),
            '助法者' => new Account( 
                RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('SoryoAccount').getRecordTypeId(),
                Name = '_'
                )
        };
        Insert theAccounts.values();

        Map<String, Keiyaku__c> theKeiyakus = new Map<String, Keiyaku__c>{
             'お坊契約' => new Keiyaku__c( 
                Teikeisaki__c = theAccounts.get('お坊契約者').Id,
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Keiyaku__c','Obosanbin'),
                KeiyakuJokyo__c = '契約中'
            )
        };
        INSERT theKeiyakus.values();

        Keiyaku__c theJohoShaKeiyaku = 
            new Keiyaku__c( 
                Teikeisaki__c = theAccounts.get('助法者').Id,
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Keiyaku__c','ObousanBinJohouSya'),
                KeiyakuJokyo__c = '契約中',
                SyuKeiyakuRef__c = theKeiyakus.get('お坊契約').Id
            );
        INSERT theJohoShaKeiyaku;

        Keiyaku__c theKeiyakuToBeVersioned = [SELECT Id, KeiyakuBango__c From Keiyaku__c WHERE Id = :theKeiyakus.get('お坊契約').Id LIMIT 1];

        DELETE [ SELECT Id FROM OboStSynVersion__c ];
        Test.startTest();
        theJohoShaKeiyaku.KeiyakuJokyo__c = '失効中';
        UPDATE theJohoShaKeiyaku;
        Test.stopTest();

        List<OboStSynVersion__c> theOboStSynVersionsAfter = [ SELECT Id,KeiyakuBango__c FROM OboStSynVersion__c ];
        System.assertEquals(1, theOboStSynVersionsAfter.size());
        
        System.assertEquals(
            theKeiyakuToBeVersioned.KeiyakuBango__c , 
            theOboStSynVersionsAfter.get(0).KeiyakuBango__c,
            '主契約(契約中のお坊さん便契約)がVersion登録されること'
        );
        
    }

    @isTest static void whenObouKeiyakuInserted_thenTheKeiyaku_ShouldBe_Versioned(){
        setup();
        
        Map<String,Account> theAccounts = new Map<String, Account>{
            '1' => new Account( 
                RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('SoryoAccount').getRecordTypeId(),
                Name = '_'
                )
        };
        Insert theAccounts.values();

        DELETE [ SELECT Id FROM OboStSynVersion__c ];
        Test.startTest();
        Map<String, Keiyaku__c> theKeiyakus = new Map<String, Keiyaku__c>{
            '契約中' => new Keiyaku__c( 
                Teikeisaki__c = theAccounts.get('1').Id,
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Keiyaku__c','Obosanbin'),
                KeiyakuJokyo__c = '契約中'
            )
        };
        Insert theKeiyakus.values();
        Test.stopTest();

        Keiyaku__c theKeiyakuToBeVersioned = [SELECT Id, KeiyakuBango__c From Keiyaku__c WHERE Id = :theKeiyakus.get('契約中').Id LIMIT 1];

        List<OboStSynVersion__c> theOboStSynVersionsAfter = [ SELECT Id,KeiyakuBango__c FROM OboStSynVersion__c ];
        System.assertEquals(1, theOboStSynVersionsAfter.size());
        
        System.assertEquals(
            theKeiyakuToBeVersioned.KeiyakuBango__c , 
            theOboStSynVersionsAfter.get(0).KeiyakuBango__c,
            'Insertされた契約中の契約はVersion登録されること'
        );
        
    }

    @isTest static void whenJohoshaKeiyakuInserted_thenObouKeiyaku_ShouldBe_Versioned(){
        setup();
        
        Map<String,Account> theAccounts = new Map<String, Account>{
            'お坊契約者' => new Account( 
                RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('SoryoAccount').getRecordTypeId(),
                Name = '_'
                ),
            '助法者' => new Account( 
                RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('SoryoAccount').getRecordTypeId(),
                Name = '_'
                )
        };
        Insert theAccounts.values();

        Map<String, Keiyaku__c> theKeiyakus = new Map<String, Keiyaku__c>{
             'お坊契約' => new Keiyaku__c( 
                Teikeisaki__c = theAccounts.get('お坊契約者').Id,
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Keiyaku__c','Obosanbin'),
                KeiyakuJokyo__c = '契約中'
            )
        };
        INSERT theKeiyakus.values();

        DELETE [ SELECT Id FROM OboStSynVersion__c ];
        Test.startTest();
        Keiyaku__c theJohoShaKeiyaku = 
            new Keiyaku__c( 
                Teikeisaki__c = theAccounts.get('助法者').Id,
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Keiyaku__c','ObousanBinJohouSya'),
                KeiyakuJokyo__c = '契約中',
                SyuKeiyakuRef__c = theKeiyakus.get('お坊契約').Id
            );
        INSERT theJohoShaKeiyaku;
        Test.stopTest();

        Keiyaku__c theKeiyakuToBeVersioned = [SELECT Id, KeiyakuBango__c From Keiyaku__c WHERE Id = :theKeiyakus.get('お坊契約').Id LIMIT 1];
        List<OboStSynVersion__c> theOboStSynVersionsAfter = [ SELECT Id,KeiyakuBango__c FROM OboStSynVersion__c ];
        System.assertEquals(1, theOboStSynVersionsAfter.size());
        
        System.assertEquals(
            theKeiyakuToBeVersioned.KeiyakuBango__c , 
            theOboStSynVersionsAfter.get(0).KeiyakuBango__c,
            '主契約(契約中のお坊さん便契約)がVersion登録されること'
        );
        
    }

    @isTest static void whenObouKeiyakuDeleted_thenTheKeiyaku_ShouldBe_Versioned(){
    	setup();
    	
        Map<String,Account> theAccounts = new Map<String, Account>{
            '1' => new Account( 
                RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('SoryoAccount').getRecordTypeId(),
                Name = '_'
                )
        };
        Insert theAccounts.values();

        Map<String, Keiyaku__c> theKeiyakus = new Map<String, Keiyaku__c>{
             '未契約' => new Keiyaku__c( 
                Teikeisaki__c = theAccounts.get('1').Id,
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Keiyaku__c','Obosanbin'),
                KeiyakuJokyo__c = '未契約'
            ),
            '契約中' => new Keiyaku__c( 
                Teikeisaki__c = theAccounts.get('1').Id,
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Keiyaku__c','Obosanbin'),
                KeiyakuJokyo__c = '契約中'
            )
        };
        Insert theKeiyakus.values();
        Keiyaku__c theKeiyakuToBeVersioned = [SELECT Id, KeiyakuBango__c From Keiyaku__c WHERE Id = :theKeiyakus.get('未契約').Id LIMIT 1];

        DELETE [ SELECT Id FROM OboStSynVersion__c ];
        Test.startTest();
        DELETE theKeiyakus.get('未契約');
        Test.stopTest();

        List<OboStSynVersion__c> theOboStSynVersionsAfter = [ SELECT Id,KeiyakuBango__c FROM OboStSynVersion__c ];
        System.assertEquals(1, theOboStSynVersionsAfter.size());
        
        System.assertEquals(
        	theKeiyakuToBeVersioned.KeiyakuBango__c , 
        	theOboStSynVersionsAfter.get(0).KeiyakuBango__c,
        	'削除された契約がVersion登録されること'
    	);
        
    }

    @isTest static void whenJohoshaKeiyakuDeleted_thenObouKeiyaku_ShouldBe_Versioned(){
    	setup();
    	
        Map<String,Account> theAccounts = new Map<String, Account>{
            'お坊契約者' => new Account( 
                RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('SoryoAccount').getRecordTypeId(),
                Name = '_'
                ),
            '助法者' => new Account( 
                RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('SoryoAccount').getRecordTypeId(),
                Name = '_'
                )
        };
        Insert theAccounts.values();

        Map<String, Keiyaku__c> theKeiyakus = new Map<String, Keiyaku__c>{
             'お坊契約' => new Keiyaku__c( 
                Teikeisaki__c = theAccounts.get('お坊契約者').Id,
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Keiyaku__c','Obosanbin'),
                KeiyakuJokyo__c = '契約中'
            )
        };
        INSERT theKeiyakus.values();

        Keiyaku__c theJohoShaKeiyaku = 
        	new Keiyaku__c( 
                Teikeisaki__c = theAccounts.get('助法者').Id,
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Keiyaku__c','ObousanBinJohouSya'),
                KeiyakuJokyo__c = '契約中',
                SyuKeiyakuRef__c = theKeiyakus.get('お坊契約').Id
            );
        INSERT theJohoShaKeiyaku;

        Keiyaku__c theKeiyakuToBeVersioned = [SELECT Id, KeiyakuBango__c From Keiyaku__c WHERE Id = :theKeiyakus.get('お坊契約').Id LIMIT 1];

        DELETE [ SELECT Id FROM OboStSynVersion__c ];
        Test.startTest();
        DELETE theJohoShaKeiyaku;
        Test.stopTest();

        List<OboStSynVersion__c> theOboStSynVersionsAfter = [ SELECT Id,KeiyakuBango__c FROM OboStSynVersion__c ];
        System.assertEquals(1, theOboStSynVersionsAfter.size());
        
        System.assertEquals(
        	theKeiyakuToBeVersioned.KeiyakuBango__c , 
        	theOboStSynVersionsAfter.get(0).KeiyakuBango__c,
        	'主契約(契約中のお坊さん便契約)がVersion登録されること'
    	);
        
    }

     @isTest static void whenEventInserted_thenActiveObouKeiyaku_ShouldBe_Versioned(){
    	setup();
    	
        Map<String,Account> theAccounts = new Map<String, Account>{
            '1' => new Account( 
                RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('SoryoAccount').getRecordTypeId(),
                Name = '_'
                )
        };
        Insert theAccounts.values();

        Map<String, Keiyaku__c> theKeiyakus = new Map<String, Keiyaku__c>{
             '未契約' => new Keiyaku__c( 
                Teikeisaki__c = theAccounts.get('1').Id,
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Keiyaku__c','Obosanbin'),
                KeiyakuJokyo__c = '未契約'
            ),
            '契約中' => new Keiyaku__c( 
                Teikeisaki__c = theAccounts.get('1').Id,
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Keiyaku__c','Obosanbin'),
                KeiyakuJokyo__c = '契約中'
            )
        };
        Insert theKeiyakus.values();

        List<Contact> theContacts = [SELECT Id FROM Contact WHERE AccountId = :theAccounts.get('1').Id];
        System.assertEquals(1, theContacts.size());
        DELETE [ SELECT Id FROM OboStSynVersion__c ];
        Test.startTest();
        INSERT new Event(
        	Subject = '_', WhoId = theContacts.get(0).Id, WhatId = theAccounts.get('1').Id,
        	StartDateTime = Datetime.newInstance(2019,4,25,18,00,00),
        	EndDateTime = Datetime.newInstance(2019,4,25,19,00,00)
    	);
        Test.stopTest();

        List<OboStSynVersion__c> theOboStSynVersionsAfter = [ SELECT Id,KeiyakuBango__c FROM OboStSynVersion__c ];
        System.assertEquals(1, theOboStSynVersionsAfter.size());
        Keiyaku__c theActiveKeiyaku = [SELECT Id, KeiyakuBango__c From Keiyaku__c WHERE Id = :theKeiyakus.get('契約中').Id LIMIT 1];
        System.assertEquals(
        	theActiveKeiyaku.KeiyakuBango__c , 
        	theOboStSynVersionsAfter.get(0).KeiyakuBango__c,
        	'契約中の契約だけVersion登録されること'
    	);
    }

     @isTest static void whenEventUpdated_thenActiveObouKeiyaku_ShouldBe_Versioned(){
    	setup();
    	
        Map<String,Account> theAccounts = new Map<String, Account>{
            '1' => new Account( 
                RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('SoryoAccount').getRecordTypeId(),
                Name = '_'
                )
        };
        Insert theAccounts.values();

        Map<String, Keiyaku__c> theKeiyakus = new Map<String, Keiyaku__c>{
             '未契約' => new Keiyaku__c( 
                Teikeisaki__c = theAccounts.get('1').Id,
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Keiyaku__c','Obosanbin'),
                KeiyakuJokyo__c = '未契約'
            ),
            '契約中' => new Keiyaku__c( 
                Teikeisaki__c = theAccounts.get('1').Id,
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Keiyaku__c','Obosanbin'),
                KeiyakuJokyo__c = '契約中'
            )
        };
        Insert theKeiyakus.values();

        List<Contact> theContacts = [SELECT Id FROM Contact WHERE AccountId = :theAccounts.get('1').Id];
        System.assertEquals(1, theContacts.size());
        Map<String, Event> theEvents = new Map<String, Event>{
			'1' => new Event( 
	        	Subject = 'Before', WhoId = theContacts.get(0).Id, WhatId = theAccounts.get('1').Id,
	        	StartDateTime = Datetime.newInstance(2019,4,25,18,00,00),
	        	EndDateTime = Datetime.newInstance(2019,4,25,19,00,00)
            )
        };
        Insert theEvents.values();

        DELETE [ SELECT Id FROM OboStSynVersion__c ];
        Test.startTest();
        theEvents.get('1').Subject = 'After';
        UPDATE theEvents.get('1');
        Test.stopTest();

        List<OboStSynVersion__c> theOboStSynVersionsAfter = [ SELECT Id,KeiyakuBango__c FROM OboStSynVersion__c ];
        System.assertEquals(1, theOboStSynVersionsAfter.size());
        Keiyaku__c theActiveKeiyaku = [SELECT Id, KeiyakuBango__c From Keiyaku__c WHERE Id = :theKeiyakus.get('契約中').Id LIMIT 1];
        System.assertEquals(
        	theActiveKeiyaku.KeiyakuBango__c , 
        	theOboStSynVersionsAfter.get(0).KeiyakuBango__c,
        	'契約中の契約だけVersion登録されること'
    	);
    }

     @isTest static void whenEventDeleted_thenActiveObouKeiyaku_ShouldBe_Versioned(){
    	setup();
    	
        Map<String,Account> theAccounts = new Map<String, Account>{
            '1' => new Account( 
                RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('SoryoAccount').getRecordTypeId(),
                Name = '_'
                )
        };
        Insert theAccounts.values();

        Map<String, Keiyaku__c> theKeiyakus = new Map<String, Keiyaku__c>{
             '未契約' => new Keiyaku__c( 
                Teikeisaki__c = theAccounts.get('1').Id,
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Keiyaku__c','Obosanbin'),
                KeiyakuJokyo__c = '未契約'
            ),
            '契約中' => new Keiyaku__c( 
                Teikeisaki__c = theAccounts.get('1').Id,
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Keiyaku__c','Obosanbin'),
                KeiyakuJokyo__c = '契約中'
            )
        };
        Insert theKeiyakus.values();

        List<Contact> theContacts = [SELECT Id FROM Contact WHERE AccountId = :theAccounts.get('1').Id];
        System.assertEquals(1, theContacts.size());
        Map<String, Event> theEvents = new Map<String, Event>{
			'1' => new Event( 
	        	Subject = '_', WhoId = theContacts.get(0).Id, WhatId = theAccounts.get('1').Id,
	        	StartDateTime = Datetime.newInstance(2019,4,25,18,00,00),
	        	EndDateTime = Datetime.newInstance(2019,4,25,19,00,00)
            )
        };
        Insert theEvents.values();

        DELETE [ SELECT Id FROM OboStSynVersion__c ];
        Test.startTest();
        DELETE theEvents.get('1');
        Test.stopTest();

        List<OboStSynVersion__c> theOboStSynVersionsAfter = [ SELECT Id,KeiyakuBango__c FROM OboStSynVersion__c ];
        System.assertEquals(1, theOboStSynVersionsAfter.size());
        Keiyaku__c theActiveKeiyaku = [SELECT Id, KeiyakuBango__c From Keiyaku__c WHERE Id = :theKeiyakus.get('契約中').Id LIMIT 1];
        System.assertEquals(
        	theActiveKeiyaku.KeiyakuBango__c , 
        	theOboStSynVersionsAfter.get(0).KeiyakuBango__c,
        	'契約中の契約だけVersion登録されること'
    	);
    }

     @isTest static void whenPartnerHyokaChanged_thenActiveObouKeiyaku_ShouldBe_Versioned(){
    	setup();
    	
        Map<String,PartnerHyoka__c> thePartnerHyokas = new Map<String, PartnerHyoka__c>{
            '1' => new PartnerHyoka__c(  ServiceRank__c = 'C' )
        };
        Insert thePartnerHyokas.values();

        Map<String,Account> theAccounts = new Map<String, Account>{
            '1' => new Account( 
                RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('SoryoAccount').getRecordTypeId(),
                Name = '_',
                PartnerHyokaRef__c = thePartnerHyokas.get('1').Id
                )
        };
        Insert theAccounts.values();

        Map<String, Keiyaku__c> theKeiyakus = new Map<String, Keiyaku__c>{
             '未契約' => new Keiyaku__c( 
                Teikeisaki__c = theAccounts.get('1').Id,
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Keiyaku__c','Obosanbin'),
                KeiyakuJokyo__c = '未契約'
            ),
            '契約中' => new Keiyaku__c( 
                Teikeisaki__c = theAccounts.get('1').Id,
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Keiyaku__c','Obosanbin'),
                KeiyakuJokyo__c = '契約中'
            )
        };
        Insert theKeiyakus.values();

        DELETE [ SELECT Id FROM OboStSynVersion__c ];
        Test.startTest();
        thePartnerHyokas.get('1').ServiceRank__c = 'A';
        UPDATE thePartnerHyokas.get('1');
        Test.stopTest();

        List<OboStSynVersion__c> theOboStSynVersionsAfter = [ SELECT Id,KeiyakuBango__c FROM OboStSynVersion__c ];
        System.assertEquals(1, theOboStSynVersionsAfter.size());
        Keiyaku__c theActiveKeiyaku = [SELECT Id, KeiyakuBango__c From Keiyaku__c WHERE Id = :theKeiyakus.get('契約中').Id LIMIT 1];
        System.assertEquals(
        	theActiveKeiyaku.KeiyakuBango__c , 
        	theOboStSynVersionsAfter.get(0).KeiyakuBango__c,
        	'契約中の契約だけVersion登録されること'
    	);
    }

}