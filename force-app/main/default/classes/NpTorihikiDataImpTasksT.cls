@isTest
public class NpTorihikiDataImpTasksT {

    private static void setUp(){
        Insert new TriggerIsActive__c( name='default', isActive__c=true );
        Insert new JizenWariPlan__c( Code__c='Yoriso' );
        Insert new List<LoggingsConfig__c>{
            new LoggingsConfig__c(
                name='dev', LevelsToWrite__c='Error, Warn, Info', WriteLogAttributeRecords__c=true,
                DmlStatementsLeftToStopLogging__c = 10, DmlStatementsLeftToWarn__c = 20,
                DmlRowsLeftToStopLogging__c = 100, DmlRowsLeftToWarn__c = 200
                ),
            new LoggingsConfig__c(
                name='prod', LevelsToWrite__c='Error, Warn, Info', WriteLogAttributeRecords__c=true,
                DmlStatementsLeftToStopLogging__c = 10, DmlStatementsLeftToWarn__c = 20,
                DmlRowsLeftToStopLogging__c = 100, DmlRowsLeftToWarn__c = 200
                )
        };
        Insert new Account(
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId(),
            FirstName = '_', LastName = '_'
        );
    }

	@isTest
	static void doTest(){

		setUp();
		
		Map<String,Account> theAccounts = new Map<String, Account>{
			'1' => new Account(
					RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId(),
					FirstName = '_', LastName = '_'
				)
		};
		Insert theAccounts.values();

        Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
            '1' => new Opportunity(
                AccountId = theAccounts.get('1').Id, Name = '_',
                StageName = '_', CloseDate = Date.Today()
            )
        };
        Insert theOpps.values();

        List<Opportunity> theOppsLoaded = [
        	select Id, ShodanBango__c
        	from Opportunity
        	where Id = :theOpps.get('1').Id
        	limit 1
        ];

        Test.startTest();	

    	Insert new NpTorihikiDataImpTask__c(
    			NpStatus__c = '審査OK',
    			KameitenTorihikiId__c = theOppsLoaded.get(0).ShodanBango__c,
    			NpTorihikiId__c = '_',
    			TorihikiKingaku__c = 1000,
    			ShoriStatus__c = 'Created'
    		);
        Test.stopTest();

	}
}