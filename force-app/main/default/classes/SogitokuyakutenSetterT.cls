@isTest
public class SogitokuyakutenSetterT {
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
    public static void TokuyakutenKeiyakuSetter_set_tokuyakuten_keiyaku(){
        beginSetUp();

        Map<String, Account> the_accounts = new Map<String, Account>{
            '客-1' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                FirstName = '_', LastName = '_'
            ),
            '葬儀社-1' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Sogisya'),
                Name = '_'
            )
        };
		INSERT the_accounts.values();

		Map<String, Keiyaku__c> the_sogi_keiyakus = new Map<String, Keiyaku__c>{
			'葬儀契約-1' => new Keiyaku__c(
				RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Keiyaku__c','SimpleYasugo'),
				Teikeisaki__c = the_accounts.get('葬儀社-1').Id,
                KeiyakuJokyo__c = '契約中'
			)
		};
        INSERT the_sogi_keiyakus.values();

		Map<String, Keiyaku__c> the_tokuyakuten_keiyakus = new Map<String, Keiyaku__c>{
			'特約店契約-1' => new Keiyaku__c(
				RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Keiyaku__c','TokuyakuTen'),
				Teikeisaki__c = the_accounts.get('葬儀社-1').Id,
                SyuKeiyakuRef__c = the_sogi_keiyakus.get('葬儀契約-1').Id,
                KeiyakuJokyo__c = '契約中'
			)
		};
		INSERT the_tokuyakuten_keiyakus.values();

        Map<String, SimpleYasugo__c> the_simple_yasugos = new Map<String, SimpleYasugo__c>{
            '葬儀-1' => new SimpleYasugo__c( SimpleYasugoKeiyakuRef__c = null)
        };
        INSERT the_simple_yasugos.values();

        Map<String, Opportunity> the_opps = new Map<String, Opportunity>{
            '1' => new Opportunity(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo'),
                Name = '_',
                AccountId = the_accounts.get('客-1').Id,
                StageName = '_',
				CloseDate = Date.newInstance(2000,1,1),
                SimpleYasugoRef__c = the_simple_yasugos.get('葬儀-1').Id
            )
        };
        INSERT the_opps.values();

        SimpleYasugo__c a_old_one = the_simple_yasugos.get('葬儀-1');
        SimpleYasugo__c a_new_one = a_old_one.clone(true);
        a_new_one.SimpleYasugoKeiyakuRef__c = the_sogi_keiyakus.get('葬儀契約-1').Id;
        endSetUp();

        Test.startTest();

        new SogitokuyakutenSetter.TokuyakutenKeiyakuSetter().set_tokuyakuten_keiyaku(
            new List<SimpleYasugo__c>{ a_new_one },
            new Map<Id, SimpleYasugo__c>{ a_old_one.Id => a_old_one }
        );

        Test.stopTest();
    }
}