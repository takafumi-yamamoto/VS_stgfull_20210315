@isTest
private class SekoKanoSogishaNashiShiryoSofuMailT {

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

        SekoKanoSogishaNashiShiryoSofuMail.CreateMailArg theArg = new SekoKanoSogishaNashiShiryoSofuMail.CreateMailArg();
        theArg.atena = 'よりそう';
        theArg.mailaddress = 'test@yoriso.com';
        theArg.kiboarea = '東京都品川区';
        MailAlert__c theMailAlert = new SekoKanoSogishaNashiShiryoSofuMail().createMail(theArg);
    }
}