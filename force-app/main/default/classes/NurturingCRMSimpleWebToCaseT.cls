@isTest
public class NurturingCRMSimpleWebToCaseT {

	@isTest static void doTest(){
		id defualtAccountRT = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId();
		Account dacc=new Account();
		dacc.LastName='xxxdefualt';
		dacc.Phone='088-0000-0001';
		dacc.MobilePhone__c='888-0000-0001';
		dacc.recordTypeId = defualtAccountRT;
		Database.SaveResult lsracc = Database.insert(dacc);

		List<Case> TESTListCase = new List<Case>();
		Opportunity OPP = new Opportunity(
			AccountId = lsracc.getid(),				// お客様・提携先名
			Name = '新規_シンプル安豪',						  // 商談名
			CloseDate = Date.valueOf('2020-06-18'),		 // 完了予定日
			Probability = 0,								// 確度(%)
			StageName = '問合せ受付',							// フェーズ
			TesuryoKeisanzumi__c = false,				   // 手数料計算済
			SurveySendWayHopeSms__c = false,				// アンケートSMS送信希望
			SurveySendWayHopeEmail__c = false,			  // アンケートMail送信希望
			RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId()
		);

		id TESTRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SimpleYasugoJizenJunbiWebForm').getRecordTypeId();

		List<String> Liststr = new List<String>();
		Liststr.add('すでにご逝去');
		Liststr.add('死亡');
		Liststr.add('危篤');
		Liststr.add('余命宣告');
		Liststr.add('入院中');
		Liststr.add('通院中');
		Liststr.add('健在');
		Liststr.add('未聴取により不明');

		String strLastname = '';
		String strFirstname = '';
		Integer nameInt = 0;

		for(String str :Liststr){

			strLastname = 'テスト' + String.valueOf(nameInt);
			strFirstname = 'テスト '+ String.valueOf(nameInt);

			Case sobj = new Case(
				Status = '新規',					  // 状況
				Origin = 'Web',					   // 発生チャネル
				Priority = '中',					  // 優先度
				Type = 'サービス利用',				// 問合せ種別
				Lastname__c = 'xxxdefualt',			// 相談者・担当者(姓)
				Firstname__c = strFirstname,		  // 相談者・担当者(名)
				TaishoushaJokyo__c = str,			 // 対象者様のご状態（初回）
				PermissionFlag__c = false,			// 初回許諾フラグ
				TelNo__c='080-8888-8888',
				KiboAreaState__c='東京都',
				KiboAreaCity__c='中央区',
				MailAddress__c='test@i.ss.com',
				RecordTypeId = TESTRecordTypeId,	   //レコードタイプ
				AccountId = lsracc.getid(),
				ShiryoSoufuHoho__c = '郵送希望'
			);

			TESTListCase.add(sobj);

			nameInt = nameInt + 1;

		}

		Case Casesobj = new Case(
			Status = '新規',					  // 状況
			Origin = 'Web',					   // 発生チャネル
			Priority = '中',					  // 優先度
			Type = 'サービス利用',				// 問合せ種別
			Lastname__c = 'xxxdefualt',			// 相談者・担当者(姓)
			Firstname__c = 'テスト',		  // 相談者・担当者(名)
			TaishoushaJokyo__c = '危篤',			 // 対象者様のご状態（初回）
			PermissionFlag__c = false,			// 初回許諾フラグ
			TelNo__c='080-8888-8888',
			KiboAreaState__c='東京都',
			KiboAreaCity__c='中央区',
			MailAddress__c='test@i.ss.com',
			RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SimpleYasugoShiryoSeikyuWebForm').getRecordTypeId(),	   //レコードタイプ
			ShiryoSoufuHoho__c = '郵送希望'
		);
		
		Case Casesobj2 = new Case(
			Status = '新規',					  // 状況
			Origin = 'Web',					   // 発生チャネル
			Priority = '中',					  // 優先度
			Type = 'サービス利用',				// 問合せ種別
			Lastname__c = 'xxxdefualt',			// 相談者・担当者(姓)
			Firstname__c = 'テスト',		  // 相談者・担当者(名)
			TaishoushaJokyo__c = '危篤',			 // 対象者様のご状態（初回）
			PermissionFlag__c = false,			// 初回許諾フラグ
			MoshuTelNo__c='test@i.ss.com',
			KiboAreaState__c='東京都',
			KiboAreaCity__c='中央区',
			MailAddress__c='test@i.ss.com',
			RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SimpleYasugoShiryoSeikyuWebForm').getRecordTypeId(),	   //レコードタイプ
			ShiryoSoufuHoho__c = '郵送希望'
		);

		Test.startTest();
		Insert new TriggerIsActive__c( name='default', isActive__c=true );
		insert OPP;
		insert Casesobj;
		insert TESTListCase;
		insert Casesobj2;
		Test.stopTest();
	
	}

	@isTest static void doTest2(){

		id defualtAccountRT = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId();
		Account dacc=new Account();
		dacc.LastName='xxxdefualt';
		dacc.Phone='088-0000-0001';
		dacc.MobilePhone__c='888-0000-0001';
		dacc.recordTypeId = defualtAccountRT;


		id TESTRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SimpleYasugoShiryoSeikyuWebForm').getRecordTypeId();

		List<String> Liststr = new List<String>();
		Liststr.add('死亡');
		Liststr.add('危篤');
		Liststr.add('余命宣告');
		Liststr.add('入院中');
		Liststr.add('通院中');
		Liststr.add('健在');
		Liststr.add('未聴取により不明');

		String strLastname = '';
		String strFirstname = '';
		Integer nameInt = 0;

		List<Case> TESTListCase = new List<Case>();

		for(String str :Liststr){

			strLastname = 'テスト' + String.valueOf(nameInt);
			strFirstname = 'テスト '+ String.valueOf(nameInt);

			Case sobj = new Case(
				Status = '新規',					  // 状況
				Origin = 'Web',					   // 発生チャネル
				Priority = '中',					  // 優先度
				Type = 'サービス利用',				// 問合せ種別
				Lastname__c = 'xxxdefualt',			// 相談者・担当者(姓)
				Firstname__c = strFirstname,		  // 相談者・担当者(名)
				TaishoushaJokyo__c = str,			 // 対象者様のご状態（初回）
				PermissionFlag__c = false,			// 初回許諾フラグ
				TelNo__c='080-8888-8888',
				KiboAreaState__c='東京都',
				KiboAreaCity__c='中央区',
				MailAddress__c='test@i.ss.com',
				RecordTypeId = TESTRecordTypeId	   //レコードタイプ
			);

			TESTListCase.add(sobj);

			nameInt = nameInt + 1;

		}
		Test.startTest();
		Insert new TriggerIsActive__c( name='default', isActive__c=true );
		Database.SaveResult lsracc = Database.insert(dacc);
		
		List<Database.SaveResult> ListCase = new List<Database.SaveResult>();
		ListCase = Database.insert(TESTListCase);
		
		String whereString = ' where id = \'' + ListCase[0].getid() + '\' ';
		String strOrderByParam = ' ORDER BY Firstname__c DESC NULLS LAST';
		List<String> whereParams = new List<String>();
		whereParams.add('AAAA');
		whereParams.add('BBBB');
		whereParams.add('CCCC');
		whereParams.add('DDDD');
		whereParams.add('EEEE');
		List<Id> whereArrayable = new List<Id>();
		List<Id> whereArrayable2 = new List<Id>();
		List<List<Id>> whereArrayableParams = new List<List<Id>>();
		whereArrayable.add(ListCase[0].getid());
		whereArrayableParams.add(whereArrayable);
		whereArrayable2.add(ListCase[1].getid());
		whereArrayableParams.add(whereArrayable2);
		
		
		List<Case> returnCase = new List<Case>();
		returnCase = Dao_Case.getList(whereString,whereParams,whereArrayableParams,strOrderByParam);

		Test.stopTest();
	}

	@isTest static void doTest3(){
		id defualtAccountRT = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId();
		Account dacc=new Account();
		dacc.LastName='xxxdefualt';
		dacc.Phone='088-0000-0001';
		dacc.MobilePhone__c='888-0000-0001';
		dacc.recordTypeId = defualtAccountRT;
		Database.SaveResult lsracc = Database.insert(dacc);

		List<Case> TESTListCase = new List<Case>();
		id TESTRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SimpleYasugoJizenJunbiWebForm').getRecordTypeId();

		List<String> Liststr = new List<String>();
		Liststr.add('死亡');
		Liststr.add('危篤');
		Liststr.add('余命宣告');
		Liststr.add('入院中');
		Liststr.add('通院中');
		Liststr.add('健在');
		Liststr.add('未聴取により不明');

		String strLastname = '';
		String strFirstname = '';
		Integer nameInt = 0;

		for(String str :Liststr){

			strLastname = 'テスト' + String.valueOf(nameInt);
			strFirstname = 'テスト '+ String.valueOf(nameInt);

			Case sobj = new Case(
				Status = '新規',					  // 状況
				Origin = 'Web',					   // 発生チャネル
				Priority = '中',					  // 優先度
				Type = 'サービス利用',				// 問合せ種別
				Lastname__c = 'xxxdefualt',			// 相談者・担当者(姓)
				Firstname__c = strFirstname,		  // 相談者・担当者(名)
				TaishoushaJokyo__c = str,			 // 対象者様のご状態（初回）
				PermissionFlag__c = false,			// 初回許諾フラグ
				TelNo__c='080-8888-8888',
				KiboAreaState__c='東京都',
				KiboAreaCity__c='中央区',
				MailAddress__c='test@i.ss.com',
				RecordTypeId = TESTRecordTypeId,	   //レコードタイプ
				AccountId = lsracc.getid(),
				ShiryoSoufuHoho__c = '郵送希望',
				ObosanbinOption__c = '葬儀読経＋戒名授与'
			);

			TESTListCase.add(sobj);

			nameInt = nameInt + 1;

		}

		Test.startTest();
		Insert new TriggerIsActive__c( name='default', isActive__c=true );
		insert TESTListCase;
		Test.stopTest();
	
	}

	@isTest static void doTest4(){
		id defualtAccountRT = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId();
		Account dacc=new Account();
		dacc.LastName='xxxdefualt';
		dacc.Phone='088-0000-0001';
		dacc.MobilePhone__c='888-0000-0001';
		dacc.recordTypeId = defualtAccountRT;
		Database.SaveResult lsracc = Database.insert(dacc);

		Case Casesobj = new Case(
			Status = '新規',					  // 状況
			Origin = 'Web',					   // 発生チャネル
			Priority = '中',					  // 優先度
			Type = 'サービス利用',				// 問合せ種別
			Lastname__c = 'xxxdefualt',			// 相談者・担当者(姓)
			Firstname__c = 'テスト',		  // 相談者・担当者(名)
			TaishoushaJokyo__c = '危篤',			 // 対象者様のご状態（初回）
			PermissionFlag__c = false,			// 初回許諾フラグ
			TelNo__c='080-8888-8888',
			KiboAreaState__c='東京都',
			KiboAreaCity__c='中央区',
			MailAddress__c='test@i.ss.com',
			RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SimpleYasugoShiryoSeikyuWebForm').getRecordTypeId(),	   //レコードタイプ
			ShiryoSoufuHoho__c = '郵送希望'
		);

		Opportunity OPP = new Opportunity(
			AccountId = lsracc.getid(),				// お客様・提携先名
			Name = '新規_シンプル安豪',						  // 商談名
			CloseDate = Date.valueOf('2020-06-18'),		 // 完了予定日
			Probability = 0,								// 確度(%)
			StageName = '問合せ受付',							// フェーズ
			TesuryoKeisanzumi__c = false,				   // 手数料計算済
			SurveySendWayHopeSms__c = false,				// アンケートSMS送信希望
			SurveySendWayHopeEmail__c = false,			  // アンケートMail送信希望
			RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId()
		);

		List<Case> TESTListCase = new List<Case>();
		id TESTRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SimpleYasugoJizenJunbiWebForm').getRecordTypeId();

		String strLastname = '';
		String strFirstname = '';
		Integer nameInt = 0;

			strLastname = 'テスト' + String.valueOf(nameInt);
			strFirstname = 'テスト '+ String.valueOf(nameInt);

		Case sobj = new Case(
			Status = '新規',					  // 状況
			Origin = 'Web',					   // 発生チャネル
			Priority = '中',					  // 優先度
			Type = 'サービス利用',				// 問合せ種別
			Lastname__c = 'xxxdefualt',			// 相談者・担当者(姓)
			Firstname__c = strFirstname,		  // 相談者・担当者(名)
			TaishoushaJokyo__c = '余命宣告',			 // 対象者様のご状態（初回）
			PermissionFlag__c = false,			// 初回許諾フラグ
			TelNo__c='080-8888-8888',
			KiboAreaState__c='東京都',
			KiboAreaCity__c='中央区',
			MailAddress__c='test@i.ss.com',
			RecordTypeId = TESTRecordTypeId,	   //レコードタイプ
			AccountId = lsracc.getid(),
			ShiryoSoufuHoho__c = '郵送希望',
			ObosanbinOption__c = 'なし'
		);

		TESTListCase.add(sobj);


		Test.startTest();
		Insert new TriggerIsActive__c( name='default', isActive__c=true );
		insert OPP;
		insert TESTListCase;
		Test.stopTest();
	
	}
	@isTest static void doTest5(){
		id defualtAccountRT = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId();
		Account dacc=new Account();
		dacc.LastName='xxxdefualt';
		dacc.Phone='088-0000-0001';
		dacc.MobilePhone__c='888-0000-0001';
		dacc.recordTypeId = defualtAccountRT;
		Database.SaveResult lsracc = Database.insert(dacc);

		Opportunity OPP = new Opportunity(
			AccountId = lsracc.getid(),				// お客様・提携先名
			Name = '新規_シンプル安豪',						  // 商談名
			CloseDate = Date.valueOf('2020-06-18'),		 // 完了予定日
			Probability = 0,								// 確度(%)
			StageName = '問合せ受付',							// フェーズ
			TesuryoKeisanzumi__c = false,				   // 手数料計算済
			SurveySendWayHopeSms__c = false,				// アンケートSMS送信希望
			SurveySendWayHopeEmail__c = false,			  // アンケートMail送信希望
			RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId()
		);

		List<Case> TESTListCase = new List<Case>();
		id TESTRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SimpleYasugoJizenJunbiWebForm').getRecordTypeId();

		String strLastname = '';
		String strFirstname = '';
		Integer nameInt = 0;

			strLastname = 'テスト' + String.valueOf(nameInt);
			strFirstname = 'テスト '+ String.valueOf(nameInt);

		Case sobj = new Case(
			Status = '新規',					  // 状況
			Origin = 'Web',					   // 発生チャネル
			Priority = '中',					  // 優先度
			Type = 'サービス利用',				// 問合せ種別
			Lastname__c = 'xxxdefualt',			// 相談者・担当者(姓)
			Firstname__c = strFirstname,		  // 相談者・担当者(名)
			TaishoushaJokyo__c = '余命宣告',			 // 対象者様のご状態（初回）
			PermissionFlag__c = false,			// 初回許諾フラグ
			TelNo__c='080-8888-8888',
			KiboAreaState__c='東京都',
			KiboAreaCity__c='中央区',
			OmukaesakiZipCode__c = '141-0031',
			OmukaesakiState__c = '東京都',
			OmukaesakiCity__c = '品川区',
			OmukaesakiStreet__c = '西五反田2-11-17',
			MailAddress__c='test@i.ss.com',
			RecordTypeId = TESTRecordTypeId,	   //レコードタイプ
			AccountId = lsracc.getid(),
			ShiryoSoufuHoho__c = 'メール希望',
			ObosanbinOption__c = '葬儀読経のみ'
		);

		TESTListCase.add(sobj);


		Test.startTest();
		Insert new TriggerIsActive__c( name='default', isActive__c=true );
		insert OPP;
		insert TESTListCase;
		Test.stopTest();
	
	}
	@isTest static void doTest6(){
		id defualtAccountRT = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId();
		Account dacc=new Account();
		dacc.LastName='xxxdefualt';
		dacc.Phone='088-0000-0001';
		dacc.MobilePhone__c='888-0000-0001';
		dacc.recordTypeId = defualtAccountRT;
		Database.SaveResult lsracc = Database.insert(dacc);

		Opportunity OPP = new Opportunity(
			AccountId = lsracc.getid(),				// お客様・提携先名
			Name = '新規_シンプル安豪',						  // 商談名
			CloseDate = Date.valueOf('2020-06-18'),		 // 完了予定日
			Probability = 0,								// 確度(%)
			StageName = '問合せ受付',							// フェーズ
			TesuryoKeisanzumi__c = false,				   // 手数料計算済
			SurveySendWayHopeSms__c = false,				// アンケートSMS送信希望
			SurveySendWayHopeEmail__c = false,			  // アンケートMail送信希望
			RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId()
		);

		List<Case> TESTListCase = new List<Case>();
		id TESTRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SimpleYasugoJizenJunbiWebForm').getRecordTypeId();

		String strLastname = '';
		String strFirstname = '';
		Integer nameInt = 0;

			strLastname = 'テスト' + String.valueOf(nameInt);
			strFirstname = 'テスト '+ String.valueOf(nameInt);

		Case sobj = new Case(
			Status = '新規',					  // 状況
			Origin = 'Web',					   // 発生チャネル
			Priority = '中',					  // 優先度
			Type = 'サービス利用',				// 問合せ種別
			Lastname__c = 'xxxdefualt',			// 相談者・担当者(姓)
			Firstname__c = strFirstname,		  // 相談者・担当者(名)
			TaishoushaJokyo__c = '余命宣告',			 // 対象者様のご状態（初回）
			PermissionFlag__c = false,			// 初回許諾フラグ
			TelNo__c='080-8888-8888',
			KiboAreaState__c='東京都',
			KiboAreaCity__c='中央区',
			OmukaesakiZipCode__c = '141-0031',
			OmukaesakiState__c = '東京都',
			OmukaesakiCity__c = '品川区',
			OmukaesakiStreet__c = '西五反田2-11-17',
			MailAddress__c='test@i.ss.com',
			RecordTypeId = TESTRecordTypeId,	   //レコードタイプ
			AccountId = lsracc.getid(),
			ShiryoSoufuHoho__c = 'メール希望',
			ObosanbinOption__c = '葬儀読経＋戒名授与'
		);

		TESTListCase.add(sobj);


		Test.startTest();
		Insert new TriggerIsActive__c( name='default', isActive__c=true );
		insert OPP;
		insert TESTListCase;
		Test.stopTest();
	
	}
	@isTest static void doTest7(){
		
		TriggerIsActive__c TriggerIsActive=new TriggerIsActive__c();
		TriggerIsActive.name='default';
		TriggerIsActive.isActive__c=true;
		insert TriggerIsActive;
		
		id redtpId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId();
		Account acc=new Account();
		acc.lastname='新規';
		acc.LastNameFurigana__pc ='defualt';
		acc.FirstNameFurigana__pc ='defualt';
		acc.Phone='080-0000-0001';
		acc.MobilePhone__c='080-0000-0001';
		acc.recordtypeid=redtpId;
		insert acc;
		
		Case newCase = new Case();
		newCase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Mail').getRecordTypeId();
		newCase.Status = '新規';
		newCase.accountid=acc.id;
		insert newCase;
		
		Test.startTest();
		newCase.Status = '対応中';
		update newCase;

		Case resultCase = [SELECT ID,OwnerId,LastModifiedById FROM Case WHERE Id = :newCase.Id];

		System.assertEquals(resultCase.LastModifiedById, resultCase.OwnerId);

		List<User> sinsoshikiUserList = [SELECT Id FROM User Where Username like 'system-admin@minrevi.jp%'];
		if(sinsoshikiUserList.size() > 0){
			newCase.Status = '新規';
			update newCase;
		
			Case resultCase2 = [SELECT ID,OwnerId,LastModifiedById FROM Case WHERE Id = :newCase.Id];

			System.assertEquals(sinsoshikiUserList.get(0).Id, resultCase2.OwnerId);
		}
		
		Test.stopTest();
	}

	@isTest static void doTest8(){
		id defualtAccountRT = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId();
		Account dacc=new Account();
		dacc.LastName='xxxdefualt';
		dacc.Phone='088-0000-0001';
		dacc.MobilePhone__c='888-0000-0001';
		dacc.recordTypeId = defualtAccountRT;
		Database.SaveResult lsracc = Database.insert(dacc);

		Opportunity OPP = new Opportunity(
			AccountId = lsracc.getid(),				// お客様・提携先名
			Name = '新規_シンプル安豪',						  // 商談名
			CloseDate = Date.valueOf('2020-06-18'),		 // 完了予定日
			Probability = 0,								// 確度(%)
			StageName = '問合せ受付',							// フェーズ
			SubPhase__c = '問合せ受付',
			TesuryoKeisanzumi__c = false,				   // 手数料計算済
			SurveySendWayHopeSms__c = false,				// アンケートSMS送信希望
			SurveySendWayHopeEmail__c = false,			  // アンケートMail送信希望
			RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId()
		);
		Database.SaveResult lsrOPP = Database.insert(OPP);

		Case newCase = new Case();
		newCase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Mail').getRecordTypeId();
		newCase.Status = '新規';
		newCase.accountid=lsracc.id;
		Database.SaveResult lsrnewCase = Database.insert(newCase);
		
		Id pricebookId = Test.getStandardPricebookId();

		Opportunity sOpp = [select id ,Name ,AccountId, TorihikiShodanRef__c , SimpleYasugoRef__c, RecordTypeId, StageName, SubPhase__c from Opportunity where id = :lsrOPP.getid()];
		
		map<string,object> ParamMap = new map<string,object>();
		
		ParamMap.put('AccountId',sOpp.AccountId);
		ParamMap.put('Name',sOpp.Name);
		ParamMap.put('TorihikiShodanRef__c',sOpp.TorihikiShodanRef__c);
		ParamMap.put('SimpleYasugoRef__c',sOpp.SimpleYasugoRef__c);
		ParamMap.put('StageName',sOpp.StageName);
		ParamMap.put('RecordTypeId',sOpp.RecordTypeId);
		ParamMap.put('CloseDate',Date.valueOf('2020-06-18'));
		ParamMap.put('Pricebook2Id',pricebookId);
		ParamMap.put('Iriguchi__c','FD-スマホ');
		ParamMap.put('TaishoushaJokyo__c','健在');
		ParamMap.put('TaishoshaKyojuKeitai__c','未聴取により不明');
		ParamMap.put('TaishoshaYomeiKikan__c','未聴取により不明');
		ParamMap.put('ToiawaseKiinsha__c','未聴取により不明');
		ParamMap.put('JuyoRenrakuJiko__c','未聴取により不明');
		ParamMap.put('SiryoSeikyoAri__c',True);
		ParamMap.put('Req_Day__c',Datetime.now());
		ParamMap.put('SubPhase__c',sOpp.SubPhase__c);
		ParamMap.put('ShiryoSoufuSakiCity__c','ああああ');
		ParamMap.put('ShiryoSoufuSakiPostalCode__c','111-1111');
		ParamMap.put('ShiryoSoufuSakiState__c','東京都');
		ParamMap.put('ShiryoSoufuSakiStreet__c','品川区');
		ParamMap.put('ShiryoSoufuSakiMailAddress__c','test@i.ss.com');
		ParamMap.put('ShiryoSoufuSakiAtena__c','ああああ');
		ParamMap.put('ShiryoSoufuSakiAtenaKana__c','ああああ');
		ParamMap.put('ShiryoSoufuHoho__c','ああああ');

		Test.startTest();
		Opportunity returnopp = new Ctl_Opportunity().InsertOpportunity(ParamMap);
		Test.stopTest();
	}
}