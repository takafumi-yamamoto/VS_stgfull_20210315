public class SorKetRenKaimCredSdcQms implements IHdlQms{
    private static String msgType = 'SorKetRenKaimCredSdcQms';
    public class QmsData{
        public String shodanBango;
    }

    public static void InsertAsRoot(String shodanBango){
        SorKetRenKaimCredSdcQms.QmsData theData = new SorKetRenKaimCredSdcQms.QmsData();
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
                Loggings.createLogEntry(Loggings.Level.Error, '20191119-1900', msgType)
                    .setSubjectRecordId(pQms.Id)
                    .putAttr('Exception', ex.getMessage())
                    .putAttr('LineNumber', '' + ex.getLineNumber())
                    .putAttr('getStackTraceString', ex.getStackTraceString())
            );
        }
    }

    private void runQms(Qms__c pQms){

        SorKetRenKaimCredSdcQms.QmsData theQmsData = (SorKetRenKaimCredSdcQms.QmsData)JSON.deserialize(pQms.Data__c, SorKetRenKaimCredSdcQms.QmsData.class);

        Opportunity opp = (Opportunity)SobjectsExtension.firstOrNull(
            [
                Select
                    id,
                    ShodanBango__c,
                    Amount,
                    SoryoKetteiRenrakuHoho__c,
                    Account.name, Account.MobilePhone__c ,
                    SorKetRenSakiAtena__c, SorKetRenSakiMobile__c,
                    ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.ShozokuSangouSangoJiin__r.Name,
                    ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.ShozokuSangouSangoJiin__r.SangoJiinMeiFurigana__c,
                    ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.ShozokuSangouSangoJiin__r.JiinSyuha__c
                FROM Opportunity
                WHERE ShodanBango__c = :theQmsData.shodanBango
            ]
        );

        SorKetRenKaimCredSdc.CreateSdcReqArgs theArg = new SorKetRenKaimCredSdc.CreateSdcReqArgs();

        String theToName = '';
        String theTo = '';
        Boolean theSorKetSakiSepecified =
            !String.isBlank(opp.SorKetRenSakiAtena__c) && !String.isBlank(opp.SorKetRenSakiMobile__c);

        theToName = theSorKetSakiSepecified ? opp.SorKetRenSakiAtena__c : opp.Account.name;
        theTo = theSorKetSakiSepecified ? opp.SorKetRenSakiMobile__c : opp.Account.MobilePhone__c;
        if(String.isBlank(theTo)) {
            if(opp.SoryoKetteiRenrakuHoho__c != '電話'){
                UPDATE new Opportunity(Id = opp.Id, SoryoKetteiRenrakuHoho__c = '電話');
            }
            return;
        }
        theTo = TelNos.toNumber(theTo);

        theArg.to_phoneNo = theTo;
        theArg.to_atena = theToName;
        theArg.shodanBango = opp.ShodanBango__c;
        theArg.jiinName = opp.ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.ShozokuSangouSangoJiin__r.Name;
        theArg.jiinNameKana = opp.ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.ShozokuSangouSangoJiin__r.SangoJiinMeiFurigana__c;
        theArg.shuha = opp.ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.ShozokuSangouSangoJiin__r.JiinSyuha__c;
        theArg.hoyoryo = opp.Amount;

        try{
            SdcSendDocQms.Data theSdcSendDocQmsData = new SdcSendDocQms.Data();
            theSdcSendDocQmsData.sdcId = SdcDto.InsertSdc( SorKetRenKaimCredSdc.createSdc(theArg) );
            INSERT QmsBld.newChild(pQms).setMsgType( SdcSendDocQms.msgType ).setData( JSON.serialize( theSdcSendDocQmsData ) ).build();
        }catch( Exception ex){
            if(opp.SoryoKetteiRenrakuHoho__c != '電話'){
                UPDATE new Opportunity(Id = opp.Id, SoryoKetteiRenrakuHoho__c = '電話');
            }
            Loggings.writeLog(
                Loggings.createLogEntry(Loggings.Level.Warn, '20191126-1052', msgType)
                    .putAttr('Exception', ex.getMessage())
                    .putAttr('LineNumber', '' + ex.getLineNumber())
                    .putAttr('getStackTraceString', ex.getStackTraceString())
            );
        }

    }

}