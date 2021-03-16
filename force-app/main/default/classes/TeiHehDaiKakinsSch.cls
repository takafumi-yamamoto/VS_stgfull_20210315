public class TeiHehDaiKakinsSch implements Schedulable{
	public static Boolean i_will_raise_error_in_run_for_errHandleTest = false;

    public void execute(SchedulableContext sc) { 
		try{
			this.run();
		}catch(Exception ex){
	        Loggings.writeLog(
                Loggings.createLogEntry(
                    Loggings.Level.Error, '20200415-1540', 'TeiHehDaiKakinsSch.execute')
                    .putAttr('ex.getMessage()', ex.getMessage())
                    .putAttr('ex.getLineNumber()', '' + ex.getLineNumber())
                    .putAttr('ex.getStackTraceString()', ex.getStackTraceString()
            	)
            );
		}
	}

	public void run(){
		Date theRenewTargetYm = Todays.date().toStartOfMonth();
		TeiHehDaiKakins.start( theRenewTargetYm );
		if(i_will_raise_error_in_run_for_errHandleTest) throw new Exceptions.AnException();
	}

}