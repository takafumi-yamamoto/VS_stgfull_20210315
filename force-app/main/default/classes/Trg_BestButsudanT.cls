@isTest
public class Trg_BestButsudanT {
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

	@isTest
	public static void onAfterUpdate(){
		beginSetUp();
		BestButsudan__c theBest = new BestButsudan__c();
		INSERT theBest;
		endSetUp();
		UPDATE theBest;
	}
}