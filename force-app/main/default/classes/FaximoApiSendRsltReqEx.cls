public class FaximoApiSendRsltReqEx {

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
        public FaximoApiSendRsltReq.Result apiResult;
        public Response response = new Response();
    }

    public interface IClient {
        Result sendRequest(Request pReq);
    }
    
    public class Client implements IClient{
        private FaximoConfs.Config mConfig;
        private FaximoApiSendRsltReq.IClient mApiClient;
        private ResponseConverter mResponseConverter;
        public Client(FaximoConfs.Config pConfig, FaximoApiSendRsltReq.IClient pApiClient, ResponseConverter pResponseConverter){
            this.mConfig = pConfig;
            this.mApiClient = pApiClient;
            this.mResponseConverter = pResponseConverter;
        }

        public Result sendRequest(Request pReq){
            FaximoApiSendRsltReq.Request theApiReq = new FaximoApiSendRsltReq.Request();
            theApiReq.pFrom = pReq.pFrom;
            theApiReq.pTo = pReq.pTo;
            
            FaximoApiSendRsltReq.Result theApiResult = 
                this.mApiClient.sendRequest(
                    this.mConfig.userId, 
                    this.mConfig.password,
                    this.mConfig.api_base_url,
                    this.mConfig.faximoProcesskey,
                    theApiReq
                );

            Result theResult = new Result();
            theResult.isSuccess = theApiResult.isSuccess;
            theResult.apiResult = theApiResult;
            theResult.response = this.mResponseConverter.convertResponse(theApiResult.response);
            return theResult;
        }
    }

    public class ResponseConverter{

        public Response convertResponse(FaximoApiSendRsltReq.Response pApiResponse){
            List<SendResultListInfo> theSendResultListInfoList = new List<SendResultListInfo>();
            for(FaximoApiSendRsltReq.SendResultListInfo aSendResult : pApiResponse.SendResultList){
                SendResultListInfo aSendResultListInfo = new SendResultListInfo();
                aSendResultListInfo.idxcnt = aSendResult.idxcnt;
                aSendResultListInfo.subidxcnt = aSendResult.subidxcnt;
                aSendResultListInfo.userkey = aSendResult.userkey;
                aSendResultListInfo.accept_type = aSendResult.accept_type;
                aSendResultListInfo.senddate = aSendResult.senddate;
                aSendResultListInfo.sendto = aSendResult.sendto;
                aSendResultListInfo.tsid = aSendResult.tsid;
                aSendResultListInfo.resaddress = aSendResult.resaddress;
                aSendResultListInfo.subject = aSendResult.subject;
                aSendResultListInfo.pagenum = aSendResult.pagenum;
                aSendResultListInfo.status = aSendResult.status;
                aSendResultListInfo.statusdetail = aSendResult.statusdetail;
                theSendResultListInfoList.add(aSendResultListInfo);
            }

            Response theResponse = new Response();
            theResponse.result = pApiResponse.result;
            theResponse.processkey = pApiResponse.processkey;
            theResponse.accepttime = pApiResponse.accepttime;
            theResponse.SendResultList = theSendResultListInfoList;
            return theResponse;
        }
    }
}