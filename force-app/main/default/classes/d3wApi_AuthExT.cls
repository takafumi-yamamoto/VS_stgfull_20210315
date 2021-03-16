@isTest
public class d3wApi_AuthExT {
    private class d3wApi_Auth_IClient_Stub implements d3wApi_Auth.IClient{
        public d3wApi_Auth.Result send_request(d3wApi_Auth.Req p_req){
            d3wApi_Auth.Result a_result = new d3wApi_Auth.Result();
            a_result.isSuccess = true;
            d3wApi_Auth.Res a_res = new d3wApi_Auth.Res();
            a_result.res = a_res;
            return a_result;
        }
    }
    @isTest public static void Client_send_request(){
        Test.startTest();
        new d3wApi_AuthEx.Client(
            'a-uid',
            'a-upw',
            new d3wApi_Auth_IClient_Stub()
        )
        .send_request();
        Test.stopTest();
    }

    @isTest public static void get_IClient_instance(){
        Test.startTest();
        d3wApi_AuthEx.get_IClient_instance();
        Test.stopTest();
    }
}