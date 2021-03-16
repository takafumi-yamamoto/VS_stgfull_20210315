@isTest
public class KrshPubCardCmdBatT {
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

    @isTest public static void start(){
        beginSetUp();
        Map<String, Account> theAccounts = new Map<String, Account>{
            'Customer' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                FirstName = 'FirstName', LastName = 'LastName',
				Phone = '000-0000-0000'
            ),
            'Taishosha' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
				FirstName = 'FirstName', LastName = 'LastName',
				PersonDeathDate__pc = Date.today()
            )
        };
		INSERT theAccounts.values();

        Map<String, SimpleYasugo__c> theSimpleYasugos = new Map<String, SimpleYasugo__c>{
            '1' => new SimpleYasugo__c(
				SonotaSaijoShisetsu__c = 'SaijoName',
				TaishoshaRef__c = theAccounts.get('Taishosha').Id,
				ZokugaraSodanshaNitottenoTaishosha__c = '本人'
            )
        };
        INSERT theSimpleYasugos.values();

        Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
            '1' => new Opportunity(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo'),
                Name = '_',
                AccountId = theAccounts.get('Customer').Id,
                StageName = '施行待ち',
				CloseDate = Date.newInstance(2000,1,1),
				Utiagebi__c = Date.today(),
                SimpleYasugoRef__c = theSimpleYasugos.get('1').Id
            )
        };
        INSERT theOpps.values();

        String theShodanBango = [ SELECT Id, ShodanBango__c FROM Opportunity WHERE Id = :theOpps.get('1').Id ].get(0).ShodanBango__c;
        INSERT new KrshPubCardCmd__c(ShodanBango__c = theShodanBango, ShoriStatus__c = 'Created');
        endSetUp();

        Test.startTest();
        KrshPubCardCmdBat.start();
        Test.stopTest();
    }

    @isTest public static void start_error(){
        beginSetUp();
        INSERT new KrshPubCardCmd__c(ShodanBango__c = 'bad-data', ShoriStatus__c = 'Created');
        endSetUp();

        Test.startTest();
        KrshPubCardCmdBat.start();
        Test.stopTest();
    }


    
    @isTest public static void schedulable_execute(){
        Test.startTest();
        new KrshPubCardCmdBat().execute(null);
        Test.stopTest();
    }

    @isTest public static void schedulable_execute_error(){
        Test.startTest();
        KrshPubCardCmdBat.i_will_occur_exception_for_test = true;
        try{
            new KrshPubCardCmdBat().execute(null);
        }catch(Exception ex){ }
        Test.stopTest();
    }
}