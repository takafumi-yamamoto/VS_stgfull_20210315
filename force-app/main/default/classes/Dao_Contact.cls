public class Dao_Contact {

	static public Contact getContactByContactId(String contactId){
        return [SELECT Id, LastName, FirstName, LastNameFurigana__c, FirstNameFurigana__c, Phone, Email, Title, AccountId FROM Contact WHERE Id =: contactId];
    }

	static public List<Contact> getContactListByContactIdList(List<ID> contactIdList){
        return [SELECT Id, AccountId FROM Contact WHERE Id =: contactIdList];
    }

    static public List<Contact> getContactListByAccountIdList(Set<ID> accountIdList){
        return [SELECT Id, LastName, FirstName, Account.MailAddress__c, LastNameFurigana__c, FirstNameFurigana__c, Phone, MobilePhone FROM Contact WHERE AccountId =: accountIdList];
    }

    static public Map<ID, Contact> getIsPersonAccountContactByContactIdList(List<ID> contactIdSet){
        return new Map<ID, Contact>([select Id, AccountId from Contact where Id = :contactIdSet and IsPersonAccount = true]);
    }
}