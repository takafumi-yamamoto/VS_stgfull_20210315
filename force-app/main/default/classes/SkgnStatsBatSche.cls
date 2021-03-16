public class SkgnStatsBatSche implements Schedulable{

    @TestVisible
	private static Boolean to_raise_error_for_test_coverage = false;
	public void execute(SchedulableContext context) {
		try{
			SkgnStatsBat.start();
			if(to_raise_error_for_test_coverage) throw new Exceptions.AnException();
		}catch(Exception ex){
            Loggings.writeLog(
                Loggings.createLogEntry(Loggings.Level.Error, '20210127-1616', 'SkgnStatsBatSche.execute')
                    .putAttr('ex.getTypeName()', ex.getTypeName() )
                    .putAttr('ex.getMessage()', ex.getMessage())
                    .putAttr('ex.getLineNumber()', '' + ex.getLineNumber())
                    .putAttr('ex.getStackTraceString', ex.getStackTraceString())
            );
            throw ex;
		}
	}
}