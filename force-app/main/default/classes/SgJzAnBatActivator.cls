public class SgJzAnBatActivator implements Schedulable{

	@TestVisible
	private static Boolean to_raise_error_for_test_coverage = false;

	public void execute(SchedulableContext context) {
		try{
			//unschedule me.
			System.abortJob( context.getTriggerId() );
			SgJzAnBat.start();
			scheduleNew();
			if(to_raise_error_for_test_coverage) throw new Exceptions.AnException();
		}catch(Exception ex){
			Loggings.writeLog(
				Loggings.createLogEntry(
					Loggings.Level.Error, '20210203-1600-00', 'SgJzAnBatActivator.execute','Cyclic-Scheduling has been killed. Resuchedule Needed!')
					.putAttr('ex.getTypeName()', ex.getTypeName() )
					.putAttr('ex.getMessage()', ex.getMessage() )
					.putAttr('ex.getLineNumber()', '' + ex.getLineNumber() )
					.putAttr('ex.getStackTraceString', ex.getStackTraceString() )
			);
		}
	}

	public static void scheduleNew(){
		Integer theInterval = 5;
		String theNextTimeCron = DateTime.now().addMinutes(theInterval).format('s m H d M ? y');
		System.schedule('SgJzAnBatActivator : 葬儀資料請求後事前アンケート登録' + '(' + theNextTimeCron + ')', theNextTimeCron, new SgJzAnBatActivator() );
	}
}