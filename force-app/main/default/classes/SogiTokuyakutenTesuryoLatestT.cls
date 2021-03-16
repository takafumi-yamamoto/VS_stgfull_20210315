@isTest
public class SogiTokuyakutenTesuryoLatestT {
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
    @isTest public static void LatestUpdater_on_SogiShaTokuyakutenTesuryo_after_Insert(){
        beginSetUp();
        Map<String, Account> the_accounts = new Map<String, Account>{
            '葬儀社-1' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Sogisya'),
                Name = '_'
            )
        };
		INSERT the_accounts.values();

		Map<String, Keiyaku__c> the_tokuyakuten_keiyakus = new Map<String, Keiyaku__c>{
			'特約店契約-1' => new Keiyaku__c(
				RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Keiyaku__c','TokuyakuTen'),
				Teikeisaki__c = the_accounts.get('葬儀社-1').Id
			)
		};
		INSERT the_tokuyakuten_keiyakus.values();
        endSetUp();
        Test.startTest();
        INSERT new SogiShaTokuyakutenTesuryo__c(
            KeiyakuRef__c = the_tokuyakuten_keiyakus.get('特約店契約-1').Id
        );
        Test.stopTest();
    }

    @isTest public static void LatestUpdater_on_SogiShaTokuyakutenTesuryo_after_update(){
        beginSetUp();
        Map<String, Account> the_accounts = new Map<String, Account>{
            '葬儀社-1' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Sogisya'),
                Name = '_'
            )
        };
		INSERT the_accounts.values();

		Map<String, Keiyaku__c> the_tokuyakuten_keiyakus = new Map<String, Keiyaku__c>{
			'特約店契約-1' => new Keiyaku__c(
				RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Keiyaku__c','TokuyakuTen'),
				Teikeisaki__c = the_accounts.get('葬儀社-1').Id
			)
		};
		INSERT the_tokuyakuten_keiyakus.values();

        SogiShaTokuyakutenTesuryo__c a_SogiShaTokuyakutenTesuryo = 
            new SogiShaTokuyakutenTesuryo__c(
                KeiyakuRef__c = the_tokuyakuten_keiyakus.get('特約店契約-1').Id
            );
            INSERT a_SogiShaTokuyakutenTesuryo;
        endSetUp();
        Test.startTest();
        UPDATE a_SogiShaTokuyakutenTesuryo;
        Test.stopTest();
    }

    @isTest public static void LatestUpdater_on_SogiShaTokuyakutenTesuryo_after_delete(){
        beginSetUp();
        Map<String, Account> the_accounts = new Map<String, Account>{
            '葬儀社-1' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Sogisya'),
                Name = '_'
            )
        };
		INSERT the_accounts.values();

		Map<String, Keiyaku__c> the_tokuyakuten_keiyakus = new Map<String, Keiyaku__c>{
			'特約店契約-1' => new Keiyaku__c(
				RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Keiyaku__c','TokuyakuTen'),
				Teikeisaki__c = the_accounts.get('葬儀社-1').Id
			)
		};
		INSERT the_tokuyakuten_keiyakus.values();

        SogiShaTokuyakutenTesuryo__c a_SogiShaTokuyakutenTesuryo = 
            new SogiShaTokuyakutenTesuryo__c(
                KeiyakuRef__c = the_tokuyakuten_keiyakus.get('特約店契約-1').Id
            );
            INSERT a_SogiShaTokuyakutenTesuryo;
        endSetUp();
        Test.startTest();
        DELETE a_SogiShaTokuyakutenTesuryo;
        Test.stopTest();
    }
}