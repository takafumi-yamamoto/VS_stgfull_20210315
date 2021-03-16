@isTest
public class SpfyOppSyncsT {
    @isTest public static void getOppSyncer() {
        Test.startTest();
        SpfyOppSyncs.getOppSyncer();
        Test.stopTest();
    }

    public class OppCreatorMock implements SpfyOppNew.IOppCreator{
        public void createNew(Decimal pOrderId){ return; }
    }
    public class OppUpdater implements SpfyOppUpd.IOppUpdater{
        public void updateOpp(Decimal pOrderId){ return; }
    }
    @isTest public static void OppSyncer_syncOrder() {

        Test.startTest();
        new SpfyOppSyncs.OppSyncer(
            new OppCreatorMock(),
            new OppUpdater()
        )
        .syncOrder(1.0);
        Test.stopTest();
    }
}