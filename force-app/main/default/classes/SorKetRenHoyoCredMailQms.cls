public class SorKetRenHoyoCredMailQms implements IHdlQms{
    private static String msgType = 'SorKetRenHoyoCredMailQms';
    public class QmsData{
        public String shodanBango;
    }

    public static void InsertAsRoot(String shodanBango){
        SorKetRenHoyoCredMailQms.QmsData theData = new SorKetRenHoyoCredMailQms.QmsData();
        theData.shodanBango = shodanBango;
        INSERT QmsBld.newRoot().setMsgType( msgType ).setData( JSON.serialize( theData ) ).build();
    }

    public void handleQms(Qms__c pQms) {
        try{
            this.runQms(pQms);
            UPDATE New Qms__c(Id = pQms.Id, ShoriStatus__c = QmsShoriStatus.Completed);
        }catch(Exception ex){
            UPDATE New Qms__c(Id = pQms.Id, ShoriStatus__c = QmsShoriStatus.Failed);
            Loggings.writeLog(
                Loggings.createLogEntry(Loggings.Level.Error, '20191120-1000', msgType)
                    .setSubjectRecordId(pQms.Id)
                    .putAttr('Exception', ex.getMessage())
                    .putAttr('LineNumber', '' + ex.getLineNumber())
                    .putAttr('getStackTraceString', ex.getStackTraceString())
            );
        }
    }

    private void runQms(Qms__c pQms){

        SorKetRenHoyoCredMailQms.QmsData theQmsData = (SorKetRenHoyoCredMailQms.QmsData)JSON.deserialize(pQms.Data__c, SorKetRenHoyoCredMailQms.QmsData.class);

        Opportunity opp = (Opportunity)SobjectsExtension.firstOrNull(
            [
                Select
                    id,
                    SubPhase__c,
                    ShodanBango__c,
                    Amount,
                    SoryoKetteiRenrakuHoho__c,
                    Account.Name , Account.MailAddress__c ,
                    SorKetRenSakiAtena__c, SorKetRenSakiMail__c,
                    ObosanbinRef__r.KokubetsuDateTime_Inp__c,
                    ObosanbinRef__r.HoyoBashoMei__c, ObosanbinRef__r.TsuikahoyobashoMei__c,
                    ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.ShozokuSangouSangoJiin__r.Name,
                    ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.ShozokuSangouSangoJiin__r.SangoJiinMeiFurigana__c,
                    ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.ShozokuSangouSangoJiin__r.JiinSyuha__c
                FROM Opportunity
                WHERE ShodanBango__c = :theQmsData.shodanBango
            ]
        );

        SorKetRenHoyoCredMail.CreateMailArg theArg = new SorKetRenHoyoCredMail.CreateMailArg();

        String theToName = '';
        String theTo = '';
        Boolean theSorKetSakiSepecified =
            !String.isBlank(opp.SorKetRenSakiAtena__c) && !String.isBlank(opp.SorKetRenSakiMail__c);

        theToName = theSorKetSakiSepecified ? opp.SorKetRenSakiAtena__c : opp.Account.name;
        theTo = theSorKetSakiSepecified ? opp.SorKetRenSakiMail__c : opp.Account.MailAddress__c;

        theArg.name = theToName;
        theArg.mailaddress = theTo;
        theArg.jiinName = opp.ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.ShozokuSangouSangoJiin__r.Name;
        theArg.jiinNameKana = opp.ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.ShozokuSangouSangoJiin__r.SangoJiinMeiFurigana__c;
        theArg.shuha = opp.ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.ShozokuSangouSangoJiin__r.JiinSyuha__c;
        theArg.hoyoBashoName = opp.ObosanbinRef__r.HoyoBashoMei__c;
        theArg.tsuikaHoyoBashoName = opp.ObosanbinRef__r.TsuikahoyobashoMei__c;
        theArg.hoyoryo = opp.Amount;
        theArg.nichiji = opp.ObosanbinRef__r.KokubetsuDateTime_Inp__c;

        try{
            INSERT new SorKetRenHoyoCredMail().createMail(theArg);

            if(opp.SubPhase__c == '僧侶決定連絡'){
                SorKetRenAutoCredSeikQms.Data theSorKetRenAutoCredSeikQms = new SorKetRenAutoCredSeikQms.Data();
                theSorKetRenAutoCredSeikQms.oppId = opp.Id;
                theSorKetRenAutoCredSeikQms.seikyusakiChannel = 'MAIL';
                theSorKetRenAutoCredSeikQms.atena = theToName;
                theSorKetRenAutoCredSeikQms.mailAddress = theTo;
                theSorKetRenAutoCredSeikQms.mobile = '';
                INSERT QmsBld.newChild(pQms).setMsgType( SorKetRenAutoCredSeikQms.msgType ).setData( JSON.serialize( theSorKetRenAutoCredSeikQms ) ).build();
            }
        }catch( Exception ex){
            if(opp.SoryoKetteiRenrakuHoho__c != '電話'){
                UPDATE new Opportunity(Id = opp.Id, SoryoKetteiRenrakuHoho__c = '電話');
            }
            Loggings.writeLog(
                Loggings.createLogEntry(Loggings.Level.Warn, '20191126-1230-1', 'SorKetRenKaimCredMailQms.sendMailFailed')
                    .putAttr('Exception', ex.getMessage())
                    .putAttr('LineNumber', '' + ex.getLineNumber())
                    .putAttr('getStackTraceString', ex.getStackTraceString())
            );
        }

    }
}