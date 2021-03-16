@isTest
public class TcmsEscalationTrgT {
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
    
    @isTest public static void Handler_onAfterInsert(){
        beginSetUp();
        endSetUp();
        Test.startTest();
        INSERT new TcmsEscalation__c(TcmsSeqNo__c = '1');
        Test.stopTest();
    }
}