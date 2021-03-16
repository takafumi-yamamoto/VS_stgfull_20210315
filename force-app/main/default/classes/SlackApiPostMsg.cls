public class SlackApiPostMsg {

    public static IClient get_IClient_instance(){
        return new Client(
            SlackApiPostMsgConf.get_IProvider_instance().getConfig().endpoint
        );
    }
    public class Req{
        public String channel = '';
        public Req set_channel(String pValue){ this.channel = pValue; return this;}
        public String username = '';
        public Req set_username(String pValue){ this.username = pValue; return this;}
        public String text = '';
        public Req set_text(String pValue){ this.text = pValue; return this;}
    }

    public class Result{
        public Boolean isSuccess = false;
        public Integer statusCode = 0;
        public String endPoint = '';
        public String reqBodyRaw = '';
        public String resBodyRaw = '';
    }

    public interface IClient {
        Result sendRequest(Req pReq);
    }
    public class Client implements IClient{
        private String m_Endpoint;
        public Client(String p_Endpoint){
            this.m_Endpoint = p_Endpoint;
        }

        public Result sendRequest(Req pReq){
            Result theResult = new Result();

        	HttpRequest theHttpReq = new HttpRequest(); 
	        theHttpReq.setMethod('POST');
            theHttpReq.setHeader('Content-Type','application/json');
            
            theHttpReq.setEndpoint(this.m_Endpoint);
            theResult.endPoint = this.m_Endpoint;

            String theReqBody = JSON.serialize(pReq);
            theResult.reqBodyRaw = theReqBody;
            theHttpReq.setBody(theReqBody);

            HTTPResponse theHttpRes = new Http().send(theHttpReq);
            Integer theStatusCode = theHttpRes.getStatusCode();
            theResult.statusCode = theStatusCode;

            String theResBody = theHttpRes.getBody();
            theResult.resBodyRaw = theResBody;
            if(theStatusCode == 200){
                theResult.isSuccess = true;
            }
            
            return theResult;
        }
    }
}