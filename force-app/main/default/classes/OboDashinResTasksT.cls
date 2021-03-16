@isTest
private class OboDashinResTasksT {

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

	@isTest static void doTest() {
		setUp();

        Map<String,Account> theAccounts = new Map<String, Account>{
            'Customer' => new Account( 
                RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId(),
                FirstName = '_', LastName = '_'
                )
        };
        Insert theAccounts.values();

        Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
            'ObouOpp' => new Opportunity(
                AccountId = theAccounts.get('Customer').Id, Name = '_',
                StageName = '_', CloseDate = Date.Today(),
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Obosanbin')
            )
        };
        Insert theOpps.values();

        Map<String, Obosanbin__c> theObous = new Map<String,Obosanbin__c>{};
		for(Opportunity aOpp : [ SELECT Id, ObosanbinRef__c FROM Opportunity WHERE Id = :theOpps.get('ObouOpp').Id LIMIT 1 ]){
			theObous.put( 'Obosanbin',
				[SELECT Id FROM Obosanbin__c WHERE Id = :aOpp.ObosanbinRef__c LIMIT 1].get(0)
			);
		}
	}
	
}