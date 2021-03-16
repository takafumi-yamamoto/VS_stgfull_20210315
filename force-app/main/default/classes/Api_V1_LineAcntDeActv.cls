@RestResource(urlMapping='/api/v1/line-account/deactivatation/*')
global class Api_V1_LineAcntDeActv {

    public class Result{
        Integer statusCode = 200;
        String reqBodyRaw = '';
        String resBodyRaw = '';
        String descr = '';
        ResBodyOnErr resBodyOnErr = new ResBodyOnErr();
    }

    public class ReqBody{
        public String torihikisaki_bango = '';
        public ReqBody readJson(String pJson){
            return (ReqBody)JSON.deserializeStrict(pJson, ReqBody.class);
        }
    }

    public class ResBodyOnErr{
        public List<ResBodyOnErrEntry> errors = new List<ResBodyOnErrEntry>();
        public ResBodyOnErr addEntry(String pCode, String pMessage){
            this.errors.add(new ResBodyOnErrEntry(pCode, pMessage));
            return this;
        }
        public String serialize(){ return JSON.serialize(this); }
    }
    public class ResBodyOnErrEntry{
        public ResBodyOnErrEntry(String pCode, String pMessage){ this.code = pCode; this.message = pMessage; }
        public string code = '';
        public string message = ''; 
    }
    public static String errCode_unhandled = 'unhandled';
    public static String errCode_invalid_json_format = 'invalid_json_format';

    @HttpPost
    global static void doPost() {

        Result theResult = new Result(); theResult.statusCode = 200;
        RestRequest theReq = RestContext.request;
        RestResponse theRes = RestContext.response;

        ReqBody theReqBody = null;
        if(theResult.statusCode == 200){
            try{
                theResult.reqBodyRaw = theReq.requestBody.toString();
                theReqBody = new ReqBody().readJson(theResult.reqBodyRaw);
                if(String.isBlank(theReqBody.torihikisaki_bango)){
                    theResult.statusCode = 400;
                    theResult.descr = 'torihikisaki_bango is mandatory';
                    theResult.resBodyOnErr.addEntry(errCode_invalid_json_format, theResult.descr);
                }   
            }catch(Exception e){
                theResult.statusCode = 400;
                theResult.descr = e.getMessage();
                theResult.resBodyOnErr.addEntry(errCode_invalid_json_format, theResult.descr);
            }
        }

        if(theResult.statusCode == 200){
            try{
                process(theResult, theReqBody);
            }catch(Exception e){
                theResult.statusCode = 500;
                theResult.descr = e.getMessage();
                theResult.resBodyOnErr.addEntry(errCode_unhandled, theResult.descr);
            }
        }

        if(theResult.statusCode != 200){
            theResult.resBodyRaw = theResult.resBodyOnErr.serialize();
        }
        
        theRes.statusCode = theResult.statusCode;
        theRes.responseBody = Blob.valueOf(theResult.resBodyRaw);

        Loggings.Level theLogLevel = Loggings.Level.Info;
        if(theResult.statusCode == 400) theLogLevel = Loggings.Level.Warn;
        if(theResult.statusCode == 500) theLogLevel = Loggings.Level.Error;
        Loggings.writeLog(
            Loggings.createLogEntry(
                theLogLevel, '20190520-1101-01', 'Api_V1_LineAcntDeActv')
                .putAttr('theResult.statusCode',String.valueOf(theResult.statusCode) )
                .putAttr('theResult.reqBodyRaw',theResult.reqBodyRaw)
                .putAttr('theResult.resBodyRaw',theResult.resBodyRaw)
                .putAttr('theResult.descr',theResult.descr)
        );
    }

    public static void process(Result pResult, ReqBody pReqBody){

        Result theResult = pResult;
        ReqBody theReqBody = pReqBody;

        if(theResult.statusCode == 200){
            List<Account> theSoryos = [
                select 
                Id, TorihikisakiBango__c from Account 
                where TorihikisakiBango__c = :theReqBody.torihikisaki_bango
                and RecordType.DeveloperName = 'SoryoAccount'
                limit 1
            ];

            if( theSoryos.size() == 1 ){
                Account theAccount = theSoryos[0];
                UPDATE new Account(Id = theAccount.Id, IsOboStLineAcnt__c = false );
            }
        }
    }
}