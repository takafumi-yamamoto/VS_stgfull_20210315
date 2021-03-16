public class SogSokSeikyuShoTorikCreTaskFlb implements Schedulable {
	public void execute(SchedulableContext context) {
		try{
			//unschedule me.
	        System.abortJob( context.getTriggerId() );

	        this.run();

	        //reschedule new one.
	        this.scheduleNew();

		}catch(Exception e){
            Loggings.writeLog(
                Loggings.createLogEntry(Loggings.Level.Error, '20190116-1200-01', 'SogSokSeikyuShoTorikCreTaskFlb.ScheduleRunFailed', 're-shedule needed.')
                	.putAttr('e.getMessage()', e.getMessage())
            );
		}
	}

	public void scheduleNew(){
        Integer theInterval = 10;
		String theNextTimeCron = DateTime.now().addMinutes(theInterval).format('s m H d M ? y');
        System.schedule('SogSokSeikyuShoTorikCreTaskFlb' + '(' + theNextTimeCron + ')', theNextTimeCron, new SogSokSeikyuShoTorikCreTaskFlb() );
	}

	public void run(){
        List<SogSok_SeikyuSho_TorikCreTask__c> theTasks = new List<SogSok_SeikyuSho_TorikCreTask__c>(
            [
                select Id
                from SogSok_SeikyuSho_TorikCreTask__c 
                where ShoriStatus__c = 'Created'
                and LastModifiedDate >= :DateTime.now().addDays(-30)
                limit 1
            ]
        );
		if( theTasks.size() <= 0 ) return;
		//request start-request.
		SogSok_SeikyuSho_TorikCre.start();
	}
}