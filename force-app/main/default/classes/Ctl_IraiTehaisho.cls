public class Ctl_IraiTehaisho {

    public String iraiTehaishoId{get;set;}
    String shodanId;


    public Ctl_IraiTehaisho(ApexPages.StandardController controller){
       shodanId = controller.getId();
    }

    private class CreateIraiTehaishoResult{
        public Opportunity opp = null;
        public Obosanbin__c obosanbin = null;
        public IraiTehaisho__c iraiTehaisho = null;
    }
    private CreateIraiTehaishoResult createIraiTehaisho(Id pShodanId){
        Opportunity theOpportunity = this.selectOpp(pShodanId);
        Obosanbin__c theObosanbin = this.selectObosanbinById(theOpportunity.ObosanbinRef__c);
        IraiTehaisho__c theIraiTehaisho = putValueIraiTehaisho(theOpportunity, theObosanbin);
        CreateIraiTehaishoResult theResult = new CreateIraiTehaishoResult();
        theResult.opp = theOpportunity;
        theResult.obosanbin = theObosanbin;
        theResult.iraiTehaisho = theIraiTehaisho;
        return theResult;
    }

    public PageReference createSoukyakusyo(){
        CreateIraiTehaishoResult theResult = this.createIraiTehaisho( this.shodanId );
        Insert theResult.iraiTehaisho;
        this.iraiTehaishoId = theResult.iraiTehaisho.Id;
        return null;
    }
    public PageReference createAmazonHoyo(){
        CreateIraiTehaishoResult theResult = this.createIraiTehaisho( this.shodanId );

        String theTicketShubetsu = 'Amazonチケット'; Date theSoufuDate = Date.today(); Date theYukoKigen = Date.today().addDays(90);
        this.updateTicketDate( theResult.obosanbin.Id, theTicketShubetsu, theSoufuDate, theYukoKigen );

        theResult.iraiTehaisho.TicketSendingDate__c = theSoufuDate;
        theResult.iraiTehaisho.TicketExpirationDate__c = theYukoKigen;
        Insert theResult.iraiTehaisho;
        this.iraiTehaishoId = theResult.iraiTehaisho.Id;
        return null;
    }
    public PageReference createAmazonKaimyo(){
        CreateIraiTehaishoResult theResult = this.createIraiTehaisho( this.shodanId );

        String theTicketShubetsu = 'Amazonチケット'; Date theSoufuDate = Date.today(); Date theYukoKigen = Date.today().addDays(30);
        this.updateTicketDate( theResult.obosanbin.Id, theTicketShubetsu, theSoufuDate, theYukoKigen );

        theResult.iraiTehaisho.TicketSendingDate__c = theSoufuDate;
        theResult.iraiTehaisho.TicketExpirationDate__c = theYukoKigen;
        Insert theResult.iraiTehaisho;
        this.iraiTehaishoId = theResult.iraiTehaisho.Id;
        return null;
    }
    public PageReference createYahooHoyo(){
        CreateIraiTehaishoResult theResult = this.createIraiTehaisho( this.shodanId );

        String theTicketShubetsu = 'Yahooチケット'; Date theSoufuDate = Date.today(); Date theYukoKigen = Date.today().addDays(90);
        this.updateTicketDate( theResult.obosanbin.Id, theTicketShubetsu, theSoufuDate, theYukoKigen );

        theResult.iraiTehaisho.TicketSendingDate__c = theSoufuDate;
        theResult.iraiTehaisho.TicketExpirationDate__c = theYukoKigen;
        Insert theResult.iraiTehaisho;
        this.iraiTehaishoId = theResult.iraiTehaisho.Id;
        return null;
    }
    public PageReference createYahooKaimyo(){
        CreateIraiTehaishoResult theResult = this.createIraiTehaisho( this.shodanId );

        String theTicketShubetsu = 'Yahooチケット'; Date theSoufuDate = Date.today(); Date theYukoKigen = Date.today().addDays(30);
        this.updateTicketDate( theResult.obosanbin.Id, theTicketShubetsu, theSoufuDate, theYukoKigen );

        theResult.iraiTehaisho.TicketSendingDate__c = theSoufuDate;
        theResult.iraiTehaisho.TicketExpirationDate__c = theYukoKigen;
        Insert theResult.iraiTehaisho;
        this.iraiTehaishoId = theResult.iraiTehaisho.Id;
        return null;
    }
    public PageReference createYoyakuTicket(){
        CreateIraiTehaishoResult theResult = this.createIraiTehaisho( this.shodanId );

        String theTicketShubetsu = 'お坊さん便チケット'; Date theSoufuDate = Date.today(); Date theYukoKigen = Date.today().addYears(2);
        this.updateTicketDate( theResult.obosanbin.Id, theTicketShubetsu, theSoufuDate, theYukoKigen );

        theResult.iraiTehaisho.TicketSendingDate__c = theSoufuDate;
        theResult.iraiTehaisho.TicketExpirationDate__c = theYukoKigen;
        Insert theResult.iraiTehaisho;
        this.iraiTehaishoId = theResult.iraiTehaisho.Id;
        return null;
    }

    private void updateTicketDate(Id pObosanbinId, String pTicketShubetsu, Date pTicketSendingDate, Date pTicketExpirationDate){
        Update new Obosanbin__c(
            Id = pObosanbinId,
            TicketShubetsu__c = pTicketShubetsu,
            TicketSendingDate__c = pTicketSendingDate,
            TicketExpirationDate__c = pTicketExpirationDate
        );
    }

    
    private IraiTehaisho__c putValueIraiTehaisho(Opportunity pOpp, Obosanbin__c anObosanbin){

        IraiTehaisho__c insertIraiTehaisho = new IraiTehaisho__c();

        insertIraiTehaisho.UriageDate__c = pOpp.Utiagebi__c;


        // 喪主情報
        if(String.isNotBlank(anObosanbin.MoshuRef__c)){

            insertIraiTehaisho.MoshuPostalCode__c                = anObosanbin.MoshuRef__r.BillingPostalCode;
            insertIraiTehaisho.MoshuState__c                     = anObosanbin.MoshuRef__r.BillingState;
            insertIraiTehaisho.MoshuCity__c                      = anObosanbin.MoshuRef__r.BillingCity;
            insertIraiTehaisho.MoshuStreet__c                    = anObosanbin.MoshuRef__r.BillingStreet;
            insertIraiTehaisho.MoshuKeitai__c                    = anObosanbin.MoshuRef__r.MobilePhone__c;
            insertIraiTehaisho.MoshuPhone__c                     = anObosanbin.MoshuRef__r.Phone;
            insertIraiTehaisho.MoshuName__c                      = anObosanbin.MoshuRef__r.LastName + ' ' + anObosanbin.MoshuRef__r.FirstName;
        }

        // 対象者情報
        if(String.isNotBlank(anObosanbin.Taishosha1Ref__c)){

            insertIraiTehaisho.TaishoshaFurigana__c              = anObosanbin.Taishosha1Furigana__c;
            insertIraiTehaisho.TaishoshaName__c                  = anObosanbin.Taishosha1Ref__r.LastName + ' ' + anObosanbin.Taishosha1Ref__r.FirstName;
            insertIraiTehaisho.TaishoshaGender__c                = anObosanbin.Taishosha1Gender__c;
            insertIraiTehaisho.TaishoshaSeinengappi__c           = anObosanbin.Taishosha1Ref__r.SeinengappiWareki__c;
            insertIraiTehaisho.TaishoshaAge__c                   = anObosanbin.Taishosha1Ref__r.Age__pc;
            insertIraiTehaisho.TaishoshaBotsunengappi__c         = anObosanbin.Taishosha1Ref__r.BotsunengappiWareki__c;
            insertIraiTehaisho.TaishoshaShuha__c                 = anObosanbin.Taishosha1Ref__r.Syuha__c;
            insertIraiTehaisho.TaishoshaShuhaSonotanoSyukyoSyuha__c = anObosanbin.Taishosha1Ref__r.SonotanoSyukyoSyuha__c;
            //没西暦が登録されていないものがあるため、和暦から西暦を計算する
            insertIraiTehaisho.TaishoshaBotsuDate__c = JpCalendar.convertWarekiToSeireki(anObosanbin.Taishosha1Ref__r.BotsunengappiWareki__c);
        }

        //相談者名
        insertIraiTehaisho.SodanshaName__c = pOpp.Account.LastName + ' ' + pOpp.Account.FirstName;
        insertIraiTehaisho.SodanshaFurigana__c = pOpp.Account.NameFurigana__c;

        {//相談者/住所
            insertIraiTehaisho.SodanshaPostalCode__c = pOpp.Account.BillingPostalCode;
            insertIraiTehaisho.SodanshaState__c = pOpp.Account.BillingState;
            insertIraiTehaisho.SodanshaCity__c = pOpp.Account.BillingCity;
            insertIraiTehaisho.SodanshaStreet__c = pOpp.Account.BillingStreet;
        }

        {//資料送付先/宛名
            insertIraiTehaisho.SofujoAtena__c = 
                String.isBlank(pOpp.ShiryoSoufuSakiAtena__c)
                ? pOpp.Account.LastName + ' ' + pOpp.Account.FirstName
                : pOpp.ShiryoSoufuSakiAtena__c;
        }
        {//資料送付先/住所
            Boolean toUseSiryoSofuAddr = 
                !String.isBlank(pOpp.ShiryoSoufuSakiPostalCode__c)
                && !String.isBlank(pOpp.ShiryoSoufuSakiState__c)
                && !String.isBlank(pOpp.ShiryoSoufuSakiCity__c)
                && !String.isBlank(pOpp.ShiryoSoufuSakiStreet__c)
                ;

            if(toUseSiryoSofuAddr){
                insertIraiTehaisho.SofujoAddrZipCode__c = pOpp.ShiryoSoufuSakiPostalCode__c;
                insertIraiTehaisho.SofujoAddrState__c = pOpp.ShiryoSoufuSakiState__c;
                insertIraiTehaisho.SofujoAddrCity__c = pOpp.ShiryoSoufuSakiCity__c;
                insertIraiTehaisho.SofujoAddrStreet__c = pOpp.ShiryoSoufuSakiStreet__c;
            }else{
                insertIraiTehaisho.SofujoAddrZipCode__c = pOpp.Account.BillingPostalCode;
                insertIraiTehaisho.SofujoAddrState__c = pOpp.Account.BillingState;
                insertIraiTehaisho.SofujoAddrCity__c = pOpp.Account.BillingCity;
                insertIraiTehaisho.SofujoAddrStreet__c = pOpp.Account.BillingStreet;
            }
        }

        insertIraiTehaisho.SodanshaKeitai__c                     = pOpp.Account.MobilePhone__c;
        insertIraiTehaisho.SodanshaPhone__c                      = pOpp.Account.Phone;
        insertIraiTehaisho.SodanshaFax__c = pOpp.Account.Fax;

        insertIraiTehaisho.MemorialServicePlan__c                = anObosanbin.MemorialServicePlan__c;
        insertIraiTehaisho.BuddOthr__c                           = anObosanbin.BuddOthr__c;
        insertIraiTehaisho.TicketSendingDate__c                  = anObosanbin.TicketSendingDate__c;
        insertIraiTehaisho.TicketExpirationDate__c               = anObosanbin.TicketExpirationDate__c;
        insertIraiTehaisho.IraishoKisaiJiko__c                   = anObosanbin.IraishoKisaiJiko__c;
        insertIraiTehaisho.Kasoba__c                             = anObosanbin.Kasoba__c;
        insertIraiTehaisho.KasoDateTime_Inp__c                   = anObosanbin.KasoDateTime_Inp__c;
        insertIraiTehaisho.Kaimyo__c                             = anObosanbin.Kaimyo__c;
        insertIraiTehaisho.KokubetsushikiNichiji__c              = anObosanbin.KokubetsushikiNichiji__c;
        insertIraiTehaisho.KokubetsuDateTime_Inp__c              = anObosanbin.KokubetsuDateTime_Inp__c;
        insertIraiTehaisho.FinalDecisionTotalAmount__c =
            (pOpp.RyunyumotoService__c == '定額僧侶手配代行')
            ? anObosanbin.TeiHehOfuseKingaku__c
            : pOpp.Amount;

        insertIraiTehaisho.Saijo__c                              = anObosanbin.Saijo__c;
        insertIraiTehaisho.SaijoAddress__c                       = getNotNullStr(anObosanbin.sogi_todofuken__c) + getNotNullStr(anObosanbin.sogi_shikugun__c) + getNotNullStr(anObosanbin.sogi_tyoumei__c) + getNotNullStr(anObosanbin.sogi_banchi__c);
        insertIraiTehaisho.SaijoPhone__c                         = anObosanbin.SaijoPhone__c;

        // 法要場所、追加法要場所
        insertIraiTehaisho.HoyoBasho1Name__c = anObosanbin.HoyoBashoMei__c;
        insertIraiTehaisho.HoyoBasho1Addr__c =  getNotNullStr(anObosanbin.hoyo_todofuken__c) + getNotNullStr(anObosanbin.hoyo_shikugun__c) + getNotNullStr(anObosanbin.hoyo_tyoumei__c) + getNotNullStr(anObosanbin.hoyo_banchi__c);

        insertIraiTehaisho.HoyoBasho2Name__c = anObosanbin.TsuikahoyobashoMei__c;
        insertIraiTehaisho.HoyoBasho2Addr__c =  getNotNullStr(anObosanbin.tuika_todofuken__c) + getNotNullStr(anObosanbin.tuika_shikugun__c) + getNotNullStr(anObosanbin.tuika_tyoumei__c) + getNotNullStr(anObosanbin.tuika_banchi__c);


        insertIraiTehaisho.ShiryoSofubi__c                       = anObosanbin.ShiryoSofubi__c;
        insertIraiTehaisho.Tehai__c                              = anObosanbin.ObosanbinKeiyakuMadoguchi__r.ObousanBinTehaiKubun__c;
        insertIraiTehaisho.TehaishoKisaiJikoTA__c                  = anObosanbin.TehaishoKisaiJiko__c;
        insertIraiTehaisho.ShukkanDateTimei_Inp__c               = anObosanbin.ShukkanDateTimei_Inp__c;
        insertIraiTehaisho.Shonanoka__c                          = anObosanbin.Shonanoka__c;
        insertIraiTehaisho.ShodanBango__c                        = pOpp.ShodanBangoF__c;
        insertIraiTehaisho.MoshuFurigana__c                      = anObosanbin.MoshuFurigana__c;
        insertIraiTehaisho.KakuteibiSyodan__c                    = pOpp.KakuteibiSyodan__c;


        String sogishaName;
        if(anObosanbin.Sogisha__c != null ){
            sogishaName = anObosanbin.Sogisha__r.Name;
        } else {
            sogishaName = anObosanbin.SonotaSogisha__c;
        }
        insertIraiTehaisho.Sogisha__c = sogishaName;

        insertIraiTehaisho.SogiTantosha__c                       = anObosanbin.SogiTantosha__c;
        insertIraiTehaisho.SogiTantoshaTel__c                    = anObosanbin.SogiTantoshaTel__c;
        insertIraiTehaisho.SogiTantoshaFax__c                    = anObosanbin.SogiTantoshaFax__c;
        insertIraiTehaisho.ZokugaraMoshuNitottenoTaishosha__c    = anObosanbin.ZokugaraMoshuNitottenoTaishosha1__c;
        insertIraiTehaisho.ZokugaraSodanshaNitottenoTaishosha__c = anObosanbin.ZokugaraSodanshaNitottenoTaishosha1__c;
        insertIraiTehaisho.StageName__c                          = pOpp.StageName;
        //insertIraiTehaisho.SekoTantoSoryoSoryoRenrakusaki__c     = anObosanbin.SekoTantoSoryoSoryoRenrakusaki__c;
        insertIraiTehaisho.TsuyaDateTime_Inp__c                  = anObosanbin.TsuyaDateTime_Inp__c;
        insertIraiTehaisho.NyukinShimeDay__c                     = anObosanbin.NyukinShimeDay__c;
        insertIraiTehaisho.NyukinDay__c                          = anObosanbin.NyukinDay__c;
        insertIraiTehaisho.Iriguchi__c                           = anObosanbin.Iriguchi__c;
        insertIraiTehaisho.BodaijinoUmu__c                       = anObosanbin.BodaijinoUmu__c;
        insertIraiTehaisho.MemorialContent__c                    = anObosanbin.MemorialContent__c;
        insertIraiTehaisho.Makurakyo__c                          = anObosanbin.Makurakyo__c;

        if(anObosanbin.ObosanbinKeiyakuSekotanto__c != null){
            insertIraiTehaisho.SekoTantoSoryoSangoJiinShuha__c       = anObosanbin.ObosanbinKeiyakuSekotanto__r.Teikeisaki__r.ShozokuSangouSangoJiin__r.SyusiSyuhaExp__c;
            insertIraiTehaisho.SekoTantoSoryoSangoJiinMei__c         = anObosanbin.ObosanbinKeiyakuSekotanto__r.Teikeisaki__r.ShozokuSangouSangoJiin__r.Name;
            insertIraiTehaisho.SekoTantoSoryoShukyoHojinShubetsu__c  = anObosanbin.ObosanbinKeiyakuSekotanto__r.Teikeisaki__r.ShozokuSangouSangoJiin__r.HoujinTanniKubun__c;
            insertIraiTehaisho.SekoTantoSoryoSoryoKyojuchi__c        = anObosanbin.ObosanbinKeiyakuSekotanto__r.Teikeisaki__r.BillingState;
            insertIraiTehaisho.SekotantoSoryoSoryomei__c             = anObosanbin.ObosanbinKeiyakuSekotanto__r.Teikeisaki__r.Name;
            insertIraiTehaisho.SekoTantoSoryoSoryoId__c              = anObosanbin.ObosanbinKeiyakuSekotanto__r.Teikeisaki__r.TorihikisakiBangoF__c;
            //insertIraiTehaisho.SekoTantoSoryoSoryoId__c              = anObosanbin.ObosanbinKeiyakuSekotanto__r.Teikeisaki__r.YusenFaxFormula__c;
            insertIraiTehaisho.SekoTantoSoryoSoryoRenrakusaki__c     = anObosanbin.ObosanbinKeiyakuSekotanto__r.Teikeisaki__r.YusenTelNoFormula__c;
            insertIraiTehaisho.JiinNameKana__c   = getNotNullStr(anObosanbin.ObosanbinKeiyakuSekotanto__r.SyozokusangojiinmeFurigana__c);
            insertIraiTehaisho.SoryoNameKana__c   = getNotNullStr(anObosanbin.ObosanbinKeiyakuSekotanto__r.Teikeisaki__r.SeiKana__c) +
                                                    getNotNullStr(anObosanbin.ObosanbinKeiyakuSekotanto__r.Teikeisaki__r.MeiKana__c);
        } else {
            insertIraiTehaisho.SekoTantoSoryoSangoJiinShuha__c       = anObosanbin.SekoTantoSoryoShuha__c;
            insertIraiTehaisho.SekoTantoSoryoSangoJiinMei__c         = anObosanbin.SekoTantoSoryoSangoJiinMei__c;
            insertIraiTehaisho.SekoTantoSoryoShukyoHojinShubetsu__c  = anObosanbin.SekoTantoSoryoShukyoHojinShubetsu__c;
            insertIraiTehaisho.SekoTantoSoryoSoryoKyojuchi__c        = anObosanbin.SekoTantoSoryoSoryoKyojuchi__c;
            insertIraiTehaisho.SekotantoSoryoSoryomei__c             = anObosanbin.SekotantoSoryoSoryomei__c;
            insertIraiTehaisho.SekoTantoSoryoFax__c                  = anObosanbin.SekoTantoSoryoFax__c;
            insertIraiTehaisho.SekoTantoSoryoSoryoRenrakusaki__c     = anObosanbin.SekoTantoSoryoSoryoRenrakusaki__c;
            insertIraiTehaisho.JiinNameKana__c   = getNotNullStr(anObosanbin.SekoTantoSoryoSangoJiinMeiFurigana__c);
            insertIraiTehaisho.SoryoNameKana__c   = '';

        }
        insertIraiTehaisho.MadoSoryoFax__c = anObosanbin.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.Fax;

        // 施行担当(上記のif文に追加する)

        // 定額手配代行
        insertIraiTehaisho.TeiHehTesuryoSogisha__c = this.isNullZero(anObosanbin.TeiHehTesuryoSogisha__c);
        insertIraiTehaisho.SogishaBankName__c = anObosanbin.Sogisha__r.BankName__c;
        insertIraiTehaisho.SogishaBankSitenName__c = anObosanbin.Sogisha__r.BankBranchName__c;
        insertIraiTehaisho.SogishaBankKouzaShubetsu__c = anObosanbin.Sogisha__r.BankAccountType__c;
        insertIraiTehaisho.SogishaBankKouzaBango__c = anObosanbin.Sogisha__r.BankAccountNo__c;
        insertIraiTehaisho.SogishaBankKouzaMeigi__c = anObosanbin.Sogisha__r.BankAccountMeigi__c;

        insertIraiTehaisho.Tesuryo__c = 0;

        if( this.isNullZero(pOpp.PartnerSeikyuGakuExp__c) != 0 || this.isNullZero(pOpp.PartnerSiharaiGakuExp__c) != 0 ){
            insertIraiTehaisho.Tesuryo__c = 
                this.isNullZero(pOpp.PartnerSeikyuGakuExp__c) > 0
                ? this.isNullZero(pOpp.PartnerSeikyuGakuExp__c)
                : this.isNullZero(pOpp.Amount) - this.isNullZero(pOpp.PartnerSiharaiGakuExp__c);
        }


        insertIraiTehaisho.PartnerSiharaiGaku__c                 = pOpp.PartnerSiharaiGakuExp__c;

        insertIraiTehaisho.RyunyumotoService__c                  = pOpp.RyunyumotoService__c;

        if(pOpp.AccountId == anObosanbin.MoshuRef__c) insertIraiTehaisho.SodanshaMoshuMatchFlg__c = true;


        for(OkyakusamaSeikyuMeisai__c aSeikyuMeisai : pOpp.KaisyuYoteisOpportunity__r){
            insertIraiTehaisho.SeikyuHouhouLabelName__c =
                sche_Pickls.tryGetLabel(
                    'OkyakusamaSeikyuMeisai__c',
                    'SeikyuHouhou__c',
                    aSeikyuMeisai.SeikyuHouhou__c,
                    ''
                );
        }



        return insertIraiTehaisho;
    }

    private Opportunity selectOpp(String pOppId){
        return [
            SELECT Id,
            ShodanBangoF__c,
            StageName,
            Utiagebi__c,
            Amount,
            PartnerSeikyuGakuExp__c,
            PartnerSiharaiGakuExp__c,
            KakuteibiSyodan__c,
            RyunyumotoService__c,
            ShiryoSoufuSakiAtena__c,
            ShiryoSoufuSakiPostalCode__c,
            ShiryoSoufuSakiState__c,
            ShiryoSoufuSakiCity__c,
            ShiryoSoufuSakiStreet__c,
            AccountId,
            Account.LastName,
            Account.FirstName,
            Account.NameFurigana__c,
            Account.MobilePhone__c,
            Account.Phone,
            Account.Fax,
            Account.BillingPostalCode,
            Account.BillingState,
            Account.BillingCity,
            Account.BillingStreet,
            ObosanbinRef__c,
            (
                SELECT Id, SeikyuHouhou__c FROM KaisyuYoteisOpportunity__r
            )
            FROM Opportunity
            WHERE Id =:pOppId
            LIMIT 1
        ].get(0);
    }

    private Decimal isNullZero(Decimal pValue){
        if(pValue == null) return 0;
        return pValue;
    }

    private String getNotNullStr(String pStr){
        if(pStr == null) return '';
        return pStr;
    }

    private Obosanbin__c selectObosanbinById(Id pId){
        List<Obosanbin__c> theEntities = [
            SELECT
            Id,
            Name,
            Iriguchi__c,
            BodaijinoUmu__c,
            MemorialServicePlan__c,
            MemorialContent__c,
            BuddOthr__c,
            Kaimyo__c,
            SekoTantoSoryoShuha__c,
            SekoTantoSoryoSangoJiinMei__c,
            SekoTantoSoryoShukyoHojinShubetsu__c,
            SekoTantoSoryoSoryoKyojuchi__c,
            SonotaSogisha__c,
            HoyoBashoMei__c,
            HoyoBashoTEL__c,
            TsuyaDateTime_Inp__c,
            KokubetsuDateTime_Inp__c,
            KokubetsushikiNichiji__c,
            ShukkanDateTimei_Inp__c,
            KasoDateTime_Inp__c,
            Shonanoka__c,
            Saijo__c,
            Sogisha__r.Name,
            Sogisha__r.BankBranchName__c,
            Sogisha__r.BankName__c,
            Sogisha__r.BankAccountType__c,
            Sogisha__r.BankAccountNo__c,
            Sogisha__r.BankAccountMeigi__c,
            Kasoba__c,
            MoshuRef__c,
            MoshuName__c,
            MoshuFurigana__c,
            Taishosha1Ref__c,
            Taishosha1Ref__r.LastName,
            Taishosha1Ref__r.FirstName,
            Taishosha1Ref__r.SeinengappiWareki__c,
            Taishosha1Ref__r.BotsunengappiWareki__c,
            Taishosha1Ref__r.Syuha__c,
            Taishosha1Furigana__c,
            Taishosha1Ref__r.ManNenreiExp__c,
            Taishosha1Ref__r.SonotanoSyukyoSyuha__c,
            MoshuRef__r.LastName,
            MoshuRef__r.FirstName,
            MoshuRef__r.phone,
            MoshuRef__r.MobilePhone__c,
            MoshuKyojuchi__c,
            Taishosha1Age__c,
            Taishosha1Gender__c,
            ZokugaraMoshuNitottenoTaishosha1__c,
            ZokugaraSodanshaNitottenoTaishosha1__c,
            Sogisha__c,
            Sogisha__r.NameYago__c,
            SogiTantosha__c,
            SogiTantoshaTel__c,
            SogiTantoshaFax__c,
            Tehai__c,
            SekotantoSoryoSoryomei__c,
            SekoTantoSoryoSoryoRenrakusaki__c,
            NyukinDay__c,
            NyukinShimeDay__c,
            ShiryoSofubi__c,
            SekoTantoSoryoFax__c,
            TicketExpirationDate__c,
            Makurakyo__c,
            IraishoKisaiJiko__c,
            TehaishoKisaiJiko__c,
            SekoTantoSoryoSoryoId__c,
            SekoTantoSoryoSangoJiinMeiFurigana__c,
            ObosanbinKeiyakuSekotanto__r.SyozokusangojiinmeFurigana__c,
            ObosanbinKeiyakuSekotanto__r.Teikeisaki__r.Name,
            ObosanbinKeiyakuSekotanto__r.Teikeisaki__r.SeiKana__c,
            ObosanbinKeiyakuSekotanto__r.Teikeisaki__r.MeiKana__c,
            ObosanbinKeiyakuSekotanto__r.Teikeisaki__r.YusenFaxFormula__c,
            ObosanbinKeiyakuSekotanto__r.Teikeisaki__r.TorihikisakiBangoF__c,
            ObosanbinKeiyakuSekotanto__r.Teikeisaki__r.ShozokuSangouSangoJiin__r.Syuha__c,
            ObosanbinKeiyakuSekotanto__r.Teikeisaki__r.ShozokuSangouSangoJiin__r.Name,
            ObosanbinKeiyakuSekotanto__r.Teikeisaki__r.ShozokuSangouSangoJiin__r.HoujinTanniKubun__c,
            ObosanbinKeiyakuSekotanto__r.Teikeisaki__r.ShozokuSangouSangoJiin__r.SyusiSyuhaExp__c,
            ObosanbinKeiyakuSekotanto__r.Teikeisaki__r.BillingAddressFormula__c,
            ObosanbinKeiyakuSekotanto__r.Teikeisaki__r.BillingState,
            ObosanbinKeiyakuSekotanto__r.Teikeisaki__r.YusenTelNoFormula__c,
            ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.Fax,
            TsuikahoyobashoMei__c,
            sogi_todofuken__c,
            sogi_shikugun__c,
            sogi_tyoumei__c,
            sogi_banchi__c,
            hoyo_todofuken__c,
            hoyo_shikugun__c,
            hoyo_tyoumei__c,
            hoyo_banchi__c,
            tuika_todofuken__c,
            tuika_shikugun__c,
            tuika_tyoumei__c,
            tuika_banchi__c,
            MoshuRef__r.BillingPostalCode,
            MoshuRef__r.BillingState,
            MoshuRef__r.BillingCity,
            MoshuRef__r.BillingStreet,
            SaijoPhone__c,
            FinalDecisionTotalAmount__c,
            TicketSendingDate__c, IraiTehaiDate__c,
            Taishosha1Ref__r.Age__pc,
            ObosanbinKeiyakuMadoguchi__r.ObousanBinTehaiKubun__c,
            TeiHehOfuseKingaku__c,
            TeiHehTesuryoSoryo__c,
            TeiHehTesuryoSogisha__c
            FROM Obosanbin__c
            WHERE Id = :pId
            LIMIT 1
            ];

        return theEntities.get(0);
    }
}