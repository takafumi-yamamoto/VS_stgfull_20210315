@isTest
public class SzsdCardExcldT {
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

    private class IOppBasicVallidator_Stub implements Szsd_OppValids.IOppBasicVallidator{
        public List<Opportunity> select_opps( List<String> p_opp_ids){ return new List<Opportunity>(); }
        public Boolean is_valid(Opportunity p_opp){ return true; }
        public Boolean is_valid( String p_opp_id){ return true; }
    }
    private class IDontContactMe_Judger_Stub implements SzsdDontContactMe.IDontContactMe_Judger{
        public Boolean is_dont_contact_me(String p_account_id){return false;}
    }
    private class ITestDataJudger_Stub implements TesterOpp.ITestDataJudger{
        public Boolean isTestData( Opportunity pOpp ){return false;}
        public  List<Opportunity> select_opps(List<String> p_opp_ids){ return new List<Opportunity>(); }
        public Boolean isTestData( String p_opp_id ){return false;}
    }
    private class ICardFinder_Stub implements SzsdAssigneesCard.ICardFinder{
        public Boolean is_card_published_for_any_asignee(String p_opp_id){return false;}
    }
    private class IOppList_For_Shiragiku_Stub implements Szsd_Shiiragiku.IOppList_For_Shiragiku{
        public List<Opportunity> select_opps(List<String> p_opp_ids){ return new List<Opportunity>(); }
        public Boolean isMatch(Opportunity p_opp){return false;}
        public Boolean isMatch(String p_opp_id){return false;}
    }
    @isTest public static void JudgeToExclude_to_exclude(){
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
        new SzsdCardExcld.JudgeToExclude(
            new IOppBasicVallidator_Stub(),
            new IDontContactMe_Judger_Stub(),
            new IOppList_For_Shiragiku_Stub(),
            new ITestDataJudger_Stub(),
            new ICardFinder_Stub(),
            new Environments.Env()
        )
        .to_exclude( the_opps.get('葬儀商談-1').Id , false);
        Test.stopTest();
    }

    @isTest public static void get_IJudgeToExclude_instance(){
        Test.startTest();
        SzsdCardExcld.get_IJudgeToExclude_instance();
        Test.stopTest();
    }
}