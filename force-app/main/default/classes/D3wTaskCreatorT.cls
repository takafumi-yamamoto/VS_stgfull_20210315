@isTest public class D3wTaskCreatorT {

    private class IFiler_Stub implements D3wTaskCsvFile.IFiler{
        public void set_csv_data(String p_task_id, String p_csv_data){ return; }
        public String get_csv_data(String p_task_id){ return ''; }
    }

    @isTest public static void TaskCreator_insert_task() {
        Test.startTest();
        new D3wTaskCreator.TaskCreator(
            new IFiler_Stub()
        )
        .insert_task('a-work-name','a-csv-data');
        Test.stopTest();
    }
}