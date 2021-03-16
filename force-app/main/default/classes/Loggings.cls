public class Loggings {

    private static LoggingsConfig__c f_CachedLoggingsConfig;
    private static LoggingsConfig__c getConfig(){
        if(f_CachedLoggingsConfig == null){
            f_CachedLoggingsConfig = LoggingsConfig__c.getInstance( Environments.isSandbox() ? 'dev' : 'prod' ); 
        }
        return f_CachedLoggingsConfig;
    }

    private static Boolean isLevelToWrite(Level pLevel){
        Boolean isMatch = false;
        String theLevelString = convertLevelToString(pLevel).toLowerCase();
        return getLevelsToWriteInLowerCaseStr().contains(theLevelString);
    }
    private static List<String> getLevelsToWriteInLowerCaseStr(){
        List<String> theLevels = new List<String>();
        String theConfigValue = getConfig().LevelsToWrite__c;
        List<String> theLevelsToWrite = String.isEmpty(theConfigValue) ? new List<String>() : theConfigValue.split(',');
        for(String aLevelToWrite : theLevelsToWrite){
            theLevels.add( aLevelToWrite.trim().toLowerCase() );
        }
        return theLevels;
    }

    public enum Level { Error, Warn, Info, Debug }

    public class LogEntry{
        private LogEntry(){}
        private Level level { private get; private set; }

        public String placeCode {
            get { return placeCode; } 
            private set { placeCode = value == null ? null : value.left(200); }
        }
        public String classifier {
            get { return classifier; }
            private set { classifier = value == null ? null : value.left(200); }
        }
        public String subjectRecordId {
            get { return subjectRecordId; }
            private set { subjectRecordId = value == null ? null : value.left(50); }
        }
        public String message {
            get { return message; }
            private set { message = value == null ? null : value.left(1000); }
        }
        public String attributes {
            get { return attributes; }
            private set { attributes = value == null ? null : value.left(30000); }
        }
        private Map<String,String> attrs {
            private get { if(this.attrs == null) this.attrs = new Map<String,String>(); return this.attrs; }
            private set { attrs = value; }
        }
        public LogEntry putAttr(String pKey, String pValue){
            String theKey = String.isBlank(pKey) ? 'none' : pKey.left(200);
            String theValue = pValue == null ? null : pValue.left(5000);
            this.attrs.put(theKey, theValue);
            return this;
        }
        public LogEntry setLevel(Level pValue){ this.level = pValue; return this; }
        public LogEntry setPlaceCode(String pValue){ this.placeCode = pValue; return this; }
        public LogEntry setClassifier(String pValue){ this.classifier = pValue; return this; }
        public LogEntry setSubjectRecordId(String pValue){ this.subjectRecordId = pValue; return this; }
        public LogEntry setMessage(String pValue){ this.message = pValue; return this; }
        public LogEntry setAttributes(String pValue){ this.attributes = pValue; return this; }
        private String getAttrsJson(){
            return JSON.serialize(this.attrs).left(30000);
        }
    }

    public static LogEntry createLogEntry(Level pLevel, String placeCode, String pClassifier, String pMessage){
        return new LogEntry()
            .setLevel(pLevel).setPlaceCode(placeCode).setClassifier(pClassifier).setMessage(pMessage);
    }
    public static LogEntry createLogEntry(Level pLevel, String placeCode, String pClassifier){
        return new LogEntry()
            .setLevel(pLevel).setPlaceCode(placeCode).setClassifier(pClassifier);
    }
    private static LogEntry createLogEntry(LogWriteReq__e pLogWriteReq){
        Loggings.LogEntry theLogEntry = Loggings.createLogEntry(
            Loggings.convertStringToLevel(pLogWriteReq.Level__c),
            pLogWriteReq.PlaceCode__c,
            pLogWriteReq.Classifier__c,
            pLogWriteReq.Message__c
        )
        .setSubjectRecordId(pLogWriteReq.SubjectRecordId__c)
        .setAttributes(pLogWriteReq.Attributes__c);

        Map<String,String> theAttrs = null;
        try{
            theAttrs = (Map<String,String>)JSON.deserialize(pLogWriteReq.Attributes__c, Map<String,String>.class);
        }catch(Exception e){
            System.Debug( e.getMessage() );
        }
        if(theAttrs != null){
            for( String aKey : theAttrs.keySet() ){
                theLogEntry.putAttr( aKey, theAttrs.get(aKey) );
            }
        }
        return theLogEntry;
    }

    private static String convertLevelToString(Level pLevel){
        if(pLevel == Level.Debug) return 'Debug';
        if(pLevel == Level.Error) return 'Error';
        if(pLevel == Level.Info) return 'Info';
        if(pLevel == Level.Warn) return 'Warn';
        return 'None';
    }
    private static Level convertStringToLevel(String pValue){
        if(pValue == 'Debug') return Level.Debug;
        if(pValue == 'Error') return Level.Error;
        if(pValue == 'Info') return Level.Info;
        if(pValue == 'Warn') return Level.Warn;
        return null;
    }

    private static void publishLogWriteEvent(LogEntry pEntry){
        if(pEntry == null) return;
        if( !isLevelToWrite(pEntry.level) ) return;

        LogWriteReq__e theLogWriteReq = new LogWriteReq__e(
            Attributes__c = pEntry.getAttrsJson(),
            Classifier__c = pEntry.classifier,
            Level__c = convertLevelToString( pEntry.Level ),
            Message__c = pEntry.message,
            PlaceCode__c = pEntry.placeCode,
            SubjectRecordId__c = pEntry.subjectRecordId
        );

        Database.SaveResult publishResult = EventBus.publish(theLogWriteReq);
        if( !publishResult.isSuccess() ){
            System.Debug('fail to publish LogWriteReq event.');

            List<LogEntry> theLogsToBeInsertedDirectry = new List<LogEntry>();
            theLogsToBeInsertedDirectry.add(pEntry);
            if( publishResult.getErrors().size() > 0 ){
                theLogsToBeInsertedDirectry.add(
                    createLogEntry(Loggings.Level.Error, '20180704-1458-01','Loggings.LogWriteReq','fail to publish LogWriteReq event.' )
                    .putAttr('getStatusCode', 
                        String.valueOf( publishResult.getErrors().get(0).getStatusCode() ) 
                    )
                    .putAttr('getMessage', publishResult.getErrors().get(0).getMessage() )
                );
            }
            saveLogs(theLogsToBeInsertedDirectry);
        }
    }

    private static void saveLogs(List<LogEntry> pEntries){

        try{
            List<LogEntry> theLogEntriesToWrite = new List<LogEntry>();
            for(LogEntry aLogEntry : pEntries){
                if( isLevelToWrite(aLogEntry.level) ) theLogEntriesToWrite.add(aLogEntry);
            }

            List<Log__c> theLogsToBeInserted = new List<Log__c>();
            for(LogEntry aLogEntry : theLogEntriesToWrite){
                Log__c theLog = new Log__c(
                    Classifier__c = aLogEntry.classifier == null ? null : aLogEntry.classifier.left(200),
                    Level__c = convertLevelToString(aLogEntry.level).left(200),
                    SubjectRecordId__c = aLogEntry.subjectRecordId == null ? '' : aLogEntry.subjectRecordId.left(50),
                    Message__c = aLogEntry.message == null ? null : aLogEntry.message.left(1000),
                    PlaceCode__c = aLogEntry.placeCode == null ? null : aLogEntry.placeCode.left(200),
                    Attributes__c = String.isBlank(aLogEntry.attributes) ? aLogEntry.getAttrsJson().left(30000) : aLogEntry.attributes
                );
                theLogsToBeInserted.add(theLog);
            }
            Insert theLogsToBeInserted;

            if( getConfig().WriteLogAttributeRecords__c ){
                List<LogAttribute__c> theLogAttributesToBeInserted = new List<LogAttribute__c>();
                Integer theIndex = -1;
                for(LogEntry aLogEntry : theLogEntriesToWrite){
                    theIndex ++;
                    Log__c theLog = theLogsToBeInserted.get(theIndex);
                    for( String aKey : aLogEntry.attrs.keySet() ){
                        String theKeyData = aKey.left(200);
                        String theValue = aLogEntry.attrs.get(aKey);
                        String theValueData = theValue == null ? null : theValue.left(5000);
                        LogAttribute__c theLogAttribute = new LogAttribute__c(Log__c = theLog.Id, AttrName__c = theKeyData, AttrVal__c = theValueData);
                        theLogAttributesToBeInserted.add(theLogAttribute);
                    }
                }
                Insert theLogAttributesToBeInserted;
            }

        }catch (Exception e){ 
            System.Debug(e.getMessage());
        }
    }

    public static void writeLog(LogEntry pEntry){
        try{
            if(pEntry == null) return;
            if( !isLevelToWrite(pEntry.level) ) return;

            Long theDMLStatementsLeft = Limits.getLimitDMLStatements() - Limits.getDMLStatements();
            Long theDMLRowsLeft = Limits.getLimitDMLRows() - Limits.getDMLRows();

            if( theDMLStatementsLeft <= getConfig().DmlStatementsLeftToStopLogging__c ) return;
            if( theDMLRowsLeft <= getConfig().DmlRowsLeftToStopLogging__c ) return;
            
            if( theDMLStatementsLeft <= getConfig().DmlStatementsLeftToWarn__c || theDMLRowsLeft <= getConfig().DmlRowsLeftToWarn__c){
                publishLogWriteEvent(
                    Loggings.createLogEntry(Loggings.Level.Warn, '20180704-2009', 'Loggings', 'Loggings governer warning')
                        .putAttr('theDMLStatementsLeft', String.valueOf(theDMLStatementsLeft) )
                        .putAttr('theDMLRowsLeft', String.valueOf(theDMLRowsLeft) )
                );
            }

            publishLogWriteEvent(pEntry);
        }catch(Exception e){
            System.Debug('writeLog failed;' + e.getMessage() );
        }
    }

    public static void subscriveOnLogWriteReqAfterInserted(List<LogWriteReq__e> pNewOnes){
        List<Loggings.LogEntry> theLogEntries = new List<Loggings.LogEntry>();
        for(LogWriteReq__e event : pNewOnes){
            theLogEntries.add( createLogEntry(event) );
        }
        saveLogs(theLogEntries);
    }
    
}