@isTest
public class KrYsHanteiChgdBatT {

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
    
    private class IStopOrUnStopper_Stub implements KrYsStopKeiyaku.IStopOrUnStopper{
        public void stop_or_unstop_by_yosin(String p_torihikisaki_bango){ return; }
    }
    @isTest public static void start() {
        beginSetUp();
        Map<String, KrYsYosin__c> theYosins = new Map<String, KrYsYosin__c>{
            '与信状況-1' => new KrYsYosin__c()
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
        
        KrYsHanteiChgdBat.m_IStopOrUnStopper_instance = new IStopOrUnStopper_Stub();
        endSetUp();

        Test.startTest();
        KrYsHanteiChgdBat.start();
        Test.stopTest();
    }

    @isTest public static void execute() {
        beginSetUp();
        Map<String, KrYsYosin__c> theYosins = new Map<String, KrYsYosin__c>{
            '与信状況-1' => new KrYsYosin__c(
                YosinHantei_VerLastest__c = '1'
            )
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
        endSetUp();

        Test.startTest();
        new KrYsHanteiChgdBat(
            new IStopOrUnStopper_Stub()
        ).execute(
            null,
            theYosins.values()
        );
        Test.stopTest();
    }
}