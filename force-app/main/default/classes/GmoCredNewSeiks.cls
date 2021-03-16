public class GmoCredNewSeiks {
    public class SeikyuRequest {
        public String recordId;
        public String torihikiShodanId;
        public List<SeikyuLine> seikyuLines;
        public String seikyuBango;
        public String torihikisakiBango;
        public String seikyusakiName;
        public String seikyusakiMail;    // 請求先メールアドレス
        public String seikyusakiPhone;    // 請求先電話番号
        public String seikyusakiChannel;
        public Boolean sokujiUriage;
    }
    public class SeikyuLine{
        public String shodanId = null;
        public String hinmei = '';
        public String stageName = '';
        public String kakuteiDate = '';
        public String plan = '';
        public Decimal kingaku = 0;
    }
    public class ProcessAnSeikyuRes {
        public String resultCode = 'success';
        public List<String> errMsgs = new List<String>();
        private ProcessAnSeikyuRes setResultCode(String presultCode){ this.resultCode = presultCode; return this; }
        private ProcessAnSeikyuRes addErrorMsg(String pErrMsg){ this.errMsgs.add(pErrMsg); return this; }
        private ProcessAnSeikyuRes addErrorMsgs( List<String> pErrMsgs ){ this.errMsgs.addAll(pErrMsgs); return this; }
    }

    private List<String> validateReq(SeikyuRequest seikyuRequest){
        List<String> resultMsg = new List<String>();
        if(String.isBlank(seikyuRequest.seikyusakiName)){
            resultMsg.add('請求先を入力してください;');
        }

        if( seikyuRequest.seikyusakiChannel == 'MAIL' && !Utility_Common.isValidEmailAddress(seikyuRequest.seikyusakiMail) ){
            resultMsg.add('請求先メールアドレス不正;');
        }
        if( seikyuRequest.seikyusakiChannel == 'SMS' && !TelNos.isTelNo(seikyuRequest.seikyusakiPhone) ){
            resultMsg.add('請求先電話番号(SMS)不正;');
        }
        if(String.isBlank(seikyuRequest.recordId)){
            resultMsg.add('recordId is null;');
        }
        if(String.isBlank(seikyuRequest.seikyuBango)){
            resultMsg.add('seikyuBango is null;');
        }
        if(String.isBlank(seikyuRequest.torihikisakiBango)){
            resultMsg.add('torihikisakiBango is null;');
        }
        if(seikyuRequest.seikyuLines.size() == 0){
            resultMsg.add('請求明細を選択してください;');
        }
        Decimal totalAmount = 0;
        for( SeikyuLine line : seikyuRequest.seikyuLines) {
            totalAmount += line.kingaku;
        }
        if(totalAmount <= 0){
            resultMsg.add('請求金額 <= 0;');
        }
        if(String.isBlank(seikyuRequest.torihikiShodanId)){
            resultMsg.add('torihikiShodanId is null;');
        }
        return resultMsg;
    }

    public ProcessAnSeikyuRes processNewSeikyu(SeikyuRequest gmoCredNewSeiksReq) {
        try{
            //validate request.
            List<String> errors = validateReq(gmoCredNewSeiksReq);
            if( errors.size() > 0 ){
                return new ProcessAnSeikyuRes()
                    .setResultCode('error_validation')
                    .addErrorMsgs(errors);
            }

            RsCoreApi_Kessai_Seikyu_Post.Result theSendResult = new RsCoreApi_Kessai_Seikyu_PostAdater().sendRequest(gmoCredNewSeiksReq);
            if(!theSendResult.isSuccess){
                return new ProcessAnSeikyuRes()
                    .setResultCode('error_unhandled')
                    .addErrorMsg('請求データ送信失敗')
                    .addErrorMsg(theSendResult.descr);
            }
            saveSeikyu(gmoCredNewSeiksReq);
            return new ProcessAnSeikyuRes().setResultCode('success');
        } catch(Exception ex){
            Loggings.writeLog(
                Loggings.createLogEntry(Loggings.Level.Error, '20191017-1500', 'GmoCredNewSeiks.processNewSeikyu')
                    .putAttr('ex.getMessage()', ex.getMessage())
                    .putAttr('ex.getLineNumber()', String.valueOf(ex.getLineNumber()) )
                    .putAttr('ex.getTypeName()', ex.getTypeName())
                    .putAttr('ex.getStackTraceString()', ex.getStackTraceString())
                    .putAttr('gmoCredNewSeiksReq', JSON.serialize(gmoCredNewSeiksReq))

            );
            throw ex;
        }
    }

    private void saveSeikyu(SeikyuRequest pSeikyuRequest){
            Opportunity theCurOpp = (Opportunity)SobjectsExtension.firstOrNull(
                [
                    Select
                    Id, TorihikiShodanRef__c, AccountId
                    from Opportunity
                    where Id = :pSeikyuRequest.recordId
                ]
            );

            Decimal theTotalPrice = 0;
            for(SeikyuLine aSeikyuLine : pSeikyuRequest.seikyuLines){
                theTotalPrice += aSeikyuLine.kingaku;
            }

            OkyakusamaSeikyuMeisai__c theParent = new OkyakusamaSeikyuMeisai__c(
                OpportunityRef__c = pSeikyuRequest.torihikiShodanId,
                SeikyuBango__c = pSeikyuRequest.seikyuBango,
                SeikyuHouhou__c = 'gmo_credit',
                SeikyuKingaku__c = theTotalPrice,
                SeikyuStatus__c = '決済待ち',
                seikyusaki__c = pSeikyuRequest.seikyusakiName,
                seikyusakiMail__c = pSeikyuRequest.seikyusakiChannel == 'MAIL' ? pSeikyuRequest.seikyusakiMail : null,
                SeikyuSakiMobile__c = pSeikyuRequest.seikyusakiChannel == 'SMS' ? pSeikyuRequest.seikyusakiPhone : null,
                SeikyuJiTorihikiSakiRef__c = theCurOpp.AccountId,
                sokujiUriage__c = pSeikyuRequest.sokujiUriage
            );
            Insert theParent;

            List<OkyakusamaSeikyuMeisai__c> theChildren = new List<OkyakusamaSeikyuMeisai__c>();
            for(SeikyuLine aSeikyuLine : pSeikyuRequest.seikyuLines){
                OkyakusamaSeikyuMeisai__c theChild = new OkyakusamaSeikyuMeisai__c(
                    SeikyuOya__c = theParent.Id,
                    OpportunityRef__c = aSeikyuLine.shodanId,
                    SeikyuBango__c = pSeikyuRequest.seikyuBango,
                    SeikyuHouhou__c = 'gmo_credit',
                    SeikyuKingaku__c = aSeikyuLine.kingaku,
                    SeikyuStatus__c = '決済待ち',
                    seikyusaki__c = pSeikyuRequest.seikyusakiName,
                    seikyusakiMail__c = pSeikyuRequest.seikyusakiChannel == 'MAIL' ? pSeikyuRequest.seikyusakiMail : null,
                    SeikyuSakiMobile__c = pSeikyuRequest.seikyusakiChannel == 'SMS' ? pSeikyuRequest.seikyusakiPhone : null,
                    SeikyuJiTorihikiSakiRef__c = theCurOpp.AccountId,
                    sokujiUriage__c = pSeikyuRequest.sokujiUriage
                );
                theChildren.add(theChild);
            }
            Insert theChildren;

            for(SeikyuLine aSeikyuLine : pSeikyuRequest.seikyuLines){
                SeikyuHinmoku__c theSeikyuHinmoku = new SeikyuHinmoku__c(
                    OkyakusamaSeikyuMeisaiRef__c = theParent.Id,
                    Hinmokumei__c = aSeikyuLine.hinmei,
                    Quantity__c = 1,
                    Kingaku__c = aSeikyuLine.kingaku,
                    Syubetu__c = '商品'
                );
            }

    }
    private class RsCoreApi_Kessai_Seikyu_PostAdater{
        private Map<String, List<RsCoreApi_Kessai_Seikyu_Post.ReqBodyServiceItem> > createServiceItemsMap(SeikyuRequest pSeikyuRequest){

            Set<Id> theSeikyuLineOppIds = new Set<Id>();
            for( SeikyuLine aSeikyuLine : pSeikyuRequest.seikyuLines ){
                theSeikyuLineOppIds.add( aSeikyuLine.shodanId );
            }

            Map<Id,Opportunity> theSeikyuLineOpps = new Map<Id,Opportunity>(
                [
                    select Id, RecordType.DeveloperName
                    from Opportunity
                    where Id = :theSeikyuLineOppIds
                ]
            );

            Map<String, List<RsCoreApi_Kessai_Seikyu_Post.ReqBodyServiceItem> > theSeviceItemsMap
                = new Map<String, List<RsCoreApi_Kessai_Seikyu_Post.ReqBodyServiceItem> >();

            for(SeikyuLine aSeikyuLine : pSeikyuRequest.seikyuLines){
                Opportunity aOpp = theSeikyuLineOpps.get( aSeikyuLine.shodanId );

                String theServiceName = 'シンプルなお葬式';
                if(aOpp.RecordType.DeveloperName == 'SimpleYasugo') theServiceName = 'シンプルなお葬式';
                if(aOpp.RecordType.DeveloperName == 'Obosanbin') theServiceName = 'お坊さん便';

                if( !theSeviceItemsMap.containsKey(theServiceName) ){
                    theSeviceItemsMap.put(theServiceName, new List<RsCoreApi_Kessai_Seikyu_Post.ReqBodyServiceItem>());
                }

                List<RsCoreApi_Kessai_Seikyu_Post.ReqBodyServiceItem> theItems = theSeviceItemsMap.get(theServiceName);

                RsCoreApi_Kessai_Seikyu_Post.ReqBodyServiceItem theItem = new RsCoreApi_Kessai_Seikyu_Post.ReqBodyServiceItem();
                theItem.type = '商品'; theItem.price = aSeikyuLine.kingaku; theItem.name = aSeikyuLine.hinmei;
                theItems.add(theItem);
            }
            return theSeviceItemsMap;
        }
        private RsCoreApi_Kessai_Seikyu_Post.ReqBody createReqBody(SeikyuRequest pSeikyuRequest){

            RsCoreApi_Kessai_Seikyu_Post.ReqBody theReqBody = new RsCoreApi_Kessai_Seikyu_Post.ReqBody();

            Opportunity theCurOpp = (Opportunity)SobjectsExtension.firstOrNull(
                [
                    Select
                    Id, RecordType.DeveloperName
                    from Opportunity
                    where Id = :pSeikyuRequest.recordId
                ]
            );
            theReqBody.service = 'sogi';
            if(theCurOpp.RecordType.DeveloperName == 'SimpleYasugo') theReqBody.service = 'sogi';
            if(theCurOpp.RecordType.DeveloperName == 'Obosanbin') theReqBody.service = 'obou';

            theReqBody.title = 'よりそう';
            if(theReqBody.service == 'sogi') theReqBody.title = 'よりそうお葬式';
            if(theReqBody.service == 'obou') theReqBody.title = 'よりそうお坊さん便';
            theReqBody.seikyuBango = pSeikyuRequest.seikyuBango;
            theReqBody.paymentMethod = 'カード（GMOPG）';
            theReqBody.sokujiUriage = pSeikyuRequest.sokujiUriage;
            theReqBody.torihikisakiBango = pSeikyuRequest.torihikisakiBango;
            theReqBody.seikyusaki.name = pSeikyuRequest.seikyusakiName;
            theReqBody.seikyusaki.mailAddress = pSeikyuRequest.seikyusakiChannel == 'SMS' ? '' :  pSeikyuRequest.seikyusakiMail;
            theReqBody.seikyusaki.sms = pSeikyuRequest.seikyusakiChannel == 'SMS' ? pSeikyuRequest.seikyusakiPhone : '' ;

            Map<String, List<RsCoreApi_Kessai_Seikyu_Post.ReqBodyServiceItem> > theSeviceItemsMap = this.createServiceItemsMap(pSeikyuRequest);
            for(String aServiceName : theSeviceItemsMap.keySet() ){

                RsCoreApi_Kessai_Seikyu_Post.ReqBodyService theService = new RsCoreApi_Kessai_Seikyu_Post.ReqBodyService();
                theService.serviceName = aServiceName;

                for(RsCoreApi_Kessai_Seikyu_Post.ReqBodyServiceItem aItem : theSeviceItemsMap.get(aServiceName) ){
                    theReqBody.totalAmount += aItem.price;
                    theService.totalAmount += aItem.price;
                    theService.items.add(aItem);
                }
                theReqBody.services.add(theService);
            }

            return theReqBody;
        }
        public RsCoreApi_Kessai_Seikyu_Post.Result sendRequest(SeikyuRequest pSeikyuRequest){
            RsCoreApi_Kessai_Seikyu_Post.ReqBody theReqBody = this.createReqBody(pSeikyuRequest);
            RsCoreApi_Kessai_Seikyu_Post.Result theResult = RsCoreApi_Kessai_Seikyu_Post.sendRequest(theReqBody);
            return theResult;
        }
    }


}