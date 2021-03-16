public class FaximoApiSendRsltReq {

    public class Request{
        public String pFrom;
        public String pTo;
    }

    public class Response{
        public String result;
        public String processkey;
        public String accepttime;
        public String count;
        public List<SendResultListInfo> SendResultList;
    }

    public class IdxcntInfo{
        public String key;
    }

    public class SendResultListInfo{
        public String idxcnt;
        public String subidxcnt;
        public String userkey;
        public String accept_type;
        public String senddate;
        public String sendto;
        public String tsid;
        public String resaddress;
        public String subject;
        public String pagenum;
        public String status;
        public String statusdetail;
    }

    public class Result{
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
            String pFaximoProcesskey, 
            Request pReq
        );
    }

    public class Client implements IClient{
        public Result sendRequest(
            String pUserId, 
            String pPassword, 
            String pBaseUrl, 
            String pFaximoProcesskey, 
            Request pReq
        ){
            Result theResult = new Result();
            
            try{
                theResult.endPoint = pBaseUrl + '/snd/v2/record_query.json?' + 'from=' + pReq.pFrom + '&to=' + pReq.pTo;
                
                String theCredential = pUserId + ':' + pPassword;
                String theToken = EncodingUtil.base64Encode(Blob.valueOf(theCredential));

                HttpRequest theHttpReq = new HttpRequest();
                theHttpReq.setEndpoint(theResult.endPoint);
                theHttpReq.setMethod('GET');
                theHttpReq.setHeader('Content-Type','application/json');
                theHttpReq.setHeader('X-Auth',theToken);
                theHttpReq.setHeader('X-Processkey', pFaximoProcesskey);

                HTTPResponse theHttpRes = new Http().send(theHttpReq);
                theResult.statusCode = theHttpRes.getStatusCode();
                
                String theResBody = theHttpRes.getBody();
                theResult.resBodyRaw = theResBody;
                theResult.isSuccess = theResult.statusCode == 200 ? true : false;
                theResult.response = (Response)JSON.deserialize(theResBody,Response.class);

                Loggings.writeLog(
                    Loggings.createLogEntry(theResult.statusCode == 200 ? Loggings.Level.Info : Loggings.Level.Error, '20210210-1534', 'FaximoApiSendRsltReq')
                        .putAttr('Request', JSON.serialize(pReq))
                        .putAttr('theResult.statusCode', String.valueOf(theResult.statusCode))
                        .putAttr('theResult.resBodyRaw', theResult.resBodyRaw)
                );

            }catch(Exception e){
                Loggings.writeLog(
                    Loggings.createLogEntry(Loggings.Level.Error, '20210210-1535', 'FaximoApiSendRsltReq')
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