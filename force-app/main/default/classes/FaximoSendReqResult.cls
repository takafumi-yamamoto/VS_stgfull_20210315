public class FaximoSendReqResult {

    public class FaximoReqInfo{
        public String seikyuId;
        public String userkey;
        public List<String> faxNumberList;
        public String subject;
        public List<AttachmentInfo> attachmentList;
    }

    public class AttachmentInfo{
        public String attachmentName;
        public String attachmentData;
    }

    public interface IClient {
        FaximoApiSendReqEx.Result getResult(FaximoReqInfo faximoReqInfo);
    }
    public class Client implements IClient{
        private FaximoApiSendReqEx.IClient mFaximoApiSendReqEx;
        public Client(
            FaximoApiSendReqEx.IClient pFaximoApiSendReqEx
        ){
            this.mFaximoApiSendReqEx = pFaximoApiSendReqEx;
        }
        
        public FaximoApiSendReqEx.Result getResult(FaximoReqInfo faximoReqInfo){
            FaximoApiSendReqEx.Request theFaximoApiSendReq = new FaximoApiSendReqEx.Request();
            List<FaximoApiSendReqEx.SendtoInfo> faximoApiSendReqEx_sendtoInfoList = new List<FaximoApiSendReqEx.SendtoInfo>(); 
            for(String faxNumber : faximoReqInfo.faxNumberList){
                FaximoApiSendReqEx.SendtoInfo faximoApiSendReqEx_sendtoInfo = new FaximoApiSendReqEx.SendtoInfo();
                faximoApiSendReqEx_sendtoInfo.faxno = faxNumber;
                faximoApiSendReqEx_sendtoInfoList.add(faximoApiSendReqEx_sendtoInfo);
            }
            theFaximoApiSendReq.sendto = faximoApiSendReqEx_sendtoInfoList;
            theFaximoApiSendReq.userkey = faximoReqInfo.userkey;
            theFaximoApiSendReq.subject = faximoReqInfo.subject;

            List<FaximoApiSendReqEx.AttachmentInfo> faximoApiSendReqEx_attachmentInfoList = new List<FaximoApiSendReqEx.AttachmentInfo>(); 
            for(AttachmentInfo attachment : faximoReqInfo.attachmentList){
                FaximoApiSendReqEx.AttachmentInfo faximoApiSendReqEx_attachment = new FaximoApiSendReqEx.AttachmentInfo();
                faximoApiSendReqEx_attachment.attachmentname = attachment.attachmentName;
                faximoApiSendReqEx_attachment.attachmentdata = attachment.attachmentData;
                faximoApiSendReqEx_attachmentInfoList.add(faximoApiSendReqEx_attachment);
            }
            theFaximoApiSendReq.Attachment = faximoApiSendReqEx_attachmentInfoList;

            FaximoApiSendReqEx.Result theFaximoApiSendReqResult = this.mFaximoApiSendReqEx.sendRequest(theFaximoApiSendReq);
            theFaximoApiSendReqResult.seikyuId = faximoReqInfo.seikyuId;
            return theFaximoApiSendReqResult;
        }
    }
}