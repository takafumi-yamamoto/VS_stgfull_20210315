@isTest
public class AcrtSmsSendErrHistLogrT {
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
	@isTest
	public static void updateLogSmsHistory() {

		beginSetUp();

		Map<String, AcrtDrTack__c> theAcrtDrTack = new Map<String, AcrtDrTack__c>{
			'AcrtDrTack1' => new AcrtDrTack__c(
				delivery_id__c = '2651276389'
			)
		};
		INSERT theAcrtDrTack.values();

		Map<String, SMSHistory__c> theSMSHistory = new Map<String, SMSHistory__c>{
			'SMSHistory1' => new SMSHistory__c(
				RecordTypeId = Schema.SObjectType.SMSHistory__c.getRecordTypeInfosByDeveloperName().get('DLR').getRecordTypeId(),
				MessageId__c = '2651276389',
				Provider__c = 'accrete',
				StatusId__c ='2'
			)
		};
		INSERT theSMSHistory.values();

		endSetUp();

		Test.startTest();
		AcrtSmsSendErrHistLogr.IErrHistoryLogr mIErrHistoryLogr = AcrtSmsSendErrHistLogr.get_IErrHistoryLogr_instance();
		mIErrHistoryLogr.updateLogSmsHistory(theAcrtDrTack.get('AcrtDrTack1').Id);
		Test.stopTest();
	}
}