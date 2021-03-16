public class ObosanbinGeoLocTaskFlb implements Schedulable{
	public void execute(SchedulableContext context) {
		try{
			//unschedule me.
	        System.abortJob( context.getTriggerId() );

	        this.run();

	        //reschedule new one.
	        this.scheduleNew();

		}catch(Exception e){
            Loggings.writeLog(
                Loggings.createLogEntry(Loggings.Level.Error, '20190606-1326-01', 'ObosanbinGeoLocTaskFlb.ScheduleRunFailed', 're-shedule needed.')
                	.putAttr('e.getMessage()', e.getMessage())
            );
		}
	}

	public void scheduleNew(){
        Integer theInterval = 15;
		String theNextTimeCron = DateTime.now().addMinutes(theInterval).format('s m H d M ? y');
        System.schedule('ObosanbinGeoLocTaskFlb-お坊さん便/座標更新TaskFlb' + '(' + theNextTimeCron + ')', theNextTimeCron, new ObosanbinGeoLocTaskFlb() );
	}

	public void run(){
		List<ObosanbinGeoLocTask__c> theTasks = [
			select Id
			from ObosanbinGeoLocTask__c
			where ShoriStatus__c = 'Created'
			and CreatedDate >= :DateTime.now().addDays(-1)
			limit 1
		];

		if( theTasks.size() <= 0 ) return;
		//request start-request.
		ObosanbinGeoLocTasks.startAsync();
	}
}