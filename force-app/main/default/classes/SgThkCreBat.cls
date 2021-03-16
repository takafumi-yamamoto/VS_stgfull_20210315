public class SgThkCreBat implements Database.Batchable<sObject>{

    @TestVisible
    private static Boolean i_will_raise_error_for_test_coverage = false;

    public static SgThkCreBat m_SgThkCreBat_instance;
    public static SgThkCreBat get_SgThkCreBat_instance(){
        if( m_SgThkCreBat_instance == null ){
            m_SgThkCreBat_instance = new SgThkCreBat(
                new RecordSelector(
                    new Todays.Today()
                ),
                SgThkCre.get_ISogiSekogoThankYouCallCreator_instance()
            );
        }
        return m_SgThkCreBat_instance;
    }

	public static void start(){
		if( isBatchActive() ) return;
		database.executebatch( get_SgThkCreBat_instance() , 1);
	}
	private static Boolean isBatchActive(){
        /*the apex-class-name of AsyncApexJob is not internal class's name but root-class'name*/
        List<AsyncApexJob> theJobs = [
            SELECT Id, ApexClass.Name from AsyncApexJob 
            where Status in ('Holding','Queued','Preparing','Processing') 
            and ApexClass.Name = 'SgThkCreBat'
            and JobType in ('BatchApex','BatchApexWorker')
            Limit 1
        ];
        return theJobs.size() >= 1;
    }

    public interface IRecordSelector{
        Database.QueryLocator get_query_locator();
    }
    public class RecordSelector implements IRecordSelector{
        private Todays.IToday m_IToday;
        public RecordSelector(Todays.IToday p_IToday){
            this.m_IToday = p_IToday;
        }
        public Database.QueryLocator get_query_locator(){
            Date theFromDate = m_IToday.date().addDays(-1);
            Date theToDate = theFromDate;
    
            return Database.getQueryLocator(
                [
                    SELECT Id
                    FROM Opportunity
                    WHERE RecordType.DeveloperName = 'SimpleYasugo'
                    AND StageName IN ('決定','施行完了', '施行待ち','商談クローズ')
                    AND 
                    (
                        (
                            Utiagebi__c >= :theFromDate 
                            AND 
                            Utiagebi__c <= :theToDate
                        )
                    )
                ]	
            );
        }
    }

    private IRecordSelector m_IRecordSelector;
    private SgThkCre.ISogiSekogoThankYouCallCreator m_ISogiSekogoThankYouCallCreator;
    public SgThkCreBat(
        IRecordSelector p_IRecordSelector,
        SgThkCre.ISogiSekogoThankYouCallCreator p_ISogiSekogoThankYouCallCreator
    ){
        this.m_IRecordSelector = p_IRecordSelector;
        this.m_ISogiSekogoThankYouCallCreator = p_ISogiSekogoThankYouCallCreator;
    }
    public Database.QueryLocator start(Database.BatchableContext BC) { return this.m_IRecordSelector.get_query_locator(); }

    public void execute(Database.BatchableContext BC, List<Opportunity> p_records) {
        for( Opportunity a_record : p_records){
            try{
                this.m_ISogiSekogoThankYouCallCreator.try_create(a_record.Id);
                if( i_will_raise_error_for_test_coverage ){ throw new Exceptions.AnException(); }
            }catch(Exception ex){
                Loggings.writeLog(
                    Loggings.createLogEntry(Loggings.Level.Error, '20210117-0925', 'SgThkCreBat.execute')
                        .setSubjectRecordId( a_record.Id )
                        .putAttr('ex.getTypeName()', ex.getTypeName() )
                        .putAttr('ex.getMessage()', ex.getMessage())
                        .putAttr('ex.getLineNumber()', '' + ex.getLineNumber())
                        .putAttr('ex.getStackTraceString', ex.getStackTraceString())
                );
            }
        }
    }
    public void finish(Database.BatchableContext BC) { }
}