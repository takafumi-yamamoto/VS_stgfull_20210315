public class OboStApi_MessagePush_Post {
    private LineMsgConfig my_LineMsgConfig = new LineMsgConfig();

    public class Result {
        public Boolean isSuccess = false;
        public String endPoint = '';
        public Integer statusCode = 0;
        public String descr = '';
        public String reqBodyRaw = '';
        public String resBodyRaw = '';
    }

    public class ReqBody{
        public String partner_id = '';
        public List<Message> messages = new List<Message>();
        public String toJson(){ return JSON.serialize( this ); }
        public ReqBody setPartnerId(String pValue){
            this.partner_id = pValue;
            return this;
        }
        public ReqBody addTextMsg(String pText){ 
            Message theMessage = new Message();
            theMessage.type = 'text'; theMessage.text = pText;
            this.messages.add(theMessage);
            return this;
        }

    }
    public class Message{
        public String type = 'text';
        public String text = ''; 
    }

    public Result sendRequest(ReqBody pReqBody) {
        OboStConfig theConfig = new OboStConfig();

        Result theResult = new Result();
        try {
            theResult.endPoint = theConfig.getBaseEndPoint() + '/api/message/push';
            theResult.reqBodyRaw = pReqBody.toJson();

            HttpRequest request = new HttpRequest();
            request.setEndpoint(theResult.endPoint);
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json;charset=UTF-8');
            request.setBody( theResult.reqBodyRaw );
            new OboStApi_Auth().setAuthHeader(request);


            if( !this.my_LineMsgConfig.canSend(pReqBody.partner_id) ){
                theResult.isSuccess = false; 
                theResult.descr = 'NotAllowed';
                Loggings.writeLog(
                    Loggings.createLogEntry(
                        Loggings.Level.Error, '20190523-1118-01', 'OboStApi_MessagePush_Post.sendRequest', 'NotAllowed')
                        .putAttr('pReqBody.partner_id',pReqBody.partner_id)
                        .putAttr('theResult.descr',theResult.descr)
                );
                return theResult; 
            }
            HttpResponse response = new http().send(request);

            theResult.statusCode = response.getStatusCode();
            theResult.resBodyRaw = response.getBody();
            theResult.isSuccess = theResult.statusCode == 200;

        } catch(Exception e){
            theResult.isSuccess = false;
            theResult.descr = e.getMessage();
            System.debug(theResult.descr);
        }

        Loggings.Level theLogLevel = Loggings.Level.Info;
        if( !theResult.isSuccess ) theLogLevel = Loggings.Level.Error;
        Loggings.writeLog(
            Loggings.createLogEntry(
                theLogLevel, '20190521-1539-01', 'OboStApi_MessagePush_Post.sendRequest')
                .putAttr('theResult.endPoint', theResult.endPoint)
                .putAttr('theResult.statusCode', String.valueOf(theResult.statusCode))
                .putAttr('theResult.reqBodyRaw',theResult.reqBodyRaw)
                .putAttr('theResult.resBodyRaw',theResult.resBodyRaw)
                .putAttr('theResult.descr',theResult.descr)
        );

        return theResult;
    }
}