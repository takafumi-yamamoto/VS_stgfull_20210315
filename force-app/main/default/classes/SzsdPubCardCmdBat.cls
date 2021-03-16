public class SzsdPubCardCmdBat implements Database.Batchable<sObject>{

    public static SzsdPubCardCmdBat m_SzsdPubCardCmdBat_instance;
    public static SzsdPubCardCmdBat get_SzsdPubCardCmdBat_instance(){
        if( m_SzsdPubCardCmdBat_instance == null ){
            m_SzsdPubCardCmdBat_instance = new SzsdPubCardCmdBat(
                new RecordSelector(),
                SzsdPubCard.get_ICardPublisher_instance()
            );
        }
        return m_SzsdPubCardCmdBat_instance;
    }

	public static void start(){
		if( isBatchActive() ) return;
		database.executebatch( get_SzsdPubCardCmdBat_instance() , 1);
	}
	private static Boolean isBatchActive(){
        /*the apex-class-name of AsyncApexJob is not internal class's name but root-class'name*/
        List<AsyncApexJob> theJobs = [
            SELECT Id, ApexClass.Name from AsyncApexJob 
            where Status in ('Holding','Queued','Preparing','Processing') 
            and ApexClass.Name = 'SzsdPubCardCmdBat'
            and JobType in ('BatchApex','BatchApexWorker')
            Limit 1
        ];
        return theJobs.size() >= 1;
    }

    private IRecordSelector m_IRecordSelector;
    private SzsdPubCard.ICardPublisher m_ICardPublisher;
    public SzsdPubCardCmdBat(
        IRecordSelector p_IRecordSelector,
        SzsdPubCard.ICardPublisher p_ICardPublisher
    ){
        this.m_IRecordSelector = p_IRecordSelector;
        this.m_ICardPublisher = p_ICardPublisher;
    }

    public Database.QueryLocator start(Database.BatchableContext BC) { return this.m_IRecordSelector.get_query_locator(); }

    public void execute(Database.BatchableContext BC, List<SzsdPubCardCmd__c> p_records) {
        for( SzsdPubCardCmd__c a_record : p_records){
            try{
                this.run(a_record.Id);
            }catch(Exception ex){
                Loggings.writeLog(
                    Loggings.createLogEntry(Loggings.Level.Error, '20201217-1455', 'SzsdPubCardCmdBat.execute')
                        .setSubjectRecordId( a_record.Id )
                        .putAttr('ex.getTypeName()', ex.getTypeName() )
                        .putAttr('ex.getMessage()', ex.getMessage())
                        .putAttr('ex.getLineNumber()', '' + ex.getLineNumber())
                        .putAttr('ex.getStackTraceString', ex.getStackTraceString())
                );
            }
        }
    }
    public void finish(Database.BatchableContext BC) {}

    public void run(String p_SzsdPubCardCmd_id){
        SzsdPubCardCmd__c a_SzsdPubCardCmd = [ SELECT Id, ShodanBango__c FROM SzsdPubCardCmd__c WHERE Id = :p_SzsdPubCardCmd_id LIMIT 1 ].get(0);
        
        String simple_yasugo_opp_rec_type_id = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId();
        Opportunity a_opp = (Opportunity)SobjectsExtension.firstOrNull(
            [
                SELECT Id, ShodanBango__c FROM Opportunity 
                WHERE ShodanBango__c = :a_SzsdPubCardCmd.ShodanBango__c
                AND RecordTypeId = :simple_yasugo_opp_rec_type_id
                LIMIT 1
            ]
        );
        if(a_opp == null){
            UPDATE new SzsdPubCardCmd__c(Id = a_SzsdPubCardCmd.Id, ShoriStatus__c = 'Failed', ShoriDescr__c = '該当する商談がありません;');
            return;
        }

        Boolean is_hakkou_shijji_directly = true;
        this.m_ICardPublisher.try_publish_card(a_opp.Id, is_hakkou_shijji_directly);

        UPDATE new SzsdPubCardCmd__c(Id = a_SzsdPubCardCmd.Id, ShoriStatus__c = 'Success');
    }

    public interface IRecordSelector{
        Database.QueryLocator get_query_locator();
    }
    public class RecordSelector implements IRecordSelector{
        public RecordSelector(){}

        public Database.QueryLocator get_query_locator(){
    
            return Database.getQueryLocator(
                [
                    SELECT Id
                    FROM SzsdPubCardCmd__c
                    WHERE ShoriStatus__c = 'Created'
                ]
            );
        }
    }
    
}