public class ObStSynBatActivator implements Schedulable {
	public void execute(SchedulableContext context) {
		try{
			//unschedule me.
			System.abortJob( context.getTriggerId() );
			this.run();
			//reschedule new one.
			this.scheduleNew();
		}catch(Exception e){
	        Loggings.writeLog(
	            Loggings.createLogEntry(
	                Loggings.Level.Error, '20190410-2000-01', 'ObStSynBatActivator.execute','Cyclic-Scheduling has been killed. Resuchedule Needed!')
	                .putAttr('e.getMessage()',e.getMessage())
	        );
		}
	}

	public void scheduleNew(){
		Integer theInterval = 10;
		String theNextTimeCron = DateTime.now().addMinutes(theInterval).format('s m H d M ? y');
		System.schedule('ObStSynBatActivator' + '(' + theNextTimeCron + ')', theNextTimeCron, new ObStSynBatActivator() );
	}
	
	public void run(){
		if(is_bat_runing()) return;
		database.executebatch(new ObStSynBat(), 1);
	}
	
	private Boolean is_bat_runing(){
        /*the apex-class-name of AsyncApexJob is not internal class's name but root-class'name*/
        String theBatchName = ObStSynBat.Class.toString();
        List<AsyncApexJob> theJobs = [
            SELECT Id, ApexClass.Name from AsyncApexJob 
            where Status in ('Holding','Queued','Preparing','Processing') 
            and ApexClass.Name = :theBatchName
            and JobType = 'Queueable'
            Limit 1
        ];
        return theJobs.size() >= 1;
    }
}