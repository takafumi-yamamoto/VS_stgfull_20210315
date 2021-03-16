public class d3wApi_HistoryEx {

    public static IClient get_IClient_instance(String p_auth_token){
        return new Client(
            p_auth_token,
            d3wApi_History.get_IClient_instance()
        );
    }

    public class Req{
        public String id;
        public Req set_id(String p_value){ this.id = p_value; return this; }
    }

    public class Result{
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
        private String m_auth_token;
        private d3wApi_History.IClient m_api_clinet;
        
        public Client( String p_auth_token, d3wApi_History.IClient p_api_clinet){
            this.m_auth_token = p_auth_token;
            this.m_api_clinet = p_api_clinet;
        }

        public Result send_request(Req p_req){
            Result a_result = new Result();

            d3wApi_History.Result a_api_result = this.m_api_clinet.send_request(
                new d3wApi_History.Req()
                    .set_id(p_req.id)
                    .set_auth_token(this.m_auth_token)
            );

            if( !a_api_result.isSuccess ){
                Map<String, String> a_err_msg = new Map<String, String>{
                    'title' => 'api_error',
                    'JSON.serialize(a_result)' => JSON.serialize(a_api_result)
                };
                throw new Exceptions.AnException( JSON.serialize(a_err_msg) );
            }

            a_result.process_id = a_api_result.res.process_id;
            a_result.user_id = a_api_result.res.user_id;
            a_result.work_name = a_api_result.res.work_name;
            a_result.subject = a_api_result.res.subject;
            a_result.application_id = a_api_result.res.application_id;
            a_result.envelope_count = a_api_result.res.envelope_count;
            a_result.status = a_api_result.res.status;
            a_result.create_date = a_api_result.res.create_date;
            a_result.update_date = a_api_result.res.update_date;
            
            if( a_api_result.res.envelopes != null){
                for(d3wApi_History.Envelope a_api_envelope : a_api_result.res.envelopes){
                    Envelope a_envelope = new Envelope();
                    a_envelope.envelope_id = a_api_envelope.envelope_id;
                    a_envelope.envelope_order = a_api_envelope.envelope_order;
                    a_envelope.envelope_value = a_api_envelope.envelope_value;
                    a_envelope.envelope_name = a_api_envelope.envelope_name;
                    a_envelope.subject = a_api_envelope.subject;
                    a_envelope.attr1 = a_api_envelope.attr1;
                    a_envelope.attr2 = a_api_envelope.attr2;
                    a_envelope.attr3 = a_api_envelope.attr3;
                    a_envelope.attr4 = a_api_envelope.attr4;
                    a_envelope.attr5 = a_api_envelope.attr5;
                    a_envelope.status = a_api_envelope.status;
                    a_envelope.document_count = a_api_envelope.document_count;
                    a_envelope.delivery_count = a_api_envelope.delivery_count;
                    a_envelope.document_status = a_api_envelope.document_status;
                    a_envelope.storage_status = a_api_envelope.storage_status;
                    a_envelope.delivery_status = a_api_envelope.delivery_status;
                    a_envelope.create_date = a_api_envelope.create_date;
                    a_envelope.update_date = a_api_envelope.update_date;
                    a_envelope.summed_status = a_api_envelope.summed_status;
                    a_result.envelopes.add(a_envelope);
                }
            }

            return a_result;
        }
    }
}