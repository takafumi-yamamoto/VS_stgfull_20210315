public class AcrtApiSmsDr {

    public class Req {
        public String id = '';
        public String pass = '';
        public String delivery_id = '';
        public Integer timeout = 0;
    }

    public class Res{
        public string action = '';
        public String telno = '';
        public String delivery_id = '';
        public String result_code = '';
        public String message = '';
        public String user_ref = '';
        public String operator = '';
        public String totalmsgnum = '';
    }

    public class Result{
        public Boolean isSuccess = false;
        public Integer statusCode = 0;
        public String endPoint = '';
        public String reqBodyRaw = '';
        public String resBodyRaw = '';
        public Req req = new Req();
        public Res res = new Res();
    }

    public static String result_code_delivered = '0001';
    public static String result_code_undelivered = '0002';
    public static String result_code_undefined = '0003';
    public static String result_code_unknown_subscriber = '0004';

    public class SmsDrException extends Exception{}
    
    public interface IClient {
        Result sendRequest(String pEndPoint, Req pReq);
    }
    public class Client implements IClient{
        
        public Result sendRequest(String pEndPoint, Req pReq){

            Result theResult = new Result();
            theResult.req = pReq;
            
            HttpRequest theHttpReq = new HttpRequest();
            theResult.endPoint = pEndPoint;
            theHttpReq.setEndpoint(pEndPoint);
            
	        theHttpReq.setMethod('POST');
            theHttpReq.setHeader('Content-Type','application/x-www-form-urlencoded');
            if(pReq.timeout > 0){
                theHttpReq.setTimeout(pReq.timeout);
            }
            

            List<String> params = new List<String>();
            params.add(
                String.format('{0}={1}', new List<String>{ 'id', pReq.id })
            );
            params.add(
                String.format('{0}={1}', new List<String>{ 'pass', pReq.pass })
            );
            params.add(
                String.format('{0}={1}', new List<String>{ 'delivery_id', pReq.delivery_id })
            );

            String theReqBody = String.join(params, '&');
            theResult.reqBodyRaw = theReqBody;
            theHttpReq.setBody( theReqBody );
            
            HTTPResponse theHttpRes = new Http().send(theHttpReq);

            Integer theStatusCode = theHttpRes.getStatusCode();
            theResult.statusCode = theStatusCode;

            String theResBody = theHttpRes.getBody();
            theResult.resBodyRaw = theResBody;

            if(theStatusCode == 200){
                theResult.res = (Res)JSON.deserialize(theResBody,Res.class);
            }else{
                try{
                    theResult.res = (Res)JSON.deserialize(theResBody,Res.class);
                }catch(Exception ex){/* ignore */}
            }

            if(theStatusCode != 200){
                throw new SmsDrException( JSON.serializePretty(theResult) );
            }

            theResult.isSuccess = true;

            return theResult;
        }
    }

}