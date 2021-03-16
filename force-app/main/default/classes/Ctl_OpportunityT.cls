@isTest
public class Ctl_OpportunityT {

	static testMethod void testCase1(){

		TriggerIsActive__c TriggerIsActive=new TriggerIsActive__c();
		TriggerIsActive.name='default';
		TriggerIsActive.isActive__c=true;
		insert TriggerIsActive;

		Map<ID, Account> accountMap = new Map<ID, Account>();
		List<Account> listAcc = new List<Account>();
		
		Account acc=new Account(
			lastname='新規',
			FirstName='しんき',
			LastNameFurigana__pc ='defualt',
			FirstNameFurigana__pc ='defualt',
			Phone='080-0000-0001',
			MobilePhone__c='080-0000-0001',
			recordtypeid=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId()
		);
		insert acc;

		Account acc2=new Account(
			lastname='TEST',
			FirstName='イチ',
			LastNameFurigana__pc ='defualt',
			FirstNameFurigana__pc ='defualt',
			Phone='090-0120-0001',
			MobilePhone__c='090-0120-0001',
			BillingPostalCode='141-0031',
			BillingState='東京都',
			BillingCity = '品川区',
			BillingStreet = '西五反田',
			recordtypeid=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId()
		);
		insert acc2;

		Database.SaveResult[] lsrAcc = Database.insert(listAcc);

		//取引先の「葬儀社」データ作成
		Account acc3 = new Account(
			Name ='ベネフィット',
			RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Default').getRecordTypeId(),
			Fax = '03-3493-87701',
			Description = 'この葬儀社は、システム内で本番環境で動作確認する際に利用するテストデータの葬儀社です。'
		);
		Database.SaveResult lsracc3 = Database.insert(acc3);

		//パートナー契約の「シンプル安豪契約」データ作成
		Keiyaku__c Keiyaku = new Keiyaku__c(
			Name = 'ベネフィット',
			RecordTypeId = Schema.SObjectType.Keiyaku__c.getRecordTypeInfosByDeveloperName().get('Alliance').getRecordTypeId(),
			Teikeisaki__c = lsracc3.getId()
		);
		insert Keiyaku;

		//取引先の「葬儀社」データ作成
		Account acc4 = new Account(
			Name ='ポスタルくらぶ',
			RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Default').getRecordTypeId(),
			Fax = '03-3493-87701',
			Description = 'この葬儀社は、システム内で本番環境で動作確認する際に利用するテストデータの葬儀社です。'
		);
		Database.SaveResult lsracc4 = Database.insert(acc4);

		//パートナー契約の「シンプル安豪契約」データ作成
		Keiyaku__c Keiyaku2 = new Keiyaku__c(
			Name = 'ポスタルくらぶ',
			RecordTypeId = Schema.SObjectType.Keiyaku__c.getRecordTypeInfosByDeveloperName().get('Alliance').getRecordTypeId(),
			Teikeisaki__c = lsracc4.getId()
		);
		insert Keiyaku2;

		Test.startTest();
		Opportunity Opp = new Opportunity(
			AccountId = acc.id,
			RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId(),
			Name = 'TEST_商談',
			StageName = 'お亡くなり対応', 
			CloseDate = date.Today(),
			RyosyuAtenaIsSodansha__c = True,
			SiryoSoufuSakiIsSoudansya__c = True,
			KiboShiharaiHouhou__c = '現金',
			SurveyDiscountAgreeStatus__c='拒否'
			);
		insert opp;
		
		Opportunity NewOpp = [SELECT ID,OwnerId,LastModifiedById,RyosyuAtena__c,StageName,AccountId,BenefitOneID__c,PostalClubKaiinBango__c FROM Opportunity WHERE Id = :opp.Id];
		NewOpp.RyosyuAtena__c = 'テスト';
		NewOpp.StageName = '決定';
		NewOpp.AccountId = acc2.id;
		NewOpp.BenefitOneID__c = 'ベネフィット';
		NewOpp.PostalClubKaiinBango__c = 'ポスタルくらぶ';
		update NewOpp;

		Opportunity NewOpp2 = [SELECT ID,OwnerId,LastModifiedById,RyosyuAtena__c,StageName,SimpleYasugoRef__c FROM Opportunity WHERE Id = :opp.Id];
		NewOpp2.StageName = 'お亡くなり対応';
		update NewOpp2;

		SimpleYasugo__c SimpleYasugo = [SELECT Id, SeikyushojuryoDay__c FROM SimpleYasugo__c WHERE Id = :NewOpp2.SimpleYasugoRef__c];
		SimpleYasugo.SeikyushojuryoDay__c = date.Today();
		update SimpleYasugo;

		Opportunity NewOpp3 = [SELECT ID,OwnerId,StageName,Req_Day__c,CloseDate,KakuteibiSyodan__c,Utiagebi__c FROM Opportunity WHERE Id = :opp.Id];
		NewOpp3.StageName = '商談クローズ';
		NewOpp3.Req_Day__c = datetime.now();
		NewOpp3.CloseDate = date.Today();
		NewOpp3.KakuteibiSyodan__c = datetime.now();
		NewOpp3.Utiagebi__c = date.Today();
		update NewOpp3;
		Set<Id> oppCloseIdSet = new Set<Id>();
		oppCloseIdSet.add(NewOpp3.id);
		Date Date2 = Ctl_Opportunity.slideDay(date.Today());
		Test.stopTest();
	}

	static testMethod void testCase2(){

		TriggerIsActive__c TriggerIsActive=new TriggerIsActive__c();
		TriggerIsActive.name='default';
		TriggerIsActive.isActive__c=true;
		insert TriggerIsActive;

		Map<ID, Account> accountMap = new Map<ID, Account>();
		List<Account> listAcc = new List<Account>();
		
		Account acc=new Account(
			lastname='新規',
			FirstName='しんき',
			LastNameFurigana__pc ='defualt',
			FirstNameFurigana__pc ='defualt',
			Phone='080-0000-0001',
			MobilePhone__c='080-0000-0001',
			recordtypeid=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId()
		);
		insert acc;

		Account acc2=new Account(
			lastname='TEST',
			FirstName='イチ',
			LastNameFurigana__pc ='defualt',
			FirstNameFurigana__pc ='defualt',
			Phone='090-0120-0001',
			MobilePhone__c='090-0120-0001',
			BillingPostalCode='141-0031',
			BillingState='東京都',
			BillingCity = '品川区',
			BillingStreet = '西五反田',
			recordtypeid=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId()
		);
		insert acc2;

		Database.SaveResult[] lsrAcc = Database.insert(listAcc);

		Test.startTest();
		Opportunity Opp = new Opportunity(
			AccountId = acc.id,
			RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Obosanbin').getRecordTypeId(),
			Name = 'TEST_商談',
			StageName = '生前契約成立', 
			CloseDate = date.Today(),
			RyosyuAtenaIsSodansha__c = True,
			SiryoSoufuSakiIsSoudansya__c = True,
			KiboShiharaiHouhou__c = '現金',
			SurveyDiscountAgreeStatus__c='拒否'
			);
		insert opp;
		
		Opportunity NewOpp = [SELECT ID,OwnerId,LastModifiedById,RyosyuAtena__c,StageName,AccountId FROM Opportunity WHERE Id = :opp.Id];
		NewOpp.RyosyuAtena__c = 'テスト';
		NewOpp.StageName = '決定';
		NewOpp.AccountId = acc2.id;
		update NewOpp;

		Opportunity NewOpp2 = [SELECT ID,OwnerId,LastModifiedById,RyosyuAtena__c,StageName,SimpleYasugoRef__c FROM Opportunity WHERE Id = :opp.Id];
		NewOpp2.StageName = '生前契約成立';
		update NewOpp2;

		Opportunity NewOpp3 = [SELECT ID,OwnerId,StageName,Req_Day__c,CloseDate,KakuteibiSyodan__c,Utiagebi__c FROM Opportunity WHERE Id = :opp.Id];
		NewOpp3.StageName = '商談クローズ';
		NewOpp3.Req_Day__c = datetime.now();
		NewOpp3.CloseDate = date.Today();
		NewOpp3.KakuteibiSyodan__c = datetime.now();
		NewOpp3.Utiagebi__c = date.Today();
		update NewOpp3;

		Test.stopTest();
	}

	@isTest static void testCase3(){
		id defualtAccountRT = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId();
		Account dacc=new Account();
		dacc.LastName='xxxdefualt';
		dacc.Phone='088-0000-0001';
		dacc.MobilePhone__c='888-0000-0001';
		dacc.recordTypeId = defualtAccountRT;
		Database.SaveResult lsracc = Database.insert(dacc);

		Opportunity OPP = new Opportunity(
			AccountId = lsracc.getid(),
			Name = '新規_シンプル安豪',
			CloseDate = Date.valueOf('2020-06-18'),
			Probability = 0,
			StageName = '問合せ受付',
			SubPhase__c = '問合せ受付',
			TesuryoKeisanzumi__c = false,
			SurveySendWayHopeSms__c = false,
			SurveySendWayHopeEmail__c = false,
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

	@isTest static void testCaseSimpleYasugo(){
		
		TriggerIsActive__c TriggerIsActive=new TriggerIsActive__c();
		TriggerIsActive.name='default';
		TriggerIsActive.isActive__c=true;
		insert TriggerIsActive;
		
		Account acc=new Account(
			lastname='新規',
			FirstName='しんき',
			LastNameFurigana__pc ='defualt',
			FirstNameFurigana__pc ='defualt',
			Phone='080-0000-0001',
			MobilePhone__c='080-0000-0001',
			recordtypeid=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId()
		);
		insert acc;
		
		Case newCase = new Case(
			Status = '新規',
			Entrance__c = 'テスト',
			ImporantMessage__c = 'テスト',
			ToiawaseDate__c = datetime.now(),
			ShiryohassosakiCity__c = '品川区',
			ShiryohassosakiZipCode__c = '141-0031',
			ShiryohassosakiState__c = '東京都',
			ShiryohassosakiStreet__c = '西五反田',
			ShiryoSoufuSakiMailAddress__c = 'test@test.com',
			ShiryoSoufuSakiAtena__c = '新規',
			ShiryoSoufuSakiAtenaKana__c = 'シンキ',
			ShiryoSoufuHoho__c = 'メール希望',
			ShiharaiHouhou__c = 'おきもち後払い',
			TaishoshaKyojuKeitai__c = null,
			TaishoshaYomeiKikan__c = null,
			ToiawaseKiinsha__c = null,
			accountid=acc.id,
			RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SimpleYasugoShiryoSeikyuWebForm').getRecordTypeId()
		);

		Test.startTest();
		insert newCase;
		Test.stopTest();
	}

	@isTest static void testCaseSeizenkeiyaku(){
		
		TriggerIsActive__c TriggerIsActive=new TriggerIsActive__c();
		TriggerIsActive.name='default';
		TriggerIsActive.isActive__c=true;
		insert TriggerIsActive;
		
		Account acc=new Account(
			lastname='新規',
			FirstName='しんき',
			LastNameFurigana__pc ='defualt',
			FirstNameFurigana__pc ='defualt',
			Phone='080-0000-0001',
			MobilePhone__c='080-0000-0001',
			recordtypeid=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId()
		);
		insert acc;
		
		Case newCase = new Case(
			Status = '新規',
			Entrance__c = 'テスト',
			ImporantMessage__c = 'テスト',
			ToiawaseDate__c = datetime.now(),
			ShiryohassosakiCity__c = '品川区',
			ShiryohassosakiZipCode__c = '141-0031',
			ShiryohassosakiState__c = '東京都',
			ShiryohassosakiStreet__c = '西五反田',
			ShiryoSoufuSakiMailAddress__c = 'test@test.com',
			ShiryoSoufuSakiAtena__c = '新規',
			ShiryoSoufuSakiAtenaKana__c = 'シンキ',
			ShiryoSoufuHoho__c = 'メール希望',
			ShiharaiHouhou__c = 'おきもち後払い',
			TaishoshaKyojuKeitai__c = null,
			TaishoshaYomeiKikan__c = null,
			ToiawaseKiinsha__c = null,
			// accountid=acc.id,
			RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Seizenkeiyaku').getRecordTypeId()
		);

		Test.startTest();
		insert newCase;
		Test.stopTest();
	}

	@isTest static void testCaseObousanbinTehaidaikou(){
		
		TriggerIsActive__c TriggerIsActive=new TriggerIsActive__c();
		TriggerIsActive.name='default';
		TriggerIsActive.isActive__c=true;
		insert TriggerIsActive;
		
		Account acc=new Account(
			lastname='新規',
			FirstName='しんき',
			LastNameFurigana__pc ='defualt',
			FirstNameFurigana__pc ='defualt',
			Phone='080-0000-0001',
			MobilePhone__c='080-0000-0001',
			recordtypeid=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId()
		);
		insert acc;
		
		Case newCase = new Case(
			Status = '新規',
			Entrance__c = 'テスト',
			ImporantMessage__c = 'テスト',
			ToiawaseDate__c = datetime.now(),
			ShiryohassosakiCity__c = '品川区',
			ShiryohassosakiZipCode__c = '141-0031',
			ShiryohassosakiState__c = '東京都',
			ShiryohassosakiStreet__c = '西五反田',
			ShiryoSoufuSakiMailAddress__c = 'test@test.com',
			ShiryoSoufuSakiAtena__c = '新規',
			ShiryoSoufuSakiAtenaKana__c = 'シンキ',
			ShiryoSoufuHoho__c = 'メール希望',
			ShiharaiHouhou__c = 'おきもち後払い',
			TaishoshaKyojuKeitai__c = null,
			TaishoshaYomeiKikan__c = null,
			ToiawaseKiinsha__c = null,
			// accountid=acc.id,
			RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('ObousanbinTehaidaikou').getRecordTypeId()
		);

		Test.startTest();
		insert newCase;
		Test.stopTest();
	}

	@isTest static void testCaseObousanbinShiryoSeikyu(){
		
		TriggerIsActive__c TriggerIsActive=new TriggerIsActive__c();
		TriggerIsActive.name='default';
		TriggerIsActive.isActive__c=true;
		insert TriggerIsActive;
		
		Account acc=new Account(
			lastname='新規',
			FirstName='しんき',
			LastNameFurigana__pc ='defualt',
			FirstNameFurigana__pc ='defualt',
			Phone='080-0000-0001',
			MobilePhone__c='080-0000-0001',
			recordtypeid=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId()
		);
		insert acc;
		
		Case newCase = new Case(
			Status = '新規',
			Entrance__c = 'テスト',
			ImporantMessage__c = 'テスト',
			ToiawaseDate__c = datetime.now(),
			ShiryohassosakiCity__c = '品川区',
			ShiryohassosakiZipCode__c = '141-0031',
			ShiryohassosakiState__c = '東京都',
			ShiryohassosakiStreet__c = '西五反田',
			ShiryoSoufuSakiMailAddress__c = 'test@test.com',
			ShiryoSoufuSakiAtena__c = '新規',
			ShiryoSoufuSakiAtenaKana__c = 'シンキ',
			ShiryoSoufuHoho__c = 'メール希望',
			ShiharaiHouhou__c = 'おきもち後払い',
			TaishoshaKyojuKeitai__c = null,
			TaishoshaYomeiKikan__c = null,
			ToiawaseKiinsha__c = null,
			// accountid=acc.id,
			RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('ObousanbinShiryoSeikyu').getRecordTypeId()
		);

		Test.startTest();
		insert newCase;
		Test.stopTest();
	}

	@isTest static void testCaseObousanbinNetYoyaku(){
		
		TriggerIsActive__c TriggerIsActive=new TriggerIsActive__c();
		TriggerIsActive.name='default';
		TriggerIsActive.isActive__c=true;
		insert TriggerIsActive;
		
		Account acc=new Account(
			lastname='新規',
			FirstName='しんき',
			LastNameFurigana__pc ='defualt',
			FirstNameFurigana__pc ='defualt',
			Phone='080-0000-0001',
			MobilePhone__c='080-0000-0001',
			recordtypeid=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId()
		);
		insert acc;
		
		Case newCase = new Case(
			Status = '新規',
			Entrance__c = 'テスト',
			ImporantMessage__c = 'テスト',
			ToiawaseDate__c = datetime.now(),
			ShiryohassosakiCity__c = '品川区',
			ShiryohassosakiZipCode__c = '141-0031',
			ShiryohassosakiState__c = '東京都',
			ShiryohassosakiStreet__c = '西五反田',
			ShiryoSoufuSakiMailAddress__c = 'test@test.com',
			ShiryoSoufuSakiAtena__c = '新規',
			ShiryoSoufuSakiAtenaKana__c = 'シンキ',
			ShiryoSoufuHoho__c = 'メール希望',
			ShiharaiHouhou__c = 'おきもち後払い',
			TaishoshaKyojuKeitai__c = null,
			TaishoshaYomeiKikan__c = null,
			ToiawaseKiinsha__c = null,
			// accountid=acc.id,
			RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('ObousanbinNetYoyaku').getRecordTypeId()
		);
		Test.startTest();
		Opportunity serviceOpp = new Ctl_Opportunity().CaseToServiceOpportunity(newCase, acc);
		Test.stopTest();
	}

	@isTest static void testCaseObosanbin(){
		
		TriggerIsActive__c TriggerIsActive=new TriggerIsActive__c();
		TriggerIsActive.name='default';
		TriggerIsActive.isActive__c=true;
		insert TriggerIsActive;
		
		Account acc=new Account(
			lastname='新規',
			FirstName='しんき',
			LastNameFurigana__pc ='defualt',
			FirstNameFurigana__pc ='defualt',
			Phone='080-0000-0001',
			MobilePhone__c='080-0000-0001',
			recordtypeid=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId()
		);
		insert acc;
		
		Case newCase = new Case(
			Status = '新規',
			Entrance__c = 'テスト',
			ImporantMessage__c = 'テスト',
			ToiawaseDate__c = datetime.now(),
			ShiryohassosakiCity__c = '品川区',
			ShiryohassosakiZipCode__c = '141-0031',
			ShiryohassosakiState__c = '東京都',
			ShiryohassosakiStreet__c = '西五反田',
			ShiryoSoufuSakiMailAddress__c = 'test@test.com',
			ShiryoSoufuSakiAtena__c = '新規',
			ShiryoSoufuSakiAtenaKana__c = 'シンキ',
			ShiryoSoufuHoho__c = 'メール希望',
			ShiharaiHouhou__c = 'おきもち後払い',
			TaishoshaKyojuKeitai__c = null,
			TaishoshaYomeiKikan__c = null,
			ToiawaseKiinsha__c = null,
			// accountid=acc.id,
			RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Obosanbin').getRecordTypeId()
		);

		Test.startTest();
		insert newCase;
		Test.stopTest();
	}

	@isTest static void testCaseEtaikuyoShiryoseikyuWebForm(){
		
		TriggerIsActive__c TriggerIsActive=new TriggerIsActive__c();
		TriggerIsActive.name='default';
		TriggerIsActive.isActive__c=true;
		insert TriggerIsActive;
		
		Account acc=new Account(
			lastname='新規',
			FirstName='しんき',
			LastNameFurigana__pc ='defualt',
			FirstNameFurigana__pc ='defualt',
			Phone='080-0000-0001',
			MobilePhone__c='080-0000-0001',
			recordtypeid=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId()
		);
		insert acc;
		
		Case newCase = new Case(
			Status = '新規',
			Entrance__c = 'テスト',
			ImporantMessage__c = 'テスト',
			ToiawaseDate__c = datetime.now(),
			ShiryohassosakiCity__c = '品川区',
			ShiryohassosakiZipCode__c = '141-0031',
			ShiryohassosakiState__c = '東京都',
			ShiryohassosakiStreet__c = '西五反田',
			ShiryoSoufuSakiMailAddress__c = 'test@test.com',
			ShiryoSoufuSakiAtena__c = '新規',
			ShiryoSoufuSakiAtenaKana__c = 'シンキ',
			ShiryoSoufuHoho__c = 'メール希望',
			ShiharaiHouhou__c = 'おきもち後払い',
			TaishoshaKyojuKeitai__c = null,
			TaishoshaYomeiKikan__c = null,
			ToiawaseKiinsha__c = null,
			// accountid=acc.id,
			RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('EtaikuyoShiryoseikyuWebForm').getRecordTypeId()
		);

		Test.startTest();
		insert newCase;
		Test.stopTest();
	}

	@isTest static void testCasePerpetualMemorial(){
		
		TriggerIsActive__c TriggerIsActive=new TriggerIsActive__c();
		TriggerIsActive.name='default';
		TriggerIsActive.isActive__c=true;
		insert TriggerIsActive;
		
		Account acc=new Account(
			lastname='新規',
			FirstName='しんき',
			LastNameFurigana__pc ='defualt',
			FirstNameFurigana__pc ='defualt',
			Phone='080-0000-0001',
			MobilePhone__c='080-0000-0001',
			recordtypeid=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId()
		);
		insert acc;
		
		Case newCase = new Case(
			Status = '新規',
			Entrance__c = 'テスト',
			ImporantMessage__c = 'テスト',
			ToiawaseDate__c = datetime.now(),
			ShiryohassosakiCity__c = '品川区',
			ShiryohassosakiZipCode__c = '141-0031',
			ShiryohassosakiState__c = '東京都',
			ShiryohassosakiStreet__c = '西五反田',
			ShiryoSoufuSakiMailAddress__c = 'test@test.com',
			ShiryoSoufuSakiAtena__c = '新規',
			ShiryoSoufuSakiAtenaKana__c = 'シンキ',
			ShiryoSoufuHoho__c = 'メール希望',
			ShiharaiHouhou__c = 'おきもち後払い',
			TaishoshaKyojuKeitai__c = null,
			TaishoshaYomeiKikan__c = null,
			ToiawaseKiinsha__c = null,
			// accountid=acc.id,
			RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('PerpetualMemorial').getRecordTypeId()
		);

		Test.startTest();
		insert newCase;
		Test.stopTest();
	}

	@isTest static void testCaseBestButsudanOtoiawase(){
		
		TriggerIsActive__c TriggerIsActive=new TriggerIsActive__c();
		TriggerIsActive.name='default';
		TriggerIsActive.isActive__c=true;
		insert TriggerIsActive;
		
		Account acc=new Account(
			lastname='新規',
			FirstName='しんき',
			LastNameFurigana__pc ='defualt',
			FirstNameFurigana__pc ='defualt',
			Phone='080-0000-0001',
			MobilePhone__c='080-0000-0001',
			recordtypeid=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId()
		);
		insert acc;
		
		Case newCase = new Case(
			Status = '新規',
			Entrance__c = 'テスト',
			ImporantMessage__c = 'テスト',
			ToiawaseDate__c = datetime.now(),
			ShiryohassosakiCity__c = '品川区',
			ShiryohassosakiZipCode__c = '141-0031',
			ShiryohassosakiState__c = '東京都',
			ShiryohassosakiStreet__c = '西五反田',
			ShiryoSoufuSakiMailAddress__c = 'test@test.com',
			ShiryoSoufuSakiAtena__c = '新規',
			ShiryoSoufuSakiAtenaKana__c = 'シンキ',
			ShiryoSoufuHoho__c = 'メール希望',
			ShiharaiHouhou__c = 'おきもち後払い',
			TaishoshaKyojuKeitai__c = null,
			TaishoshaYomeiKikan__c = null,
			ToiawaseKiinsha__c = null,
			// accountid=acc.id,
			RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('BestButsudanOtoiawase').getRecordTypeId()
		);

		Test.startTest();
		insert newCase;
		Test.stopTest();
	}

	@isTest static void testCaseKyouka(){
		
		TriggerIsActive__c TriggerIsActive=new TriggerIsActive__c();
		TriggerIsActive.name='default';
		TriggerIsActive.isActive__c=true;
		insert TriggerIsActive;
		
		Account acc=new Account(
			lastname='新規',
			FirstName='しんき',
			LastNameFurigana__pc ='defualt',
			FirstNameFurigana__pc ='defualt',
			Phone='080-0000-0001',
			MobilePhone__c='080-0000-0001',
			recordtypeid=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId()
		);
		insert acc;
		
		Case newCase = new Case(
			Status = '新規',
			Entrance__c = 'テスト',
			ImporantMessage__c = 'テスト',
			ToiawaseDate__c = datetime.now(),
			ShiryohassosakiCity__c = '品川区',
			ShiryohassosakiZipCode__c = '141-0031',
			ShiryohassosakiState__c = '東京都',
			ShiryohassosakiStreet__c = '西五反田',
			ShiryoSoufuSakiMailAddress__c = 'test@test.com',
			ShiryoSoufuSakiAtena__c = '新規',
			ShiryoSoufuSakiAtenaKana__c = 'シンキ',
			ShiryoSoufuHoho__c = 'メール希望',
			ShiharaiHouhou__c = 'おきもち後払い',
			TaishoshaKyojuKeitai__c = null,
			TaishoshaYomeiKikan__c = null,
			ToiawaseKiinsha__c = null,
			// accountid=acc.id,
			RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Kyouka').getRecordTypeId()
		);

		Test.startTest();
		insert newCase;
		Test.stopTest();
	}

	@isTest static void testCaseKaiyoUmie(){
		
		TriggerIsActive__c TriggerIsActive=new TriggerIsActive__c();
		TriggerIsActive.name='default';
		TriggerIsActive.isActive__c=true;
		insert TriggerIsActive;
		
		Account acc=new Account(
			lastname='新規',
			FirstName='しんき',
			LastNameFurigana__pc ='defualt',
			FirstNameFurigana__pc ='defualt',
			Phone='080-0000-0001',
			MobilePhone__c='080-0000-0001',
			recordtypeid=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId()
		);
		insert acc;
		
		Case newCase = new Case(
			Status = '新規',
			Entrance__c = 'テスト',
			ImporantMessage__c = 'テスト',
			ToiawaseDate__c = datetime.now(),
			ShiryohassosakiCity__c = '品川区',
			ShiryohassosakiZipCode__c = '141-0031',
			ShiryohassosakiState__c = '東京都',
			ShiryohassosakiStreet__c = '西五反田',
			ShiryoSoufuSakiMailAddress__c = 'test@test.com',
			ShiryoSoufuSakiAtena__c = '新規',
			ShiryoSoufuSakiAtenaKana__c = 'シンキ',
			ShiryoSoufuHoho__c = 'メール希望',
			ShiharaiHouhou__c = 'おきもち後払い',
			TaishoshaKyojuKeitai__c = null,
			TaishoshaYomeiKikan__c = null,
			ToiawaseKiinsha__c = null,
			// accountid=acc.id,
			RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('KaiyoUmie').getRecordTypeId()
		);

		Test.startTest();
		insert newCase;
		Test.stopTest();
	}

	@isTest static void testCaseSpaceFuneral(){
		
		TriggerIsActive__c TriggerIsActive=new TriggerIsActive__c();
		TriggerIsActive.name='default';
		TriggerIsActive.isActive__c=true;
		insert TriggerIsActive;
		
		Account acc=new Account(
			lastname='新規',
			FirstName='しんき',
			LastNameFurigana__pc ='defualt',
			FirstNameFurigana__pc ='defualt',
			Phone='080-0000-0001',
			MobilePhone__c='080-0000-0001',
			recordtypeid=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId()
		);
		insert acc;
		
		Case newCase = new Case(
			Status = '新規',
			Entrance__c = 'テスト',
			ImporantMessage__c = 'テスト',
			ToiawaseDate__c = datetime.now(),
			ShiryohassosakiCity__c = '品川区',
			ShiryohassosakiZipCode__c = '141-0031',
			ShiryohassosakiState__c = '東京都',
			ShiryohassosakiStreet__c = '西五反田',
			ShiryoSoufuSakiMailAddress__c = 'test@test.com',
			ShiryoSoufuSakiAtena__c = '新規',
			ShiryoSoufuSakiAtenaKana__c = 'シンキ',
			ShiryoSoufuHoho__c = 'メール希望',
			ShiharaiHouhou__c = 'おきもち後払い',
			TaishoshaKyojuKeitai__c = null,
			TaishoshaYomeiKikan__c = null,
			ToiawaseKiinsha__c = null,
			// accountid=acc.id,
			RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SpaceFuneral').getRecordTypeId()
		);

		Test.startTest();
		insert newCase;
		Test.stopTest();
	}

	@isTest static void testCaseHakapitaHokatsutoiawase(){
		
		TriggerIsActive__c TriggerIsActive=new TriggerIsActive__c();
		TriggerIsActive.name='default';
		TriggerIsActive.isActive__c=true;
		insert TriggerIsActive;
		
		Account acc=new Account(
			lastname='新規',
			FirstName='しんき',
			LastNameFurigana__pc ='defualt',
			FirstNameFurigana__pc ='defualt',
			Phone='080-0000-0001',
			MobilePhone__c='080-0000-0001',
			recordtypeid=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId()
		);
		insert acc;
		
		Case newCase = new Case(
			Status = '新規',
			Entrance__c = 'テスト',
			ImporantMessage__c = 'テスト',
			ToiawaseDate__c = datetime.now(),
			ShiryohassosakiCity__c = '品川区',
			ShiryohassosakiZipCode__c = '141-0031',
			ShiryohassosakiState__c = '東京都',
			ShiryohassosakiStreet__c = '西五反田',
			ShiryoSoufuSakiMailAddress__c = 'test@test.com',
			ShiryoSoufuSakiAtena__c = '新規',
			ShiryoSoufuSakiAtenaKana__c = 'シンキ',
			ShiryoSoufuHoho__c = 'メール希望',
			ShiharaiHouhou__c = 'おきもち後払い',
			TaishoshaKyojuKeitai__c = null,
			TaishoshaYomeiKikan__c = null,
			ToiawaseKiinsha__c = null,
			// accountid=acc.id,
			RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('HakapitaHokatsutoiawase').getRecordTypeId()
		);

		Test.startTest();
		insert newCase;
		Test.stopTest();
	}

	@isTest static void testCaseKakuyasuBoseki(){
		
		TriggerIsActive__c TriggerIsActive=new TriggerIsActive__c();
		TriggerIsActive.name='default';
		TriggerIsActive.isActive__c=true;
		insert TriggerIsActive;
		
		Account acc=new Account(
			lastname='新規',
			FirstName='しんき',
			LastNameFurigana__pc ='defualt',
			FirstNameFurigana__pc ='defualt',
			Phone='080-0000-0001',
			MobilePhone__c='080-0000-0001',
			recordtypeid=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId()
		);
		insert acc;
		
		Case newCase = new Case(
			Status = '新規',
			Entrance__c = 'テスト',
			ImporantMessage__c = 'テスト',
			ToiawaseDate__c = datetime.now(),
			ShiryohassosakiCity__c = '品川区',
			ShiryohassosakiZipCode__c = '141-0031',
			ShiryohassosakiState__c = '東京都',
			ShiryohassosakiStreet__c = '西五反田',
			ShiryoSoufuSakiMailAddress__c = 'test@test.com',
			ShiryoSoufuSakiAtena__c = '新規',
			ShiryoSoufuSakiAtenaKana__c = 'シンキ',
			ShiryoSoufuHoho__c = 'メール希望',
			ShiharaiHouhou__c = 'おきもち後払い',
			TaishoshaKyojuKeitai__c = null,
			TaishoshaYomeiKikan__c = null,
			ToiawaseKiinsha__c = null,
			// accountid=acc.id,
			RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('KakuyasuBoseki').getRecordTypeId()
		);

		Test.startTest();
		insert newCase;
		Test.stopTest();
	}

	@isTest static void testCaseJizenwariWebMoshikomi(){
		
		TriggerIsActive__c TriggerIsActive=new TriggerIsActive__c();
		TriggerIsActive.name='default';
		TriggerIsActive.isActive__c=true;
		insert TriggerIsActive;
		
		Account acc=new Account(
			lastname='新規',
			FirstName='しんき',
			LastNameFurigana__pc ='defualt',
			FirstNameFurigana__pc ='defualt',
			Phone='080-0000-0001',
			MobilePhone__c='080-0000-0001',
			recordtypeid=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId()
		);
		insert acc;
		
		Case newCase = new Case(
			Status = '新規',
			Entrance__c = 'テスト',
			ImporantMessage__c = 'テスト',
			ToiawaseDate__c = datetime.now(),
			ShiryohassosakiCity__c = '品川区',
			ShiryohassosakiZipCode__c = '141-0031',
			ShiryohassosakiState__c = '東京都',
			ShiryohassosakiStreet__c = '西五反田',
			ShiryoSoufuSakiMailAddress__c = 'test@test.com',
			ShiryoSoufuSakiAtena__c = '新規',
			ShiryoSoufuSakiAtenaKana__c = 'シンキ',
			ShiryoSoufuHoho__c = 'メール希望',
			ShiharaiHouhou__c = 'おきもち後払い',
			TaishoshaKyojuKeitai__c = null,
			TaishoshaYomeiKikan__c = null,
			ToiawaseKiinsha__c = null,
			// accountid=acc.id,
			RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('JizenwariWebMoshikomi').getRecordTypeId()
		);

		Test.startTest();
		insert newCase;
		Test.stopTest();
	}

	@isTest static void testCaseSogiReviShiryoSeikyuWebForm(){
		
		TriggerIsActive__c TriggerIsActive=new TriggerIsActive__c();
		TriggerIsActive.name='default';
		TriggerIsActive.isActive__c=true;
		insert TriggerIsActive;
		
		Account acc=new Account(
			lastname='新規',
			FirstName='しんき',
			LastNameFurigana__pc ='defualt',
			FirstNameFurigana__pc ='defualt',
			Phone='080-0000-0001',
			MobilePhone__c='080-0000-0001',
			recordtypeid=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId()
		);
		insert acc;
		
		Case newCase = new Case(
			Status = '新規',
			Entrance__c = 'テスト',
			ImporantMessage__c = 'テスト',
			ToiawaseDate__c = datetime.now(),
			ShiryohassosakiCity__c = '品川区',
			ShiryohassosakiZipCode__c = '141-0031',
			ShiryohassosakiState__c = '東京都',
			ShiryohassosakiStreet__c = '西五反田',
			ShiryoSoufuSakiMailAddress__c = 'test@test.com',
			ShiryoSoufuSakiAtena__c = '新規',
			ShiryoSoufuSakiAtenaKana__c = 'シンキ',
			ShiryoSoufuHoho__c = 'メール希望',
			ShiharaiHouhou__c = 'おきもち後払い',
			TaishoshaKyojuKeitai__c = null,
			TaishoshaYomeiKikan__c = null,
			ToiawaseKiinsha__c = null,
			// accountid=acc.id,
			RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SogiReviShiryoSeikyuWebForm').getRecordTypeId()
		);

		Test.startTest();
		insert newCase;
		Test.stopTest();
	}
	
	@isTest static void testCaseOsoshikiYoyaku_SiryoSeikyu_Web(){
		
		TriggerIsActive__c TriggerIsActive=new TriggerIsActive__c();
		TriggerIsActive.name='default';
		TriggerIsActive.isActive__c=true;
		insert TriggerIsActive;
		
		Account acc=new Account(
			lastname='新規',
			FirstName='しんき',
			LastNameFurigana__pc ='defualt',
			FirstNameFurigana__pc ='defualt',
			Phone='080-0000-0001',
			MobilePhone__c='080-0000-0001',
			recordtypeid=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId()
		);
		insert acc;
		
		Case newCase = new Case(
			Status = '新規',
			Entrance__c = 'テスト',
			ImporantMessage__c = 'テスト',
			ToiawaseDate__c = datetime.now(),
			ShiryohassosakiCity__c = '品川区',
			ShiryohassosakiZipCode__c = '141-0031',
			ShiryohassosakiState__c = '東京都',
			ShiryohassosakiStreet__c = '西五反田',
			ShiryoSoufuSakiMailAddress__c = 'test@test.com',
			ShiryoSoufuSakiAtena__c = '新規',
			ShiryoSoufuSakiAtenaKana__c = 'シンキ',
			ShiryoSoufuHoho__c = 'メール希望',
			ShiharaiHouhou__c = 'おきもち後払い',
			TaishoshaKyojuKeitai__c = null,
			TaishoshaYomeiKikan__c = null,
			ToiawaseKiinsha__c = null,
			// accountid=acc.id,
			RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('OsoshikiYoyaku_SiryoSeikyu_Web').getRecordTypeId()
		);

		Test.startTest();
		insert newCase;
		Test.stopTest();
	}

	@isTest static void testSimpleYasugoJizenJunbiWebForm(){
		
		TriggerIsActive__c TriggerIsActive=new TriggerIsActive__c();
		TriggerIsActive.name='default';
		TriggerIsActive.isActive__c=true;
		insert TriggerIsActive;
		
		Account acc=new Account(
			lastname='新規',
			LastNameFurigana__pc ='defualt',
			FirstNameFurigana__pc ='defualt',
			Phone='080-0000-0001',
			MobilePhone__c='080-0000-0001',
			recordtypeid=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId()
		);
		insert acc;

		Case newCase = new Case(
			RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SimpleYasugoJizenJunbiWebForm').getRecordTypeId(),
			Status = '対応中',
			accountid=acc.id
		);
		Test.startTest();
		insert newCase;
		Test.stopTest();
	}
}