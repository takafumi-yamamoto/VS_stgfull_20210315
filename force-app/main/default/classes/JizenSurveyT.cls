@isTest
public class JizenSurveyT {

	static testMethod void testCase1(){
		
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
		
		Account acc2=new Account(
			lastname='TEST',
			LastNameFurigana__pc ='defualt',
			FirstNameFurigana__pc ='defualt',
			Phone='090-0120-0001',
			MobilePhone__c='090-0120-0001',
			recordtypeid=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId()
		);
		insert acc2;

		Case newCase = new Case(
			RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SimpleYasugoJizenJunbiWebForm').getRecordTypeId(),
			Status = '対応中',
			accountid=acc2.id
		);
		Test.startTest();
		insert newCase;
		Test.stopTest();
	}

	static testMethod void testCase2(){
		
		TriggerIsActive__c TriggerIsActive=new TriggerIsActive__c();
		TriggerIsActive.name='default';
		TriggerIsActive.isActive__c=true;
		insert TriggerIsActive;

		TodoufuKen__c TodoufuKen = new TodoufuKen__c(
			Name = '東京都',
			PKey__c = '東京都',
			KenCode__c = '13'
		);
		insert TodoufuKen;

		Shikugun__c Shikugun = new Shikugun__c(
			Name = '東京都品川区',
			TodoufuKenRef__c = TodoufuKen.id,
			AreaCode__c = '13109',
			ShikugunMei__c = '品川区',
			ShikugunMeiFurigana__c = 'しながわく'
		);
		insert Shikugun;

		Account acc=new Account(
			lastname='新規',
			LastNameFurigana__pc ='defualt',
			FirstNameFurigana__pc ='defualt',
			Phone='080-0000-0001',
			MobilePhone__c='080-0000-0001',
			recordtypeid=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId()
		);
		insert acc;

		Account acc2=new Account(
			lastname='TEST',
			LastNameFurigana__pc ='defualt',
			FirstNameFurigana__pc ='defualt',
			Phone='090-0120-0001',
			MobilePhone__c='090-0120-0001',
			recordtypeid=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId()
		);
		insert acc2;

		Opportunity Opp = new Opportunity(
			AccountId = acc2.id,
			RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId(),
			Name = 'TEST_商談',
			StageName = 'フォロー', 
			CloseDate = date.Today());
		insert opp;

		Case newCase = new Case(
			RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SimpleYasugoJizenJunbiWebForm').getRecordTypeId(),
			Status = '対応中',
			ShiryoSoufuHoho__c = 'メール希望',
			OmukaesakiZipCode__c = '141-0031',
			OmukaesakiState__c = '東京都',
			OmukaesakiCity__c = '品川区',
			OmukaesakiStreet__c = '西五反田',
			KiboAreaState__c = '東京都',
			KiboAreaCity__c = '品川区',
			AnchiKubun__c = '自宅安置',
			ObosanbinOption__c = '葬儀読経＋戒名授与',
			accountid=acc2.id
		);
		
		Test.startTest();
		insert newCase;
		Test.stopTest();
	}

	static testMethod void testCase3(){
		
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

		Account acc2=new Account(
			lastname='TEST',
			LastNameFurigana__pc ='defualt',
			FirstNameFurigana__pc ='defualt',
			Phone='090-0120-0001',
			MobilePhone__c='090-0120-0001',
			recordtypeid=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId()
		);
		insert acc2;

		Opportunity Opp = new Opportunity(
			AccountId = acc2.id,
			RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId(),
			Name = 'TEST_商談',
			StageName = 'フォロー', 
			CloseDate = date.Today());
		insert opp;

		Case newCase = new Case(
			RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SimpleYasugoJizenJunbiWebForm').getRecordTypeId(),
			Status = '対応中',
			ShiryoSoufuHoho__c = '郵送希望',
			OmukaesakiZipCode__c = '141-0031',
			OmukaesakiState__c = '東京都',
			OmukaesakiCity__c = '品川区',
			OmukaesakiStreet__c = '西五反田',
			AnchiKubun__c = '葬儀社預かり安置',
			ObosanbinOption__c = 'なし',
			accountid=acc2.id
		);
		
		Test.startTest();
		insert newCase;
		Test.stopTest();
	}

	static testMethod void testCase4(){
		
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

		Account acc2=new Account(
			lastname='TEST',
			LastNameFurigana__pc ='defualt',
			FirstNameFurigana__pc ='defualt',
			Phone='090-0120-0001',
			MobilePhone__c='090-0120-0001',
			recordtypeid=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId()
		);
		insert acc2;

		Opportunity Opp = new Opportunity(
			AccountId = acc2.id,
			RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId(),
			Name = 'TEST_商談',
			StageName = 'フォロー', 
			CloseDate = date.Today());
		insert opp;

		Case newCase = new Case(
			RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SimpleYasugoJizenJunbiWebForm').getRecordTypeId(),
			Status = '対応中',
			ShiryoSoufuHoho__c = '郵送希望',
			OmukaesakiZipCode__c = '141-0031',
			OmukaesakiState__c = '東京都',
			OmukaesakiCity__c = '品川区',
			OmukaesakiStreet__c = '西五反田',
			ObosanbinOption__c = '葬儀読経のみ',
			accountid=acc2.id
		);
		
		Test.startTest();
		insert newCase;
		Test.stopTest();
	}

	static testMethod void testCase5(){
		
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

		Account acc2=new Account(
			lastname='TEST',
			LastNameFurigana__pc ='defualt',
			FirstNameFurigana__pc ='defualt',
			Phone='090-0120-0001',
			MobilePhone__c='090-0120-0001',
			recordtypeid=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId()
		);
		insert acc2;

		Opportunity Opp = new Opportunity(
			AccountId = acc2.id,
			RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId(),
			Name = 'TEST_商談',
			StageName = 'フォロー', 
			CloseDate = date.Today());
		insert opp;

		Opportunity Opp2 = new Opportunity(
			AccountId = acc2.id,
			RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId(),
			Name = 'TEST_商談2',
			StageName = 'フォロー', 
			CloseDate = date.Today());
		insert opp2;

		Case newCase = new Case(
			RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SimpleYasugoJizenJunbiWebForm').getRecordTypeId(),
			Status = '対応中',
			accountid=acc2.id
		);
		
		Test.startTest();
		insert newCase;
		Test.stopTest();
	}
}