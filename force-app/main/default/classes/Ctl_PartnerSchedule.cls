public class Ctl_PartnerSchedule {

    public List<Event> events {get; set;}

    public Ctl_PartnerSchedule(ApexPages.StandardController stdController) {
        Account tempAcct = (Account)stdController.getRecord();
        Account acct = [select Id, (select Id from Contacts) from Account where Id = :tempAcct.Id];
        String contactId = '';
        if(acct.Contacts.size() > 0){
        	contactId = acct.Contacts.get(0).Id;
        }

        events = [select Id, Subject, isAllDayEvent, StartDateTime, EndDateTime from Event where WhoId = :contactId or AtesakiRef__c = :acct.Id];
    }
}