@isTest
public class KrshPubCardCmdTriggerT {

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

    private class IHandler_Stub implements KrshPubCardCmdTrg.IHandler{
        public void set_context(Boolean pIsExecuting, Integer pSize){ return; }
        public void onBeforeInsert(List<KrshPubCardCmd__c> pNewOnes){ return; }
    }

    @isTest public static void before_insert(){
        beginSetUp();
        KrshPubCardCmdTrg.mHandler_instane = new IHandler_Stub();
        endSetUp();

        Test.startTest();
        INSERT new KrshPubCardCmd__c(ShodanBango__c = '1');
        Test.stopTest();
    }

}