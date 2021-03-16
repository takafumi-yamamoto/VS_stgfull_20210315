public class D3wTaskCreator {

    public static ITaskCreator get_ITaskCreator_instance(){
        return new TaskCreator(
            D3wTaskCsvFile.get_IFiler_instance()
        );
    }

    public interface ITaskCreator {
        String insert_task(String p_work_name, String p_csv_data);
    }

    public class TaskCreator implements ITaskCreator{

        private D3wTaskCsvFile.IFiler m_IFiler;
        public TaskCreator(D3wTaskCsvFile.IFiler p_IFiler){
            this.m_IFiler = p_IFiler;
        }

        public String insert_task(String p_work_name, String p_csv_data){
            
            D3wTask__c a_task = 
                new D3wTask__c(
                    d3w_work_name__c = p_work_name,
                    ShoriStatus__c = 'Created'
                );
            INSERT a_task;
            
            this.m_IFiler.set_csv_data(a_task.Id, p_csv_data);

            return a_task.Id;
        }
    }
}