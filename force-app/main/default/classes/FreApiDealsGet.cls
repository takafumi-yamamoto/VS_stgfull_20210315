public class FreApiDealsGet {

    public static IClient get_IClient_instance(){
        return new Client(
            FreAuthTkn.get_ITokenProvider_instance().getTokenInfo().access_token,
            FreApiConfs.getConfig().api_base_url
        );
    }

    public class Request{
        public Integer company_id = 0; //事業所ID
        public String partner_code = ''; //取引先コードで絞込
        public String type = ''; //収支区分 (収入: income, 支出: expense)
        public String status = ''; //決済状況で絞込 (未決済: unsettled, 完了: settled)
        public String start_issue_date = '';
        public String end_issue_date = '';
        public Integer offset = 0;
        public Integer limit_limit = 100;
    }
    public class Response{
        public List<Deal> deals;
        public Meta meta;
    }
    public class Deal{
        public Integer Id;
        public Integer company_id;
        public String issue_date;
        public Integer amount;
        public String due_date;
        public Integer due_amount;
        public String type;
        public String partner_code;
        public String ref_number;
        public String status;
    }
    public class Meta{
        public Integer total_count;
    }

    public class Result{
        public Boolean isSuccess = false;
        public Integer statusCode = 0;
        public String endPoint = '';
        public String reqBodyRaw = '';
        public String resBodyRaw = '';
        public Response response = new Response();
    }

    public interface IClient {
        Result sendRequest(Request pReq);
    }
    public class Client implements IClient{
        String mAccessToken;
        String mApiBaseEndPoint;

        public Client(String pAccessToken, String pApiBaseEndPoint){
            this.mAccessToken = pAccessToken;
            this.mApiBaseEndPoint = pApiBaseEndPoint;
        }

        public Result sendRequest(Request pReq){
            return this.sendRequest(this.mAccessToken, this.mApiBaseEndPoint, pReq);
        }

        public Result sendRequest(String pToken, String pBaseUrl, Request pReq){
            Result theResult = new Result();
    
            HttpRequest theHttpReq = new HttpRequest(); 
            theHttpReq.setMethod('GET');
            theHttpReq.setHeader('Authorization','Bearer ' + pToken);
            theHttpReq.setHeader('X-Api-Version','2020-06-15');
            
            String queryParam = '?company_id=' + String.valueOf(pReq.company_id);
            if(!String.isBlank(pReq.partner_code)){ 
                queryParam += '&partner_code=' + EncodingUtil.urlEncode(pReq.partner_code, 'UTF-8'); 
            }
            if(!String.isBlank(pReq.type)){ queryParam += '&type=' + pReq.type; }
            if(!String.isBlank(pReq.status)){ queryParam += '&status=' + pReq.status; }
            if(!String.isBlank(pReq.start_issue_date)){ queryParam += '&start_issue_date=' + pReq.start_issue_date; }
            if(!String.isBlank(pReq.end_issue_date)){ queryParam += '&end_issue_date=' + pReq.start_issue_date; }
            queryParam += '&offset=' + String.valueOf(pReq.offset);
            queryParam += '&limit=' + String.valueOf(pReq.limit_limit);
    
            String theEndPoint = pBaseUrl + '/api/1/deals' + queryParam;
            theHttpReq.setEndpoint(theEndPoint);
            theResult.endPoint = theEndPoint;
    
            HTTPResponse theHttpRes = new Http().send(theHttpReq);
            Integer theStatusCode = theHttpRes.getStatusCode();
            theResult.statusCode = theStatusCode;
    
            String theResBody = theHttpRes.getBody();
            theResult.resBodyRaw = theResBody;
            if(theStatusCode == 200){
                theResult.response = (Response)JSON.deserialize(theResBody,Response.class);
                theResult.isSuccess = true;
            }
            
            return theResult;
        }
    }
}