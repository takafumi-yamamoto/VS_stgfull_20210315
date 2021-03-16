public class SeikyusyoSakuseiController {

    @AuraEnabled
    public static DataCtx getDataCtx(String recordId, String sekyulineOption){

        Opportunity theCurOpp = (Opportunity)SobjectsExtension.firstOrNull(
            [
                Select
                Id, ShodanBango__c, StageName, KakuteibiSyodan__c,
                RecordType.DeveloperName, TorihikiShodanRef__c,
                AccountId, Account.TorihikisakiBango__c, Account.Name,
                Account.YusenMailAddressFormula__c, Account.MobilePhone__c,
                Amount, KaisyuYoteGokeKingaku__c,
                ObosanbinRef__r.MemorialServicePlan__c,
                ( SELECT Id,Product2.Name,Product2.k_ShohinCategory_Id_exp__c,Product2.SougiPlan__c FROM OpportunityLineItems )
                from Opportunity
                where Id = :recordId
            ]
        );
        DataCtx theDataCtx = new DataCtx();
        theDataCtx.recordId = recordId;
        theDataCtx.seikyuBango = SeikyusyoSaiban.getInstance().newSeikyusyoBango();
        theDataCtx.torihikiShodanId = theCurOpp.TorihikiShodanRef__c;
        theDataCtx.seikyuSakiName = theCurOpp.Account.Name;
        theDataCtx.torihikisakiBango = theCurOpp.Account.TorihikisakiBango__c;
        theDataCtx.seikyuSakiMailAddress = theCurOpp.Account.YusenMailAddressFormula__c == null ? '' : theCurOpp.Account.YusenMailAddressFormula__c;
        theDataCtx.seikyuSakiMobile = theCurOpp.Account.MobilePhone__c == null ? '' : TelNos.toNumber(theCurOpp.Account.MobilePhone__c);
        theDataCtx.seikyuLines.add(
            createSeikyuLine(theCurOpp)
        );

        if(sekyulineOption == 'obou-multi-select'){
            List<Opportunity> theOpps =
                [
                    Select
                    Id, ShodanBango__c, StageName, KakuteibiSyodan__c,
                    RecordType.DeveloperName, TorihikiShodanRef__c,
                    AccountId, Account.TorihikisakiBango__c, Account.Name,
                    Account.YusenMailAddressFormula__c, Account.MobilePhone__c,
                    Amount, KaisyuYoteGokeKingaku__c,
                    ObosanbinRef__r.MemorialServicePlan__c,
                    ( SELECT Id,Product2.Name,Product2.k_ShohinCategory_Id_exp__c,Product2.SougiPlan__c FROM OpportunityLineItems )
                    from Opportunity
                    where AccountId = :theCurOpp.AccountId
                    and Amount > 0
                    and StageName in ('予約','決定')
                    and Id != :theCurOpp.Id
                    and RecordType.DeveloperName = 'Obosanbin'
                ];
            for(Opportunity aOpp : theOpps){
                Decimal theAmount = aOpp.Amount == null ? 0 : aOpp.Amount;
                Decimal theSeikyuAlready = aOpp.KaisyuYoteGokeKingaku__c == null ? 0 : aOpp.KaisyuYoteGokeKingaku__c;
                if(theAmount - theSeikyuAlready > 0){
                    theDataCtx.seikyuLines.add(
                        createSeikyuLine(aOpp)
                    );
                }
            }
        }

        return theDataCtx;
    }

    private static SeikyuLine createSeikyuLine(Opportunity pOpp){
        SeikyuLine theSeikyuLine = new SeikyuLine();
        String theServiceName = '';
        if(pOpp.RecordType.DeveloperName == 'SimpleYasugo') theServiceName = 'よりそうお葬式';
        if(pOpp.RecordType.DeveloperName == 'Obosanbin') theServiceName = 'よりそうお坊さん便';
        theSeikyuLine.shodanId = pOpp.Id;
        theSeikyuLine.hinmei = String.format(
            '{0}  お客様ID : {1}',
            new List<String>{ theServiceName, pOpp.ShodanBango__c }
        );
        theSeikyuLine.stageName = pOpp.stageName == null ? '' : pOpp.stageName;
        theSeikyuLine.kakuteiDate = pOpp.KakuteibiSyodan__c == null ? '' : String.valueOf(pOpp.KakuteibiSyodan__c);

        theSeikyuLine.plan = '';
        if(pOpp.RecordType.DeveloperName == 'SimpleYasugo') {
            for(OpportunityLineItem aLineItem : pOpp.OpportunityLineItems){
                if(aLineItem.Product2.SougiPlan__c) theSeikyuLine.plan = aLineItem.Product2.Name;
            }
        }
        if(pOpp.RecordType.DeveloperName == 'Obosanbin') {
            theSeikyuLine.plan = pOpp.ObosanbinRef__r.MemorialServicePlan__c == null ? '' : pOpp.ObosanbinRef__r.MemorialServicePlan__c;
        }

        Decimal theAmount = pOpp.Amount == null ? 0 : pOpp.Amount;
        Decimal theSeikyuAlready = pOpp.KaisyuYoteGokeKingaku__c == null ? 0 : pOpp.KaisyuYoteGokeKingaku__c;
        theSeikyuLine.kingaku = theAmount - theSeikyuAlready;
        return theSeikyuLine;
    }

    public class DataCtx{
        @AuraEnabled public String recordId = null;
        @AuraEnabled public String seikyuBango = '';
        @AuraEnabled public Id torihikiShodanId = null;
        @AuraEnabled public String seikyuSakiName = '';
        @AuraEnabled public String torihikisakiBango = '';
        @AuraEnabled public String seikyuSakiMailAddress = '';
        @AuraEnabled public String seikyuSakiMobile = '';
        @AuraEnabled public List<SeikyuLine> seikyuLines = new List<SeikyuLine>();
    }

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
        @AuraEnabled public String shodanId = null;
        @AuraEnabled public String hinmei = '';
        @AuraEnabled public String stageName = '';
        @AuraEnabled public String kakuteiDate = '';
        @AuraEnabled public String plan = '';
        @AuraEnabled public Decimal kingaku = 0;
    }

    public class DoSaveResult{
        @AuraEnabled public String resultCode = 'success';
        @AuraEnabled public List<String> errMsgs = new List<String>();
        public DoSaveResult setResultCode(String presultCode){ this.resultCode = presultCode; return this; }
        public DoSaveResult addErrorMsg(String pErrMsg){ this.errMsgs.add(pErrMsg); return this; }
        public DoSaveResult addErrorMsgs( List<String> pErrMsgs ){ this.errMsgs.addAll(pErrMsgs); return this; }
    }

    @AuraEnabled
    public static DoSaveResult doSave(String pSeikyuRequest) {
        try {
            SeikyuRequest aSeikyuRequest = (SeikyuRequest) JSON.deserialize(pSeikyuRequest, SeikyuRequest.class);
            GmoCredNewSeiks.SeikyuRequest theSeikyuRequest = new GmoCredNewSeiks.SeikyuRequest();
            theSeikyuRequest.recordId = aSeikyuRequest.recordId ;
            theSeikyuRequest.torihikiShodanId = aSeikyuRequest.torihikiShodanId ;
            theSeikyuRequest.seikyuBango = aSeikyuRequest.seikyuBango ;
            theSeikyuRequest.torihikisakiBango = aSeikyuRequest.torihikisakiBango ;
            theSeikyuRequest.seikyusakiName = aSeikyuRequest.seikyusakiName ;
            theSeikyuRequest.seikyusakiMail = aSeikyuRequest.seikyusakiMail ;
            theSeikyuRequest.seikyusakiPhone = aSeikyuRequest.seikyusakiPhone ;
            theSeikyuRequest.seikyusakiChannel = aSeikyuRequest.seikyusakiChannel ;
            theSeikyuRequest.sokujiUriage = aSeikyuRequest.sokujiUriage ;
            theSeikyuRequest.seikyuLines = new List<GmoCredNewSeiks.SeikyuLine>();
            for(SeikyuLine aSeikyuLine : aSeikyuRequest.seikyuLines) {
                GmoCredNewSeiks.SeikyuLine theSeikyuLine = new GmoCredNewSeiks.SeikyuLine();
                theSeikyuLine.shodanId = aSeikyuLine.shodanId;
                theSeikyuLine.hinmei = aSeikyuLine.hinmei;
                theSeikyuLine.stageName = aSeikyuLine.stageName;
                theSeikyuLine.kakuteiDate = aSeikyuLine.kakuteiDate;
                theSeikyuLine.plan = aSeikyuLine.plan;
                theSeikyuLine.kingaku = aSeikyuLine.kingaku;
                theSeikyuRequest.seikyuLines.add(theSeikyuLine);
            }
            GmoCredNewSeiks.ProcessAnSeikyuRes res = new GmoCredNewSeiks().processNewSeikyu(theSeikyuRequest);
            return new DoSaveResult().setResultCode(res.resultCode).addErrorMsgs( res.errMsgs );
        } catch(Exception ex) {
            return new DoSaveResult().setResultCode('error_unhandled').addErrorMsg( ex.getMessage() );
        }
    }

}