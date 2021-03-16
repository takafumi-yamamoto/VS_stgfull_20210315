public class AcrtDrTackBat implements Database.Batchable<sObject> ,Database.AllowsCallouts{
    
    @TestVisible
    private static Todays.IToday mTodayInstance = new Todays.Today();
    @TestVisible
    private static AcrtSmsDr.IClient mAcrtSmsDrClientInstance = AcrtSmsDr.getClient();

    public static void start(){
        if( isBatchActive() ) return;
		Integer theBatchSize = 1;
		database.executebatch( new AcrtDrTackBat( mTodayInstance, mAcrtSmsDrClientInstance ),theBatchSize );
    }
	private static Boolean isBatchActive(){
        /*the apex-class-name of AsyncApexJob is not internal class's name but root-class'name*/
        List<AsyncApexJob> theJobs = [
            SELECT Id, ApexClass.Name from AsyncApexJob 
            where Status in ('Holding','Queued','Preparing','Processing') 
            and ApexClass.Name = 'AcrtDrTackBat'
            and JobType in ('BatchApex','BatchApexWorker')
            Limit 1
        ];
        return theJobs.size() >= 1;
    }

    private Todays.IToday mToday = null;
    private AcrtSmsDr.IClient mAcrtSmsDrClient;
    public AcrtDrTackBat( Todays.IToday pToay, AcrtSmsDr.IClient pAcrtSmsDrClient ){
        this.mToday = pToay;
        this.mAcrtSmsDrClient = pAcrtSmsDrClient;
    }

    public List<AcrtDrTack__c> start(Database.BatchableContext BC) { 

        List<AcrtDrTack__c> theRecords = 
            [
                SELECT Id, msg_type__c, scheduled_at__c
                FROM AcrtDrTack__c
                WHERE status__c = 'active'
                AND scheduled_at__c != null
                ORDER BY scheduled_at__c
                LIMIT 100
            ];

		return theRecords;
    }

    public void execute(Database.BatchableContext BC, List<AcrtDrTack__c> pRecords) {
        if( pRecords.size() <= 0 ) return;
        AcrtDrTack__c theRecord = pRecords.get(0);
        try{
            this.exec( theRecord );
        }
        catch(Exception ex){ 
            UPDATE new AcrtDrTack__c(Id = theRecord.Id, status__c = 'error');

            Loggings.writeLog(
                Loggings.createLogEntry(Loggings.Level.Error, '20200806-1948', 'AcrtDrTackBat.execute', theRecord.msg_type__c)
                    .setSubjectRecordId(theRecord.Id)
                    .putAttr('Exception', ex.getMessage())
                    .putAttr('LineNumber', '' + ex.getLineNumber())
                    .putAttr('getStackTraceString', ex.getStackTraceString())
            );
        }
    }

    public void exec(AcrtDrTack__c aRecord){

        AcrtDrTack__c theAcrtDrTack = (AcrtDrTack__c)SobjectsExtension.firstOrNull(
            [
                SELECT Id, delivery_id__c, msg_type__c, status__c, delivery_result_code__c, expired_at__c, scheduled_at__c
                FROM AcrtDrTack__c
                WHERE Id = :aRecord.Id
                LIMIT 1
            ]
        );
        if(theAcrtDrTack == null) return;

        AcrtSmsDr.Result theDrResult = 
            this.mAcrtSmsDrClient.sendRequest(
                new AcrtSmsDr.Req().set_delivery_id( theAcrtDrTack.delivery_id__c )
            );
        String theNewResultCode = theDrResult.res.result_code;

        Boolean toUpdate = theNewResultCode != theAcrtDrTack.delivery_result_code__c;
        if(!toUpdate) return;

        theAcrtDrTack.delivery_result_code__c = theNewResultCode;
            
        Boolean isClosed =
        new List<String>{
            AcrtApiSmsDr.result_code_delivered,
            AcrtApiSmsDr.result_code_undelivered,
            AcrtApiSmsDr.result_code_unknown_subscriber
        }.contains(theNewResultCode);

        Boolean isExpired = false;
        if(isClosed){
            theAcrtDrTack.status__c = 'closed';
        }else{
            if(theAcrtDrTack.expired_at__c <= this.mToday.now() ){
                isExpired = true;
                theAcrtDrTack.status__c = 'expired';
            }else{
                theAcrtDrTack.scheduled_at__c = this.mToday.now().addMinutes(10);
            }
        }

        UPDATE theAcrtDrTack;

        if(isClosed || isExpired){
            INSERT AcrtDrResultQms.createQms( 
                theAcrtDrTack.Id, 
                theAcrtDrTack.msg_type__c,
                theNewResultCode,
                isExpired
                );
        }
    }

    public void finish(Database.BatchableContext BC){}
}