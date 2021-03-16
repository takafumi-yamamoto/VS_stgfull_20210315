public class OboSyncToOpp {

    private static String ASYNCS_BROKER_REQNAME = OboSyncToOpp.Class.toString();

    //running-begin
    public static void run(){
        //Load and lock tasks;
        List<OboSyncToOppTask__c> theTasks = new List<OboSyncToOppTask__c>(
            [
                select Id
                from OboSyncToOppTask__c 
                where ShoriStatus__c = 'Created'
                and LastModifiedDate >= :DateTime.now().addDays(-30)
                limit 10
                for update //caution=should be with Lock!;
            ]
        );
        //change status to running;
        for(OboSyncToOppTask__c aTask : theTasks){ aTask.ShoriStatus__c = 'Running'; }
        Update theTasks;
        //run-tasks;
        for(OboSyncToOppTask__c aTask : theTasks){ System.enqueueJob( new OboSyncToOppTask(aTask.Id) ); }
        //continue-tasks;
        List<OboSyncToOppTask__c> theTaskLeft = new List<OboSyncToOppTask__c>(
            [
                select Id
                from OboSyncToOppTask__c 
                where ShoriStatus__c = 'Created'
                and LastModifiedDate >= :DateTime.now().addDays(-30)
                limit 1
                //caution!=should be with No-Lock or Dead Locking;
            ]
        );
        if( theTaskLeft.size() >= 1 ) Asyncs_Broker.requestStart( ASYNCS_BROKER_REQNAME );

        //delete-garbage-tasks
        List<OboSyncToOppTask__c> theTaskToBeDeleted = new List<OboSyncToOppTask__c>(
            [
                select Id
                from OboSyncToOppTask__c 
                where LastModifiedDate < :DateTime.now().addDays(-60)
                limit 100
                for update
            ]
        );
        Delete theTaskToBeDeleted;
    }
    public static void subscriveOnAyncBrokerOnRunRequested(string pRequestName){
        if(pRequestName == ASYNCS_BROKER_REQNAME ){ run(); }
    }
    //running-end

    //stating-begin
    public static void start(){ 
        Asyncs_Broker.requestStart( ASYNCS_BROKER_REQNAME ); 
    }
    public static void subscriveOnOboSyncToOppTaskAfterInserted(List<OboSyncToOppTask__c> pNewOnes){
        Boolean isToStart = false;
        for(OboSyncToOppTask__c aNewOne : pNewOnes){
            if(aNewOne.ShoriStatus__c == 'Created') isToStart = true;
        }
        if(isToStart) start();
    }
    public static void subscriveOnOboSyncToOppTaskAfterUpdated
        (List<OboSyncToOppTask__c> pNewOnes, Map<Id, OboSyncToOppTask__c> pOldOnes){

        Boolean isToStart = false;
        for(OboSyncToOppTask__c aNewOne : pNewOnes){
            OboSyncToOppTask__c aOldOne = pOldOnes.get(aNewOne.Id);
            if(aNewOne.ShoriStatus__c != aOldOne.ShoriStatus__c && aNewOne.ShoriStatus__c == 'Created') isToStart = true;
        }
        if(isToStart) start();
    }
    //stating-end

    //tasking-begin
    public static void subscriveOnObosanbinAfterInserted(List<Obosanbin__c> pNewOnes){
        List<OboSyncToOppTask__c> theTasks = new List<OboSyncToOppTask__c>();
        for(Obosanbin__c aNewOne : pNewOnes){
            Boolean isTaskToBeCreated = false;
            if(aNewOne.Taishosha1Ref__c != null) isTaskToBeCreated = true;
            if(aNewOne.MoshuRef__c != null) isTaskToBeCreated = true;
            if(aNewOne.ObosanbinKeiyakuMadoguchi__c != null) isTaskToBeCreated = true;
            if(aNewOne.ObosanbinKeiyakuSekotanto__c != null) isTaskToBeCreated = true;
            if( !String.isBlank(aNewOne.MemorialServicePlan__c) ) isTaskToBeCreated = true;

            if(isTaskToBeCreated) {
                theTasks.add( 
                    new OboSyncToOppTask__c(
                        ShoriStatus__c = 'Created', ObosanbinRef__c = aNewOne.Id
                    )
                );
            }
        }
        Insert theTasks;
    }

    public static void subscriveOnObosanbinAfterUpdated(List<Obosanbin__c> pNewOnes, Map<Id, Obosanbin__c> pOldOnes){
        List<OboSyncToOppTask__c> theTasks = new List<OboSyncToOppTask__c>();
        for(Obosanbin__c aNewOne : pNewOnes){
            Obosanbin__c aOldOne = pOldOnes.get(aNewOne.Id);

            Boolean isTaskToBeCreated = false;
            if(aNewOne.Taishosha1Ref__c != aOldOne.Taishosha1Ref__c) isTaskToBeCreated = true;
            if(aNewOne.MoshuRef__c != aOldOne.MoshuRef__c) isTaskToBeCreated = true;
            if(aNewOne.ObosanbinKeiyakuMadoguchi__c != aOldOne.ObosanbinKeiyakuMadoguchi__c) isTaskToBeCreated = true;
            if(aNewOne.ObosanbinKeiyakuSekotanto__c != aOldOne.ObosanbinKeiyakuSekotanto__c) isTaskToBeCreated = true;
            if(aNewOne.MemorialServicePlan__c != aOldOne.MemorialServicePlan__c) isTaskToBeCreated = true;

            if(isTaskToBeCreated) {
                theTasks.add( 
                    new OboSyncToOppTask__c(
                        ShoriStatus__c = 'Created', ObosanbinRef__c = aNewOne.Id
                    )
                );
            }
        }
        Insert theTasks;
    }
    //tasking-end
}