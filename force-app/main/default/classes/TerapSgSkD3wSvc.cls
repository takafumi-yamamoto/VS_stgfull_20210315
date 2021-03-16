public without sharing class TerapSgSkD3wSvc {

    @TestVisible
	private static Boolean to_raise_error_for_test_coverage = false;

    @TestVisible
    private static ITaskStarter m_ITaskStarter_instance = new TaskStarter(
        D3wTaskStarter.get_IStarter_instance()
    );

    public class start_d3w_task_req{
        @AuraEnabled public String d3w_task_id {get; set;}
    }
    public class start_d3w_task_res{
        public start_d3w_task_res(){
            this.is_success = false;
            this.d3w_job_id = '';
            this.err_msg = '';
        }
        @AuraEnabled public Boolean is_success {get; set;} 
        public start_d3w_task_res set_is_success(Boolean p_value){ this.is_success = p_value; return this; }
        @AuraEnabled public String d3w_job_id {get; set;}
        public start_d3w_task_res set_d3w_job_id(String p_value){ this.d3w_job_id = p_value; return this; }
        @AuraEnabled public String err_msg {get; set;}
        public start_d3w_task_res set_err_msg(String p_value){ this.err_msg = p_value; return this; }
    }
    @AuraEnabled
    public static start_d3w_task_res start_d3w_task(start_d3w_task_req p_req){
        try{
            if(to_raise_error_for_test_coverage) throw new Exceptions.AnException();
            return m_ITaskStarter_instance.start_d3w_task(p_req);
        }catch(Exception ex){
	        Loggings.writeLog(
	            Loggings.createLogEntry(
	                Loggings.Level.Error, '20210225-1719', 'TerapSgSkD3wSvc.start_d3w_task')
                    .putAttr('ex.getTypeName()', ex.getTypeName() )
                    .putAttr('ex.getMessage()', ex.getMessage())
                    .putAttr('ex.getLineNumber()', '' + ex.getLineNumber())
                    .putAttr('ex.getStackTraceString', ex.getStackTraceString())
	        );
            return new start_d3w_task_res()
            .set_is_success(false)
            ;
        }
    }
    public interface ITaskStarter {
        start_d3w_task_res start_d3w_task(start_d3w_task_req p_req);
    }
    public class TaskStarter implements ITaskStarter{
        private D3wTaskStarter.IStarter m_IStarter;
        public TaskStarter(D3wTaskStarter.IStarter p_IStarter){
            this.m_IStarter = p_IStarter;
        }

        public start_d3w_task_res start_d3w_task(start_d3w_task_req p_req){
            String a_job_id = this.m_IStarter.start(p_req.d3w_task_id);
            return new start_d3w_task_res()
                .set_is_success(true)
                .set_d3w_job_id(a_job_id);
        }
    }
}