@isTest public class D3wTaskStarterT {

    private static void beginSetUp(){
		Utility_Common.isMimicExecAsDataIkouProfile = true;
    }
	private static void endSetUp(){
        Insert new TriggerIsActive__c( name='default', isActive__c=true );
        Insert new JizenWariPlan__c( Code__c='Yoriso' );
        Insert new Account(
            RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','null'),
            FirstName = '_', LastName = '_'
        );
		Utility_Common.isMimicExecAsDataIkouProfile = false;
	}
    private class IFiler_Stub implements D3wTaskCsvFile.IFiler{
        public void set_csv_data(String p_task_id, String p_csv_data){ return; }
        public String get_csv_data(String p_task_id){ return 'a-csv-data'; }
    }
    private class IClient_Stub implements d3wApi_ActionEx.IClient{
        public d3wApi_ActionEx.Result send_request(d3wApi_ActionEx.Req p_req){
            d3wApi_ActionEx.Result a_result = new d3wApi_ActionEx.Result();
            a_result.process_id = 'a_job_id';
            a_result.work_name = 'a-work-name';
            a_result.work_subject = 'a-subject';
            return a_result;
        }
    }
    @isTest public static void Starter_start() {
        beginSetUp();
        D3wTask__c a_D3wTask = new D3wTask__c(d3w_work_name__c = 'a-work-name');
        INSERT a_D3wTask;
        endSetUp();
        Test.startTest();
        new D3wTaskStarter.Starter(
            new IFiler_Stub(),
            new IClient_Stub()
        )
        .start(a_D3wTask.Id);
        Test.stopTest();
    }
}