@isTest
public class KeirDenRenewBatT {
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
	@isTest static void doTest(){
		beginSetUp();
		UPSERT New KeirDenVer__c(ShodanBango__c = '1', ToBeRenewed__c = true) ShodanBango__c;
		endSetUp();
		KeirDenRenewBat.start();
	}
	@isTest static void doTest_exception(){
		beginSetUp();
		UPSERT New KeirDenVer__c(ShodanBango__c = '1', ToBeRenewed__c = true) ShodanBango__c;
		UPSERT New KeirDenVer__c(ShodanBango__c = '2', ToBeRenewed__c = true) ShodanBango__c;
		endSetUp();
		database.executebatch(new KeirDenRenewBat(), 2);
	}
}