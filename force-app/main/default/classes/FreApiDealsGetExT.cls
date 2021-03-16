@isTest public class FreApiDealsGetExT {

    public class FreApiDealsGet_IClient_Stub implements FreApiDealsGet.IClient{
        public FreApiDealsGet.Result sendRequest(FreApiDealsGet.Request pReq){
            FreApiDealsGet.Result a_result = new FreApiDealsGet.Result();
            a_result.isSuccess = true;
            a_result.response = new FreApiDealsGet.Response();
            a_result.response.deals = new List<FreApiDealsGet.Deal>();

            FreApiDealsGet.Deal a_deal_1 = new FreApiDealsGet.Deal();
            a_deal_1.Id = 1;
            a_deal_1.issue_date = '2020-08-20 00:00:00';
            a_result.response.deals.add(a_deal_1);

            FreApiDealsGet.Deal a_deal_2 = new FreApiDealsGet.Deal();
            a_deal_2.Id = 2;
            a_deal_2.issue_date = '2020-08-20 00:00:00';
            a_result.response.deals.add(a_deal_2);

            FreApiDealsGet.Meta a_meta = new FreApiDealsGet.Meta();
            a_meta.total_count = 2;
            a_result.response.meta = a_meta;
            
            return a_result;
        }
    }
    @isTest public static void Client_get_unsettled_all(){

        Integer a_compnay_id = 1;
        Integer a_max_api_call_count_for_safety = 100;
        Test.startTest();
        new FreApiDealsGetEx.Client(
            new FreApiDealsGet_IClient_Stub(),
            a_compnay_id,
            a_max_api_call_count_for_safety
        )
        .get_unsettled_all();
        Test.stopTest();
    }
}