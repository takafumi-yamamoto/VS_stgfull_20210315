public class ObouYoyakuCaseToShodanTaskFlb implements Schedulable {
	public void execute(SchedulableContext context) {
		try{
			//unschedule me.
	        System.abortJob( context.getTriggerId() );

	        this.run();

	        //reschedule new one.
	        this.scheduleNew();

		}catch(Exception e){
            Loggings.writeLog(
                Loggings.createLogEntry(Loggings.Level.Error, '20181207-1703-01', 'ObouYoyakuCaseToShodanTaskFlb.ScheduleRunFailed', 're-shedule needed.')
                	.putAttr('e.getMessage()', e.getMessage())
            );
		}
	}

	public void scheduleNew(){
        Integer theInterval = 10;
		String theNextTimeCron = DateTime.now().addMinutes(theInterval).format('s m H d M ? y');
        System.schedule('ObouYoyakuCaseToShodanTaskFlb' + '(' + theNextTimeCron + ')', theNextTimeCron, new ObouYoyakuCaseToShodanTaskFlb() );
	}

	public void run(){
		List<ObouYoyakuCaseToShodanTask__c> theTasks = [
			select Id
			from ObouYoyakuCaseToShodanTask__c
			where ShoriStatus__c = 'Created'
			and CreatedDate >= :DateTime.now().addDays(-1)
			limit 1
		];

		if( theTasks.size() <= 0 ) return;
		//request start-request.
		new Ctl_ObosanbinService.CaseToShodanTaskProcessor().sendStartRequest();
	}
}