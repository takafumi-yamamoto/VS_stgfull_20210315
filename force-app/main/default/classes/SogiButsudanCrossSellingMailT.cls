@isTest
public class SogiButsudanCrossSellingMailT {

	@isTest public static void TEST1(){

		beginSetUp();
		Campaign sCampaign = new Campaign(
			Name = 'Marketo_SM_MP_No01_sougi_butudan',
			IsActive = true,
			Status = '進行中',
			Type = 'メールマーケティング'
		);
		Database.SaveResult CampaignMarketoStepMail = Database.insert(sCampaign);

		MarketoManagement__c sMarketoManagement = new MarketoManagement__c(
			MarketoName__c = 'SogiButsudanCrossSellingMail',
			MarketoClassName__c = 'SogiButsudanCrossSellingMail',
			Campaign__c = CampaignMarketoStepMail.getId(),
			MarketoFlg__c = false,
			TESTMarketoFlg__c = false
		);
		insert sMarketoManagement;

		dataCreate();
		endSetUp();

		Test.startTest();
		SogiButsudanCrossSellingMail scheduler = new SogiButsudanCrossSellingMail();
		 
		// 実行日付を設定する
		Datetime scheduleDate = Datetime.now().addSeconds(10);
		String year = String.valueOf(scheduleDate.year());      // 年
		String month = String.valueOf(scheduleDate.month());    // 月
		String day = String.valueOf(scheduleDate.day());        // 日
		String hour = String.valueOf(scheduleDate.hour());      // 時間
		String minute = String.valueOf(scheduleDate.minute());  // 分
		String second = String.valueOf(scheduleDate.second());  // 秒
		 
		// 実行スケジュールを作成する
		String sch = second + ' ' + minute + ' ' + hour + ' ' + day + ' ' + month + ' ' + '?' + ' ' + year;
		// スケジュールを実行する(スケジュール名, スケジューラ)
		system.schedule('Test_SogiButsudanCrossSellingMail' + year + month + day + hour + minute + second, sch, scheduler);
		Test.stopTest();
	}

	@isTest public static void TEST2(){

		beginSetUp();
		Campaign sCampaign = new Campaign(
			Name = 'Marketo_SM_MP_No01_sougi_butudan',
			IsActive = true,
			Status = '進行中',
			Type = 'メールマーケティング'
		);
		Database.SaveResult CampaignMarketoStepMail = Database.insert(sCampaign);

		MarketoManagement__c sMarketoManagement = new MarketoManagement__c(
			MarketoName__c = 'Sogi',
			MarketoClassName__c = 'Sogi',
			Campaign__c = CampaignMarketoStepMail.getId(),
			MarketoFlg__c = false,
			TESTMarketoFlg__c = false
		);
		insert sMarketoManagement;

		dataCreate();
		endSetUp();

		Test.startTest();
		SogiButsudanCrossSellingMail scheduler = new SogiButsudanCrossSellingMail();
		 
		// 実行日付を設定する
		Datetime scheduleDate = Datetime.now().addSeconds(10);
		String year = String.valueOf(scheduleDate.year());      // 年
		String month = String.valueOf(scheduleDate.month());    // 月
		String day = String.valueOf(scheduleDate.day());        // 日
		String hour = String.valueOf(scheduleDate.hour());      // 時間
		String minute = String.valueOf(scheduleDate.minute());  // 分
		String second = String.valueOf(scheduleDate.second());  // 秒
		 
		// 実行スケジュールを作成する
		String sch = second + ' ' + minute + ' ' + hour + ' ' + day + ' ' + month + ' ' + '?' + ' ' + year;
		// スケジュールを実行する(スケジュール名, スケジューラ)
		system.schedule('Test_SogiButsudanCrossSellingMail' + year + month + day + hour + minute + second, sch, scheduler);
		Test.stopTest();
	}

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

	private static void dataCreate(){

		Map<String, Account> theAccounts = new Map<String, Account>{
			'客' => new Account(
				RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId(),
				FirstName = '_', LastName = '_',
				PermissionFlag__pc = '受け取る',
				E_NG__pc = False,
				MailAddress__c = 'TEST@yoriso.com'
			)
		};
		INSERT theAccounts.values();

		Map<String, SimpleYasugo__c> theSimpleYasugos = new Map<String, SimpleYasugo__c>{
			'葬儀' => new SimpleYasugo__c()
		};
		INSERT theSimpleYasugos.values();

		Date DateNow = Date.today();
		Date ChkDate = DateNow.addDays(-12);
		Time FromTime = Time.newInstance(0, 0, 0, 0);
		DateTime ChkFromdt = DateTime.newInstance(ChkDate, FromTime);

		Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
			'葬儀' => new Opportunity(
				RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId(),
				Name = '_',
				AccountId = theAccounts.get('客').Id,
				StageName = '_',
				CloseDate = Date.newInstance(2000,1,1),
				SimpleYasugoRef__c = theSimpleYasugos.get('葬儀').Id,
				Req_Day__c = ChkFromdt
			)
		};
		Insert theOpps.values();
	}
}