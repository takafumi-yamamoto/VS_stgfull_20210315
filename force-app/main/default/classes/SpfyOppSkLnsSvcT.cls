@isTest public class SpfyOppSkLnsSvcT {

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
    @isTest public static void getSeikyuLines() {
        beginSetUp();

        Map<String, Account> theAccounts = new Map<String, Account>{
            '客' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                FirstName = '_', LastName = '_'
            )
        };
        INSERT theAccounts.values();

        Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
            'ベスト' => new Opportunity(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','KakuyasuButsudan'),
                Name = '_',
                AccountId = theAccounts.get('客').Id,
                StageName = '_',
                CloseDate = Date.newInstance(2000,1,1),
                Pricebook2Id = Test.getStandardPricebookId()
            )
        };
        INSERT theOpps.values();
        
        Map<String, OkyakusamaSeikyuMeisai__c> theSeikMeisais = new Map<String, OkyakusamaSeikyuMeisai__c>{
			'1' =>new OkyakusamaSeikyuMeisai__c(
            SeikyuKingaku__c = 1000,
            ServiceSyubetsu__c = 'ベスト仏壇',
            OpportunityRef__c = theOpps.get('ベスト').Id,
            SeikyuHouhou__c = '_'
        	)
		};
        INSERT theSeikMeisais.values();
        endSetUp();

        Test.startTest();
        SpfyOppSkLnsSvc.getSeikyuLines( theOpps.get('ベスト').Id );
        Test.stopTest();
    }
}