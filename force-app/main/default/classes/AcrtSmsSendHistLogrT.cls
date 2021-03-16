@isTest
public class AcrtSmsSendHistLogrT {
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
	public static void logSmsHistory() {

		beginSetUp();

		Map<String, Account> theAccounts = new Map<String, Account>{
			'客' => new Account(
				RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId(),
				FirstName = '_', LastName = '_'
			)
		};
		INSERT theAccounts.values();

		Map<String, SimpleYasugo__c> theSimpleYasugos = new Map<String, SimpleYasugo__c>{
			'シンプル安豪' => new SimpleYasugo__c()
		};
		INSERT theSimpleYasugos.values();

		Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
			'シンプル安豪' => new Opportunity(
				RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId(),
				Name = '_', StageName = '_', Pricebook2Id = Test.getStandardPricebookId(),
				CloseDate = Date.newInstance(2020,1,1),
				AccountId = theAccounts.get('客').Id,
				SimpleYasugoRef__c = theSimpleYasugos.get('シンプル安豪').Id
			)
		};
		INSERT theOpps.values();

		endSetUp();

		AcrtSmsSender.Req theAcrtSmsSenderReq = new AcrtSmsSender.Req()
			.set_telno('09012345678')
			.set_text_long('TEST')
			.set_shorten_url(true)
			.set_user_ref(null)
			.set_msg_type('SgTgAnSms')
			.set_msg_meta_data(null)
			.set_account_id(theAccounts.get('客').Id)
			.set_opp_id(theOpps.get('シンプル安豪').Id);
		AcrtSmsSender.Result theAcrtSmsSenderResult = new AcrtSmsSender.Result();
		theAcrtSmsSenderResult.delivery_id = '0123456789';
		theAcrtSmsSenderResult.send_dt = DateTime.newInstance(2021, 1, 25, 10, 8, 16);
		theAcrtSmsSenderResult.req = theAcrtSmsSenderReq;

		Test.startTest();
		AcrtSmsSendHistLogr.IAcrtSmsSendHistLogr mIAcrtSmsSendHistLogr = AcrtSmsSendHistLogr.get_IAcrtSmsSendHistLogr_instance();
		mIAcrtSmsSendHistLogr.logSmsHistory(theAcrtSmsSenderResult);
		Test.stopTest();
	}
}