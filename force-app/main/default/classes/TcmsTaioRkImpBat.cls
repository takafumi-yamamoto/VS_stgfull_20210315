public class TcmsTaioRkImpBat implements Database.Batchable<sObject>{

    @TestVisible
    private static TcmsTaioRkImp.ITaioRerekiImporter mTaioRerekiImporter_instance = TcmsTaioRkImp.get_ITaioRerekiImporter_instance();
    @TestVisible
    private static TcmsTaioRkImpOpp.IKanryoShubetsus mKanryoShubetsus_instance = TcmsTaioRkImpOpp.get_IKanryoShubetsus_instance();
    @TestVisible
    private static Boolean i_will_occur_exception_for_test = false;

    public static void start(){
        if( isBatchActive() ) return;

        Integer theBatchSize = 1;
        Integer p_limit_of_batch_load = (Integer)TcmsTaioRkImpConf.getConfig().batch_limit;
		database.executebatch( 
            new TcmsTaioRkImpBat( 
                mTaioRerekiImporter_instance, 
                mKanryoShubetsus_instance,
                p_limit_of_batch_load 
            ),
            theBatchSize 
        );
    }
	private static Boolean isBatchActive(){
        /*the apex-class-name of AsyncApexJob is not internal class's name but root-class'name*/
        List<AsyncApexJob> theJobs = [
            SELECT Id, ApexClass.Name from AsyncApexJob 
            where Status in ('Holding','Queued','Preparing','Processing') 
            and ApexClass.Name = 'TcmsTaioRkImpBat'
            and JobType in ('BatchApex','BatchApexWorker')
            Limit 1
        ];
        return theJobs.size() >= 1;
    }

    private TcmsTaioRkImp.ITaioRerekiImporter mTaioRerekiImporter = null;
    private TcmsTaioRkImpOpp.IKanryoShubetsus mKanryoShubetsus = null;
    private Integer m_limit_of_batch_load = 100;
    public TcmsTaioRkImpBat( 
        TcmsTaioRkImp.ITaioRerekiImporter pTaioRerekiImporter, 
        TcmsTaioRkImpOpp.IKanryoShubetsus pKanryoShubetsus,
        Integer p_limit_of_batch_load
    ){
        this.mTaioRerekiImporter = pTaioRerekiImporter;
        this.mKanryoShubetsus = pKanryoShubetsus;
        this.m_limit_of_batch_load = p_limit_of_batch_load;
    }

    public List<TcmsTaioRkImpData__c> start(Database.BatchableContext BC) { 

        Set<String> the_Kanryo_Shubetsu = this.mKanryoShubetsus.get_Kanryo_Shubetsu_to_create_opps();
        
        List<TcmsTaioRkImpData__c> theRecords = 
            [
                SELECT Id
                FROM TcmsTaioRkImpData__c
                WHERE Shori_Status__c = 'Created'
                AND HasValidationError__c = false
                AND OppRef__c = null
                AND Kanryo_Shubetsu__c IN :the_Kanryo_Shubetsu
                LIMIT :this.m_limit_of_batch_load
            ];

		return theRecords;
    }

    public void execute(Database.BatchableContext BC, List<TcmsTaioRkImpData__c> pRecords) {
        if( pRecords.size() <= 0 ) return;

        for(TcmsTaioRkImpData__c aRecord : pRecords){
            try{
                this.mTaioRerekiImporter.run_import(aRecord.Id);
            }
            catch(Exception ex){ 
                UPDATE new TcmsTaioRkImpData__c( Id = aRecord.Id, Shori_Status__c = 'Failed' );
    
                Loggings.writeLog(
                    Loggings.createLogEntry(Loggings.Level.Error, '20201001-1417', 'TcmsTaioRkImpBat.execute')
                        .setSubjectRecordId( aRecord == null ? null : aRecord.Id)
                        .putAttr('ex.getTypeName()', ex.getTypeName() )
                        .putAttr('ex.getMessage()', ex.getMessage())
                        .putAttr('ex.getLineNumber()', '' + ex.getLineNumber())
                        .putAttr('ex.getStackTraceString', ex.getStackTraceString())
                );
            }
        }

    }

    public void finish(Database.BatchableContext BC){}
}