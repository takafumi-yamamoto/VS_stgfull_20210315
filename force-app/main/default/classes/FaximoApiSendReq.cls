public class FaximoApiSendReq {

    public class Request{
        public List<SendtoInfo> sendto;
        public String userkey;
        public String tsi;
        public String headerinfo;
        public String retrynum;
        public String resaddress;
        public String subject;
        public String body;
        public List<AttachmentInfo> Attachment;
    }

    public class Response{
        public String result;
        public String processkey;
        public String accepttime;
        public String idxcnt;
    }

    public class SendtoInfo{
        public String faxno;
    }

    public class AttachmentInfo{
        public String attachmentname;
        public String attachmentdata;
    }

    public class Result{
        public String seikyuId = '';
        public Boolean isSuccess = false;
        public Integer statusCode = 0;
        public String endPoint = '';
        public String reqBodyRaw = '';
        public String resBodyRaw = '';
        public Response response = new Response();
    }

    public interface IClient {
        Result sendRequest(
            String pUserId, 
            String pPassword, 
            String pBaseUrl, 
            String pFaximoNumber, 
            Request pReq
        );
    }
    public class Client implements IClient{
        public Result sendRequest(
            String pUserId, 
            String pPassword, 
            String pBaseUrl, 
            String pFaximoNumber, 
            Request pReq
        ){
            Result theResult = new Result();
            
            try{
                theResult.endPoint = pBaseUrl + '/snd/v1/request.json';
                theResult.reqBodyRaw = JSON.serialize(pReq);

                String theCredential = pUserId + ':' + pPassword;
                String theToken = EncodingUtil.base64Encode(Blob.valueOf(theCredential));

                HttpRequest theHttpReq = new HttpRequest(); 
                theHttpReq.setMethod('POST');
                theHttpReq.setHeader('X-Auth',theToken);
                theHttpReq.setHeader('X-Processkey', pFaximoNumber);
                theHttpReq.setEndpoint(theResult.endPoint);
                theHttpReq.setBody(theResult.reqBodyRaw );

                HTTPResponse theHttpRes = new Http().send(theHttpReq);
                theResult.statusCode = theHttpRes.getStatusCode();

                String theResBody = theHttpRes.getBody();
                theResult.resBodyRaw = theResBody;
                theResult.isSuccess = theResult.statusCode == 200 ? true : false;
                theResult.response = (Response)JSON.deserialize(theResBody,Response.class);

                Loggings.writeLog(
                    Loggings.createLogEntry(theResult.statusCode == 200 ? Loggings.Level.Info : Loggings.Level.Error, '20210201-2328', 'FaximoApiSendReq')
                        .putAttr('Request', JSON.serialize(pReq))
                        .putAttr('theResult.statusCode', String.valueOf(theResult.statusCode))
                        .putAttr('theResult.resBodyRaw', theResult.resBodyRaw)
                );

            }catch(Exception e){
                Loggings.writeLog(
                    Loggings.createLogEntry(Loggings.Level.Error, '20210201-2329', 'FaximoApiSendReq')
                        .putAttr('theResult.statusCode', String.valueOf(theResult.statusCode))
                        .putAttr('theResult.reqBodyRaw', theResult.reqBodyRaw)
                        .putAttr('theResult.resBodyRaw', theResult.resBodyRaw)
                        .putAttr('Exception', e.getMessage())
                        .putAttr('LineNumber', '' + e.getLineNumber())
                        .putAttr('getStackTraceString', e.getStackTraceString())
                );
            }
            
            return theResult;
        }
    }
}