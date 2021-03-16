@isTest
public class D3wTaskMntrScheT {
    private class ITaskMonitor_Stub implements D3wTaskMntr.ITaskMonitor{
        public void update_status(){ return; }
    }
    private class d3wApi_AuthEx_IClient_Stub implements d3wApi_AuthEx.IClient{
        public d3wApi_AuthEx.Result send_request(){
            d3wApi_AuthEx.Result a_result = new d3wApi_AuthEx.Result();
            a_result.auth = 'a-token';
            return a_result;
        }
    }
    @isTest public static void execute_error(){
        D3wTaskMntrSche.ITaskMonitor_instance = new ITaskMonitor_Stub();
        D3wTaskMntrSche.to_raise_error_for_test_coverage = true;
        Test.startTest();
        new D3wTaskMntrSche().execute(null);
        Test.stopTest();
    }

    @isTest public static void scheduleNew(){
        Test.startTest();
        D3wTaskMntrSche.scheduleNew();
        Test.stopTest();
    }
    @isTest public static void get_ITaskMonitor_instance(){
        D3wTaskMntrSche.m_d3wApi_AuthEx_IClient_instance = new d3wApi_AuthEx_IClient_Stub();
        Test.startTest();
        new D3wTaskMntrSche().get_ITaskMonitor_instance();
        Test.stopTest();
    }
}