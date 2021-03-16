public class SpfyOppSyncs{

    private static IOppSyncer mOppSyncer;
    public static IOppSyncer getOppSyncer(){
        if(mOppSyncer == null){
            SpfyConfs.Config theConfig = SpfyConfs.getConfig();

            SpfyOrdersGet.Client theSpfyOrdersGetClient =
                new SpfyOrdersGet.Client(
                    new SpfyApi_OrdersGetEx.Client(
                        theConfig,
                        new SpfyApi_OrdersGet.Client(),
                        new SpfyApi_OrdersGetEx.ResponseConverter()
                    )
                );

            SpfyOppShohinBango.ShohinBangoForOppLineItems theShohinBangoForOppLineItems = 
                new SpfyOppShohinBango.ShohinBangoForOppLineItems( theConfig.ShohinBango_For_OppLineItem );

            SpfyNoteShipDates.SpfyNoteShipDate theSpfyNoteShipDate = new SpfyNoteShipDates.SpfyNoteShipDate();

            SpfyOppStages.StageRsolver theStageResolver = new SpfyOppStages.StageRsolver( new SpfyPreKessaiPolicy.PreKessaiPolicy() );
            
            SpfyCyumonJohoTxt.ICyumonJohoTexter theCyumonJohoTexter = new SpfyCyumonJohoTxt.CyumonJohoTexter();
            mOppSyncer = 
                new OppSyncer(
                    new SpfyOppNew.OppCreator(
                        theSpfyOrdersGetClient,
                        theShohinBangoForOppLineItems,
                        new SpfyOppNewAcntRslv.AccountResolver(),
                        theSpfyNoteShipDate,
                        theStageResolver,
                        theCyumonJohoTexter
                    ),
                    new SpfyOppUpd.OppUpdater(
                        theSpfyOrdersGetClient,
                        theShohinBangoForOppLineItems,
                        theSpfyNoteShipDate,
                        theStageResolver,
                        theCyumonJohoTexter
                    )
                );
        }
        return mOppSyncer;
    }

    public interface IOppSyncer {
        void syncOrder(Decimal pOrderId);
    }
    public class OppSyncer implements IOppSyncer{

        private SpfyOppNew.IOppCreator mOppCreator;
        private SpfyOppUpd.IOppUpdater mOppUpdater;
        public OppSyncer(SpfyOppNew.IOppCreator pOppCreator, SpfyOppUpd.IOppUpdater pOppUpdater){
            this.mOppCreator = pOppCreator; 
            this.mOppUpdater = pOppUpdater;
        }

        public void syncOrder(Decimal pOrderId){

            Boolean isNew = [
                SELECT Id
                FROM Opportunity
                WHERE RefHub4OppRef__r.SpfyOrderRef__r.spfyOrder_Id__c != NULL
                AND RefHub4OppRef__r.SpfyOrderRef__r.spfyOrder_Id__c = :pOrderId
                LIMIT 1
            ].size() == 0;
    
            if(isNew){
                this.mOppCreator.createNew(pOrderId);
            }
            if(!isNew){
                this.mOppUpdater.updateOpp(pOrderId);
            }
        }
    }

}