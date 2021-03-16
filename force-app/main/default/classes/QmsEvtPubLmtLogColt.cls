public class QmsEvtPubLmtLogColt implements Queueable{

	private Long f_DurationKey = 0;

	private QmsEvtPubLmtLogColt(Long pDurationKey){
		f_DurationKey = pDurationKey;
	}

	private void updateStats(){
		Long theDurationKey = this.f_DurationKey;

		List<QmsEvtPubLmtLog__c> theStats = [
			SELECT Id, PubCnt__c FROM QmsEvtPubLmtLog__c WHERE DurationKey__c = :theDurationKey 
			ORDER BY Name DESC LIMIT 1 
		];

		QmsEvtPubLmtLog__c theCurStat = 
			theStats.size() <= 0 
			? new QmsEvtPubLmtLog__c( DurationKey__c = theDurationKey, PubCnt__c = 0 )
			: theStats.get(0);

		List<QmsEvtPubLmtTmpLog__c> theLogs = [
			SELECT Id, DurationKey__c, PubCnt__c
			FROM QmsEvtPubLmtTmpLog__c
			WHERE DurationKey__c = :theDurationKey AND IsCollected__c = false
			LIMIT 2000
		];

		for(QmsEvtPubLmtTmpLog__c aLog : theLogs){
			theCurStat.PubCnt__c += aLog.PubCnt__c == null ? 0 : (Long)aLog.PubCnt__c;  
			aLog.IsCollected__c = true;
		}

		UPSERT theCurStat;
		UPDATE theLogs;

		Long theDurationKeyTodayStarted = theDurationKey / 100 * 100;
		List<QmsEvtPubLmtTmpLog__c> theLogsSholdBeDeleted = [
			SELECT Id
			FROM QmsEvtPubLmtTmpLog__c
			WHERE DurationKey__c < :theDurationKeyTodayStarted
			LIMIT 2000
		];
		try{ DELETE theLogsSholdBeDeleted; }catch(Exception ex){ } //ignore error.
	}

	public void execute(QueueableContext context) { this.updateStats(); }

    private static Boolean isRunning(){

        List<AsyncApexJob> theJobs = [
            SELECT Id, ApexClass.Name from AsyncApexJob 
            where Status in ('Holding','Queued','Preparing','Processing') 
            and ApexClass.Name = 'QmsEvtPubLmtLogColt'
            and JobType = 'Queueable'
            Limit 1
        ];

        return theJobs.size() >= 1;
    }
	public static void requestStart(Long pDurationKey){
		if(isRunning()) return;
		System.enqueueJob( new QmsEvtPubLmtLogColt(pDurationKey) );
	}
}