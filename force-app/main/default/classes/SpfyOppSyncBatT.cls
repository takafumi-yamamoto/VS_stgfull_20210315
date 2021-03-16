@isTest
public class SpfyOppSyncBatT {

    private static void beginSetUp(){
		Utility_Common.isMimicExecAsDataIkouProfile = true;
    }
	private static void endSetUp(){
        Insert new TriggerIsActive__c( name='default', isActive__c=true );
        Insert new JizenWariPlan__c( Code__c='Yoriso' );
        Insert new Account(
            RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','null'),
            FirstName = '_', LastName = '_'
        );
		Utility_Common.isMimicExecAsDataIkouProfile = false;
    }
    public class OppSyncerMock implements SpfyOppSyncs.IOppSyncer{
        public void syncOrder(Decimal pOrderId){ return; }
    }
    public class BatchStopperMock implements SpfyOppSyncBat.IBatchStopper{
        public Boolean toStop(){ return false; }
    }
    @isTest public static void start() {
        Test.startTest();
        SpfyOppSyncBat.start();
        Test.stopTest();
    }

    @isTest public static void exec() {
        beginSetUp();
        INSERT new SpfyOppSyncBatLockTkn__c(
            orderId__c = 1.0
        );
        SpfyOppSyncQue__c theQue = new SpfyOppSyncQue__c(
            orderId__c = 1.0, versionLatest__c = '_', versionLastSync__c = '_'
        );
        INSERT theQue;
        endSetUp();
        Test.startTest();
        new SpfyOppSyncBat(
            new OppSyncerMock(),
            new BatchStopperMock()
        )
        .exec( theQue );
        Test.stopTest();
    }

    
    @isTest public static void execuete_exception() {
        beginSetUp();
        endSetUp();
        Test.startTest();
        new SpfyOppSyncBat(
            new OppSyncerMock(),
            new BatchStopperMock()
        )
        .execute( null, null);
        Test.stopTest();
    }
}