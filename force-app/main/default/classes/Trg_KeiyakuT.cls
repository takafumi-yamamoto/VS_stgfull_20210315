@isTest
public class Trg_KeiyakuT {


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
    private static void inject_mock(){
        Trg_Keiyaku.m_KrYsLockKeiyaku_IKeiyakuLocker_instance = new KrYsLockKeiyaku_IKeiyakuLocker_Mock();
    }
    private class KrYsLockKeiyaku_IKeiyakuLocker_Mock implements KrYsLockKeiyaku.IKeiyakuLocker{
        public void on_keiyaku_before_update(List<Keiyaku__c> p_new_ones, Map<Id, Keiyaku__c> p_old_ones){return;}
    }
    @isTest public static void on_insert(){
        beginSetUp();
        inject_mock();
        Map<String, Account> theAccounts = new Map<String, Account>{
            '葬儀社-1' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Sogisya'),
                Name = '_'
            )
        };
		INSERT theAccounts.values();
        endSetUp();

        Test.startTest();
        INSERT new Keiyaku__c(
            RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Keiyaku__c','SimpleYasugo'),
            Teikeisaki__c = theAccounts.get('葬儀社-1').Id
        );
        Test.stopTest();
    }
    @isTest public static void on_update(){
        beginSetUp();
        inject_mock();
        Map<String, Account> theAccounts = new Map<String, Account>{
            '葬儀社-1' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Sogisya'),
                Name = '_'
            )
        };
        INSERT theAccounts.values();
        
		Map<String, Keiyaku__c> theKeiyakus = new Map<String, Keiyaku__c>{
			'葬儀契約-1' => new Keiyaku__c(
				RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Keiyaku__c','SimpleYasugo'),
				Teikeisaki__c = theAccounts.get('葬儀社-1').Id
			)
		};
		INSERT theKeiyakus.values();
        endSetUp();

        Test.startTest();
        UPDATE new Keiyaku__c(
            Id = theKeiyakus.get('葬儀契約-1').Id,
            KeiyakuJokyo__c = '未契約'
        );
        Test.stopTest();
    }
}