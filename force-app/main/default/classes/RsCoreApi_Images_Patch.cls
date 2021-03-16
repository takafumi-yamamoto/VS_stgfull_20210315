public class RsCoreApi_Images_Patch {

    private class ReqBody{
        public ReqBody_Image image { get; set; }
        public Boolean published { get; set; }
    }

    private class ReqBody_Image{
        public String extension { get; set; }
        public String base64Data { get; set; }
    }

    public class ReqArgs{
        public String extension  { get; set; }
        public String base64Data { get; set; }   
        public String imageId { get; set; }
        public Boolean published { get; set; }
    }

    public class ResBody{
        public Long id { get; set; }
        public String url { get; set; }
    }

    public class Result{
        public Boolean isError { get; set; }
        public String reqBodyRaw  { get; set; }
        public String endPoint { get; private set; }
        public Integer statusCode { get; set; }
        public String resBodyRaw { get; set; }
        public Long id { get; set; }
        public String url { get; set; }
        public String descr { get; set; }
    }

    public class Agent{
        public Result sendRequest(ReqArgs pReqArgs){
            Result theResult = new Result();
            theResult.isError = false;
            
            try {
                theResult.endPoint = RsCoreApi_Configs.getConfig().EndPoint__c + '/images/' + pReqArgs.imageId;
                theResult.reqBodyRaw = this.createReqBodyJson(pReqArgs);

                HttpRequest request = new HttpRequest();
                request.setEndpoint(theResult.endPoint);
                request.setMethod('POST');
                request.setHeader('Content-Type', 'application/json;charset=UTF-8');
                request.setBody( theResult.reqBodyRaw );
                
                RsCoreApi_AuthClients.getInstance().setAuthHeader(request);
                HttpResponse response = new http().send(request);
                
                theResult.statusCode = response.getStatusCode();
                if(theResult.statusCode != 200) theResult.isError = true;
                theResult.resBodyRaw = response.getBody();
                if( !theResult.isError ){
                    ResBody theResBody = (ResBody)JSON.deserialize(theResult.resBodyRaw, ResBody.class);
                    theResult.id = theResBody.id;
                    theResult.url = theResBody.url;
                }
            }catch(Exception e){
                theResult.isError = true;
                theResult.descr = e.getMessage();
                System.Debug(theResult.descr);
            }
            
            return theResult;
        }

        private String createReqBodyJson(ReqArgs pArgs){
            ReqBody_Image theReqBody_Image = new ReqBody_Image();
            theReqBody_Image.extension = pArgs.extension;
            theReqBody_Image.base64Data = pArgs.base64Data;

            ReqBody theReqBody = new ReqBody();
            theReqBody.image = theReqBody_Image;
            theReqBody.published = pArgs.published;

            String theJson = JSON.serialize( theReqBody );
            return theJson;
        }
    }
}