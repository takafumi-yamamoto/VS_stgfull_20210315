@isTest
public class Trg_PatnerUriageT {

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
    private class ISogiShiharaitsuchisyo_Stub implements SogiShiharaitsuchisyo.ISogiShiharaitsuchisyo{
        public void updateShiharaitsuchisyo (List<PatnerUriage__c> pEntries){ return ; }
    }
    private static void injectStub(){
        Trg_PatnerUriage.m_ISogiShiharaitsuchisyo_instance = new ISogiShiharaitsuchisyo_Stub();
    }
    
    @isTest public static void on_insert() {
        beginSetUp();
        Map<String, Account> theAccounts = new Map<String, Account>{
            '客' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                FirstName = '_', LastName = '_'
            )
        };
        INSERT theAccounts.values();

        Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
            '葬儀商談' => new Opportunity(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo'),
                Name = '_',
                AccountId = theAccounts.get('客').Id,
                StageName = '_',
				CloseDate = Date.newInstance(2000,1,1)
            )
        };
        INSERT theOpps.values();
        injectStub();
        endSetUp();

        Test.startTest();
        INSERT New PatnerUriage__c(Syodan__c = theOpps.get('葬儀商談').Id);
        Test.stopTest();
    }
    @isTest public static void on_udpate() {
        beginSetUp();
        Map<String, Account> theAccounts = new Map<String, Account>{
            '客' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                FirstName = '_', LastName = '_'
            )
        };
        INSERT theAccounts.values();

        Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
            '葬儀商談' => new Opportunity(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo'),
                Name = '_',
                AccountId = theAccounts.get('客').Id,
                StageName = '_',
				CloseDate = Date.newInstance(2000,1,1)
            )
        };
        INSERT theOpps.values();
        
        Map<String, PatnerUriage__c> thePartnerCyoseis = new Map<String, PatnerUriage__c>{
            'パートナー調整' => new PatnerUriage__c(
                Syodan__c = theOpps.get('葬儀商談').Id
            )
        };
        INSERT thePartnerCyoseis.values();
        injectStub();
        endSetUp();

        Test.startTest();
        UPDATE new PatnerUriage__c( Id = thePartnerCyoseis.get('パートナー調整').Id );
        Test.stopTest();
    }

    @isTest public static void on_delete(){
        beginSetUp();
        Map<String, Account> theAccounts = new Map<String, Account>{
            '客' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                FirstName = '_', LastName = '_'
            )
        };
        INSERT theAccounts.values();

        Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
            '葬儀商談' => new Opportunity(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo'),
                Name = '_',
                AccountId = theAccounts.get('客').Id,
                StageName = '_',
				CloseDate = Date.newInstance(2000,1,1)
            )
        };
        INSERT theOpps.values();
        
        Map<String, PatnerUriage__c> thePartnerCyoseis = new Map<String, PatnerUriage__c>{
            'パートナー調整' => new PatnerUriage__c(
                Syodan__c = theOpps.get('葬儀商談').Id
            )
        };
        INSERT thePartnerCyoseis.values();
        injectStub();
        endSetUp();

        Test.startTest();
        DELETE new PatnerUriage__c( Id = thePartnerCyoseis.get('パートナー調整').Id );
        Test.stopTest();
    }
}