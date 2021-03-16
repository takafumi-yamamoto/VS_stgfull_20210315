public class Asysncs_BrokerStats {

    public static Long getCurDurationKey(){
        return Long.valueOf( DateTime.now().format('yyyyMMddHH') );
    }

    public static void writeStatsLog(Asyncs_BrokerStatsLog__c pAsyncs_BrokerStatsLog){
        pAsyncs_BrokerStatsLog.MessageThisTime__c = 
            String.isBlank(pAsyncs_BrokerStatsLog.MessageThisTime__c)
            ? pAsyncs_BrokerStatsLog.MessageThisTime__c
            : pAsyncs_BrokerStatsLog.MessageThisTime__c.left(200);

        Insert pAsyncs_BrokerStatsLog;
        startUpdateStats();
    }

    public static Long getCurNumOfEvents(){
        Long theDurationKey = getCurDurationKey();
        List<Asyncs_BrokerStatsLog__c> theStats = [
            select Id, NumOfEvents__c
            from Asyncs_BrokerStatsLog__c 
            where DurationKey__c = :theDurationKey
            order by name desc
            Limit 1
        ];
        return theStats.size() <= 0 ? 0 : (Long)(theStats.get(0).NumOfEvents__c);
    }

    public static void startUpdateStats(){
        if( isAsysncs_BrokerStats_UpdateStatsJob_Running() ) return;
        System.enqueueJob( new Asysncs_BrokerStats_UpdateStatsJob() );
    }

    private static Boolean isAsysncs_BrokerStats_UpdateStatsJob_Running(){

        /*the apex-class-name of AsyncApexJob is not internal class's name but root-class'name*/
        List<AsyncApexJob> theJobs = [
            SELECT Id, ApexClass.Name from AsyncApexJob 
            where Status in ('Holding','Queued','Preparing','Processing') 
            and ApexClass.Name = 'Asysncs_BrokerStats'
            and JobType = 'Queueable'
            Limit 1
        ];

        return theJobs.size() >= 1;
    }

    private class Asysncs_BrokerStats_UpdateStatsJob implements Queueable{

        private void updateStats(){
            Long theDurationKey = getCurDurationKey();

            List<Asyncs_BrokerStats__c> theStats = [
                select id, NumOfEvents__c,NumOfMessages__c,NumOfMessagesCarriedOver__c from Asyncs_BrokerStats__c where DurationKey__c = :theDurationKey limit 1
            ];

            Asyncs_BrokerStats__c theCurStat = 
                theStats.size() <= 0 
                ? new Asyncs_BrokerStats__c( DurationKey__c = theDurationKey, NumOfEvents__c = 0, NumOfMessages__c = 0, NumOfMessagesCarriedOver__c = 0 )
                : theStats.get(0);

            List<Asyncs_BrokerStatsLog__c> theLogs = [
                select Id, DurationKey__c, NumOfEvents__c, NumOfMessages__c, NumOfMessagesCarriedOver__c
                from Asyncs_BrokerStatsLog__c
                where DurationKey__c = :theDurationKey and IsStatsProcessed__c = false
                limit 2000
            ];

            for(Asyncs_BrokerStatsLog__c aLog : theLogs){
                theCurStat.NumOfEvents__c += aLog.NumOfEvents__c == null ? 0 : (Long)aLog.NumOfEvents__c;
                theCurStat.NumOfMessages__c += aLog.NumOfMessages__c == null ? 0 : (Long)aLog.NumOfMessages__c;
                theCurStat.NumOfMessagesCarriedOver__c += aLog.NumOfMessagesCarriedOver__c == null ? 0 : (Long)aLog.NumOfMessagesCarriedOver__c;
                aLog.IsStatsProcessed__c = true;
            }

            Upsert theCurStat;
            Update theLogs;

            Long theDurationKeyTodayStarted = theDurationKey / 100 * 100;
            List<Asyncs_BrokerStatsLog__c> theLogsSholdBeDeleted = [
                select Id
                from Asyncs_BrokerStatsLog__c
                where DurationKey__c < :theDurationKeyTodayStarted
                limit 2000
            ];
            Delete theLogsSholdBeDeleted;
        }

        //implements Queable begin
        public void execute(QueueableContext context) {
                this.updateStats();
        }
        //implements Queable end
    }

}