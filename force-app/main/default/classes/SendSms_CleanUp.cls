public class SendSms_CleanUp implements Schedulable{
    @TestVisible
	private static Boolean to_raise_error_for_test_coverage = false;

    public void execute(SchedulableContext context) {
		try{
            new CleanUpper().clena_up();
            if(to_raise_error_for_test_coverage) throw new Exceptions.AnException();
		}catch(Exception ex){
            Loggings.writeLog(
                Loggings.createLogEntry(Loggings.Level.Error, '20200106-1931', 'SendSms_CleanUp.execute')
                    .putAttr('ex.getTypeName()', ex.getTypeName() )
                    .putAttr('ex.getMessage()', ex.getMessage())
                    .putAttr('ex.getLineNumber()', '' + ex.getLineNumber())
                    .putAttr('ex.getStackTraceString', ex.getStackTraceString())
            );
            throw ex;
		}
    }
    
    public class CleanUpper{
        public void clena_up(){
            Datetime a_datetime_to_delete = this.get_datetime_to_delete();
            DELETE [
                SELECT Id FROM SendSms__c
                WHERE CreatedDate <= :a_datetime_to_delete
                LIMIT 8000
            ];
        }

        public Datetime get_datetime_to_delete(){
            return Datetime.now().addMonths(-3);
        }
    }
}