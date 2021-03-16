public class KrYsZanSyncBat implements Database.Batchable<sObject>{

    @TestVisible
    private static IRunner IRunner_instance;
    private static IRunner get_IRunner_instance(){
        if( IRunner_instance == null ){ IRunner_instance = new Runner(); }
        return IRunner_instance;
    }

    public static void start(){
        if( isBatchActive() ) return;

        Integer theBatchSize = 100;
		database.executebatch( 
            new KrYsZanSyncBat( get_IRunner_instance() ),
            theBatchSize 
        );
    }

    private static Boolean isBatchActive(){
        /*the apex-class-name of AsyncApexJob is not internal class's name but root-class'name*/
        List<AsyncApexJob> theJobs = [
            SELECT Id, ApexClass.Name from AsyncApexJob 
            where Status in ('Holding','Queued','Preparing','Processing') 
            and ApexClass.Name = 'KrYsZanSyncBat'
            and JobType in ('BatchApex','BatchApexWorker')
            Limit 1
        ];
        return theJobs.size() >= 1;
    }

    private IRunner m_IRunner;
    public KrYsZanSyncBat(IRunner p_IRunner){
        this.m_IRunner = p_IRunner;
    }

    public List<Account> start(Database.BatchableContext BC) { 
        List<Account> theRecords = 
            [
                SELECT Id, KeiriTorihikiSakiName__c, KrYsYosinRef__c
                FROM Account
                WHERE KrYsYosinRef__c != NULL
                AND KeiriTorihikiSakiName__c != NULL
            ];

		return theRecords;
    }

    public void execute(Database.BatchableContext BC, List<Account> pRecords) {
        try{
            this.m_IRunner.run(pRecords);
        }catch(Exception ex){
            Loggings.writeLog(
                Loggings.createLogEntry(Loggings.Level.Error, '20201203-1702', 'KrYsZanSyncBat.execute')
                    .putAttr('ex.getTypeName()', ex.getTypeName() )
                    .putAttr('ex.getMessage()', ex.getMessage())
                    .putAttr('ex.getLineNumber()', '' + ex.getLineNumber())
                    .putAttr('ex.getStackTraceString', ex.getStackTraceString())
            );
        }
    }

    public interface IRunner {
        void run(List<Account> pRecords);
    }
    public class Runner implements IRunner{
        public void run(List<Account> pRecords) {

            KrYsFreUnSetlDlImpJob__c the_latest_KrYsFreUnSetlDlImpJob = 
                (KrYsFreUnSetlDlImpJob__c)SobjectsExtension.firstOrNull(
                    [
                        SELECT Id,CompletedDt__c 
                        FROM KrYsFreUnSetlDlImpJob__c 
                        WHERE ShoriStatus__c = 'Completed' 
                        AND CompletedDt__c != null
                        ORDER BY CompletedDt__c DESC LIMIT 1]
                );
            if( the_latest_KrYsFreUnSetlDlImpJob == null){ return; }
    
            Set<String> partner_codes = new Set<String>();
            for(Account aAccount : pRecords){
                if( !String.isBlank(aAccount.KeiriTorihikiSakiName__c) ){
                    partner_codes.add(aAccount.KeiriTorihikiSakiName__c);
                }
            }
            
            Map<String, Decimal> the_partner_code_to_due_amount_map = new Map<String, Decimal>();
            for(AggregateResult a_aggregation_result : [
                SELECT partner_code__c partner_code, SUM(due_amount__c) due_amount
                FROM KrYsFreUnsetlDl__c
                WHERE partner_code__c IN :partner_codes
                AND due_amount__c != NULL
                AND KrYsFreUnSetlDlImpJobRef__c = :the_latest_KrYsFreUnSetlDlImpJob.Id
                GROUP BY partner_code__c
            ]){
                String a_partner_code = (String)a_aggregation_result.get('partner_code');
                Decimal a_due_amount = (Decimal)a_aggregation_result.get('due_amount');
                the_partner_code_to_due_amount_map.put(a_partner_code, a_due_amount );
            }
    
            Map<String, KrYsYosin__c> the_KrYsYosin_updates = new Map<String, KrYsYosin__c>();
            for(Account aAccount : pRecords){
                the_KrYsYosin_updates.put(
                    aAccount.KrYsYosinRef__c,
                    new KrYsYosin__c(
                        Id = aAccount.KrYsYosinRef__c,
                        SaikenZandaka__c = 
                        the_partner_code_to_due_amount_map.containsKey(aAccount.KeiriTorihikiSakiName__c)
                        ? the_partner_code_to_due_amount_map.get(aAccount.KeiriTorihikiSakiName__c)
                        : 0,
                        SaikenZandakaSyukeiDt__c = the_latest_KrYsFreUnSetlDlImpJob.CompletedDt__c
                    )
                );
            }
    
            UPDATE the_KrYsYosin_updates.values();

            UPDATE New KrYsFreUnSetlDlImpJob__c(Id = the_latest_KrYsFreUnSetlDlImpJob.Id,  isZandakaHaneiZumi__c = true);
        }
    }

    public void finish(Database.BatchableContext BC){}
}