@isTest
public class Ctl_Obosanbin_SyncToOppTest {

    static testMethod void testMethod1() {
		SampleData sd = new SampleData();
		sd.buildMaster();
		List<Opportunity> opps = sd.buildObosanbinOpp();

        RecordType defualtAccountRT = new RecordTypeDao().selectRecordBySobjectTypeDeveloperName('Account', 'Customer');
		Account dacc = new Account();
		dacc.LastName = 'Sampleお客様';
		dacc.Phone = '081-2019-0003';
		dacc.MobilePhone__c = '082-2019-0003';
		dacc.recordTypeId = defualtAccountRT.Id;
		insert dacc;


        TriggerIsActive__c TriggerIsActive=new TriggerIsActive__c();
        TriggerIsActive.name='default';
        TriggerIsActive.isActive__c=true;
        insert TriggerIsActive;

		Test.startTest();

		System.debug('>>>>>>>>>>>>>>>>>>>>>>>>');
        List<Obosanbin__c> oboList = [select id From Obosanbin__c limit 1];
        oboList[0].Taishosha1Ref__c = dacc.Id;
        update oboList;

        insert oboList[0].clone(false, false, false, false);

		Test.stopTest();
    }
}