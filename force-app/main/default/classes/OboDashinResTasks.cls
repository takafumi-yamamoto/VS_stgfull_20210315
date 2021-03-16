public class OboDashinResTasks {

    private static String ASYNCS_BROKER_REQNAME = OboDashinResTasks.Class.toString();

    //running-begin
    public static void run(){
        //Load and lock tasks;
        List<OboDashinResTask__c> theTasks = new List<OboDashinResTask__c>(
            [
                select Id
                from OboDashinResTask__c 
                where ShoriStatus__c = 'Created'
                // and CreatedDate >= :DateTime.now().addDays(-30)
                limit 10
                for update //caution=should be with Lock!;
            ]
        );
        //change status to running;
        for(OboDashinResTask__c aTask : theTasks){ aTask.ShoriStatus__c = 'Running'; }
        Update theTasks;
        //run-tasks;
        for(OboDashinResTask__c aTask : theTasks){ System.enqueueJob( new OboDashinResTask(aTask.Id) ); }
        //continue-tasks;
        List<OboDashinResTask__c> theTaskLeft = new List<OboDashinResTask__c>(
            [
                select Id
                from OboDashinResTask__c 
                where ShoriStatus__c = 'Created'
                and CreatedDate >= :DateTime.now().addDays(-30)
                limit 1
                //caution!=should be with No-Lock or Dead Locking;
            ]
        );
        if( theTaskLeft.size() >= 1 ) Asyncs_Broker.requestStart( ASYNCS_BROKER_REQNAME );

        //delete-garbage-tasks
        List<OboDashinResTask__c> theTaskToBeDeleted = new List<OboDashinResTask__c>(
            [
                select Id
                from OboDashinResTask__c 
                where LastModifiedDate < :DateTime.now().addDays(-90)
                limit 100
                for update
            ]
        );
        Delete theTaskToBeDeleted;
    }
    public static void onAyncBrokerRunRequested(string pRequestName){
        if(pRequestName == ASYNCS_BROKER_REQNAME ){ run(); }
    }
    //running-end

    //stating-begin
    public static void startAsync(){ 
        Asyncs_Broker.requestStart( ASYNCS_BROKER_REQNAME ); 
    }
    public static void onOboDashinResAfterInseted(List<OboDashinResTask__c> pNewOnes){
        Boolean isToStart = false;
        for(OboDashinResTask__c aNewOne : pNewOnes){
            if(aNewOne.ShoriStatus__c == 'Created') isToStart = true;
        }
        if(isToStart) startAsync();
    }
    public static void onOboDashinResAfterUpdated(List<OboDashinResTask__c> pNewOnes, Map<Id, OboDashinResTask__c> pOldOnes){

        Boolean isToStart = false;
        for(OboDashinResTask__c aNewOne : pNewOnes){
            OboDashinResTask__c aOldOne = pOldOnes.get(aNewOne.Id);
            if(aNewOne.ShoriStatus__c != aOldOne.ShoriStatus__c && aNewOne.ShoriStatus__c == 'Created') isToStart = true;
        }
        if(isToStart) startAsync();
    }
    //stating-end

}