@isTest
public class SzsdPubCardCmdBatT {

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

    private class ICardPublisher_Stub implements SzsdPubCard.ICardPublisher{
        public String try_publish_card( String p_opp_id, Boolean p_is_hakkou_shijji_directly){return null; }
    }
    @isTest public static void start(){
        Test.startTest();
        SzsdPubCardCmdBat.start();
        Test.stopTest();
    }

    @isTest public static void SzsdPubCardBat_execut(){
        beginSetUp();
        Map<String, Account> the_accounts = new Map<String, Account>{
            '客-1' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                FirstName = '_', LastName = '_'
            )
        };
        INSERT the_accounts.values();

        Map<String, Opportunity> the_opps = new Map<String, Opportunity>{
            '葬儀商談-1' => new Opportunity(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo'),
                Name = '_',
                AccountId = the_accounts.get('客-1').Id,
                StageName = '_',
                CloseDate = Date.newInstance(2000,1,1)
            )
        };
        INSERT the_opps.values();

        String the_ShodanBango = [SELECT Id, ShodanBango__c FROM Opportunity WHERE Id = :the_opps.get('葬儀商談-1').Id ].get(0).ShodanBango__c;

        Map<String, SzsdPubCardCmd__c> the_SzsdPubCardCmds = new Map<String, SzsdPubCardCmd__c>{
            '葬儀商談-1' => new SzsdPubCardCmd__c(
                ShodanBango__c = the_ShodanBango
            )
        };
        INSERT the_SzsdPubCardCmds.values();

        endSetUp();

        Test.startTest();
        new SzsdPubCardCmdBat(
            new SzsdPubCardCmdBat.RecordSelector(),
            new ICardPublisher_Stub()
        )
        .execute(
            null, 
            the_SzsdPubCardCmds.values()
        );
        Test.stopTest();
    }
}