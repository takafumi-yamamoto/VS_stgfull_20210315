@isTest
public class SgThkSvcOppCreSvcT {

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
    @isTest public static void create_opp(){
        beginSetUp();
        Map<String, SgThkCallSvcAnnai__c> the_SgThkCallSvcAnnais = new Map<String, SgThkCallSvcAnnai__c>{
            'サービス案内-1' => new SgThkCallSvcAnnai__c()
        };
        INSERT the_SgThkCallSvcAnnais.values();
        endSetUp();

        Test.startTest();
        SgThkSvcOppCreSvc.create_opp(
            new SgThkSvcOppCreSvc.CreateOppReq()
                .set_SgThkCallSvcAnnai_id( the_SgThkCallSvcAnnais.get('サービス案内-1').Id )
        );
        Test.stopTest();
    }


    @isTest public static void OppCreator_49Nichi_create_opp(){
        beginSetUp();
        Map<String, Account> the_accounts = new Map<String, Account>{
            '客-1' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                FirstName = '_', LastName = '_'
            )
        };
        INSERT the_accounts.values();

        Map<String, SgThkCall__c> the_SgThkCalls = new Map<String, SgThkCall__c>{
            'ThankYouCall-1' => new SgThkCall__c(
                SodanshaRef__c = the_accounts.get('客-1').Id
            )
        };
        INSERT the_SgThkCalls.values();

        Map<String, SgThkCallSvcAnnai__c> the_SgThkCallSvcAnnais = new Map<String, SgThkCallSvcAnnai__c>{
            'サービス案内-1' => new SgThkCallSvcAnnai__c( SgThkCallRef__c = the_SgThkCalls.get('ThankYouCall-1').Id )
        };
        INSERT the_SgThkCallSvcAnnais.values();

        endSetUp();

        Test.startTest();
        new SgThkSvcOppCreSvc.OppCreator_49Nichi().create_opp( the_SgThkCallSvcAnnais.get('サービス案内-1').Id );
        Test.stopTest();
    }

    @isTest public static void OppCreator_EitaiKuyo_create_opp(){
        beginSetUp();
        Map<String, Account> the_accounts = new Map<String, Account>{
            '客-1' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                FirstName = '_', LastName = '_'
            )
        };
        INSERT the_accounts.values();

        Map<String, SgThkCall__c> the_SgThkCalls = new Map<String, SgThkCall__c>{
            'ThankYouCall-1' => new SgThkCall__c(
                SodanshaRef__c = the_accounts.get('客-1').Id
            )
        };
        INSERT the_SgThkCalls.values();

        Map<String, SgThkCallSvcAnnai__c> the_SgThkCallSvcAnnais = new Map<String, SgThkCallSvcAnnai__c>{
            'サービス案内-1' => new SgThkCallSvcAnnai__c( SgThkCallRef__c = the_SgThkCalls.get('ThankYouCall-1').Id )
        };
        INSERT the_SgThkCallSvcAnnais.values();

        endSetUp();

        Test.startTest();
        new SgThkSvcOppCreSvc.OppCreator_EitaiKuyo().create_opp( the_SgThkCallSvcAnnais.get('サービス案内-1').Id );
        Test.stopTest();
    }

    @isTest public static void OppCreator_KaiyoSankotsu_create_opp(){
        beginSetUp();
        Map<String, Account> the_accounts = new Map<String, Account>{
            '客-1' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                FirstName = '_', LastName = '_'
            )
        };
        INSERT the_accounts.values();

        Map<String, SgThkCall__c> the_SgThkCalls = new Map<String, SgThkCall__c>{
            'ThankYouCall-1' => new SgThkCall__c(
                SodanshaRef__c = the_accounts.get('客-1').Id
            )
        };
        INSERT the_SgThkCalls.values();

        Map<String, SgThkCallSvcAnnai__c> the_SgThkCallSvcAnnais = new Map<String, SgThkCallSvcAnnai__c>{
            'サービス案内-1' => new SgThkCallSvcAnnai__c( SgThkCallRef__c = the_SgThkCalls.get('ThankYouCall-1').Id )
        };
        INSERT the_SgThkCallSvcAnnais.values();

        endSetUp();

        Test.startTest();
        new SgThkSvcOppCreSvc.OppCreator_KaiyoSankotsu().create_opp( the_SgThkCallSvcAnnais.get('サービス案内-1').Id );
        Test.stopTest();
    }
}