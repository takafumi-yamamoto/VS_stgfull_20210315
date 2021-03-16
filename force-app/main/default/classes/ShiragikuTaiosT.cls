@isTest 
public class ShiragikuTaiosT {
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

    @isTest public static void CanShiragikuTaio_Judger_can_taio(){
        beginSetUp();
        Map<String, Account> the_accounts = new Map<String, Account>{
            '客-1' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                FirstName = '_', LastName = '_',
                Phone = '_'
            )
        };
        INSERT the_accounts.values();

        Map<String, SimpleYasugo__c> the_simple_yasugos = new Map<String, SimpleYasugo__c>{
            '葬儀-1' => new SimpleYasugo__c(
				SogiAfterSodanshaMailDatetime__c = Datetime.newInstance(2021,1,1, 0, 0, 0)
            )
        };
        INSERT the_simple_yasugos.values();

        Map<String, Opportunity> the_opps = new Map<String, Opportunity>{
            '葬儀商談-1' => new Opportunity(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo'),
                Name = '_',
                AccountId = the_accounts.get('客-1').Id,
                StageName = '施行完了',
                CloseDate = Date.newInstance(2000,1,1),
                Utiagebi__c = Date.newInstance(2021, 1, 1),
                SimpleYasugoRef__c = the_simple_yasugos.get('葬儀-1').Id
            )
        };
        INSERT the_opps.values();
        endSetUp();

        Test.startTest();
        new ShiragikuTaios.CanShiragikuTaio_Judger().can_taio(
            the_opps.get('葬儀商談-1').Id
        );
        Test.stopTest();
    }

    @isTest public static void get_ICanShiragikuTaio_Judger_instance(){
        Test.startTest();
        ShiragikuTaios.get_ICanShiragikuTaio_Judger_instance();
        Test.stopTest();
    }
}