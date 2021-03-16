@isTest
public class SkgnStatsT {

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
    
    private class ITaioKanoKeiyakuCounter_Stub implements SkgnSogiKeiyaku.ITaioKanoKeiyakuCounter{
        private String m_shikugun_id;
        public ITaioKanoKeiyakuCounter_Stub(String p_shikugun_id){
            this.m_shikugun_id = p_shikugun_id;
        }

        public Map<String, Integer> get_taiokano_keiyaku_count_by_shikugun_ids(List<String> p_shikugun_ids){
            return new Map<String, Integer>{ this.m_shikugun_id => 0 };
        }
    }

    @isTest public static void SkgnStatsUpdater_update_shikugun_stats(){
        beginSetUp();
        Map<String, Shikugun__c> the_Shikuguns = new Map<String, Shikugun__c>{
            '市区郡-1' => new Shikugun__c( Name = '_' )
        };
        INSERT the_Shikuguns.values();
        endSetUp();

        Test.startTest();
        new SkgnStats.SkgnStatsUpdater(
            new ITaioKanoKeiyakuCounter_Stub(
                the_Shikuguns.get('市区郡-1').Id
            )
        )
        .update_shikugun_stats(
            new List<String>{ the_Shikuguns.get('市区郡-1').Id }
        );
        Test.stopTest();
    }
}