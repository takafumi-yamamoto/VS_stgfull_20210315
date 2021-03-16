@isTest
public class NcpSzkSdnShkCardTrgT {
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

    private class IRecordKyeAssigner_Stub implements NcpSzkSdnShkCardKey.IRecordKyeAssigner{
        public void assignIfNotAssigned(List<NcpSzkSdnShkCard__c> pNewOnes){ return;}
    }
    private static void setup_stubs(){
        NcpSzkSdnShkCardTrg.m_IRecordKyeAssigner = new IRecordKyeAssigner_Stub();
    }
    @isTest public static void Handler_insert(){
        beginSetUp();
        endSetUp();
        Test.startTest();
        INSERT new NcpSzkSdnShkCard__c();
        Test.stopTest();
    }
}