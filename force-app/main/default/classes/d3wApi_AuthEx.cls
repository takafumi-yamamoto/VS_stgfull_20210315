public class d3wApi_AuthEx {

    public static IClient get_IClient_instance(){
        d3wConf.Config a_config = d3wConf.get_IProvider_instance().getConfig();

        return new Client(
            a_config.UID,
            a_config.UPW,
            d3wApi_Auth.get_IClient_instance()
        );
    }

    public class Result{
        public String auth;
    }
    public interface IClient {
        Result send_request();
    }
    public class Client implements IClient{
        private String m_UID;
        private String m_UPW;
        private d3wApi_Auth.IClient m_api_clinet;


        public Client( String p_UID, String p_UPW, d3wApi_Auth.IClient p_api_clinet){
            this.m_UID = p_UID;
            this.m_UPW = p_UPW;
            this.m_api_clinet = p_api_clinet;
        }

        public Result send_request(){
            Result a_result = new Result();

            d3wApi_Auth.Result a_api_result = this.m_api_clinet.send_request(
                new d3wApi_Auth.Req()
                    .set_UID(this.m_UID)
                    .set_UPW(this.m_UPW)
            );

            if( !a_api_result.isSuccess ){
                Map<String, String> a_err_msg = new Map<String, String>{
                    'title' => 'api_error',
                    'JSON.serialize(a_result)' => JSON.serialize(a_api_result)
                };
                throw new Exceptions.AnException( JSON.serialize(a_err_msg) );
            }

            a_result.auth = a_api_result.res.auth;

            return a_result;
        }
    }
}