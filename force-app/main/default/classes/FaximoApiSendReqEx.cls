public class FaximoApiSendReqEx {

    public class Request{
        public String seikyuId;
        public List<SendtoInfo> sendto;
        public String userkey;
        public String tsi;
        public String headerinfo;
        public Decimal retry_count;
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
        public FaximoApiSendReq.Result apiResult;
        public Response response = new Response();
    }

    public interface IClient {
        Result sendRequest(Request pReq);
    }
    public class Client implements IClient{
        private FaximoConfs.Config mConfig;
        private FaximoApiSendReq.IClient mApiClient;
        private ResponseConverter mResponseConverter;
        public Client(FaximoConfs.Config pConfig, FaximoApiSendReq.IClient pApiClient, ResponseConverter pResponseConverter){
            this.mConfig = pConfig;
            this.mApiClient = pApiClient;
            this.mResponseConverter = pResponseConverter;
        }

        public Result sendRequest(Request pReq){
            Result theResult = new Result();

            FaximoApiSendReq.Request theApiReq = new FaximoApiSendReq.Request();
            theApiReq.sendto = this.mResponseConverter.convertSendtoInfo(pReq.sendto);
            theApiReq.userkey = pReq.userkey;
            theApiReq.tsi = pReq.tsi;
            theApiReq.headerinfo = pReq.headerinfo;
            theApiReq.retrynum = pReq.retry_count == null ? '3' : String.valueOf(pReq.retry_count);
            theApiReq.resaddress = pReq.resaddress;
            theApiReq.subject = pReq.subject;
            theApiReq.body = pReq.body;
            theApiReq.Attachment = this.mResponseConverter.convertAttachmentInfo(pReq.Attachment);

            FaximoApiSendReq.Result theApiResult = 
                this.mApiClient.sendRequest(
                    this.mConfig.userId, 
                    this.mConfig.password,
                    this.mConfig.api_base_url,
                    this.mConfig.faximoProcesskey,
                    theApiReq
                );

            theResult.seikyuId = pReq.seikyuId;
            theResult.isSuccess = theApiResult.isSuccess;
            theResult.apiResult = theApiResult;
            theResult.response = this.mResponseConverter.convertResponse(theApiResult.response);

            return theResult;
        }
    }

    public class ResponseConverter{
        public List<FaximoApiSendReq.SendtoInfo> convertSendtoInfo(List<FaximoApiSendReqEx.SendtoInfo> pApiSendtoInfo){
            List<FaximoApiSendReq.SendtoInfo> theSendtoInfoList = new List<FaximoApiSendReq.SendtoInfo>();
            for( FaximoApiSendReqEx.SendtoInfo aApiSendto : pApiSendtoInfo){
                FaximoApiSendReq.SendtoInfo theSendtoInfo = new FaximoApiSendReq.SendtoInfo();
                theSendtoInfo.faxno = aApiSendto.faxno;
                theSendtoInfoList.add(theSendtoInfo);
            }
            return theSendtoInfoList;
        }

        public List<FaximoApiSendReq.AttachmentInfo> convertAttachmentInfo(List<FaximoApiSendReqEx.AttachmentInfo> pAttachment){
            List<FaximoApiSendReq.AttachmentInfo> theAttachmentInfoList = new List<FaximoApiSendReq.AttachmentInfo>();
            for( FaximoApiSendReqEx.AttachmentInfo aApiAttachment : pAttachment){
                FaximoApiSendReq.AttachmentInfo theAttachmentInfo = new FaximoApiSendReq.AttachmentInfo();
                theAttachmentInfo.attachmentname = aApiAttachment.attachmentname;
                theAttachmentInfo.attachmentdata = aApiAttachment.attachmentdata;
                theAttachmentInfoList.add(theAttachmentInfo);
            }
            return theAttachmentInfoList;
        }

        public Response convertResponse(FaximoApiSendReq.Response pApiResponse){
            Response theResponse = new Response();
            theResponse.result = pApiResponse.result;
            theResponse.processkey = pApiResponse.processkey;
            theResponse.accepttime = pApiResponse.accepttime;
            theResponse.idxcnt = pApiResponse.idxcnt;
            return theResponse;
        }
    }
}