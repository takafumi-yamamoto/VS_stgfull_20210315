@isTest
public class SogiSmsFollowEffectMeasurementT {

    private static void beginSetUp(){
        Insert new TriggerIsActive__c( name='default', isActive__c=true );
    }

    private static Database.SaveResult setUp( Boolean onSmsData ){
        Account acc = new Account(
			LastName ='TEST',
			FirstName ='TESTFIRSTNAME',
            PermissionFlag__pc = '受け取る',
            Tel_Sogifollow_SmsPermission__c = True,
			MemberTourokuZumi__c = False,
            JizenJizenSheetTeishutsuzumi__c = false,
            KoukokuSmsNg__c = false,
			MailAddress__c = 'test@yoriso.com',
			YusenMailAddressKubun__c = 'メールアドレス1',
			MobilePhone__c ='090-1111-2222',
			RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account', 'null')
        );

        Database.SaveResult lsracc = Database.insert(acc);

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
			StageName = 'フォロー',
			SubPhase__c = '',
			TaishoushaJokyo__c = '健在', 
            CloseDate = Date.today(),
            SimpleYasugoRef__c = srobj.getId(),
			Req_Day__c = InDateTime
        );
        
        Database.SaveResult lsropp = Database.insert(opp1);

        if(onSmsData){
            Date DateToday = Date.today();
            Date sendData5days = DateToday.addDays(-5);
            TelSogiFollowSMSDeliveryMember__c sobj1 = new TelSogiFollowSMSDeliveryMember__c (
                Tel_SendSogiSmsStatus__c = '送信OK',
                Tel_SendSogiSmsResultMessage__c = '',
                Tel_SendSogiSmsNumber__c = '09011112222',
                Tel_SendSogiSmsDatetime__c = Datetime.newInstance(sendData5days, Time.newInstance(0, 0, 0, 0)),
                Tel_SendSogiSmsSchedule__c = sendData5days,
                Account__c = lsracc.getId(),
                Opportunity__c = lsropp.getId(),
                AccountID__c = lsracc.getId(),
                Tel_SendSogiSmsPhase__c = '0',
                Tel_SendSogiSmsYorisoMemberDay__c = null,
                Tel_SendSogiSmsMessage__c = null
            );
            Database.SaveResult lsrsobj1 = Database.insert(sobj1);
            Date sendData1days = DateToday.addDays(-1);
            TelSogiFollowSMSDeliveryMember__c sobj2 = new TelSogiFollowSMSDeliveryMember__c (
                Tel_SendSogiSmsStatus__c = '送信OK',
                Tel_SendSogiSmsResultMessage__c = '',
                Tel_SendSogiSmsNumber__c = '09011112222',
                Tel_SendSogiSmsDatetime__c = Datetime.newInstance(sendData1days, Time.newInstance(0, 0, 0, 0)),
                Tel_SendSogiSmsSchedule__c = sendData1days,
                Account__c = lsracc.getId(),
                Opportunity__c = lsropp.getId(),
                AccountID__c = lsracc.getId(),
                Tel_SendSogiSmsPhase__c = 'B',
                Tel_SendSogiSmsYorisoMemberDay__c = null,
                Tel_SendSogiSmsMessage__c = null
            );
            Database.SaveResult lsrsobj2 = Database.insert(sobj2);
        }

        return lsracc;
    }

    @isTest static void dotestcase1(){
        beginSetUp();
        Test.startTest();
        Database.SaveResult lsracc = setUp(true);
        Account oldRecord = [SELECT Id, MemberTourokuZumi__c from Account WHERE Id =:lsracc.getId() LIMIT 1 ];
        UPDATE new Account (
            Id = oldRecord.Id,
            MemberTourokuZumi__c = true
        );
        List<TelSogiFollowSMSDeliveryMember__c> listName = [SELECT Id , Name,Tel_SendSogiSmsYorisoMemberDay__c,Tel_SendSogiSmsDatetime__c FROM TelSogiFollowSMSDeliveryMember__c order by Tel_SendSogiSmsDatetime__c desc LIMIT 1];
        Test.stopTest();
        System.debug(listName.get(0).Tel_SendSogiSmsYorisoMemberDay__c);
        System.assert(listName.get(0).Tel_SendSogiSmsYorisoMemberDay__c != null , '最新日付が更新されていること。');
    }

    @isTest static void dotestcase2(){
        beginSetUp();
        Test.startTest();
        Database.SaveResult lsracc = setUp(false);
        Account oldRecord = [SELECT Id, MemberTourokuZumi__c from Account WHERE Id =:lsracc.getId() LIMIT 1 ];
        UPDATE new Account (
            Id = oldRecord.Id,
            MemberTourokuZumi__c = true
        );
        List<TelSogiFollowSMSDeliveryMember__c> listName = [SELECT Id , Name,Tel_SendSogiSmsYorisoMemberDay__c,Tel_SendSogiSmsDatetime__c FROM TelSogiFollowSMSDeliveryMember__c order by Tel_SendSogiSmsDatetime__c desc LIMIT 1];
        Test.stopTest();
        if(listName.size() > 0){
            System.assert(false,'意図しないデータ更新されている。');
        }
    }

    @isTest static void dotestcase3(){
        beginSetUp();
        Test.startTest();
        Database.SaveResult lsracc = setUp(true);
        Account oldRecord = [SELECT Id, MemberTourokuZumi__c from Account WHERE Id =:lsracc.getId() LIMIT 1 ];
        UPDATE new Account (
            Id = oldRecord.Id,
            JizenJizenSheetTeishutsuzumi__c = true
        );
        List<TelSogiFollowSMSDeliveryMember__c> listName = [SELECT Id , Name,Tel_SendSogiSmsYorisoMemberDay__c,Tel_SendSogiSmsDatetime__c FROM TelSogiFollowSMSDeliveryMember__c order by Tel_SendSogiSmsDatetime__c desc LIMIT 1];
        Test.stopTest();
        System.debug(listName.get(0).Tel_SendSogiSmsYorisoMemberDay__c);
        System.assert(listName.get(0).Tel_SendSogiSmsYorisoMemberDay__c != null , '最新日付が更新されていること。');
    }
}