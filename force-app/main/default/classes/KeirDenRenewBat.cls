public class KeirDenRenewBat implements Database.Batchable<sObject> {

	public static void start(){
		if( isBatchActive() ) return;
		database.executebatch(new KeirDenRenewBat(), 1);
	}
	
	public static String getQuery(){
		String theQuery = 'SELECT ';
		theQuery += 'Id, ';
		theQuery += 'ShodanBango__c, VersionToBeRenewed__c ';
		theQuery += 'FROM KeirDenVer__c ';
		theQuery += 'WHERE ToBeRenewed__c = True ';
		return theQuery;
	}

	public Database.QueryLocator start(Database.BatchableContext BC) { return Database.getQueryLocator( getQuery() ); }
   	public void execute(Database.BatchableContext BC, List<KeirDenVer__c> pRecords) {
   		try{
   			if(pRecords.size() > 1) throw new UnsapportedOpeException('batch size should be 1.');
   			this.run( pRecords.get(0) );
   		}catch(Exception ex){
	        Loggings.writeLog(
                Loggings.createLogEntry(
                    Loggings.Level.Error, '20191115-1857-01', 'KeirDenRenewBat.execute')
                    .putAttr('ex.getMessage()', ex.getMessage())
                    .putAttr('ex.getLineNumber()', '' + ex.getLineNumber())
                    .putAttr('ex.getStackTraceString()', ex.getStackTraceString()
            	)
            );
   		}
   	}

	private void run(KeirDenVer__c pDenVer){
		KeirDenVers.renew( pDenVer.ShodanBango__c, pDenVer.VersionToBeRenewed__c );
	}

	private static Boolean isBatchActive(){
        /*the apex-class-name of AsyncApexJob is not internal class's name but root-class'name*/
        String theBatchName = KeirDenRenewBat.Class.toString();
        List<AsyncApexJob> theJobs = [
            SELECT Id, ApexClass.Name from AsyncApexJob 
            where Status in ('Holding','Queued','Preparing','Processing') 
            and ApexClass.Name = :theBatchName
            and JobType in ('BatchApex','BatchApexWorker')
            Limit 1
        ];
        return theJobs.size() >= 1;
    }
	public void finish(Database.BatchableContext BC) { }

	public class UnsapportedOpeException extends Exception {}
}