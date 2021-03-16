public class ObosanbinGeoLocTasks {
    private static String ASYNCS_BROKER_REQNAME = NpTorihikiDataImpTasks.Class.toString();

    //running-begin
    public static void run(){
        //Load and lock tasks;
        List<ObosanbinGeoLocTask__c> theTasks = new List<ObosanbinGeoLocTask__c>(
            [
                SELECT Id
                FROM ObosanbinGeoLocTask__c 
                WHERE ShoriStatus__c = 'Created'
                AND CreatedDate >= :DateTime.now().addDays(-30)
                LIMIT 10
                FOR UPDATE //caution=should be with Lock!;
            ]
        );
        //change status to running;
        for(ObosanbinGeoLocTask__c aTask : theTasks){ aTask.ShoriStatus__c = 'Running'; }
        Update theTasks;
        //run-tasks;
        for(ObosanbinGeoLocTask__c aTask : theTasks){ System.enqueueJob( new ObosanbinGeoLocTask(aTask.Id) ); }
        //continue-tasks;
        List<ObosanbinGeoLocTask__c> theTaskLeft = new List<ObosanbinGeoLocTask__c>(
            [
                SELECT Id
                FROM ObosanbinGeoLocTask__c 
                WHERE ShoriStatus__c = 'Created'
                AND CreatedDate >= :DateTime.now().addDays(-30)
                LIMIT 1
                //caution!=should be with No-Lock or Dead Locking;
            ]
        );
        if( theTaskLeft.size() >= 1 ) Asyncs_Broker.requestStart( ASYNCS_BROKER_REQNAME );

        //delete-garbage-tasks
        List<ObosanbinGeoLocTask__c> theTaskToBeDeleted = new List<ObosanbinGeoLocTask__c>(
            [
                select Id
                from ObosanbinGeoLocTask__c 
                where LastModifiedDate < :DateTime.now().addDays(-30)
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
    public static void startAsync(){ 
        Asyncs_Broker.requestStart( ASYNCS_BROKER_REQNAME ); 
    }
    public static void onTaskAfterInserted(List<ObosanbinGeoLocTask__c> pNewOnes){
        Boolean isToStart = false;
        for(ObosanbinGeoLocTask__c aNewOne : pNewOnes){
            if(aNewOne.ShoriStatus__c == 'Created') isToStart = true;
        }
        if(isToStart) startAsync();
    }
    public static void onTaskAfterUpdated(List<ObosanbinGeoLocTask__c> pNewOnes, Map<Id, ObosanbinGeoLocTask__c> pOldOnes){

        Boolean isToStart = false;
        for(ObosanbinGeoLocTask__c aNewOne : pNewOnes){
            ObosanbinGeoLocTask__c aOldOne = pOldOnes.get(aNewOne.Id);
            if(aNewOne.ShoriStatus__c != aOldOne.ShoriStatus__c && aNewOne.ShoriStatus__c == 'Created') isToStart = true;
        }
        if(isToStart) startAsync();
    }
    //stating-end

    //tasking-begin
    private Boolean hoyoLocationHasValue(Obosanbin__c aNewOne){
        return aNewOne.hoyo_location__Latitude__s != null && aNewOne.hoyo_location__Longitude__s != null;
    }
    private Boolean hoyoAddrHasAnyValue(Obosanbin__c aNewOne){
        return !String.isBlank(aNewOne.hoyo_postcode__c) 
            || !String.isBlank(aNewOne.hoyo_todofuken__c) || !String.isBlank(aNewOne.hoyo_shikugun__c) 
            || !String.isBlank(aNewOne.hoyo_tyoumei__c) || !String.isBlank(aNewOne.hoyo_banchi__c);
    }
    private Boolean tsuikaHoyoLocationHasValue(Obosanbin__c aNewOne){
        return aNewOne.tuika_location__Latitude__s != null && aNewOne.tuika_location__Longitude__s != null;
    }
    private Boolean tsuikaHoyoAddrHasAnyValue(Obosanbin__c aNewOne){
        return !String.isBlank(aNewOne.tuika_postcode__c) 
            || !String.isBlank(aNewOne.tuika_todofuken__c) || !String.isBlank(aNewOne.tuika_shikugun__c) 
            || !String.isBlank(aNewOne.tuika_tyoumei__c) || !String.isBlank(aNewOne.tuika_banchi__c);
    }
    private Boolean sogiLocationHasValue(Obosanbin__c aNewOne){
        return aNewOne.sogi_location__Latitude__s != null && aNewOne.sogi_location__Longitude__s != null;
    }
    private Boolean sogiAddrHasAnyValue(Obosanbin__c aNewOne){
        return !String.isBlank(aNewOne.sogi_postcode__c) 
            || !String.isBlank(aNewOne.sogi_todofuken__c) || !String.isBlank(aNewOne.sogi_shikugun__c) 
            || !String.isBlank(aNewOne.sogi_tyoumei__c) || !String.isBlank(aNewOne.sogi_banchi__c);
    }
    public void onObosanbinAfterInserted(List<Obosanbin__c> pNewOnes){
        List<ObosanbinGeoLocTask__c> theTasks = new List<ObosanbinGeoLocTask__c>();
        for(Obosanbin__c aNewOne : pNewOnes){

            Boolean isHoyoAddrChg = this.hoyoAddrHasAnyValue(aNewOne) && !this.hoyoLocationHasValue(aNewOne);
            Boolean isTsuikaHoyoAddrChg = this.tsuikaHoyoAddrHasAnyValue(aNewOne) && !this.tsuikaHoyoLocationHasValue(aNewOne);
            Boolean isSogiAddrChg = this.sogiAddrHasAnyValue(aNewOne) && !this.sogiLocationHasValue(aNewOne);

            if(isHoyoAddrChg || isTsuikaHoyoAddrChg || isSogiAddrChg){
                theTasks.add(
                    new ObosanbinGeoLocTask__c( 
                        OboRef__c = aNewOne.Id, ShoriStatus__c = 'Created',
                        IsHoyoAddrChg__c = isHoyoAddrChg, isTsuikaHoyoAddrChg__c = isTsuikaHoyoAddrChg, isSogiAddrChg__c = isSogiAddrChg
                    )
                );
            }
        }
        INSERT theTasks;
    }
    private Boolean isHoyoLocationChanged(Obosanbin__c aNewOne, Obosanbin__c aOldOne){
        return aNewOne.hoyo_location__Latitude__s != aOldOne.hoyo_location__Latitude__s 
            || aNewOne.hoyo_location__Longitude__s != aOldOne.hoyo_location__Longitude__s;
    }
    private Boolean isHoyoAddrChanged(Obosanbin__c aNewOne, Obosanbin__c aOldOne){
        return aNewOne.hoyo_postcode__c != aOldOne.hoyo_postcode__c
            || aNewOne.hoyo_todofuken__c != aOldOne.hoyo_todofuken__c || aNewOne.hoyo_shikugun__c != aOldOne.hoyo_shikugun__c
            || aNewOne.hoyo_tyoumei__c != aOldOne.hoyo_tyoumei__c || aNewOne.hoyo_banchi__c != aOldOne.hoyo_banchi__c;
    }
    private Boolean isTsuikaHoyoLocationChanged(Obosanbin__c aNewOne, Obosanbin__c aOldOne){
        return aNewOne.tuika_location__Latitude__s != aOldOne.tuika_location__Latitude__s
            || aNewOne.tuika_location__Longitude__s != aOldOne.tuika_location__Longitude__s;
    }
    private Boolean isTsuikaHoyoAddrChanged(Obosanbin__c aNewOne, Obosanbin__c aOldOne){
        return aNewOne.tuika_postcode__c != aOldOne.tuika_postcode__c
            || aNewOne.tuika_todofuken__c != aOldOne.tuika_todofuken__c || aNewOne.tuika_shikugun__c != aOldOne.tuika_shikugun__c
            || aNewOne.tuika_tyoumei__c != aOldOne.tuika_tyoumei__c || aNewOne.tuika_banchi__c != aOldOne.tuika_banchi__c;
    }
    private Boolean isSogiLocationChanged(Obosanbin__c aNewOne, Obosanbin__c aOldOne){
        return aNewOne.sogi_location__Latitude__s != aOldOne.sogi_location__Latitude__s
            || aNewOne.sogi_location__Longitude__s != aOldOne.sogi_location__Longitude__s;
    }
    private Boolean isSogiAddrChanged(Obosanbin__c aNewOne, Obosanbin__c aOldOne){
        return aNewOne.sogi_postcode__c != aOldOne.sogi_postcode__c
            || aNewOne.sogi_todofuken__c != aOldOne.sogi_todofuken__c || aNewOne.sogi_shikugun__c != aOldOne.sogi_shikugun__c
            || aNewOne.sogi_tyoumei__c != aOldOne.sogi_tyoumei__c || aNewOne.sogi_banchi__c != aOldOne.sogi_banchi__c;
    }
    public void onObosanbinAfterUpdated(List<Obosanbin__c> pNewOnes, Map<Id,Obosanbin__c> pOldOnes){
        List<ObosanbinGeoLocTask__c> theTasks = new List<ObosanbinGeoLocTask__c>();

        for(Obosanbin__c aNewOne : pNewOnes){
            Obosanbin__c aOldOne = pOldOnes.get(aNewOne.Id);

            Boolean isHoyoAddrChg = this.isHoyoAddrChanged(aNewOne, aOldOne) && !this.isHoyoLocationChanged(aNewOne, aOldOne);
            Boolean isTsuikaHoyoAddrChg = this.isTsuikaHoyoAddrChanged(aNewOne, aOldOne) && !this.isTsuikaHoyoLocationChanged(aNewOne, aOldOne);
            Boolean isSogiAddrChg = this.isSogiAddrChanged(aNewOne, aOldOne) && !this.isSogiLocationChanged(aNewOne, aOldOne);

            if(isHoyoAddrChg || isTsuikaHoyoAddrChg || isSogiAddrChg){
                theTasks.add(
                    new ObosanbinGeoLocTask__c( 
                        OboRef__c = aNewOne.Id, ShoriStatus__c = 'Created',
                        IsHoyoAddrChg__c = isHoyoAddrChg, isTsuikaHoyoAddrChg__c = isTsuikaHoyoAddrChg, isSogiAddrChg__c = isSogiAddrChg
                    )
                );
            }
        }
        INSERT theTasks;
    }
    //tasking-end
}