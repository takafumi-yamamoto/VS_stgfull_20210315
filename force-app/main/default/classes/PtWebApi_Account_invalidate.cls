public class PtWebApi_Account_invalidate {
    private class ReqBody{
        String torihikisaki_bango = '';
        String email = '';
        Boolean is_send_mail = true;
    }
    public class ReqArgs{
        public String torihikisaki_bango = '';
        public String email = '';
        public Boolean is_send_mail = true;
    }
    public  class Result{
        public Boolean isSuccess = false;
        public String endPoint = '';
        public Integer statusCode = 0;
        public String descr = '';
        public String reqBodyRaw = '';
        public String resBodyRaw = '';
    }

   public class Agent{
        public Result sendRequest(ReqArgs pReqArgs){
            Result theResult = new Result();
            
            try {
                theResult.endPoint = PtWebApi_Configs.getConfig().BaseEndPoint__c + '/api/sf/account/invalidate';
                theResult.reqBodyRaw = this.createReqBodyJson(pReqArgs);

                HttpRequest request = new HttpRequest();
                request.setEndpoint(theResult.endPoint);
                request.setMethod('POST');
                request.setHeader('Content-Type', 'application/json;charset=UTF-8');
                request.setBody( theResult.reqBodyRaw );
                PtWebApi_Auth.setAuthHeader(request);

                HttpResponse response = new http().send(request);

                theResult.statusCode = response.getStatusCode();
                theResult.resBodyRaw = response.getBody();
                theResult.isSuccess = theResult.statusCode == 200;
            }catch(Exception e){
                theResult.isSuccess = false;
                theResult.descr = e.getMessage();
                System.Debug(theResult.descr);
            }
            return theResult;
        }

        private String createReqBodyJson(ReqArgs pArgs){
            ReqBody theReqBody = new ReqBody();
            theReqBody.torihikisaki_bango = pArgs.torihikisaki_bango;
            theReqBody.email                       = pArgs.email;
            theReqBody.is_send_mail         = pArgs.is_send_mail;
            return JSON.serialize( theReqBody );
        }
    }
}