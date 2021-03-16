public class D3wTaskStarter {

    public static IStarter get_IStarter_instance(){
        return new Starter(
            D3wTaskCsvFile.get_IFiler_instance(),
            d3wApi_ActionEx.get_IClient_instance()
        );
    }
    public interface IStarter {
        String start(String p_d3wTask_id);
    }
    public class Starter implements IStarter{

        private D3wTaskCsvFile.IFiler m_IFiler;
        private d3wApi_ActionEx.IClient m_IClient;
        public Starter(
            D3wTaskCsvFile.IFiler p_IFiler,
            d3wApi_ActionEx.IClient p_IClient
        ){
            this.m_IFiler = p_IFiler;
            this.m_IClient = p_IClient;
        }

        public String start(String p_d3wTask_id){

            D3wTask__c a_D3wTask = [
                SELECT Id, d3w_work_name__c FROM D3wTask__c WHERE Id = :p_d3wTask_id
            ]
            .get(0);

            String a_csv_data = m_IFiler.get_csv_data(p_d3wTask_id);

            d3wApi_ActionEx.Result a_d3wApi_ActionEx_result = m_IClient.send_request(
                new d3wApi_ActionEx.Req()
                .set_work_name(a_D3wTask.d3w_work_name__c)
                .set_data(a_csv_data)
            );

            UPDATE new D3wTask__c(
                Id = p_d3wTask_id, 
                ShoriStatus__c = 'Runned', 
                d3w_job_id__c = a_d3wApi_ActionEx_result.process_id,
                d3w_work_subject__c = a_d3wApi_ActionEx_result.work_subject
            );

            return a_d3wApi_ActionEx_result.process_id;
        }
    }

}