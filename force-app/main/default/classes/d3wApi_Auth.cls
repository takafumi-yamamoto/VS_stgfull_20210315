public class d3wApi_Auth {
    public static IClient get_IClient_instance(){
        return new Client(
            d3wConf.get_IProvider_instance().getConfig().api_base_url
        );
    }

    public class Req{
        public String UID;
        public Req set_UID(String p_value){ this.UID = p_value; return this; }
        public String UPW;
        public Req set_UPW(String p_value){ this.UPW = p_value; return this; }
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
        public String auth;
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
            a_http_req.setHeader('Content-Type','application/x-www-form-urlencoded');
            
            String a_end_point = this.m_api_base_url + '/auth';
            a_http_req.setEndpoint(a_end_point);
            a_result.end_point = a_end_point;

            String a_req_body = '';
            a_req_body += 'UID=' + p_req.UID;
            a_req_body += '&UPW=' + p_req.UPW;
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