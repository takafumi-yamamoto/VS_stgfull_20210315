public class CopyAccountToContactActivator{
    public void ATC(){}

/*
public class CopyAccountToContactActivator implements Schedulable{

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
					Loggings.Level.Error, '20200217-1500-01', 'CopyAccountToContactActivator.execute','Cyclic-Scheduling has been killed. Resuchedule Needed!')
					.putAttr('e.getMessage()',e.getMessage())
			);
		}
	}

	public void scheduleNew(){

		Integer theInterval = Integer.valueOf(System.Label.TIMECopyAccountToContactActivator);
		String theNextTimeCron = DateTime.now().addMinutes(theInterval).format('s m H d M ? y');
		System.schedule('個人取引先（AccountからContactへのコピー処理)/CopyAccountToContactActivator' + '(' + theNextTimeCron + ')', theNextTimeCron, new CopyAccountToContactActivator() );
	}
	
	private void run(){
		CopyAccountToContactBat.Batstart();
	}
}
*/
}