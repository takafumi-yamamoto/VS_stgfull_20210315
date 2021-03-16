// SogiJizenAncateMihimodukeTaishoNashiKanryoBatchActivator
public class SgJzAnMdKrTsNsBatActivator implements Schedulable{

	@TestVisible
	private static Boolean to_raise_error_for_test_coverage = false;

	public void execute(SchedulableContext context) {
		try{
			SgJzAnMdKrTsNsBat.start();
			if(to_raise_error_for_test_coverage) throw new Exceptions.AnException();
		}catch(Exception ex){
			Loggings.writeLog(
				Loggings.createLogEntry(
					Loggings.Level.Error, '20210203-1600-00', 'SgJzAnMdKrTsNsBatActivator.execute','Cyclic-Scheduling has been killed. Resuchedule Needed!')
					.putAttr('ex.getTypeName()', ex.getTypeName() )
					.putAttr('ex.getMessage()', ex.getMessage() )
					.putAttr('ex.getLineNumber()', '' + ex.getLineNumber() )
					.putAttr('ex.getStackTraceString', ex.getStackTraceString() )
			);
		}
	}
}