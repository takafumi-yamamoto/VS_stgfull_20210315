public class FreApiDealsGetEx {

    public static IClient get_IClient_instance(){
        Integer the_max_api_call_count_for_safety = 100;
        return new Client(
            FreApiDealsGet.get_IClient_instance(),
            FreApiConfs.getConfig().company_id,
            the_max_api_call_count_for_safety
        );
    }

    public class Request{
        public String partner_code; //取引先コードで絞込
        public Request set_partner_code(String pValue){ this.partner_code = pValue; return this; }

        public String type; //収支区分 (収入: income, 支出: expense)
        public Request set_type(String pValue){ this.type = pValue; return this; }

        public String status; //決済状況で絞込 (未決済: unsettled, 完了: settled)
        public Request set_status(String pValue){ this.status = pValue; return this; }

        public Date start_issue_date;
        public Request set_start_issue_date(Date pValue){ this.start_issue_date = pValue; return this; }

        public Date end_issue_date;
        public Request set_end_issue_date(Date pValue){ this.end_issue_date = pValue; return this; }

        public Integer page_size = 100;
        public Request set_page_size(Integer pValue){ this.page_size = pValue; return this; }
    }
    public class Deal{
        public Integer Id;
        public Integer company_id;
        public Date issue_date;
        public Integer amount;
        public Date due_date;
        public Integer due_amount;
        public String type;
        public String partner_code;
        public String ref_number;
        public String status;
    }

    public interface IClient {
        List<Deal> sendRequest(Request pReq);
        List<Deal> get_unsettled_all();
    }
    public class Client implements IClient{
        private FreApiDealsGet.IClient mFreApiDealsGetClient;
        private Integer mCompanyId;
        public Integer m_max_api_call_count_for_safety;
        public Client(FreApiDealsGet.IClient pFreApiDealsGetClient, Integer pCompanyId, Integer p_max_api_call_count_for_safety){
            this.mFreApiDealsGetClient = pFreApiDealsGetClient;
            this.mCompanyId = pCompanyId;
            this.m_max_api_call_count_for_safety = p_max_api_call_count_for_safety;
        }

        public List<Deal> sendRequest(Request pReq){
            Map<Integer, Deal> the_Deals = new Map<Integer, Deal>();

            FreApiDealsGet.Request theApiReq = new FreApiDealsGet.Request();
            theApiReq.company_id = this.mCompanyId;
            theApiReq.partner_code = pReq.partner_code;
            theApiReq.type = pReq.type;
            theApiReq.status = pReq.status;
            theApiReq.start_issue_date = 
                pReq.start_issue_date == null 
                ? null 
                : Datetime.newInstance( pReq.start_issue_date.year(), pReq.start_issue_date.month(), pReq.start_issue_date.day() ).format('yyyy-MM-dd');

            theApiReq.end_issue_date = 
                pReq.end_issue_date == null 
                ? null 
                : Datetime.newInstance( pReq.end_issue_date.year(), pReq.end_issue_date.month(), pReq.end_issue_date.day() ).format('yyyy-MM-dd');
                
            theApiReq.limit_limit = pReq.page_size;

            Integer the_api_call_count = 0;

            Integer the_cusrsor_position = 0;
            Integer the_total_count_match = -1;
            Boolean is_first_call = true;
            while( is_first_call || the_cusrsor_position < the_total_count_match){
                
                the_api_call_count ++;
                if( the_api_call_count > this.m_max_api_call_count_for_safety){
                    throw new TooManyApiCallException('too Many Api call');
                }

                theApiReq.offset = the_cusrsor_position;
                FreApiDealsGet.Result theApiRes = this.mFreApiDealsGetClient.sendRequest(theApiReq);
                if( !theApiRes.isSuccess ){
                    throw new ApiErrorException(
                        Json.serializePretty(new Map<String,String>{
                            'err_msg' => 'api error occured.',
                            'theApiRes' => Json.serializePretty(theApiRes)
                        })
                    );
                }

                if( is_first_call ) the_total_count_match = theApiRes.response.meta.total_count;
                

                for(FreApiDealsGet.Deal aApiDeal : theApiRes.response.deals){
                    the_cusrsor_position ++;

                    Deal aDeal = new Deal();
                    aDeal.type = aApiDeal.type;
                    aDeal.status = aApiDeal.status;
                    aDeal.ref_number = aApiDeal.ref_number;
                    aDeal.partner_code = aApiDeal.partner_code;
                    aDeal.issue_date =  Date.valueOf(aApiDeal.issue_date);
                    aDeal.Id = aApiDeal.Id;
                    aDeal.due_date = String.isBlank(aApiDeal.due_date) ? null : Date.valueOf(aApiDeal.due_date);
                    aDeal.due_amount = aApiDeal.due_amount;
                    aDeal.company_id = aApiDeal.company_id;
                    aDeal.amount =  aApiDeal.amount;
                    the_Deals.put(aDeal.Id, aDeal);
                }

                is_first_call = false;

                if( theApiRes.response.deals.size() == 0 ) break;
            }

            return the_Deals.values();
        }

        public List<Deal> get_unsettled_all(){

            return this.sendRequest(
                new Request()
                .set_type('income')
                .set_status('unsettled')
                .set_page_size(100)
            );

        }
    }

    public class TooManyApiCallException extends Exception{}
    public class ApiErrorException extends Exception{}
}