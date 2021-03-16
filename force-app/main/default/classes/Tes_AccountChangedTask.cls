@isTest
private class Tes_AccountChangedTask {
    static testMethod void testMethod1() {
        RecordType defualtAccountRT = new RecordTypeDao().selectRecordBySobjectTypeDeveloperName('Account', 'null');
		Account dacc = new Account();
		dacc.LastName = 'xxxdefualt';
		dacc.Phone = '088-0000-0001';
		dacc.MobilePhone__c = '888-0000-0001';
		dacc.recordTypeId = defualtAccountRT.Id;
		insert dacc;
		
        TriggerIsActive__c TriggerIsActive=new TriggerIsActive__c();
        TriggerIsActive.name='default';
        TriggerIsActive.isActive__c=true;
        insert TriggerIsActive;

        

        AccountChangedTask__c sobj = new AccountChangedTask__c();
        sobj.Opportunity__c = null;    // 商談
        sobj.OldAccount__c = null;    // 旧お客様・提携先
        sobj.NewAccount__c = null;    // お客様・提携先
        sobj.ShoriStatus__c = '未処理';
        insert sobj;
    }
}