public class SkgnStatsBat implements Database.Batchable<sObject>{

    @TestVisible
    private static Boolean i_will_raise_error_for_test_coverage = false;

    public static SkgnStatsBat m_SkgnStatsBat_instance;
    public static SkgnStatsBat get_SkgnStatsBat_instance(){
        if( m_SkgnStatsBat_instance == null ){
            m_SkgnStatsBat_instance = new SkgnStatsBat(
                new RecordSelector(),
                SkgnStats.get_ISkgnStatsUpdater_instance()
            );
        }
        return m_SkgnStatsBat_instance;
    }
	public static void start(){
		if( isBatchActive() ) return;
		database.executebatch( get_SkgnStatsBat_instance() , 100);
	}
	private static Boolean isBatchActive(){
        /*the apex-class-name of AsyncApexJob is not internal class's name but root-class'name*/
        List<AsyncApexJob> theJobs = [
            SELECT Id, ApexClass.Name from AsyncApexJob 
            where Status in ('Holding','Queued','Preparing','Processing') 
            and ApexClass.Name = 'SkgnStatsBat'
            and JobType in ('BatchApex','BatchApexWorker')
            Limit 1
        ];
        return theJobs.size() >= 1;
    }

    public interface IRecordSelector{
        Database.QueryLocator get_query_locator();
    }
    public class RecordSelector implements IRecordSelector{
        public Database.QueryLocator get_query_locator(){
    
            return Database.getQueryLocator(
                [
                    SELECT Id
                    FROM Shikugun__c
                ]	
            );
        }
    }

    private IRecordSelector m_IRecordSelector;
    private SkgnStats.ISkgnStatsUpdater m_ISkgnStatsUpdater;
    public SkgnStatsBat(
        IRecordSelector p_IRecordSelector,
        SkgnStats.ISkgnStatsUpdater p_ISkgnStatsUpdater
    ){
        this.m_IRecordSelector = p_IRecordSelector;
        this.m_ISkgnStatsUpdater = p_ISkgnStatsUpdater;
    }

    public Database.QueryLocator start(Database.BatchableContext BC) { return this.m_IRecordSelector.get_query_locator(); }

    public void execute(Database.BatchableContext BC, List<Shikugun__c> p_records) {

        List<String> the_shikugun_ids = new List<String>();
        for(Shikugun__c a_Shikugun : p_records){ the_shikugun_ids.add(a_Shikugun.Id); }

        try{
            this.m_ISkgnStatsUpdater.update_shikugun_stats(the_shikugun_ids);
            if( i_will_raise_error_for_test_coverage ){ throw new Exceptions.AnException(); }
        }catch(Exception ex){
            Loggings.writeLog(
                Loggings.createLogEntry(Loggings.Level.Error, '20210127-1532', 'SkgnStatsBat.execute')
                    .putAttr('ex.getTypeName()', ex.getTypeName() )
                    .putAttr('ex.getMessage()', ex.getMessage())
                    .putAttr('ex.getLineNumber()', '' + ex.getLineNumber())
                    .putAttr('ex.getStackTraceString', ex.getStackTraceString())
                    .putAttr('JSON.serialize(the_shikugun_ids)', JSON.serialize(the_shikugun_ids))
            );
        }

    }
    public void finish(Database.BatchableContext BC) { }
}