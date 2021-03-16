trigger WepPayKekkaUketsukeTaskTrigger on WepPayKekkaUketsukeTask__c (after insert) {
    if(Utility_Common.isDataIkouProfile()){return;}
    //if(!TriggerIsActive__c.getOrgDefaults().isActive__c){return;}
    
    
    if(Trigger.isInsert && Trigger.isAfter){
        System.debug('----Insert_After----');

		for(WepPayKekkaUketsukeTask__c aTask : Trigger.new){
			WepPayKekkaUketsukeTaskProcessor taskProcessor = new WepPayKekkaUketsukeTaskProcessor(aTask);
			System.enqueueJob(taskProcessor);
		}
    }
}