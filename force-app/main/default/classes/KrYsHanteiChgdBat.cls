public class KrYsHanteiChgdBat implements Database.Batchable<sObject>{

    @TestVisible
    private static KrYsStopKeiyaku.IStopOrUnStopper m_IStopOrUnStopper_instance = 
        KrYsStopKeiyaku.get_IStopOrUnStopper_instance();

    public static void start(){
        if( isBatchActive() ) return;
		Integer theBatchSize = 1;
		database.executebatch( new KrYsHanteiChgdBat( m_IStopOrUnStopper_instance ),theBatchSize );
    }

	private static Boolean isBatchActive(){
        /*the apex-class-name of AsyncApexJob is not internal class's name but root-class'name*/
        List<AsyncApexJob> theJobs = [
            SELECT Id, ApexClass.Name from AsyncApexJob 
            where Status in ('Holding','Queued','Preparing','Processing') 
            and ApexClass.Name = 'KrYsHanteiChgdBat'
            and JobType in ('BatchApex','BatchApexWorker')
            Limit 1
        ];
        return theJobs.size() >= 1;
    }

    private KrYsStopKeiyaku.IStopOrUnStopper m_IStopOrUnStopper;
    public KrYsHanteiChgdBat( KrYsStopKeiyaku.IStopOrUnStopper p_IStopOrUnStopper){
        this.m_IStopOrUnStopper = p_IStopOrUnStopper;
    }
    public List<KrYsYosin__c> start(Database.BatchableContext BC) { 
        List<KrYsYosin__c> theRecords = 
            [
                SELECT Id, YosinHantei_VerLastest__c
                FROM KrYsYosin__c
                WHERE YosinHantei_toProc__c = true
            ];
		return theRecords;
    }

    public void execute(Database.BatchableContext BC, List<KrYsYosin__c> pRecords) {
        KrYsYosin__c theRecord = pRecords.get(0);
        try{
            this.exec( theRecord );
        }
        catch(Exception ex){ 
            Loggings.writeLog(
                Loggings.createLogEntry(Loggings.Level.Error, '20201209-1037', 'KrYsHanteiChgdBat.execute')
                    .setSubjectRecordId(theRecord.Id)
                    .putAttr('ex.getTypeName()', ex.getTypeName() )
                    .putAttr('ex.getMessage()', ex.getMessage())
                    .putAttr('ex.getLineNumber()', '' + ex.getLineNumber())
                    .putAttr('ex.getStackTraceString', ex.getStackTraceString())
            );
            throw ex;
        }
    }

    public void exec(KrYsYosin__c a_record){

        Account a_account = (Account)SobjectsExtension.firstOrNull(
            [
                SELECT Id, TorihikisakiBango__c
                FROM Account
                WHERE KrYsYosinRef__c = :a_record.Id
                LIMIT 1
            ]
        );
        if( a_account == null){ return; }

        this.m_IStopOrUnStopper.stop_or_unstop_by_yosin(a_account.TorihikisakiBango__c);

        UPDATE new KrYsYosin__c(
            Id = a_record.Id,
            YosinHantei_VerLastProc__c = a_record.YosinHantei_VerLastest__c
        );
    }

    public void finish(Database.BatchableContext BC){}
}