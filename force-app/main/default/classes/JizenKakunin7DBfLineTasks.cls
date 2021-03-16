public class JizenKakunin7DBfLineTasks {

    private static String ASYNCS_BROKER_REQNAME = JizenKakunin7DBfLineTasks.Class.toString();

    //running-begin
    public static void run(){
        //Load and lock tasks;
        List<JizenKakunin7DBfLineTask__c> theTasks = new List<JizenKakunin7DBfLineTask__c>(
            [
                select Id
                from JizenKakunin7DBfLineTask__c 
                where ShoriStatus__c = 'Created'
                limit 10
                for update //caution=should be with Lock!;
            ]
        );
        //change status to running;
        for(JizenKakunin7DBfLineTask__c aTask : theTasks){ aTask.ShoriStatus__c = 'Running'; }
        Update theTasks;
        //run-tasks;
        for(JizenKakunin7DBfLineTask__c aTask : theTasks){ System.enqueueJob( new JizenKakunin7DBfLineTask(aTask.Id) ); }
        //continue-tasks;
        List<JizenKakunin7DBfLineTask__c> theTaskLeft = new List<JizenKakunin7DBfLineTask__c>(
            [
                select Id
                from JizenKakunin7DBfLineTask__c 
                where ShoriStatus__c = 'Created'
                and CreatedDate >= :DateTime.now().addDays(-30)
                limit 1
                //caution!=should be with No-Lock or Dead Locking;
            ]
        );
        if( theTaskLeft.size() >= 1 ) Asyncs_Broker.requestStart( ASYNCS_BROKER_REQNAME );

        //delete-garbage-tasks
        List<JizenKakunin7DBfLineTask__c> theTaskToBeDeleted = new List<JizenKakunin7DBfLineTask__c>(
            [
                select Id
                from JizenKakunin7DBfLineTask__c 
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
    public static void onJizenKakunin7DBfLineTaskAfterInsert(List<JizenKakunin7DBfLineTask__c> pNewOnes){
        Boolean isToStart = false;
        for(JizenKakunin7DBfLineTask__c aNewOne : pNewOnes){
            if(aNewOne.ShoriStatus__c == 'Created') isToStart = true;
        }
        if(isToStart) startAsync();
    }
    public static void onJizenKakunin7DBfLineTaskAfterUpdate(List<JizenKakunin7DBfLineTask__c> pNewOnes, Map<Id, JizenKakunin7DBfLineTask__c> pOldOnes){

        Boolean isToStart = false;
        for(JizenKakunin7DBfLineTask__c aNewOne : pNewOnes){
            JizenKakunin7DBfLineTask__c aOldOne = pOldOnes.get(aNewOne.Id);
            if(aNewOne.ShoriStatus__c != aOldOne.ShoriStatus__c && aNewOne.ShoriStatus__c == 'Created') isToStart = true;
        }
        if(isToStart) startAsync();
    }
    //stating-end
}