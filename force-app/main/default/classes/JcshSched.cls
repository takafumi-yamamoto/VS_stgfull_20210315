public class JcshSched implements Schedulable{

	@TestVisible
	private static Jcsh_JucyuJokyoSokuho.IJucyuJokyoSokuhoer m_IJucyuJokyoSokuhoer_instance = Jcsh_JucyuJokyoSokuho.get_IJucyuJokyoSokuhoer_instance();

	@TestVisible
	private static Boolean to_raise_error_for_test_coverage = false;

	public class JucyuJokyoHokokuJob implements Queueable, Database.AllowsCallouts{
		private Jcsh_JucyuJokyoSokuho.IJucyuJokyoSokuhoer m_IJucyuJokyoSokuhoer;
		public JucyuJokyoHokokuJob(Jcsh_JucyuJokyoSokuho.IJucyuJokyoSokuhoer p_IJucyuJokyoSokuhoer){
			this.m_IJucyuJokyoSokuhoer = p_IJucyuJokyoSokuhoer;
		}
		public void startAsync(){
			System.enqueueJob(this);
		}
		public void execute(QueueableContext context) {
            try{
				this.m_IJucyuJokyoSokuhoer.run();
				if(to_raise_error_for_test_coverage) throw new Exceptions.AnException();
            }catch(Exception ex){
                Loggings.writeLog(
                    Loggings.createLogEntry(Loggings.Level.Error, '20201206-1507', 'JcshSched.JucyuJokyoHokokuJob.execute')
                        .putAttr('ex.getTypeName()', ex.getTypeName() )
                        .putAttr('ex.getMessage()', ex.getMessage())
                        .putAttr('ex.getLineNumber()', '' + ex.getLineNumber())
                        .putAttr('ex.getStackTraceString', ex.getStackTraceString())
                );
            }
        }
	}

	public void execute(SchedulableContext context) {
		try{
			//unschedule me.
			System.abortJob( context.getTriggerId() );
			
			new JucyuJokyoHokokuJob(m_IJucyuJokyoSokuhoer_instance).startAsync();
			
			//reschedule new one.
			scheduleNew();
			if(to_raise_error_for_test_coverage) throw new Exceptions.AnException();
		}catch(Exception ex){
	        Loggings.writeLog(
	            Loggings.createLogEntry(
	                Loggings.Level.Error, '20201206-1218', 'JcshSched.execute','Cyclic-Scheduling has been killed. Resuchedule Needed!')
                    .putAttr('ex.getTypeName()', ex.getTypeName() )
                    .putAttr('ex.getMessage()', ex.getMessage())
                    .putAttr('ex.getLineNumber()', '' + ex.getLineNumber())
                    .putAttr('ex.getStackTraceString', ex.getStackTraceString())
	        );
		}
	}

	public static void scheduleNew(){
		Integer theInterval = 60;
		String theNextTimeCron = DateTime.now().addMinutes(theInterval).format('s m H d M ? y');
		System.schedule('JcshSched : 受注状況速報' + '(' + theNextTimeCron + ')', theNextTimeCron, new JcshSched() );
	}
}