@isTest
public class Tes_LocAfTesuryoSeikyuLineCalc {

	@testSetup
	static void initializeTestData() {
 
		Account dacc = new Account();
		dacc.LastName = 'xxxdefualt';
		dacc.Phone = '088-0000-0001';
		dacc.MobilePhone__c = '888-0000-0001';
		dacc.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId();
		insert dacc;

		// カスタム設定のTriggerIsActive__cのデータを作成
		TriggerIsActive__c TriggerIsActive = new TriggerIsActive__c();
		TriggerIsActive.name = 'default';
		TriggerIsActive.isActive__c = true;
		insert TriggerIsActive;
		JizenWariPlan__c JizenWariPlan = new JizenWariPlan__c();
		JizenWariPlan.Code__c = 'Yoriso';
		insert JizenWariPlan;		

		// 取引先のデータ作成
		Account acc = new Account();
		acc.name = 'defualt';
		acc.Phone = '080-0000-0001';
		acc.MobilePhone__c = '080-0000-0001';
		insert acc;
		
		opportunity opp = new opportunity();
		opp.accountid = acc.id;
		opp.Name = 'test';
		opp.StageName = '商談開始';
		opp.CloseDate = Date.today();
		opp.TaishoushaJokyo__c = '_';
		opp.recordtypeid = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId();
		insert opp;

		OkyakusamaSeikyuMeisai__c OkyakusamaSeikyuMeisai = new OkyakusamaSeikyuMeisai__c(
			OpportunityRef__c = opp.id,
			ServiceSyubetsu__c = 'シンプル安豪',
			SeikyuHouhou__c = 'パートナー回収',
			RecordTypeId = Schema.SObjectType.OkyakusamaSeikyuMeisai__c.getRecordTypeInfosByDeveloperName().get('KobetsuSeikyu').getRecordTypeId(),
			SeikyuKingaku__c = 489300,
			Kessaibi__c = Date.today(),
			SeikyuHohoCode__c = '1'
		);
		insert OkyakusamaSeikyuMeisai;
	}

	static testMethod void testInsert(){
		

		Opportunity opp = [SELECT Id, Name, TesuryoKeisanzumi__c FROM Opportunity WHERE Name = 'test'];
		opp.TesuryoKeisanzumi__c = true;
		Update opp;


		OkyakusamaSeikyuMeisai__c OkyakusamaSeikyuMeisai = new OkyakusamaSeikyuMeisai__c(
			OpportunityRef__c = opp.id,
			ServiceSyubetsu__c = 'シンプル安豪',
			SeikyuHouhou__c = 'パートナー回収',
			RecordTypeId = Schema.SObjectType.OkyakusamaSeikyuMeisai__c.getRecordTypeInfosByDeveloperName().get('KobetsuSeikyu').getRecordTypeId(),
			SeikyuKingaku__c = 489300,
			Kessaibi__c = Date.today(),
			SeikyuHohoCode__c = '1'
		);
		try{
			insert OkyakusamaSeikyuMeisai;
		}catch(Exception e){}
		LocAfTesuryoSeikyuLineCalc.turnOffLockRule();
		insert OkyakusamaSeikyuMeisai;
		LocAfTesuryoSeikyuLineCalc.turnOnLockRule();

	}

	static testMethod void testUpdate(){
		

		Opportunity opp = [SELECT Id, Name, TesuryoKeisanzumi__c FROM Opportunity WHERE Name = 'test'];
		opp.TesuryoKeisanzumi__c = true;
		Update opp;

		List<OkyakusamaSeikyuMeisai__c> targetSeikyuMeisais = [SELECT Id,
																SeikyuKingaku__c 
																FROM OkyakusamaSeikyuMeisai__c
																WHERE OpportunityRef__c = :opp.id];

		for(OkyakusamaSeikyuMeisai__c target : targetSeikyuMeisais){
			target.SeikyuKingaku__c = 999999;
		}

		try{
			Update targetSeikyuMeisais;
		}catch(Exception e){}
		LocAfTesuryoSeikyuLineCalc.turnOffLockRule();
		Update targetSeikyuMeisais;
		LocAfTesuryoSeikyuLineCalc.turnOnLockRule();
	}

	static testMethod void testDelete(){
		

		Opportunity opp = [SELECT Id, Name, TesuryoKeisanzumi__c FROM Opportunity WHERE Name = 'test'];
		opp.TesuryoKeisanzumi__c = true;
		Update opp;

		List<OkyakusamaSeikyuMeisai__c> targetSeikyuMeisais = [SELECT Id,
																SeikyuKingaku__c 
																FROM OkyakusamaSeikyuMeisai__c
																WHERE OpportunityRef__c = :opp.id];

		try{
			Delete targetSeikyuMeisais;
		}catch(Exception e){}
		LocAfTesuryoSeikyuLineCalc.turnOffLockRule();
		Delete targetSeikyuMeisais;
		LocAfTesuryoSeikyuLineCalc.turnOnLockRule();
	}

}