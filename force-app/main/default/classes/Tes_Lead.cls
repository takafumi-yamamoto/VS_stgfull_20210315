@isTest
private class Tes_Lead {
    static testMethod void testMethod1() {

    	TriggerIsActive__c customSetting = new TriggerIsActive__c(Name = 'defualt',isActive__c = true);
		insert customSetting;
		
    	ID rtSoryoAccountId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('Teikeisaki_Soryo').getRecordTypeId();
    	Lead l = new Lead();
    	l.LastName = '僧侶';
    	l.FirstName = 'テスト';
    	l.RecordTypeId = rtSoryoAccountId;
    	insert l;
    }
}