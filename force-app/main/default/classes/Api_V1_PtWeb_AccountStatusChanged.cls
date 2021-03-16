@RestResource(urlMapping='/api/v1/ptwebs/account_statuschanged/*')
global class Api_V1_PtWeb_AccountStatusChanged {

    public class Result{
        Integer statusCode = 200;
        String reqBodyRaw = '';
        String resBodyRaw = '';
        String descr = '';
        ResBodyOnErr resBodyOnErr = new ResBodyOnErr();
    }

    private class ReqBody{
        public String torihikisaki_bango = '';
        public Integer user_id = null;
        public String email = '';
        public String status = '';
    }

    public class ResBodyOnErr{
        public List<ResBodyOnErrEntry> errors = new List<ResBodyOnErrEntry>();
        public ResBodyOnErr addEntry(String pCode, String pMessage){
            this.errors.add(new ResBodyOnErrEntry(pCode, pMessage));
            return this;
        }
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
                theReqBody = (ReqBody)JSON.deserializeStrict(theReq.requestBody.toString(), ReqBody.class);
            }catch(Exception e){
                theResult.statusCode = 400;
                theResult.descr = e.getMessage();
                theResult.resBodyOnErr.addEntry(errCode_invalid_json_format, theResult.descr);
            }
        }

        if(theResult.statusCode == 200){
            try{
                Insert new PtWebAccountStatusChanged__c(
                    torihikisaki_bango__c = theReqBody.torihikisaki_bango,
                    ExternalId__c = theReqBody.user_id,
                    mailaddress__c = theReqBody.email,
                    status__c = theReqBody.status,
                    ShoriStatus__c = 'Created'
                );
            }catch(Exception e){
                theResult.statusCode = 500;
                theResult.descr = e.getMessage();
                theResult.resBodyOnErr.addEntry(errCode_unhandled, theResult.descr);
                System.Debug( e.getMessage() );
            }
        }

        if(theResult.statusCode != 200){
            theResult.resBodyRaw = JSON.serialize(theResult.resBodyOnErr);
        }
        theRes.statusCode = theResult.statusCode;
        theRes.responseBody = Blob.valueOf(theResult.resBodyRaw);

        Loggings.writeLog(
            Loggings.createLogEntry(
                theResult.statusCode == 200 ? Loggings.Level.Info : Loggings.Level.Error, '20180713-1328-01', 'PtWeb.Account.StatusChanged')
                .putAttr('theResult.statusCode',String.valueOf(theResult.statusCode) )
                .putAttr('theResult.reqBodyRaw',theResult.reqBodyRaw)
                .putAttr('theResult.resBodyRaw',theResult.resBodyRaw)
                .putAttr('theResult.descr',theResult.descr)
        );
    }
}