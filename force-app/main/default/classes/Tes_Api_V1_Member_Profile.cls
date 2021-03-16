@isTest
private class Tes_Api_V1_Member_Profile {
	static testMethod void testMethod1() {
		
		Account aDefo = new Account(RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId(),
									FirstName = '_',
									LastName = '_');
		
		Database.SaveResult lsraDefo = Database.insert(aDefo);
		
		Account a1 = new Account(
							RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId(),
							FirstName = '相談者',
							LastName = '_',
							MemberTourokuZumi__c = true,
							JizenJizenSheetTeishutsuzumi__c = true
						);
		
		Database.SaveResult lsra1 = Database.insert(a1);
		
		String torihikisakiBango = '';
		Account a2 = [SELECT Id, TorihikisakiBango__c FROM Account WHERE Id = :lsra1.getid()];
		torihikisakiBango = a2.TorihikisakiBango__c;
		
		Date testDate = date.today();
		
		Achievement__c sAchievement = new Achievement__c(
			Syubetsu__c = 'campaign_sougi',
			YukoKaishiBi__c = testDate,
			YukoFlag__c = true,
			TorihikiSakiRef__c = lsra1.getid(),
			BaitaiToroku__c = 'Web',
			YukoShuryoBi__c = testDate.addDays(30)
			);
		insert sAchievement;
		
		Test.startTest();
		
		RestRequest req = new RestRequest();
		RestResponse res = new RestResponse();
		
		req.requestURI = '/services/apexrest/api/v1/member/profile/';
		req.httpMethod = 'GET';
		req.params.put('custcd', torihikisakiBango);
		
		RestContext.request = req;
		RestContext.response= res;
		
		Api_V1_Member_Profile.doGet();
		
		Test.stopTest();
	}

}