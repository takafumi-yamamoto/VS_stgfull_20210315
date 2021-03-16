public class Asyncs_Broker {

    public static void requestStart(String pRequestName){
        if( String.isBlank(pRequestName) ) return;

        if(Asysncs_BrokerStats.getCurNumOfEvents() >= 10000){
            Loggings.writeLog(
                Loggings.createLogEntry(Loggings.Level.Error, '20180711-1908-01', 'Asyncs_Broker.EventCountExceeded', 'event publishing is suspended by EventCountExceeded')
            );
            return;
        }

        Database.SaveResult theSaveResult =
            EventBus.publish(
                new Asyncs_StartReq__e( RequestedName__c = pRequestName)
            );

        if( !theSaveResult.isSuccess() ){
            Insert new AsyncBrokerReqPended__c(RequestName__c = pRequestName, ShoriStatus__c = 'Created');
            Loggings.writeLog(
                Loggings.createLogEntry(Loggings.Level.Error, '20181207-1641-01', 'Asyncs_Broker.EventPublishingFailed')
                    .putAttr('pRequestName',pRequestName)
            );
        }
    }

    public void subscriveOnAyncsStartReqAfterInserted(List<Asyncs_StartReq__e> pNewOnes){

        Set<String> theRequests = new Set<String>();
        for(Asyncs_StartReq__e aNewOne : pNewOnes){
            if( String.isBlank( aNewOne.RequestedName__c ) ) continue;
            theRequests.add( aNewOne.RequestedName__c );
        }

        String theRequestToBeStartedThisTime = '';
        Set<String> theRequestsShouldBeCarriedover = new Set<String>();
        Long theIndex = 0;
        for(String aRequest : theRequests){
            theIndex ++;
            if(theIndex == 1) theRequestToBeStartedThisTime = aRequest;
            if(theIndex > 1){
                theRequestsShouldBeCarriedover.add( aRequest );
            }
        }

        if( !String.isBlank(theRequestToBeStartedThisTime) ){
            this.runRequested(theRequestToBeStartedThisTime);
        }

        for(String aRequest : theRequestsShouldBeCarriedover){
            requestStart(aRequest);
        }

        Asysncs_BrokerStats.writeStatsLog(
            new Asyncs_BrokerStatsLog__c(
                IsStatsProcessed__c = false,
                DurationKey__c = Asysncs_BrokerStats.getCurDurationKey(),
                NumOfEvents__c = pNewOnes.size(),
                NumOfMessages__c = theRequests.size(),
                NumOfMessagesCarriedOver__c = theRequestsShouldBeCarriedover.size(),
                MessageThisTime__c = theRequestToBeStartedThisTime
            )
        );
    }

    private void runRequested(String pRequestName){
        new Ctl_ObosanbinService.CaseToShodanTaskProcessor().subscriveOnAyncBrokerOnRunRequested(pRequestName);
        new GlbSearchingByAccount().subscriveOnAsyncBrokerOnRunRequested(pRequestName);

        PtWebAccounts_IssuingNewAccount.subscriveOnAyncBrokerOnRunRequested(pRequestName);
        PtWebAccounts_ActivatingWebAccount.subscriveOnAyncBrokerOnRunRequested(pRequestName);
        PtWebAccounts_InvalidatingWebAccount.subscriveOnAyncBrokerOnRunRequested(pRequestName);
        SogSok_MitsumoriSho_TorikCre.subscriveOnAyncBrokerOnRunRequested(pRequestName);
        SogSok_SrthIraiSho_TorikCre.subscriveOnAyncBrokerOnRunRequested(pRequestName);
        SogSok_SeikyuSho_TorikCre.subscriveOnAyncBrokerOnRunRequested(pRequestName);
        AffiCaseCre.subscriveOnAyncBrokerOnRunRequested(pRequestName);
        GlbSearchingByObo.subscriveOnAyncBrokerOnRunRequested(pRequestName);
        NpTorihikiDataImpTasks.subscriveOnAyncBrokerOnRunRequested(pRequestName);
        OboDashinResTasks.onAyncBrokerRunRequested(pRequestName);
        ObosanbinGeoLocTasks.subscriveOnAyncBrokerOnRunRequested(pRequestName);
        JizenKakunin1DBfLineTasks.onAyncBrokerRunRequested(pRequestName);
        JizenKakunin7DBfLineTasks.onAyncBrokerRunRequested(pRequestName);
    }
}