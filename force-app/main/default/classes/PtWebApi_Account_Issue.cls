public class PtWebApi_Account_Issue {

    private class ReqBody{
        String email = '';
        String torihikisaki_bango = '';
        String torihikisaki_name = '';
        String role = '';
    }
    public class ReqArgs{
        public String email = '';
        public String torihikisaki_bango = '';
        public String torihikisaki_name = '';
        public String role = '';
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
                TesterMails.getInstance().raiseNotTesterExIfNotAllowed(pReqArgs.email);
                theResult.endPoint = PtWebApi_Configs.getConfig().BaseEndPoint__c + '/api/sf/account/issue';
                theResult.reqBodyRaw = this.createReqBodyJson(pReqArgs);

                HttpRequest request = new HttpRequest();
                request.setEndpoint(theResult.endPoint);
                request.setMethod('POST');
                request.setHeader('Content-Type', 'application/json;charset=UTF-8');
                request.setBody( theResult.reqBodyRaw );
                PtWebApi_Auth.setAuthHeader(request);

                System.Debug(request.getHeader('Authorization') );
                System.Debug(request);
                HttpResponse response = new http().send(request);

                theResult.statusCode = response.getStatusCode();
                theResult.resBodyRaw = response.getBody();
                theResult.isSuccess = theResult.statusCode == 200;
            }catch(Exception e){
                theResult.isSuccess = false;
                theResult.descr = e.getMessage();
                System.Debug(theResult.descr);
            }

            System.Debug(theResult);
            return theResult;
        }

        private String createReqBodyJson(ReqArgs pArgs){
            ReqBody theReqBody = new ReqBody();
            theReqBody.torihikisaki_bango = pArgs.torihikisaki_bango;
            theReqBody.torihikisaki_name = pArgs.torihikisaki_name;
            theReqBody.email = pArgs.email;
            theReqBody.role = pArgs.role;
            return JSON.serialize( theReqBody );
        }
    }
}