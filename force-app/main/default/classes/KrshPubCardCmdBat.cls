public class KrshPubCardCmdBat implements Schedulable, Database.Batchable<sObject>{

    @TestVisible
    private static Boolean i_will_occur_exception_for_test = false;
	//schedulable-section begin
	public void execute(SchedulableContext context) {
		try{
            KrshPubCardCmdBat.start();
            if(i_will_occur_exception_for_test) throw new Exceptions.AnException();
		}catch(Exception e){
	        Loggings.writeLog(
	            Loggings.createLogEntry(
	                Loggings.Level.Error, '20201027-1132', 'KrshPubCardCmdBat.execute','Batch cant start')
	                .putAttr('e.getMessage()',e.getMessage())
	        );
		}
	}
    //schedulable-section end
    
    public static void start(){
        if( isBatchActive() ) return;

        Integer theBatchSize = 1;
		database.executebatch( 
            new KrshPubCardCmdBat(),
            theBatchSize 
        );
    }
	private static Boolean isBatchActive(){
        /*the apex-class-name of AsyncApexJob is not internal class's name but root-class'name*/
        List<AsyncApexJob> theJobs = [
            SELECT Id, ApexClass.Name from AsyncApexJob 
            where Status in ('Holding','Queued','Preparing','Processing') 
            and ApexClass.Name = 'KrshPubCardCmdBat'
            and JobType in ('BatchApex','BatchApexWorker')
            Limit 1
        ];
        return theJobs.size() >= 1;
    }

    public List<KrshPubCardCmd__c> start(Database.BatchableContext BC) { 
        
        List<KrshPubCardCmd__c> theRecords = 
            [
                SELECT Id
                FROM KrshPubCardCmd__c
                WHERE ShoriStatus__c = 'Created'
            ];

		return theRecords;
    }

    public void execute(Database.BatchableContext BC, List<KrshPubCardCmd__c> pRecords) {

        for(KrshPubCardCmd__c aRecord : pRecords){
            try{
                this.run(aRecord.Id);
            }
            catch(Exception ex){ 
                UPDATE new KrshPubCardCmd__c(Id = aRecord.Id, ShoriStatus__c = 'Failed', ShoriDescr__c = '');
    
                Loggings.writeLog(
                    Loggings.createLogEntry(Loggings.Level.Error, '20201021-1856', 'KrshPubCardCmdBat.execute')
                    .setSubjectRecordId(aRecord.Id)
                    .putAttr('ex.getTypeName()', ex.getTypeName() )
                    .putAttr('ex.getMessage()', ex.getMessage())
                    .putAttr('ex.getLineNumber()', '' + ex.getLineNumber())
                    .putAttr('ex.getStackTraceString()', ex.getStackTraceString())
                );
            }
        }
    }

    public void run(String pKrshPubCardCmd_Id){
        KrshPubCardCmd__c the_KrshPubCardCmd = [ SELECT Id, ShodanBango__c FROM KrshPubCardCmd__c WHERE Id = :pKrshPubCardCmd_Id LIMIT 1 ].get(0);
        

        String Opp_SimpleYasugo_RecTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo');
        Opportunity the_opp = (Opportunity)SobjectsExtension.firstOrNull(
            [
                SELECT Id, ShodanBango__c FROM Opportunity 
                WHERE ShodanBango__c = :the_KrshPubCardCmd.ShodanBango__c
                AND RecordTypeId = :Opp_SimpleYasugo_RecTypeId
                LIMIT 1
            ]
        );
        if(the_opp == null){
            UPDATE new KrshPubCardCmd__c(Id = the_KrshPubCardCmd.Id, ShoriStatus__c = 'Failed', ShoriDescr__c = '該当する商談がありません;');
            return;
        }
        Boolean to_exclude_opps_for_shiragiku_list = false;
        KrshPubSzkSdnShkCards.procceedOpp(the_opp.ShodanBango__c, to_exclude_opps_for_shiragiku_list);

        UPDATE new KrshPubCardCmd__c(Id = the_KrshPubCardCmd.Id, ShoriStatus__c = 'Success');

    }
    
    public void finish(Database.BatchableContext BC){}
}