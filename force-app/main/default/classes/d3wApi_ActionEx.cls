public class d3wApi_ActionEx {
    public static IClient get_IClient_instance(){
        d3wConf.Config a_config = d3wConf.get_IProvider_instance().getConfig();
        return new Client(
            a_config.UID,
            a_config.UPW,
            d3wApi_Action.get_IClient_instance()
        );
    }

    public class Req{
        public String work_name;
        public Req set_work_name(String p_value){ this.work_name = p_value; return this; }
        public String data;
        public Req set_data(String p_value){ this.data = p_value; return this; }
    }
    public class Result{
        public String process_id;//job_id
        public String work_name;
        public String work_subject;
    }

    public interface IClient {
        Result send_request(Req p_req);
    }
    public class Client implements IClient{
        private String m_uid;
        private String m_upw;
        private d3wApi_Action.IClient m_d3wApi_Action_IClient;
        
        public Client( String p_uid, String p_upw, d3wApi_Action.IClient p_d3wApi_Action_IClient){
            this.m_uid = p_uid;
            this.m_upw = p_upw;
            this.m_d3wApi_Action_IClient = p_d3wApi_Action_IClient;
        }

        public Result send_request(Req p_req){
            Result a_result = new Result();

            d3wApi_Action.Result a_d3wApi_Action_resut = this.m_d3wApi_Action_IClient.send_request(
                new d3wApi_Action.Req()
                .set_UID(this.m_uid)
                .set_UPW(this.m_upw)
                .set_work(p_req.work_name)
                .set_data(p_req.data)
            );
            if( !a_d3wApi_Action_resut.isSuccess ){
                Map<String, String> a_err_msg = new Map<String, String>{
                    'title' => 'api_error',
                    'JSON.serialize(a_result)' => JSON.serialize(a_d3wApi_Action_resut)
                };
                throw new Exceptions.AnException( JSON.serialize(a_err_msg) );
            }

            a_result.process_id = a_d3wApi_Action_resut.res.process_id;
            a_result.work_name = a_d3wApi_Action_resut.res.work_name;
            a_result.work_subject = a_d3wApi_Action_resut.res.subject;
            
            return a_result;
        }
    }
}