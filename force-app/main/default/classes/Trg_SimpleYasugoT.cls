@isTest
public class Trg_SimpleYasugoT {

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
    private class ITokuyakutenKeiyakuSetter_Stub implements SogitokuyakutenSetter.ITokuyakutenKeiyakuSetter{
        public void set_tokuyakuten_keiyaku(List<SimpleYasugo__c> pNewOnes , Map<Id, SimpleYasugo__c> oldOnes){ return; }
    }

    private static void setup_stubs(){
        Trg_SimpleYasugo.m_ITokuyakutenKeiyakuSetter = new ITokuyakutenKeiyakuSetter_Stub();
    }
	@isTest public static void OnAfterInsert(){
		beginSetUp();
		endSetUp();
		Test.startTest();
		INSERT NEW SimpleYasugo__c();
		Test.stopTest();
	}

    @isTest public static void OnBeforeUpdate(){
        beginSetUp();
        Map<String, Account> the_accounts = new Map<String, Account>{
            '客-1' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                FirstName = '_', LastName = '_'
            )
        };
		INSERT the_accounts.values();

        Map<String, SimpleYasugo__c> the_simple_yasugos = new Map<String, SimpleYasugo__c>{
            '葬儀-1' => new SimpleYasugo__c( SimpleYasugoKeiyakuRef__c = null)
        };
        INSERT the_simple_yasugos.values();

        Map<String, Opportunity> the_opps = new Map<String, Opportunity>{
            '葬儀商談-1' => new Opportunity(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo'),
                Name = '_',
                AccountId = the_accounts.get('客-1').Id,
                StageName = '_',
				CloseDate = Date.newInstance(2000,1,1),
                SimpleYasugoRef__c = the_simple_yasugos.get('葬儀-1').Id
            )
        };
        INSERT the_opps.values();
        setup_stubs();
        endSetUp();
        Test.startTest();
        UPDATE the_simple_yasugos.get('葬儀-1');
        Test.stopTest();
    }

	@isTest public static void OnAfterUpdate(){
		beginSetUp();

        Map<String, Account> theAccounts = new Map<String, Account>{
            '客' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                FirstName = '_', LastName = '_'
            )
        };
		INSERT theAccounts.values();

        Map<String, SimpleYasugo__c> theSimpleYasugos = new Map<String, SimpleYasugo__c>{
            '葬儀' => new SimpleYasugo__c()
        };
        INSERT theSimpleYasugos.values();

        Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
            '葬儀' => new Opportunity(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo'),
                Name = '_',
                AccountId = theAccounts.get('客').Id,
                StageName = '_',
				CloseDate = Date.newInstance(2000,1,1),
                SimpleYasugoRef__c = theSimpleYasugos.get('葬儀').Id
            )
        };
        Insert theOpps.values();
		endSetUp();
		UPDATE new SimpleYasugo__c(Id = theSimpleYasugos.get('葬儀').Id );
	}
}