public class SorKetRenKaimCredMailQms implements IHdlQms{
    private static String msgType = 'SorKetRenKaimCredMailQms';
    public class QmsData{
        public String shodanBango;
    }

    public static void InsertAsRoot(String shodanBango){
        SorKetRenKaimCredMailQms.QmsData theData = new SorKetRenKaimCredMailQms.QmsData();
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
                Loggings.createLogEntry(Loggings.Level.Error, '20191120-1800', msgType)
                    .setSubjectRecordId(pQms.Id)
                    .putAttr('Exception', ex.getMessage())
                    .putAttr('LineNumber', '' + ex.getLineNumber())
                    .putAttr('getStackTraceString', ex.getStackTraceString())
            );
        }
    }

    private void runQms(Qms__c pQms){

        SorKetRenKaimCredMailQms.QmsData theQmsData = (SorKetRenKaimCredMailQms.QmsData)JSON.deserialize(pQms.Data__c, SorKetRenKaimCredMailQms.QmsData.class);

        Opportunity opp = (Opportunity)SobjectsExtension.firstOrNull(
            [
                Select
                    id,
                    SubPhase__c,
                    ShodanBango__c,
                    Amount,
                    SoryoKetteiRenrakuHoho__c,
                    Account.name , Account.MailAddress__c ,
                    SorKetRenSakiAtena__c, SorKetRenSakiMail__c,
                    ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.ShozokuSangouSangoJiin__r.Name,
                    ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.ShozokuSangouSangoJiin__r.SangoJiinMeiFurigana__c,
                    ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.ShozokuSangouSangoJiin__r.JiinSyuha__c
                FROM Opportunity
                WHERE ShodanBango__c = :theQmsData.shodanBango
            ]
        );

        SorKetRenKaimCredMail.CreateMailArg theArg = new SorKetRenKaimCredMail.CreateMailArg();

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
        theArg.hoyoryo = opp.Amount;

        try{
            INSERT new SorKetRenKaimCredMail().createMail(theArg);

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
                Loggings.createLogEntry(Loggings.Level.Warn, '20191126-1220-1', 'SorKetRenKaimCredMailQms.sendMailFailed')
                    .putAttr('Exception', ex.getMessage())
                    .putAttr('LineNumber', '' + ex.getLineNumber())
                    .putAttr('getStackTraceString', ex.getStackTraceString())
            );
        }
    }

}