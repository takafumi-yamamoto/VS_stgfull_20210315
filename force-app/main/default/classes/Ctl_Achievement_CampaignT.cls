@isTest
public class Ctl_Achievement_CampaignT {

	@isTest static void testCase1(){

		
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

		Account acc2=new Account(
			lastname='新規に',
			FirstName='しんきに',
			LastNameFurigana__pc ='defualtw',
			FirstNameFurigana__pc ='defualtw',
			Phone='070-0000-0001',
			MobilePhone__c='070-0000-0001',
			MemberTourokuZumi__c = True,
			recordtypeid=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId()
		);
		insert acc2;

		Date testDate = date.today();

		List<String> Listcampaign_id = new List<String>();
		Listcampaign_id.add('campaign_sougi_bouquet');

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
			ShiryoSoufuSakiAtena__c = '新規に',
			ShiryoSoufuSakiAtenaKana__c = 'シンキニ',
			ShiryoSoufuHoho__c = 'メール希望',
			ShiharaiHouhou__c = 'おきもち後払い',
			TaishoshaKyojuKeitai__c = null,
			TaishoshaYomeiKikan__c = null,
			ToiawaseKiinsha__c = null,
			accountid=acc2.id,
			CampaignMoshikomiName__c = String.join(Listcampaign_id, ';'),
			RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SimpleYasugoShiryoSeikyuWebForm').getRecordTypeId()
		);

		Test.startTest();
		insert newCase;
		Test.stopTest();
	}
}