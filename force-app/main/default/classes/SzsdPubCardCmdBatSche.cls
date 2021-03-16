public class SzsdPubCardCmdBatSche implements Schedulable{

    @TestVisible
	private static Boolean to_raise_error_for_test_coverage = false;
	public void execute(SchedulableContext context) {
		try{
			SzsdPubCardCmdBat.start();
			if(to_raise_error_for_test_coverage) throw new Exceptions.AnException();
		}catch(Exception ex){
            Loggings.writeLog(
                Loggings.createLogEntry(Loggings.Level.Error, '20201217-1542', 'SzsdPubCardCmdBatSche.execute')
                    .putAttr('ex.getTypeName()', ex.getTypeName() )
                    .putAttr('ex.getMessage()', ex.getMessage())
                    .putAttr('ex.getLineNumber()', '' + ex.getLineNumber())
                    .putAttr('ex.getStackTraceString', ex.getStackTraceString())
            );
            throw ex;
		}
	}
}