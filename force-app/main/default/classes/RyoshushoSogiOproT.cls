@isTest
public class RyoshushoSogiOproT {

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

	@isTest 
	public static void DocRecordCreation_print(){
		beginSetUp();
        Map<String, Account> theAccounts = new Map<String, Account>{
            '客' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                FirstName = '_', LastName = '_'
            )
        };
		INSERT theAccounts.values();
		endSetUp();

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
				Req_Day__c = Datetime.newInstance(2000,1,1,0,0,0),
				CloseDate = Date.newInstance(2000,1,1),
                SimpleYasugoRef__c = theSimpleYasugos.get('葬儀').Id
            )
        };
        INSERT theOpps.values();

		Map<String, OkyakusamaSeikyuMeisai__c> theSeikMeisais = new Map<String, OkyakusamaSeikyuMeisai__c>{
			'furikomi' =>new OkyakusamaSeikyuMeisai__c(
                ServiceSyubetsu__c = 'シンプル安豪',
                SeikyuKingaku__c = 1000,
                OpportunityRef__c = theOpps.get('葬儀').Id,
                SeikyuHouhou__c = 'furikomi',
                Kessaibi__c = Date.today()
            ),
			'orico_credit' =>new OkyakusamaSeikyuMeisai__c(
                ServiceSyubetsu__c = 'シンプル安豪',
                SeikyuKingaku__c = 1000,
                OpportunityRef__c = theOpps.get('葬儀').Id,
                SeikyuHouhou__c = 'orico_credit',
                Kessaibi__c = Date.today()
            ),
			'orico_loan' =>new OkyakusamaSeikyuMeisai__c(
                ServiceSyubetsu__c = 'シンプル安豪',
                SeikyuKingaku__c = 1000,
                OpportunityRef__c = theOpps.get('葬儀').Id,
                SeikyuHouhou__c = 'orico_loan',
                Kessaibi__c = Date.today()
            )
		};
        INSERT theSeikMeisais.values();
        
		Test.startTest();
		new RyoshushoSogiOpro.DocRecordCreation().print( theOpps.get('葬儀').Id );
		Test.stopTest();
	}
}