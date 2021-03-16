public class AffiCaseCre {

    private static String ASYNCS_BROKER_REQNAME = AffiCaseCre.Class.toString();

    //running-begin
    public static void run(){
        //Load and lock tasks;
        List<AffiCaseCreTask__c> theTasks = new List<AffiCaseCreTask__c>(
            [
                select Id
                from AffiCaseCreTask__c 
                where ShoriStatus__c = 'Created'
                and CreatedDate >= :DateTime.now().addDays(-30)
                and (DefferedUntil__c <= :DateTime.now() OR DefferedUntil__c = null)
                limit 10
                for update //caution=should be with Lock!;
            ]
        );
        //change status to running;
        for(AffiCaseCreTask__c aTask : theTasks){ aTask.ShoriStatus__c = 'Running'; }
        Update theTasks;
        //run-tasks;
        for(AffiCaseCreTask__c aTask : theTasks){ System.enqueueJob( new AffiCaseCreTask(aTask.Id) ); }
        //continue-tasks;
        List<AffiCaseCreTask__c> theTaskLeft = new List<AffiCaseCreTask__c>(
            [
                select Id
                from AffiCaseCreTask__c 
                where ShoriStatus__c = 'Created'
                and CreatedDate >= :DateTime.now().addDays(-30)
                and (DefferedUntil__c <= :DateTime.now() OR DefferedUntil__c = null)
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
    public static void subscriveOnAffiCaseCreTaskAfterInserted(List<AffiCaseCreTask__c> pNewOnes){
        Boolean isToStart = false;
        for(AffiCaseCreTask__c aNewOne : pNewOnes){
            if(aNewOne.ShoriStatus__c == 'Created') isToStart = true;
        }
        if(isToStart) start();
    }
    public static void subscriveOnAffiCaseCreTaskAfterUpdated(List<AffiCaseCreTask__c> pNewOnes, Map<Id, AffiCaseCreTask__c> pOldOnes){

        Boolean isToStart = false;
        for(AffiCaseCreTask__c aNewOne : pNewOnes){
            AffiCaseCreTask__c aOldOne = pOldOnes.get(aNewOne.Id);
            if(aNewOne.ShoriStatus__c != aOldOne.ShoriStatus__c && aNewOne.ShoriStatus__c == 'Created') isToStart = true;
        }
        if(isToStart) start();
    }
    public static void subscriveOnCaseAfterInserted(List<Case> pNewOnes){
        start();
    }    
    //stating-end

}