public class SogSok_MitsumoriSho_TorikCre{

    private static String ASYNCS_BROKER_REQNAME = SogSok_MitsumoriSho_TorikCre.Class.toString(); 

    //running-begin
    public static void run(){
        //Load and lock tasks;
        List<SogSok_MitsumoriSho_TorikCreTask__c> theTasks = new List<SogSok_MitsumoriSho_TorikCreTask__c>(
            [
                select Id
                from SogSok_MitsumoriSho_TorikCreTask__c 
                where ShoriStatus__c = 'Created'
                and LastModifiedDate >= :DateTime.now().addDays(-30)
                limit 10
                for update //caution=should be with Lock!;
            ]
        );
        //change status to running;
        for(SogSok_MitsumoriSho_TorikCreTask__c aTask : theTasks){ aTask.ShoriStatus__c = 'Running'; }
        Update theTasks;
        //run-tasks;
        for(SogSok_MitsumoriSho_TorikCreTask__c aTask : theTasks){ System.enqueueJob( new SogSok_MitsumoriSho_TorikCreTask(aTask.Id) ); }
        //continue-tasks;
        List<SogSok_MitsumoriSho_TorikCreTask__c> theTaskLeft = new List<SogSok_MitsumoriSho_TorikCreTask__c>(
            [
                select Id
                from SogSok_MitsumoriSho_TorikCreTask__c 
                where ShoriStatus__c = 'Created'
                and LastModifiedDate >= :DateTime.now().addDays(-30)
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
    public static void start(){ 
        Asyncs_Broker.requestStart( ASYNCS_BROKER_REQNAME ); 
    }
    
    public static void subscriveOnSogSokMitsumoriShoTorikCreTaskAfterInserted(List<SogSok_MitsumoriSho_TorikCreTask__c> pNewOnes){
        Boolean isToStart = false;
        for(SogSok_MitsumoriSho_TorikCreTask__c aNewOne : pNewOnes){
            if(aNewOne.ShoriStatus__c == 'Created') isToStart = true;
        }
        if(isToStart) start();
    }
    public static void subscriveOnSogSokMitsumoriShoTorikCreTaskAfterUpdated
        (List<SogSok_MitsumoriSho_TorikCreTask__c> pNewOnes, Map<Id, SogSok_MitsumoriSho_TorikCreTask__c> pOldOnes){

        Boolean isToStart = false;
        for(SogSok_MitsumoriSho_TorikCreTask__c aNewOne : pNewOnes){
            SogSok_MitsumoriSho_TorikCreTask__c aOldOne = pOldOnes.get(aNewOne.Id);
            if(aNewOne.ShoriStatus__c != aOldOne.ShoriStatus__c && aNewOne.ShoriStatus__c == 'Created') isToStart = true;
        }
        if(isToStart) start();
    }
    //stating-end

    //tasking-begin
    public static void subscriveOnSogSokMitsumoriShoAfterInserted(List<SogSok_MitsumoriSho__c> pNewOnes){
        List<SogSok_MitsumoriSho_TorikCreTask__c> theTasks = new List<SogSok_MitsumoriSho_TorikCreTask__c>();
        for(SogSok_MitsumoriSho__c aNewOne : pNewOnes){
            if(aNewOne.DocStatus__c == 'Activated') {
                theTasks.add( 
                    new SogSok_MitsumoriSho_TorikCreTask__c(
                        ShoriStatus__c = 'Created', SogSok_MitsumoriShoRef__c = aNewOne.Id
                    )
                );
            }
        }
        Insert theTasks;
    }
    public static void subscriveOnSogSokMitsumoriShoAfterUpdated(List<SogSok_MitsumoriSho__c> pNewOnes, Map<Id, SogSok_MitsumoriSho__c> pOldOnes){
        List<SogSok_MitsumoriSho_TorikCreTask__c> theTasks = new List<SogSok_MitsumoriSho_TorikCreTask__c>();
        for(SogSok_MitsumoriSho__c aNewOne : pNewOnes){
            SogSok_MitsumoriSho__c aOldOne = pOldOnes.get(aNewOne.Id);
            if(aNewOne.DocStatus__c != aOldOne.DocStatus__c && aNewOne.DocStatus__c == 'Activated') {
                theTasks.add( 
                    new SogSok_MitsumoriSho_TorikCreTask__c(
                        ShoriStatus__c = 'Created', SogSok_MitsumoriShoRef__c = aNewOne.Id
                    )
                );
            }
        }
        Insert theTasks;
    }
    //tasking-end
}