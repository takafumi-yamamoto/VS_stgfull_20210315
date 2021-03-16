public class AddOpportunityContactRoleActivator implements Schedulable{

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
					Loggings.Level.Error, '20200204-1452-01', 'AddOpportunityContactRoleActivator.execute','Cyclic-Scheduling has been killed. Resuchedule Needed!')
					.putAttr('e.getMessage()',e.getMessage())
			);
		}
	}

	public void scheduleNew(){

		AddOpportunityContactRoleBat__mdt ACSP = [SELECT ActivatorTIME__c
												FROM AddOpportunityContactRoleBat__mdt
												WHERE DeveloperName = 'AddOpportunityContactRoleBat'
												Limit 1];
		Integer theInterval = Integer.valueOf(ACSP.ActivatorTIME__c);
		String theNextTimeCron = DateTime.now().addMinutes(theInterval).format('s m H d M ? y');
		System.schedule('商談 取引先責任者の役割/AddOpportunityContactRoleActivator' + '(' + theNextTimeCron + ')', theNextTimeCron, new AddOpportunityContactRoleActivator() );
	}
	
	private void run(){
		AddOpportunityContactRoleBat.Batstart();
	}
}