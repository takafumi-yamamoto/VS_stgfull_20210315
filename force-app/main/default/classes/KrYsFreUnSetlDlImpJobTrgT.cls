@isTest
public class KrYsFreUnSetlDlImpJobTrgT {
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
    
    public class KrYsFreUnSetlDlImp_IImportJob_Stub implements KrYsFreUnSetlDlImp.IImportJob{
        public KrYsFreUnSetlDlImp.IImportJob set_KrYsFreUnsetlDlId(String pValue){return this;}
        public void startAsync(){return;}
    }
    @isTest public static void Handler_onAfterInsert() {
        beginSetUp();
        KrYsFreUnSetlDlImpJobTrg.mHandler_instane =
            new KrYsFreUnSetlDlImpJobTrg.Handler(
                new KrYsFreUnSetlDlImp_IImportJob_Stub()
            );
        endSetUp();
        
        Test.startTest();
        INSERT new KrYsFreUnSetlDlImpJob__c();
        Test.stopTest();
    }
}