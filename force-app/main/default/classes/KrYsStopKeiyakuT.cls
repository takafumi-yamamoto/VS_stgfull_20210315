@isTest
public class KrYsStopKeiyakuT {

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
    @isTest public static void StopOrUnStopper_stop_or_unstop_by_yosin_stop() {
        beginSetUp();
        Map<String, KrYsYosin__c> theYosins = new Map<String, KrYsYosin__c>{
            '与信状況-1' => new KrYsYosin__c(YosinHantei__c = 'NG-与信限度額Over')
        };
        INSERT theYosins.values();
        Map<String, Account> theAccounts = new Map<String, Account>{
            '葬儀社-1' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Sogisya'),
                Name = '_',
                KrYsYosinRef__c = theYosins.get('与信状況-1').Id
            )
        };
        INSERT theAccounts.values();
        
		Map<String, Keiyaku__c> theKeiyakus = new Map<String, Keiyaku__c>{
			'葬儀契約-1' => new Keiyaku__c(
				RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Keiyaku__c','SimpleYasugo'),
                Teikeisaki__c = theAccounts.get('葬儀社-1').Id,
                KeiyakuJokyo__c = '契約中'
			)
		};
        INSERT theKeiyakus.values();
        String the_torihikisaki_bango = [SELECT Id, TorihikisakiBango__c FROM Account WHERE Id = :theAccounts.get('葬儀社-1').Id ].get(0).TorihikisakiBango__c;
        endSetUp();

        Test.startTest();
        new KrYsStopKeiyaku.StopOrUnStopper(
            KrYsStopKeiyaku.get_IStopOfKeiyaku_instance(),
            KrYsStopKeiyaku.get_IUnStopOfKeiyaku_instance()
        ).stop_or_unstop_by_yosin(
            the_torihikisaki_bango
        );
        Test.stopTest();
    }

    @isTest public static void StopOrUnStopper_stop_or_unstop_by_yosin_unstop() {
        beginSetUp();
        Map<String, KrYsYosin__c> theYosins = new Map<String, KrYsYosin__c>{
            '与信状況-1' => new KrYsYosin__c(YosinHantei__c = 'OK')
        };
        INSERT theYosins.values();
        Map<String, Account> theAccounts = new Map<String, Account>{
            '葬儀社-1' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Sogisya'),
                Name = '_',
                KrYsYosinRef__c = theYosins.get('与信状況-1').Id
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
        String the_torihikisaki_bango = [SELECT Id, TorihikisakiBango__c FROM Account WHERE Id = :theAccounts.get('葬儀社-1').Id ].get(0).TorihikisakiBango__c;
        endSetUp();

        Test.startTest();
        Utility_Common.isMimicExecAsDataIkouProfile = true;
        new KrYsStopKeiyaku.StopOrUnStopper(
            KrYsStopKeiyaku.get_IStopOfKeiyaku_instance(),
            KrYsStopKeiyaku.get_IUnStopOfKeiyaku_instance()
        ).stop_or_unstop_by_yosin(
            the_torihikisaki_bango
        );
        Test.stopTest();
    }
}