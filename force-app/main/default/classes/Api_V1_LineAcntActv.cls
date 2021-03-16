@RestResource(urlMapping='/api/v1/line-account/activatation/*')
global class Api_V1_LineAcntActv {

    public class Result{
        Integer statusCode = 200;
        String reqBodyRaw = '';
        String resBodyRaw = '';
        String descr = '';
        ResBodyOnErr resBodyOnErr = new ResBodyOnErr();
        ResBodyOnSuccess resBodyOnSuccess = new ResBodyOnSuccess();
    }

    public class ReqBody{
        public String birth_date = '';
        public String mobile_phone_no = '';
        public ReqBody readJson(String pJson){
            return (ReqBody)JSON.deserializeStrict(pJson, ReqBody.class);
        }
    }

    public class ResBodyOnSuccess{
        public String torihikisaki_bango = '';
        public String serialize(){ return JSON.serialize(this); }
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
    public static String errCode_no_match = 'no_match';
    public static String errCode_duplicate_match = 'duplicate_match';

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

        if(theResult.statusCode == 200){
            theResult.resBodyRaw = theResult.resBodyOnSuccess.serialize();
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
                theLogLevel, '20190402-1527-01', 'Api_V1_LineAcntActv')
                .putAttr('theResult.statusCode',String.valueOf(theResult.statusCode) )
                .putAttr('theResult.reqBodyRaw',theResult.reqBodyRaw)
                .putAttr('theResult.resBodyRaw',theResult.resBodyRaw)
                .putAttr('theResult.descr',theResult.descr)
        );
    }

    public static void process(Result pResult, ReqBody pReqBody){

        Result theResult = pResult;
        ReqBody theReqBody = pReqBody;

        Date theBirthDate;
        String theMobilePhone;
        if(theResult.statusCode == 200){

            try{
                theBirthDate = Date.valueOf(theReqBody.birth_date);
                theMobilePhone = theReqBody.mobile_phone_no.replace('-','').replace('ー','');
            }catch (Exception e){
                theResult.statusCode = 400;
                theResult.descr = e.getMessage();
                theResult.resBodyOnErr.addEntry(errCode_invalid_json_format, theResult.descr);
            }         
        }

        if(theResult.statusCode == 200){
            if(theBirthDate == null || theMobilePhone == null || theMobilePhone.length() < 10){
                theResult.statusCode = 400;
                theResult.descr = 'too short phone no;';
                theResult.resBodyOnErr.addEntry(errCode_invalid_json_format, theResult.descr);
            }
        }

        if(theResult.statusCode == 200){
            List<Account> theSoryos = [
                select 
                Id, TorihikisakiBango__c from Account 
                where Seinengappi__c = :theBirthDate and MobilePhoneFormula__c = :theMobilePhone
                and RecordType.DeveloperName = 'SoryoAccount'
                limit 2
            ];

            if( theSoryos.size() >= 2 ){
                theResult.statusCode = 400;
                theResult.descr = 'duplicate_match';
                theResult.resBodyOnErr.addEntry(errCode_duplicate_match, theResult.descr);
            }
            if( theSoryos.size() <= 0 ){
                theResult.statusCode = 400;
                theResult.descr = 'no_match;';
                theResult.resBodyOnErr.addEntry(errCode_no_match, theResult.descr);
            }
            if( theSoryos.size() == 1 ){
                Account theAccount = theSoryos[0];
                UPDATE new Account(Id = theAccount.Id, IsOboStLineAcnt__c = true );
                theResult.resBodyOnSuccess.torihikisaki_bango = theAccount.TorihikisakiBango__c;
            }
        }
    }
}