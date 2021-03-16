public class EventOperation {

    public class EventScheduleHistory {
        @AuraEnabled public Event evt = new Event();
        @AuraEnabled public String soryoId = '';
    }

    @AuraEnabled
    public static List<EventScheduleHistory> auraGetEventHistorys(String recordId) {
        List<EventScheduleHistory> eshList = new List<EventScheduleHistory>();
        List<Event> evtList = [select Id, Subject, Description, WhoId, Who.Name, StartDateTime, EndDateTime, WhatId, CreatedDate, CreatedById, CreatedBy.Name, LastModifiedDate, LastModifiedBy.Name from Event where WhatId = :recordId order by StartDateTime ALL ROWS];
        Set<ID> contactIdSet = new Set<ID>();
        for(Event e : evtList){
            if(e.WhoId != null){
                contactIdSet.add(e.WhoId);
            }
        }

        Map<ID, Contact> soryoIdMap = new Map<ID, Contact>([select Id, AccountId from Contact where Id =: contactIdSet]);
        for(Event e : evtList){
            EventScheduleHistory esh = new EventScheduleHistory();
            esh.evt = e;
            if(soryoIdMap.containskey(e.WhoId)){
                esh.soryoId = soryoIdMap.get(e.WhoId).AccountId;
            }
            eshList.add(esh);
        }

        return eshList;
    }
}