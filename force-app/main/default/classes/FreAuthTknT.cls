@isTest
public class FreAuthTknT {

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
    @isTest public static void TokenProvider_getTokenInfo(){
        beginSetUp();
        Environments.Env a_Env = new Environments.Env();
        String theKeyName = a_Env.isSandbox() ? 'dev' : 'prod';
        INSERT new FreApiAuthTkn__c(Env__c = theKeyName);
        endSetUp();

        Test.startTest();
        FreAuthTkn.get_ITokenProvider_instance().getTokenInfo();
        Test.stopTest();
    }
}