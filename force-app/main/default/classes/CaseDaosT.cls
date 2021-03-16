@isTest
public class CaseDaosT {

	@isTest static void doTest(){

		RecordType defualtAccountRT = new RecordTypeDao().selectRecordBySobjectTypeDeveloperName('Account', 'null');
		Account dacc=new Account();
		dacc.LastName='xxxdefualt';
		dacc.Phone='088-0000-0001';
		dacc.MobilePhone__c='888-0000-0001';
		dacc.recordTypeId = defualtAccountRT.Id;


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
		String strMail = '';
		Integer nameInt = 0;

		List<Case> TESTListCase = new List<Case>();
		List<String> SubjectnameList = new List<String>();
		List<String> MailList = new List<String>();
		List<String> LastnameList = new List<String>();

		for(String str :Liststr){

			strLastname = 'xxxdefualt' + String.valueOf(nameInt);
			strFirstname = 'テスト '+ String.valueOf(nameInt);
			strMail = 'TEST' + String.valueOf(nameInt) + '@i.ss.com';

			Case sobj = new Case(
				Status = '新規',					  // 状況
				Origin = 'Web',					   // 発生チャネル
				Priority = '中',					  // 優先度
				Type = 'サービス利用',				// 問合せ種別
				Lastname__c = strLastname,			// 相談者・担当者(姓)
				Firstname__c = strFirstname,		  // 相談者・担当者(名)
				TaishoushaJokyo__c = str,			 // 対象者様のご状態（初回）
				PermissionFlag__c = false,			// 初回許諾フラグ
				TelNo__c='080-8888-8888',
				Subject = strFirstname,
				uniq_id__c = strFirstname,
				KiboAreaState__c='東京都',
				KiboAreaCity__c='中央区',
				MailAddress__c=strMail,
				RecordTypeId = TESTRecordTypeId	   //レコードタイプ
			);

			TESTListCase.add(sobj);
			SubjectnameList.add(strFirstname);
			MailList.add(strMail);
			LastnameList.add(strLastname);

			nameInt = nameInt + 1;

		}
		Test.startTest();
		Insert new TriggerIsActive__c( name='default', isActive__c=true );
		Database.SaveResult lsracc = Database.insert(dacc);
		
		List<Database.SaveResult> ListCase = new List<Database.SaveResult>();
		ListCase = Database.insert(TESTListCase);
		
		CaseDaos.ICaseDao testICaseDao = CaseDaos.GetInstance();

		Case returnTEST = new Case();
		returnTEST = testICaseDao.SelectById(ListCase[0].getid());

		List<Case> returnTEST1 = new List<Case>();
		returnTEST1 = testICaseDao.getDataForCheckSelectByName(SubjectnameList);

		List<Case> returnTEST2 = new List<Case>();
		returnTEST2 = testICaseDao.getDataForCheckSelectByUniqId(SubjectnameList);

		List<Case> returnTEST3 = new List<Case>();
		returnTEST3 = testICaseDao.getDataForCheckSelectByRecordTypeIdAndKey(TESTRecordTypeId,LastnameList);

		List<Case> returnTEST4 = new List<Case>();
		returnTEST4 = testICaseDao.getDataForCheckSelectByRecordTypeIdAndMailAddress(TESTRecordTypeId,MailList);

		Test.stopTest();
	}

}