@isTest
public class NurturingCRMSimpleYasugoOpportunityT {

	static testMethod void doTest(){
		Id SimpleYasugorecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId();

		List<Opportunity> Listopp = new List<Opportunity>();

		//取引先の「お客様」データ作成
		Account acc = new Account(
			LastName ='TEST',
			FirstName ='特約店手数料対応',
			PermissionFlag__pc = '受け取る',
			MemberTourokuZumi__c = TRUE,
			PersonEmail = 'mail@yoriso.com',
			YusenMailAddressKubun__c = 'メールアドレス1',
			RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer')
		);
		Database.SaveResult lsracc = Database.insert(acc);

		Account acc2 = new Account(
			LastName ='TEST2',
			FirstName ='特約店手数料対応2',
			PermissionFlag__pc = '受け取る',
			MemberTourokuZumi__c = TRUE,
			PersonEmail = 'mail2@yoriso.com',
			YusenMailAddressKubun__c = 'メールアドレス1',
			RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account', 'null')
		);
		Database.SaveResult lsracc2 = Database.insert(acc2);

		Opportunity sobj1 = new Opportunity(
			recordTypeId = SimpleYasugorecordTypeId,     //レコードタイプ
			AccountId = lsracc.getId(),                  // お客様・提携先名
			Name = 'TEST 確認1_シンプル商談',         // 商談名
			CloseDate = Date.valueOf('2020-06-18'),       // 完了予定日
			StageName = '問合せ受付',                     // フェーズ
			TaishoushaJokyo__c = '死亡'                   // 対象者様のご状態（初回）
		);

		Listopp.add(sobj1);

		Opportunity sobj2 = new Opportunity(
			recordTypeId = SimpleYasugorecordTypeId,     //レコードタイプ
			AccountId = lsracc.getId(),                  // お客様・提携先名
			Name = 'TEST 確認2_シンプル商談',         // 商談名
			CloseDate = Date.valueOf('2020-06-18'),       // 完了予定日
			StageName = '問合せ受付',                     // フェーズ
			TaishoushaJokyo__c = '危篤'                   // 対象者様のご状態（初回）
		);

		Listopp.add(sobj2);

		Opportunity sobj3 = new Opportunity(
			recordTypeId = SimpleYasugorecordTypeId,     //レコードタイプ
			AccountId = lsracc.getId(),                  // お客様・提携先名
			Name = 'TEST 確認3_シンプル商談',         // 商談名
			CloseDate = Date.valueOf('2020-06-18'),       // 完了予定日
			StageName = '問合せ受付',                     // フェーズ
			TaishoushaJokyo__c = '余命宣告',              // 対象者様のご状態（初回）
			TaishoshaYomeiKikan__c = '2週間以内'         // 余命期間（初回）
		);

		Listopp.add(sobj3);

		Opportunity sobj4 = new Opportunity(
			recordTypeId = SimpleYasugorecordTypeId,     //レコードタイプ
			AccountId = lsracc.getId(),                  // お客様・提携先名
			Name = 'TEST 確認4_シンプル商談',         // 商談名
			CloseDate = Date.valueOf('2020-06-18'),       // 完了予定日
			StageName = '問合せ受付',                     // フェーズ
			TaishoushaJokyo__c = '余命宣告',              // 対象者様のご状態（初回）
			TaishoshaYomeiKikan__c = '1か月以内'         // 余命期間（初回）
		);

		Listopp.add(sobj4);

		Opportunity sobj5 = new Opportunity(
			recordTypeId = SimpleYasugorecordTypeId,     //レコードタイプ
			AccountId = lsracc.getId(),                  // お客様・提携先名
			Name = 'TEST 確認5_シンプル商談',         // 商談名
			CloseDate = Date.valueOf('2020-06-18'),       // 完了予定日
			StageName = '問合せ受付',                     // フェーズ
			TaishoushaJokyo__c = '余命宣告',              // 対象者様のご状態（初回）
			TaishoshaYomeiKikan__c = '未聴取により不明'         // 余命期間（初回）
		);

		Listopp.add(sobj5);

		Opportunity sobj6 = new Opportunity(
			recordTypeId = SimpleYasugorecordTypeId,     //レコードタイプ
			AccountId = lsracc.getId(),                  // お客様・提携先名
			Name = 'TEST 確認6_シンプル商談',         // 商談名
			CloseDate = Date.valueOf('2020-06-18'),       // 完了予定日
			StageName = '問合せ受付',                     // フェーズ
			TaishoushaJokyo__c = '余命宣告',              // 対象者様のご状態（初回）
			TaishoshaYomeiKikan__c = '3か月以内'         // 余命期間（初回）
		);

		Listopp.add(sobj6);

		Opportunity sobj7 = new Opportunity(
			recordTypeId = SimpleYasugorecordTypeId,     //レコードタイプ
			AccountId = lsracc.getId(),                  // お客様・提携先名
			Name = 'TEST 確認7_シンプル商談',         // 商談名
			CloseDate = Date.valueOf('2020-06-18'),       // 完了予定日
			StageName = '問合せ受付',                     // フェーズ
			TaishoushaJokyo__c = '余命宣告',              // 対象者様のご状態（初回）
			TaishoshaYomeiKikan__c = '6か月以内'         // 余命期間（初回）
		);

		Listopp.add(sobj7);

		Opportunity sobj8 = new Opportunity(
			recordTypeId = SimpleYasugorecordTypeId,     //レコードタイプ
			AccountId = lsracc.getId(),                  // お客様・提携先名
			Name = 'TEST 確認8_シンプル商談',         // 商談名
			CloseDate = Date.valueOf('2020-06-18'),       // 完了予定日
			StageName = '問合せ受付',                     // フェーズ
			TaishoushaJokyo__c = '余命宣告',              // 対象者様のご状態（初回）
			TaishoshaYomeiKikan__c = '1年以内'         // 余命期間（初回）
		);

		Listopp.add(sobj8);

		Opportunity sobj9 = new Opportunity(
			recordTypeId = SimpleYasugorecordTypeId,     //レコードタイプ
			AccountId = lsracc.getId(),                  // お客様・提携先名
			Name = 'TEST 確認9_シンプル商談',         // 商談名
			CloseDate = Date.valueOf('2020-06-18'),       // 完了予定日
			StageName = '問合せ受付',                     // フェーズ
			TaishoushaJokyo__c = '余命宣告',              // 対象者様のご状態（初回）
			TaishoshaYomeiKikan__c = '2年以内'         // 余命期間（初回）
		);

		Listopp.add(sobj9);

		Opportunity sobj10 = new Opportunity(
			recordTypeId = SimpleYasugorecordTypeId,     //レコードタイプ
			AccountId = lsracc.getId(),                  // お客様・提携先名
			Name = 'TEST 確認10_シンプル商談',         // 商談名
			CloseDate = Date.valueOf('2020-06-18'),       // 完了予定日
			StageName = '問合せ受付',                     // フェーズ
			TaishoushaJokyo__c = '余命宣告',              // 対象者様のご状態（初回）
			TaishoshaYomeiKikan__c = '3年以内'         // 余命期間（初回）
		);

		Listopp.add(sobj10);

		Opportunity sobj11 = new Opportunity(
			recordTypeId = SimpleYasugorecordTypeId,     //レコードタイプ
			AccountId = lsracc.getId(),                  // お客様・提携先名
			Name = 'TEST 確認11_シンプル商談',         // 商談名
			CloseDate = Date.valueOf('2020-06-18'),       // 完了予定日
			StageName = '問合せ受付',                     // フェーズ
			TaishoushaJokyo__c = '余命宣告',              // 対象者様のご状態（初回）
			TaishoshaYomeiKikan__c = '4年以内'         // 余命期間（初回）
		);

		Listopp.add(sobj11);

		Opportunity sobj12 = new Opportunity(
			recordTypeId = SimpleYasugorecordTypeId,     //レコードタイプ
			AccountId = lsracc.getId(),                  // お客様・提携先名
			Name = 'TEST 確認12_シンプル商談',         // 商談名
			CloseDate = Date.valueOf('2020-06-18'),       // 完了予定日
			StageName = '問合せ受付',                     // フェーズ
			TaishoushaJokyo__c = '余命宣告',              // 対象者様のご状態（初回）
			TaishoshaYomeiKikan__c = '5年以内'         // 余命期間（初回）
		);

		Listopp.add(sobj12);

		Opportunity sobj13 = new Opportunity(
			recordTypeId = SimpleYasugorecordTypeId,     //レコードタイプ
			AccountId = lsracc.getId(),                  // お客様・提携先名
			Name = 'TEST 確認13_シンプル商談',         // 商談名
			CloseDate = Date.valueOf('2020-06-18'),       // 完了予定日
			StageName = '問合せ受付',                     // フェーズ
			TaishoushaJokyo__c = '余命宣告',              // 対象者様のご状態（初回）
			TaishoshaYomeiKikan__c = '10年以内'         // 余命期間（初回）
		);

		Listopp.add(sobj13);

		Opportunity sobj14 = new Opportunity(
			recordTypeId = SimpleYasugorecordTypeId,     //レコードタイプ
			AccountId = lsracc.getId(),                  // お客様・提携先名
			Name = 'TEST 確認14_シンプル商談',         // 商談名
			CloseDate = Date.valueOf('2020-06-18'),       // 完了予定日
			StageName = '問合せ受付',                     // フェーズ
			TaishoushaJokyo__c = '余命宣告'              // 対象者様のご状態（初回）
		);

		Listopp.add(sobj14);

		Opportunity sobj15 = new Opportunity(
			recordTypeId = SimpleYasugorecordTypeId,     //レコードタイプ
			AccountId = lsracc.getId(),                  // お客様・提携先名
			Name = 'TEST 確認15_シンプル商談',         // 商談名
			CloseDate = Date.valueOf('2020-06-18'),       // 完了予定日
			StageName = '問合せ受付',                     // フェーズ
			TaishoushaJokyo__c = '高齢終末期'              // 対象者様のご状態（初回）
		);

		Listopp.add(sobj15);

		Opportunity sobj16 = new Opportunity(
			recordTypeId = SimpleYasugorecordTypeId,     //レコードタイプ
			AccountId = lsracc.getId(),                  // お客様・提携先名
			Name = 'TEST 確認16_シンプル商談',         // 商談名
			CloseDate = Date.valueOf('2020-06-18'),       // 完了予定日
			StageName = '問合せ受付',                     // フェーズ
			TaishoushaJokyo__c = '闘病中（重度）'              // 対象者様のご状態（初回）
		);

		Listopp.add(sobj16);

		Opportunity sobj17 = new Opportunity(
			recordTypeId = SimpleYasugorecordTypeId,     //レコードタイプ
			AccountId = lsracc.getId(),                  // お客様・提携先名
			Name = 'TEST 確認17_シンプル商談',         // 商談名
			CloseDate = Date.valueOf('2020-06-18'),       // 完了予定日
			StageName = '問合せ受付',                     // フェーズ
			TaishoushaJokyo__c = '闘病中（軽度）',           // 対象者様のご状態（初回）
			TaishoshaKyojuKeitai__c = '病院（入院中）'     // 対象者居住状態（初回）
		);

		Listopp.add(sobj17);

		Opportunity sobj18 = new Opportunity(
			recordTypeId = SimpleYasugorecordTypeId,     //レコードタイプ
			AccountId = lsracc.getId(),                  // お客様・提携先名
			Name = 'TEST 確認18_シンプル商談',         // 商談名
			CloseDate = Date.valueOf('2020-06-18'),       // 完了予定日
			StageName = '問合せ受付',                     // フェーズ
			TaishoushaJokyo__c = '闘病中（軽度）'              // 対象者様のご状態（初回）
		);

		Listopp.add(sobj18);

		Opportunity sobj19 = new Opportunity(
			recordTypeId = SimpleYasugorecordTypeId,     //レコードタイプ
			AccountId = lsracc.getId(),                  // お客様・提携先名
			Name = 'TEST 確認19_シンプル商談',         // 商談名
			CloseDate = Date.valueOf('2020-06-18'),       // 完了予定日
			StageName = '問合せ受付',                     // フェーズ
			TaishoushaJokyo__c = '闘病中（度合不明）',        // 対象者様のご状態（初回）
			TaishoshaKyojuKeitai__c = '病院（入院中）'     // 対象者居住状態（初回）
		);

		Listopp.add(sobj19);

		Opportunity sobj20 = new Opportunity(
			recordTypeId = SimpleYasugorecordTypeId,     //レコードタイプ
			AccountId = lsracc.getId(),                  // お客様・提携先名
			Name = 'TEST 確認20_シンプル商談',         // 商談名
			CloseDate = Date.valueOf('2020-06-18'),       // 完了予定日
			StageName = '問合せ受付',                     // フェーズ
			TaishoushaJokyo__c = '闘病中（度合不明）'              // 対象者様のご状態（初回）
		);

		Listopp.add(sobj20);

		Opportunity sobj21 = new Opportunity(
			recordTypeId = SimpleYasugorecordTypeId,     //レコードタイプ
			AccountId = lsracc.getId(),                  // お客様・提携先名
			Name = 'TEST 確認21_シンプル商談',         // 商談名
			CloseDate = Date.valueOf('2020-06-18'),       // 完了予定日
			StageName = '問合せ受付',                     // フェーズ
			TaishoushaJokyo__c = '健在'              // 対象者様のご状態（初回）
		);

		Listopp.add(sobj21);

		Opportunity sobj22 = new Opportunity(
			recordTypeId = SimpleYasugorecordTypeId,     //レコードタイプ
			AccountId = lsracc.getId(),                  // お客様・提携先名
			Name = 'TEST 確認22_シンプル商談',         // 商談名
			CloseDate = Date.valueOf('2020-06-18'),       // 完了予定日
			StageName = '問合せ受付',                     // フェーズ
			TaishoushaJokyo__c = '未聴取により不明',        // 対象者様のご状態（初回）
			TaishoshaKyojuKeitai__c = '老人ホーム'     // 対象者居住状態（初回）
		);

		Listopp.add(sobj22);

		Opportunity sobj23 = new Opportunity(
			recordTypeId = SimpleYasugorecordTypeId,     //レコードタイプ
			AccountId = lsracc.getId(),                  // お客様・提携先名
			Name = 'TEST 確認23_シンプル商談',         // 商談名
			CloseDate = Date.valueOf('2020-06-18'),       // 完了予定日
			StageName = '問合せ受付',                     // フェーズ
			TaishoushaJokyo__c = '未聴取により不明'              // 対象者様のご状態（初回）
		);

		Listopp.add(sobj23);

		Opportunity sobj24 = new Opportunity(
			recordTypeId = SimpleYasugorecordTypeId,     //レコードタイプ
			AccountId = lsracc.getId(),                  // お客様・提携先名
			Name = 'TEST 確認24_シンプル商談',         // 商談名
			CloseDate = Date.valueOf('2020-06-18'),       // 完了予定日
			StageName = '問合せ受付',                     // フェーズ
			TaishoushaJokyo__c = 'お骨'              // 対象者様のご状態（初回）
		);

		Listopp.add(sobj24);

		Opportunity sobj25 = new Opportunity(
			recordTypeId = SimpleYasugorecordTypeId,     //レコードタイプ
			AccountId = lsracc.getId(),                  // お客様・提携先名
			Name = 'TEST 確認25_シンプル商談',         // 商談名
			CloseDate = Date.valueOf('2020-06-18'),       // 完了予定日
			StageName = '問合せ受付',                     // フェーズ
			TaishoushaJokyo__c = '病状回復'              // 対象者様のご状態（初回）
		);

		Listopp.add(sobj25);

		Opportunity sobj26 = new Opportunity(
			recordTypeId = SimpleYasugorecordTypeId,     //レコードタイプ
			AccountId = lsracc.getId(),                  // お客様・提携先名
			Name = 'TEST 確認26_シンプル商談',         // 商談名
			CloseDate = Date.valueOf('2020-06-18'),       // 完了予定日
			StageName = '問合せ受付'                     // フェーズ

		);

		Listopp.add(sobj26);

		Opportunity sobj27 = new Opportunity(
			recordTypeId = SimpleYasugorecordTypeId,     //レコードタイプ
			AccountId = lsracc.getId(),                  // お客様・提携先名
			Name = 'TEST 確認22_シンプル商談',         // 商談名
			CloseDate = Date.valueOf('2020-06-18'),       // 完了予定日
			StageName = '問合せ受付',                     // フェーズ
			TaishoshaKyojuKeitai__c = '老人ホーム'     // 対象者居住状態（初回）
		);

		Listopp.add(sobj27);

		Opportunity sobj28 = new Opportunity(
			recordTypeId = SimpleYasugorecordTypeId,     //レコードタイプ
			AccountId = lsracc.getId(),                  // お客様・提携先名
			Name = 'TEST 確認22_シンプル商談',         // 商談名
			CloseDate = Date.valueOf('2020-06-18'),       // 完了予定日
			StageName = '問合せ受付',                     // フェーズ
			TaishoushaJokyo__c = 'ああああ'        // 対象者様のご状態（初回）
		);

		Listopp.add(sobj28);

		Database.SaveResult[] lsrtopp = Database.insert(Listopp);
		try{
		Opportunity sobjUP1 = [SELECT Id , TaishoushaJokyo__c FROM Opportunity WHERE Id = :lsrtopp[1].getId() limit 1];
			sobjUP1.TaishoushaJokyo__c = '未聴取により不明';
			update sobjUP1;
		}catch(Exception e){
		}
		try{
			Opportunity sobjUP2 = [SELECT Id , TaishoushaJokyoGenzai__c ,TaishoshaYomeiKikanGenzai__c ,TaishoshaKyojuKeitaiGenzai__c FROM Opportunity WHERE Id = :lsrtopp[2].getId() limit 1];
			sobjUP2.TaishoushaJokyoGenzai__c = '未聴取により不明';
			update sobjUP2;
		}catch(Exception e){
		}
		try{
			Opportunity sobjUP3 = [SELECT Id , TaishoushaJokyoGenzai__c FROM Opportunity WHERE Id = :lsrtopp[3].getId() limit 1];
			sobjUP3.TaishoushaJokyoGenzai__c = '病状回復';
			update sobjUP3;
		}catch(Exception e){
		}
		try{
			Opportunity sobjUP4 = [SELECT Id , TaishoushaJokyoGenzai__c FROM Opportunity WHERE Id = :lsrtopp[23].getId() limit 1];
			sobjUP4.TaishoushaJokyoGenzai__c = '余命宣告';
			update sobjUP4;
		}catch(Exception e){
		}
		try{
			Opportunity sobjUP5 = [SELECT Id , TaishoushaJokyoGenzai__c ,TaishoshaYomeiKikanGenzai__c ,TaishoshaKyojuKeitaiGenzai__c FROM Opportunity WHERE Id = :lsrtopp[22].getId() limit 1];
			sobjUP5.TaishoshaYomeiKikanGenzai__c = '10年以内';
			update sobjUP5;
		}catch(Exception e){
		}
		try{
			Opportunity sobjUP6 = [SELECT Id , TaishoushaJokyoGenzai__c ,TaishoshaYomeiKikanGenzai__c ,TaishoshaKyojuKeitaiGenzai__c FROM Opportunity WHERE Id = :lsrtopp[5].getId() limit 1];
			sobjUP6.TaishoshaKyojuKeitaiGenzai__c = '病院（入院中）';
			update sobjUP6;
		}catch(Exception e){
		}
	}

	public static testMethod void testRunAs() {
		String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@test.com';
		Profile p = [SELECT Id FROM Profile WHERE Name='CSリーダ'];
		User u = new User(Alias = 'standt', 
			Email='test@test.com',
			EmailEncodingKey='UTF-8', 
			LastName='Testing', 
			LanguageLocaleKey='en_US',
			LocaleSidKey='en_US', 
			ProfileId = p.Id,
			TimeZoneSidKey='Asia/Tokyo',
			UserName=uniqueUserName);
			
		Id SimpleYasugorecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId();

		List<Opportunity> Listopp = new List<Opportunity>();

		//取引先の「お客様」データ作成
		Account acc = new Account(
			LastName ='TEST',
			FirstName ='特約店手数料対応',
			PermissionFlag__pc = '受け取る',
			MemberTourokuZumi__c = TRUE,
			PersonEmail = 'mail@yoriso.com',
			YusenMailAddressKubun__c = 'メールアドレス1',
			RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer')
		);
		Database.SaveResult lsracc = Database.insert(acc);

		Account acc2 = new Account(
			LastName ='TEST2',
			FirstName ='特約店手数料対応2',
			PermissionFlag__pc = '受け取る',
			MemberTourokuZumi__c = TRUE,
			PersonEmail = 'mail2@yoriso.com',
			YusenMailAddressKubun__c = 'メールアドレス1',
			RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account', 'null')
		);
		Database.SaveResult lsracc2 = Database.insert(acc2);

		Opportunity sobj1 = new Opportunity(
			recordTypeId = SimpleYasugorecordTypeId,     //レコードタイプ
			AccountId = lsracc.getId(),                  // お客様・提携先名
			Name = 'TEST 確認1_シンプル商談',         // 商談名
			CloseDate = Date.valueOf('2020-06-18'),       // 完了予定日
			StageName = '問合せ受付',                     // フェーズ
			TaishoushaJokyo__c = '未聴取により不明',
			TaishoshaKyojuKeitai__c = '未聴取により不明',
			TaishoshaYomeiKikan__c = '未聴取により不明',
			TaishoushaJokyoGenzai__c = '未聴取により不明',
			TaishoshaYomeiKikanGenzai__c = '未聴取により不明',
			TaishoshaKyojuKeitaiGenzai__c = '未聴取により不明',
			ToiawaseKiinsha__c = '未聴取により不明'
		);

		Listopp.add(sobj1);

		Database.SaveResult[] lsrtopp = Database.insert(Listopp);

		System.runAs(u) {
			try{
				Opportunity sobjUP1 = [SELECT Id , TaishoushaJokyo__c ,TaishoshaKyojuKeitai__c ,TaishoshaYomeiKikan__c,TaishoushaJokyoGenzai__c,TaishoshaYomeiKikanGenzai__c,TaishoshaKyojuKeitaiGenzai__c, ToiawaseKiinsha__c FROM Opportunity WHERE Id = :lsrtopp[0].getId() limit 1];
				sobjUP1.TaishoushaJokyo__c = '';
				update sobjUP1;
			}catch(Exception e){
			}
			try{
				Opportunity sobjUP2 = [SELECT Id , TaishoushaJokyo__c ,TaishoshaKyojuKeitai__c ,TaishoshaYomeiKikan__c,TaishoushaJokyoGenzai__c,TaishoshaYomeiKikanGenzai__c,TaishoshaKyojuKeitaiGenzai__c, ToiawaseKiinsha__c FROM Opportunity WHERE Id = :lsrtopp[0].getId() limit 1];
				sobjUP2.TaishoushaJokyo__c = '未聴取により不明';
				sobjUP2.TaishoshaKyojuKeitai__c = '';
				update sobjUP2;
			}catch(Exception e){
			}
			try{
				Opportunity sobjUP3 = [SELECT Id , TaishoushaJokyo__c ,TaishoshaKyojuKeitai__c ,TaishoshaYomeiKikan__c,TaishoushaJokyoGenzai__c,TaishoshaYomeiKikanGenzai__c,TaishoshaKyojuKeitaiGenzai__c, ToiawaseKiinsha__c FROM Opportunity WHERE Id = :lsrtopp[0].getId() limit 1];
				sobjUP3.TaishoushaJokyo__c = '未聴取により不明';
				sobjUP3.TaishoshaKyojuKeitai__c = '未聴取により不明';
				sobjUP3.TaishoshaYomeiKikan__c = '';
				update sobjUP3;
			}catch(Exception e){
			}
			try{
				Opportunity sobjUP4 = [SELECT Id , TaishoushaJokyo__c ,TaishoshaKyojuKeitai__c ,TaishoshaYomeiKikan__c,TaishoushaJokyoGenzai__c,TaishoshaYomeiKikanGenzai__c,TaishoshaKyojuKeitaiGenzai__c, ToiawaseKiinsha__c FROM Opportunity WHERE Id = :lsrtopp[0].getId() limit 1];
				sobjUP4.TaishoushaJokyo__c = '未聴取により不明';
				sobjUP4.TaishoshaKyojuKeitai__c = '未聴取により不明';
				sobjUP4.TaishoshaYomeiKikan__c = '未聴取により不明';
				sobjUP4.TaishoushaJokyoGenzai__c = '';
				update sobjUP4;
			}catch(Exception e){
			}
			try{
				Opportunity sobjUP5 = [SELECT Id , TaishoushaJokyo__c ,TaishoshaKyojuKeitai__c ,TaishoshaYomeiKikan__c,TaishoushaJokyoGenzai__c,TaishoshaYomeiKikanGenzai__c,TaishoshaKyojuKeitaiGenzai__c, ToiawaseKiinsha__c FROM Opportunity WHERE Id = :lsrtopp[0].getId() limit 1];
				sobjUP5.TaishoushaJokyo__c = '未聴取により不明';
				sobjUP5.TaishoshaKyojuKeitai__c = '未聴取により不明';
				sobjUP5.TaishoshaYomeiKikan__c = '未聴取により不明';
				sobjUP5.TaishoushaJokyoGenzai__c = '未聴取により不明';
				sobjUP5.TaishoshaYomeiKikanGenzai__c = '';
				update sobjUP5;
			}catch(Exception e){
			}
			try{
				Opportunity sobjUP6 = [SELECT Id , TaishoushaJokyo__c ,TaishoshaKyojuKeitai__c ,TaishoshaYomeiKikan__c,TaishoushaJokyoGenzai__c,TaishoshaYomeiKikanGenzai__c,TaishoshaKyojuKeitaiGenzai__c, ToiawaseKiinsha__c FROM Opportunity WHERE Id = :lsrtopp[0].getId() limit 1];
				sobjUP6.TaishoushaJokyo__c = '未聴取により不明';
				sobjUP6.TaishoshaKyojuKeitai__c = '未聴取により不明';
				sobjUP6.TaishoshaYomeiKikan__c = '未聴取により不明';
				sobjUP6.TaishoushaJokyoGenzai__c = '未聴取により不明';
				sobjUP6.TaishoshaYomeiKikanGenzai__c = '未聴取により不明';
				sobjUP6.TaishoshaKyojuKeitaiGenzai__c = '';
				update sobjUP6;
			}catch(Exception e){
			}
			try{
				Opportunity sobjUP7 = [SELECT Id , TaishoushaJokyo__c ,TaishoshaKyojuKeitai__c ,TaishoshaYomeiKikan__c,TaishoushaJokyoGenzai__c,TaishoshaYomeiKikanGenzai__c,TaishoshaKyojuKeitaiGenzai__c, ToiawaseKiinsha__c FROM Opportunity WHERE Id = :lsrtopp[0].getId() limit 1];
				sobjUP7.TaishoushaJokyo__c = '未聴取により不明';
				sobjUP7.TaishoshaKyojuKeitai__c = '未聴取により不明';
				sobjUP7.TaishoshaYomeiKikan__c = '未聴取により不明';
				sobjUP7.TaishoushaJokyoGenzai__c = '未聴取により不明';
				sobjUP7.TaishoshaYomeiKikanGenzai__c = '未聴取により不明';
				sobjUP7.TaishoshaKyojuKeitaiGenzai__c = '未聴取により不明';
				sobjUP7.ToiawaseKiinsha__c = '';
				update sobjUP7;
			}catch(Exception e){
			}
		}
	}

}