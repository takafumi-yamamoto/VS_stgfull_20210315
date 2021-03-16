@isTest
public class TerapSgSeikTasksCmdTriggerT {
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
	@isTest static void doTest(){
		beginSetUp();
		endSetUp();
		Test.startTest();
		INSERT New TerapSgSeikTasksCmd__c( BillingYm__c = Date.newInstance(2020,1,1));
		Test.stopTest();
	}
}