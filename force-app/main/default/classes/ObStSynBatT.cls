@isTest
public class ObStSynBatT {

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

    @isTest static void doTest_Sync_Update(){
    	setup();
    	
        Map<String,Account> theAccounts = new Map<String, Account>{
            'お坊契約者' => new Account( 
                RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('SoryoAccount').getRecordTypeId(),
                Name = '_',
                BillingState = '東京都', BillingCity = '品川区', BillingStreet = '西五反田', BillingPostalCode = '1410031',
                BillingLatitude = 35.6253858D, BillingLongitude = 139.7072703D
                ),
            '寺院' => new Account( 
                RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Jiin').getRecordTypeId(),
                Name = '_', JiinSyusi__c = '天台系', JiinSyuha__c = '天台宗'
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

        List<Contact> theContacts = [SELECT Id FROM Contact WHERE AccountId = :theAccounts.get('お坊契約者').Id];
        System.assertEquals(1, theContacts.size());
        Map<String, Event> theEvents = new Map<String, Event>{
			'1' => new Event( 
	        	Subject = '_', WhoId = theContacts.get(0).Id, WhatId = theAccounts.get('お坊契約者').Id,
	        	StartDateTime = Datetime.now().addHours(1),
	        	EndDateTime = Datetime.now().addHours(2)
            )
        };
        Insert theEvents.values();

        DELETE [ SELECT Id FROM OboStSynVersion__c ];
        Keiyaku__c theKeiyaku = [SELECT Id, KeiyakuBango__c From Keiyaku__c WHERE Id = :theKeiyakus.get('お坊契約').Id LIMIT 1];
        INSERT New OboStSynVersion__c(KeiyakuBango__c = theKeiyaku.KeiyakuBango__c, LastVersion__c = 20190426153901L );
        

        OboStApi_Auth.ResBody theOboStApi_AuthRes = new OboStApi_Auth.ResBody();
        theOboStApi_AuthRes.token_type = ''; theOboStApi_AuthRes.expires_in = 0; theOboStApi_AuthRes.access_token = '';
        Test.setMock( HttpCalloutMock.class, 
        	new Testing_HttpResMock()
        		.addResponder(
        			new Testing_HttpResponders.UrlContains()
        				.setStrUrlContains( new OboStConfig().getBaseEndPoint() + '/api/oauth/token' )
        				.setStatusCode(200)
        				.setBody( JSON.serialize(theOboStApi_AuthRes) )
    			)
        		.addResponder(
        			new Testing_HttpResponders.CatchAll()
        				.setStatusCode(200)
    			)
    	);
        Test.startTest();
        List<OboStSynVersion__c> theOboStSynVersions = Database.query(ObStSynBat.getQuery());
        new ObStSynBat().run(theOboStSynVersions);
        Test.stopTest();
    }

    @isTest static void doTest_Sync_Inactivate(){
    	setup();
    	
        Map<String,Account> theAccounts = new Map<String, Account>{
            'お坊契約者' => new Account( 
                RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('SoryoAccount').getRecordTypeId(),
                Name = '_'
                )
        };
        Insert theAccounts.values();
 

        Map<String, Keiyaku__c> theKeiyakus = new Map<String, Keiyaku__c>{
            'お坊契約' => new Keiyaku__c( 
                Teikeisaki__c = theAccounts.get('お坊契約者').Id,
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Keiyaku__c','Obosanbin'),
                KeiyakuJokyo__c = '契約終了'
            )
        };
        Insert theKeiyakus.values();

        DELETE [ SELECT Id FROM OboStSynVersion__c ];
        Keiyaku__c theKeiyaku = [SELECT Id, KeiyakuBango__c From Keiyaku__c WHERE Id = :theKeiyakus.get('お坊契約').Id LIMIT 1];
        INSERT New OboStSynVersion__c(KeiyakuBango__c = theKeiyaku.KeiyakuBango__c, LastVersion__c = 20190426153901L, isExistInZaikoSys__c =true );
        

        OboStApi_Auth.ResBody theOboStApi_AuthRes = new OboStApi_Auth.ResBody();
        theOboStApi_AuthRes.token_type = ''; theOboStApi_AuthRes.expires_in = 0; theOboStApi_AuthRes.access_token = '';
        Test.setMock( HttpCalloutMock.class, 
        	new Testing_HttpResMock()
        		.addResponder(
        			new Testing_HttpResponders.UrlContains()
        				.setStrUrlContains( new OboStConfig().getBaseEndPoint() + '/api/oauth/token' )
        				.setStatusCode(200)
        				.setBody( JSON.serialize(theOboStApi_AuthRes) )
    			)
        		.addResponder(
        			new Testing_HttpResponders.CatchAll()
        				.setStatusCode(200)
    			)
    	);
        Test.startTest();
        List<OboStSynVersion__c> theOboStSynVersions = Database.query(ObStSynBat.getQuery());
        new ObStSynBat().run(theOboStSynVersions);
        Test.stopTest();
    }
}