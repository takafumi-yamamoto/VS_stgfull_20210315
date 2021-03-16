@isTest
private class TesuryoPartnerKeisanT {

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
    static void myUnitTest() {
        
		beginSetUp();

        Map<String, Account> theAccounts01 = new Map<String, Account>{
            'Customer' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                FirstName = '_', LastName = '_'
            )
        };
		INSERT theAccounts01.values();

        Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
            '1' => new Opportunity(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Obosanbin'),
                Name = '_',
                AccountId = theAccounts01.get('Customer').Id,
                StageName = '_',
                CloseDate = system.today(),
                Req_Day__c = Date.today()
            )
        };
        Insert theOpps.values();
        endSetUp();
        Test.startTest();
        Opportunity theOppVer01 = [SELECT Id, ShodanBango__c FROM Opportunity WHERE Id = :theOpps.get('1').Id ].get(0);
        theOppVer01.TesuryoPartnerForPlan__c = 10000;
        theOppVer01.TesuryoPartnerForOption__c = 10000;
        update theOppVer01;
		Test.stopTest();
    }
}