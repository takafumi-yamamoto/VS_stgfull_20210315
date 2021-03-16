@isTest
public class SzsdDontContactMeT {

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
    @isTest public static void DontContactMe_Judger_is_dont_contact_me(){
        beginSetUp();
        Map<String, Account> the_accounts = new Map<String, Account>{
            '客-1' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                FirstName = '_', LastName = '_'
            )
        };
        INSERT the_accounts.values();
        endSetUp();
        Test.startTest();
        new SzsdDontContactMe.DontContactMe_Judger(
            new Todays.TodayStub().setNow( Datetime.newInstance(2020,1,1,0,0,0) )
        )
        .is_dont_contact_me( the_accounts.get('客-1').Id );
        Test.stopTest();
    }
}