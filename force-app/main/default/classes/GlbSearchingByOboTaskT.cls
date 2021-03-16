@isTest
public class GlbSearchingByOboTaskT {

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

    @isTest public static void doTest(){

        setUp();

        Map<String,Account> theAccounts = new Map<String, Account>{
            '1' => new Account( 
                RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId(),
                FirstName = 'FirstName', LastName = 'LastName'
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
            '1' => new Obosanbin__c()
        };
        Insert theObous.values();
        
        theOpps.get('1').ObosanbinRef__c = theObous.get('1').Id;
        Update theOpps.get('1');

        Test.startTest();
        theObous.get('1').Taishosha1Ref__c = theAccounts.get('1').Id;
        Update theObous.get('1');
        Test.getEventBus().deliver();
        Test.stopTest();
    }
}