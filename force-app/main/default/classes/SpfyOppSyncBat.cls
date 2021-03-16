public without sharing class SpfyOppSyncBat implements Database.Batchable<sObject> ,Database.AllowsCallouts{
    
    private static SpfyOppSyncs.IOppSyncer mOppSyncerInstance = SpfyOppSyncs.getOppSyncer();
    private static IBatchStopper mBatchStopperInstance = new BatchStopper();
	public static void start(){
        if( mBatchStopperInstance.toStop() ) return;
        start(false);
    }
    private static void start(Boolean isContinue){
        if( !isContinue && isBatchActive() ) return;
		Integer theBatchSize = 1;
		database.executebatch( new SpfyOppSyncBat(mOppSyncerInstance, mBatchStopperInstance),theBatchSize );
    }
	private static Boolean isBatchActive(){
        /*the apex-class-name of AsyncApexJob is not internal class's name but root-class'name*/
        List<AsyncApexJob> theJobs = [
            SELECT Id, ApexClass.Name from AsyncApexJob 
            where Status in ('Holding','Queued','Preparing','Processing') 
            and ApexClass.Name = 'SpfyOppSyncBat'
            and JobType in ('BatchApex','BatchApexWorker')
            Limit 1
        ];
        return theJobs.size() >= 1;
    }

    private SpfyOppSyncs.IOppSyncer mOppSyncer;
    private IBatchStopper mBatchStopper;
    public SpfyOppSyncBat(SpfyOppSyncs.IOppSyncer pOppSyncer, IBatchStopper pBatchStopper){
        this.mOppSyncer = pOppSyncer;
        this.mBatchStopper = pBatchStopper;
    }
	public List<SpfyOppSyncQue__c> start(Database.BatchableContext BC) { 

        List<SpfyOppSyncQue__c> theQueues = 
            [
                SELECT Id, orderId__c, versionLastSync__c
                FROM SpfyOppSyncQue__c
                WHERE isSyncNeededExp__c = true
                AND lastSyncStatus__c != 'Failed'
                LIMIT 50
            ];
        
        List<SpfyOppSyncBatLockTkn__c> theLockTokens = new List<SpfyOppSyncBatLockTkn__c>();
        for(SpfyOppSyncQue__c aQueue : theQueues){
            theLockTokens.add(
                new SpfyOppSyncBatLockTkn__c( orderId__c = aQueue.orderId__c)
            );
        }
        UPSERT theLockTokens orderId__c;

		return theQueues;
	}
   	public void execute(Database.BatchableContext BC, List<SpfyOppSyncQue__c> pRecords) {
   		try{
            this.exec( pRecords.get(0) );
        }
        catch(Exception ex){ 
            Loggings.writeLog(
                Loggings.createLogEntry(Loggings.Level.Error, '20200617-1722', 'SpfyOppSyncBat.execute')
                    .putAttr('Exception', ex.getMessage())
                    .putAttr('LineNumber', '' + ex.getLineNumber())
                    .putAttr('getStackTraceString', ex.getStackTraceString())
            );
        }
   	}
    public void finish(Database.BatchableContext BC) {
        if( this.mBatchStopper.toStop() ) return;
        Boolean toContinue =
        [
            SELECT Id
            FROM SpfyOppSyncQue__c
            WHERE isSyncNeededExp__c = true
            AND lastSyncStatus__c != 'Failed'
            LIMIT 1
        ].size() > 0;
        if(toContinue) SpfyOppSyncBat.start(true);
    }

    public void exec(SpfyOppSyncQue__c aRecord){

        SpfyOppSyncBatLockTkn__c aLockToken = [
            SELECT Id, orderId__c 
            FROM SpfyOppSyncBatLockTkn__c
            WHERE orderId__c = :aRecord.orderId__c
            LIMIT 1
            FOR UPDATE
        ].get(0);

        SpfyOppSyncQue__c aQue =
        [
            SELECT Id, orderId__c, versionLatest__c, versionLastSync__c 
            FROM SpfyOppSyncQue__c 
            WHERE Id = :aRecord.Id
            LIMIT 1
        ].get(0);
        if( aRecord.versionLastSync__c !=  aQue.versionLastSync__c) return;

        try{
            this.mOppSyncer.syncOrder(aQue.orderId__c);
            UPDATE new SpfyOppSyncQue__c(
                Id = aQue.Id, 
                versionLastSync__c = aQue.versionLatest__c, 
                lastSyncStatus__c = 'Completed'
            );
        }catch(Exception ex){
            UPDATE new SpfyOppSyncQue__c(
                Id = aQue.Id, 
                lastSyncStatus__c = 'Failed'
            );
            Loggings.writeLog(
                Loggings.createLogEntry(Loggings.Level.Error, '20200617-1723', 'SpfyOppSyncBat.exec')
                    .putAttr('aRecord.Id', aRecord.Id)
                    .putAttr('Exception', ex.getMessage())
                    .putAttr('LineNumber', '' + ex.getLineNumber())
                    .putAttr('getStackTraceString', ex.getStackTraceString())
            );
        }
    }

    public interface IBatchStopper {
        Boolean toStop();
    } 
    public class BatchStopper implements IBatchStopper{
        public Boolean toStop(){
            return SpfyConfs.getConfig().stopSyncBatch;
        }
    }
}