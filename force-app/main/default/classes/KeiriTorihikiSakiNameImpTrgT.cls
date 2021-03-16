@isTest
private class KeiriTorihikiSakiNameImpTrgT {
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

	@isTest static void update_last_sync_version(){
        beginSetUp();
        
        Map<String,Account> theAccounts = new Map<String, Account>{
            '1' => new Account( 
                RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('SoryoAccount').getRecordTypeId(),
                Name = '_', Seinengappi__c = Date.newInstance(1980,1,1), MobilePhone__c = '080-0000-0001'
                )
        };
        Insert theAccounts.values();

        endSetUp();
        Test.startTest();
        
        String accId = theAccounts.get('1').Id;
        String TorihikiSakiBango = [select TorihikiSakiBango__c from account where Id=:accId].TorihikiSakiBango__c;
        Map<String,KeiriTorihikiSakiNameImp__c> theKeiriTorihikiSakiNameImps = new Map<String, KeiriTorihikiSakiNameImp__c>{
            '1' => new KeiriTorihikiSakiNameImp__c( 
                TorihikiSakiBango__c = TorihikiSakiBango,
                KeiriTorihikiSakiName__c = 'update-eiriTorihikiSakiName'
                )
        };
        Insert theKeiriTorihikiSakiNameImps.values();


		Test.stopTest();

	}
}