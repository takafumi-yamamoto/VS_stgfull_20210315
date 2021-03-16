public class LwsnJizenJunbisSche implements Schedulable{
	public static Boolean i_will_raise_error_in_run_for_errHandleTest = false;

    public void execute(SchedulableContext sc) { 
		try{
			this.run();
		}catch(Exception ex){
	        Loggings.writeLog(
                Loggings.createLogEntry(
                    Loggings.Level.Error, '20200331-2103-01', 'LwsnJizenJunbisSche.execute')
                    .putAttr('ex.getMessage()', ex.getMessage())
                    .putAttr('ex.getLineNumber()', '' + ex.getLineNumber())
                    .putAttr('ex.getStackTraceString()', ex.getStackTraceString()
            	)
            );
		}
	}

	public void run(){
		Date theToDate = Todays.date().addDays(-1);
		Date theFromDate = theToDate.addDays(-2);
		LwsnJizenJunbis.start(theFromDate, theToDate);

		if(i_will_raise_error_in_run_for_errHandleTest) throw new Exceptions.AnException();
	}
}