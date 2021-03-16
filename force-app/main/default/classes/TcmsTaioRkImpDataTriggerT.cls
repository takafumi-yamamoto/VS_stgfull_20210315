@isTest
public class TcmsTaioRkImpDataTriggerT {
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
    
    private class IHandler_Stub implements TcmsTaioRkImpDataTrg.IHandler{
        public void set_context(Boolean pIsExecuting, Integer pSize){ return; }
        public void onBeforeInsert(List<TcmsTaioRkImpData__c> pNewOnes){ return; }
        public void onBeforeUpdate(List<TcmsTaioRkImpData__c> pNewOnes, Map<Id, TcmsTaioRkImpData__c> pOldOnes){ return; }
    }
    @isTest public static void inserts(){
        beginSetUp();
        TcmsTaioRkImpDataTrg.mHandler_instane = new IHandler_Stub();
        endSetUp();
        Test.startTest();
        TcmsTaioRkImpData__c the_TcmsTaioRkImpData = new TcmsTaioRkImpData__c(TcmsSeqNo__c = '1');
        INSERT the_TcmsTaioRkImpData;
        Test.stopTest();
    }

    @isTest public static void updates(){
        beginSetUp();
        TcmsTaioRkImpDataTrg.mHandler_instane = new IHandler_Stub();
        endSetUp();
        Test.startTest();
        TcmsTaioRkImpData__c the_TcmsTaioRkImpData = new TcmsTaioRkImpData__c(TcmsSeqNo__c = '1');
        INSERT the_TcmsTaioRkImpData;
        UPDATE the_TcmsTaioRkImpData;
        Test.stopTest();
    }
}