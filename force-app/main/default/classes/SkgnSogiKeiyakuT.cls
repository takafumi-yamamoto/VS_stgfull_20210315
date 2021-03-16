@isTest
public class SkgnSogiKeiyakuT {
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
    
    @isTest public static void TaioKanoKeiyakuCounter_get_taiokano_keiyaku_count_by_shikugun_ids(){
        beginSetUp();
        Map<String, Account> the_Accounts = new Map<String, Account>{
            '葬儀社' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Sogisya'),
                Name = '_'
            )
        };
        INSERT the_Accounts.values();
        
		Map<String, Keiyaku__c> the_Keiyakus = new Map<String, Keiyaku__c>{
			'葬儀契約-1' => new Keiyaku__c(
				RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Keiyaku__c','SimpleYasugo'),
                Teikeisaki__c = the_accounts.get('葬儀社').Id,
                KeiyakuJokyo__c = '契約中'
			)
		};
        INSERT the_Keiyakus.values();
        
        Map<String, Shikugun__c> the_Shikuguns = new Map<String, Shikugun__c>{
            '市区郡-1' => new Shikugun__c( Name = '_' )
        };
        INSERT the_Shikuguns.values();

        Map<String, SekouKanouArea__c> the_SekouKanouAreas = new Map<String, SekouKanouArea__c>{
            '施行可能エリア-1' => new SekouKanouArea__c(
                SimpleYasugoKeiyakuRef__c = the_Keiyakus.get('葬儀契約-1').Id,
                ShikugunRef__c = the_Shikuguns.get('市区郡-1').Id
            )
        };
        INSERT the_SekouKanouAreas.values();
        endSetUp();

        Test.startTest();
        new SkgnSogiKeiyaku.TaioKanoKeiyakuCounter().get_taiokano_keiyaku_count_by_shikugun_ids(
            new List<String>{ the_Shikuguns.get('市区郡-1').Id }
        );
        Test.stopTest();
    }
}