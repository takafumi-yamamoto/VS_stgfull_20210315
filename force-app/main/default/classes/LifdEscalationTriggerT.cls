@isTest
public class LifdEscalationTriggerT {
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

    private class IHandler_Stub implements LifdEscalationTrg.IHandler{
        public void set_context(Boolean pIsExecuting, Integer pSize){ return; }
        public void onAfterInsert(List<LifdEscalation__c> pNewOnes){ return; }
    }
    @isTest public static void after_insert(){
        beginSetUp();
        LifdEscalationTrg.mHandler_instane = new IHandler_Stub();
        endSetUp();

        Test.startTest();
        INSERT new LifdEscalation__c(ShodanBango__c = '1');
        Test.stopTest();
    }
}