@isTest
public class KrYsYosinHanteiT {
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
    @isTest public static void YosinHantei_on_KrysYosin_before_update(){
        beginSetUp();
        KrYsYosin__c a_old_one = new KrYsYosin__c(
            YosinGendoGaku__c = 10000,
            SaikenZandaka__c = 9000,
            SaikenZandakaRateAlert__c = 90
        );
        INSERT a_old_one;

        KrYsYosin__c a_new_one = a_old_one.clone(true);
        a_new_one.SaikenZandaka__c = 11000;

        endSetUp();
        Test.startTest();
        new KrYsYosinHantei.YosinHantei().on_KrysYosin_before_update(
            new List<KrYsYosin__c>{a_new_one},
            new Map<Id, KrYsYosin__c>{ a_old_one.Id => a_old_one }
        );
        Test.stopTest();
    }

    @isTest public static void YosinHantei_onKrysYosin_before_insert(){
        beginSetUp();
        KrYsYosin__c a_new_one = new KrYsYosin__c(
            YosinGendoGaku__c = 10000,
            SaikenZandaka__c = 0,
            YosinZandakaAlert__c = 5000
        );

        endSetUp();
        Test.startTest();
        new KrYsYosinHantei.YosinHantei().on_KrysYosin_before_insert(
            new List<KrYsYosin__c>{a_new_one}
        );
        Test.stopTest();
    }
    
}