public class OboDashinResTaskFlb implements Schedulable{
	public void execute(SchedulableContext context) {
		try{
			//unschedule me.
	        System.abortJob( context.getTriggerId() );

	        this.run();

	        //reschedule new one.
	        this.scheduleNew();

		}catch(Exception e){
            Loggings.writeLog(
                Loggings.createLogEntry(Loggings.Level.Error, '20190606-1336-01', 'OboDashinResTaskFlb.ScheduleRunFailed', 're-shedule needed.')
                	.putAttr('e.getMessage()', e.getMessage())
            );
		}
	}

	public void scheduleNew(){
        Integer theInterval = 15;
		String theNextTimeCron = DateTime.now().addMinutes(theInterval).format('s m H d M ? y');
        System.schedule('OboDashinResTaskFlb-お坊さん便/打診結果取込TaskFlb' + '(' + theNextTimeCron + ')', theNextTimeCron, new OboDashinResTaskFlb() );
	}

	public void run(){
		List<OboDashinResTask__c> theTasks = [
			select Id
			from OboDashinResTask__c
			where ShoriStatus__c = 'Created'
			and CreatedDate >= :DateTime.now().addDays(-1)
			limit 1
		];

		if( theTasks.size() <= 0 ) return;
		//request start-request.
		OboDashinResTasks.startAsync();
	}
}