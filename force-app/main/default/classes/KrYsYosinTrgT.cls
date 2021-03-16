@isTest public class KrYsYosinTrgT {
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
    
    private class KrYsYosinHantei_IYosinHantei_Stub implements KrYsYosinHantei.IYosinHantei{
        public void on_KrysYosin_before_insert(List<KrYsYosin__c> pNewOnes){ return;}
        public void on_KrysYosin_before_update(List<KrYsYosin__c> pNewOnes, Map<Id, KrYsYosin__c> pOldOnes){return;}
    }
    @isTest public static void Handler_onBeforeUpdate(){
        beginSetUp();
        KrYsYosinTrg.IYosinHantei_instance = new KrYsYosinHantei_IYosinHantei_Stub();
        endSetUp();

        Test.startTest();

        KrYsYosin__c a_old_one = new KrYsYosin__c(
            YosinGendoGaku__c = 10000,
            SaikenZandaka__c = 9000,
            SaikenZandakaRateAlert__c = 90
        );
        INSERT a_old_one;
        UPDATE new KrYsYosin__c(Id = a_old_one.Id, SaikenZandaka__c = 11000);
        Test.stopTest();
    }

    @isTest public static void Handler_onBeforeInsert(){
        beginSetUp();
        KrYsYosinTrg.IYosinHantei_instance = new KrYsYosinHantei_IYosinHantei_Stub();
        endSetUp();

        Test.startTest();
        INSERT new KrYsYosin__c(
            YosinGendoGaku__c = 10000,
            SaikenZandaka__c = 9000,
            SaikenZandakaRateAlert__c = 90
        );
        Test.stopTest();
    }
}