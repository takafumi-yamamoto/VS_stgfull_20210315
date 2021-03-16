public class Ctl_PartnerContract {

    /**
     * 葬儀社更新
     */
    @AuraEnabled
    public static ResponseDto auraUpdateSogisha(String partnerMoshikomiSogishaId, String sogishaId) {
        System.debug('partnerMoshikomiSogishaId:' + partnerMoshikomiSogishaId);
        System.debug('sogishaId:' + sogishaId);

        ResponseDto res = new ResponseDto(true, '');

        try{
            PartnerMoshikomi_Sogisha__c partnerMoshikomiSogisha = PartnerMoshikomi_SogishaDaos.GetInstance().SelectById(partnerMoshikomiSogishaId);

            if(partnerMoshikomiSogisha.MoshikomiService__c == null){
                return new ResponseDto(false, '申込サービスが選択されていません');
            }

            String recordTypeDeveloperName = '';
            if(partnerMoshikomiSogisha.MoshikomiService__c.contains('シンプルなお葬式(よりそうのお葬式)') && partnerMoshikomiSogisha.MoshikomiService__c.contains('葬儀レビ')) {
                recordTypeDeveloperName = '\'SimpleYasugo\',\'SougiRevi\'';
            }
            else if(partnerMoshikomiSogisha.MoshikomiService__c.contains('シンプルなお葬式(よりそうのお葬式)')) {
                recordTypeDeveloperName = '\'SimpleYasugo\'';
            }
            else if(partnerMoshikomiSogisha.MoshikomiService__c.contains('葬儀レビ')) {
                recordTypeDeveloperName = '\'SougiRevi\'';
            }

            String strAccountWhereParam = 'WHERE Id = \'' + sogishaId + '\'';
            String strAccountOrderByParam = '';
            String strKeiyakuWhereParam = 'WHERE RecordType.DeveloperName in (' + recordTypeDeveloperName + ') AND KeiyakuJokyo__c = \'契約中\'';
            String strKeiyakuOrderyByParam = '';
            Account updateSogisha = Dao_Account.getAccountKeiyakuByAccountId(strAccountWhereParam, strAccountOrderByParam, strKeiyakuWhereParam, strKeiyakuOrderyByParam);

            if(partnerMoshikomiSogisha.NameShogoFurigana__c != null) updateSogisha.NameShogoFurigana__c = partnerMoshikomiSogisha.NameShogoFurigana__c;
            if(partnerMoshikomiSogisha.NameShogo__c != null) updateSogisha.NameShogo__c = partnerMoshikomiSogisha.NameShogo__c;
            if(partnerMoshikomiSogisha.NameYagouFurigana__c != null) updateSogisha.NameYagouFurigana__c = partnerMoshikomiSogisha.NameYagouFurigana__c;
            if(partnerMoshikomiSogisha.TeikeisakiName__c != null) updateSogisha.Name = partnerMoshikomiSogisha.TeikeisakiName__c;
            if(partnerMoshikomiSogisha.UneiKeitai__c != null) updateSogisha.UneiKeitai__c = partnerMoshikomiSogisha.UneiKeitai__c;
            if(partnerMoshikomiSogisha.UneiKeitaiSonota__c != null) updateSogisha.UneiKeitaiSonota__c = partnerMoshikomiSogisha.UneiKeitaiSonota__c;
            if(partnerMoshikomiSogisha.BillingPostalCode__c != null) updateSogisha.BillingPostalCode = partnerMoshikomiSogisha.BillingPostalCode__c;
            if(partnerMoshikomiSogisha.BillingState__c != null) updateSogisha.BillingState = partnerMoshikomiSogisha.BillingState__c;
            if(partnerMoshikomiSogisha.BillingCity__c != null) updateSogisha.BillingCity = partnerMoshikomiSogisha.BillingCity__c;
            if(partnerMoshikomiSogisha.BillingStreet__c != null) updateSogisha.BillingStreet = partnerMoshikomiSogisha.BillingStreet__c;
            if(partnerMoshikomiSogisha.Phone__c != null) updateSogisha.Phone = partnerMoshikomiSogisha.Phone__c;
            if(partnerMoshikomiSogisha.Fax__c != null) updateSogisha.Fax = partnerMoshikomiSogisha.Fax__c;
            if(partnerMoshikomiSogisha.MailAddress__c != null) updateSogisha.MailAddress__c = partnerMoshikomiSogisha.MailAddress__c;
            if(partnerMoshikomiSogisha.Website__c != null) updateSogisha.Website = partnerMoshikomiSogisha.Website__c;
            
            String tempDaihoshameiKana = '';
            if(partnerMoshikomiSogisha.DaihyoshaseiKana__c != null) tempDaihoshameiKana += partnerMoshikomiSogisha.DaihyoshaseiKana__c + ' ';
            if(partnerMoshikomiSogisha.DaihyoshameiKana__c != null) tempDaihoshameiKana += partnerMoshikomiSogisha.DaihyoshameiKana__c;
            if(tempDaihoshameiKana != '') updateSogisha.DaihyomeiKana__c = tempDaihoshameiKana;

            String tempDaihoshamei = '';
            if(partnerMoshikomiSogisha.Daihyoshasei__c != null) tempDaihoshamei += partnerMoshikomiSogisha.Daihyoshasei__c + ' ';
            if(partnerMoshikomiSogisha.Daihyoshamei__c != null) tempDaihoshamei += partnerMoshikomiSogisha.Daihyoshamei__c;
            if(tempDaihoshamei != '') updateSogisha.DaihyoName__c = tempDaihoshamei;

            String tempKeiriTantoshaKana = '';
            if(partnerMoshikomiSogisha.KeiriTantoshaseiKana__c != null) tempKeiriTantoshaKana += partnerMoshikomiSogisha.KeiriTantoshaseiKana__c + ' ';
            if(partnerMoshikomiSogisha.KeiriTantoshameiKana__c != null) tempKeiriTantoshaKana += partnerMoshikomiSogisha.KeiriTantoshameiKana__c + ' ';
            if(tempKeiriTantoshaKana != '') updateSogisha.SeikyuSakiTantoNameFurigana__c = tempKeiriTantoshaKana;
            
            String tempKeiriTantosha = '';
            if(partnerMoshikomiSogisha.KeiriTantoshasei__c != null) tempKeiriTantosha += partnerMoshikomiSogisha.KeiriTantoshasei__c + ' ';
            if(partnerMoshikomiSogisha.KeiriTantoshamei__c != null) tempKeiriTantosha += partnerMoshikomiSogisha.KeiriTantoshamei__c;
            if(tempKeiriTantosha != '') updateSogisha.SeikyuSakiTantoName__c = tempKeiriTantosha;
            
            if(partnerMoshikomiSogisha.KeiriTantoshaTel__c != null) updateSogisha.KeiriTantoshaTel__c = partnerMoshikomiSogisha.KeiriTantoshaTel__c;
            if(partnerMoshikomiSogisha.ShuyoRenrakusaki__c != null) updateSogisha.ShuyoRenrakusaki__c = partnerMoshikomiSogisha.ShuyoRenrakusaki__c;
            if(partnerMoshikomiSogisha.ShindaishaShoyusu__c != null) updateSogisha.ShindaishaShoyusu__c = Decimal.valueOf(partnerMoshikomiSogisha.ShindaishaShoyusu__c);
            if(partnerMoshikomiSogisha.JisyaSaijoSyoyuSu__c != null) updateSogisha.JisyaSaijoSyoyuSu__c = Decimal.valueOf(partnerMoshikomiSogisha.JisyaSaijoSyoyuSu__c);
            if(partnerMoshikomiSogisha.SeikyusakiShogoKana__c != null) updateSogisha.SeikyusakiShogoKana__c = partnerMoshikomiSogisha.SeikyusakiShogoKana__c;
            if(partnerMoshikomiSogisha.SeikyusakiShogo__c != null) updateSogisha.SeikyusakiShogo__c = partnerMoshikomiSogisha.SeikyusakiShogo__c;
            if(partnerMoshikomiSogisha.SeikyusakiYagokana__c != null) updateSogisha.SeikyusakiYagokana__c = partnerMoshikomiSogisha.SeikyusakiYagokana__c;
            if(partnerMoshikomiSogisha.SeikyusakiYago__c != null) updateSogisha.SeikyusakiYago__c = partnerMoshikomiSogisha.SeikyusakiYago__c;
            if(partnerMoshikomiSogisha.SeikyuSakiAddrPostalCode__c != null) updateSogisha.SeikyuSakiAddrPostalCode__c = partnerMoshikomiSogisha.SeikyuSakiAddrPostalCode__c;
            if(partnerMoshikomiSogisha.SeikyuSakiAddrState__c != null) updateSogisha.SeikyuSakiAddrState__c = partnerMoshikomiSogisha.SeikyuSakiAddrState__c;
            if(partnerMoshikomiSogisha.SeikyuSakiAddrCity__c != null) updateSogisha.SeikyuSakiAddrCity__c = partnerMoshikomiSogisha.SeikyuSakiAddrCity__c;
            if(partnerMoshikomiSogisha.SeikyuSakiAddrStreet__c != null) updateSogisha.SeikyuSakiAddrStreet__c = partnerMoshikomiSogisha.SeikyuSakiAddrStreet__c;
            if(partnerMoshikomiSogisha.SeikyusakiTel__c != null) updateSogisha.SeikyusakiTel__c = partnerMoshikomiSogisha.SeikyusakiTel__c;
            if(partnerMoshikomiSogisha.SeikyusakiFax__c != null) updateSogisha.SeikyusakiFax__c = partnerMoshikomiSogisha.SeikyusakiFax__c;
            
            String tempSeikyuTantoshaKana = '';
            if(partnerMoshikomiSogisha.SeikyusakiTantoshaseiKana__c != null) tempSeikyuTantoshaKana += partnerMoshikomiSogisha.SeikyusakiTantoshaseiKana__c + ' ';
            if(partnerMoshikomiSogisha.SeikyusakiTantoshameiKana__c != null) tempSeikyuTantoshaKana += partnerMoshikomiSogisha.SeikyusakiTantoshameiKana__c;
            if(tempSeikyuTantoshaKana != '') updateSogisha.SeikyusakiTantoshaKana__c = tempSeikyuTantoshaKana;
            
            String tempSeikyuTantosha = '';
            if(partnerMoshikomiSogisha.SeikyusakiTantoshasei__c != null) tempSeikyuTantosha += partnerMoshikomiSogisha.SeikyusakiTantoshasei__c + ' ';
            if(partnerMoshikomiSogisha.SeikyusakiTantoshamei__c != null) tempSeikyuTantosha += partnerMoshikomiSogisha.SeikyusakiTantoshamei__c;
            if(tempSeikyuTantosha != '') updateSogisha.SeikyusakiTantosha__c = tempSeikyuTantosha;
            
            if(partnerMoshikomiSogisha.BankName__c != null) updateSogisha.BankName__c = partnerMoshikomiSogisha.BankName__c;
            if(partnerMoshikomiSogisha.BankBranchName__c != null) updateSogisha.BankBranchName__c = partnerMoshikomiSogisha.BankBranchName__c;
            if(partnerMoshikomiSogisha.BankAccountType__c != null) updateSogisha.BankAccountType__c = partnerMoshikomiSogisha.BankAccountType__c;
            if(partnerMoshikomiSogisha.BankAccountNo__c != null) updateSogisha.BankAccountNo__c = partnerMoshikomiSogisha.BankAccountNo__c;
            if(partnerMoshikomiSogisha.BankAccountMeigi__c != null) updateSogisha.BankAccountMeigi__c = partnerMoshikomiSogisha.BankAccountMeigi__c;
            if(partnerMoshikomiSogisha.HekinSekoKensuNen__c != null) updateSogisha.HekinSekoKensuNen__c = Decimal.valueOf(partnerMoshikomiSogisha.HekinSekoKensuNen__c);
            if(partnerMoshikomiSogisha.SekoStaffNinzu__c != null) updateSogisha.SekoStaffNinzu__c = Decimal.valueOf(partnerMoshikomiSogisha.SekoStaffNinzu__c);
            if(partnerMoshikomiSogisha.SekoKanoKensuTsuki__c != null) updateSogisha.SekoKanoKensuTsuki__c = Decimal.valueOf(partnerMoshikomiSogisha.SekoKanoKensuTsuki__c);
            if(partnerMoshikomiSogisha.SosaiPlannerNinzu__c != null) updateSogisha.SosaiPlannerNinzu__c = Decimal.valueOf(partnerMoshikomiSogisha.SosaiPlannerNinzu__c);
            if(partnerMoshikomiSogisha.SosaiDirectorNinzu__c != null) updateSogisha.SosaiDirectorNinzu__c = Decimal.valueOf(partnerMoshikomiSogisha.SosaiDirectorNinzu__c);
            update updateSogisha;

            for(Keiyaku__c updateKeiyaku : updateSogisha.KeiyakusTeikeisaki__r){
                
                String tempKeiyakuTantoshaKana = '';
                if(partnerMoshikomiSogisha.KeiyakuTantoshaseiKana__c != null) tempKeiyakuTantoshaKana += partnerMoshikomiSogisha.KeiyakuTantoshaseiKana__c + ' ';
                if(partnerMoshikomiSogisha.KeiyakuTantoshameiKana__c != null) tempKeiyakuTantoshaKana += partnerMoshikomiSogisha.KeiyakuTantoshameiKana__c;
                if(tempKeiyakuTantoshaKana != '') updateKeiyaku.KeiyakuTantoNameFurigana__c = tempKeiyakuTantoshaKana;

                String tempKeiyakuTantosha = '';
                if(partnerMoshikomiSogisha.KeiyakuTantoshasei__c != null) tempKeiyakuTantosha += partnerMoshikomiSogisha.KeiyakuTantoshasei__c + ' ';
                if(partnerMoshikomiSogisha.KeiyakuTantoshamei__c != null) tempKeiyakuTantosha += partnerMoshikomiSogisha.KeiyakuTantoshamei__c;
                if(tempKeiyakuTantosha != '') updateKeiyaku.KeiyakuTantoName__c = tempKeiyakuTantosha;
                
                if(partnerMoshikomiSogisha.KeiyakuTantoYakuShoku__c != null) updateKeiyaku.KeiyakuTantoYakuShoku__c = partnerMoshikomiSogisha.KeiyakuTantoYakuShoku__c;
                if(partnerMoshikomiSogisha.KeiyakuTantoTelNo__c != null) updateKeiyaku.KeiyakuTantoTelNo__c = partnerMoshikomiSogisha.KeiyakuTantoTelNo__c;
                if(partnerMoshikomiSogisha.KeiyakuTantoEmail__c != null) updateKeiyaku.KeiyakuTantoEmail__c = partnerMoshikomiSogisha.KeiyakuTantoEmail__c;
                if(partnerMoshikomiSogisha.UnsoKyokasyoKubun__c != null) updateKeiyaku.UnsoKyokasyoKubun__c = partnerMoshikomiSogisha.UnsoKyokasyoKubun__c;
                if(partnerMoshikomiSogisha.TokkijikoPartnerKinyu__c != null) updateKeiyaku.TokkijikoPartnerKinyu__c = partnerMoshikomiSogisha.TokkijikoPartnerKinyu__c;
                if(partnerMoshikomiSogisha.TaiouKanouArea__c != null) updateKeiyaku.TaiouKanouArea__c = partnerMoshikomiSogisha.TaiouKanouArea__c;
                if(partnerMoshikomiSogisha.JishaSyukyakujiTaiokanoNaiyo__c != null) updateKeiyaku.JishaSyukyakujiTaiokanoNaiyo__c = partnerMoshikomiSogisha.JishaSyukyakujiTaiokanoNaiyo__c;
                if(partnerMoshikomiSogisha.ShiharaiHoho__c != null) updateKeiyaku.ShiharaiHoho__c = partnerMoshikomiSogisha.ShiharaiHoho__c;
                if(partnerMoshikomiSogisha.ShiharaiHohoSonota__c != null) updateKeiyaku.ShiharaiHohoSonota__c = partnerMoshikomiSogisha.ShiharaiHohoSonota__c;
                if(partnerMoshikomiSogisha.SekoRyunyuHiritsuJishaShukaku__c != null) updateKeiyaku.SekoRyunyuHiritsuJishaShukaku__c = Decimal.valueOf(partnerMoshikomiSogisha.SekoRyunyuHiritsuJishaShukaku__c);
                if(partnerMoshikomiSogisha.SekorRyunyuHiritsuByoinKesatsuKaigo__c != null) updateKeiyaku.SekorRyunyuHiritsuByoinKesatsuKaigo__c = Decimal.valueOf(partnerMoshikomiSogisha.SekorRyunyuHiritsuByoinKesatsuKaigo__c);
                if(partnerMoshikomiSogisha.SekoRyunyuHiritsuInternet__c != null) updateKeiyaku.SekoRyunyuHiritsuInternet__c = Decimal.valueOf(partnerMoshikomiSogisha.SekoRyunyuHiritsuInternet__c);
                if(partnerMoshikomiSogisha.SekoRyunyuHiritsuSonota__c != null) updateKeiyaku.SekoRyunyuHiritsuSonota__c = Decimal.valueOf(partnerMoshikomiSogisha.SekoRyunyuHiritsuSonota__c);
                if(partnerMoshikomiSogisha.SekoHiritsuChokuso__c != null) updateKeiyaku.SekoHiritsuChokuso__c = Decimal.valueOf(partnerMoshikomiSogisha.SekoHiritsuChokuso__c);
                if(partnerMoshikomiSogisha.SekoHiritsuIchinichiso__c != null) updateKeiyaku.SekoHiritsuIchinichiso__c = Decimal.valueOf(partnerMoshikomiSogisha.SekoHiritsuIchinichiso__c);
                if(partnerMoshikomiSogisha.SekoHiritsuKazokuso__c != null) updateKeiyaku.SekoHiritsuKazokuso__c = Decimal.valueOf(partnerMoshikomiSogisha.SekoHiritsuKazokuso__c);
                if(partnerMoshikomiSogisha.SekoHiritsuIppanso__c != null) updateKeiyaku.SekoHiritsuIppanso__c = Decimal.valueOf(partnerMoshikomiSogisha.SekoHiritsuIppanso__c);
                if(partnerMoshikomiSogisha.SekoHiritsuHansoAnken__c != null) updateKeiyaku.SekoHiritsuHansoAnken__c = Decimal.valueOf(partnerMoshikomiSogisha.SekoHiritsuHansoAnken__c);
                if(partnerMoshikomiSogisha.SekoHiritsuSonota__c != null) updateKeiyaku.SekoHiritsuSonota__c = Decimal.valueOf(partnerMoshikomiSogisha.SekoHiritsuSonota__c);
                if(partnerMoshikomiSogisha.SekoHekinTanka__c != null) updateKeiyaku.SekoHekinTanka__c = Decimal.valueOf(partnerMoshikomiSogisha.SekoHekinTanka__c);
                if(partnerMoshikomiSogisha.SogiBrandTaioKanoNaiyo__c != null) updateKeiyaku.SogiBrandTaioKanoNaiyo__c = partnerMoshikomiSogisha.SogiBrandTaioKanoNaiyo__c;
                if(partnerMoshikomiSogisha.SaidaiEnkiNissuKasoshiki__c != null) updateKeiyaku.SaidaiEnkiNissuKasoshiki__c = Decimal.valueOf(partnerMoshikomiSogisha.SaidaiEnkiNissuKasoshiki__c);
                if(partnerMoshikomiSogisha.SaidaiBunkatuKaisuKasoshiki__c != null) updateKeiyaku.SaidaiBunkatuKaisuKasoshiki__c = Decimal.valueOf(partnerMoshikomiSogisha.SaidaiBunkatuKaisuKasoshiki__c);
                if(partnerMoshikomiSogisha.SaidaiEnkiNissuShikiari__c != null) updateKeiyaku.SaidaiEnkiNissuShikiari__c = Decimal.valueOf(partnerMoshikomiSogisha.SaidaiEnkiNissuShikiari__c);
                if(partnerMoshikomiSogisha.SaidaiBunkatsuKaisuShikiari__c != null) updateKeiyaku.SaidaiBunkatsuKaisuShikiari__c = Decimal.valueOf(partnerMoshikomiSogisha.SaidaiBunkatsuKaisuShikiari__c);
                update updateKeiyaku;
            }

            partnerMoshikomiSogisha.OkyakusamaTeikeisaki__c = sogishaId;
            update partnerMoshikomiSogisha;
        }
        catch(Exception e){
            System.debug('e.getMessage():' + e.getMessage());
            System.debug('e.getStackTraceString():' + e.getStackTraceString());
            res = new ResponseDto(false, 'システムエラーが発生しました：' + e.getMessage());
        }

        return res;
    }

    /**
     * 葬儀社担当者更新
     */
    @AuraEnabled
    public static ResponseDto auraUpdateContact(String partnerMoshikomiSogishaId, String contactId) {
        System.debug('partnerMoshikomiSogishaId:' + partnerMoshikomiSogishaId);
        System.debug('contactId:' + contactId);

        ResponseDto res = new ResponseDto(true, '');

        try{
            PartnerMoshikomi_Sogisha__c partnerMoshikomiSogisha = PartnerMoshikomi_SogishaDaos.GetInstance().SelectById(partnerMoshikomiSogishaId);
            Contact updateContact = Dao_Contact.getContactByContactId(contactId);

            if(partnerMoshikomiSogisha.KeiyakuTantoshaseiKana__c != null) updateContact.LastNameFurigana__c = partnerMoshikomiSogisha.KeiyakuTantoshaseiKana__c;
            if(partnerMoshikomiSogisha.KeiyakuTantoshameiKana__c != null) updateContact.FirstNameFurigana__c = partnerMoshikomiSogisha.KeiyakuTantoshameiKana__c;
            if(partnerMoshikomiSogisha.KeiyakuTantoshasei__c != null) updateContact.LastName = partnerMoshikomiSogisha.KeiyakuTantoshasei__c;
            if(partnerMoshikomiSogisha.KeiyakuTantoshamei__c != null) updateContact.FirstName = partnerMoshikomiSogisha.KeiyakuTantoshamei__c;
            if(partnerMoshikomiSogisha.KeiyakuTantoTelNo__c != null) updateContact.Phone = partnerMoshikomiSogisha.KeiyakuTantoTelNo__c;
            if(partnerMoshikomiSogisha.KeiyakuTantoEmail__c != null) updateContact.Email = partnerMoshikomiSogisha.KeiyakuTantoEmail__c;
            if(partnerMoshikomiSogisha.KeiyakuTantoYakuShoku__c != null) updateContact.Title = partnerMoshikomiSogisha.KeiyakuTantoYakuShoku__c;
            update updateContact;

            partnerMoshikomiSogisha.TeikeisakiTantoshaRef__c = contactId;
            update partnerMoshikomiSogisha;
        }
        catch(Exception e){
            System.debug('e.getMessage():' + e.getMessage());
            System.debug('e.getStackTraceString():' + e.getStackTraceString());
            res = new ResponseDto(false, 'システムエラーが発生しました：' + e.getMessage());
        }

        return res;
    }

    /**
     * 斎場更新
     */
    @AuraEnabled
    public static ResponseDto auraUpdateSaijo(String partnerMoshikomiSaijoId, String saijoId) {
        System.debug('partnerMoshikomiSaijoId:' + partnerMoshikomiSaijoId);
        System.debug('saijoId:' + saijoId);

        ResponseDto res = new ResponseDto(true, '');

        try{
            PartnerMoshikomi_Saijo__c partnerMoshikomiSaijo = PartnerMoshikomi_SaijoDaos.GetInstance().SelectById(partnerMoshikomiSaijoId);
            Shisetsu__c updateSaijo = Dao_Shisetsu.getShisetsuByShisetsuId(saijoId);

            if(partnerMoshikomiSaijo.FAX__c != null) updateSaijo.FAX__c = partnerMoshikomiSaijo.FAX__c;
            if(partnerMoshikomiSaijo.HpUrl__c != null) updateSaijo.HpUrl__c = partnerMoshikomiSaijo.HpUrl__c;
            if(partnerMoshikomiSaijo.AccessHohoBasu__c != null) updateSaijo.AccessHohoBasu__c = partnerMoshikomiSaijo.AccessHohoBasu__c;
            if(partnerMoshikomiSaijo.AccessHohoKuruma__c != null) updateSaijo.AccessHohoKuruma__c = partnerMoshikomiSaijo.AccessHohoKuruma__c;
            if(partnerMoshikomiSaijo.AccessHouhouDensha__c != null) updateSaijo.AccessHouhouDensha__c = partnerMoshikomiSaijo.AccessHouhouDensha__c;
            if(partnerMoshikomiSaijo.OmutsuKokandaiAri__c != null) updateSaijo.OmutsuKokandaiAri__c = changeBoolean(partnerMoshikomiSaijo.OmutsuKokandaiAri__c);
            if(partnerMoshikomiSaijo.KizzuRoomAri__c != null) updateSaijo.KizzuRoomAri__c = changeBoolean(partnerMoshikomiSaijo.KizzuRoomAri__c);
            if(partnerMoshikomiSaijo.ShawaRoomAri__c != null) updateSaijo.ShawaRoomAri__c = changeBoolean(partnerMoshikomiSaijo.ShawaRoomAri__c);
            if(partnerMoshikomiSaijo.Bariafuri__c != null) updateSaijo.Bariafuri__c = changeBoolean(partnerMoshikomiSaijo.Bariafuri__c);
            if(partnerMoshikomiSaijo.BebiRoomAri__c != null) updateSaijo.BebiRoomAri__c = changeBoolean(partnerMoshikomiSaijo.BebiRoomAri__c);
            if(partnerMoshikomiSaijo.HoleSetsumeibun__c != null) updateSaijo.HoleSetsumeibun__c = partnerMoshikomiSaijo.HoleSetsumeibun__c;
            if(partnerMoshikomiSaijo.AnchiKa__c != null) updateSaijo.AnchiKa__c = changeBoolean(partnerMoshikomiSaijo.AnchiKa__c);
            if(partnerMoshikomiSaijo.AnchiTaioNinzu__c != null) updateSaijo.AnchiTaioNinzu__c = Decimal.valueOf(partnerMoshikomiSaijo.AnchiTaioNinzu__c);
            if(partnerMoshikomiSaijo.AnchiMenkaiKa__c != null) updateSaijo.AnchiMenkaiKa__c = changeBoolean(partnerMoshikomiSaijo.AnchiMenkaiKa__c);
            if(partnerMoshikomiSaijo.IchinichisoKa__c != null) updateSaijo.IchinichisoKa__c = changeBoolean(partnerMoshikomiSaijo.IchinichisoKa__c);
            if(partnerMoshikomiSaijo.IppansoKa__c != null) updateSaijo.IppansoKa__c = changeBoolean(partnerMoshikomiSaijo.IppansoKa__c);
            if(partnerMoshikomiSaijo.Organiser__c != null) updateSaijo.Organiser__c = partnerMoshikomiSaijo.Organiser__c;
            if(partnerMoshikomiSaijo.KazokusoKa__c != null) updateSaijo.KazokusoKa__c = changeBoolean(partnerMoshikomiSaijo.KazokusoKa__c);
            if(partnerMoshikomiSaijo.KasoshikiKa__c != null) updateSaijo.KasoshikiKa__c = changeBoolean(partnerMoshikomiSaijo.KasoshikiKa__c);
            if(partnerMoshikomiSaijo.CloseDay__c != null) updateSaijo.CloseDay__c = partnerMoshikomiSaijo.CloseDay__c;
            if(partnerMoshikomiSaijo.KoeiMinei__c != null) updateSaijo.KoeiMinei__c = partnerMoshikomiSaijo.KoeiMinei__c;
            if(partnerMoshikomiSaijo.Saijomei__c != null) updateSaijo.Name = partnerMoshikomiSaijo.Saijomei__c;
            if(partnerMoshikomiSaijo.ShisetsumeiFurigana__c != null) updateSaijo.ShisetsumeiFurigana__c = partnerMoshikomiSaijo.ShisetsumeiFurigana__c;
            if(partnerMoshikomiSaijo.JunyushitsuAri__c != null) updateSaijo.JunyushitsuAri__c = changeBoolean(partnerMoshikomiSaijo.JunyushitsuAri__c);
            if(partnerMoshikomiSaijo.ShukuhakuKa__c != null) updateSaijo.ShukuhakuKa__c = changeBoolean(partnerMoshikomiSaijo.ShukuhakuKa__c);
            if(partnerMoshikomiSaijo.ShukuhakuShisetsuBiko__c != null) updateSaijo.ShukuhakuShisetsuBiko__c = partnerMoshikomiSaijo.ShukuhakuShisetsuBiko__c;
            if(partnerMoshikomiSaijo.ShukuhakuShisetsuRyokin__c != null) updateSaijo.ShukuhakuShisetsuRyokin__c = Decimal.valueOf(partnerMoshikomiSaijo.ShukuhakuShisetsuRyokin__c);
            if(partnerMoshikomiSaijo.ShinzokuHikaeshitsuAri__c != null) updateSaijo.ShinzokuHikaeshitsuAri__c = changeBoolean(partnerMoshikomiSaijo.ShinzokuHikaeshitsuAri__c);
            if(partnerMoshikomiSaijo.ZenShuhaTaioKa__c != null) updateSaijo.ZenShuhaTaioKa__c = changeBoolean(partnerMoshikomiSaijo.ZenShuhaTaioKa__c);
            if(partnerMoshikomiSaijo.TaioKanoNinzu__c != null) updateSaijo.Scale__c = partnerMoshikomiSaijo.TaioKanoNinzu__c;
            if(partnerMoshikomiSaijo.ChushajoAri__c != null) updateSaijo.ChushajoAri__c = changeBoolean(partnerMoshikomiSaijo.ChushajoAri__c);
            if(partnerMoshikomiSaijo.Chushadaisu__c != null) updateSaijo.Chushadaisu__c = Decimal.valueOf(partnerMoshikomiSaijo.Chushadaisu__c);
            if(partnerMoshikomiSaijo.Street__c != null) updateSaijo.Street__c = partnerMoshikomiSaijo.Street__c;
            if(partnerMoshikomiSaijo.ChokusoKa__c != null) updateSaijo.ChokusoKa__c = changeBoolean(partnerMoshikomiSaijo.ChokusoKa__c);
            if(partnerMoshikomiSaijo.Phone1__c != null) updateSaijo.Phone1__c = partnerMoshikomiSaijo.Phone1__c;
            if(partnerMoshikomiSaijo.TsukisoiAnchiKa__c != null) updateSaijo.TsukisoiAnchiKa__c = changeBoolean(partnerMoshikomiSaijo.TsukisoiAnchiKa__c);
            if(partnerMoshikomiSaijo.Horeikosu__c != null) updateSaijo.Horeikosu__c = Decimal.valueOf(partnerMoshikomiSaijo.Horeikosu__c);
            if(partnerMoshikomiSaijo.HoyoKa__c != null) updateSaijo.HoyoKa__c = changeBoolean(partnerMoshikomiSaijo.HoyoKa__c);
            if(partnerMoshikomiSaijo.PostalCode__c != null) updateSaijo.PostalCode__c = partnerMoshikomiSaijo.PostalCode__c;
            if(partnerMoshikomiSaijo.AnchiResidentPrice__c != null) updateSaijo.AnchiResidentPrice__c = partnerMoshikomiSaijo.AnchiResidentPrice__c;

            String shikugunId = '';
            if(partnerMoshikomiSaijo.State__c != null && partnerMoshikomiSaijo.City__c != null){
                List<Shikugun__c> sltShikugunList = Dao_Shikugun.SearchShikugunByFullName(partnerMoshikomiSaijo.State__c + partnerMoshikomiSaijo.City__c);
                if(sltShikugunList.size() == 1){
                    shikugunId = sltShikugunList.get(0).Id;
                }
            }
            if(shikugunId != '') updateSaijo.Shikugun__c = shikugunId;
            update updateSaijo;

            partnerMoshikomiSaijo.ShisetsuRef__c = saijoId;
            update partnerMoshikomiSaijo;
        }
        catch(Exception e){
            System.debug('e.getMessage():' + e.getMessage());
            System.debug('e.getStackTraceString():' + e.getStackTraceString());
            res = new ResponseDto(false, 'システムエラーが発生しました：' + e.getMessage());
        }

        return res;
    }


    /**
     * 僧侶更新
     */
    @AuraEnabled
    public static ResponseDto auraUpdateSouryou(String partnerMoshikomiObosanbinId, String souryouId) {
        System.debug('partnerMoshikomiObosanbinId:' + partnerMoshikomiObosanbinId);
        System.debug('souryouId:' + souryouId);

        ResponseDto res = new ResponseDto(true, '');

        Savepoint sp = Database.setSavepoint();

        try{
            PartnerMoshikomi_Obosanbin__c partnerMoshikomiSogisha = PartnerMoshikomi_ObosanDaos.GetInstance().SelectById(partnerMoshikomiObosanbinId);
            Account obo = null;
            for(Account aAcc : [Select Id,ShozokuSangouSangoJiin__c,ZaisekiSaki__c,
                                    (Select Id From KeiyakusTeikeisaki__r WHERE KeiyakuJokyo__c = '契約中' limit 1) 
                                    From Account WHERE Id = :souryouId limit 1]) {
                obo = aAcc;
            }
            if(obo == null) {
                res = new ResponseDto(false, '僧侶が見つかりません！' + souryouId);
                return res;
            }

            Account updateObo = new Account(Id=souryouId);
            Account shozokuSangouSangoJiin = new Account(Id=obo.ShozokuSangouSangoJiin__c);
            Account zaisekiSaki = new Account(Id=obo.ZaisekiSaki__c);
            Keiyaku__c keiyaku = null;
            if(obo.KeiyakusTeikeisaki__r != null && obo.KeiyakusTeikeisaki__r.size() > 0) keiyaku = obo.KeiyakusTeikeisaki__r[0];

            if(partnerMoshikomiSogisha.LastNameFurigana__c != null) updateObo.SeiKana__c = partnerMoshikomiSogisha.LastNameFurigana__c ; //姓（カナ）
            if(partnerMoshikomiSogisha.FirstNameFurigana__c != null) updateObo.MeiKana__c = partnerMoshikomiSogisha.FirstNameFurigana__c ; //名（カナ）
            if(partnerMoshikomiSogisha.LastName__c != null || partnerMoshikomiSogisha.FirstName__c != null ) 
                updateObo.Name = str(partnerMoshikomiSogisha.LastName__c) + ' ' + str(partnerMoshikomiSogisha.FirstName__c) ; //姓名
            if(partnerMoshikomiSogisha.Gender__c != null) updateObo.Seibetsu__c = partnerMoshikomiSogisha.Gender__c ; //性別
            if(partnerMoshikomiSogisha.JiinSyuha__c != null) updateObo.JiinSyuha__c = partnerMoshikomiSogisha.JiinSyuha__c ; //宗派
            if(partnerMoshikomiSogisha.JiinShuhaSonotaKana__c != null) updateObo.JiinShuhaSonotaKana__c = partnerMoshikomiSogisha.JiinShuhaSonotaKana__c ; //宗派その他(カナ)
            if(partnerMoshikomiSogisha.JiinShuhaSonota__c != null) updateObo.JiinShushaSonota__c = partnerMoshikomiSogisha.JiinShuhaSonota__c ; //宗派その他
            if(partnerMoshikomiSogisha.MoshikomishaKyojuchiPostalcode__c != null) updateObo.BillingPostalCode = partnerMoshikomiSogisha.MoshikomishaKyojuchiPostalcode__c ; // 住所(請求先)(郵便番号)
            if(partnerMoshikomiSogisha.MoshikomishaKyojuchiState__c != null) updateObo.BillingState = partnerMoshikomiSogisha.MoshikomishaKyojuchiState__c ; // 住所(請求先)(都道府県)
            if(partnerMoshikomiSogisha.MoshikomishaKyojuchiCity__c != null) updateObo.BillingCity = partnerMoshikomiSogisha.MoshikomishaKyojuchiCity__c ; // 住所(請求先)(市区郡)
            if(partnerMoshikomiSogisha.MoshikomishaKyojuchiStreet__c != null) updateObo.BillingStreet = partnerMoshikomiSogisha.MoshikomishaKyojuchiStreet__c ; // 住所(請求先)(町名・番地)
            if(partnerMoshikomiSogisha.Phone__c != null) updateObo.Phone = partnerMoshikomiSogisha.Phone__c ; //電話1
            if(partnerMoshikomiSogisha.Fax__c != null) updateObo.Fax = partnerMoshikomiSogisha.Fax__c ; // Fax
            if(partnerMoshikomiSogisha.MobilePhone__c != null) updateObo.MobilePhone__c = partnerMoshikomiSogisha.MobilePhone__c ; //携帯1
            if(partnerMoshikomiSogisha.HomutaiokanoArea__c != null) updateObo.HomutaiokanoArea__c = partnerMoshikomiSogisha.HomutaiokanoArea__c ; //法務対応可能エリア
            if(partnerMoshikomiSogisha.PersonBirthdate__c != null) updateObo.Seinengappi__c = Date.valueOf(partnerMoshikomiSogisha.PersonBirthdate__c) ; //生年月日
            // if(partnerMoshikomiSogisha.HoninKakuninSyoruiSyubetsu__c != null) updateObo.HonninKakuninSyoruiSyubetsu__c = partnerMoshikomiSogisha.HoninKakuninSyoruiSyubetsu__c ; //本人確認書類種別

            if(partnerMoshikomiSogisha.MailAddress__c != null) updateObo.MailAddress__c = partnerMoshikomiSogisha.MailAddress__c ; //メールアドレス1
            if(partnerMoshikomiSogisha.SangoJiinMeiFurigana__c != null) updateObo.SangoJiinMeiFurigana__c = partnerMoshikomiSogisha.SangoJiinMeiFurigana__c ; //山号寺院名（カナ）

            if(partnerMoshikomiSogisha.JiinjohoBetsuinjushoPostalcode__c != null) updateObo.JiinjohoBetsuinjushoPostalcode__c = partnerMoshikomiSogisha.JiinjohoBetsuinjushoPostalcode__c ; // 住所(請求先)(郵便番号)
            if(partnerMoshikomiSogisha.JiinjohoBetsuinjushoState__c != null) updateObo.JiinjohoBetsuinjushoState__c = partnerMoshikomiSogisha.JiinjohoBetsuinjushoState__c ; // 住所(請求先)(都道府県)
            if(partnerMoshikomiSogisha.JiinjohoBetsuinjushoCity__c != null) updateObo.JiinjohoBetsuinjushoCity__c = partnerMoshikomiSogisha.JiinjohoBetsuinjushoCity__c ; // 住所(請求先)(市区郡)
            if(partnerMoshikomiSogisha.JiinjohoBetsuinjushoStreet__c != null) updateObo.JiinjohoBetsuinjushoStreet__c = partnerMoshikomiSogisha.JiinjohoBetsuinjushoStreet__c ; // 住所(請求先)(町名・番地)
            if(partnerMoshikomiSogisha.JiinjohoBetsuindenokatsudo__c != null) updateObo.BetsuinKatsudoKibo__c = changeBoolean(partnerMoshikomiSogisha.JiinjohoBetsuindenokatsudo__c) ; // 別院での活動を希望
            if(partnerMoshikomiSogisha.JiinjohoBetsuintel__c != null) updateObo.JiinjohoBetsuintel__c = partnerMoshikomiSogisha.JiinjohoBetsuintel__c ; // 電話1
            if(partnerMoshikomiSogisha.JiinjohoBetsuinfax__c != null) updateObo.JiinjohoBetsuinfax__c = partnerMoshikomiSogisha.JiinjohoBetsuinfax__c ; // Fax

            if(partnerMoshikomiSogisha.BankName__c != null) updateObo.BankName__c = partnerMoshikomiSogisha.BankName__c ; //銀行名
            if(partnerMoshikomiSogisha.BankBranchName__c != null) updateObo.BankBranchName__c = partnerMoshikomiSogisha.BankBranchName__c ; //銀行支店名
            if(partnerMoshikomiSogisha.BankAccountType__c != null) updateObo.BankAccountType__c = partnerMoshikomiSogisha.BankAccountType__c ; //口座種別
            if(partnerMoshikomiSogisha.BankAccountNo__c != null) updateObo.BankAccountNo__c = partnerMoshikomiSogisha.BankAccountNo__c ; //口座番号
            if(partnerMoshikomiSogisha.BankAccountMeigi__c != null) updateObo.BankAccountMeigi__c = partnerMoshikomiSogisha.BankAccountMeigi__c ; //口座名義
            if(partnerMoshikomiSogisha.Kaimyojuyonomiirai__c != null) updateObo.Kaimyojuyonomiirai__c = partnerMoshikomiSogisha.Kaimyojuyonomiirai__c ; //戒名授与のみ依頼
            if(partnerMoshikomiSogisha.SyuzaiTaiouKahiKubun__c != null) updateObo.SyuzaiTaiouKahiKubun__c = partnerMoshikomiSogisha.SyuzaiTaiouKahiKubun__c ; //取材対応区分
            if(partnerMoshikomiSogisha.Somei__c != null) updateObo.Soumei__c = partnerMoshikomiSogisha.Somei__c ; //僧名
            if(partnerMoshikomiSogisha.JizenanketoSomeidenotorokuwokibo__c != null) updateObo.SomeiTorokuKibo__c = changeBoolean(partnerMoshikomiSogisha.JizenanketoSomeidenotorokuwokibo__c) ; //僧名での登録を希望
            if(partnerMoshikomiSogisha.JizenanketoTashaservicetoroku__c != null) updateObo.TashaServiceToroku__c = partnerMoshikomiSogisha.JizenanketoTashaservicetoroku__c ; //他社サービス登録
            if(partnerMoshikomiSogisha.JizenanketoTashaservicetorokumei__c != null) updateObo.TashaServiceTorokumei__c = partnerMoshikomiSogisha.JizenanketoTashaservicetorokumei__c ; //他社サービス登録名
            if(partnerMoshikomiSogisha.moshikomisha_sosekishuhakeito__c != null) updateObo.JiinSyusi__c = partnerMoshikomiSogisha.moshikomisha_sosekishuhakeito__c ; // 僧籍宗派系統

            //パートナー契約更新
            if(keiyaku != null){
                if(partnerMoshikomiSogisha.KaimyojuyoIraiYosodan__c != null) keiyaku.KaimyojuyoIraiYosodan__c = partnerMoshikomiSogisha.KaimyojuyoIraiYosodan__c ; // 戒名授与のみ依頼要相談
                if(partnerMoshikomiSogisha.IdoSyudan__c != null) keiyaku.IdoSyudan__c = partnerMoshikomiSogisha.IdoSyudan__c ; // 移動手段
                if(partnerMoshikomiSogisha.JizenanketoIdoshudanSonota__c != null) keiyaku.IdoSyudanSonota__c = partnerMoshikomiSogisha.JizenanketoIdoshudanSonota__c ; // 移動手段その他
                if(partnerMoshikomiSogisha.Iraisyosofuhouhou__c != null) keiyaku.Iraisyosofuhouhou__c = partnerMoshikomiSogisha.Iraisyosofuhouhou__c ; // 依頼書送付方法
                if(partnerMoshikomiSogisha.ToubaTaioKahiKubun__c != null) keiyaku.ToubaTaioKahiKubun__c = partnerMoshikomiSogisha.ToubaTaioKahiKubun__c ; // 塔婆対応可否区分
                if(partnerMoshikomiSogisha.TobaTaioYosodan__c != null) keiyaku.TobaTaioYosodan__c = partnerMoshikomiSogisha.TobaTaioYosodan__c ; // 塔婆対応要相談
                if(partnerMoshikomiSogisha.TobaTaioKingakuFrom__c != null) keiyaku.TobaTaioKingakuFrom__c = decimal.valueOf(partnerMoshikomiSogisha.TobaTaioKingakuFrom__c) ; // 塔婆対応金額
                if(partnerMoshikomiSogisha.TobaTaioKingakuTo__c != null) keiyaku.TobaTaioKingakuTo__c = decimal.valueOf(partnerMoshikomiSogisha.TobaTaioKingakuTo__c) ; // 塔婆対応金額
                if(partnerMoshikomiSogisha.KakoTyoKinyuTaiouKahiKubun__c != null) keiyaku.KakoTyoKinyuTaiouKahiKubun__c = partnerMoshikomiSogisha.KakoTyoKinyuTaiouKahiKubun__c ; // 過去帳記入対応可否区分
                if(partnerMoshikomiSogisha.KakochoKinyuYosodan__c != null) keiyaku.KakochoKinyuYosodan__c = partnerMoshikomiSogisha.KakochoKinyuYosodan__c ; // 過去帳記入要相談
                if(partnerMoshikomiSogisha.KakochoKinyuKingakuFrom__c != null) keiyaku.KakochoKinyuKingakuFrom__c = decimal.valueOf(partnerMoshikomiSogisha.KakochoKinyuKingakuFrom__c) ; // 過去帳記入金額
                if(partnerMoshikomiSogisha.KakochoKinyuKingakuTo__c != null) keiyaku.KakochoKinyuKingakuTo__c = decimal.valueOf(partnerMoshikomiSogisha.KakochoKinyuKingakuTo__c) ; // 過去帳記入金額
                if(partnerMoshikomiSogisha.JiinDenoHoyoKa__c != null) keiyaku.JiinDenoHoyoKa__c = partnerMoshikomiSogisha.JiinDenoHoyoKa__c ; // 寺院での法要可
                if(partnerMoshikomiSogisha.SyuyoNinzu__c != null) keiyaku.SyuyoNinzu__c = decimal.valueOf(partnerMoshikomiSogisha.SyuyoNinzu__c) ; // 収容人数
                if(partnerMoshikomiSogisha.CyusyaJoUmu__c != null) keiyaku.CyusyaJoUmu__c = partnerMoshikomiSogisha.CyusyaJoUmu__c ; // 駐車場有無
                if(partnerMoshikomiSogisha.CyusyaKanouDaisu__c != null) keiyaku.CyusyaKanouDaisu__c = decimal.valueOf(partnerMoshikomiSogisha.CyusyaKanouDaisu__c) ; // 駐車可能台数
                if(partnerMoshikomiSogisha.JiindenohoyoYosodan__c != null) keiyaku.JiinDenoHoyoYosodan__c = partnerMoshikomiSogisha.JiindenohoyoYosodan__c ; // 寺院での法要要相談
                update keiyaku;
            }

            //所属寺院更新
            if(String.isNotBlank(shozokuSangouSangoJiin.Id)){
                if(partnerMoshikomiSogisha.JiinJiinshuha__c != null) updateObo.JiinSyuha__c = partnerMoshikomiSogisha.JiinJiinshuha__c ; //宗派
                if(partnerMoshikomiSogisha.JiinJiinshuhaSonotaKana__c != null) updateObo.JiinShuhaSonotaKana__c = partnerMoshikomiSogisha.JiinJiinshuhaSonotaKana__c ; //宗派その他(カナ)
                if(partnerMoshikomiSogisha.JiinJiinshuhaSonota__c != null) updateObo.JiinShushaSonota__c = partnerMoshikomiSogisha.JiinJiinshuhaSonota__c ; //宗派その他
                
                if(partnerMoshikomiSogisha.KatudojiinJiinName__c != null) shozokuSangouSangoJiin.Name = partnerMoshikomiSogisha.KatudojiinJiinName__c ; // 所属寺院名
                if(partnerMoshikomiSogisha.ShozokuJiinShuhaKeito__c != null) shozokuSangouSangoJiin.JiinSyuha__c = partnerMoshikomiSogisha.ShozokuJiinShuhaKeito__c ; // 所属寺院宗派系統
                if(partnerMoshikomiSogisha.Jiinsekininshasei__c != null) shozokuSangouSangoJiin.JushokushaSei__c = partnerMoshikomiSogisha.Jiinsekininshasei__c ; // 姓
                if(partnerMoshikomiSogisha.Jiinsekininshamei__c != null) shozokuSangouSangoJiin.JushokushaMei__c = partnerMoshikomiSogisha.Jiinsekininshamei__c ; // 名
                
                if(partnerMoshikomiSogisha.KatudojiinJiinjushoPostalcode__c != null) shozokuSangouSangoJiin.BillingPostalCode = partnerMoshikomiSogisha.KatudojiinJiinjushoPostalcode__c ; // 住所(請求先)(郵便番号)
                if(partnerMoshikomiSogisha.KatudojiinJiinjushoState__c != null) shozokuSangouSangoJiin.BillingState = partnerMoshikomiSogisha.KatudojiinJiinjushoState__c ; // 住所(請求先)(都道府県)
                if(partnerMoshikomiSogisha.KatudojiinJiinjushoCity__c != null) shozokuSangouSangoJiin.BillingCity = partnerMoshikomiSogisha.KatudojiinJiinjushoCity__c ; // 住所(請求先)(市区郡)
                if(partnerMoshikomiSogisha.KatudojiinJiinjushoStreet__c != null) shozokuSangouSangoJiin.BillingStreet = partnerMoshikomiSogisha.KatudojiinJiinjushoStreet__c ; // 住所(請求先)(町名・番地)
                if(partnerMoshikomiSogisha.JiinTel__c != null) shozokuSangouSangoJiin.Phone = partnerMoshikomiSogisha.JiinTel__c ; // 電話1
                if(partnerMoshikomiSogisha.JiinFax__c != null) shozokuSangouSangoJiin.Fax = partnerMoshikomiSogisha.JiinFax__c ; // Fax
                if(partnerMoshikomiSogisha.JiinsekininshaseiKana__c != null) shozokuSangouSangoJiin.JushokushaSeiKana__c = partnerMoshikomiSogisha.JiinsekininshaseiKana__c ; // 姓（カナ）
                if(partnerMoshikomiSogisha.JiinsekininshameiKana__c != null) shozokuSangouSangoJiin.JushokushaMeiKana__c = partnerMoshikomiSogisha.JiinsekininshameiKana__c ; // 名（カナ）
                if(partnerMoshikomiSogisha.JiinHpurl__c != null) shozokuSangouSangoJiin.Website = partnerMoshikomiSogisha.JiinHpurl__c ; // Web サイト
                if(partnerMoshikomiSogisha.JiinTanisyubetsu__c != null) shozokuSangouSangoJiin.HoujinTanniKubun__c = partnerMoshikomiSogisha.JiinTanisyubetsu__c ; // 宗教法人単位種別
                if(partnerMoshikomiSogisha.JiinHojintoki__c != null) shozokuSangouSangoJiin.HoujinKakuAri__c = partnerMoshikomiSogisha.JiinHojintoki__c ; // 宗教法人格有
                update shozokuSangouSangoJiin;
            }

            //在籍寺院更新
            if(String.isNotBlank(zaisekiSaki.Id)){
                if(partnerMoshikomiSogisha.JiinjohoZaisekijiinmeiKana__c != null) zaisekiSaki.SangoJiinMeiFurigana__c = partnerMoshikomiSogisha.JiinjohoZaisekijiinmeiKana__c ; // 山号寺院名（カナ）
                if(partnerMoshikomiSogisha.JiinjohoZaisekijiinmei__c != null) zaisekiSaki.Name = partnerMoshikomiSogisha.JiinjohoZaisekijiinmei__c ; // お客様・提携先名
                if(partnerMoshikomiSogisha.JiinjohoZaisekijiinjushoPostalcode__c != null) zaisekiSaki.BillingPostalCode = partnerMoshikomiSogisha.JiinjohoZaisekijiinjushoPostalcode__c ; // 住所(請求先)(郵便番号)
                if(partnerMoshikomiSogisha.JiinjohoZaisekijiinjushoState__c != null) zaisekiSaki.BillingState = partnerMoshikomiSogisha.JiinjohoZaisekijiinjushoState__c ; // 住所(請求先)(都道府県)
                if(partnerMoshikomiSogisha.JiinjohoZaisekijiinjushoCity__c != null) zaisekiSaki.BillingCity = partnerMoshikomiSogisha.JiinjohoZaisekijiinjushoCity__c ; // 住所(請求先)(市区郡)
                if(partnerMoshikomiSogisha.JiinjohoZaisekijiinjushoStreet__c != null) zaisekiSaki.BillingStreet = partnerMoshikomiSogisha.JiinjohoZaisekijiinjushoStreet__c ; // 住所(請求先)(町名・番地)
                if(partnerMoshikomiSogisha.JiinjohoZaisekijiintel__c != null) zaisekiSaki.Phone = partnerMoshikomiSogisha.JiinjohoZaisekijiintel__c ; // 電話1
                if(partnerMoshikomiSogisha.JiinjohoZaisekijiinfax__c != null) zaisekiSaki.Fax = partnerMoshikomiSogisha.JiinjohoZaisekijiinfax__c ; // Fax
                update zaisekiSaki;
            }

            Database.DMLOptions dml = new Database.DMLOptions();
            dml.DuplicateRuleHeader.AllowSave = true;
            Database.SaveResult sr = Database.update(updateObo, dml);

            partnerMoshikomiSogisha.OkyakusamaTeikeisaki__c = souryouId;
            update partnerMoshikomiSogisha;
        }
        catch(Exception e){
            Database.rollback(sp);
            System.debug('e.getMessage():' + e.getMessage());
            System.debug('e.getLineNumber():' + e.getLineNumber());
            System.debug('e.getStackTraceString():' + e.getStackTraceString());
            res = new ResponseDto(false, 'システムエラーが発生しました：' + e.getMessage());
        }

        return res;
    }


    /**
     * 助法者更新
     */
    @AuraEnabled
    public static ResponseDto auraUpdateJohosha(String partnerMoshikomiJohoshaId, String JohoshaId) {
        ResponseDto res = new ResponseDto(true, '');

        Savepoint sp = Database.setSavepoint();

        try{
            PartnerMoshikomi_Johosha__c partnerMoshikomiJohosha = PartnerMoshikomi_JohoshaDaos.GetInstance().SelectById(partnerMoshikomiJohoshaId);
            Account johosha = null;
            for(Account aAcc : [Select Id, ZaisekiSaki__c,
                                    (Select Id From KeiyakusTeikeisaki__r WHERE KeiyakuJokyo__c = '契約中' limit 1) 
                                    From Account WHERE Id = :JohoshaId limit 1]) {
                johosha = aAcc;
            }
            if(johosha == null) {
                res = new ResponseDto(false, '助法者が見つかりません！' + JohoshaId);
                return res;
            }

            Account zaisekiSaki = new Account(Id=johosha.ZaisekiSaki__c);
            Keiyaku__c keiyaku = null;
            if(johosha.KeiyakusTeikeisaki__r != null && johosha.KeiyakusTeikeisaki__r.size() > 0) keiyaku = johosha.KeiyakusTeikeisaki__r[0];

            if(partnerMoshikomiJohosha.LastNameFurigana__c != null) johosha.SeiKana__c = partnerMoshikomiJohosha.LastNameFurigana__c ; // 助法者姓(カナ)
            if(partnerMoshikomiJohosha.FirstNameFurigana__c != null) johosha.MeiKana__c = partnerMoshikomiJohosha.FirstNameFurigana__c ; // 助法者名(カナ)
            if(partnerMoshikomiJohosha.LastName__c != null || partnerMoshikomiJohosha.FirstName__c != null ) 
                johosha.Name = str(partnerMoshikomiJohosha.LastName__c) + ' ' + str(partnerMoshikomiJohosha.FirstName__c) ; //姓名
            //if(partnerMoshikomiJohosha.LastName__c != null) johosha.LastName = str(partnerMoshikomiJohosha.LastName__c);
            //if(partnerMoshikomiJohosha.FirstName__c != null) johosha.FirstName = str(partnerMoshikomiJohosha.FirstName__c);
            if(partnerMoshikomiJohosha.Gender__c != null) johosha.Seibetsu__c = partnerMoshikomiJohosha.Gender__c ; // 性別
            if(partnerMoshikomiJohosha.JohoshaKyojuchiPostalcode__c != null) johosha.BillingPostalCode = partnerMoshikomiJohosha.JohoshaKyojuchiPostalcode__c ; // 居住地(郵便番号)
            if(partnerMoshikomiJohosha.JohoshaKyojuchiState__c != null) johosha.BillingState = partnerMoshikomiJohosha.JohoshaKyojuchiState__c ; // 居住地(都道府県)
            if(partnerMoshikomiJohosha.JohoshaKyojuchiCity__c != null) johosha.BillingCity = partnerMoshikomiJohosha.JohoshaKyojuchiCity__c ; // 居住地(市区郡)
            if(partnerMoshikomiJohosha.JohoshaKyojuchiStreet__c != null) johosha.BillingStreet = partnerMoshikomiJohosha.JohoshaKyojuchiStreet__c ; // 居住地(町名・番地)
            if(partnerMoshikomiJohosha.JohoshaTel__c != null) johosha.Phone = partnerMoshikomiJohosha.JohoshaTel__c ; // TEL
            if(partnerMoshikomiJohosha.Fax__c != null) johosha.Fax = partnerMoshikomiJohosha.Fax__c ; // FAX
            if(partnerMoshikomiJohosha.MobilePhone__c != null) johosha.MobilePhone__c = partnerMoshikomiJohosha.MobilePhone__c ; // MOBILE
            if(partnerMoshikomiJohosha.HomutaiokanoArea__c != null) johosha.HomutaiokanoArea__c = partnerMoshikomiJohosha.HomutaiokanoArea__c ; // 対応可能エリア
            if(partnerMoshikomiJohosha.PersonBirthdate__c != null) johosha.Seinengappi__c = Date.valueOf(partnerMoshikomiJohosha.PersonBirthdate__c) ; // 生年月日
            // if(partnerMoshikomiJohosha.HoninKakuninSyoruiSyubetsu__c != null) johosha.HonninKakuninSyoruiSyubetsu__c = partnerMoshikomiJohosha.HoninKakuninSyoruiSyubetsu__c ; // 本人確認書類
            if(partnerMoshikomiJohosha.MailAddress__c != null) johosha.MailAddress__c = partnerMoshikomiJohosha.MailAddress__c ; // E-Mail
            if(partnerMoshikomiJohosha.johoshajiin_sosekishuhakeito__c != null && partnerMoshikomiJohosha.johoshajiin_sosekishuhakeito__c != 'その他') johosha.JiinSyusi__c = partnerMoshikomiJohosha.johoshajiin_sosekishuhakeito__c ; // 僧籍宗派系統
            if(partnerMoshikomiJohosha.Syuha__c != null) johosha.JiinSyuha__c = partnerMoshikomiJohosha.Syuha__c ; // 僧籍宗派
            if(partnerMoshikomiJohosha.JiinShuhaSonotaKana__c != null) johosha.JiinShuhaSonotaKana__c = partnerMoshikomiJohosha.JiinShuhaSonotaKana__c ; // 僧籍宗派(カナ)
            if(partnerMoshikomiJohosha.JiinShushaSonota__c != null) johosha.JiinShushaSonota__c = partnerMoshikomiJohosha.JiinShushaSonota__c ; // 僧籍宗派その他
            

            if(String.isNotBlank(zaisekiSaki.Id)){
                if(partnerMoshikomiJohosha.SangoJiinMeiFurigana__c != null) zaisekiSaki.SangoJiinMeiFurigana__c = partnerMoshikomiJohosha.SangoJiinMeiFurigana__c ; // 在籍寺院名(カナ)
                if(partnerMoshikomiJohosha.TeikeisakiName__c != null) zaisekiSaki.Name = partnerMoshikomiJohosha.TeikeisakiName__c ; // 在籍寺院名
                if(partnerMoshikomiJohosha.JiinZaisekijiinjushoPostalcode__c != null) zaisekiSaki.BillingPostalCode = partnerMoshikomiJohosha.JiinZaisekijiinjushoPostalcode__c ; // 在籍寺院住所(郵便番号)
                if(partnerMoshikomiJohosha.JiinZaisekijiinjushoState__c != null) zaisekiSaki.BillingState = partnerMoshikomiJohosha.JiinZaisekijiinjushoState__c ; // 在籍寺院住所(都道府県)
                if(partnerMoshikomiJohosha.JiinZaisekijiinjushoCity__c != null) zaisekiSaki.BillingCity = partnerMoshikomiJohosha.JiinZaisekijiinjushoCity__c ; // 在籍寺院住所(市区郡)
                if(partnerMoshikomiJohosha.JiinZaisekijiinjushoStreet__c != null) zaisekiSaki.BillingStreet = partnerMoshikomiJohosha.JiinZaisekijiinjushoStreet__c ; // 在籍寺院住所(町名・番地)
                if(partnerMoshikomiJohosha.JohoshajiinTel__c != null) zaisekiSaki.Phone = partnerMoshikomiJohosha.JohoshajiinTel__c ; // 電話1
                if(partnerMoshikomiJohosha.JohoshajiinFax__c != null) zaisekiSaki.Fax = partnerMoshikomiJohosha.JohoshajiinFax__c ; // Fax

                update zaisekiSaki;
            }

            update johosha;
            partnerMoshikomiJohosha.OkyakusamaTeikeisakiRef__c = JohoshaId;
            update partnerMoshikomiJohosha;

        }
        catch(Exception e){
            Database.rollback(sp);
            System.debug('e.getMessage():' + e.getMessage());
            System.debug('e.getStackTraceString():' + e.getStackTraceString());
            res = new ResponseDto(false, 'システムエラーが発生しました：' + e.getMessage());
        }

        return res;
    }


    public static String str(String str){
        if(String.isBlank(str)){
            return '';
        }
        else{
            return str;
        }
    }

    public static Boolean changeBoolean(String str){
        if(str == '1'){
            return true;
        }
        else{
            return false;
        }
    }

    public class ResponseDto {
        @AuraEnabled public Boolean isSuccess { get; set; }
        @AuraEnabled public String message { get; set; }
        @AuraEnabled public Map<Object, Object> values { get; set; }
        public ResponseDto(Boolean isSuccess, String msg){
            this.isSuccess = isSuccess;
            this.message = msg;
            this.values = new Map<Object, Object>();
        }
    }
}