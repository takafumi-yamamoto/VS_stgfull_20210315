@isTest
public class TcmsTaioRkImpBatT {

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

    public class ITaioRerekiImporter_Stub implements TcmsTaioRkImp.ITaioRerekiImporter{
        public void run_import(String pTcmsTaioRkImpDataId){ return; }
    }
    public class IKanryoShubetsus_Stub implements TcmsTaioRkImpOpp.IKanryoShubetsus{
        public Set<String> get_Kanryo_Shubetsu_to_create_opps(){ return new Set<String>{'test'}; }
    }
    
    @isTest public static void start(){
        beginSetUp();
        TcmsTaioRkImpData__c the_TcmsTaioRkImpData = new TcmsTaioRkImpData__c(TcmsSeqNo__c = '1', Kanryo_Shubetsu__c = 'test');
        INSERT the_TcmsTaioRkImpData;

        TcmsTaioRkImpBat.mTaioRerekiImporter_instance = new ITaioRerekiImporter_Stub();
        TcmsTaioRkImpBat.mKanryoShubetsus_instance = new IKanryoShubetsus_Stub();
        endSetUp();
        Test.startTest();
        TcmsTaioRkImpBat.start();
        Test.stopTest();
    }
}