@isTest
private class SorKetRenErrMailT {

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

    @isTest static void doTest() {
        setUp();

        Map<String,Log__c> theDummyObjIds = new Map<String, Log__c>{
            'DummyOppId' => new Log__c()
        };
        INSERT theDummyObjIds.values();

        SorKetRenErrMail.CreateMailArg theArg = new SorKetRenErrMail.CreateMailArg();
        theArg.ShodanId = theDummyObjIds.get('DummyOppId').Id;
        theArg.errorMessage = 'ex.getMessage() + ex.getStackTraceString()';

        MailAlert__c theMailAlert = new SorKetRenErrMail().createMail(theArg);
        //System.Debug(theMailAlert);
    }
}