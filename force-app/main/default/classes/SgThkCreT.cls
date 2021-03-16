@isTest
public class SgThkCreT {

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

    private class IToExclude_Judger_Stub implements SgThkExcld.IToExclude_Judger{
        public Set<SgThkExcld.Reasons_To_Exclude> get_any_reason_to_exclude(String p_opp_id){
            return new Set<SgThkExcld.Reasons_To_Exclude>();
        }
    }
    private class IServiceToBeExcluded_Judger_Stub implements SgThkSvcExcld.IServiceToBeExcluded_Judger{
        public Set<SgThkSvcExcld.ServiceKubuns> get_services_tobe_excluded(String p_opp_id){
            return new Set<SgThkSvcExcld.ServiceKubuns>();
        }
    }

    @isTest
    public static void SogiSekogoThankYouCallCreator_try_create() {
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
        new SgThkCre.SogiSekogoThankYouCallCreator(
            new IToExclude_Judger_Stub(),
            new IServiceToBeExcluded_Judger_Stub(),
            new Todays.TodayStub().setNow( Date.newInstance(2021,1,1) )
        )
        .try_create(the_opps.get('葬儀商談-1').Id);
        Test.stopTest();
    }
}