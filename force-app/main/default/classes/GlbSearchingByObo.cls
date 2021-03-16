public class GlbSearchingByObo {

    private static String ASYNCS_BROKER_REQNAME = GlbSearchingByObo.Class.toString();

    //running-begin
    public static void run(){
        //Load and lock tasks;
        List<GlbSearchingByOboTask__c> theTasks = new List<GlbSearchingByOboTask__c>(
            [
                select Id
                from GlbSearchingByOboTask__c 
                where ShoriStatus__c = 'Created'
                and LastModifiedDate >= :DateTime.now().addDays(-30)
                limit 10
                for update //caution=should be with Lock!;
            ]
        );
        //change status to running;
        for(GlbSearchingByOboTask__c aTask : theTasks){ aTask.ShoriStatus__c = 'Running'; }
        Update theTasks;
        //run-tasks;
        for(GlbSearchingByOboTask__c aTask : theTasks){ System.enqueueJob( new GlbSearchingByOboTask(aTask.Id) ); }
        //continue-tasks;
        List<GlbSearchingByOboTask__c> theTaskLeft = new List<GlbSearchingByOboTask__c>(
            [
                select Id
                from GlbSearchingByOboTask__c 
                where ShoriStatus__c = 'Created'
                and LastModifiedDate >= :DateTime.now().addDays(-30)
                limit 1
                //caution!=should be with No-Lock or Dead Locking;
            ]
        );
        if( theTaskLeft.size() >= 1 ) Asyncs_Broker.requestStart( ASYNCS_BROKER_REQNAME );

        //delete-garbage-tasks
        List<GlbSearchingByOboTask__c> theTaskToBeDeleted = new List<GlbSearchingByOboTask__c>(
            [
                select Id
                from GlbSearchingByOboTask__c 
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
    public static void subscriveOnGlbSearchingByOboTaskAfterInserted(List<GlbSearchingByOboTask__c> pNewOnes){
        Boolean isToStart = false;
        for(GlbSearchingByOboTask__c aNewOne : pNewOnes){
            if(aNewOne.ShoriStatus__c == 'Created') isToStart = true;
        }
        if(isToStart) start();
    }
    public static void subscriveOnGlbSearchingByOboTaskAfterUpdated
        (List<GlbSearchingByOboTask__c> pNewOnes, Map<Id, GlbSearchingByOboTask__c> pOldOnes){

        Boolean isToStart = false;
        for(GlbSearchingByOboTask__c aNewOne : pNewOnes){
            GlbSearchingByOboTask__c aOldOne = pOldOnes.get(aNewOne.Id);
            if(aNewOne.ShoriStatus__c != aOldOne.ShoriStatus__c && aNewOne.ShoriStatus__c == 'Created') isToStart = true;
        }
        if(isToStart) start();
    }
    //stating-end

    //tasking-begin
    public static void subscriveOnObosanbinAfterInserted(List<Obosanbin__c> pNewOnes){
        List<GlbSearchingByOboTask__c> theTasks = new List<GlbSearchingByOboTask__c>();
        for(Obosanbin__c aNewOne : pNewOnes){
            Boolean isTaskToBeCreated = false;
            if(aNewOne.Taishosha1Ref__c != null) isTaskToBeCreated = true;
            if(aNewOne.MoshuRef__c != null) isTaskToBeCreated = true;
            if(aNewOne.ObosanbinKeiyakuMadoguchi__c != null) isTaskToBeCreated = true;
            if(aNewOne.ObosanbinKeiyakuSekotanto__c != null) isTaskToBeCreated = true;
            if( !String.isBlank(aNewOne.SekoTantoSoryoSangoJiinMeiFurigana__c) ) isTaskToBeCreated = true;
            if( !String.isBlank(aNewOne.SekoTantoSoryoSoryoRenrakusaki__c) ) isTaskToBeCreated = true;

            if(isTaskToBeCreated) {
                theTasks.add( 
                    new GlbSearchingByOboTask__c(
                        ShoriStatus__c = 'Created', ObosanbinRef__c = aNewOne.Id
                    )
                );
            }
        }
        if(theTasks.size() > 0) Insert theTasks;
    }

    public static void subscriveOnObosanbinAfterUpdated(List<Obosanbin__c> pNewOnes, Map<Id, Obosanbin__c> pOldOnes){
        List<GlbSearchingByOboTask__c> theTasks = new List<GlbSearchingByOboTask__c>();
        for(Obosanbin__c aNewOne : pNewOnes){
            Obosanbin__c aOldOne = pOldOnes.get(aNewOne.Id);

            Boolean isTaskToBeCreated = false;
            if(aNewOne.Taishosha1Ref__c != aOldOne.Taishosha1Ref__c) isTaskToBeCreated = true;
            if(aNewOne.MoshuRef__c != aOldOne.MoshuRef__c) isTaskToBeCreated = true;
            if(aNewOne.ObosanbinKeiyakuMadoguchi__c != aOldOne.ObosanbinKeiyakuMadoguchi__c) isTaskToBeCreated = true;
            if(aNewOne.ObosanbinKeiyakuSekotanto__c != aOldOne.ObosanbinKeiyakuSekotanto__c) isTaskToBeCreated = true;
            if(aNewOne.SekoTantoSoryoSangoJiinMeiFurigana__c != aOldOne.SekoTantoSoryoSangoJiinMeiFurigana__c) isTaskToBeCreated = true;
            if(aNewOne.SekoTantoSoryoSoryoRenrakusaki__c != aOldOne.SekoTantoSoryoSoryoRenrakusaki__c) isTaskToBeCreated = true;

            if(isTaskToBeCreated) {
                theTasks.add( 
                    new GlbSearchingByOboTask__c(
                        ShoriStatus__c = 'Created', ObosanbinRef__c = aNewOne.Id
                    )
                );
            }
        }
        if(theTasks.size() > 0) Insert theTasks;
    }
    //tasking-end
}