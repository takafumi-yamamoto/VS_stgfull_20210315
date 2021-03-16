@isTest
public class LoggingsTest {

    private static void setUp(){
        Insert new TriggerIsActive__c( name='default', isActive__c=true );
        Insert new JizenWariPlan__c( Code__c='Yoriso' );
    }

    @isTest
    public static void logShouldBeSaved(){

        setUp();

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

        Test.startTest();
        Loggings.writeLog(
            Loggings.createLogEntry(Loggings.Level.Error, '<PlaceCode__c>', '<Classifier__c>', '<Message__c>')
                .setSubjectRecordId('<SubjectRecordId__c>')
                .putAttr('key1','value1')
                .putAttr('key2','value2')
        );

        Test.getEventBus().deliver();
        Test.stopTest();

        Log__c theLog = new List<Log__c>(
            [
                select Id, Level__c, Classifier__c, Message__c, PlaceCode__c, SubjectRecordId__c, Attributes__c,
                (
                    select AttrName__c, AttrVal__c
                    from LogAttributes__r
                )
                from Log__c
            ]
        )
        .get(0)
        ;

        System.assertEquals('Error', theLog.Level__c );
        System.assertEquals('<Classifier__c>', theLog.Classifier__c );
        System.assertEquals('<Message__c>', theLog.Message__c );
        System.assertEquals('<SubjectRecordId__c>', theLog.SubjectRecordId__c );
        System.assertEquals(2, theLog.LogAttributes__r.size() );
        //System.Debug(theLog);
    }

    @isTest
    public static void onlyLevelsSpecifiedShouldBeLogged(){

        setUp();

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

        Test.startTest();
        Loggings.writeLog(
            Loggings.createLogEntry(Loggings.Level.Info, '20180704-1540-01', 'Loggings.Test.info', 'onlyLevelsSpecifiedShouldBeLogged')
        );
        Loggings.writeLog(
            Loggings.createLogEntry(Loggings.Level.Debug, '20180704-1540-02', 'Loggings.Test.Debug', 'onlyLevelsSpecifiedShouldBeLogged')
        );
        Test.getEventBus().deliver();
        Test.stopTest();

        List<Log__c> theLogs = new List<Log__c>(
            [
                select Id, Level__c
                from Log__c
            ]
        );
        System.assertEquals(1, theLogs.size() );
        System.assertEquals('Info', theLogs.get(0).Level__c );
    }

    @isTest
    public static void ifWriteLogAttributeRecordsTurnedOff_thenAttrRecordsShouldNotBeInserted(){

        setUp();

        Insert new List<LoggingsConfig__c>{
            new LoggingsConfig__c( 
                name='dev', LevelsToWrite__c='Error, Warn, Info', WriteLogAttributeRecords__c=false,
                DmlStatementsLeftToStopLogging__c = 10, DmlStatementsLeftToWarn__c = 20,
                DmlRowsLeftToStopLogging__c = 100, DmlRowsLeftToWarn__c = 200
                ),
            new LoggingsConfig__c( 
                name='prod', LevelsToWrite__c='Error, Warn, Info', WriteLogAttributeRecords__c=false,
                DmlStatementsLeftToStopLogging__c = 10, DmlStatementsLeftToWarn__c = 20,
                DmlRowsLeftToStopLogging__c = 100, DmlRowsLeftToWarn__c = 200
                )
        };

        Test.startTest();
        Loggings.writeLog(
            Loggings.createLogEntry(Loggings.Level.Error, '<PlaceCode__c>', '<Classifier__c>', '<Message__c>')
                .setSubjectRecordId('<SubjectRecordId__c>')
                .putAttr('key1','value1')
                .putAttr('key2','value2')
        );

        Test.getEventBus().deliver();
        Test.stopTest();

        Log__c theLog = new List<Log__c>(
            [
                select Id, Level__c, Classifier__c, Message__c, PlaceCode__c, SubjectRecordId__c, Attributes__c,
                (
                    select AttrName__c, AttrVal__c
                    from LogAttributes__r
                )
                from Log__c
            ]
        )
        .get(0)
        ;
        System.assertEquals(0, theLog.LogAttributes__r.size() );
        System.assertEquals(true, theLog.Attributes__c.contains('key1') );
        System.assertEquals(true, theLog.Attributes__c.contains('value2') );
        
        System.Debug(theLog);
    }

    @isTest
    public static void ifStoppingGovernerPolicyOver_thenLoggingShouldBeStopped(){

        setUp();

        Insert new List<LoggingsConfig__c>{
            new LoggingsConfig__c( 
                name='dev', LevelsToWrite__c='Error, Warn, Info', WriteLogAttributeRecords__c=true,
                DmlStatementsLeftToStopLogging__c = 10000000, DmlStatementsLeftToWarn__c = 20,
                DmlRowsLeftToStopLogging__c = 10000000, DmlRowsLeftToWarn__c = 200
                ),
            new LoggingsConfig__c( 
                name='prod', LevelsToWrite__c='Error, Warn, Info', WriteLogAttributeRecords__c=true,
                DmlStatementsLeftToStopLogging__c = 10000000, DmlStatementsLeftToWarn__c = 20,
                DmlRowsLeftToStopLogging__c = 10000000, DmlRowsLeftToWarn__c = 200
                )
        };

        Test.startTest();
        Loggings.writeLog(
            Loggings.createLogEntry(Loggings.Level.Error, '<PlaceCode__c>', '<Classifier__c>', '<Message__c>')
                .setSubjectRecordId('<SubjectRecordId__c>')
                .putAttr('key1','value1')
                .putAttr('key2','value2')
        );

        Test.getEventBus().deliver();
        Test.stopTest();

        List<Log__c> theLogs = new List<Log__c>(
            [
                select Id, Level__c, Classifier__c, Message__c, PlaceCode__c, SubjectRecordId__c, Attributes__c,
                (
                    select AttrName__c, AttrVal__c
                    from LogAttributes__r
                )
                from Log__c
            ]
        )
        ;
        System.assertEquals(0, theLogs.size() );
        //System.Debug(theLog);
    }

    @isTest
    public static void ifWarningGovernerPolicyOver_thenWarningShouldBeLogged(){

        setUp();

        Insert new List<LoggingsConfig__c>{
            new LoggingsConfig__c( 
                name='dev', LevelsToWrite__c='Error, Warn, Info', WriteLogAttributeRecords__c=true,
                DmlStatementsLeftToStopLogging__c = 0, DmlStatementsLeftToWarn__c = 1000000,
                DmlRowsLeftToStopLogging__c = 0, DmlRowsLeftToWarn__c = 1000000
                ),
            new LoggingsConfig__c( 
                name='prod', LevelsToWrite__c='Error, Warn, Info', WriteLogAttributeRecords__c=true,
                DmlStatementsLeftToStopLogging__c = 0, DmlStatementsLeftToWarn__c = 1000000,
                DmlRowsLeftToStopLogging__c = 0, DmlRowsLeftToWarn__c = 1000000
                )
        };

        Test.startTest();
        Insert new Log__c( );
        Loggings.writeLog(
            Loggings.createLogEntry(Loggings.Level.Error, '<PlaceCode__c>', '<Classifier__c>', '<Message__c>')
                .setSubjectRecordId('<SubjectRecordId__c>')
                .putAttr('key1','value1')
                .putAttr('key2','value2')
        );

        Test.getEventBus().deliver();
        Test.stopTest();

        List<Log__c> theLogs = new List<Log__c>(
            [
                select Id, Level__c, Classifier__c, Message__c, PlaceCode__c, SubjectRecordId__c, Attributes__c,
                (
                    select AttrName__c, AttrVal__c
                    from LogAttributes__r
                )
                from Log__c
            ]
        )
        ;
        System.assertEquals(3, theLogs.size() );
        System.Debug(theLogs);
    }

}