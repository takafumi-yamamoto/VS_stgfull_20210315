@isTest
private class SorKetRenHoyoCachMailT {

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

        SorKetRenHoyoCachMail.CreateMailArg theArg = new SorKetRenHoyoCachMail.CreateMailArg();
        theArg.name = 'opp.Account.name';
        theArg.mailaddress = 'opp.Account.MailAddress__c';
        theArg.jiinName = 'opp.ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.ShozokuSangouSangoJiin__r.Name';
        theArg.jiinNameKana = 'opp.ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.ShozokuSangouSangoJiin__r.SangoJiinMeiFurigana__c';
        theArg.shuha = 'opp.ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.ShozokuSangouSangoJiin__r.JiinSyuha__c';
        theArg.hoyoBashoName = 'opp.ObosanbinRef__r.HoyoBashoMei__c';
        theArg.tsuikaHoyoBashoName = 'tsuikaHoyoBashoName';
        theArg.hoyoryo = 123;
        theArg.nichiji = Datetime.now();

        MailAlert__c theMailAlert = new SorKetRenHoyoCachMail().createMail(theArg);
        //System.Debug(theMailAlert);
    }
}