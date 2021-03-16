@isTest
public class d3wApi_HistoryExT {
    private class d3wApi_History_IClient_Stub implements d3wApi_History.IClient{
        public d3wApi_History.Result send_request(d3wApi_History.Req p_req){
            d3wApi_History.Result a_result = new d3wApi_History.Result();
            a_result.isSuccess = true;
            d3wApi_History.Res a_res = new d3wApi_History.Res();
            d3wApi_History.Envelope a_envelope = new d3wApi_History.Envelope();
            a_res.envelopes = new List<d3wApi_History.Envelope>{ a_envelope };
            a_result.res = a_res;
            return a_result;
        }
    }
    @isTest public static void Client_send_request(){
        Test.startTest();
        new d3wApi_HistoryEx.Client(
            'a-auth-token',
            new d3wApi_History_IClient_Stub()
        )
        .send_request(
            new d3wApi_HistoryEx.Req()
            .set_id('a-job-id')
        );
        Test.stopTest();
    }
}