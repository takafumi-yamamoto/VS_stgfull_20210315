public class SorKetRenKaimCachMailQms implements IHdlQms{
    private static String msgType = 'SorKetRenKaimCachMailQms';
    public class QmsData{
        public String shodanBango;
    }

    public static void InsertAsRoot(String shodanBango){
        SorKetRenKaimCachMailQms.QmsData theData = new SorKetRenKaimCachMailQms.QmsData();
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
                Loggings.createLogEntry(Loggings.Level.Error, '20191120-1700', msgType)
                    .setSubjectRecordId(pQms.Id)
                    .putAttr('Exception', ex.getMessage())
                    .putAttr('LineNumber', '' + ex.getLineNumber())
                    .putAttr('getStackTraceString', ex.getStackTraceString())
            );
        }
    }

    private void runQms(Qms__c pQms){

        SorKetRenKaimCachMailQms.QmsData theQmsData = (SorKetRenKaimCachMailQms.QmsData)JSON.deserialize(pQms.Data__c, SorKetRenKaimCachMailQms.QmsData.class);

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

        SorKetRenKaimCachMail.CreateMailArg theArg = new SorKetRenKaimCachMail.CreateMailArg();

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

        Boolean isMailSent = false;
        try{
            INSERT new SorKetRenKaimCachMail().createMail(theArg);
            isMailSent = true;
        }catch( Exception ex){
            if(opp.SoryoKetteiRenrakuHoho__c != '電話'){
                UPDATE new Opportunity(Id = opp.Id, SoryoKetteiRenrakuHoho__c = '電話');
            }
            Loggings.writeLog(
                Loggings.createLogEntry(Loggings.Level.Warn, '20191126-1209-1', 'SorKetRenKaimCachMailQms.sendMailFailed')
                    .putAttr('Exception', ex.getMessage())
                    .putAttr('LineNumber', '' + ex.getLineNumber())
                    .putAttr('getStackTraceString', ex.getStackTraceString())
            );
        }

        if(isMailSent){
            try{
                if(opp.SubPhase__c == '僧侶決定連絡'){
                    UPDATE new Opportunity(Id = opp.Id, SubPhase__c = '依頼書・手配報告書作成');
                }
            }catch(Exception ex){
                SorKetRenErrMail.CreateMailArg mailArg = new SorKetRenErrMail.CreateMailArg();
                mailArg.ShodanId = opp.Id;
                mailArg.ShodanBango = theQmsData.shodanBango;
                mailArg.errorMessage = '僧侶決定連絡は完了しましたが、フェーズを更新中にエラーが発生しました。';
                INSERT new SorKetRenErrMail().createMail(mailArg);

                Loggings.writeLog(
                    Loggings.createLogEntry(Loggings.Level.Warn, '20191126-1209-2', 'SorKetRenKaimCachMailQms.updPhaseFailed')
                        .putAttr('Exception', ex.getMessage())
                        .putAttr('LineNumber', '' + ex.getLineNumber())
                        .putAttr('getStackTraceString', ex.getStackTraceString())
                );
            }
        }

    }
}