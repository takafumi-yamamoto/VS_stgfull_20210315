@isTest
public class FaximoApiSendReqExT {

    public class ApiClientMock implements FaximoApiSendReq.IClient{
        public FaximoApiSendReq.Result sendRequest(
            String pBasicAuth_Username, String pBasicAuth_Password, String pBaseUrl, String pFaximoNumber, FaximoApiSendReq.Request pReq
        ){
            FaximoApiSendReq.Result theResult = new FaximoApiSendReq.Result();
            theResult.response = new FaximoApiSendReq.Response();

            return theResult;
        }
    }

    @isTest public static void Client_sendRequest() {

        String faximoProcesskey = datetime.now().format('yyyy-MM-dd HH:mm:sss');

        FaximoApiSendReqEx.SendtoInfo theSendtoInfo = new FaximoApiSendReqEx.SendtoInfo();
        theSendtoInfo.faxno = '';

        FaximoApiSendReqEx.AttachmentInfo theAttachmentInfo = new FaximoApiSendReqEx.AttachmentInfo();
        theAttachmentInfo.attachmentname = '';
        theAttachmentInfo.attachmentdata = '';

        FaximoApiSendReqEx.Request theReq = new FaximoApiSendReqEx.Request();
        theReq.sendto = new List<FaximoApiSendReqEx.SendtoInfo>();
        theReq.sendto.add(theSendtoInfo);

        theReq.Attachment = new List<FaximoApiSendReqEx.AttachmentInfo>();
        theReq.Attachment.add(theAttachmentInfo);

        Test.startTest();
        
        new FaximoApiSendReqEx.Client(
            FaximoConfs.getConfig(faximoProcesskey),
            new ApiClientMock(),
            new FaximoApiSendReqEx.ResponseConverter()
        ).sendRequest(theReq);
    
        Test.stopTest();
    }
}