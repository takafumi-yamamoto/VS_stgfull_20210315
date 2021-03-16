public class SorKetRenAutoCredSeikQms implements IHdlQms {
    public static String msgType = 'SorKetRenAutoCredSeikQms';

    public class Data{
        public String oppId;
        public String seikyusakiChannel; //MAIL OR SMS
        public String atena;
        public String mailAddress;
        public String mobile;
    }
/*
    public static void InsertAsRoot(String oppId, String seikyusakiChannel, String pAtena, String pMailAddress, String pMobile){
        Data theData = new Data();
        theData.oppId = oppId;
        theData.seikyusakiChannel = seikyusakiChannel;
        theData.atena = pAtena;
        theData.mailAddress = pMailAddress;
        theData.mobile = pMobile;
        INSERT QmsBld.newRoot().setMsgType( msgType ).setData( JSON.serialize( theData ) ).build();
    }
*/
    public void handleQms(Qms__c pQms) {
        try{
            this.runQms(pQms);
        }catch(Exception ex){
            UPDATE New Qms__c(Id = pQms.Id, ShoriStatus__c = QmsShoriStatus.Failed);
            Loggings.writeLog(
                Loggings.createLogEntry(Loggings.Level.Error, '20191107-1645', msgType)
                    .setSubjectRecordId(pQms.Id)
                    .putAttr('Exception', ex.getMessage())
                    .putAttr('LineNumber', '' + ex.getLineNumber())
                    .putAttr('getStackTraceString', ex.getStackTraceString())
            );
        }
    }

    private void runQms(Qms__c pQms){
        Data theData = (Data)JSON.deserialize(pQms.Data__c, Data.class);

        Opportunity theOpp = [ SELECT Id, ShodanBango__c FROM Opportunity WHERE Id = :theData.oppId ].get(0);

        GmoCredNewSeiks.SeikyuRequest theSeikyuReq = 
            this.getSeikyuReqData(
                theData.oppId, 
                theData.seikyusakiChannel,
                theData.atena,
                theData.mailAddress,
                theData.mobile
            );
        System.enqueueJob(
            new GmoCredNewSeiksAsync( theOpp.ShodanBango__c, theSeikyuReq )
        );
        UPDATE New Qms__c(Id = pQms.Id, ShoriStatus__c = QmsShoriStatus.Completed);
    }

    private GmoCredNewSeiks.SeikyuRequest getSeikyuReqData(String oppId, String seikyusakiChannel, String pAtena, String pMailAddress, String pMobile) {
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
                        where Id = :oppId
                    ]
                );
        GmoCredNewSeiks.SeikyuRequest theSeikyuRequest = new GmoCredNewSeiks.SeikyuRequest();
        theSeikyuRequest.recordId = oppId ;
        theSeikyuRequest.torihikiShodanId = theCurOpp.TorihikiShodanRef__c ;
        theSeikyuRequest.seikyuBango = SeikyusyoSaiban.getInstance().newSeikyusyoBango();
        theSeikyuRequest.torihikisakiBango = theCurOpp.Account.TorihikisakiBango__c;
        theSeikyuRequest.seikyusakiName = pAtena;
        theSeikyuRequest.seikyusakiMail = pMailAddress;
        theSeikyuRequest.seikyusakiPhone = String.isBlank(pMobile) ? '' : TelNos.toNumber(pMobile);
        theSeikyuRequest.seikyusakiChannel = seikyusakiChannel ; // MAIL OR SMS
        theSeikyuRequest.sokujiUriage = True ;
        theSeikyuRequest.seikyuLines = new List<GmoCredNewSeiks.SeikyuLine>();
        theSeikyuRequest.seikyuLines.add(createSeikyuLine(theCurOpp));
        return theSeikyuRequest;
    }

    private GmoCredNewSeiks.SeikyuLine createSeikyuLine(Opportunity pOpp){
        GmoCredNewSeiks.SeikyuLine theSeikyuLine = new GmoCredNewSeiks.SeikyuLine();
        String theServiceName = 'よりそうお坊さん便';
        theSeikyuLine.shodanId = pOpp.Id;
        theSeikyuLine.hinmei = String.format(
            '{0}  お客様ID : {1}',
            new List<String>{ theServiceName, pOpp.ShodanBango__c }
        );
        theSeikyuLine.stageName = pOpp.stageName == null ? '' : pOpp.stageName;
        theSeikyuLine.kakuteiDate = pOpp.KakuteibiSyodan__c == null ? '' : String.valueOf(pOpp.KakuteibiSyodan__c);

        theSeikyuLine.plan = pOpp.ObosanbinRef__r.MemorialServicePlan__c;

        Decimal theAmount = pOpp.Amount == null ? 0 : pOpp.Amount;
        Decimal theSeikyuAlready = pOpp.KaisyuYoteGokeKingaku__c == null ? 0 : pOpp.KaisyuYoteGokeKingaku__c;
        theSeikyuLine.kingaku = theAmount - theSeikyuAlready;
        return theSeikyuLine;
    }

    @TestVisible
    private class GmoCredNewSeiksAsync implements Queueable, Database.AllowsCallouts {
        private String shodanBango = '';
        private GmoCredNewSeiks.SeikyuRequest seikyuReq;
        public GmoCredNewSeiksAsync(String pShodanBango, GmoCredNewSeiks.SeikyuRequest seikyuReq) {
            this.shodanBango = pShodanBango;
            this.seikyuReq = seikyuReq;
        }
        public void execute(QueueableContext context) {
            try{
                this.sendSeikyu();
            }catch(Exception ex){
                Loggings.writeLog(
                    Loggings.createLogEntry(Loggings.Level.Error, '20191107-1800-02', 'SorKetRenAutoCredSeikQms.sendSeikyu')
                        .putAttr('this.shodanBango', this.shodanBango)
                        .putAttr('ex.getMessage()', ex.getMessage())
                        .putAttr('ex.getLineNumber()', String.valueOf(ex.getLineNumber()) )
                        .putAttr('ex.getTypeName()', ex.getTypeName())
                        .putAttr('ex.getStackTraceString()', ex.getStackTraceString())
                );
            }
        }

        private void sendSeikyu() {
            GmoCredNewSeiks.ProcessAnSeikyuRes res = new GmoCredNewSeiks().processNewSeikyu(this.seikyuReq);
            if(res.resultCode == 'success'){
                UPDATE new Opportunity(Id = this.seikyuReq.recordId, SubPhase__c = 'クレジットカード決済待ち'); 
            }
            if(res.resultCode != 'success') {

                //MailAlert Begin
                SorKetRenAutoCredSeikNgMail.CreateMailArg theArg = new SorKetRenAutoCredSeikNgMail.CreateMailArg();
                theArg.ShodanBango = this.shodanBango;
                theArg.ShodanId = this.seikyuReq.recordId;
                INSERT new SorKetRenAutoCredSeikNgMail().createMail(theArg);

                Loggings.writeLog(
                    Loggings.createLogEntry(Loggings.Level.Warn, '20191107-1800-01', 'SorKetRenAutoCredSeikQms.sendSeikyu')
                        .putAttr('this.shodanBango', this.shodanBango)
                        .putAttr('resultCode', res.resultCode)
                        .putAttr('errMsgs', JSON.serialize(res.errMsgs))
                );
            }
        }

    }

}