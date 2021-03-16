@isTest
public class KrYsFreUnSetlDlImpJobTriggerT {

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
    
    public class KrYsFreUnSetlDlImpJobTrg_IHandler_Stub implements KrYsFreUnSetlDlImpJobTrg.IHandler{
        public void set_context(Boolean pIsExecuting, Integer pSize){return;}
        public void onAfterInsert(List<KrYsFreUnSetlDlImpJob__c> pNewOnes){return;}
    }
    @isTest public static void after_insert() {
        beginSetUp();
        KrYsFreUnSetlDlImpJobTrg.mHandler_instane = new KrYsFreUnSetlDlImpJobTrg_IHandler_Stub();
        endSetUp();
        
        Test.startTest();
        INSERT new KrYsFreUnSetlDlImpJob__c();
        Test.stopTest();
    }
}