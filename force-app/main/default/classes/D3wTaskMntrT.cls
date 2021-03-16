@isTest
public class D3wTaskMntrT {
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
    private class d3wApi_HistoryEx_IClient_Stub implements d3wApi_HistoryEx.IClient{
        public d3wApi_HistoryEx.Result send_request(d3wApi_HistoryEx.Req p_req){
            d3wApi_HistoryEx.Result a_result = new d3wApi_HistoryEx.Result();
            a_result.status = 'COMPLETED';
            d3wApi_HistoryEx.Envelope a_envelope = new d3wApi_HistoryEx.Envelope();
            a_envelope.document_status = 'COMPLETED';
            a_envelope.storage_status = 'COMPLETED';
            a_envelope.delivery_status = 'FAILED';
            a_result.envelopes.add(a_envelope);
            return a_result;
        }
    }
    private class IStatusUpdaterFactory_Stub implements D3wTaskMntr.IStatusUpdaterFactory{
        public D3wTaskMntr.IStatusUpdater get_instance(){
            return new D3wTaskMntr.StatusUpdater(
                new d3wApi_HistoryEx_IClient_Stub()
            );
        }
    }
    public class IStatusUpdater_Stub implements D3wTaskMntr.IStatusUpdater{
        public void update_status(String p_task_id){ return; }
    }
    @isTest public static void TaskMonitor_update_status() {
        beginSetUp();
        INSERT new D3wTask__c(d3w_work_name__c = 'a_work_name',ShoriStatus__c = 'Runned');
        endSetUp();
        Test.startTest();
        new D3wTaskMntr.TaskMonitor(
            new IStatusUpdaterFactory_Stub()
        )
        .update_status();
        Test.stopTest();
    }

    @isTest public static void StatusUpdaterFactory_get_instance(){
        Test.startTest();
        new D3wTaskMntr.StatusUpdaterFactory('a-auth-token').get_instance();
        Test.stopTest();
    }

    @isTest public static void StatusUpdaterJob_execute_error(){
        D3wTaskMntr.to_raise_error_for_test_coverage = true;
        Test.startTest();
        new D3wTaskMntr.StatusUpdaterJob(
            'a_task_id',
            new IStatusUpdater_Stub()
        )
        .execute(null);
        Test.stopTest();
    }
}