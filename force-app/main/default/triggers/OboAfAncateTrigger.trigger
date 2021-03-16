trigger OboAfAncateTrigger on OboAfAncate__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    if(Utility_Common.isDataIkouProfile()){return;}
    if(!TriggerIsActive__c.getOrgDefaults().isActive__c){return;}

    if(Trigger.isAfter && Trigger.isInsert) {
    	Map<String, Opportunity> theOpps = new Map<String, Opportunity>();

    	for(OboAfAncate__c aAncate : Trigger.new){
    		if(String.isBlank(aAncate.OppRef__c)) continue;
    		theOpps.put(
    			aAncate.OppRef__c, 
    			new Opportunity(Id = aAncate.OppRef__c, OboAfAncateRef__c = aAncate.Id)
			);
    	}
    	UPDATE theOpps.values();
    }

     if(Trigger.isAfter && Trigger.isUpdate) {
    	Map<String, Opportunity> theOpps = new Map<String, Opportunity>();

    	for(OboAfAncate__c aAncate : Trigger.new){
    		if(String.isBlank(aAncate.OppRef__c)) continue;
    		theOpps.put(
    			aAncate.OppRef__c, 
    			new Opportunity(Id = aAncate.OppRef__c, OboAfAncateRef__c = aAncate.Id)
			);
    	}
    	UPDATE theOpps.values();
    }

}