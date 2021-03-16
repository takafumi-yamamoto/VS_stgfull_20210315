public class Ctl_Contact {

	public void initialProcessing(List<Contact> newList, Map<ID, Contact> oldMap){

		ID rtTeikeisakiSoryoId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Teikeisaki_Soryo').getRecordTypeId();
		List<ID> accountIdList = new List<ID>();
		for(Contact newContact : newList){
			if(newContact.RecordTypeId == rtTeikeisakiSoryoId && 
				(oldMap == null || newContact.AccountId != oldMap.get(newContact.Id).AccountId)){
				accountIdList.add(newContact.AccountId);
			}
		}

		Map<ID, Account> sltAccountMap = new Map<ID, Account>([select Id, (select Id from Contacts) from Account where Id = :accountIdList]);
		for(Contact newContact : newList){
			if(sltAccountMap.containsKey(newContact.AccountId) && sltAccountMap.get(newContact.AccountId).Contacts.size() > 0){
				newContact.addError('提携先僧侶は既に登録されています');
			}
		}
	}
}