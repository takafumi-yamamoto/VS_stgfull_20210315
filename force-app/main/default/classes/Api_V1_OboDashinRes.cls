@RestResource(urlMapping='/api/v1/obo-dashin-res')
global class Api_V1_OboDashinRes {

    public class Result{
        Integer statusCode = 200;
        String reqBodyRaw = '';
        String resBodyRaw = '';
        String descr = '';
        ResBodyOnErr resBodyOnErr = new ResBodyOnErr();
    }

    public class ReqBody{
        public Integer offer_Id = 0;
        public String shodan_bango = '';
        public String result = '';
        public String sokyakusaki = '';
        public String sekotanto = '';
        public String accepted_datetime = '';
        public List<Reply> replies = new List<Reply>();
        public ReqBody readJson(String pJson){
            return (ReqBody)JSON.deserializeStrict(pJson, ReqBody.class);
        }
        public Datetime parseAcceptedDateTime(){
            if( String.isBlank(this.accepted_datetime) ) return null;

            if( this.accepted_datetime.length() == 16 ){ //eg. 2019-05-20 15:00
                String theStrVal = this.accepted_datetime + ':00';
                return Datetime.valueOf(theStrVal);
            }
            else { //eg. 2019-05-20
                String theStrVal = this.accepted_datetime + ' 00:00:00';
                return Datetime.valueOf(theStrVal);
            }
        }
        public List<String> collectRejectedKeiyakuBangos(){
            List<String> theKeiyakuBangos = new List<String>();
            for(Reply aReply : this.replies){
                if(aReply.answer == 'reject') theKeiyakuBangos.add( aReply.keiyaku_bango );
            }
            return theKeiyakuBangos;
        }
    }
    public class Reply{
        public String keiyaku_bango = '';
        public String answer = '';
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

                if( theReqBody.offer_id == null) {
                    theResult.statusCode = 400; theResult.resBodyOnErr.addEntry(errCode_invalid_json_format, 'offer_id is mandatory');
                }
                if( String.isBlank(theReqBody.shodan_bango) ) {
                    theResult.statusCode = 400; theResult.resBodyOnErr.addEntry(errCode_invalid_json_format, 'shodan_bango is mandatory');
                }
                if( String.isBlank(theReqBody.result) ) {
                    theResult.statusCode = 400; theResult.resBodyOnErr.addEntry(errCode_invalid_json_format, 'result is mandatory');
                }
                if( theReqBody.result == 'ok') {
                    if( String.isBlank(theReqBody.sokyakusaki) ) {
                        theResult.statusCode = 400; theResult.resBodyOnErr.addEntry(errCode_invalid_json_format, 'sokyakusaki is mandatory when result is ok');
                    }
                    if( String.isBlank(theReqBody.sekotanto) ) {
                        theResult.statusCode = 400; theResult.resBodyOnErr.addEntry(errCode_invalid_json_format, 'sekotanto is mandatory when result is ok');
                    }
                }
                if( theReqBody.replies == null){
                    theResult.statusCode = 400; theResult.resBodyOnErr.addEntry(errCode_invalid_json_format, 'replies must be a list');
                }
                if( theReqBody.replies != null) {
                    for(Reply reply : theReqBody.replies){
                        if( String.isBlank(reply.keiyaku_bango) ) {
                            theResult.statusCode = 400; theResult.resBodyOnErr.addEntry(errCode_invalid_json_format, 'reply.keiyaku_bango is mandatory');
                        }
                        if( String.isBlank(reply.answer) ) {
                            theResult.statusCode = 400; theResult.resBodyOnErr.addEntry(errCode_invalid_json_format, 'reply.answer is mandatory');
                        }
                    }
                }
            }catch(Exception e){
                theResult.statusCode = 400;
                theResult.descr = e.getMessage();
                theResult.resBodyOnErr.addEntry(errCode_invalid_json_format, theResult.descr);
                System.debug(e);
            }
        }

        if(theResult.statusCode == 200){
            try{
                INSERT new OboDashinResTask__c(
                    data__c = JSON.serialize(theReqBody),
                    ShoriStatus__c = 'Created'
                );
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
                theLogLevel, '20190517-1207-01', 'Api_V1_OboDashinRes')
                .putAttr('theResult.statusCode',String.valueOf(theResult.statusCode) )
                .putAttr('theResult.reqBodyRaw',theResult.reqBodyRaw)
                .putAttr('theResult.resBodyRaw',theResult.resBodyRaw)
                .putAttr('theResult.descr',theResult.descr)
        );
    }

}