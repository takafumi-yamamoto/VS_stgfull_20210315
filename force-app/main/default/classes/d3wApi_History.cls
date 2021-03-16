public class d3wApi_History {
    public static IClient get_IClient_instance(){
        return new Client(
            d3wConf.get_IProvider_instance().getConfig().api_base_url
        );
    }

    public class Req{
        public String id;
        public Req set_id(String p_value){ this.id = p_value; return this; }
        public String auth_token;
        public Req set_auth_token(String p_value){ this.auth_token = p_value; return this; }
    }
    public class Result{
        public Boolean isSuccess = false;
        public Integer http_status_code = 0;
        public String end_point = '';
        public String req_body_raw = '';
        public String res_body_raw = '';
        public Res res = new Res();
    }
    public class Res{
        public String process_id;
        public String user_id;
        public String work_name;
        public String subject;
        public String application_id;
        public Integer envelope_count;
        public String status;
        public String create_date;
        public String update_date;
        public List<Envelope> envelopes = new List<Envelope>();
    }
    public class Envelope{
        public String envelope_id;
        public String envelope_order;
        public String envelope_value;
        public String envelope_name;
        public String subject;
        public String attr1;
        public String attr2;
        public String attr3;
        public String attr4;
        public String attr5;
        public String status;
        public Integer document_count;
        public Integer delivery_count;
        public String document_status;
        public String storage_status;
        public String delivery_status;
        public String create_date;
        public String update_date;
        public String summed_status;
    }

    public interface IClient {
        Result send_request(Req p_req);
    }
    public class Client implements IClient{
        private String m_api_base_url;
        public Client( String p_api_base_url){
            this.m_api_base_url = p_api_base_url;
        }

        public Result send_request(Req p_req){
            Result a_result = new Result();

        	HttpRequest a_http_req = new HttpRequest(); 
	        a_http_req.setMethod('POST');
            a_http_req.setHeader('X-OPRO-D3W-Auth',p_req.auth_token);
            a_http_req.setHeader('Content-Type','application/x-www-form-urlencoded');
            
            String a_end_point = this.m_api_base_url + '/history/';
            a_end_point = 'https://d3w.ap.oproarts.com/d3w/api/op179_yrs/history/';
            a_http_req.setEndpoint(a_end_point);
            a_result.end_point = a_end_point;

            String a_req_body = '';
            a_req_body += 'id=' + p_req.id;
            a_http_req.setBody(a_req_body);
            a_result.req_body_raw = a_req_body;

            HTTPResponse a_http_res = new Http().send(a_http_req);
            Integer a_http_status_code = a_http_res.getStatusCode();
            a_result.http_status_code = a_http_status_code;

            String a_res_body = a_http_res.getBody();
            a_result.res_body_raw = a_res_body;

            if(a_http_status_code == 200){
                a_result.res = (Res)JSON.deserialize(a_res_body, Res.class);
                a_result.isSuccess = true;
            }
            
            return a_result;
        }
    }
}