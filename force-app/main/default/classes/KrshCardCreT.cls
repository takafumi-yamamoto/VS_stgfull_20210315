@isTest
public class KrshCardCreT {
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
    
    private class IJudgeToExclude_Stub implements SzsdCardExcld.IJudgeToExclude{
        public Boolean to_exclude( String p_opp_id, Boolean p_is_hakkou_shijji_directly){
            return false;
        }
    }
    @isTest public static void CardCreator_try_publish_card(){
        beginSetUp();
        Map<String, Account> the_accounts = new Map<String, Account>{
            '客-1' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                FirstName = '_', LastName = '_'
            )
        };
        INSERT the_accounts.values();

        Map<String, Opportunity> the_opps = new Map<String, Opportunity>{
            '葬儀商談-1' => new Opportunity(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo'),
                Name = '_',
                AccountId = the_accounts.get('客-1').Id,
                StageName = '_',
                CloseDate = Date.newInstance(2000,1,1)
            )
        };
        INSERT the_opps.values();
        endSetUp();

        Test.startTest();
        new KrshCardCre.CardCreator(
            new Todays.TodayStub().setNow( Datetime.newInstance(2020,1,1,0,0,0) ),
            new IJudgeToExclude_Stub()
        )
        .try_publish_card(the_opps.get('葬儀商談-1').Id, true);
        Test.stopTest();
    }
}