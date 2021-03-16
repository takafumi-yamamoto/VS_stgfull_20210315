@isTest
public class MakeSMSHaishinT {
	
	@isTest static void doTest_schedule(){
		Test.startTest();
		MakeSMSHaishin scheduler = new MakeSMSHaishin();
		 
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
		system.schedule('Test_MakeSMSHaishinMemberToroku' + year + month + day + hour + minute + second, sch, scheduler);

		system.debug('バッチ名 : ' + 'Test_MakeSMSHaishinMemberToroku' + year + month + day + hour + minute + second);
		Test.stopTest();
	}

	@isTest static void doTest_Bat1(){
	
		Database.SaveResult NewAcc = NewAccDate('受け取る',false,false);
		Database.SaveResult NewOpp = NewOppDate(NewAcc,'問合せ受付');
		UpSimpleDate(NewOpp,null,'未案内');
		NewMarkeSMSDate(NewAcc,NewOpp);
		
		Test.startTest();
		MockAccreteSmsApi mock = new MockAccreteSmsApi();
		mock.setStatusCodeSmsReg(200);
		Test.setMock(HttpCalloutMock.class, mock);
		MakeSMSHaishin batchable = new MakeSMSHaishin();
		Database.executeBatch(batchable);
		Test.stopTest();
	}

	@isTest static void doTest_Bat2(){
	
		Database.SaveResult NewAcc = NewAccDate('受け取る',false,false);
		Database.SaveResult NewOpp = NewOppDate(NewAcc,'事前準備処理中');
		UpSimpleDate(NewOpp,null,'未案内');
		NewMarkeSMSDate(NewAcc,NewOpp);
		
		Test.startTest();
		MockAccreteSmsApi mock = new MockAccreteSmsApi();
		mock.setStatusCodeSmsReg(200);
		Test.setMock(HttpCalloutMock.class, mock);
		MakeSMSHaishin batchable = new MakeSMSHaishin();
		Database.executeBatch(batchable);
		Test.stopTest();
	}

	@isTest static void doTest_Bat3(){
	
		Database.SaveResult NewAcc = NewAccDate('受け取らない',false,false);
		Database.SaveResult NewOpp = NewOppDate(NewAcc,'問合せ受付');
		UpSimpleDate(NewOpp,null,'未案内');
		NewMarkeSMSDate(NewAcc,NewOpp);
		
		Test.startTest();
		MockAccreteSmsApi mock = new MockAccreteSmsApi();
		mock.setStatusCodeSmsReg(200);
		Test.setMock(HttpCalloutMock.class, mock);
		MakeSMSHaishin batchable = new MakeSMSHaishin();
		Database.executeBatch(batchable);
		Test.stopTest();
	}

	@isTest static void doTest_Bat4(){
	
		Database.SaveResult NewAcc = NewAccDate('受け取る',True,false);
		Database.SaveResult NewOpp = NewOppDate(NewAcc,'問合せ受付');
		UpSimpleDate(NewOpp,null,'未案内');
		NewMarkeSMSDate(NewAcc,NewOpp);
		
		Test.startTest();
		MockAccreteSmsApi mock = new MockAccreteSmsApi();
		mock.setStatusCodeSmsReg(200);
		Test.setMock(HttpCalloutMock.class, mock);
		MakeSMSHaishin batchable = new MakeSMSHaishin();
		Database.executeBatch(batchable);
		Test.stopTest();
	}

	@isTest static void doTest_Bat5(){
	
		Database.SaveResult NewAcc = NewAccDate('受け取る',false,True);
		Database.SaveResult NewOpp = NewOppDate(NewAcc,'問合せ受付');
		UpSimpleDate(NewOpp,null,'未案内');
		NewMarkeSMSDate(NewAcc,NewOpp);
		
		Test.startTest();
		MockAccreteSmsApi mock = new MockAccreteSmsApi();
		mock.setStatusCodeSmsReg(200);
		Test.setMock(HttpCalloutMock.class, mock);
		MakeSMSHaishin batchable = new MakeSMSHaishin();
		Database.executeBatch(batchable);
		Test.stopTest();
	}

	@isTest static void doTest_Bat6(){
	
		Database.SaveResult NewAcc = NewAccDate('受け取る',false,false);
		Database.SaveResult NewOpp = NewOppDate(NewAcc,'問合せ受付');
		UpSimpleDate(NewOpp,Date.today(),'未案内');
		NewMarkeSMSDate(NewAcc,NewOpp);
		
		Test.startTest();
		MockAccreteSmsApi mock = new MockAccreteSmsApi();
		mock.setStatusCodeSmsReg(200);
		Test.setMock(HttpCalloutMock.class, mock);
		MakeSMSHaishin batchable = new MakeSMSHaishin();
		Database.executeBatch(batchable);
		Test.stopTest();
	}

	@isTest static void doTest_Bat7(){
	
		Database.SaveResult NewAcc = NewAccDate('受け取る',false,false);
		Database.SaveResult NewOpp = NewOppDate(NewAcc,'問合せ受付');
		UpSimpleDate(NewOpp,Null,'受領');
		NewMarkeSMSDate(NewAcc,NewOpp);
		
		Test.startTest();
		MockAccreteSmsApi mock = new MockAccreteSmsApi();
		mock.setStatusCodeSmsReg(200);
		Test.setMock(HttpCalloutMock.class, mock);
		MakeSMSHaishin batchable = new MakeSMSHaishin();
		Database.executeBatch(batchable);
		Test.stopTest();
	}

	private static Database.SaveResult NewAccDate(String PermissionFlag, Boolean KoukokuSmsNg, Boolean JizenJizenSheet) {
		//取引先の「お客様」データ作成
		Account acc = new Account(
			LastName ='TEST',
			FirstName ='xxxdefualt',
			PermissionFlag__pc = PermissionFlag,
			KoukokuSmsNg__c = KoukokuSmsNg,
			MemberTourokuZumi__c = TRUE,
			JizenJizenSheetTeishutsuzumi__c = JizenJizenSheet,
			MailAddress__c = 'mail@yoriso.com',
			YusenMailAddressKubun__c = 'メールアドレス1',
			MobilePhone__c ='080-0000-0001',
			RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId()
		);
		Database.SaveResult lsracc = Database.insert(acc);
		return lsracc;
	}

	private static Database.SaveResult NewOppDate(Database.SaveResult lsracc, String StrStageName) {

		//取引商談のデータ作成
		opportunity torihikiopp = new opportunity(
			AccountId = lsracc.getId(),
			RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('TorihikiShodan').getRecordTypeId(),
			IsPrivate = FALSE,
			CloseDate = Date.today(),
			Name = 'xxxdefualt',
			StageName = StrStageName
		);
		Database.SaveResult lsrtorihikiopp = Database.insert(torihikiopp);
		
		Date DateNow = Date.today();
		Date InDate = DateNow.addDays(-5);
		Time FromTime = Time.newInstance(7, 0, 0, 0);
		DateTime InDateTime = DateTime.newInstance(InDate, FromTime);

		//商談のデータ作成
		opportunity opp1 = new opportunity(
			AccountId = lsracc.getId(),
			RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId(),
			Name = 'xxxdefualt',
			StageName = StrStageName,
			SubPhase__c = '3分コール接続待',
			TaishoushaJokyo__c = '健在', 
			CloseDate = Date.today(),
			Req_Day__c = InDateTime
		);

		Database.SaveResult lsropp = Database.insert(opp1);

		return lsropp;
	}
		
	private static void UpSimpleDate(Database.SaveResult lsropp, Date PCDate ,String JizenJunbiSheet) {
		//シンプル安豪のデータ更新
		Opportunity opp2 = [SELECT Id , SimpleYasugoRef__c FROM Opportunity WHERE Id = :lsropp.getId() limit 1];

		SimpleYasugo__c SimpleYasugo = new SimpleYasugo__c(
			Id = opp2.SimpleYasugoRef__c,
			PreliminaryConsultationDate__c = PCDate,
			JizenJunbiSheetGoannaiJokyo__c = JizenJunbiSheet
		);

		update SimpleYasugo;

	}

	private static void NewMarkeSMSDate(Database.SaveResult lsracc,Database.SaveResult lsropp) {
		insert new MarkeSMSDeliveryMember__c(
			Account__c = lsracc.getId(),
			AccountID__c = lsracc.getId(),
			Opportunity__c = lsropp.getId(),
			SmsSendCellphoneNumber__c = '08000000001',
			SmsSendSchedule__c = Date.today(),
			SmsSendStatus__c = '未送信'
		);
	}

}