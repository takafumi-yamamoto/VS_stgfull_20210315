public class SzsdPubCardBat implements Database.Batchable<sObject>{

    @TestVisible
    private static Boolean i_will_raise_error_for_test_coverage = false;

    public static SzsdPubCardBat m_SzsdPubCardBat_instance;
    public static SzsdPubCardBat get_SzsdPubCardBat_instance(){
        if( m_SzsdPubCardBat_instance == null ){
            m_SzsdPubCardBat_instance = new SzsdPubCardBat(
                new RecordSelector(
                    new Todays.Today()
                ),
                SzsdPubCard.get_ICardPublisher_instance()
            );
        }
        return m_SzsdPubCardBat_instance;
    }

	public static void start(){
		if( isBatchActive() ) return;
		database.executebatch( get_SzsdPubCardBat_instance() , 1);
	}
	private static Boolean isBatchActive(){
        /*the apex-class-name of AsyncApexJob is not internal class's name but root-class'name*/
        List<AsyncApexJob> theJobs = [
            SELECT Id, ApexClass.Name from AsyncApexJob 
            where Status in ('Holding','Queued','Preparing','Processing') 
            and ApexClass.Name = 'SzsdPubCardBat'
            and JobType in ('BatchApex','BatchApexWorker')
            Limit 1
        ];
        return theJobs.size() >= 1;
    }

    private IRecordSelector m_IRecordSelector;
    private SzsdPubCard.ICardPublisher m_ICardPublisher;
    public SzsdPubCardBat(
        IRecordSelector p_IRecordSelector,
        SzsdPubCard.ICardPublisher p_ICardPublisher
    ){
        this.m_IRecordSelector = p_IRecordSelector;
        this.m_ICardPublisher = p_ICardPublisher;
    }

    public Database.QueryLocator start(Database.BatchableContext BC) { return this.m_IRecordSelector.get_query_locator(); }

    public void execute(Database.BatchableContext BC, List<Opportunity> p_records) {
        for( Opportunity a_record : p_records){
            try{
                Boolean is_hakkou_shijji_directly = false;
                this.m_ICardPublisher.try_publish_card(a_record.Id, is_hakkou_shijji_directly);
                if( i_will_raise_error_for_test_coverage ){ throw new Exceptions.AnException(); }
            }catch(Exception ex){
                Loggings.writeLog(
                    Loggings.createLogEntry(Loggings.Level.Error, '20201217-0936', 'SzsdPubCardBat.execute')
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

    public interface IRecordSelector{
        Database.QueryLocator get_query_locator();
    }
    public class RecordSelector implements IRecordSelector{
        private Todays.IToday m_IToday;
        public RecordSelector(Todays.IToday p_IToday){
            this.m_IToday = p_IToday;
        }
        public Database.QueryLocator get_query_locator(){
            Date theFromDate = m_IToday.date().addDays(-14);
            Date theToDate = m_IToday.date();
    
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
}