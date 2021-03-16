public class RsCoreApi_Images_Delete {

    public class ReqArgs{
        public Long imageId { get; set; }
    }

    public class Result{
        public Boolean isError { get;private set; }
        public String endPoint { get; private set; }
        public String reqBodyRaw  { get; private set; }
        public Integer statusCode { get;private set; }
        public String resBodyRaw { get; private set; }
        public String descr { get; private set; }
    }

    public class Agent{
        public Result sendRequest(ReqArgs pReqArgs){
            
            Result theResult = new Result();
            theResult.isError = false;
            
            try {
                theResult.endPoint = RsCoreApi_Configs.getConfig().EndPoint__c + '/images/' + pReqArgs.imageId;
                
                HttpRequest request = new HttpRequest();
                request.setEndpoint(theResult.endPoint);
                request.setMethod('DELETE');
                request.setHeader('Content-Type', 'application/json;charset=UTF-8');
                
                RsCoreApi_AuthClients.getInstance().setAuthHeader(request);
                HttpResponse response = new http().send(request);
                
                theResult.statusCode = response.getStatusCode();
                if(theResult.statusCode != 204) theResult.isError = true;
                theResult.resBodyRaw = response.getBody();
            }catch(Exception e){
                theResult.isError = true;
                theResult.descr = e.getMessage();
                System.Debug(theResult.descr);
            }

            return theResult;
        }
    }
}