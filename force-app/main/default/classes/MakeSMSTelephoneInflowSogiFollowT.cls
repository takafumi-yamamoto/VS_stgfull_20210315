@isTest
public class MakeSMSTelephoneInflowSogiFollowT {

    @isTest static void doTest_schedule(){
        Test.startTest();
        MakeSMSTelephoneInflowSogiFollow scheduler = new MakeSMSTelephoneInflowSogiFollow();
		 
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
		system.schedule('Test_MakeSMSTelephoneInflowSogiFollow' + year + month + day + hour + minute + second, sch, scheduler);

		system.debug('バッチ名 : ' + 'Test_MakeSMSHaishinMemberToroku' + year + month + day + hour + minute + second);
        Test.stopTest();
    }

    @isTest static void doTest_Bat1(){
        Test.startTest();
        Database.SaveResult NewAcc = NewAccDate('xxxdefualt','mail@yoriso.com','080-0000-0001');
        Database.SaveResult NewOpp = NewOppSMSDate(NewAcc,'フォロー','0',-1);
        MakeSMSTelephoneInflowSogiFollow batchable = new MakeSMSTelephoneInflowSogiFollow();
        Database.executeBatch(batchable);
        Test.stopTest();
    }

    @isTest static void doTest_Bat2(){
        Test.startTest();
        Database.SaveResult NewAcc = NewAccDate('xxxdefualt','mail@yoriso.com','080-0000-0001');
        Database.SaveResult NewOpp = NewOppSMSDate(NewAcc,'フォロー','0',-5);
        MakeSMSTelephoneInflowSogiFollow batchable = new MakeSMSTelephoneInflowSogiFollow();
        Database.executeBatch(batchable);
        Test.stopTest();
    }

    private static Database.SaveResult NewAccDate(String StrFirstName, String StrMailAddress, String StrMobilePhone){
        Account acc = new Account(
			LastName ='TEST',
			FirstName =StrFirstName,
            PermissionFlag__pc = '受け取る',
            Tel_Sogifollow_SmsPermission__c = True,
			MemberTourokuZumi__c = True,
            JizenJizenSheetTeishutsuzumi__c = false,
            KoukokuSmsNg__c = false,
			MailAddress__c = StrMailAddress,
			YusenMailAddressKubun__c = 'メールアドレス1',
			MobilePhone__c =StrMobilePhone,
			RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account', 'null')
		);
        Database.SaveResult lsracc = Database.insert(acc);
        return lsracc;
    }


    private static Database.SaveResult NewOppSMSDate(Database.SaveResult lsracc, String StrStageName , String phase, Integer sofudays) {
		
		Date DateNow = Date.today();
		Date InDate = DateNow.addDays(-5);
		Time FromTime = Time.newInstance(7, 0, 0, 0);
        DateTime InDateTime = DateTime.newInstance(InDate, FromTime);
        
        SimpleYasugo__c simpleobj = new SimpleYasugo__c (
            JizenJunbiSheetGoannaiJokyo__c = null
        );
        Database.SaveResult srobj = Database.insert(simpleobj);

        Case newCase = new Case(
            RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SimpleYasugoOtoiawase').getRecordTypeId(),
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

		//商談のデータ作成
		opportunity opp1 = new opportunity(
			AccountId = lsracc.getId(),
            RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId(),
            CaseRef__c = lsrCase.getId(),
			Name = 'xxxdefualt',
			StageName = StrStageName,
			SubPhase__c = '',
			TaishoushaJokyo__c = '健在', 
            CloseDate = Date.today(),
            SimpleYasugoRef__c = srobj.getId(),
			Req_Day__c = InDateTime
		);

        Database.SaveResult lsropp = Database.insert(opp1);

        addShiryosofuData(lsropp,sofudays);
        
		return lsropp;
    }

    private static void addShiryosofuData(Database.SaveResult lsropp,Integer sofudays){
        Date sofuday = Date.today();
        sofuday = sofuday.addDays(sofudays);

        SogiShiryoSofu__c sobj = new SogiShiryoSofu__c(
			OpportunityRef__c = lsropp.getid(),										// 商談
			SofuJokyo__c = '送付済',												// 送付状況
			SofuShubetsu__c = '郵便',												// 送付種別
			YusoShubetsu__c = '',												// 郵送種別
			Atena__c = 'AAAA',														// 宛名
			PostalCode__c = '141-0031',												// 郵便番号
			State__c = '東京都',													// 都道府県
			City__c = '品川区',														// 市区郡
			Street__c = '西五反田',													// 町名・番地
			InsatsubutsuIchiran__c = '送付状;斎場資料;提案書;事前割証書',		// 印刷物一覧
			PamphletYohi__c = '要',													// パンフレット要否
			SofuNichiji__c = Datetime.newInstance(sofuday, Time.newInstance(0, 0, 0, 0)),				// 送付日時
			TaSofubutsu1__c = 'ベス仏カタログ',										// 他送付物1
			IsogiTaio__c = true,													// 急ぎ対応
			SofuShiryoURL__c = '',
            HikitsugiJiko__c = 'あいうえお',										//引継事項
            KasoshikiyoMongon__c = false,                                          // 火葬式文言
			InsatsuNichiji__c = Datetime.valueOf('2020-06-30 20:04:00')				// 印刷日時
		);
        Database.SaveResult lsrsobj = Database.insert(sobj);
    }
}