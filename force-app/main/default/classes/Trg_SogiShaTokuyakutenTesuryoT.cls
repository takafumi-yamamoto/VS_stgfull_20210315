@isTest
public class Trg_SogiShaTokuyakutenTesuryoT {
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

    private class ILatestUpdater_Stub implements SogiTokuyakutenTesuryoLatest.ILatestUpdater{
        public void on_SogiShaTokuyakutenTesuryo_after_Insert( List<SogiShaTokuyakutenTesuryo__c> p_new_ones ){
            return;
        }
        public void on_SogiShaTokuyakutenTesuryo_after_update(
            List<SogiShaTokuyakutenTesuryo__c> p_new_ones, Map<Id, SogiShaTokuyakutenTesuryo__c> p_old_ones
        ){ return; }
        public void on_SogiShaTokuyakutenTesuryo_after_delete( Map<Id, SogiShaTokuyakutenTesuryo__c> p_old_ones ){
            return;
        }
    }
    @isTest public static void Handler_on_after_insert(){
        beginSetUp();
        Trg_SogiShaTokuyakutenTesuryo.m_ILatestUpdater = new ILatestUpdater_Stub();
        endSetUp();
        Test.startTest();
        INSERT new SogiShaTokuyakutenTesuryo__c();
        Test.stopTest();
    }
    @isTest public static void Handler_on_after_update(){
        beginSetUp();
        SogiShaTokuyakutenTesuryo__c a_SogiShaTokuyakutenTesuryo = new SogiShaTokuyakutenTesuryo__c();
        INSERT a_SogiShaTokuyakutenTesuryo;
        Trg_SogiShaTokuyakutenTesuryo.m_ILatestUpdater = new ILatestUpdater_Stub();
        endSetUp();
        Test.startTest();
        UPDATE a_SogiShaTokuyakutenTesuryo;
        Test.stopTest();
    }
    @isTest public static void Handler_on_after_delete(){
        beginSetUp();
        SogiShaTokuyakutenTesuryo__c a_SogiShaTokuyakutenTesuryo = new SogiShaTokuyakutenTesuryo__c();
        INSERT a_SogiShaTokuyakutenTesuryo;
        Trg_SogiShaTokuyakutenTesuryo.m_ILatestUpdater = new ILatestUpdater_Stub();
        endSetUp();
        Test.startTest();
        DELETE a_SogiShaTokuyakutenTesuryo;
        Test.stopTest();
    }
}