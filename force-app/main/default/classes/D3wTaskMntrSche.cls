public class D3wTaskMntrSche implements Schedulable{

	@TestVisible
	private static d3wApi_AuthEx.IClient m_d3wApi_AuthEx_IClient_instance = d3wApi_AuthEx.get_IClient_instance();

    @TestVisible 
    private static D3wTaskMntr.ITaskMonitor ITaskMonitor_instance;
	@TestVisible
	private D3wTaskMntr.ITaskMonitor get_ITaskMonitor_instance(){
		if( ITaskMonitor_instance == null ){
			String d3w_auth_token = m_d3wApi_AuthEx_IClient_instance.send_request().auth;
			ITaskMonitor_instance = D3wTaskMntr.get_ITaskMonitor_instance(d3w_auth_token);
		}
		return ITaskMonitor_instance;
	}
	
    @TestVisible
	private static Boolean to_raise_error_for_test_coverage = false;

	public void execute(SchedulableContext context) {
		try{
			//unschedule me.
			System.abortJob( context.getTriggerId() );
			
			this.get_ITaskMonitor_instance().update_status();
			
			//reschedule new one.
			scheduleNew();
			if(to_raise_error_for_test_coverage) throw new Exceptions.AnException();
		}catch(Exception ex){
	        Loggings.writeLog(
	            Loggings.createLogEntry(
	                Loggings.Level.Error, '20210304-1338', 'D3wTaskMntrSche.execute','Cyclic-Scheduling has been killed. Resuchedule Needed!')
                    .putAttr('ex.getTypeName()', ex.getTypeName() )
                    .putAttr('ex.getMessage()', ex.getMessage())
                    .putAttr('ex.getLineNumber()', '' + ex.getLineNumber())
                    .putAttr('ex.getStackTraceString', ex.getStackTraceString())
	        );
		}
	}

	public static void scheduleNew(){
		Integer theInterval = 15;
		String theNextTimeCron = DateTime.now().addMinutes(theInterval).format('s m H d M ? y');
		System.schedule('D3wTaskMntrSche : d3wTaskステータス更新' + '(' + theNextTimeCron + ')', theNextTimeCron, new D3wTaskMntrSche() );
	}
}