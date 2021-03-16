@isTest
public class d3wApi_ActionExT {
    private class d3wApi_Action_IClient_Stub implements d3wApi_Action.IClient{
        public d3wApi_Action.Result send_request(d3wApi_Action.Req p_req){
            d3wApi_Action.Result a_result = new d3wApi_Action.Result();
            a_result.isSuccess = true;
            d3wApi_Action.Res a_res = new d3wApi_Action.Res();
            a_result.res = a_res;
            return a_result;
        }
    }
    @isTest public static void Client_send_request(){
        Test.startTest();
        new d3wApi_ActionEx.Client(
            'a-uid',
            'a-upw',
            new d3wApi_Action_IClient_Stub()
        )
        .send_request(
            new d3wApi_ActionEx.Req()
            .set_work_name('a-work-name')
            .set_data('a-csv-data')
        );
        Test.stopTest();
    }
}