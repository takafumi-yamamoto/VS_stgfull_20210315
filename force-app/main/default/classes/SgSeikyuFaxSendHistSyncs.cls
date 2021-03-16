public class SgSeikyuFaxSendHistSyncs {
    private static ISgSeikyuFaxSendHistCreateSyncer mSgSeikyuFaxSendHistCreateSyncer;
    public static ISgSeikyuFaxSendHistCreateSyncer getSgSeikyuFaxSendHistCreateSyncer(){
        if(mSgSeikyuFaxSendHistCreateSyncer == null){
            String faximoProcesskey = datetime.now().format('yyyy-MM-dd HH:mm:sss');
            FaximoConfs.Config theConfig = FaximoConfs.getConfig(faximoProcesskey);
            FaximoSendReqResult.Client theFaximoSendReqResultClient = new FaximoSendReqResult.Client(
                new FaximoApiSendReqEx.Client(
                    theConfig,
                    new FaximoApiSendReq.Client(),
                    new FaximoApiSendReqEx.ResponseConverter()
                )
            );

            mSgSeikyuFaxSendHistCreateSyncer = new SgSeikyuFaxSendHistCreateSyncer(
                theFaximoSendReqResultClient,
                TesterPhones.getInstance()
            );
        }
        return mSgSeikyuFaxSendHistCreateSyncer;
    }

    public interface ISgSeikyuFaxSendHistCreateSyncer {
        void syncSgSeikyuFaxSendHist(String pSeikyuId, String pFaxNumber, String pPdfFileName, String pPdfFileData);
    }
    public class SgSeikyuFaxSendHistCreateSyncer implements ISgSeikyuFaxSendHistCreateSyncer{

        private FaximoSendReqResult.IClient mFaximoSendReqResultIClient;
        private TesterPhones.ITesterPhones mTesterPhones;
        
        public SgSeikyuFaxSendHistCreateSyncer(FaximoSendReqResult.IClient pFaximoSendReqResultIClient, TesterPhones.ITesterPhones pTesterPhones){
            this.mFaximoSendReqResultIClient = pFaximoSendReqResultIClient;
            this.mTesterPhones = pTesterPhones; 
        }

        public void syncSgSeikyuFaxSendHist(String pSeikyuId, String pFaxNumber, String pPdfFileName, String pPdfFileData){
            this.mTesterPhones.raiseNotTesterExIfNotAllowed(pFaxNumber);

            List<String> faxNumberList = new List<String>();
            faxNumberList.add(pFaxNumber);

            List<FaximoSendReqResult.AttachmentInfo> attachmentInfoList = new List<FaximoSendReqResult.AttachmentInfo>();
            FaximoSendReqResult.AttachmentInfo tempAttachmentInfo = new FaximoSendReqResult.AttachmentInfo();
            tempAttachmentInfo.attachmentName = pPdfFileName;
            tempAttachmentInfo.attachmentData = pPdfFileData;    
            attachmentInfoList.add(tempAttachmentInfo);

            FaximoSendReqResult.FaximoReqInfo theFaximoReqInfo = new FaximoSendReqResult.FaximoReqInfo();
            theFaximoReqInfo.seikyuId = pSeikyuId;
            theFaximoReqInfo.userkey = GuidUtil.NewGuid().replace('-', '');
            theFaximoReqInfo.faxNumberList = faxNumberList;
            theFaximoReqInfo.subject = '葬儀様向け請求書(' + pSeikyuId + ')';
            theFaximoReqInfo.attachmentList = attachmentInfoList;

            this.createHistory(
                theFaximoReqInfo.userkey,
                this.mFaximoSendReqResultIClient.getResult(theFaximoReqInfo)
            );
        }

        private void createHistory(String pUserkey, FaximoApiSendReqEx.Result pResult){
            FaximoApiSendReq.Response faximoApiSendReq_response = pResult.apiResult.response;
            PartnerSeikyuSendHistory__c theHistory = new PartnerSeikyuSendHistory__c(
                SendType__c = 'Fax',
                PartnerSeikyuSogishaRef__c = pResult.seikyuId,
                SendRequestResponse__c = JSON.serialize(faximoApiSendReq_response),
                SendRequestStatus__c = faximoApiSendReq_response.result == '000000' ? '送信依頼OK' : '送信依頼NG',
                SendResultStatus__c = '未処理',
                FaximoUserkey__c = pUserkey,
                FaximoMeisaiBango__c = faximoApiSendReq_response.idxcnt,
                SendRequestUketsukeNichiji__c = faximoApiSendReq_response.accepttime == null ? null : Datetime.valueOf(faximoApiSendReq_response.accepttime.replace('T', ' '))
            );
            insert theHistory;
        }
    }

    private static ISgSeikyuFaxSendHistUpdateSyncer mSgSeikyuFaxSendHistUpdateSyncer;
    public static ISgSeikyuFaxSendHistUpdateSyncer getSgSeikyuFaxSendHistUpdateSyncer(){

        if(mSgSeikyuFaxSendHistUpdateSyncer == null){
            String faximoProcesskey = datetime.now().format('yyyy-MM-dd HH:mm:sss');
            FaximoConfs.Config theConfig = FaximoConfs.getConfig(faximoProcesskey);

            FaximoApiSendRsltReqEx.Request theFaximoApiSendRsltReqExRequest = new FaximoApiSendRsltReqEx.Request();
            theFaximoApiSendRsltReqExRequest.pFrom = datetime.now().addDays(-7).format('yyyyMMddHHmmss') + 'Z';
            theFaximoApiSendRsltReqExRequest.pTo = datetime.now().format('yyyyMMddHHmmss') + 'Z';

            FaximoApiSendRsltReqEx.Client theFaximoApiSendRsltReqExClient = new FaximoApiSendRsltReqEx.Client(
                theConfig,
                new FaximoApiSendRsltReq.Client(),
                new FaximoApiSendRsltReqEx.ResponseConverter()
            );
            
            mSgSeikyuFaxSendHistUpdateSyncer = new SgSeikyuFaxSendHistUpdateSyncer(theFaximoApiSendRsltReqExRequest, theFaximoApiSendRsltReqExClient);
        }
        return mSgSeikyuFaxSendHistUpdateSyncer;
    }

    public interface ISgSeikyuFaxSendHistUpdateSyncer {
        void syncSgSeikyuFaxSendHistUpdate();
    }

    public class SgSeikyuFaxSendHistUpdateSyncer implements ISgSeikyuFaxSendHistUpdateSyncer{

        private FaximoApiSendRsltReqEx.Request mFaximoApiSendRsltReqExRequest;
        private FaximoApiSendRsltReqEx.IClient mFaximoApiSendRsltReqExIClient;
        
        public SgSeikyuFaxSendHistUpdateSyncer(FaximoApiSendRsltReqEx.Request pFaximoApiSendRsltReqExRequest, FaximoApiSendRsltReqEx.IClient pFaximoApiSendRsltReqExIClient){
            this.mFaximoApiSendRsltReqExRequest = pFaximoApiSendRsltReqExRequest;
            this.mFaximoApiSendRsltReqExIClient = pFaximoApiSendRsltReqExIClient;
        }

        public void syncSgSeikyuFaxSendHistUpdate(){

            List<PartnerSeikyuSendHistory__c> mishoriPartnerSeikyuSendHistoryList = selectPartnerSeikyuSendHistoryList();
            if(mishoriPartnerSeikyuSendHistoryList.size() > 0){
                this.updateHistory(mishoriPartnerSeikyuSendHistoryList,
                    this.mFaximoApiSendRsltReqExIClient.sendRequest(mFaximoApiSendRsltReqExRequest)
                );
            }          
        }

        private List<PartnerSeikyuSendHistory__c> selectPartnerSeikyuSendHistoryList(){
            return [select 
                        Id, 
                        Name, 
                        FaximoUserkey__c, 
                        FaximoMeisaiBango__c, 
                        PartnerSeikyuSogishaRef__c, 
                        SendRequestStatus__c, 
                        SendRequestResponse__c, 
                        SendRequestUketsukeNichiji__c, 
                        SendType__c 
                    from PartnerSeikyuSendHistory__c
                    where 
                        SendType__c = 'Fax' and 
                        SendRequestStatus__c = '送信依頼OK' and 
                        SendResultStatus__c = '未処理' and 
                        CreatedDate >= :datetime.now().addDays(-7) 
            ];
        }

        private void updateHistory(List<PartnerSeikyuSendHistory__c> mishoriPartnerSeikyuSendHistoryList, FaximoApiSendRsltReqEx.Result pResult){
            
            FaximoApiSendRsltReqEx.Response faximoApiSendRsltReqEx_response = pResult.response;
            List<FaximoApiSendRsltReqEx.SendResultListInfo> sendResultListInfoList = faximoApiSendRsltReqEx_response.SendResultList;

            List<PartnerSeikyuSendHistory__c> upPartnerSeikyuSendHistoryList = new List<PartnerSeikyuSendHistory__c>();
            for(PartnerSeikyuSendHistory__c mishoriPartnerSeikyuSendHistory : mishoriPartnerSeikyuSendHistoryList){
                for(FaximoApiSendRsltReqEx.SendResultListInfo aSendResultListInfo : faximoApiSendRsltReqEx_response.SendResultList){
                    if(mishoriPartnerSeikyuSendHistory.FaximoMeisaiBango__c != aSendResultListInfo.idxcnt) continue;
                    if(aSendResultListInfo.status == '0') continue; // ステータス：送信中
                    
                    mishoriPartnerSeikyuSendHistory.SendResultStatus__c = aSendResultListInfo.status == '5' ? '送信OK' : '送信NG';
                    for(FaximoApiSendRsltReqEx.SendResultListInfo sendResultListInfo : sendResultListInfoList){
                        if(mishoriPartnerSeikyuSendHistory.FaximoMeisaiBango__c == sendResultListInfo.idxcnt){
                            mishoriPartnerSeikyuSendHistory.SendResultResponse__c = JSON.serialize(sendResultListInfo);
                        }
                    }
                    mishoriPartnerSeikyuSendHistory.SendResultShutokuNichiji__c = faximoApiSendRsltReqEx_response.accepttime == null ? null : Datetime.valueOf(faximoApiSendRsltReqEx_response.accepttime.replace('T', ' '));
                    upPartnerSeikyuSendHistoryList.add(mishoriPartnerSeikyuSendHistory);
                }
            }
            update upPartnerSeikyuSendHistoryList;
        }
    }
}