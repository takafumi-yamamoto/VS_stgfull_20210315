/**
run batch:

Database.executeBatch(new NayoseDataBatch());

*/
global class NayoseDataBatch implements Database.Batchable<sObject> {
	
	String query;
	
	global NayoseDataBatch() {
        ID rtCustomerAccountId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
		query = 'Select id, Phone, MobilePhone__c, MailAddress__c, MailAddress2__c From Account Where RecordTypeId = \'' + rtCustomerAccountId + '\'';
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<Account> accountList) {
   		Nayose nayose = new Nayose();
   		for(Account acc : accountList){
                String thePhoneKey = nayose.genTelNoKey(acc.Phone);
                String theMobilePhoneKey = nayose.genTelNoKey(acc.MobilePhone__c);
                String theMailAddressKey = nayose.genMailKey(acc.MailAddress__c);
                String theMailAddress2Key = nayose.genMailKey(acc.MailAddress2__c);
                acc.NayosePhone1__c = sortNayoseKey(thePhoneKey,theMobilePhoneKey).get(0);
                acc.NayosePhone2__c = sortNayoseKey(thePhoneKey,theMobilePhoneKey).get(1);
                acc.NayoseMailAddress__c = sortNayoseKey(theMailAddressKey,theMailAddress2Key).get(0);
                acc.NayoseMailAddress2__c = sortNayoseKey(theMailAddressKey,theMailAddress2Key).get(1);
                System.debug(acc);
   		}
   		update accountList;
	}
	
	global void finish(Database.BatchableContext BC) {
		
	}

    global List<String> sortNayoseKey(String pVal1, String pVal2){
        List<String> result = new List<String>();

        if(String.isBlank(pVal1)){
            result.add(pVal2);
            result.add(pVal2);
        } else if(String.isBlank(pVal2)) {
            result.add(pVal1);
            result.add(pVal1);
        } else {
            result.add(pVal1);
            result.add(pVal2);
            result.sort();
        }
        return result;
    }

}