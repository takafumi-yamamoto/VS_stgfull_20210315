@isTest
public class MakeSMSHaishinMemberTorokuT {
	
	@isTest static void doTest_schedule(){
		Test.startTest();
		MakeSMSHaishinMemberToroku scheduler = new MakeSMSHaishinMemberToroku();
		 
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
		Database.SaveResult NewAcc = NewAccDate('xxxdefualt','mail@yoriso.com','080-0000-0001');
		Database.SaveResult NewCase = NewCaseDate(NewAcc);
		Database.SaveResult NewOpp = NewOppDate(NewAcc,NewCase);
		UpSimpleDate(NewOpp);

		Test.startTest();
		MakeSMSHaishinMemberToroku batchable = new MakeSMSHaishinMemberToroku();
		Database.executeBatch(batchable);
		Test.stopTest();
	}

	@isTest static void doTest_Bat2(){
		Database.SaveResult NewAcc = NewAccDate('xxxdefualt','mail@yoriso.com','080-0000-0001');
		Database.SaveResult NewCase = NewCaseDate(NewAcc);
		Database.SaveResult NewOpp = NewOppDate(NewAcc,NewCase);
		UpSimpleDate(NewOpp);
		NewMarkeSMSDate(NewAcc,NewOpp);

		Database.SaveResult NewAcc2 = NewAccDate('yyydefualt','mail2@yoriso.com','080-0000-0002');
		Database.SaveResult NewCase2 = NewCaseDate(NewAcc2);
		Database.SaveResult NewOpp2 = NewOppDate(NewAcc2,NewCase2);
		UpSimpleDate(NewOpp2);

		Test.startTest();
		MakeSMSHaishinMemberToroku batchable = new MakeSMSHaishinMemberToroku();
		Database.executeBatch(batchable);
		Test.stopTest();
	}

	private static Database.SaveResult NewAccDate(String StrFirstName, String StrMailAddress, String StrMobilePhone) {
		//取引先の「お客様」データ作成
		Account acc = new Account(
			LastName ='TEST',
			FirstName =StrFirstName,
			PermissionFlag__pc = '受け取る',
			KoukokuSmsNg__c = false,
			MemberTourokuZumi__c = TRUE,
			JizenJizenSheetTeishutsuzumi__c = false,
			MailAddress__c = StrMailAddress,
			YusenMailAddressKubun__c = 'メールアドレス1',
			MobilePhone__c =StrMobilePhone,
			RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId()
		);
		Database.SaveResult lsracc = Database.insert(acc);
		return lsracc;
	}

	private static Database.SaveResult NewCaseDate(Database.SaveResult lsracc) {
		Case newCase = new Case(
			RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SimpleYasugoShiryoSeikyuWebForm').getRecordTypeId(),
			Status = '新規',					  // 状況
			Origin = 'Web',					   // 発生チャネル
			Priority = '中',					  // 優先度
			Type = 'サービス利用',				// 問合せ種別
			Lastname__c = 'xxxdefualt',			// 相談者・担当者(姓)
			Firstname__c = 'xxxdefualt',		  // 相談者・担当者(名)
			TaishoushaJokyo__c = '健在',			 // 対象者様のご状態（初回）
			PermissionFlag__c = false,			// 初回許諾フラグ
			TelNo__c='080-0000-0001',
			KiboAreaState__c='東京都',
			KiboAreaCity__c='中央区',
			OmukaesakiZipCode__c = '141-0031',
			OmukaesakiState__c = '東京都',
			OmukaesakiCity__c = '品川区',
			OmukaesakiStreet__c = '西五反田2-11-17',
			MailAddress__c='mail@yoriso.com',
			accountid=lsracc.getId()
		);
		Database.SaveResult lsrCase = Database.insert(newCase);
		return lsrCase;
	}

	private static Database.SaveResult NewOppDate(Database.SaveResult lsracc, Database.SaveResult lsrCase) {

		//取引商談のデータ作成
		opportunity torihikiopp = new opportunity(
			AccountId = lsracc.getId(),
			RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('TorihikiShodan').getRecordTypeId(),
			IsPrivate = FALSE,
			CloseDate = Date.today(),
			Name = 'xxxdefualt',
			StageName = '問合せ受付'
		);
		Database.SaveResult lsrtorihikiopp = Database.insert(torihikiopp);
		
		Date DateNow = Date.today();
		Date InDate = DateNow.addDays(-5);
		Time FromTime = Time.newInstance(7, 0, 0, 0);
		DateTime InDateTime = DateTime.newInstance(InDate, FromTime);
		//商談のデータ作成
		opportunity opp1 = new opportunity(
			AccountId = lsracc.getId(),
			CaseRef__c = lsrCase.getId(),
			RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId(),
			Name = 'xxxdefualt',
			StageName = '問合せ受付',
			SubPhase__c = '3分コール接続待',
			TaishoushaJokyo__c = '健在', 
			CloseDate = Date.today(),
			Req_Day__c = InDateTime
		);

		Database.SaveResult lsropp = Database.insert(opp1);

		return lsropp;
	}
		
	private static void UpSimpleDate(Database.SaveResult lsropp) {

		//シンプル安豪のデータ更新
		Opportunity opp2 = [SELECT Id , SimpleYasugoRef__c FROM Opportunity WHERE Id = :lsropp.getId() limit 1];

		SimpleYasugo__c SimpleYasugo = new SimpleYasugo__c(
			Id = opp2.SimpleYasugoRef__c,
			PreliminaryConsultationDate__c = null,
			JizenJunbiSheetGoannaiJokyo__c = '未案内'
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