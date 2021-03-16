@isTest
public class KrYsLockKeiyakuT {

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
    @isTest public static void KeiyakuLocker_on_keiyaku_before_update() {
        beginSetUp();
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
                Teikeisaki__c = theAccounts.get('葬儀社-1').Id,
                KeiyakuJokyo__c = '失効中',
                IsYosinOverStop__c = true
			)
		};
        INSERT theKeiyakus.values();
        
        Keiyaku__c a_old_one = theKeiyakus.get('葬儀契約-1');
        Keiyaku__c a_new_one = new Keiyaku__c(
            Id = a_old_one.Id,
            KeiyakuJokyo__c = '契約中',
            IsYosinOverStop__c = a_old_one.IsYosinOverStop__c
        );
        endSetUp();
        Test.startTest();
        new KrYsLockKeiyaku.KeiyakuLocker().on_keiyaku_before_update(
            new List<Keiyaku__c>{ a_new_one }, 
            new Map<Id, Keiyaku__c>{
                a_old_one.Id => a_old_one
            }
        );
        Test.stopTest();
    }

    @isTest public static void get_IKeiyakuLocker_instance(){
        Test.startTest();
        KrYsLockKeiyaku.get_IKeiyakuLocker_instance();
        Test.stopTest();
    }
}