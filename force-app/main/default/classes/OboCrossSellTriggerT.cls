@isTest
public class OboCrossSellTriggerT {

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

    private class IHandler_Stub implements OboCrossSellTrg.IHandler{
        public void set_context(Boolean pIsExecuting, Integer pSize){ return; }
        public void onBeforeInsert(List<OboCrossSell__c> pNewOnes){ return; }
        public void onBeforeUpdate(List<OboCrossSell__c> pNewOnes, Map<Id, OboCrossSell__c> pOldOnes){ return; }
    }

    @isTest public static void before_insert(){
        beginSetUp();
        OboCrossSellTrg.mHandler_instane = new IHandler_Stub();
        endSetUp();

        Test.startTest();
        INSERT new OboCrossSell__c();
        Test.stopTest();
    }
    @isTest public static void before_update(){
        beginSetUp();
        OboCrossSellTrg.mHandler_instane = new IHandler_Stub();
        OboCrossSell__c the_OboCrossSell = new OboCrossSell__c();
        INSERT the_OboCrossSell;
        endSetUp();

        Test.startTest();
        UPDATE new OboCrossSell__c(Id = the_OboCrossSell.Id);
        Test.stopTest();
    }
}