@isTest public class TerapSgSkD3wSvcT {
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
    private class IStarter_Stub implements D3wTaskStarter.IStarter{
        public String start(String p_d3wTask_id){ return 'a-job-id'; }
    }

    @isTest public static void start_d3w_task(){
        beginSetUp();
        D3wTask__c a_D3wTask = new D3wTask__c(d3w_work_name__c = 'a-work');
        INSERT a_D3wTask;

        TerapSgSkD3wSvc.m_ITaskStarter_instance = new TerapSgSkD3wSvc.TaskStarter(
            new IStarter_Stub()
        );
        endSetUp();
        Test.startTest();
        TerapSgSkD3wSvc.start_d3w_task_req a_req = new TerapSgSkD3wSvc.start_d3w_task_req();
        a_req.d3w_task_id = a_D3wTask.Id;
        TerapSgSkD3wSvc.start_d3w_task(a_req);
        Test.stopTest();
    }

    @isTest public static void start_d3w_task_error(){
        TerapSgSkD3wSvc.to_raise_error_for_test_coverage = true;
        Test.startTest();
        TerapSgSkD3wSvc.start_d3w_task_req a_req = new TerapSgSkD3wSvc.start_d3w_task_req();
        a_req.d3w_task_id = 'xxx';
        TerapSgSkD3wSvc.start_d3w_task(a_req);
        Test.stopTest();
    }
}