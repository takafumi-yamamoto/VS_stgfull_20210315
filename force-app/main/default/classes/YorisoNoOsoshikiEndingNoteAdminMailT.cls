@isTest
private class YorisoNoOsoshikiEndingNoteAdminMailT {

    @testSetup
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
        YorisoNoOsoshikiEndingNoteAdminMail.CreateMailArg theArg = new YorisoNoOsoshikiEndingNoteAdminMail.CreateMailArg();
        theArg.title = 'test';
        theArg.mailArrivalTime = '';
        theArg.salesforceOrgURL = 'test';
        theArg.jidoShiryoSofuKekka = '';
        theArg.duplicationCheckAccountUrl = '';
        theArg.addressConfirmInfo = '';
        theArg.uniq_id = 'test';
        theArg.kiboAreaState = '';
        theArg.kiboAreaCity = '';
        theArg.toiawaseDate = '';
        MailAlert__c theMailAlert = new YorisoNoOsoshikiEndingNoteAdminMail().createMail(theArg);
    }
}