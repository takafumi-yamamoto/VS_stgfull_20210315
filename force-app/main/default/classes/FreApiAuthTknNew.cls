public class FreApiAuthTknNew {

    public static IClient get_IClient_instance(){
        return new Client();
    }
    
    public class Request{
        public String grant_type;
        public String client_id;
        public String client_secret;
        public String code;
        public String redirect_uri;
    }
    public class Response{
        public String access_token;
        public String token_type;
        public Decimal expires_in;
        public String refresh_token;
        public String scope;
        public Decimal created_at; 
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
        Result sendRequest(String pEndPoint, Request pReq);
    }
    public class Client implements IClient{

        public Result sendRequest(String pEndPoint, Request pReq){
            Result theResult = new Result();

        	HttpRequest theHttpReq = new HttpRequest(); 
	        theHttpReq.setMethod('POST');
            theHttpReq.setHeader('Content-Type','application/x-www-form-urlencoded');
            
            String theEndPoint = pEndPoint;
            theHttpReq.setEndpoint(theEndPoint);
            theResult.endPoint = theEndPoint;

            String theReqBody = '';
            theReqBody += 'grant_type=' + pReq.grant_type;
            theReqBody += '&client_id=' + pReq.client_id; 
            theReqBody += '&client_secret=' + pReq.client_secret;
            theReqBody += '&code=' + pReq.code;
            theReqBody += '&redirect_uri=' + EncodingUtil.urlEncode(pReq.redirect_uri, 'UTF-8');
            theResult.reqBodyRaw = theReqBody;
            theHttpReq.setBody(theReqBody);

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