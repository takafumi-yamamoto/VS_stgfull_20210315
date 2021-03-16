@isTest
private class Ctl_ShodanCopyT {
	
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
    static void copyFromSimpleYasugo(){

        setUp();

        Map<String,Account> theAccounts = new Map<String, Account>{
            '1' => new Account( 
                RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId(),
                FirstName = 'FirstName', LastName = 'LastName'
                )
        };
        Insert theAccounts.values();

        Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
            'source' => new Opportunity(
                AccountId = theAccounts.get('1').Id, Name = '_',
                StageName = '_', CloseDate = Date.Today(),
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo')
            ),
            'target' => new Opportunity(
                AccountId = theAccounts.get('1').Id, Name = '_',
                StageName = '_', CloseDate = Date.Today(),
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Obosanbin')
            )
        };
        Insert theOpps.values();

		Test.startTest();
		theOpps.get('target').SougiSyoudanRef__c = theOpps.get('source').Id;
		Update theOpps.get('target');
        Test.stopTest();
    }

    @isTest
    static void copyFromRevi(){

        setUp();

        Map<String,Account> theAccounts = new Map<String, Account>{
            '1' => new Account( 
                RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId(),
                FirstName = 'FirstName', LastName = 'LastName'
                )
        };
        Insert theAccounts.values();

        Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
            'source' => new Opportunity(
                AccountId = theAccounts.get('1').Id, Name = '_',
                StageName = '_', CloseDate = Date.Today(),
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SougiRev')
            ),
            'target' => new Opportunity(
                AccountId = theAccounts.get('1').Id, Name = '_',
                StageName = '_', CloseDate = Date.Today(),
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Obosanbin')
            )
        };
        Insert theOpps.values();

		Test.startTest();
		theOpps.get('target').SougiSyoudanRef__c = theOpps.get('source').Id;
		Update theOpps.get('target');
        Test.stopTest();
    }

    @isTest
    static void copyFromObo(){

        setUp();

        Map<String,Account> theAccounts = new Map<String, Account>{
            '1' => new Account( 
                RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId(),
                FirstName = 'FirstName', LastName = 'LastName'
                )
        };
        Insert theAccounts.values();

        Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
            'source' => new Opportunity(
                AccountId = theAccounts.get('1').Id, Name = '_',
                StageName = '_', CloseDate = Date.Today(),
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Obosanbin')
            ),
            'target' => new Opportunity(
                AccountId = theAccounts.get('1').Id, Name = '_',
                StageName = '_', CloseDate = Date.Today(),
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Obosanbin')
            )
        };
        Insert theOpps.values();

		Test.startTest();
		theOpps.get('target').ZennkaiOboOppRef__c = theOpps.get('source').Id;
		Update theOpps.get('target');
        Test.stopTest();
    }

}