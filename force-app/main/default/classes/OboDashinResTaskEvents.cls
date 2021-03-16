public class OboDashinResTaskEvents {

    public class CreateRejectedEventArg{
        public Datetime HoyoKohoDatetime1;
        public Datetime HoyoKohoDatetime2;
        public Datetime HoyoKohoDatetime3;
        public Datetime TsuyaDatetime;
        public Datetime KokubetsuDatetime;
        public Datetime KasoDatetime;
        public List<String> RejectedKeiyakuBangos = new List<String>();
        public String DashinIraiId;
        public String OwnerId;
    }
    public List<Event> createRejectedEvents(CreateRejectedEventArg pArg){

        List<Event> theRejectedEvents = new List<Event>();

        SET<Id> theRejectedAccountIds = new SET<Id>();
        for(Keiyaku__c aKeiyaku : [ SELECT Id, Teikeisaki__c FROM Keiyaku__c WHERE KeiyakuBango__c IN :pArg.RejectedKeiyakuBangos ])
        { theRejectedAccountIds.add(aKeiyaku.Teikeisaki__c); }

        SET<Id> theRejectedContactIds = new SET<Id>();
        for(Contact aContact : [ SELECT Id FROM Contact WHERE AccountId IN :theRejectedAccountIds ])
        { theRejectedContactIds.add(aContact.Id); }

        for(Id aContactId : theRejectedContactIds){
            if( pArg.HoyoKohoDatetime1 != null) {
                Duration theEventDuration = this.createHoyoEvnetDuration(pArg.HoyoKohoDatetime1);
                theRejectedEvents.add( this.createRejectedEvent(aContactId, pArg.DashinIraiId, pArg.OwnerId, theEventDuration.StartDatetime, theEventDuration.EndDatetime) );
            }
            if( pArg.HoyoKohoDatetime2 != null ){
                Duration theEventDuration = this.createHoyoEvnetDuration(pArg.HoyoKohoDatetime2);
                theRejectedEvents.add( this.createRejectedEvent(aContactId, pArg.DashinIraiId, pArg.OwnerId, theEventDuration.StartDatetime, theEventDuration.EndDatetime) );
            }
            if( pArg.HoyoKohoDatetime3 != null ){
                Duration theEventDuration = this.createHoyoEvnetDuration(pArg.HoyoKohoDatetime3);
                theRejectedEvents.add( this.createRejectedEvent(aContactId, pArg.DashinIraiId, pArg.OwnerId, theEventDuration.StartDatetime, theEventDuration.EndDatetime) );
            }
            if( pArg.TsuyaDatetime != null ){
                Duration theEventDuration = this.createSogiEventDuration(pArg.TsuyaDatetime);
                theRejectedEvents.add( this.createRejectedEvent(aContactId, pArg.DashinIraiId, pArg.OwnerId, theEventDuration.StartDatetime, theEventDuration.EndDatetime) );
            }
            if( pArg.KokubetsuDatetime != null ){
                Duration theEventDuration = this.createSogiEventDuration(pArg.KokubetsuDatetime);
                theRejectedEvents.add( this.createRejectedEvent(aContactId, pArg.DashinIraiId, pArg.OwnerId, theEventDuration.StartDatetime, theEventDuration.EndDatetime) );
            }
            if( pArg.KasoDatetime != null ){
                Duration theEventDuration = this.createSogiEventDuration(pArg.KasoDatetime);
                theRejectedEvents.add( this.createRejectedEvent(aContactId, pArg.DashinIraiId, pArg.OwnerId, theEventDuration.StartDatetime, theEventDuration.EndDatetime) );
            }
        }
        return theRejectedEvents;
    }

    private Boolean isTimeNotSpecified(Datetime pDatetime){
        return pDatetime.hour() == 0 && pDatetime.minute() == 0;
    }

    private class Duration{ Datetime StartDatetime; Datetime EndDatetime; }

    private Duration createHoyoEvnetDuration(Datetime pStart){
        Duration theDuration = new Duration();
        if( this.isTimeNotSpecified(pStart) ){
            theDuration.StartDatetime = Datetime.newInstance(pStart.year(), pStart.month(), pStart.day(), 0,0,0);
            theDuration.EndDatetime = Datetime.newInstance(pStart.year(), pStart.month(), pStart.day(), 23,59,59);
            return theDuration;
        }
        theDuration.StartDatetime = pStart;
        theDuration.EndDatetime = pStart.addHours(1);
        return theDuration;
    }
    private Duration createSogiEventDuration(Datetime pStart){
        Duration theDuration = new Duration();
        theDuration.StartDatetime = pStart;
        theDuration.EndDatetime = pStart.addHours(1);
        return theDuration;
    }

    private Event createRejectedEvent(String pContactId, String pWhatId, String pOwnerId, Datetime pStartDateTime, Datetime pEndDateTime){
        return new Event(
            RecordTypeId = Schema.SObjectType.Event.getRecordTypeInfosByDeveloperName().get('TsujoEvent').getRecordTypeId(),
            WhoId = pContactId,
            WhatId = pWhatId,
            Subject = '打診結果NG',
            StartDateTime = pStartDateTime,
            EndDateTime = pEndDateTime,
            Type = 'その他',
            ShowAs = 'Busy',
            EventSubtype = 'Event',
            Kaisu__c = 1,
            Kijitsu__c = pEndDateTime,
            OwnerId = pOwnerId
        );
    }
}