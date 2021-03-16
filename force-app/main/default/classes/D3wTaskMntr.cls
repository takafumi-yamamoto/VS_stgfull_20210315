public class D3wTaskMntr {

    @TestVisible
	private static Boolean to_raise_error_for_test_coverage = false;

    public static ITaskMonitor get_ITaskMonitor_instance(String p_d3w_auth_token){
        return new TaskMonitor(
            new StatusUpdaterFactory(p_d3w_auth_token)
        );
    }

    public interface IStatusUpdaterFactory {
        IStatusUpdater get_instance();
    }
    public class StatusUpdaterFactory implements IStatusUpdaterFactory{
        private String m_auth_token;
        public StatusUpdaterFactory(String p_auth_token){
            this.m_auth_token = p_auth_token;
        }
        public IStatusUpdater get_instance(){
            return new StatusUpdater(
                d3wApi_HistoryEx.get_IClient_instance(this.m_auth_token)
            );
        }
    }

    public interface ITaskMonitor {
        void update_status();
    }
    public class TaskMonitor implements ITaskMonitor{
        private IStatusUpdaterFactory m_IStatusUpdaterFactory;
        public TaskMonitor(
            IStatusUpdaterFactory p_IStatusUpdaterFactory
        ){
            this.m_IStatusUpdaterFactory = p_IStatusUpdaterFactory;
        }

        public void update_status(){
            try{

                for(D3wTask__c a_D3wTask : [
                    SELECT Id
                    FROM D3wTask__c
                    WHERE ShoriStatus__c = 'Runned'
                    limit 50
                ]){
                    new StatusUpdaterJob(
                        a_D3wTask.Id,
                        this.m_IStatusUpdaterFactory.get_instance()
                    )
                    .startAsync();
                }
            }catch(Exception ex){
                Loggings.writeLog(
                    Loggings.createLogEntry(Loggings.Level.Error, '20210304-1057', 'D3wTaskMntr.TaskMonitor.update_status')
                        .putAttr('ex.getTypeName()', ex.getTypeName() )
                        .putAttr('ex.getMessage()', ex.getMessage())
                        .putAttr('ex.getLineNumber()', '' + ex.getLineNumber())
                        .putAttr('ex.getStackTraceString', ex.getStackTraceString())
                );
            }
        }
    }

    public class StatusUpdaterJob implements Queueable, Database.AllowsCallouts{
        private String m_task_id;
        private IStatusUpdater m_IStatusUpdater;
        public StatusUpdaterJob(
            String p_task_id,
            IStatusUpdater p_IStatusUpdater
        ){
            this.m_task_id = p_task_id;
            this.m_IStatusUpdater = p_IStatusUpdater;
        }

		public void startAsync(){
			System.enqueueJob(this);
		}
		public void execute(QueueableContext context) {
            try{
				this.m_IStatusUpdater.update_status(this.m_task_id);
				if(to_raise_error_for_test_coverage) throw new Exceptions.AnException();
            }catch(Exception ex){
                Loggings.writeLog(
                    Loggings.createLogEntry(Loggings.Level.Error, '20210304-1046', 'D3wTaskMntr.StatusUpdaterJob.execute')
                        .setSubjectRecordId(this.m_task_id)
                        .putAttr('ex.getTypeName()', ex.getTypeName() )
                        .putAttr('ex.getMessage()', ex.getMessage())
                        .putAttr('ex.getLineNumber()', '' + ex.getLineNumber())
                        .putAttr('ex.getStackTraceString', ex.getStackTraceString())
                );
            }
        }
    }
    public interface IStatusUpdater {
        void update_status(String p_task_id);
    }
    public class StatusUpdater implements IStatusUpdater{
        private d3wApi_HistoryEx.IClient m_IClient;
        public StatusUpdater(d3wApi_HistoryEx.IClient p_IClient){
            this.m_IClient = p_IClient;
        }

        public void update_status(String p_task_id){
            
            D3wTask__c a_D3wTask = [
                SELECT Id, d3w_job_id__c
                FROM D3wTask__c WHERE Id = :p_task_id
            ]
            .get(0);
            
            d3wApi_HistoryEx.Result a_result = this.m_IClient.send_request(
                new d3wApi_HistoryEx.Req()
                .set_id(a_D3wTask.d3w_job_id__c)
            );

            D3wTask__c a_status_update = new D3wTask__c(Id = a_D3wTask.Id);
            if( !String.isBlank(a_result.status) ){
                a_status_update.d3w_status__c = a_result.status;
            }

            Boolean is_any_error = false;
            if( a_result.status == 'FAILED' ){ is_any_error = true; }
            for( d3wApi_HistoryEx.Envelope a_envelope : a_result.envelopes ){
                if( a_envelope.status == 'FAILED' ){ is_any_error = true; }
                if( a_envelope.document_status == 'FAILED' ){ is_any_error = true; }
                if( a_envelope.storage_status == 'FAILED' ){ is_any_error = true; }
                if( a_envelope.delivery_status == 'FAILED' ){ is_any_error = true; }
            }

            if( is_any_error ){
                a_status_update.ShoriStatus__c = 'Failed';

                Loggings.writeLog(
                    Loggings.createLogEntry(
                        Loggings.Level.Error, '20210304-1028', 'D3wTaskMntr.TaskMonitor.update_status','d3w error detected')
                        .setSubjectRecordId(a_D3wTask.Id)
                        .putAttr('a_D3wTask.d3w_job_id__c', a_D3wTask.d3w_job_id__c )
                        .putAttr('a_result.work_name', a_result.work_name)
                        .putAttr('a_result.subject', '' + a_result.subject)
                );
            }
            else if( a_result.status == 'COMPLETED' ){
                a_status_update.ShoriStatus__c = 'Completed';
            }
            
            UPDATE a_status_update;
        }
    }

}