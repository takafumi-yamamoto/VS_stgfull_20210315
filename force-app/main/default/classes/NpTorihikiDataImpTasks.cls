public class NpTorihikiDataImpTasks {
	private static String ASYNCS_BROKER_REQNAME = NpTorihikiDataImpTasks.Class.toString();

    //running-begin
    public static void run(){
        //Load and lock tasks;
        List<NpTorihikiDataImpTask__c> theTasks = new List<NpTorihikiDataImpTask__c>(
            [
                select Id
                from NpTorihikiDataImpTask__c 
                where ShoriStatus__c = 'Created'
                and CreatedDate >= :DateTime.now().addDays(-30)
                limit 10
                for update //caution=should be with Lock!;
            ]
        );
        //change status to running;
        for(NpTorihikiDataImpTask__c aTask : theTasks){ aTask.ShoriStatus__c = 'Running'; }
        Update theTasks;
        //run-tasks;
        for(NpTorihikiDataImpTask__c aTask : theTasks){ System.enqueueJob( new NpTorihikiDataImpTask(aTask.Id) ); }
        //continue-tasks;
        List<NpTorihikiDataImpTask__c> theTaskLeft = new List<NpTorihikiDataImpTask__c>(
            [
                select Id
                from NpTorihikiDataImpTask__c 
                where ShoriStatus__c = 'Created'
                and CreatedDate >= :DateTime.now().addDays(-30)
                limit 1
                //caution!=should be with No-Lock or Dead Locking;
            ]
        );
        if( theTaskLeft.size() >= 1 ) Asyncs_Broker.requestStart( ASYNCS_BROKER_REQNAME );
    }
    public static void subscriveOnAyncBrokerOnRunRequested(string pRequestName){
        if(pRequestName == ASYNCS_BROKER_REQNAME ){ run(); }
    }
    //running-end

    //stating-begin
    public static void startAsync(){ 
        Asyncs_Broker.requestStart( ASYNCS_BROKER_REQNAME ); 
    }
    public static void onNpTorihikiDataImpTaskAfterInserted(List<NpTorihikiDataImpTask__c> pNewOnes){
        Boolean isToStart = false;
        for(NpTorihikiDataImpTask__c aNewOne : pNewOnes){
            if(aNewOne.ShoriStatus__c == 'Created') isToStart = true;
        }
        if(isToStart) startAsync();
    }
    public static void onNpTorihikiDataImpTaskAfterUpdated
        (List<NpTorihikiDataImpTask__c> pNewOnes, Map<Id, NpTorihikiDataImpTask__c> pOldOnes){

        Boolean isToStart = false;
        for(NpTorihikiDataImpTask__c aNewOne : pNewOnes){
            NpTorihikiDataImpTask__c aOldOne = pOldOnes.get(aNewOne.Id);
            if(aNewOne.ShoriStatus__c != aOldOne.ShoriStatus__c && aNewOne.ShoriStatus__c == 'Created') isToStart = true;
        }
        if(isToStart) startAsync();
    }
    //stating-end
}