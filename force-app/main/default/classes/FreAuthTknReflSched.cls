public class FreAuthTknReflSched implements Schedulable{

    @TestVisible
    private static Boolean i_will_raise_error_in_run_for_errHandleTest = false;
    
    @TestVisible
    private static FreAuthTknRefl.ITokenReflesher m_ITokenReflesher_instance = FreAuthTknRefl.get_ITokenReflesher_instance();

    public void execute(SchedulableContext sc) { 
		try{
            if(i_will_raise_error_in_run_for_errHandleTest) throw new Exceptions.AnException();

			System.enqueueJob(
                new TokenRefleshingJob(m_ITokenReflesher_instance)
            );
		}catch(Exception ex){
	        Loggings.writeLog(
                Loggings.createLogEntry(
                    Loggings.Level.Error, '20201118-2012', 'FreAuthTknReflSched.execute')
                    .putAttr('ex.getTypeName()', ex.getTypeName())
                    .putAttr('ex.getMessage()', ex.getMessage())
                    .putAttr('ex.getLineNumber()', '' + ex.getLineNumber())
                    .putAttr('ex.getStackTraceString()', ex.getStackTraceString()
            	)
            );
		}
    }

    private class TokenRefleshingJob implements Queueable, Database.AllowsCallouts{

        private FreAuthTknRefl.ITokenReflesher mITokenReflesher;
        public TokenRefleshingJob(FreAuthTknRefl.ITokenReflesher pITokenReflesher){
            this.mITokenReflesher = pITokenReflesher;
        }
        public void execute(QueueableContext context) {
            try{
                this.mITokenReflesher.refleshToken();
            }catch(Exception ex){
                Loggings.writeLog(
                    Loggings.createLogEntry(
                        Loggings.Level.Error, '20201118-2015', 'FreAuthTknReflSched.TokenRefleshingJob.execute')
                        .putAttr('ex.getTypeName()', ex.getTypeName())
                        .putAttr('ex.getMessage()', ex.getMessage())
                        .putAttr('ex.getLineNumber()', '' + ex.getLineNumber())
                        .putAttr('ex.getStackTraceString()', ex.getStackTraceString()
                    )
                );
            }
        }
    }
}