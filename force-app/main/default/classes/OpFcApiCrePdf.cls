public class OpFcApiCrePdf {

    public class Result{
        public Boolean isSuccess = false;
        public Integer statusCode = 0;
        public String endPoint = '';
        public String reqBodyRaw = '';
        public String resBodyRaw = '';
        public Res response = new Res();
    }
    public class Res {
        public String path;
    }

    public static String getEndPoint(){
        return OpfcConfs.getConfig().base_url + '/Facade';
    }
    public static String getCreatedPdfBaseEndPoint(){
        return OpfcConfs.getConfig().base_url;
    }

    public interface IClient {
        Result sendRequest(OpFcReq.Req pReq);
    }
    public class Client implements IClient{

        public Result sendRequest(OpFcReq.Req pReq){
            Result theResult = new Result();

        	HttpRequest theHttpReq = new HttpRequest(); 
	        theHttpReq.setMethod('POST');
            theHttpReq.setHeader('Content-Type','application/x-www-form-urlencoded');
            
            String theEndPoint = getEndPoint();
            theHttpReq.setEndpoint(theEndPoint);
            theResult.endPoint = theEndPoint;

            String theReqBody = pReq.getParamString();
            theResult.reqBodyRaw = theReqBody;
            theHttpReq.setBody(theReqBody);

            HTTPResponse theHttpRes = new Http().send(theHttpReq);
            Integer theStatusCode = theHttpRes.getStatusCode();
            theResult.statusCode = theStatusCode;

            String theResBody = theHttpRes.getBody();
            theResult.resBodyRaw = theResBody;
            if(theStatusCode == 200){
                theResult.response = (Res)JSON.deserialize(theResBody,Res.class);
                theResult.isSuccess = true;
            }
            
            return theResult;
        }
    }
}