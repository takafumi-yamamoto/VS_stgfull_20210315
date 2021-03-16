@isTest
public class Tes_Event {

	static testMethod void testMethod_Event(){

		List<Account> soryoList = new List<Account>();
		id redtpId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','SoryoAccount'); 
        Account acc1 = new Account();
        acc1.Name = '窓口 僧侶';
        acc1.recordtypeid = redtpId;
        soryoList.add(acc1);

        Account acc2 = new Account();
        acc2.Name = '施行 僧侶';
        acc2.recordtypeid = redtpId;
        soryoList.add(acc2);
		insert soryoList;

		TriggerIsActive__c TriggerIsActive=new TriggerIsActive__c();
		TriggerIsActive.name='default';
		TriggerIsActive.isActive__c=true;
		insert TriggerIsActive;

        Keiyaku__c keiyaku1 = new Keiyaku__c();
		keiyaku1.recordtypeid = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Keiyaku__c','Obosanbin');
		keiyaku1.Name = '窓口 僧侶_お坊さん便';
		keiyaku1.Teikeisaki__c = acc2.id;
		keiyaku1.KeiyakuJokyo__c = '契約中';
		keiyaku1.Keiyakukaishibi__c = system.today();
		insert keiyaku1;

		Keiyaku__c keiyaku2 = new Keiyaku__c();
		keiyaku2.recordtypeid = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Keiyaku__c','ObousanBinJohouSya');
		keiyaku2.Name = '施行 僧侶_お坊さん便助法者';
		keiyaku2.Teikeisaki__c = acc2.id;
		keiyaku2.KeiyakuJokyo__c ='契約中';
		keiyaku2.Keiyakukaishibi__c = system.today();
		keiyaku2.SyuKeiyakuRef__c = keiyaku1.Id;
		insert keiyaku2;


		Test.startTest();

        Event event = new Event();
        event.Subject = '予定あり';
        event.WhatId = acc2.Id;
        event.StartDateTime = Datetime.now();
        event.EndDateTime = Datetime.now();
        event.OwnerId = UserInfo.getUserId();
        insert event;

		Test.stopTest();
	}
}