@isTest
private class YorisoNoOsoshikiShiryoSofuPassWordMailT {

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

        YorisoNoOsoshikiShiryoSofuPassWordMail.CreateMailArg theArg = new YorisoNoOsoshikiShiryoSofuPassWordMail.CreateMailArg();
        theArg.atena = 'よりそう';
        theArg.mailaddress = 'test@yoriso.com';
        theArg.passWord = 'abcdefg';
        MailAlert__c theMailAlert = new YorisoNoOsoshikiShiryoSofuPassWordMail().createMail(theArg);
    }
}