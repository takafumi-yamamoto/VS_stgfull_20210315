public class Trg_Event {

    public Trg_Event(){}

    public void OnBeforeInsert(List<Event> newEventList, Map<ID, Event> oldEventMap){
        new Ctl_Event().initialProcessing(newEventList, oldEventMap);
    }
    
	public void OnAfterInsert(List<Event> newEventList){
        new OboStSynVer().OnPartnerEventAfterInsert(newEventList);
    }
	public void OnAfterUpdate(List<Event> newEventList, Map<ID, Event> oldEventMap){
        new OboStSynVer().OnPartnerEventAfterUpdated(newEventList, oldEventMap);
    }
	public void OnAfterDelete(List<Event> oldEventList, Map<ID, Event> oldEventMap){
        new OboStSynVer().OnPartnerEventAfterDeleted(oldEventList);
    }

}