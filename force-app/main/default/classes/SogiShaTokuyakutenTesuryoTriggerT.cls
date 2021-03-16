@isTest
public class SogiShaTokuyakutenTesuryoTriggerT {
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
    private class IHandler_Stub implements Trg_SogiShaTokuyakutenTesuryo.IHandler{
        public void set_context(Boolean pIsExecuting, Integer pSize){return;}
        public void on_after_insert(List<SogiShaTokuyakutenTesuryo__c> p_new_ones){return;}
        public void on_after_update(List<SogiShaTokuyakutenTesuryo__c> p_new_ones, Map<Id,SogiShaTokuyakutenTesuryo__c> p_old_ones){return;}
        public void on_after_delete(Map<Id,SogiShaTokuyakutenTesuryo__c> p_old_ones){return;}
    }
    @isTest public static void on_insert(){
        beginSetUp();
        Trg_SogiShaTokuyakutenTesuryo.mHandler_instane = new IHandler_Stub();
        endSetUp();
        Test.startTest();
        INSERT new SogiShaTokuyakutenTesuryo__c();
        Test.stopTest();
    }
    @isTest public static void on_update(){
        beginSetUp();
        SogiShaTokuyakutenTesuryo__c a_SogiShaTokuyakutenTesuryo = new SogiShaTokuyakutenTesuryo__c();
        INSERT a_SogiShaTokuyakutenTesuryo;
        Trg_SogiShaTokuyakutenTesuryo.mHandler_instane = new IHandler_Stub();
        endSetUp();
        Test.startTest();
        UPDATE a_SogiShaTokuyakutenTesuryo;
        Test.stopTest();
    }
    @isTest public static void on_delete(){
        beginSetUp();
        SogiShaTokuyakutenTesuryo__c a_SogiShaTokuyakutenTesuryo = new SogiShaTokuyakutenTesuryo__c();
        INSERT a_SogiShaTokuyakutenTesuryo;
        Trg_SogiShaTokuyakutenTesuryo.mHandler_instane = new IHandler_Stub();
        endSetUp();
        Test.startTest();
        DELETE a_SogiShaTokuyakutenTesuryo;
        Test.stopTest();
    }
}