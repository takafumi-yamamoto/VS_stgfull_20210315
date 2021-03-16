public class KeirDenRenewActivator implements Schedulable{
	public void execute(SchedulableContext context) {
		try{
			//unschedule me.
			System.abortJob( context.getTriggerId() );
			run();
			//reschedule new one.
			scheduleNew();
		}catch(Exception e){
	        Loggings.writeLog(
	            Loggings.createLogEntry(
	                Loggings.Level.Error, '20191115-1913-01', 'KeirDenRenewActivator.execute','Cyclic-Scheduling has been killed. Resuchedule Needed!')
	                .putAttr('e.getMessage()',e.getMessage())
	        );
		}
	}

	public static void scheduleNew(){
		Integer theInterval = 10;
		String theNextTimeCron = DateTime.now().addMinutes(theInterval).format('s m H d M ? y');
		System.schedule('経理連携伝票生成/KeirDenRenewActivator' + '(' + theNextTimeCron + ')', theNextTimeCron, new KeirDenRenewActivator() );
	}
	
	private static void run(){
		KeirDenRenewBat.start();
	}
}