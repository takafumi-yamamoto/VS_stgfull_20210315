@isTest
public class SgSeikyuFaxSendCatterNotificationT {
	private static void beginSetUp(){
		Utility_Common.isMimicExecAsDataIkouProfile = true;
	}
	private static void endSetUp(){
		Insert new TriggerIsActive__c( name='default', isActive__c=true );
		Insert new JizenWariPlan__c( Code__c='Yoriso' );
		Insert new Account(
			RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId(),
			FirstName = '_', LastName = '_'
		);
		Utility_Common.isMimicExecAsDataIkouProfile = false;
	}

	@isTest(SeeAllData=true)
	public static void TEST() {

		Test.startTest();

        PartnerSeikyuSendHistory__c p = new PartnerSeikyuSendHistory__c(SendRequestStatus__c = '送信依頼NG');
		insert p;

        p.SendResultStatus__c = '送信NG';
        update p;

        Test.stopTest();
	}
}