@isTest
public class KeirDenSyncVerImpTrgT {
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
		UPSERT new OboKeirDen__c(
			RenkeiShoriKbn__c = '通常', ShodanBango__c = 'OPP-01', 
			LastVersion__c = '1', LastSyncVersion__c = '0'
		) ShodanBango__c;
        endSetUp();

		Test.startTest();
		INSERT New KeirDenSyncVerImp__c( ShodanBango__c = 'OPP-01', LastVersion__c = '1');
		Test.stopTest();

		OboKeirDen__c actual_Denpyo = [SELECT Id, LastSyncVersion__c FROM OboKeirDen__c WHERE ShodanBango__c = 'OPP-01'].get(0);
		System.assertEquals('1', actual_Denpyo.LastSyncVersion__c);
	}
}