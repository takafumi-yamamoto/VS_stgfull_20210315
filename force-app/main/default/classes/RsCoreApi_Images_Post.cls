public class RsCoreApi_Images_Post {

    private class ReqBody{
        public ReqBody_Image image { get; set; }
        public String type { get; set; }
        public Long typeAssociateId { get; set; }
        public String purpose { get; set; }
        public Boolean published { get; set; }
    }

    private class ReqBody_Image{
        public String extension { get; set; }
        public String base64Data { get; set; }
    }

    public class ReqArgs{
        public String extension  { get; set; }
        public String base64Data { get; set; }
        public String type { get; set; }    
        public String purpose { get; set; }
        public Long typeAssociateId { get; set; }
        public Boolean published { get; set; }
    }

    public class ResBody{
        @TestVisible public Long id { get; private set; }
        @TestVisible public String url { get; private set; }
    }

    public class Result{
        public Boolean isError { get; set; }
        public String resBodyRaw { get; set; }
        public String endPoint { get; private set; }
        public Integer statusCode { get; set; }
        public String reqBodyRaw  { get; set; }
        public String url { get; set; }
        public String id { get; set; }
        public String descr { get; set; }
    }

    public class Agent{
        public Result sendRequest(ReqArgs pReqArgs){
            Result theResult = new Result();
            theResult.isError = false;
            
            try {
                theResult.endPoint = RsCoreApi_Configs.getConfig().EndPoint__c + '/images';
                theResult.reqBodyRaw = this.createReqBodyJson(pReqArgs);

                HttpRequest request = new HttpRequest();
                request.setEndpoint(theResult.endPoint);
                request.setMethod('POST');
                request.setHeader('Content-Type', 'application/json;charset=UTF-8');
                request.setBody( theResult.reqBodyRaw );

                RsCoreApi_AuthClients.getInstance().setAuthHeader(request);
                HttpResponse response = new http().send(request);

                theResult.statusCode = response.getStatusCode();
                if(theResult.statusCode != 201) theResult.isError = true;
                theResult.resBodyRaw = response.getBody();
                if( !theResult.isError ){
                    ResBody theResBody = (ResBody)JSON.deserialize(response.getBody(), ResBody.class);
                    theResult.id = String.valueOf(theResBody.id);
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
            theReqBody.type = pArgs.type;
            theReqBody.typeAssociateId = pArgs.typeAssociateId;
            theReqBody.purpose = pArgs.purpose;
            theReqBody.published = pArgs.published;

            String theJson = JSON.serialize( theReqBody );
            return theJson;
        }
    }
}