public class Ctl_Lead {

	public void initialProcessing(List<Lead> newList, Map<ID, Lead> oldMap){

		Map<Id,Schema.RecordTypeInfo> rtMapById = Schema.SObjectType.Lead.getRecordTypeInfosById();
		for(Lead newLead : newList){
			if(oldMap == null && rtMapById.get(newLead.RecordTypeId).getDeveloperName() == 'Teikeisaki_Soryo'){
				newLead.Company = newLead.LastName + ' ' + newLead.FirstName;
			}
		}
	}

	public void startTrading(List<Lead> newList, Map<ID, Lead> oldMap){

		List<Account> updateAccountList = new List<Account>();
		ID rtId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('Teikeisaki_Soryo').getRecordTypeId();
		for(Lead newLead : newList){
			if(newLead.RecordTypeId == rtId && newLead.IsConverted && !oldMap.get(newLead.Id).IsConverted){
				updateAccountList.add(new Account(Id=newLead.ConvertedAccountId,
													MobilePhone__c=newLead.MobilePhone,
													MailAddress__c=newLead.Email)
										);
			}
		}
		update updateAccountList;
	}
}