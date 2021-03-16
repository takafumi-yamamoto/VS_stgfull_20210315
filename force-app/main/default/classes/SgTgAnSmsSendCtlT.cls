@isTest
public class SgTgAnSmsSendCtlT {
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
	private class SgTgAnSms_Stub implements SgTgAnSms.IMessageCreater{
		public String createMsg(String p_opp_id){return null;}
	}
	public class AcrtSmsSenderClient_Stub implements AcrtSmsSender.IClient{
		public AcrtSmsSender.Result sendSms(AcrtSmsSender.Req pReq){return null;}
	}

	private class IAcrtDrTackRegister_Stub implements AcrtDrTackRegister.IRegister{
		public void InsertEntry(AcrtSmsSender.Result pAcrtSmsSenderResult){return;}
		public void InsertEntrries( List<AcrtSmsSender.Result> pAcrtSmsSenderResults){return;}
	}

	private class IAcrtSmsSendHistLogr_Stub implements AcrtSmsSendHistLogr.IAcrtSmsSendHistLogr{
		public void logSmsHistory(AcrtSmsSender.Result pAcrtSmsSenderResult){return;}
	}

	@isTest
	public static void TEST() {

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

		SgTgAnSmsSendCtl.mSgTgAnSms = new SgTgAnSms_Stub();
		SgTgAnSmsSendCtl.mAcrtSmsSenderClient = new AcrtSmsSenderClient_Stub();
		SgTgAnSmsSendCtl.mIAcrtDrTackRegister = new IAcrtDrTackRegister_Stub();
		SgTgAnSmsSendCtl.mIAcrtSmsSendHistLogr = new IAcrtSmsSendHistLogr_Stub();

		endSetUp();

		SgTgAnSmsSendCtl.SendReq theReq = new SgTgAnSmsSendCtl.SendReq();
		theReq.opp_id = theOpps.get('シンプル安豪').Id;
		theReq.account_id = theAccounts.get('客').Id;
		theReq.theTelno = '09012345678';
		theReq.theMsg = 'TEST';

		Opportunity opp = [select Id from Opportunity where Id = :theOpps.get('シンプル安豪').Id];
		
		PageReference pr = Page.SgTgAnSmsSend;
		Test.setCurrentPage(pr);
		Test.startTest();
		ApexPages.StandardController stdOpp = new ApexPages.StandardController(opp);
		SgTgAnSmsSendCtl theSgTgAnSmsSendCtl = new SgTgAnSmsSendCtl(stdOpp);
		theSgTgAnSmsSendCtl.init();
		theSgTgAnSmsSendCtl.cancel();
		PageReference pageRef = theSgTgAnSmsSendCtl.submit();
		theSgTgAnSmsSendCtl.TelNo = '0901234abcd';
		PageReference pageRef2 = theSgTgAnSmsSendCtl.submit();
		theSgTgAnSmsSendCtl.TelNo = '09012345678';
		PageReference pageRef3 = theSgTgAnSmsSendCtl.submit();
		SgTgAnSmsSendCtl.SendRes theRes = theSgTgAnSmsSendCtl.send(theReq);
		Test.stopTest();
	}
}