public class KeiriSokyakuTeishiActivator implements Schedulable{

	public void execute(SchedulableContext context) {
		try{
			
			//unschedule me.
			System.abortJob( context.getTriggerId() );
			this.run();
			//reschedule new one.
			this.scheduleNew();
			
			if(Test.isRunningTest()){
				CalloutException e = new CalloutException();
				e.setMessage('This is a constructed exception! ');
				throw e;
			}

		}catch(Exception e){
			Loggings.writeLog(
				Loggings.createLogEntry(
					Loggings.Level.Error, '20200312-1500-01', 'KeiriSokyakuTeishiActivator.execute','Cyclic-Scheduling has been killed. Resuchedule Needed!')
					.putAttr('e.getMessage()',e.getMessage())
			);
		}
	}

	public void scheduleNew(){
	
		KeiriSokyakuTeishiBat__mdt ACSP = [SELECT ActivatorTIME__c
											FROM KeiriSokyakuTeishiBat__mdt
											WHERE DeveloperName = 'KeiriSokyakuTeishiBat'
											Limit 1];

		Integer theInterval =  Integer.valueOf(ACSP.ActivatorTIME__c);
		String theNextTimeCron = DateTime.now().addMinutes(theInterval).format('s m H d M ? y');
		System.schedule('経理_送客停止バッチ/KeiriSokyakuTeishiActivator' + '(' + theNextTimeCron + ')', theNextTimeCron, new KeiriSokyakuTeishiActivator() );
	}
	
	private void run(){
		KeiriSokyakuTeishiBat.Batstart();
	}
}