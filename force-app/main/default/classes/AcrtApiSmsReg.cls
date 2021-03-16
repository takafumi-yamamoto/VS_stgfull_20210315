public class AcrtApiSmsReg {

    public static IClient getClient(){
        return new Client( AcrtSmsConf.getConfig(), TesterPhones.getInstance() );
    }
    
    public class Req {
        public String text_long = '';
        public String shorten_url = 'yes';
        public String telno = '';
        public String user_ref = '';
        public Integer timeout = 0;
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

    public class Res{
        public string action = '';
        public String telno = '';
        public String delivery_id = '';
        public String result_code = '';
        public String message = '';
        public String register_time = '';
    }
    
    public interface IClient {
        Result sendRequest(Req pReq);
    }
    public class Client implements IClient{

        private AcrtSmsConf.Config mConfig = AcrtSmsConf.getConfig();
        private TesterPhones.ITesterPhones mTesterPhones;
        public Client(AcrtSmsConf.Config pConfig, TesterPhones.ITesterPhones pTesterPhones){
            this.mConfig = pConfig;
            this.mTesterPhones = pTesterPhones;
        }
        public String getEndPoint(){
            return mConfig.base_url + '/sms_reg/' + mConfig.accrete_account_id + '/json';
        }
        public Result sendRequest(Req pReq){
            return this.sendRequest(this.getEndPoint(), mConfig.request_id, mConfig.request_pass, pReq);
        }
    
        public Result sendRequest(String pEndPoint, String pAcrtReqId, String pAcrtReqPass, Req pReq){

            Result theResult = new Result();
            theResult.isSuccess = false;
            theResult.req = pReq;
    
            this.mTesterPhones.raiseNotTesterExIfNotAllowed(pReq.telno);
            
            HttpRequest theHttpReq = new HttpRequest();
            theResult.endPoint = pEndPoint;
            theHttpReq.setEndpoint(pEndPoint);
            
            theHttpReq.setMethod('POST');
            theHttpReq.setHeader('Content-Type','application/x-www-form-urlencoded');
            if( pReq.timeout >= 0 ) theHttpReq.setTimeout(30000);
    
            List<String> params = new List<String>();
            params.add(
                String.format('{0}={1}', new List<String>{ 'id', pAcrtReqId })
            );
            params.add(
                String.format('{0}={1}', new List<String>{ 'pass', pAcrtReqPass })
            );
            params.add(
                String.format('{0}={1}', new List<String>{ 'text.long', EncodingUtil.urlEncode(pReq.text_long, 'UTF-8') })
            );
            params.add(
                String.format('{0}={1}', new List<String>{ 'shorten_url', pReq.shorten_url })
            );
            params.add(
                String.format('{0}={1}', new List<String>{ 'telno', pReq.telno })
            );
            if( !String.isBlank(pReq.user_ref) ){
                params.add(
                    String.format('{0}={1}', new List<String>{ 'user_ref', pReq.user_ref })
                );
            }
    
            String theReqBody = String.join(params, '&');
            theResult.reqBodyRaw = theReqBody;
            theHttpReq.setBody( theReqBody );
            
            HTTPResponse theHttpRes = new Http().send(theHttpReq);
    
            Integer theStatusCode = theHttpRes.getStatusCode();
            theResult.statusCode = theStatusCode;
    
            String theResBody = theHttpRes.getBody();
            theResult.resBodyRaw = theResBody;
    
            if(theStatusCode == 200){
                theResult.isSuccess = true;
                theResult.res = (Res)JSON.deserialize(theResBody,Res.class);
            }else{
                try{
                    theResult.res = (Res)JSON.deserialize(theResBody,Res.class);
                }catch(Exception ex){/* ignore */}
            }
    
            return theResult;
        }
    }
}