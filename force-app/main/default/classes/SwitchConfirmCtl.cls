public class SwitchConfirmCtl {

    public String otaId {get;set;}
    public String oppId {get;set;}
    public String contactText {get;set;}
    public Opportunity opp {get; set;}
    public OtaiShienSogiyo__c ota {get; set;}
    public SwitchContactHistory__c scon {get;set;}
    public String nextAction {get;set;}
    public Map<String, List<String>> yokenShubetsuMapList {get;set;}
    public Boolean claimFlg {get;set;}
    public String beforeStageName {get;set;}
    public String beforeSubPhase {get;set;}
    public String profileName {get;set;}
    public String userName {get;set;}

    //public String strNew;

    public String valuePicked {get; set;} 

    // 選択リストを作成    
    public List<SelectOption> customPickList{
        get{
            List<SelectOption> options = new List<SelectOption>();
            for(String yokenShubetsu : yokenShubetsuMapList.keySet()){
                options.add(new SelectOption(yokenShubetsu, yokenShubetsu));
            }
            return options;
        }
    }

    // 選択リストで選択された値が格納される変数
    public String valuePicked2 {get; set;} 

    // 選択リストを作成    
    public List<SelectOption> customPickList2{
        get{
            List<SelectOption> options = new List<SelectOption>();
            if(yokenShubetsuMapList.get(valuePicked) != null){
                for(String yokenShubetsu : yokenShubetsuMapList.get(valuePicked)){
                    options.add(new SelectOption(yokenShubetsu, yokenShubetsu));
                }
            }
            else{
                options.add(new SelectOption('---なし--', '---なし--'));
            }
            return options;
        }
    }

    public List<SwitchLongTextTempleteWrap> nextLTTempleteWrapList {get;set;}
    public List<SwitchLongTextTempleteWrap> importantLTTempleteWrapList {get;set;}
    public class SwitchLongTextTempleteWrap {
        public SwitchLongTextTemplete__c longTextTemplete {get;set;}
        public SwitchLongTextTempleteWrap(){}
    }


    public SwitchConfirmCtl() {
        otaId = Apexpages.currentPage().getParameters().get('otaid');
        oppId = Apexpages.currentPage().getParameters().get('oppid');
        ota = new OtaiShienSogiyo__c();
        opp = new Opportunity();
        nextAction = '';
        claimFlg = false;
        errFlg = false;
        alertFlg = false;
        msg = '';
        saveFlg = false;
        contactText = '';
    }


    public void init() {
        contactTextCreate();
        yokenShubetsuMapList = TaskOperation.getYokenShubetsuListMap(opp.RecordType.DeveloperName);

        valuePicked = opp.StageName;
        if(opp.SubPhase__c != null && opp.SubPhase__c != ''){
            valuePicked += '：' + opp.SubPhase__c;
        }
        if(valuePicked == null || valuePicked == ''){
            valuePicked = '問合せ受付：3分コール接続待';
        }

        beforeStageName = opp.StageName;
        beforeSubPhase = opp.SubPhase__c;
        
        opp.StageName = '';
        opp.SubPhase__c = '';

        profileName = [select Name from Profile where Id = :UserInfo.getProfileId()].Name;
        userName = UserInfo.getLastName();

        nextLTTempleteWrapList = new List<SwitchLongTextTempleteWrap>();
        importantLTTempleteWrapList = new List<SwitchLongTextTempleteWrap>();
        for(SwitchLongTextTemplete__c sltSwitchLongTextTemplete : [select Id, Body__c, Title__c, ShiyoBasho__c from SwitchLongTextTemplete__c order by SortOrder__c]){
            SwitchLongTextTempleteWrap tempSwitchLongTextTempleteWrap = new SwitchLongTextTempleteWrap();
            tempSwitchLongTextTempleteWrap.longTextTemplete = sltSwitchLongTextTemplete;
            if(sltSwitchLongTextTemplete.ShiyoBasho__c == '次回対応') nextLTTempleteWrapList.add(tempSwitchLongTextTempleteWrap);
            if(sltSwitchLongTextTemplete.ShiyoBasho__c == '重要連絡事項') importantLTTempleteWrapList.add(tempSwitchLongTextTempleteWrap);
        }
    }

    public void contactTextCreate(){

        List<OtaiShienSogiyo__c> otaList = [select Id,
                                                    FreeText__c,
                                                    Name,
                                                    OpportunityRef__c,
                                                    SodanshaSeiKana__c,
                                                    SodanshaMeiKana__c,
                                                    MobilePhone__c,
                                                    Phone__c,
                                                    TelNoPrimaryKubun__c,
                                                    TaishoushaJokyo__c,
                                                    //issues3806--Start--
                                                    TaishoshaKyojuKeitai__c,
                                                    TaishoshaYomeiKikan__c,
                                                    ToiawaseKiinsha__c,
                                                    TaishoshaKyojuKeitaiGenzai__c,
                                                    TaishoushaJokyoGenzai__c,
                                                    TaishoshaYomeiKikanGenzai__c,
                                                    //issues3806--End--
                                                    BenefitOneID__c,
                                                    BenefitOneName__c,
                                                    PostalClubKaiinBango__c,
                                                    SodanshaSei__c,
                                                    SodanshaMei__c,
                                                    SodanshaSeibetsu__c,
                                                    //issues3806--Start--
                                                    //コメントアウト
                                                    //TaishoshasamaKyojuKeitai__c,
                                                    //issues3806--End--
                                                    TaishoshaSei__c,
                                                    TaishoshaMei__c,
                                                    TaishoshaSeiKana__c,
                                                    TaishoshaMeiKana__c,
                                                    TaishoshaSeibetsu__c,
                                                    SeinengappiSeireki__c,
                                                    SeinengappiWareki__c,
                                                    TaishoshaPostalCode__c,
                                                    TaiishoshaStateText__c,
                                                    TaishoshaCity__c,
                                                    TaishoshaStreet__c,
                                                    Syushi__c,
                                                    Syuha__c,
                                                    BodaijinoUmu__c,
                                                    HakaUmuKubun__c,
                                                    KiboKeishiki__c,
                                                    // KiboPlan__c,
                                                    KiboGoanchisaki__c,
                                                    MonkArrangements__c,
                                                    FamilyTempleObtainConsensus__c,
                                                    SanretsushaShinzokuFrom__c,
                                                    SanretsushaShinzokuTo__c,
                                                    SanretsushaShinzokuigaiFrom__c,
                                                    SanretsushaShinzokuigaiTo__c,
                                                    Kaimyojuyo__c,
                                                    MoshuNoJuminhyoRef__c,
                                                    MoshuNoJuminhyoRef__r.Name,
                                                    TaishoshaJuminhyoState__c,
                                                    TaishoshaJuminhyoCity__c,
                                                    ZokugaraSodanshaNitottenoTaishosha__c,
                                                    PreExecuteArea__c,
                                                    PreExecuteArea2__c,
                                                    PreExecuteArea3__c,
                                                    PreExecuteArea4__c,
                                                    PreExecuteArea__r.Name,
                                                    PreExecuteArea2__r.Name,
                                                    PreExecuteArea3__r.Name,
                                                    PreExecuteArea4__r.Name,
                                                    Ketteisha__c,
                                                    Shiharaihouhou__c,
                                                    ShiryoseikyushaSei__c,
                                                    ShiryoseikyushaMei__c,
                                                    ShiryoseikyushaSeiKana__c,
                                                    ShiryoseikyushaMeiKana__c,
                                                    ShiryoseikyushaMail__c,
                                                    ShiroseikyushaFax__c,
                                                    ShiryoseikyushaPostalCode__c,
                                                    ShiryoseikyushaStateText__c,
                                                    ShiryoseikyushaCity__c,
                                                    ShiryoseikyushaStreet__c,
                                                    ShiryoSofuJokyo__c,
                                                    YusoYohiShubetsu__c,
                                                    MailSofuYohi__c,
                                                    ShiryoSofuNichiji__c,
                                                    YubinShiryoSofubi__c,
                                                    MailShiryoSofubi__c,
                                                    FaxSofuYohi__c,
                                                    FaxShiryoSofubi__c,
                                                    SodanshaMemberTourokuZumi__c,
                                                    JizenJizenSheetTeishutsuzumi__c, 
                                                    MemberSeidoGoannaiJokyo__c,
                                                    JizenJunbiSheetGoannaiJokyo__c, 
                                                    JizenJunbiSheetGoteishutsuShudan__c, 
                                                    JizenJunbiSheetDairiNyuryokuTantoshaRef__c, 
                                                    JizenwariShoshoHassoDate__c, 
                                                    PreliminaryConsultationDate__c,
                                                    JuyoRenrakuJiko__c,
                                                    Shiharaihouhou2__c,
                                                    OmukaeSakiName__c,
                                                    OmukaeSakiJusho__c,
                                                    SimpleYasugoKeiyakuRef__c,
                                                    SimpleYasugoKeiyakuRef__r.Name,
                                                    TaiouKanouRiyu__c,
                                                    SokyakushoKisaiJiko__c,
                                                    KakuteibiSyodan__c,
                                                    BotsunengappiSeireki__c,
                                                    BotsunengappiWareki__c,
                                                    TaishoshaNoJuminhyoRef__c,
                                                    TaishoshaNoJuminhyoRef__r.Name,
                                                    TaishoshaNoJuminhyoRef__r.TodoufuKenRef__r.Name,
                                                    TaishoshaNoJuminhyoRef__r.ShikugunMei__c,
                                                    AnchiRyokin2hakuOr3haku__c,
                                                    ShikijoShiyoryo2man5senOr5man__c,
                                                    KasobaShiyoryoPlangai__c,
                                                    HansoKyori50km__c,
                                                    HansoKaisu2kaiOr3kai__c,
                                                    ChokusoPlanMenkaiFuka__c,
                                                    KeisatsuAnkenKenanryo__c,
                                                    KeisatsuAnken__c,
                                                    SosaiFujo__c,
                                                    TashaAnchi__c,
                                                    TaijiAnken__c,
                                                    Kaimyo__c,
                                                    SodanshaRef__c,
                                                    SodanshaRef__r.JizenwariShoshoHassoDate__c,
                                                    TaishoshaRef__c,
                                                    OfferingJokyo__c,
                                                    ShohinRef__c,
                                                    GoanchiMenkaiKiboUmu__c,
                                                    GoanchisakiJusho__c,
                                                    KiboKingaku__c, 
                                                    GoannaizumiRyuijiko__c, 
                                                    ShiharaiHohoMikakuteiRiyu__c, 
                                                    SurveySendWayHopeEmail__c, 
                                                    SurveySendWayHopeSms__c, 
                                                    SurveyDiscountAgreeStatus__c, 
                                                    ShiharaiHohoMikakuteiRiyu2__c, 
                                                    TaioYusenRiyuShosai__c, 
                                                    RyokinAnnaiBiko__c, 
                                                    SonotaGoanchiKanrenTokkijiko__c,  
                                                    BodaijiSoryoTehaiBiko__c,
                                                    AllianceRef__c, 
                                                    Tel_Sogifollow_SmsPermission__c, 
                                                    Konnyusaki__c, 
                                                    KonnyusakiKasobaRef__c, 
                                                    KonnyusakiKasobaText__c, 
                                                    KonnyusakiKyogoTasha__c, 
                                                    KonnyusakiKyogoTashaText__c, 
                                                    KonnyusakiSaijoRef__c, 
                                                    KonnyusakiSaijoText__c, 
                                                    KonnyusakiSogishaRef__c, 
                                                    KonnyusakiSogishaText__c, 
                                                    TashaSodanJokyo__c, 
                                                    TeikeiJokyo__c, 
                                                    ToiawaseNaiyo__c, 
                                                    AnkenShubetsu__c, 
                                                    PlanBiko__c, 
                                                    ShikijoKasojoBiko__c, 
                                                    ButsuguNashiKibo__c, 
                                                    SaidanKibo__c, 
                                                    KanjoHanatabaKibo__c, 
                                                    KagobanaKibo__c,
                                                    MakurabanaKibo__c, 
                                                    AimitsumoriHiaringuSha__c, 
                                                    AimitsumoriJokyo__c, 
                                                    AimitsumoriPointKakaku__c, 
                                                    AimitsumoriPointShikijo__c, 
                                                    AimitsumoriPointSonota__c, 
                                                    KakakuOffering__c, 
                                                    AimitsumoriHiaringuBiko__c, 
                                                    YorisoWoSittaKikkake__c, 
                                                    SogishaTsuikaEigyoNg__c, 
                                                    (
                                                    select Id, 
                                                            Name, 
                                                            OtaiShienSogiRef__c, 
                                                            KaimyoHomyo__c, 
                                                            KaimyoJuyoKiboUmu__c, 
                                                            SanretsushaShinzokuFrom__c, 
                                                            SanretsushaShinzokuTo__c, 
                                                            SanretsushaShinzokuigaiFrom__c, 
                                                            SanretsushaShinzokuigaiTo__c, 
                                                            SoryoTehaiKiboUmu__c, 
                                                            // KiboPlan__c, 
                                                            KiboKeishiki__c, 
                                                            WebJizenJunbi__c, 
                                                            WaribikiService__c, 
                                                            Zeiritsu__c, 
                                                            Version__c, 
                                                            ShiryoSakusei__c, 
                                                            RyokinKeisanHyoJson__c, 
                                                            KasobaName__c, 
                                                            CreatedDate, 
                                                            CreatedBy.LastName, 
                                                            LastModifiedDate, 
                                                            LastModifiedBy.LastName 
                                                    from OtaiShienSogiRyokinHyos__r 
                                                    order by CreatedDate desc 
                                                    ),
                                                    (
                                                    select Id, 
                                                            TeianShohin__c, 
                                                            TeianKekka__c, 
                                                            OpportunityRef__c 
                                                    from OtaiShienSogiyos__r 
                                                    )
                                                FROM OtaiShienSogiyo__c
                                                where Id = :otaId];
        if(otaList.size() == 1){
            ota = otaList.get(0);
            opp = [select Id,
                            AccountId,
                            Account.SeiKana__c,
                            Account.MeiKana__c,
                            Account.LastName,
                            Account.FirstName,
                            Account.Seibetsu__c,
                            Account.MobilePhone__c,
                            Account.Phone,
                            Account.YusenTelNoKubun__c,
                            Account.MemberTourokuZumi__c,
                            Account.JizenJizenSheetTeishutsuzumi__c,
                            Account.JizenwariShoshoHassoDate__c,
                            Account.PersonContactId,
                            Account.LastNameFurigana__pc,
                            Account.FirstNameFurigana__pc,
                            Account.Gender__pc,
                            Account.BodaijinoUmu__c,
                            Account.MailAddress__c,
                            Account.Fax,
                            Account.BillingPostalCode,
                            Account.BillingState,
                            Account.BillingCity,
                            Account.BillingStreet,
                            Account.RecordTypeId,
                            Account.Tel_Sogifollow_SmsPermission__c, 
                            StageName,
                            SubPhase__c,
                            BenefitOneID__c,
                            BenefitOneName__c,
                            KiboShiharaiHouhou__c,
                            OfferingJokyo__c,
                            PostalClubKaiinBango__c,
                            TaishoushaJokyo__c,
                            //issues3806--Start--
                            SogiKPI__c,
                            TaishoshaKyojuKeitai__c,
                            TaishoshaYomeiKikan__c,
                            ToiawaseKiinsha__c,
                            KinkyudoLV__c,
                            SoteiLeadTime__c,
                            TaishoshaKyojuKeitaiGenzai__c,
                            TaishoushaJokyoGenzai__c,
                            TaishoshaYomeiKikanGenzai__c,
                            KinkyudoLVGenzai__c,
                            SoteiLeadTimeGenzai__c,
                            SogiKPIGenzai__c,
                            SogiKPIGenzaiKoshinbi__c,
                            //issues3806--End--
                            Ketteisha__c,
                            JuyoRenrakuJiko__c,
                            ShodanBangoF__c, 
                            ShitchuYoin__c, 
                            JogaiKubun__c, 
                            ShitchuKubun__c, 
                            SonotaShitchuYoinHosoku__c, 
                            GoannaizumiRyuijiko__c, 
                            ShiharaiHohoMikakuteiRiyu__c, 
                            SurveySendWayHopeEmail__c, 
                            SurveySendWayHopeSms__c, 
                            SurveyDiscountAgreeStatus__c, 
                            AllianceRef__c, 
                            FirstContact__c, 
                            AnkenShubetsu__c, 
                            AimitsumoriHiaringuSha__c, 
                            AimitsumoriJokyo__c, 
                            AimitsumoriPointKakaku__c, 
                            AimitsumoriPointShikijo__c, 
                            AimitsumoriPointSonota__c, 
                            KakakuOffering__c, 
                            AimitsumoriHiaringuBiko__c, 
                            YorisoWoSittaKikkake__c, 
                            TorihikiShodanRef__r.AccountId, 
                            SimpleYasugoRef__r.TaishoshaRef__c,
                            SimpleYasugoRef__r.TaishoshaRef__r.LastName,
                            SimpleYasugoRef__r.TaishoshaRef__r.LastNameFurigana__pc,
                            SimpleYasugoRef__r.TaishoshaRef__r.FirstName,
                            SimpleYasugoRef__r.TaishoshaRef__r.FirstNameFurigana__pc,
                            SimpleYasugoRef__r.TaishoshaRef__r.Gender__pc,
                            SimpleYasugoRef__r.TaishoshaRef__r.PersonBirthdate,
                            SimpleYasugoRef__r.TaishoshaRef__r.SeinengappiWareki__c,
                            SimpleYasugoRef__r.TaishoshaRef__r.PersonDeathDate__pc,
                            SimpleYasugoRef__r.TaishoshaRef__r.BotsunengappiWareki__c,
                            SimpleYasugoRef__r.TaishoshaRef__r.BillingPostalCode,
                            SimpleYasugoRef__r.TaishoshaRef__r.BillingState,
                            SimpleYasugoRef__r.TaishoshaRef__r.BillingCity,
                            SimpleYasugoRef__r.TaishoshaRef__r.BillingStreet,
                            SimpleYasugoRef__r.TaishoshaRef__r.BodaijinoUmu__c,
                            SimpleYasugoRef__r.TaishoshaRef__r.HakaUmuKubun__c,
                            SimpleYasugoRef__r.TaishoshaRef__r.Syushi__c,
                            SimpleYasugoRef__r.TaishoshaRef__r.Syuha__c,
                            SimpleYasugoRef__r.TaishoshaRef__r.JuminhyouState__c, 
                            SimpleYasugoRef__r.TaishoshaRef__r.JuminhyouCity__c,  
                            SimpleYasugoRef__r.KiboAreaRef__c,
                            SimpleYasugoRef__r.KiboAreaRef__r.Name,
                            SimpleYasugoRef__r.KiboArea2Ref__c,
                            SimpleYasugoRef__r.KiboArea2Ref__r.Name,
                            SimpleYasugoRef__r.KiboArea3Ref__c,
                            SimpleYasugoRef__r.KiboArea3Ref__r.Name,
                            SimpleYasugoRef__r.KiboArea4Ref__c,
                            SimpleYasugoRef__r.KiboArea4Ref__r.Name,
                            SimpleYasugoRef__r.MosyuRef__c,
                            SimpleYasugoRef__r.KiboGoanchisaki__c,
                            SimpleYasugoRef__r.MonkArrangements__c,
                            SimpleYasugoRef__r.FamilyTempleObtainConsensus__c,
                            SimpleYasugoRef__r.Kaimyojuyo__c,
                            SimpleYasugoRef__r.Kaimyo__c,
                            SimpleYasugoRef__r.MoshuNoJuminhyoRef__c,
                            SimpleYasugoRef__r.MoshuNoJuminhyoRef__r.Name,
                            SimpleYasugoRef__r.ShiryoSofuJokyo__c,
                            SimpleYasugoRef__r.MailSofuYohi__c,
                            SimpleYasugoRef__r.ShiryoSofuNichiji__c,
                            SimpleYasugoRef__r.MailShiryoSofubi__c,
                            SimpleYasugoRef__r.FaxSofuYohi__c,
                            SimpleYasugoRef__r.FaxShiryoSofubi__c,
                            Account.MemberSeidoGoannaiJokyo__c,
                            SimpleYasugoRef__r.OmukaeSakiName__c,
                            SimpleYasugoRef__r.OmukaeSakiZipcode__c,
                            SimpleYasugoRef__r.OmukaeSakiState__c,
                            SimpleYasugoRef__r.OmukaeSakiCity__c,
                            SimpleYasugoRef__r.OmukaeSakiStreet__c,
                            SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__c,
                            SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Name,
                            SimpleYasugoRef__r.SokyakushoKisaiJiko__c,
                            SimpleYasugoRef__r.TaiouKanouRiyu__c,
                            //issues3806--Start--
                            //コメントアウト
                            //SimpleYasugoRef__r.TaishoshasamaKyojuKeitai__c,
                            //issues3806--End--
                            SimpleYasugoRef__r.YubinShiryoSofubi__c,
                            SimpleYasugoRef__r.YusoYohiShubetsu__c,
                            SimpleYasugoRef__r.ZokugaraSodanshaNitottenoTaishosha__c,
                            SimpleYasugoRef__r.NumberRelatives__c,
                            SimpleYasugoRef__r.SanretsushaShinzokuTo__c,
                            SimpleYasugoRef__r.MournersNumber__c,
                            SimpleYasugoRef__r.SanretsushaShinzokuigaiTo__c,
                            SimpleYasugoRef__r.AnchiRyokin2hakuOr3haku__c,
                            SimpleYasugoRef__r.ShikijoShiyoryo2man5senOr5man__c,
                            SimpleYasugoRef__r.KasobaShiyoryoPlangai__c,
                            SimpleYasugoRef__r.HansoKyori50km__c,
                            SimpleYasugoRef__r.HansoKaisu2kaiOr3kai__c,
                            SimpleYasugoRef__r.ChokusoPlanMenkaiFuka__c,
                            SimpleYasugoRef__r.KeisatsuAnkenKenanryo__c,
                            SimpleYasugoRef__r.KeisatsuAnken__c,
                            SimpleYasugoRef__r.SosaiFujo__c,
                            SimpleYasugoRef__r.TashaAnchi__c,
                            SimpleYasugoRef__r.TaijiAnken__c,
                            SimpleYasugoRef__r.SogiPlanUketsuke__c,
                            SimpleYasugoRef__r.FollowTelJokyo__c,
                            SimpleYasugoRef__r.X3CallJishiKekka__c,
                            SimpleYasugoRef__r.ShiryoTochakugoFollowTel1__c,
                            SimpleYasugoRef__r.ShiryoTochakugoFollowTel2__c,
                            SimpleYasugoRef__r.ShiryoTochakugoFollowTel3__c,
                            SimpleYasugoRef__r.ShiryoTochakugoFollowTel4__c,
                            SimpleYasugoRef__r.GoanchiMenkaiKiboUmu__c,
                            SimpleYasugoRef__r.GoanchisakiJusho__c, 
                            SimpleYasugoRef__r.TaioYusenRiyuShosai__c, 
                            SimpleYasugoRef__r.RyokinAnnaiBiko__c, 
                            SimpleYasugoRef__r.SonotaGoanchiKanrenTokkijiko__c, 
                            SimpleYasugoRef__r.KetteijiTantoshaRef__c, 
                            SimpleYasugoRef__r.JizenJunbiSheetGoannaiJokyo__c, 
                            SimpleYasugoRef__r.JizenJunbiSheetGoteishutsuShudan__c, 
                            SimpleYasugoRef__r.JizenJunbiSheetDairiNyuryokuTantoshaRef__c, 
                            SimpleYasugoRef__r.PreliminaryConsultationDate__c, 
                            SimpleYasugoRef__r.Konnyusaki__c, 
                            SimpleYasugoRef__r.KonnyusakiKasobaRef__c, 
                            SimpleYasugoRef__r.KonnyusakiKasobaText__c, 
                            SimpleYasugoRef__r.KonnyusakiKyogoTasha__c, 
                            SimpleYasugoRef__r.KonnyusakiKyogoTashaText__c, 
                            SimpleYasugoRef__r.KonnyusakiSaijoRef__c, 
                            SimpleYasugoRef__r.KonnyusakiSaijoText__c, 
                            SimpleYasugoRef__r.KonnyusakiSogishaRef__c, 
                            SimpleYasugoRef__r.KonnyusakiSogishaText__c, 
                            SimpleYasugoRef__r.TashaSodanJokyo__c, 
                            SimpleYasugoRef__r.TeikeiJokyo__c, 
                            SimpleYasugoRef__r.ToiawaseNaiyo__c, 
                            SimpleYasugoRef__r.PlanBiko__c, 
                            SimpleYasugoRef__r.ShikijoKasojoBiko__c, 
                            SimpleYasugoRef__r.ButsuguNashiKibo__c, 
                            SimpleYasugoRef__r.SaidanKibo__c, 
                            SimpleYasugoRef__r.KanjoHanatabaKibo__c, 
                            SimpleYasugoRef__r.KagobanaKibo__c, 
                            SimpleYasugoRef__r.MakurabanaKibo__c, 
                            SimpleYasugoRef__r.SogishaTsuikaEigyoNg__c, 
                            RecordType.DeveloperName,
                            (select Id from OpportunityLineItems) 
                    from Opportunity 
                    where Id = :oppId];
            valuePicked = opp.StageName;
            valuePicked2 = opp.SubPhase__c;
        }

        List<SwitchContactHistory__c> contactHistoryList = [SELECT 
                                            Id,
                                            OwnerId,
                                            IsDeleted,
                                            Name,
                                            CreatedDate,
                                            CreatedById,
                                            LastModifiedDate,
                                            LastModifiedById,
                                            SystemModstamp,
                                            OkyakusamaJuhasshinJokyo__c,
                                            OkyakusamaKadenShubetsu__c,
                                            OkyakusamaKadenShubetsuSonota__c,
                                            OkyakusamaTaiosha__c,
                                            OkyakusamaSodanshaIgaiName__c,
                                            OkyakusamaSodanshaIgaiKankei__c,
                                            OkyakusamaTel__c,
                                            OkyakusamaTaishoshaJokyo__c,
                                            OkyakusamaTaishoshaJokyoSonota__c,
                                            OkyakusamaSetsuzokuJokyo__c,
                                            SogishaJuhasshinJokyo__c,
                                            OkyakusamaShiryoTochakuKakunin__c,
                                            SogishaKetteiSogishaName__c,
                                            OkyakusamaTaishoshaShozaichi__c,
                                            OkyakusamaShiboShindansho__c,
                                            SogishaKetteiSogishaTantosha__c,
                                            OkyakusamaTochakuJokyo__c,
                                            OkyakusamaOmukaeJikanShitei__c,
                                            SogishaKetteiSogishaIgaiName__c,
                                            OkyakusamaOffering__c,
                                            OkyakusamaOfferingKingaku__c,
                                            OkyakusamaFreeComment__c,
                                            SogishaKetteiSogishaIgaiTantosha__c,
                                            SogishaTel__c,
                                            OkyakusamaOptionRyori__c,
                                            OkyakusamaOptionHenreihin__c,
                                            OkyakusamaOptionKyoka__c,
                                            OkyakusamaOptionYukan__c,
                                            OkyakusamaOptionKoshikiYukan__c,
                                            OkyakusamaOptionKanjoHanataba__c,
                                            OkyakusamaOptionIeishashin__c,
                                            OkyakusamaOptionMake__c,
                                            OkyakusamaOptionSonota__c,
                                            OkyakusamaChuiJikoAnchiRyokinAnnai__c,
                                            OkyakusamaChuiJikoPlannaiShikijoShiryory__c,
                                            OkyakusamaChuiJikoKasojoShiyoryoPlangai__c,
                                            OkyakusamaChuiJikoHansoKyori50km__c,
                                            OkyakusamaChuiJikoHansoKaisu2KaiOr3Kai__c,
                                            OkyakusamaChuiJikoChokusoPlanMenkaiFuka__c,
                                            OkyakusamaKasoRyokin__c,
                                            OkyakusamaJizenSurveyWebAnnai__c,
                                            OkyakusamaJizenSurveyYusoAnnai__c,
                                            OkyakusamaJizenSurveyDairiNyuryokuTeian__c,
                                            OkyakusamaJizenSurveySodanshaFullNameKan__c,
                                            OkyakusamaJizenSurveySodanshaFullName__c,
                                            OkyakusamaJizenSurveySogiKiboChiiki__c,
                                            OkyakusamaJizenSurveySodanshaJusho__c,
                                            OkyakusamaJizenSurveySodanshaMail__c,
                                            OkyakusamaJizenSurveySodanshaMobile__c,
                                            OkyakusamaJizenSurveyTaishoshaJuminhyo__c,
                                            OkyakusamaJizenSurveyTaishoshaJotai__c,
                                            OkyakusamaJizenSurveyTaishoshaZokugara__c,
                                            OkyakusamaJizenSurveyTaishoshaFullNameKa__c,
                                            OkyakusamaJizenSurveyTaishoshaFullName__c,
                                            OkyakusamaSurveywari__c,
                                            OkyakusamaJizenSurveyDairiNyuryokuTeianY__c,
                                            OkyakusamaShiryoSeikyuYohi__c,
                                            OkyakusamaSmsShisakuYohi__c,
                                            OkyakusamaTaimenSodanYohi__c,
                                            OkyakusamaOsoshiYoyaku__c,
                                            OkyakusamaKeisatsuAnken__c,
                                            OkyakusamaSosaiFujo__c,
                                            OkyakusamaHenkinHosho__c,
                                            SogishaFreeComment__c,
                                            OkyakusamaTokkijikoComment__c,
                                            OkyakusamaMemberSeido__c,
                                            OkyakusamaRusudenMsg__c,
                                            OkyakusamaShiryoNaiyoKakunin__c,
                                            OkyakusamaOmukaeJikan__c,
                                            OkyakusamaShiboShindanshoShutokuYotei__c,
                                            OkyakusamaPlanNaiyo__c,
                                            OkyakusamaPlanKingaku__c,
                                            OkyakusamaOndokanTakame__c,
                                            OkyakusamaClaim__c,
                                            OkyakusamaSoryoTehaiAnnai__c,
                                            SogishaTaiosha__c,
                                            SogishaOmukaeJikan__c,
                                            SogishaTsuyaDate__c,
                                            SogishaKokubetsushikiDate__c,
                                            SogishaKasoDate__c,
                                            SogishaShiharaiHoho__c,
                                            SogishaSoryoTehai__c,
                                            SogishaSonotaShinchoku__c,
                                            SogishaMitsumorishoSofuRenraku__c,
                                            SogishaSeikyushoSofuRenraku__c,
                                            SogishaTesuryoKingaku__c,
                                            SogishaTeikeiKaijoKibo__c,
                                            SogishaPlanToiawase__c,
                                            SogishaPanfuSofuIrai__c,
                                            SogishaPanfuAtesaki__c,
                                            SogishaPanfuAtena__c,
                                            SogishaSofubutsu__c,
                                            SogishaTaimenSodanKekka__c,
                                            SogishaSogishaTehai__c,
                                            SogishaAkijokyoKakunin__c,
                                            SogishaMitsumorishoSaisoku__c,
                                            SogishaUchiawaseYotei__c,
                                            SogishaMitsumorishoNaiyo__c,
                                            SogishaTaimenSodanIrai__c,
                                            SogishaAtooi__c,
                                            SogishaClaim__c,
                                            SogishaOndokanTakame__c,
                                            SogishaTokkijikoComment__c,
                                            SogishaOrikaeshiNaiyo__c,
                                            SogishaOrikaeshiTantoshaName__c,
                                            SogishaOrikaeshiRenrakusaki__c,
                                            SogishaOrikaeshiRenrakuNichijiShitei__c,
                                            SogishaOrikaeshiRenrakuNichiji__c,
                                            SogishaTsuyaHour__c,
                                            SogishaTsuyaMinute__c,
                                            SogishaKasoHour__c,
                                            SogishaKasoMinute__c,
                                            SogishaKokubetsushikiHour__c,
                                            SogishaKokubetsushikiMinute__c,
                                            SogishaPlan__c,
                                            OpportunityRef__c, 
                                            ContactShubetsu__c 
                                        FROM SwitchContactHistory__c 
                                        WHERE OpportunityRef__c =:oppId];
        if(contactHistoryList.size() > 0){
            scon = contactHistoryList.get(0);

            contactText = '';
            
            if(scon.ContactShubetsu__c == 'お客様'){
                String taiwashaInfo = '';
                if(!String.isBlank(scon.OkyakusamaTaiosha__c)){
                    taiwashaInfo += scon.OkyakusamaTaiosha__c + '(';
                    if(scon.OkyakusamaTaiosha__c == '相談者'){
                        if(!String.isBlank(ota.SodanshaSeiKana__c)) taiwashaInfo += ota.SodanshaSeiKana__c;
                        if(!String.isBlank(ota.SodanshaMeiKana__c)) taiwashaInfo += ' ' + ota.SodanshaMeiKana__c;
                    }
                    if(scon.OkyakusamaTaiosha__c == '相談者以外'){
                        if(!String.isBlank(scon.OkyakusamaSodanshaIgaiName__c)) taiwashaInfo += scon.OkyakusamaSodanshaIgaiName__c;
                        if(!String.isBlank(scon.OkyakusamaSodanshaIgaiKankei__c)) taiwashaInfo += '　関係：' + scon.OkyakusamaSodanshaIgaiKankei__c;
                    }
                    taiwashaInfo += ')';
                }

                if(!String.isBlank(scon.OkyakusamaJuhasshinJokyo__c)){
                    if(scon.OkyakusamaJuhasshinJokyo__c == '受電'){
                        taiwashaInfo += 'より' + scon.OkyakusamaJuhasshinJokyo__c;
                    }
                    if(scon.OkyakusamaJuhasshinJokyo__c == '架電'){
                        taiwashaInfo += 'に' + scon.OkyakusamaJuhasshinJokyo__c;
                        if(!String.isBlank(scon.OkyakusamaKadenShubetsu__c)){
                            taiwashaInfo += '(';
                            if(scon.OkyakusamaKadenShubetsu__c == 'その他') { taiwashaInfo += scon.OkyakusamaKadenShubetsuSonota__c; }
                            else{ taiwashaInfo += scon.OkyakusamaKadenShubetsu__c; }
                            taiwashaInfo += ')';
                        }
                    }
                }
                taiwashaInfo += '\n';

                if(!String.isBlank(scon.OkyakusamaTel__c)) taiwashaInfo += '電話番号：' + scon.OkyakusamaTel__c + '\n';

                if(!String.isBlank(scon.OkyakusamaTaishoshaJokyo__c)) {
                    taiwashaInfo += '対象者状況：';
                    if(scon.OkyakusamaTaishoshaJokyo__c == 'その他') { taiwashaInfo += scon.OkyakusamaTaishoshaJokyoSonota__c; }
                    else{ taiwashaInfo += scon.OkyakusamaTaishoshaJokyo__c; }
                    taiwashaInfo += '\n';
                }
                if(String.isNotBlank(taiwashaInfo.replace('\n', ''))) contactText += '<対話者情報>' + '\n' + taiwashaInfo + '\n';

                String kadenInfo = '';
                if(!String.isBlank(scon.OkyakusamaSetsuzokuJokyo__c)) kadenInfo += '接続状況：' + scon.OkyakusamaSetsuzokuJokyo__c + '\n';
                if(!String.isBlank(scon.OkyakusamaRusudenMsg__c)) kadenInfo += '留守電(MSG)：' + scon.OkyakusamaRusudenMsg__c + '\n';
                if(!String.isBlank(scon.OkyakusamaShiryoTochakuKakunin__c)) kadenInfo += '資料到着確認：' + scon.OkyakusamaShiryoTochakuKakunin__c + '\n';
                if(!String.isBlank(scon.OkyakusamaShiryoNaiyoKakunin__c)) kadenInfo += '資料内容確認：' + scon.OkyakusamaShiryoNaiyoKakunin__c + '\n';
                if(String.isNotBlank(kadenInfo.replace('\n', ''))) contactText += '<架電専用>' + '\n' + kadenInfo + '\n';

                String onakunariInfo = '';
                if(!String.isBlank(scon.OkyakusamaTaishoshaShozaichi__c)) onakunariInfo += '対象者所在地：' + scon.OkyakusamaTaishoshaShozaichi__c + '\n';
                if(!String.isBlank(scon.OkyakusamaShiboShindansho__c)){
                    onakunariInfo += '死亡診断書：' + scon.OkyakusamaShiboShindansho__c;
                    if(scon.OkyakusamaShiboShindansho__c == 'なし') onakunariInfo += '(' + scon.OkyakusamaShiboShindanshoShutokuYotei__c + ')' + '\n';
                }
                if(!String.isBlank(scon.OkyakusamaTochakuJokyo__c)) onakunariInfo += '到着状況：' + scon.OkyakusamaTochakuJokyo__c + '\n';
                if(!String.isBlank(scon.OkyakusamaOmukaeJikan__c)){
                    onakunariInfo += 'お迎え時間：' + scon.OkyakusamaOmukaeJikan__c;
                    if(scon.OkyakusamaOmukaeJikanShitei__c == '指定あり') onakunariInfo += '(' + scon.OkyakusamaOmukaeJikanShitei__c + ')';
                    onakunariInfo += '\n';
                }
                
                if(!String.isBlank(scon.OkyakusamaOffering__c)) onakunariInfo += 'オファリング：' + scon.OkyakusamaOffering__c + '\n';
                if(scon.OkyakusamaOfferingKingaku__c != null) onakunariInfo += 'オファリング金額：' + scon.OkyakusamaOfferingKingaku__c + '\n';
                if(String.isNotBlank(onakunariInfo.replace('\n', ''))) contactText += '<お亡くなり時の状況>' + '\n' + onakunariInfo + '\n';

                String annaiInfo = '';
                if(!String.isBlank(scon.OkyakusamaFreeComment__c)) annaiInfo += 'フリーコメント：' + scon.OkyakusamaFreeComment__c + '\n';
                if(!String.isBlank(scon.OkyakusamaPlanNaiyo__c)) annaiInfo += 'プラン内容：' + scon.OkyakusamaPlanNaiyo__c + '\n';
                if(!String.isBlank(scon.OkyakusamaPlanKingaku__c)) annaiInfo += 'プラン金額：' + scon.OkyakusamaPlanKingaku__c + '\n';
                if(scon.OkyakusamaKasoRyokin__c != null) annaiInfo += '火葬料金：' + scon.OkyakusamaKasoRyokin__c + '\n';
                if(scon.OkyakusamaSoryoTehaiAnnai__c != null) annaiInfo += '僧侶手配案内：' + scon.OkyakusamaSoryoTehaiAnnai__c + '\n';
                if(scon.OkyakusamaOptionRyori__c || scon.OkyakusamaOptionHenreihin__c || scon.OkyakusamaOptionKyoka__c || 
                    scon.OkyakusamaOptionYukan__c || scon.OkyakusamaOptionKoshikiYukan__c || scon.OkyakusamaOptionMake__c || 
                    scon.OkyakusamaOptionKanjoHanataba__c || scon.OkyakusamaOptionIeishashin__c || 
                    !String.isBlank(scon.OkyakusamaOptionSonota__c)
                ){
                    annaiInfo += 'オプション：';
                    if(scon.OkyakusamaOptionRyori__c) annaiInfo += '料理;';
                    if(scon.OkyakusamaOptionHenreihin__c) annaiInfo += '返礼品;';
                    if(scon.OkyakusamaOptionMake__c) annaiInfo += 'メイク;';
                    if(scon.OkyakusamaOptionKoshikiYukan__c) annaiInfo += '古式湯灌;';
                    if(scon.OkyakusamaOptionYukan__c) annaiInfo += '湯かん;';
                    if(scon.OkyakusamaOptionKanjoHanataba__c) annaiInfo += '棺上花束;';
                    if(scon.OkyakusamaOptionKyoka__c) annaiInfo += '供花;';
                    if(scon.OkyakusamaOptionIeishashin__c) annaiInfo += '遺影写真;';
                    if(!String.isBlank(scon.OkyakusamaOptionSonota__c)) annaiInfo += scon.OkyakusamaOptionSonota__c;
                    annaiInfo += '\n';
                }
                if(scon.OkyakusamaChuiJikoAnchiRyokinAnnai__c || scon.OkyakusamaChuiJikoPlannaiShikijoShiryory__c || 
                    scon.OkyakusamaChuiJikoKasojoShiyoryoPlangai__c || scon.OkyakusamaChuiJikoHansoKyori50km__c || 
                    scon.OkyakusamaChuiJikoHansoKaisu2KaiOr3Kai__c || scon.OkyakusamaChuiJikoChokusoPlanMenkaiFuka__c
                ){
                    annaiInfo += '注意事項：';
                    if(scon.OkyakusamaChuiJikoAnchiRyokinAnnai__c) annaiInfo += '安置料金案内;';
                    if(scon.OkyakusamaChuiJikoPlannaiShikijoShiryory__c) annaiInfo += 'プラン内式場使用料;';
                    if(scon.OkyakusamaChuiJikoKasojoShiyoryoPlangai__c) annaiInfo += '火葬場使用料プラン外案内;';
                    if(scon.OkyakusamaChuiJikoHansoKyori50km__c) annaiInfo += '搬送距離50km;';
                    if(scon.OkyakusamaChuiJikoHansoKaisu2KaiOr3Kai__c) annaiInfo += '搬送回数2回or3回;';
                    if(scon.OkyakusamaChuiJikoChokusoPlanMenkaiFuka__c) annaiInfo += '直葬プラン面会不可;';
                    annaiInfo += '\n';
                }
                if(!String.isBlank(scon.OkyakusamaMemberSeido__c)) annaiInfo += 'メンバー制度：' + scon.OkyakusamaMemberSeido__c + '\n';
                if(scon.OkyakusamaJizenSurveyWebAnnai__c || scon.OkyakusamaJizenSurveyYusoAnnai__c || 
                    scon.OkyakusamaJizenSurveyDairiNyuryokuTeian__c || scon.OkyakusamaJizenSurveySodanshaFullNameKan__c || 
                    scon.OkyakusamaJizenSurveySodanshaFullName__c || scon.OkyakusamaJizenSurveySogiKiboChiiki__c || 
                    scon.OkyakusamaJizenSurveySodanshaJusho__c || scon.OkyakusamaJizenSurveySodanshaMail__c || 
                    scon.OkyakusamaJizenSurveySodanshaMobile__c || scon.OkyakusamaJizenSurveyTaishoshaJuminhyo__c || 
                    scon.OkyakusamaJizenSurveyTaishoshaJotai__c || scon.OkyakusamaJizenSurveyTaishoshaZokugara__c || 
                    scon.OkyakusamaJizenSurveyTaishoshaFullNameKa__c || scon.OkyakusamaJizenSurveyTaishoshaFullName__c
                ){
                    if(scon.OkyakusamaJizenSurveyWebAnnai__c || scon.OkyakusamaJizenSurveyYusoAnnai__c) {
                        annaiInfo += '事前アンケート：';
                        if(scon.OkyakusamaJizenSurveyWebAnnai__c) annaiInfo += 'Web案内;';
                        if(scon.OkyakusamaJizenSurveyYusoAnnai__c) annaiInfo += '郵送案内;';
                        annaiInfo += '\n';
                    }
                    if(scon.OkyakusamaJizenSurveyDairiNyuryokuTeian__c){
                        annaiInfo += '代理入力提案：〇';
                        if(!String.isBlank(scon.OkyakusamaJizenSurveyDairiNyuryokuTeianY__c)) annaiInfo += '(' + scon.OkyakusamaJizenSurveyDairiNyuryokuTeianY__c + ')' + '\n';
                    }
                    if(scon.OkyakusamaJizenSurveySodanshaFullNameKan__c) annaiInfo += '相談者フルネームカナ：〇' + '\n';
                    if(scon.OkyakusamaJizenSurveySodanshaFullName__c) annaiInfo += '相談者フルネーム漢字：〇' + '\n';
                    if(scon.OkyakusamaJizenSurveySogiKiboChiiki__c) annaiInfo += '葬儀希望地域：〇' + '\n';
                    if(scon.OkyakusamaJizenSurveySodanshaJusho__c || 
                        scon.OkyakusamaJizenSurveySodanshaMobile__c || 
                        scon.OkyakusamaJizenSurveySodanshaMail__c
                    ){
                        if(scon.OkyakusamaJizenSurveySodanshaJusho__c) annaiInfo += '相談者住所：〇;';
                        if(scon.OkyakusamaJizenSurveySodanshaMobile__c) annaiInfo += '相談者メール：〇;';
                        if(scon.OkyakusamaJizenSurveySodanshaMail__c) annaiInfo += '相談者携帯：〇;';
                        annaiInfo += '\n';
                    }
                    if(scon.OkyakusamaJizenSurveyTaishoshaJuminhyo__c) annaiInfo += '対象者住民票：〇' + '\n';
                    if(scon.OkyakusamaJizenSurveyTaishoshaJotai__c) annaiInfo += '対象者状態：〇' + '\n';
                    if(scon.OkyakusamaJizenSurveyTaishoshaZokugara__c) annaiInfo += '相談者から見た対象者の続柄：〇' + '\n';
                    if(scon.OkyakusamaJizenSurveyTaishoshaFullNameKa__c) annaiInfo += '対象者フルネームカナ：〇' + '\n';
                    if(scon.OkyakusamaJizenSurveyTaishoshaFullName__c) annaiInfo += '対象者フルネーム漢字：〇' + '\n';
                }
                if(!String.isBlank(scon.OkyakusamaSurveywari__c)) annaiInfo += 'アンケート割：' + scon.OkyakusamaSurveywari__c + '\n';
                if(!String.isBlank(scon.OkyakusamaShiryoSeikyuYohi__c)) annaiInfo += '資料請求：' + scon.OkyakusamaShiryoSeikyuYohi__c + '\n';
                if(!String.isBlank(scon.OkyakusamaSmsShisakuYohi__c)) annaiInfo += 'SMS(施策)：' + scon.OkyakusamaSmsShisakuYohi__c + '\n';
                if(!String.isBlank(scon.OkyakusamaTaimenSodanYohi__c)) annaiInfo += '対面相談：' + scon.OkyakusamaTaimenSodanYohi__c + '\n';
                if(String.isNotBlank(annaiInfo.replace('\n', ''))) contactText += '<案内内容>' + '\n' + annaiInfo + '\n';

                String annai2Info = '';
                if(!String.isBlank(scon.OkyakusamaOsoshiYoyaku__c)) annai2Info += 'お葬式予約：' + scon.OkyakusamaOsoshiYoyaku__c + '\n';
                if(!String.isBlank(scon.OkyakusamaKeisatsuAnken__c)) annai2Info += '警察案件：' + scon.OkyakusamaKeisatsuAnken__c + '\n';
                if(!String.isBlank(scon.OkyakusamaSosaiFujo__c)) annai2Info += '葬祭扶助：' + scon.OkyakusamaSosaiFujo__c + '\n';
                if(!String.isBlank(scon.OkyakusamaHenkinHosho__c)) annai2Info += '返金保証：' + scon.OkyakusamaHenkinHosho__c + '\n';
                if(String.isNotBlank(annai2Info.replace('\n', ''))) contactText += '<案内2>' + '\n' + annai2Info + '\n';

                String tokkiInfo = '';
                if(scon.OkyakusamaClaim__c || 
                    scon.OkyakusamaOndokanTakame__c || 
                    !String.isBlank(scon.OkyakusamaTokkijikoComment__c)
                ){
                    if(scon.OkyakusamaClaim__c) tokkiInfo += 'クレーム';
                    if(scon.OkyakusamaOndokanTakame__c) tokkiInfo += ' 温度感高め';
                    tokkiInfo += '\n';
                    if(!String.isBlank(scon.OkyakusamaTokkijikoComment__c)) tokkiInfo += scon.OkyakusamaTokkijikoComment__c + '\n';
                }
                if(String.isNotBlank(tokkiInfo.replace('\n', ''))) contactText += '<特記事項>' + '\n' + tokkiInfo + '\n';
            }
            else{
                String taiwashaInfo = '';
                if(!String.isBlank(scon.SogishaTaiosha__c)){
                    if(scon.SogishaTaiosha__c == '決定葬儀社'){
                        if(!String.isBlank(scon.SogishaKetteiSogishaName__c)) taiwashaInfo += '決定葬儀社(' + scon.SogishaKetteiSogishaName__c;
                        if(!String.isBlank(scon.SogishaKetteiSogishaTantosha__c)) taiwashaInfo += ' 担当者：' + scon.SogishaKetteiSogishaTantosha__c;
                    }
                    if(scon.SogishaTaiosha__c == '決定葬儀社以外'){
                        if(!String.isBlank(scon.SogishaKetteiSogishaIgaiName__c)) taiwashaInfo += '決定葬儀社以外(' + scon.SogishaKetteiSogishaIgaiName__c;
                        if(!String.isBlank(scon.SogishaKetteiSogishaIgaiTantosha__c)) taiwashaInfo += ' 担当者：' + scon.SogishaKetteiSogishaIgaiTantosha__c;
                    }
                    taiwashaInfo += ')';
                }
                if(!String.isBlank(scon.SogishaJuhasshinJokyo__c)){
                    if(scon.SogishaJuhasshinJokyo__c == '受電') taiwashaInfo += 'より' + scon.SogishaJuhasshinJokyo__c;
                    if(scon.SogishaJuhasshinJokyo__c == '架電') taiwashaInfo += 'に' + scon.SogishaJuhasshinJokyo__c + '\n';
                }
                if(!String.isBlank(scon.SogishaTel__c)) taiwashaInfo += '電話番号：' + scon.SogishaTel__c + '\n';
                if(String.isNotBlank(taiwashaInfo.replace('\n', ''))) contactText += '<対話者情報>' + '\n' + taiwashaInfo + '\n';

                String annnaiJudenInfo = '';
                if(String.isNotBlank(scon.SogishaOmukaeJikan__c)) annnaiJudenInfo += 'お迎え時間：' + scon.SogishaOmukaeJikan__c + '\n';
                if(scon.SogishaTsuyaDate__c != null) {
                    annnaiJudenInfo += '通夜日付：' + scon.SogishaTsuyaDate__c;
                    if(scon.SogishaTsuyaHour__c != null) annnaiJudenInfo += ' ' + scon.SogishaTsuyaHour__c + '時';
                    if(scon.SogishaTsuyaMinute__c != null) annnaiJudenInfo += ' ' + scon.SogishaTsuyaMinute__c + '分';
                    annnaiJudenInfo += '\n';
                }
                if(scon.SogishaKokubetsushikiDate__c != null) {
                    annnaiJudenInfo += '告別式日付：' + scon.SogishaKokubetsushikiDate__c;
                    if(scon.SogishaKokubetsushikiHour__c != null) annnaiJudenInfo += ' ' + scon.SogishaKokubetsushikiHour__c + '時';
                    if(scon.SogishaKokubetsushikiMinute__c != null) annnaiJudenInfo += ' ' + scon.SogishaKokubetsushikiMinute__c + '分';
                    annnaiJudenInfo += '\n';
                }
                if(scon.SogishaKasoDate__c != null) {
                    annnaiJudenInfo += '火葬日付：' + scon.SogishaKasoDate__c;
                    if(scon.SogishaKasoHour__c != null) annnaiJudenInfo += ' ' + scon.SogishaKasoHour__c + '時';
                    if(scon.SogishaKasoMinute__c != null) annnaiJudenInfo += ' ' + scon.SogishaKasoMinute__c + '分';
                    annnaiJudenInfo += '\n';
                }
                if(String.isNotBlank(scon.SogishaPlan__c)) annnaiJudenInfo += 'プラン：' + scon.SogishaPlan__c + '\n';
                if(String.isNotBlank(scon.SogishaShiharaiHoho__c)) annnaiJudenInfo += '支払方法：' + scon.SogishaShiharaiHoho__c + '\n';
                if(String.isNotBlank(scon.SogishaSoryoTehai__c)) annnaiJudenInfo += '僧侶手配：' + scon.SogishaSoryoTehai__c + '\n';
                if(String.isNotBlank(scon.SogishaSonotaShinchoku__c)) annnaiJudenInfo += 'その他進捗：' + scon.SogishaSonotaShinchoku__c + '\n';
                if(String.isNotBlank(scon.SogishaMitsumorishoSofuRenraku__c)) annnaiJudenInfo += '見積書送付連絡：' + scon.SogishaMitsumorishoSofuRenraku__c + '\n';
                if(String.isNotBlank(scon.SogishaSeikyushoSofuRenraku__c)) annnaiJudenInfo += '請求書送付連絡：' + scon.SogishaSeikyushoSofuRenraku__c + '\n';
                if(String.isNotBlank(scon.SogishaTesuryoKingaku__c)) annnaiJudenInfo += '手数料金額：' + scon.SogishaTesuryoKingaku__c + '\n';
                if(String.isNotBlank(scon.SogishaTeikeiKaijoKibo__c)) annnaiJudenInfo += '提携解除希望：' + scon.SogishaTeikeiKaijoKibo__c + '\n';
                if(String.isNotBlank(scon.SogishaPlanToiawase__c)) annnaiJudenInfo += 'プラン問合せ：' + scon.SogishaPlanToiawase__c + '\n';
                if(String.isNotBlank(scon.SogishaPanfuSofuIrai__c)) {
                    annnaiJudenInfo += 'パンフ送付依頼：' + scon.SogishaPanfuSofuIrai__c + '\n';
                    if(String.isNotBlank(scon.SogishaSofubutsu__c)) annnaiJudenInfo += '送付物：' + scon.SogishaSofubutsu__c + '\n';
                    if(String.isNotBlank(scon.SogishaPanfuAtena__c)) annnaiJudenInfo += '宛先：' + scon.SogishaPanfuAtena__c + '\n';
                    if(String.isNotBlank(scon.SogishaPanfuAtena__c)) annnaiJudenInfo += '宛名：' + scon.SogishaPanfuAtena__c + '\n';
                }
                if(String.isNotBlank(scon.SogishaTaimenSodanKekka__c)) annnaiJudenInfo += '対面相談結果：' + scon.SogishaTaimenSodanKekka__c + '\n';
                if(String.isNotBlank(annnaiJudenInfo.replace('\n', ''))) contactText += '<案内内容(受電)>' + '\n' + annnaiJudenInfo + '\n';

                String annnaiKadenInfo = '';
                if(String.isNotBlank(scon.SogishaSogishaTehai__c)) annnaiKadenInfo += '葬儀社手配：' + scon.SogishaSogishaTehai__c + '\n';
                if(String.isNotBlank(scon.SogishaAkijokyoKakunin__c)) annnaiKadenInfo += '空き状況確認：' + scon.SogishaAkijokyoKakunin__c + '\n';
                if(String.isNotBlank(scon.SogishaMitsumorishoSaisoku__c)) {
                    annnaiKadenInfo += '見積書催促：' + scon.SogishaMitsumorishoSaisoku__c + '\n';
                    if(String.isNotBlank(scon.SogishaUchiawaseYotei__c)) annnaiKadenInfo += '(' + scon.SogishaUchiawaseYotei__c + ')';
                }
                if(String.isNotBlank(scon.SogishaMitsumorishoNaiyo__c)) annnaiKadenInfo += '見積書内容：' + scon.SogishaMitsumorishoNaiyo__c + '\n';
                if(String.isNotBlank(scon.SogishaTaimenSodanIrai__c)) annnaiKadenInfo += '対面相談依頼：' + scon.SogishaTaimenSodanIrai__c + '\n';
                if(String.isNotBlank(scon.SogishaAtooi__c)) annnaiKadenInfo += '後追い：' + scon.SogishaAtooi__c + '\n';
                if(String.isNotBlank(annnaiKadenInfo.replace('\n', ''))) contactText += '<案内内容(架電)>' + '\n' + annnaiKadenInfo + '\n';

                String tokkiInfo = '';
                if(scon.SogishaClaim__c || 
                    scon.SogishaOndokanTakame__c || 
                    !String.isBlank(scon.SogishaTokkijikoComment__c)
                ){
                    if(scon.SogishaClaim__c) tokkiInfo += 'クレーム';
                    if(scon.SogishaOndokanTakame__c) tokkiInfo += ' 温度感高め';
                    tokkiInfo += '\n';
                    if(!String.isBlank(scon.SogishaTokkijikoComment__c)) tokkiInfo += scon.SogishaTokkijikoComment__c + '\n';
                }
                if(String.isNotBlank(tokkiInfo.replace('\n', ''))) contactText += '<特記事項>' + '\n' + tokkiInfo + '\n';

                String sogishaOrikaeshiInfo = '';
                if(String.isNotBlank(scon.SogishaOrikaeshiNaiyo__c)) sogishaOrikaeshiInfo += '折返し内容：' + scon.SogishaOrikaeshiNaiyo__c + '\n';
                if(String.isNotBlank(scon.SogishaOrikaeshiTantoshaName__c)) sogishaOrikaeshiInfo += '担当者名：' + scon.SogishaOrikaeshiTantoshaName__c + '\n';
                if(String.isNotBlank(scon.SogishaOrikaeshiRenrakusaki__c)) sogishaOrikaeshiInfo += '連絡先：' + scon.SogishaOrikaeshiRenrakusaki__c + '\n';
                if(String.isNotBlank(scon.SogishaOrikaeshiRenrakuNichijiShitei__c)) {
                    sogishaOrikaeshiInfo += '日時指定：' + scon.SogishaOrikaeshiRenrakuNichijiShitei__c;
                    if(String.isNotBlank(scon.SogishaOrikaeshiRenrakuNichiji__c)) sogishaOrikaeshiInfo += '(' + scon.SogishaOrikaeshiRenrakuNichiji__c + ')';
                    sogishaOrikaeshiInfo += '\n';
                }
                if(String.isNotBlank(sogishaOrikaeshiInfo.replace('\n', ''))) contactText += '<葬儀社への折返し連絡先>' + '\n' + sogishaOrikaeshiInfo + '\n';
                
                if(!String.isBlank(scon.SogishaFreeComment__c)) contactText += '<フリーコメント>' + '\n' + scon.SogishaFreeComment__c + '\n';
            }
        }

        String strAnkenShubetsu = '';
        if(ota.KeisatsuAnken__c || ota.SosaiFujo__c || ota.TashaAnchi__c || ota.TaijiAnken__c){
            if(ota.KeisatsuAnken__c){
                strAnkenShubetsu +=  '■ 警察案件 ■ ';
            }
            if(ota.SosaiFujo__c){
                strAnkenShubetsu +=  '■ 葬祭扶助 ■ ';
            }
            if(ota.TashaAnchi__c){
                strAnkenShubetsu +=  '■ 他社安置 ■ ';
            }
            if(ota.TaijiAnken__c){
                strAnkenShubetsu +=  '■ 胎児案件 ■ ';
            }
            strAnkenShubetsu +=  '\n';
        }

        String strSodansha = '';
        if(opp.Account.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId()){
            if(!String.isBlank(ota.SodanshaSeiKana__c)){
                strSodansha += ota.SodanshaSeiKana__c;
            }
            if(!String.isBlank(ota.SodanshaMeiKana__c)){
                strSodansha += ' ' + ota.SodanshaMeiKana__c;
            }
            if(!String.isBlank(ota.SodanshaSei__c)){
                strSodansha += '  ' + ota.SodanshaSei__c;
            }
            if(!String.isBlank(ota.SodanshaMei__c)){
                strSodansha += ' ' + ota.SodanshaMei__c;
            }

            if(!String.isBlank(ota.SodanshaSeibetsu__c)){
                strSodansha += '(' + ota.SodanshaSeibetsu__c + ')';
            }

            if(strSodansha != ''){
                strSodansha = '相談者 ： ' + strSodansha + '\n';
            }
        }
        else if(ota.SodanshaSeiKana__c != opp.Account.LastNameFurigana__pc || 
            ota.SodanshaMeiKana__c != opp.Account.FirstNameFurigana__pc || 
            ota.SodanshaSei__c != opp.Account.LastName || 
            ota.SodanshaMei__c != opp.Account.FirstName || 
            ota.SodanshaSeibetsu__c != opp.Account.Gender__pc){
            strSodansha = '相談者 ： ';
            if(!String.isBlank(ota.SodanshaSeiKana__c)){
                strSodansha += ota.SodanshaSeiKana__c;
            }
            if(!String.isBlank(ota.SodanshaMeiKana__c)){
                strSodansha += ' ' + ota.SodanshaMeiKana__c;
            }
            if(!String.isBlank(ota.SodanshaSei__c)){
                strSodansha += '  ' + ota.SodanshaSei__c;
            }
            if(!String.isBlank(ota.SodanshaMei__c)){
                strSodansha += ' ' + ota.SodanshaMei__c;
            }

            if(!String.isBlank(ota.SodanshaSeibetsu__c)){
                strSodansha += '(' + ota.SodanshaSeibetsu__c + ')';
            }

            if(!String.isBlank(opp.Account.LastNameFurigana__pc) || 
                !String.isBlank(opp.Account.FirstNameFurigana__pc) || 
                !String.isBlank(opp.Account.LastName) || 
                !String.isBlank(opp.Account.FirstName) || 
                !String.isBlank(opp.Account.Gender__pc)){
                strSodansha += ' (変更前 ';
                strSodansha += '相談者 ： ' + strNullChange(opp.Account.LastNameFurigana__pc);
                strSodansha += ' ' + strNullChange(opp.Account.FirstNameFurigana__pc);
                strSodansha += '  ' + strNullChange(opp.Account.LastName);
                strSodansha += ' ' + strNullChange(opp.Account.FirstName);
                if(!String.isBlank(opp.Account.Gender__pc)){
                    strSodansha += '(' + strNullChange(opp.Account.Gender__pc) + ')';
                }
                strSodansha += ')';
            }
            strSodansha += '\n';
        }

        if(ota.BenefitOneID__c != opp.BenefitOneID__c ||
            ota.PostalClubKaiinBango__c != opp.PostalClubKaiinBango__c){
            if(ota.BenefitOneID__c != opp.BenefitOneID__c){
                if(ota.BenefitOneID__c != opp.BenefitOneID__c){
                    if(String.isBlank(ota.BenefitOneID__c)){
                        strSodansha += '[削除]';
                    }
                    strSodansha += 'ベネフィット会員ID ： ' + strNullChange(ota.BenefitOneID__c);
                }
                if(!String.isBlank(opp.BenefitOneID__c)){
                    strSodansha += ' (変更前 ' + strNullChange(opp.BenefitOneID__c) + ')';
                }
                strSodansha += '\n';
            }

            if(ota.PostalClubKaiinBango__c != opp.PostalClubKaiinBango__c){
                if(ota.PostalClubKaiinBango__c != opp.PostalClubKaiinBango__c){
                    if(String.isBlank(ota.PostalClubKaiinBango__c)){
                        strSodansha += '[削除]';
                    }
                    strSodansha += 'ポスタルくらぶ会員番号 ： ' + strNullChange(ota.PostalClubKaiinBango__c);
                }
                if(!String.isBlank(opp.PostalClubKaiinBango__c)){
                    strSodansha += ' (変更前 ' + strNullChange(opp.PostalClubKaiinBango__c) + ')';
                }
                strSodansha += '\n';
            }
        }

        if(ota.MobilePhone__c != opp.Account.MobilePhone__c || 
            ota.Phone__c != opp.Account.Phone){
            strSodansha += '連絡先 ： ';
            Boolean mobilephonFlg = false;
            if(!String.isBlank(ota.MobilePhone__c)){
                strSodansha += ota.MobilePhone__c;
                mobilephonFlg = true;
            }
            if(!String.isBlank(ota.Phone__c)){
                if(mobilephonFlg){
                    strSodansha += ',';
                }
                strSodansha += ota.Phone__c;
            }
            mobilephonFlg = false;
            if(!String.isBlank(ota.TelNoPrimaryKubun__c)){
                strSodansha += '(' + ota.TelNoPrimaryKubun__c + '優先)';
            }
            if(opp.Account.RecordTypeId != Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId() && 
                (!String.isBlank(opp.Account.MobilePhone__c) ||
                !String.isBlank(opp.Account.Phone) || 
                !String.isBlank(opp.Account.YusenTelNoKubun__c))){
                strSodansha += ' (変更前 ';
                if(!String.isBlank(opp.Account.MobilePhone__c)){
                    strSodansha += opp.Account.MobilePhone__c;
                    mobilephonFlg = true;
                }
                if(!String.isBlank(opp.Account.Phone)){
                    if(mobilephonFlg){
                        strSodansha += ',';
                    }
                    strSodansha += opp.Account.Phone;
                }
                if(opp.Account.YusenTelNoKubun__c == '携帯1'){
                        strSodansha += '(携帯電話優先)';
                }
                else if(opp.Account.YusenTelNoKubun__c == '電話1'){
                        strSodansha += '(固定電話優先)';
                }
                    strSodansha += ')';
            }
            strSodansha += '\n';
        }

        if(ota.ShiryoseikyushaPostalCode__c != opp.Account.BillingPostalCode || 
            ota.ShiryoseikyushaStateText__c != opp.Account.BillingState || 
            ota.ShiryoseikyushaCity__c != opp.Account.BillingCity || 
            ota.ShiryoseikyushaStreet__c != opp.Account.BillingStreet){
            strSodansha += '住所 ： ';
            strSodansha += strNullChange(ota.ShiryoseikyushaPostalCode__c);
            strSodansha += strNullChange(ota.ShiryoseikyushaStateText__c);
            strSodansha += strNullChange(ota.ShiryoseikyushaCity__c);
            strSodansha += strNullChange(ota.ShiryoseikyushaStreet__c);

            if(opp.Account.RecordTypeId != Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId() && 
                (!String.isBlank(opp.Account.BillingPostalCode) || 
                !String.isBlank(opp.Account.BillingState) || 
                !String.isBlank(opp.Account.BillingCity) || 
                !String.isBlank(opp.Account.BillingStreet))){
                strSodansha += ' (変更前 ';
                strSodansha += strNullChange(opp.Account.BillingPostalCode);
                strSodansha += strNullChange(opp.Account.BillingState);
                strSodansha += strNullChange(opp.Account.BillingCity);
                strSodansha += strNullChange(opp.Account.BillingStreet);
                strSodansha += ')';
            }
            strSodansha += '\n';
        }

        String strTaishosha = '';
        //issues3806--Start--
        if(ota.ToiawaseKiinsha__c != opp.ToiawaseKiinsha__c){
            strTaishosha += '問い合わせ起因者（初回） ： ' + strNullChange(ota.ToiawaseKiinsha__c) ;
            if(!String.isBlank(opp.ToiawaseKiinsha__c) ){
                strTaishosha += ' (変更前 問い合わせ起因者（初回）： ' + strNullChange(opp.ToiawaseKiinsha__c);
            }
            strTaishosha += '\n';
        }
        //issues3806--End--

        if(ota.TaishoshaSeiKana__c != opp.SimpleYasugoRef__r.TaishoshaRef__r.LastNameFurigana__pc || 
            ota.TaishoshaMeiKana__c != opp.SimpleYasugoRef__r.TaishoshaRef__r.FirstNameFurigana__pc || 
            ota.TaishoshaSei__c != opp.SimpleYasugoRef__r.TaishoshaRef__r.LastName || 
            ota.TaishoshaMei__c != opp.SimpleYasugoRef__r.TaishoshaRef__r.FirstName || 
            ota.TaishoshaSeibetsu__c != opp.SimpleYasugoRef__r.TaishoshaRef__r.Gender__pc){
            strTaishosha += '対象者 ： ';
            strTaishosha += strNullChange(ota.TaishoshaSeiKana__c);
            strTaishosha += ' ' + strNullChange(ota.TaishoshaMeiKana__c);
            strTaishosha += '  ' + strNullChange(ota.TaishoshaSei__c);
            strTaishosha += ' ' + strNullChange(ota.TaishoshaMei__c);

            if(!String.isBlank(ota.TaishoshaSeibetsu__c) || 
                !String.isBlank(ota.ZokugaraSodanshaNitottenoTaishosha__c)){
                strTaishosha += '(';
                Boolean taishoshaSeibetsuFlg = false;
                if(!String.isBlank(ota.TaishoshaSeibetsu__c)){
                    strTaishosha += ota.TaishoshaSeibetsu__c;
                    taishoshaSeibetsuFlg = true;
                }
                
                if(!String.isBlank(ota.ZokugaraSodanshaNitottenoTaishosha__c)){
                    if(taishoshaSeibetsuFlg){
                        strTaishosha += ',';
                    }
                    strTaishosha += ota.ZokugaraSodanshaNitottenoTaishosha__c;
                }
                strTaishosha += ')';
            }

            if(!String.isBlank(opp.SimpleYasugoRef__r.TaishoshaRef__r.LastNameFurigana__pc) || 
                !String.isBlank(opp.SimpleYasugoRef__r.TaishoshaRef__r.FirstNameFurigana__pc) || 
                !String.isBlank(opp.SimpleYasugoRef__r.TaishoshaRef__r.LastName) || 
                !String.isBlank(opp.SimpleYasugoRef__r.TaishoshaRef__r.FirstName) || 
                !String.isBlank(opp.SimpleYasugoRef__r.TaishoshaRef__r.Gender__pc)){
                strTaishosha += ' (変更前 ';
                strTaishosha += strNullChange(opp.SimpleYasugoRef__r.TaishoshaRef__r.LastNameFurigana__pc);
                strTaishosha += ' ' + strNullChange(opp.SimpleYasugoRef__r.TaishoshaRef__r.FirstNameFurigana__pc);
                strTaishosha += '  ' + strNullChange(opp.SimpleYasugoRef__r.TaishoshaRef__r.LastName);
                strTaishosha += ' ' + strNullChange(opp.SimpleYasugoRef__r.TaishoshaRef__r.FirstName);
                if(!String.isBlank(opp.SimpleYasugoRef__r.ZokugaraSodanshaNitottenoTaishosha__c)){
                    strTaishosha += '(';
                    Boolean taishoshaSeibetsuFlg = false;
                    if(!String.isBlank(opp.SimpleYasugoRef__r.TaishoshaRef__r.Gender__pc)){
                        strTaishosha += opp.SimpleYasugoRef__r.TaishoshaRef__r.Gender__pc;
                        taishoshaSeibetsuFlg = true;
                    }
                    if(!String.isBlank(opp.SimpleYasugoRef__r.ZokugaraSodanshaNitottenoTaishosha__c)){
                        if(taishoshaSeibetsuFlg){
                            strTaishosha += ',';
                        }
                        strTaishosha += opp.SimpleYasugoRef__r.ZokugaraSodanshaNitottenoTaishosha__c;
                    }
                    strTaishosha += ')';
                }
            }
            strTaishosha += '\n';
        }

        if(ota.SeinengappiSeireki__c != opp.SimpleYasugoRef__r.TaishoshaRef__r.PersonBirthdate){
            if(ota.SeinengappiSeireki__c == null){
                strTaishosha += '[削除]生年月日 ： ';
            }
            else{
                strTaishosha += '生年月日 ： ' + ota.SeinengappiSeireki__c.format() + ' (' + ota.SeinengappiWareki__c + ')';
            }

            if(opp.SimpleYasugoRef__r.TaishoshaRef__r.PersonBirthdate != null){
                strTaishosha += ' (変更前 ' + opp.SimpleYasugoRef__r.TaishoshaRef__r.PersonBirthdate.format() + ' (' + JpCalendar.convertSeirekiToWareki(opp.SimpleYasugoRef__r.TaishoshaRef__r.PersonBirthdate) + '))';
            }
            strTaishosha += '\n';
        }
        if(ota.BotsunengappiSeireki__c !=  opp.SimpleYasugoRef__r.TaishoshaRef__r.PersonDeathDate__pc){
            if(ota.BotsunengappiSeireki__c == null){
                strTaishosha += '[削除]没年月日 ： ';
            }
            else{
                strTaishosha += '没年月日 ： ' + ota.BotsunengappiSeireki__c.format() + ' (' + ota.BotsunengappiWareki__c + ')';
            }

            if(opp.SimpleYasugoRef__r.TaishoshaRef__r.PersonDeathDate__pc != null){
                strTaishosha += ' (変更前 ' + opp.SimpleYasugoRef__r.TaishoshaRef__r.PersonDeathDate__pc.format() + ' (' + JpCalendar.convertSeirekiToWareki(opp.SimpleYasugoRef__r.TaishoshaRef__r.PersonDeathDate__pc) + '))';
            }
            strTaishosha += '\n';
        }

        String omukaesaki = '';
        String omukaesakiOpp = strNullChange(opp.SimpleYasugoRef__r.OmukaeSakiStreet__c);
        if(ota.OmukaeSakiName__c != opp.SimpleYasugoRef__r.OmukaeSakiName__c){
            if(ota.OmukaeSakiName__c == null){
                omukaesaki += '[削除]';
            }
            omukaesaki += 'お迎え先名称 ： ' + strNullChange(ota.OmukaeSakiName__c);
            if(opp.SimpleYasugoRef__r.OmukaeSakiName__c != null){
                omukaesaki += ' (変更前 ' + opp.SimpleYasugoRef__r.OmukaeSakiName__c + ')';
            }
            omukaesaki += '\n';
        }
        if(strNullChange(ota.OmukaeSakiJusho__c) != omukaesakiOpp){
            if(ota.OmukaeSakiJusho__c == null){
                omukaesaki += '[削除]';
            }
            omukaesaki += 'お迎え先住所 ： ' + strNullChange(ota.OmukaeSakiJusho__c);
            if(!String.isBlank(omukaesakiOpp)){
                omukaesaki += ' (変更前 ' + omukaesakiOpp + ')';
            }
            omukaesaki += '\n';
        }

        String strPlan = '';
        if(strNullChange(ota.KiboKeishiki__c) != opp.SimpleYasugoRef__r.SogiPlanUketsuke__c){
            if(String.isBlank(ota.KiboKeishiki__c)){
                strPlan += '[削除]';
            }
            strPlan += '希望プラン ： ' + strNullChange(ota.KiboKeishiki__c);
            if(!String.isBlank(opp.SimpleYasugoRef__r.SogiPlanUketsuke__c)){
                strPlan += ' (変更前 ' + opp.SimpleYasugoRef__r.SogiPlanUketsuke__c + ')';
            }
            strPlan += '\n';
        }
        if(ota.ButsuguNashiKibo__c != opp.SimpleYasugoRef__r.ButsuguNashiKibo__c){
            if(ota.ButsuguNashiKibo__c == null){
                strPlan += '[削除]';
            }
            strPlan += '仏具なし希望 ： ' + strNullChange(ota.ButsuguNashiKibo__c);
            if(!String.isBlank(opp.SimpleYasugoRef__r.ButsuguNashiKibo__c)){
                strPlan += ' (変更前 ' + opp.SimpleYasugoRef__r.ButsuguNashiKibo__c + ')';
            }
            strPlan += '\n';
        }
        if(ota.SaidanKibo__c != opp.SimpleYasugoRef__r.SaidanKibo__c){
            if(ota.SaidanKibo__c == null){
                strPlan += '[削除]';
            }
            strPlan += '祭壇希望 ： ' + strNullChange(ota.SaidanKibo__c);
            if(!String.isBlank(opp.SimpleYasugoRef__r.SaidanKibo__c)){
                strPlan += ' (変更前 ' + opp.SimpleYasugoRef__r.SaidanKibo__c + ')';
            }
            strPlan += '\n';
        }
        if(ota.KanjoHanatabaKibo__c != opp.SimpleYasugoRef__r.KanjoHanatabaKibo__c){
            if(ota.KanjoHanatabaKibo__c == null){
                strPlan += '[削除]';
            }
            strPlan += '棺上花束希望 ： ' + strNullChange(ota.KanjoHanatabaKibo__c);
            if(!String.isBlank(opp.SimpleYasugoRef__r.KanjoHanatabaKibo__c)){
                strPlan += ' (変更前 ' + opp.SimpleYasugoRef__r.KanjoHanatabaKibo__c + ')';
            }
            strPlan += '\n';
        }
        if(ota.KagobanaKibo__c != opp.SimpleYasugoRef__r.KagobanaKibo__c){
            if(ota.KagobanaKibo__c == null){
                strPlan += '[削除]';
            }
            strPlan += 'お別れ花希望 ： ' + strNullChange(ota.KagobanaKibo__c);
            if(!String.isBlank(opp.SimpleYasugoRef__r.KagobanaKibo__c)){
                strPlan += ' (変更前 ' + opp.SimpleYasugoRef__r.KagobanaKibo__c + ')';
            }
            strPlan += '\n';
        }
        if(ota.MakurabanaKibo__c != opp.SimpleYasugoRef__r.MakurabanaKibo__c){
            if(ota.MakurabanaKibo__c == null){
                strPlan += '[削除]';
            }
            strPlan += '枕花希望 ： ' + strNullChange(ota.MakurabanaKibo__c);
            if(!String.isBlank(opp.SimpleYasugoRef__r.MakurabanaKibo__c)){
                strPlan += ' (変更前 ' + opp.SimpleYasugoRef__r.MakurabanaKibo__c + ')';
            }
            strPlan += '\n';
        }

        if(ota.SanretsushaShinzokuFrom__c != opp.SimpleYasugoRef__r.NumberRelatives__c || 
            ota.SanretsushaShinzokuTo__c != opp.SimpleYasugoRef__r.SanretsushaShinzokuTo__c || 
            ota.SanretsushaShinzokuigaiFrom__c != opp.SimpleYasugoRef__r.MournersNumber__c || 
            ota.SanretsushaShinzokuigaiTo__c != opp.SimpleYasugoRef__r.SanretsushaShinzokuigaiTo__c){
            strPlan += '親族 ： ';
            if(ota.SanretsushaShinzokuFrom__c != null){
                strPlan += ota.SanretsushaShinzokuFrom__c;
            }
            strPlan += '～';
            if(ota.SanretsushaShinzokuTo__c != null){
                strPlan += ota.SanretsushaShinzokuTo__c;
            }
            strPlan += '名　親族以外 ： ';
            if(ota.SanretsushaShinzokuigaiFrom__c != null){
                strPlan += ota.SanretsushaShinzokuigaiFrom__c;
            }
            strPlan += '～';
            if(ota.SanretsushaShinzokuigaiTo__c != null){
                strPlan += ota.SanretsushaShinzokuigaiTo__c;
            }
            strPlan += '名';

            if(opp.SimpleYasugoRef__r.NumberRelatives__c != null || 
                opp.SimpleYasugoRef__r.SanretsushaShinzokuTo__c != null || 
                opp.SimpleYasugoRef__r.MournersNumber__c != null || 
                opp.SimpleYasugoRef__r.SanretsushaShinzokuigaiTo__c != null){
                strPlan += ' (変更前 ';
                if(opp.SimpleYasugoRef__r.NumberRelatives__c != null){
                    strPlan += opp.SimpleYasugoRef__r.NumberRelatives__c;
                }
                strPlan += '～';
                if(opp.SimpleYasugoRef__r.SanretsushaShinzokuTo__c != null){
                    strPlan += opp.SimpleYasugoRef__r.SanretsushaShinzokuTo__c;
                }
                strPlan += '名 親族以外 ： ';
                if(opp.SimpleYasugoRef__r.MournersNumber__c != null){
                    strPlan += opp.SimpleYasugoRef__r.MournersNumber__c;
                }
                strPlan += '～';
                if(opp.SimpleYasugoRef__r.SanretsushaShinzokuigaiTo__c != null){
                    strPlan += opp.SimpleYasugoRef__r.SanretsushaShinzokuigaiTo__c;
                }
                strPlan += '名';
            }
            strPlan += '\n';
        }

        if(ota.KiboGoanchisaki__c != opp.SimpleYasugoRef__r.KiboGoanchisaki__c){
            if(String.isBlank(ota.KiboGoanchisaki__c)){
                strPlan += '[削除]';
            }
            strPlan += '希望ご安置先 ： ' + strNullChange(ota.KiboGoanchisaki__c);
            if(!String.isBlank(opp.SimpleYasugoRef__r.KiboGoanchisaki__c)){
                strPlan += ' (変更前 ' + strNullChange(opp.SimpleYasugoRef__r.KiboGoanchisaki__c) + ')';
            }
            strPlan += '\n';
        }

        if(ota.GoanchisakiJusho__c != opp.SimpleYasugoRef__r.GoanchisakiJusho__c){
            if(String.isBlank(ota.GoanchisakiJusho__c)){
                strPlan += '[削除]';
            }
            strPlan += 'ご安置先住所 ： ' + strNullChange(ota.GoanchisakiJusho__c);
            if(!String.isBlank(opp.SimpleYasugoRef__r.GoanchisakiJusho__c)){
                strPlan += ' (変更前 ' + strNullChange(opp.SimpleYasugoRef__r.GoanchisakiJusho__c) + ')';
            }
            strPlan += '\n';
        }

        if(ota.BodaijinoUmu__c != opp.SimpleYasugoRef__r.TaishoshaRef__r.BodaijinoUmu__c || 
            ota.HakaUmuKubun__c != opp.SimpleYasugoRef__r.TaishoshaRef__r.HakaUmuKubun__c){
            strPlan += '菩提寺 ： ' + strNullChange(ota.BodaijinoUmu__c) + '　' + 
                        ' お墓 ： ' + strNullChange(ota.HakaUmuKubun__c);
            if(!String.isBlank(opp.SimpleYasugoRef__r.TaishoshaRef__r.BodaijinoUmu__c) || 
                !String.isBlank(opp.SimpleYasugoRef__r.TaishoshaRef__r.HakaUmuKubun__c)){
                strPlan += ' (変更前 菩提寺 ： ' + strNullChange(opp.SimpleYasugoRef__r.TaishoshaRef__r.BodaijinoUmu__c) + 
                        ' お墓 ： ' + strNullChange(opp.SimpleYasugoRef__r.TaishoshaRef__r.HakaUmuKubun__c) + ')';
            }
            strPlan += '\n';
        }

        if(ota.Syushi__c != opp.SimpleYasugoRef__r.TaishoshaRef__r.Syushi__c || 
            ota.Syuha__c != opp.SimpleYasugoRef__r.TaishoshaRef__r.Syuha__c){
            strPlan += '宗教/宗旨 ： ' + strNullChange(ota.Syushi__c) + '　' + 
                        '宗派 ： ' + strNullChange(ota.Syuha__c);
            if(!String.isBlank(opp.SimpleYasugoRef__r.TaishoshaRef__r.Syushi__c) || 
                !String.isBlank(opp.SimpleYasugoRef__r.TaishoshaRef__r.Syuha__c)){
                strPlan += ' (変更前 宗教/宗旨 ： ' + strNullChange(opp.SimpleYasugoRef__r.TaishoshaRef__r.Syushi__c) + '　' + 
                            ' 宗派 ： ' + strNullChange(opp.SimpleYasugoRef__r.TaishoshaRef__r.Syuha__c) + ')';
            }
            strPlan += '\n';
        }

        if(ota.MonkArrangements__c != opp.SimpleYasugoRef__r.MonkArrangements__c || 
            ota.Kaimyojuyo__c != opp.SimpleYasugoRef__r.Kaimyojuyo__c || 
            ota.Kaimyo__c != opp.SimpleYasugoRef__r.Kaimyo__c){
            strPlan += '僧侶手配希望 ： ' + strNullChange(ota.MonkArrangements__c) + '　' + 
                        '戒名希望 ： ' + isAriNashiChange(ota.Kaimyojuyo__c) + '　' + 
                        '戒名・法名 ： ' + strNullChange(ota.Kaimyo__c);
            if(!String.isBlank(opp.SimpleYasugoRef__r.MonkArrangements__c) || 
                !String.isBlank(opp.SimpleYasugoRef__r.Kaimyojuyo__c) || 
                !String.isBlank(opp.SimpleYasugoRef__r.Kaimyo__c)){
                strPlan += ' (変更前 僧侶手配希望 ： ' + strNullChange(opp.SimpleYasugoRef__r.MonkArrangements__c) + '　' + 
                            '戒名希望 ： ' + isAriNashiChange(opp.SimpleYasugoRef__r.Kaimyojuyo__c) + '　' + 
                            '戒名・法名 ： ' + strNullChange(opp.SimpleYasugoRef__r.Kaimyo__c) + ')';
            }
            strPlan += '\n';
        }

        String strArea = '';
        if(ota.PreExecuteArea__r.Name != opp.SimpleYasugoRef__r.KiboAreaRef__r.Name){
            if(String.isBlank(ota.PreExecuteArea__r.Name)){
                strArea += '[削除]'; 
            }
            strArea += '希望地域1 ： ' + strNullChange(ota.PreExecuteArea__r.Name);
            if(!String.isBlank(opp.SimpleYasugoRef__r.KiboAreaRef__r.Name)){
                strArea += ' (変更前 ' + strNullChange(opp.SimpleYasugoRef__r.KiboAreaRef__r.Name) + ')';
            }
            strArea += '\n';
        }
        if(ota.PreExecuteArea2__r.Name != opp.SimpleYasugoRef__r.KiboArea2Ref__r.Name){
            if(String.isBlank(ota.PreExecuteArea2__r.Name)){
                strArea += '[削除]'; 
            }
            strArea += '希望地域2 ： ' + strNullChange(ota.PreExecuteArea2__r.Name);
            if(!String.isBlank(opp.SimpleYasugoRef__r.KiboArea2Ref__r.Name)){
                strArea += ' (変更前 ' + strNullChange(opp.SimpleYasugoRef__r.KiboArea2Ref__r.Name) + ')';
            }
            strArea += '\n';
        }
        if(ota.PreExecuteArea3__r.Name != opp.SimpleYasugoRef__r.KiboArea3Ref__r.Name){
            if(String.isBlank(ota.PreExecuteArea3__r.Name)){
                strArea += '[削除]'; 
            }
            strArea += '希望地域3 ： ' + strNullChange(ota.PreExecuteArea3__r.Name);
            if(!String.isBlank(opp.SimpleYasugoRef__r.KiboArea3Ref__r.Name)){
                strArea += ' (変更前 ' + strNullChange(opp.SimpleYasugoRef__r.KiboArea3Ref__r.Name) + ')';
            }
            strArea += '\n';
        }
        if(ota.PreExecuteArea4__r.Name != opp.SimpleYasugoRef__r.KiboArea4Ref__r.Name){
            if(String.isBlank(ota.PreExecuteArea4__r.Name)){
                strArea += '[削除]'; 
            }
            strArea += '希望地域4 ： ' + strNullChange(ota.PreExecuteArea4__r.Name);
            if(!String.isBlank(opp.SimpleYasugoRef__r.KiboArea4Ref__r.Name)){
                strArea += ' (変更前 ' + strNullChange(opp.SimpleYasugoRef__r.KiboArea4Ref__r.Name) + ')';
            }
            strArea += '\n';
        }
        if((!String.isBlank(ota.TaishoshaNoJuminhyoRef__r.Name) ||   
            !String.isBlank(Utility_Common.str(opp.SimpleYasugoRef__r.TaishoshaRef__r.JuminhyouState__c) + Utility_Common.str(opp.SimpleYasugoRef__r.TaishoshaRef__r.JuminhyouCity__c))) && 
            (ota.TaishoshaNoJuminhyoRef__r.Name != Utility_Common.str(opp.SimpleYasugoRef__r.TaishoshaRef__r.JuminhyouState__c) + Utility_Common.str(opp.SimpleYasugoRef__r.TaishoshaRef__r.JuminhyouCity__c))){
            if(String.isBlank(ota.TaishoshaNoJuminhyoRef__r.Name)){
                strArea += '[削除]'; 
            }
            strArea += '対象者の住民票 ： ' + strNullChange(ota.TaishoshaNoJuminhyoRef__r.Name);
            if(!String.isBlank(Utility_Common.str(opp.SimpleYasugoRef__r.TaishoshaRef__r.JuminhyouState__c) + Utility_Common.str(opp.SimpleYasugoRef__r.TaishoshaRef__r.JuminhyouCity__c))){
                strArea += ' (変更前 対象者の住民票 ： ' + Utility_Common.str(opp.SimpleYasugoRef__r.TaishoshaRef__r.JuminhyouState__c) + Utility_Common.str(opp.SimpleYasugoRef__r.TaishoshaRef__r.JuminhyouCity__c) + ')';
            }
            strArea += '\n';
        }
        if(ota.Ketteisha__c != opp.Ketteisha__c){
            if(String.isBlank(ota.Ketteisha__c)){
                strArea += '[削除]'; 
            }
            strArea += '決定権者 ： ' + strNullChange(ota.Ketteisha__c);
            if(!String.isBlank(opp.Ketteisha__c)){
                strArea += ' (変更前 決定権者 ： ' + strNullChange(opp.Ketteisha__c) + ')';
            }
            strArea += '\n';
        }
        if(ota.Shiharaihouhou__c != opp.KiboShiharaiHouhou__c){
            if(String.isBlank(ota.Shiharaihouhou__c)){
                strArea += '[削除]'; 
            }
            strArea += '希望支払方法 ： ' + strNullChange(ota.Shiharaihouhou__c);
            if(!String.isBlank(opp.KiboShiharaiHouhou__c)){
                strArea += ' (変更前 希望支払方法 ： ' + strNullChange(opp.KiboShiharaiHouhou__c) + ')';
            }
            strArea += '\n';
        }

        String strPost = '';
        if(ota.YusoYohiShubetsu__c != opp.SimpleYasugoRef__r.YusoYohiShubetsu__c){
            if(String.isBlank(ota.YusoYohiShubetsu__c)){
                strPost += '[削除]'; 
            }
            strPost += '郵送要否種別 ： ' + strNullChange(ota.YusoYohiShubetsu__c);
            if(!String.isBlank(opp.SimpleYasugoRef__r.YusoYohiShubetsu__c)){
                strPost += ' (変更前 郵送要否種別 ： ' + strNullChange(opp.SimpleYasugoRef__r.YusoYohiShubetsu__c) + ')';
            }
            strPost += '\n';
        }
        if(ota.MailSofuYohi__c != opp.SimpleYasugoRef__r.MailSofuYohi__c || 
            ota.ShiryoseikyushaMail__c != opp.Account.MailAddress__c){
            strPost += 'メール送付要 ： ' + isYoFuyoChange(ota.MailSofuYohi__c) + '　メールアドレス ： ' + strNullChange(ota.ShiryoseikyushaMail__c);
            if(opp.SimpleYasugoRef__r.MailSofuYohi__c && !String.isBlank(opp.Account.MailAddress__c)){
                strPost += ' (変更前 メール送付要 ： ' + isYoFuyoChange(opp.SimpleYasugoRef__r.MailSofuYohi__c) + '　メールアドレス ： ' + strNullChange(opp.Account.MailAddress__c) + ')';
            }
            strPost += '\n';
        }
        if(ota.FaxSofuYohi__c != opp.SimpleYasugoRef__r.FaxSofuYohi__c || 
            ota.ShiroseikyushaFax__c != opp.Account.Fax){
            strPost += 'FAX送付要 ： ' + isYoFuyoChange(ota.FaxSofuYohi__c) + '　FAX番号 ： ' + strNullChange(ota.ShiroseikyushaFax__c);
            if(opp.SimpleYasugoRef__r.FaxSofuYohi__c && !String.isBlank(opp.Account.Fax)){
                strPost += ' (変更前 FAX送付要 ： ' + isYoFuyoChange(opp.SimpleYasugoRef__r.FaxSofuYohi__c) + '　FAX番号 ： ' + strNullChange(opp.Account.Fax) + ')';
            }
            strPost += '\n';
        }

        String strMember = '';
        if(ota.MemberSeidoGoannaiJokyo__c != opp.Account.MemberSeidoGoannaiJokyo__c){
            if(String.isBlank(ota.MemberSeidoGoannaiJokyo__c)){
                strMember += '[削除]'; 
            }
            strMember += 'メンバー制度ご案内状況 ： ' + strNullChange(ota.MemberSeidoGoannaiJokyo__c);
            if(!String.isBlank(opp.Account.MemberSeidoGoannaiJokyo__c)){
                strMember += ' (変更前 ： ' + strNullChange(opp.Account.MemberSeidoGoannaiJokyo__c) + ')';
            }
            strMember += '\n';
        }
        if(ota.SodanshaMemberTourokuZumi__c != opp.Account.MemberTourokuZumi__c){
            strMember += ' 事前割メンバー登録 ： ' + isSumiMiChange(ota.SodanshaMemberTourokuZumi__c);
            strMember += ' (変更前 ： ' + isSumiMiChange(opp.Account.MemberTourokuZumi__c) + ')';
            strMember += '\n';
        }

        String strChuiten = '';
        strChuiten = isChangeChuuitenAddStr(opp.SimpleYasugoRef__r.AnchiRyokin2hakuOr3haku__c
                                            ,ota.AnchiRyokin2hakuOr3haku__c 
                                            ,'安置料金2泊or3泊      ： '
                                            ,strChuiten);
        strChuiten = isChangeChuuitenAddStr(opp.SimpleYasugoRef__r.ShikijoShiyoryo2man5senOr5man__c
                                            ,ota.ShikijoShiyoryo2man5senOr5man__c 
                                            ,'式場使用料2.5万or5万  ： '
                                            ,strChuiten);
        strChuiten = isChangeChuuitenAddStr(opp.SimpleYasugoRef__r.KasobaShiyoryoPlangai__c
                                            ,ota.KasobaShiyoryoPlangai__c 
                                            ,'火葬場使用料プラン外    ： '
                                            ,strChuiten);
        strChuiten = isChangeChuuitenAddStr(opp.SimpleYasugoRef__r.HansoKyori50km__c
                                            ,ota.HansoKyori50km__c 
                                            ,'搬送距離50km         ： '
                                            ,strChuiten);
        strChuiten = isChangeChuuitenAddStr(opp.SimpleYasugoRef__r.HansoKaisu2kaiOr3kai__c
                                            ,ota.HansoKaisu2kaiOr3kai__c 
                                            ,'搬送回数2回or3回      ： '
                                            ,strChuiten);
        strChuiten = isChangeChuuitenAddStr(opp.SimpleYasugoRef__r.ChokusoPlanMenkaiFuka__c
                                            ,ota.ChokusoPlanMenkaiFuka__c 
                                            ,'直葬プラン面会不可      ： '
                                            ,strChuiten);
        strChuiten = isChangeChuuitenAddStr(opp.SimpleYasugoRef__r.KeisatsuAnkenKenanryo__c
                                            ,ota.KeisatsuAnkenKenanryo__c 
                                            ,'警察案件検案料        ： '
                                            ,strChuiten);

        if(ota.OfferingJokyo__c != opp.OfferingJokyo__c){
            strChuiten += '\n';
            if(String.isBlank(ota.OfferingJokyo__c)){
                strChuiten += '[削除]'; 
            }
            strChuiten += 'オファリング状況 ： ' + strNullChange(ota.OfferingJokyo__c);
            if(!String.isBlank(opp.OfferingJokyo__c)){
                strChuiten += ' (変更前 オファリング状況 ： ' + strNullChange(opp.OfferingJokyo__c) + ')';
            }
            strChuiten += '\n';
        }

        String henkoKomokuRireki = '';
        if(!String.isBlank(strAnkenShubetsu)){
            henkoKomokuRireki += strAnkenShubetsu + '\n';
        }
        if(!String.isBlank(strSodansha)){
            henkoKomokuRireki += strSodansha + '\n';
        }
        if(!String.isBlank(strTaishosha)){
            henkoKomokuRireki += strTaishosha + '\n';
        }
        if(!String.isBlank(omukaesaki)){
            henkoKomokuRireki += omukaesaki + '\n';
        }
        if(!String.isBlank(strPlan)){
            henkoKomokuRireki += strPlan + '\n';
        }
        if(!String.isBlank(strArea)){
            henkoKomokuRireki += strArea + '\n';
        }
        if(!String.isBlank(strPost)){
            henkoKomokuRireki += strPost + '\n';
        }
        if(!String.isBlank(strMember)){
            henkoKomokuRireki += strMember + '\n';
        }

        if(!String.isBlank(henkoKomokuRireki)){
            contactText += '【変更項目履歴】' + '\n' + henkoKomokuRireki;
        }

        if(!String.isBlank(strChuiten)){
            contactText += strChuiten + '\n';
        }
    }
    
    public String strNullChange(String val){
        if(String.isBlank(val)) return '';
        return val;
    }

    public String isMaruBatsuChange(Boolean val){
        if(val) return '〇';
        return '✖';
    }

    public String isYoFuyoChange(Boolean val){
        if(val) return '要';
        return '不要';
    }

    public String isAriNashiChange(String val){
        if(String.isBlank(val)) return '';
        else if(val == '戒名の授与を希望する') return '有';
        return '無';
    }

    public String isSumiMiChange(Boolean val){
        if(val) return '済';
        return '未';
    }

    public void setPhase(){
        opp.StageName = beforeStageName;
        opp.SubPhase__c = beforeSubPhase;
    }

    public String msg {get;set;}
    public Boolean errFlg {get;set;}
    public Boolean alertFlg {get;set;}
    public Boolean saveFlg {get;set;}

    public void oppUpdate(){
        String isToDoCreate = Apexpages.currentPage().getParameters().get('isToDoCreate');
        errFlg = false;
        alertFlg = false;
        msg = '';

        Savepoint sp = Database.setSavepoint();

        try{

            delete ota.OtaiShienSogiRyokinHyos__r;
            
            ota.IchijiHozonFlg__c = false;
            update ota;

            /*if(!String.isBlank(ota.SodanshaSeiKana__c)){
                Account sodansha = new Account();
                sodansha.Id = ota.SodanshaRef__c;
                sodansha.LastName = ota.SodanshaSei__c;
                sodansha.LastNameFurigana__pc = ota.SodanshaSeiKana__c;
                sodansha.FirstName = ota.SodanshaMei__c;
                sodansha.FirstNameFurigana__pc = ota.SodanshaMeiKana__c;
                sodansha.Gender__pc = ota.SodanshaSeibetsu__c;
                sodansha.MobilePhone__c = ota.MobilePhone__c;
                sodansha.Phone = ota.Phone__c;
                if(ota.TelNoPrimaryKubun__c == '携帯電話'){
                    sodansha.YusenTelNoKubun__c = '携帯1';
                }
                else if(ota.TelNoPrimaryKubun__c == '固定電話'){
                    sodansha.YusenTelNoKubun__c = '電話1';
                }
                sodansha.MailAddress__c = ota.ShiryoseikyushaMail__c;
                sodansha.Fax = ota.ShiroseikyushaFax__c;
                sodansha.BillingPostalCode = ota.ShiryoseikyushaPostalCode__c;
                sodansha.BillingState = ota.ShiryoseikyushaState__c;
                sodansha.BillingCity = ota.ShiryoseikyushaCity__c;
                sodansha.BillingStreet = ota.ShiryoseikyushaStreet__c;
                sodansha.MemberTourokuZumi__c = ota.SodanshaMemberTourokuZumi__c;

                Database.SaveResult saveResult = Database.update(sodansha, false);
                if (!saveResult.isSuccess()) {
                    for (Database.Error error : saveResult.getErrors()) {
                        if (error instanceof Database.DuplicateError) {
                            msg += '相談者情報が重複しています。マージをお願いします。';
                            Database.DMLOptions dml = new Database.DMLOptions();
                            dml.DuplicateRuleHeader.AllowSave = true;
                            Database.SaveResult sr2 = Database.update(sodansha, dml);
                            alertFlg = true;
                            System.debug('msg1:' + msg);
                        }
                    }
                }
                opp.AccountId = ota.SodanshaRef__c;
            }*/
            if(ota.SodanshaRef__c != null){
                opp.AccountId = ota.SodanshaRef__c;
            }

            if(ota.TaishoshaRef__c != null){
                opp.SimpleYasugoRef__r.TaishoshaRef__c = ota.TaishoshaRef__c;
            }

            opp.AimitsumoriHiaringuSha__c = ota.AimitsumoriHiaringuSha__c;
            opp.AimitsumoriJokyo__c = ota.AimitsumoriJokyo__c;
            opp.AimitsumoriPointKakaku__c = ota.AimitsumoriPointKakaku__c;
            opp.AimitsumoriPointShikijo__c = ota.AimitsumoriPointShikijo__c;
            opp.AimitsumoriPointSonota__c = ota.AimitsumoriPointSonota__c;
            opp.KakakuOffering__c = ota.KakakuOffering__c;
            opp.AimitsumoriHiaringuBiko__c = ota.AimitsumoriHiaringuBiko__c;
            opp.TaishoushaJokyo__c = ota.TaishoushaJokyo__c;
            opp.YorisoWoSittaKikkake__c = ota.YorisoWoSittaKikkake__c;
            //issues3806--Start--
            opp.TaishoshaKyojuKeitai__c = ota.TaishoshaKyojuKeitai__c;
            opp.TaishoshaYomeiKikan__c = ota.TaishoshaYomeiKikan__c;
            opp.TaishoshaKyojuKeitaiGenzai__c = ota.TaishoshaKyojuKeitaiGenzai__c;
            opp.TaishoushaJokyoGenzai__c = ota.TaishoushaJokyoGenzai__c;
            opp.TaishoshaYomeiKikanGenzai__c = ota.TaishoshaYomeiKikanGenzai__c;
            opp.ToiawaseKiinsha__c = ota.ToiawaseKiinsha__c;
            opp.TaishoushaJokyoKeteiFlg__c = true;
            //issues3806--End--
            opp.BenefitOneID__c = ota.BenefitOneID__c;
            opp.BenefitOneName__c = ota.BenefitOneName__c;
            opp.PostalClubKaiinBango__c = ota.PostalClubKaiinBango__c;
            opp.KiboShiharaiHouhou__c = ota.Shiharaihouhou__c;
            opp.ShiryoSoufuSakiPostalCode__c = ota.ShiryoseikyushaPostalCode__c;
            opp.ShiryoSoufuSakiState__c = ota.ShiryoseikyushaStateText__c;
            opp.ShiryoSoufuSakiCity__c = ota.ShiryoseikyushaCity__c;
            opp.ShiryoSoufuSakiStreet__c = ota.ShiryoseikyushaStreet__c;
            opp.JuyoRenrakuJiko__c = ota.JuyoRenrakuJiko__c;
            opp.Ketteisha__c = ota.Ketteisha__c;
            opp.OfferingJokyo__c = ota.OfferingJokyo__c;
            opp.AllianceRef__c = ota.AllianceRef__c;
            opp.SurveySendWayHopeEmail__c = ota.SurveySendWayHopeEmail__c;
            opp.SurveySendWayHopeSms__c = ota.SurveySendWayHopeSms__c;
            opp.SurveyDiscountAgreeStatus__c = ota.SurveyDiscountAgreeStatus__c;
            
            //opp.SimpleYasugoRef__r.KiboKeishiki__c = ota.KiboKeishiki__c;
            //opp.SimpleYasugoRef__r.SogiPlanUketsuke__c = ota.KiboPlan__c;
            opp.SimpleYasugoRef__r.KiboGoanchisaki__c = ota.KiboGoanchisaki__c;
            opp.SimpleYasugoRef__r.MonkArrangements__c = ota.MonkArrangements__c;
            //opp.SimpleYasugoRef__r.Maisosaki__c = ota.Maisosaki__c;
            opp.SimpleYasugoRef__r.FamilyTempleObtainConsensus__c = ota.FamilyTempleObtainConsensus__c;
            opp.SimpleYasugoRef__r.NumberRelatives__c = ota.SanretsushaShinzokuFrom__c;
            opp.SimpleYasugoRef__r.SanretsushaShinzokuTo__c = ota.SanretsushaShinzokuTo__c;
            opp.SimpleYasugoRef__r.MournersNumber__c = ota.SanretsushaShinzokuigaiFrom__c;
            opp.SimpleYasugoRef__r.SanretsushaShinzokuigaiTo__c = ota.SanretsushaShinzokuigaiTo__c;
            opp.SimpleYasugoRef__r.Kaimyojuyo__c = ota.Kaimyojuyo__c;
            opp.SimpleYasugoRef__r.Kaimyo__c = ota.Kaimyo__c;

            opp.SimpleYasugoRef__r.MoshuNoJuminhyoRef__c = ota.MoshuNoJuminhyoRef__c;
            opp.SimpleYasugoRef__r.ZokugaraSodanshaNitottenoTaishosha__c = ota.ZokugaraSodanshaNitottenoTaishosha__c;
            opp.SimpleYasugoRef__r.KiboAreaRef__c = ota.PreExecuteArea__c;
            opp.SimpleYasugoRef__r.KiboArea2Ref__c = ota.PreExecuteArea2__c;
            opp.SimpleYasugoRef__r.KiboArea3Ref__c = ota.PreExecuteArea3__c;
            opp.SimpleYasugoRef__r.KiboArea4Ref__c = ota.PreExecuteArea4__c;
            //issues3806--Start--
            //コメントアウト
            //opp.SimpleYasugoRef__r.TaishoshasamaKyojuKeitai__c = ota.TaishoshasamaKyojuKeitai__c;
            ////issues3806--End--
            
            opp.SimpleYasugoRef__r.ShiryoSofuJokyo__c = ota.ShiryoSofuJokyo__c;
            opp.SimpleYasugoRef__r.YusoYohiShubetsu__c = ota.YusoYohiShubetsu__c;
            opp.SimpleYasugoRef__r.MailSofuYohi__c = ota.MailSofuYohi__c;
            opp.SimpleYasugoRef__r.ShiryoSofuNichiji__c = ota.ShiryoSofuNichiji__c;
            opp.SimpleYasugoRef__r.YubinShiryoSofubi__c = ota.YubinShiryoSofubi__c;
            opp.SimpleYasugoRef__r.MailShiryoSofubi__c = ota.MailShiryoSofubi__c;
            opp.SimpleYasugoRef__r.FaxSofuYohi__c = ota.FaxSofuYohi__c;
            opp.SimpleYasugoRef__r.FaxShiryoSofubi__c = ota.FaxShiryoSofubi__c;
            //opp.SimpleYasugoRef__r. = ota.SodanshaMemberTourokuZumi__c;
            opp.Account.MemberSeidoGoannaiJokyo__c = ota.MemberSeidoGoannaiJokyo__c;
            
            //opp.SimpleYasugoRef__r. = ota.Shiharaihouhou2__c;
            opp.SimpleYasugoRef__r.OmukaeSakiName__c = ota.OmukaeSakiName__c;
            opp.SimpleYasugoRef__r.OmukaeSakiStreet__c = ota.OmukaeSakiJusho__c;
            opp.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__c = ota.SimpleYasugoKeiyakuRef__c;
            opp.SimpleYasugoRef__r.TaiouKanouRiyu__c = ota.TaiouKanouRiyu__c;
            if(String.isBlank(ota.SokyakushoKisaiJiko__c)) ota.SokyakushoKisaiJiko__c = '';
            if(ota.OtaiShienSogiyos__r.size() > 0){
                for(CrossSellingTeian__c cst : ota.OtaiShienSogiyos__r){
                    if(cst.OpportunityRef__c == null && cst.TeianShohin__c == '位牌' && (cst.TeianKekka__c == 'クロスセル検討中' || cst.TeianKekka__c == 'クロスセル希望あり')){
                        ota.SokyakushoKisaiJiko__c += '弊社サービスにて、位牌ご購入を検討いただいており、後日弊社よりお客様へご連絡する予定です。\r\nお客様より位牌に関する話があった際は、弊社担当からの連絡をお待ちいただくようお伝え願います。';
                    }
                }
            }
            opp.SimpleYasugoRef__r.SokyakushoKisaiJiko__c = ota.SokyakushoKisaiJiko__c;
            //商品登録処理
            //opp.SimpleYasugoRef__r. = ota.ShohinRef__c;
            
            //opp.SimpleYasugoRef__r. = ota.TaishoshaNoJuminhyoRef__c;
            opp.SimpleYasugoRef__r.AnchiRyokin2hakuOr3haku__c = ota.AnchiRyokin2hakuOr3haku__c;
            opp.SimpleYasugoRef__r.ShikijoShiyoryo2man5senOr5man__c = ota.ShikijoShiyoryo2man5senOr5man__c;
            opp.SimpleYasugoRef__r.KasobaShiyoryoPlangai__c = ota.KasobaShiyoryoPlangai__c;
            opp.SimpleYasugoRef__r.HansoKyori50km__c = ota.HansoKyori50km__c;
            opp.SimpleYasugoRef__r.HansoKaisu2kaiOr3kai__c = ota.HansoKaisu2kaiOr3kai__c;
            opp.SimpleYasugoRef__r.ChokusoPlanMenkaiFuka__c = ota.ChokusoPlanMenkaiFuka__c;
            opp.SimpleYasugoRef__r.KeisatsuAnkenKenanryo__c = ota.KeisatsuAnkenKenanryo__c;
            opp.SimpleYasugoRef__r.KeisatsuAnken__c = ota.KeisatsuAnken__c;
            opp.SimpleYasugoRef__r.SosaiFujo__c = ota.SosaiFujo__c;
            opp.SimpleYasugoRef__r.TashaAnchi__c = ota.TashaAnchi__c;
            opp.SimpleYasugoRef__r.TaijiAnken__c = ota.TaijiAnken__c;
            opp.SimpleYasugoRef__r.TaijiAnken__c = ota.TaijiAnken__c;
            opp.SimpleYasugoRef__r.GoanchiMenkaiKiboUmu__c = ota.GoanchiMenkaiKiboUmu__c;
            opp.SimpleYasugoRef__r.GoanchisakiJusho__c = ota.GoanchisakiJusho__c;
            opp.SimpleYasugoRef__r.TaioYusenRiyuShosai__c = ota.TaioYusenRiyuShosai__c;
            opp.SimpleYasugoRef__r.RyokinAnnaiBiko__c = ota.RyokinAnnaiBiko__c;
            opp.SimpleYasugoRef__r.SonotaGoanchiKanrenTokkijiko__c = ota.SonotaGoanchiKanrenTokkijiko__c;
            opp.SimpleYasugoRef__r.JizenJunbiSheetGoannaiJokyo__c = ota.JizenJunbiSheetGoannaiJokyo__c;
            opp.SimpleYasugoRef__r.JizenJunbiSheetGoteishutsuShudan__c = ota.JizenJunbiSheetGoteishutsuShudan__c;
            opp.SimpleYasugoRef__r.JizenJunbiSheetDairiNyuryokuTantoshaRef__c = ota.JizenJunbiSheetDairiNyuryokuTantoshaRef__c;
            opp.SimpleYasugoRef__r.PreliminaryConsultationDate__c = ota.PreliminaryConsultationDate__c;
            if(opp.SimpleYasugoRef__r.JizenJunbiSheetGoannaiJokyo__c != '受領' && 
                opp.SimpleYasugoRef__r.PreliminaryConsultationDate__c == null && 
                scon.OkyakusamaJizenSurveyDairiNyuryokuTeian__c && 
                scon.OkyakusamaJizenSurveyDairiNyuryokuTeianY__c == '承る' && 
                scon.OkyakusamaJizenSurveySodanshaFullNameKan__c &&
                scon.OkyakusamaJizenSurveySodanshaFullName__c &&
                scon.OkyakusamaJizenSurveySogiKiboChiiki__c &&
                (scon.OkyakusamaJizenSurveySodanshaJusho__c || scon.OkyakusamaJizenSurveySodanshaMobile__c || scon.OkyakusamaJizenSurveySodanshaMail__c) && 
                scon.OkyakusamaJizenSurveyTaishoshaJuminhyo__c &&
                scon.OkyakusamaJizenSurveyTaishoshaJotai__c &&
                scon.OkyakusamaJizenSurveyTaishoshaZokugara__c &&
                scon.OkyakusamaJizenSurveyTaishoshaFullNameKa__c &&
                scon.OkyakusamaJizenSurveyTaishoshaFullName__c
            ){
                opp.SimpleYasugoRef__r.JizenJunbiSheetGoannaiJokyo__c = '受領';
                opp.SimpleYasugoRef__r.PreliminaryConsultationDate__c = date.today();
                opp.SimpleYasugoRef__r.JizenJunbiSheetGoteishutsuShudan__c = '代理入力';
                opp.SimpleYasugoRef__r.JizenJunbiSheetDairiNyuryokuTantoshaRef__c = UserInfo.getUserId();
            }

            opp.SimpleYasugoRef__r.SogiPlanUketsuke__c = ota.KiboKeishiki__c;
            opp.SimpleYasugoRef__r.Konnyusaki__c = ota.Konnyusaki__c;
            opp.SimpleYasugoRef__r.KonnyusakiKasobaRef__c = ota.KonnyusakiKasobaRef__c;
            opp.SimpleYasugoRef__r.KonnyusakiKasobaText__c = ota.KonnyusakiKasobaText__c;
            opp.SimpleYasugoRef__r.KonnyusakiKyogoTasha__c = ota.KonnyusakiKyogoTasha__c;
            opp.SimpleYasugoRef__r.KonnyusakiKyogoTashaText__c = ota.KonnyusakiKyogoTashaText__c;
            opp.SimpleYasugoRef__r.KonnyusakiSaijoRef__c = ota.KonnyusakiSaijoRef__c;
            opp.SimpleYasugoRef__r.KonnyusakiSaijoText__c = ota.KonnyusakiSaijoText__c;
            opp.SimpleYasugoRef__r.KonnyusakiSogishaRef__c = ota.KonnyusakiSogishaRef__c;
            opp.SimpleYasugoRef__r.KonnyusakiSogishaText__c = ota.KonnyusakiSogishaText__c;
            opp.SimpleYasugoRef__r.TashaSodanJokyo__c = ota.TashaSodanJokyo__c;
            opp.SimpleYasugoRef__r.TeikeiJokyo__c = ota.TeikeiJokyo__c;
            opp.SimpleYasugoRef__r.ToiawaseNaiyo__c = ota.ToiawaseNaiyo__c;
            opp.SimpleYasugoRef__r.PlanBiko__c = ota.PlanBiko__c;
            opp.SimpleYasugoRef__r.ShikijoKasojoBiko__c = ota.ShikijoKasojoBiko__c;
            opp.SimpleYasugoRef__r.ButsuguNashiKibo__c = ota.ButsuguNashiKibo__c;
            opp.SimpleYasugoRef__r.SaidanKibo__c = ota.SaidanKibo__c;
            opp.SimpleYasugoRef__r.KanjoHanatabaKibo__c = ota.KanjoHanatabaKibo__c;
            opp.SimpleYasugoRef__r.KagobanaKibo__c = ota.KagobanaKibo__c;
            opp.SimpleYasugoRef__r.MakurabanaKibo__c = ota.MakurabanaKibo__c;
            opp.SimpleYasugoRef__r.SogishaTsuikaEigyoNg__c = ota.SogishaTsuikaEigyoNg__c;

            opp.GoannaizumiRyuijiko__c = ota.GoannaizumiRyuijiko__c;
            opp.ShiharaiHohoMikakuteiRiyu__c = ota.ShiharaiHohoMikakuteiRiyu__c;
            opp.SurveySendWayHopeEmail__c = ota.SurveySendWayHopeEmail__c;
            opp.SurveySendWayHopeSms__c = ota.SurveySendWayHopeSms__c;
            opp.SurveyDiscountAgreeStatus__c = ota.SurveyDiscountAgreeStatus__c;
            opp.AnkenShubetsu__c = ota.AnkenShubetsu__c;

            update opp.SimpleYasugoRef__r;
            update opp;

            System.debug('ota.SodanshaSeiKana__c:' + ota.SodanshaSeiKana__c);
            if(!String.isBlank(ota.SodanshaSeiKana__c)){
                Account sodansha = new Account();
                sodansha.Id = ota.SodanshaRef__c;
                if(String.isBlank(ota.SodanshaSei__c)){
                    ota.SodanshaSei__c = ota.SodanshaSeiKana__c;
                    sodansha.LastName = ota.SodanshaSeiKana__c;
                }
                else{
                    sodansha.LastName = ota.SodanshaSei__c;
                }
                sodansha.LastNameFurigana__pc = ota.SodanshaSeiKana__c;
                //sodansha.FirstName = ota.SodanshaMei__c;
                if(!String.isBlank(ota.SodanshaMei__c)){
                    sodansha.FirstName = ota.SodanshaMei__c;
                }
                else if(!String.isBlank(ota.SodanshaMeiKana__c)){
                    sodansha.FirstName = ota.SodanshaMeiKana__c;
                    ota.SodanshaMei__c = ota.SodanshaMeiKana__c;
                }
                sodansha.FirstNameFurigana__pc = ota.SodanshaMeiKana__c;
                sodansha.Gender__pc = ota.SodanshaSeibetsu__c;
                sodansha.MobilePhone__c = ota.MobilePhone__c;
                sodansha.Phone = ota.Phone__c;
                if(ota.TelNoPrimaryKubun__c == '携帯電話'){
                    sodansha.YusenTelNoKubun__c = '携帯1';
                }
                else if(ota.TelNoPrimaryKubun__c == '固定電話'){
                    sodansha.YusenTelNoKubun__c = '電話1';
                }
                sodansha.MailAddress__c = ota.ShiryoseikyushaMail__c;
                sodansha.Fax = ota.ShiroseikyushaFax__c;
                sodansha.BillingPostalCode = ota.ShiryoseikyushaPostalCode__c;
                sodansha.BillingState = ota.ShiryoseikyushaStateText__c;
                sodansha.BillingCity = ota.ShiryoseikyushaCity__c;
                sodansha.BillingStreet = ota.ShiryoseikyushaStreet__c;
                sodansha.MemberTourokuZumi__c = ota.SodanshaMemberTourokuZumi__c;
                //sodansha.JizenJizenSheetTeishutsuzumi__c = ota.JizenJizenSheetTeishutsuzumi__c;
                sodansha.MemberSeidoGoannaiJokyo__c = ota.MemberSeidoGoannaiJokyo__c;
                sodansha.BodaijiSoryoTehaiBiko__c = ota.BodaijiSoryoTehaiBiko__c;
                sodansha.Tel_Sogifollow_SmsPermission__c = ota.Tel_Sogifollow_SmsPermission__c;
                
                if(!sodansha.JizenJizenSheetTeishutsuzumi__c && 
                    opp.SimpleYasugoRef__r.PreliminaryConsultationDate__c != null){
                    sodansha.JizenJizenSheetTeishutsuzumi__c = true;
                }
                if(ota.SodanshaRef__r.JizenwariShoshoHassoDate__c == null && ota.JizenwariShoshoHassoDate__c != null){
                    sodansha.JizenwariShoshoHassoDate__c = ota.JizenwariShoshoHassoDate__c;
                }

                Database.SaveResult saveResult = Database.update(sodansha, false);
                if (!saveResult.isSuccess()) {
                    for (Database.Error error : saveResult.getErrors()) {
                        if (error instanceof Database.DuplicateError) {
                            msg += '\r\n相談者情報が重複しています。マージをお願いします。';
                            Database.DMLOptions dml = new Database.DMLOptions();
                            dml.DuplicateRuleHeader.AllowSave = true;
                            Database.SaveResult sr2 = Database.update(sodansha, dml);
                            alertFlg = true;
                            System.debug('msg1:' + msg);
                        }
                    }
                }
            }

            if(!String.isBlank(ota.TaishoshaRef__c)){
                Account taishosha = new Account();
                taishosha.Id = ota.TaishoshaRef__c;
                if(String.isBlank(ota.TaishoshaSei__c)){
                    if(String.isBlank(ota.TaishoshaSeiKana__c)){
                        String taishoshaSei = '対象者' + opp.ShodanBangoF__c;
                        taishosha.LastName = taishoshaSei;
                        ota.TaishoshaSei__c = taishoshaSei;
                    }
                    else{
                        taishosha.LastName = ota.TaishoshaSeiKana__c;
                        ota.TaishoshaSei__c = ota.TaishoshaSeiKana__c;
                    }
                }
                else{
                    taishosha.LastName = ota.TaishoshaSei__c;
                }
                taishosha.LastNameFurigana__pc = ota.TaishoshaSeiKana__c;
                //taishosha.FirstName = ota.TaishoshaMei__c;
                if(!String.isBlank(ota.TaishoshaMei__c)){
                    taishosha.FirstName = ota.TaishoshaMei__c;
                }
                else if(!String.isBlank(ota.TaishoshaMeiKana__c)){
                    taishosha.FirstName = ota.TaishoshaMeiKana__c;
                    ota.TaishoshaMei__c = ota.TaishoshaMeiKana__c;
                }
                taishosha.FirstNameFurigana__pc = ota.TaishoshaMeiKana__c;
                taishosha.Gender__pc = ota.TaishoshaSeibetsu__c;
                taishosha.PersonBirthdate = ota.SeinengappiSeireki__c;
                taishosha.SeinengappiWareki__c = ota.SeinengappiWareki__c;
                taishosha.PersonDeathDate__pc = ota.BotsunengappiSeireki__c;
                taishosha.BotsunengappiWareki__c = ota.BotsunengappiWareki__c;
                taishosha.BillingPostalCode = ota.TaishoshaPostalCode__c;
                taishosha.BillingState = ota.TaiishoshaStateText__c;
                taishosha.BillingCity = ota.TaishoshaCity__c;
                taishosha.BillingStreet = ota.TaishoshaStreet__c;
                taishosha.BodaijinoUmu__c = ota.BodaijinoUmu__c;
                taishosha.HakaUmuKubun__c = ota.HakaUmuKubun__c;
                taishosha.Syushi__c = ota.Syushi__c;
                taishosha.Syuha__c = ota.Syuha__c;
                taishosha.JuminhyouState__c = ota.TaishoshaNoJuminhyoRef__r.TodoufuKenRef__r.Name;  
                taishosha.JuminhyouCity__c = ota.TaishoshaNoJuminhyoRef__r.ShikugunMei__c;

                Database.SaveResult saveResult = Database.update(taishosha, false);
                if (!saveResult.isSuccess()) {
                    for (Database.Error error : saveResult.getErrors()) {
                        if (error instanceof Database.DuplicateError) {
                            msg += '\r\n対象者情報が重複しています。マージをお願いします。';
                            Database.DMLOptions dml = new Database.DMLOptions();
                            dml.DuplicateRuleHeader.AllowSave = true;
                            Database.SaveResult sr2 = Database.update(taishosha, dml);
                            alertFlg = true;
                            System.debug('msg2:' + msg);
                        }
                    }
                }
            }

            if(opp.OpportunityLineItems.size() == 0 && !String.isBlank(ota.ShohinRef__c)){
                insertShohin(oppId, ota.ShohinRef__c);
            }

            if(isToDoCreate == 'true'){
                Task t = new Task();
                t.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('Tsujo').getRecordTypeId();
                t.WhoId = opp.Account.PersonContactId;
                t.WhatId = oppId;
                t.Status = '完了';
                t.Subject = '';
                t.TaskSubtype = 'Call';
                t.ShiborikomiJoken__c = valuePicked;
                t.YokenSyubetsu__c = valuePicked2;
                t.Claim__c = claimFlg;
                contactText += '【次回対応】' + '\n';
                if(!String.isBlank(nextAction)){
                    contactText += nextAction;
                }
                t.Description = contactText;
                t.OwnerId = UserInfo.getUserId();
                insert t;
            }

            if(ota.OtaiShienSogiyos__r.size() > 0){
                List<String> crossSellIdList = new List<String>();
                for(CrossSellingTeian__c cst : ota.OtaiShienSogiyos__r){
                    if(cst.OpportunityRef__c == null){
                        crossSellIdList.add(cst.Id);
                    }
                }

                if(crossSellIdList.size() > 0){
                    updateCrossSell(opp.Id, crossSellIdList);
                }
            }

            saveFlg = true;

            if(opp.TorihikiShodanRef__r.AccountId != opp.AccountId){
                AccountChangedTask__c sobj = new AccountChangedTask__c();
                sobj.Opportunity__c = opp.Id;    // 商談
                sobj.OldAccount__c = opp.AccountId;    // 旧お客様・提携先
                sobj.NewAccount__c = ota.SodanshaRef__c;    // お客様・提携先
                sobj.ShoriStatus__c = '未処理';
                insert sobj;
            }

            delete scon;
        }
        catch(DmlException e){
            System.debug('exception:' + e.getMessage() + ' ' + e.getLineNumber());
            Database.rollback(sp);
            msg += e.getDmlMessage(0);
            errFlg = true;
        }
        catch(Exception e){
            System.debug('exception:' + e.getMessage() + ' ' + e.getLineNumber());
            Database.rollback(sp);
            msg += e.getMessage() + ' ' + e.getLineNumber();
            errFlg = true;
        }

        if(msg == ''){
            msg = '商談更新&コンタクト作成が完了しました。';
        }
    }

    public Pagereference back(){
        msg = '';
        Pagereference pr = Page.SwitchInput;
        pr.getParameters().put('oppid', opp.id);
        return pr;

        //update opp;
        //saveResult = 'ok';
    }

    private String isChangeChuuitenAddStr(Boolean bf, Boolean af, String addMsg, String baseStr) {
        if (bf != af) {
            if (String.isBlank(baseStr)) {
                baseStr = '【注意点説明】';
            }

            baseStr += '\n';
            baseStr += addMsg + isMaruBatsuChange(af);
        }

        return baseStr;
    }

    @future
    public static void insertShohin(String oppId, String shohinId) {
        OpportunityLineItem oppLI = new OpportunityLineItem();
        oppLI.OpportunityId = oppId;
        oppLI.Product2Id = shohinId;
        insert oppLI;
    }

    @future
    public static void updateCrossSell(String oppId, List<String> crossSellIdList) {
        List<CrossSellingTeian__c> updateCrossSellingList = new List<CrossSellingTeian__c>();
        for(String crossSellId : crossSellIdList){
            updateCrossSellingList.add(new CrossSellingTeian__c(Id=crossSellId, OpportunityRef__c=oppId));
        }
        update updateCrossSellingList;
    }


    Map<String, Map<String, String>> otaPlanOppPlanTable = new Map<String, Map<String, String>> {
                                                            '【20.06】火葬式' => new Map<String, String> {
                                                                '直葬'   => '【20.06】火葬式　直葬プラン(税抜:103,000　税込:113,300)'
                                                            },
                                                            '【19.12】火葬式' => new Map<String, String> {
                                                                '直葬'   => '【19.12】火葬式　直葬プラン(税抜:128,000　税込:140,800)',
                                                                '無宗教' => '【19.12】火葬式　無宗教プラン(税抜:148,000　税込:162,800)',
                                                                '仏式'   => '【19.12】火葬式　仏式プラン(税抜:168,000　税込:184,800)',
                                                                '花束'   => '【19.12】火葬式　花束プラン(税抜:188,000　税込:206,800)'
                                                            },
                                                            '【19.12】一日葬' => new Map<String, String> {
                                                                '無宗教'   => '【19.12】一日葬　無宗教プラン(税抜:278,000　税込:305,800)',
                                                                '仏式'    => '【19.12】一日葬　仏式プラン(税抜:298,000　税込:327,800)',
                                                                'お花増量' => '【19.12】一日葬　お花増量プラン(税抜:318,000　税込:349,800)'
                                                            },
                                                            '【19.12】家族葬' => new Map<String, String> {
                                                                '無宗教'   => '【19.12】家族葬　無宗教プラン(税抜:408,000　税込:448,800)',
                                                                '仏式'    => '【19.12】家族葬　仏式プラン(税抜:428,000　税込:470,800)',
                                                                'お花増量' => '【19.12】家族葬　お花増量プラン(税抜:448,000　税込:492,800)'
                                                            },
                                                            '【19.12】一般葬' => new Map<String, String> {
                                                                '無宗教'   => '【19.12】一般葬　無宗教プラン(税抜:548,000　税込:602,800)',
                                                                '仏式'    => '【19.12】一般葬　仏式プラン(税抜:568,000　税込:624,800)',
                                                                'お花増量' => '【19.12】一般葬　お花増量プラン(税抜:618,000　税込:679,800)'
                                                            },
                                                            '【19.12】お花いっぱい一日葬' => new Map<String, String> {
                                                                '無宗教'         => '【19.12】お花いっぱい　一日葬　無宗教プラン(税抜:338,000　税込:371,800)',
                                                                '仏式'           => '【19.12】お花いっぱい　一日葬　仏式プラン(税抜:358,000　税込:393,800)',
                                                                'お花増量' => '【19.12】お花いっぱい　一日葬　お花増量プラン(税抜:378,000　税込:415,800)'
                                                            },
                                                            '【19.12】お花いっぱい家族葬' => new Map<String, String> {
                                                                '無宗教'         => '【19.12】お花いっぱい　家族葬　無宗教プラン(税抜:528,000　税込:580,800)',
                                                                '仏式'           => '【19.12】お花いっぱい　家族葬　仏式プラン(税抜:548,000　税込:602,800)',
                                                                'お花増量' => '【19.12】お花いっぱい　家族葬　お花増量プラン(税抜:568,000　税込:624,800)'
                                                            },
                                                            '(新)火葬式' => new Map<String, String> {
                                                                '直葬'   => '火葬式　直葬プラン(税抜:118,000　税込:129,800)',
                                                                '無宗教' => '火葬式　無宗教プラン(税抜:128,000　税込:140,800)',
                                                                '仏式'   => '火葬式　仏式プラン(税抜:158,000　税込:173,800)',
                                                                '花束'   => '火葬式　花束プラン(税抜:178,000　税込:195,800)'
                                                            },
                                                            '(新)一日葬' => new Map<String, String> {
                                                                '無宗教'  => '一日葬　無宗教プラン(税抜:268,000　税込:294,800)',
                                                                '仏式'    => '一日葬　仏式プラン(税抜:288,000　税込:316,800)',
                                                                'お花増量' => '一日葬　お花増量プラン(税抜:308,000　税込:338,800)'
                                                            },
                                                            '(新)家族葬' => new Map<String, String> {
                                                                '無宗教'  => '家族葬　無宗教プラン(税抜:398,000　税込:437,800)',
                                                                '仏式'    => '家族葬　仏式プラン(税抜:418,000　税込:459,800)',
                                                                'お花増量' => '家族葬　お花増量プラン(税抜:438,000　税込:481,800)'
                                                            },
                                                            '(新)一般葬' => new Map<String, String> {
                                                                '無宗教'  => '一般葬　無宗教プラン(税抜:508,000　税込:558,800)',
                                                                '仏式'    => '一般葬　仏式プラン(税抜:528,000　税込:580,800)',
                                                                'お花増量' => '一般葬　お花増量プラン(税抜:578,000　税込:635,800)'
                                                            },
                                                            '(新)お花いっぱい一日葬' => new Map<String, String> {
                                                                '無宗教'         => 'お花いっぱい　一日葬　無宗教プラン(税抜:315,000　税込:346,500)',
                                                                '仏式'           => 'お花いっぱい　一日葬　仏式プラン(税抜:335,000　税込:368,500)',
                                                                '祭壇ランクアップ' => 'お花いっぱい　一日葬　祭壇ランクアッププラン(税抜:355,000　税込:390,500)'
                                                            },
                                                            '(新)お花いっぱい家族葬' => new Map<String, String> {
                                                                '無宗教'         => 'お花いっぱい　家族葬　無宗教プラン(税抜:495,000　税込:544,500)',
                                                                '仏式'           => 'お花いっぱい　家族葬　仏式プラン(税抜:515,000　税込:566,500)',
                                                                '祭壇ランクアップ' => 'お花いっぱい　家族葬　祭壇ランクアッププラン(税抜:535,000　税込:588,500)'
                                                            },
                                                            '火葬式' => new Map<String, String> {
                                                                '直葬' => '直葬　133,000円プラン',
                                                                '無宗教' => '火葬式　148,000円プラン',
                                                                '仏式' => '火葬式　178,000円プラン',
                                                                '花束' => '火葬式　198,000円プラン'
                                                            }, 
                                                            '一日葬' => new Map<String, String> {
                                                                '無宗教' => '一日葬　278,000円プラン',
                                                                '仏式' => '一日葬　298,000円プラン',
                                                                'お花増量' => '一日葬　318,000円プラン'
                                                            }, 
                                                            '家族葬' => new Map<String, String> {
                                                                '無宗教' => '家族葬　398,000円プラン',
                                                                '仏式' => '家族葬　418,000円プラン',
                                                                'お花増量' => '家族葬　438,000円プラン'
                                                            }, 
                                                            '一般葬' => new Map<String, String> {
                                                                '無宗教' => '一般葬　498,000円プラン',
                                                                '仏式' => '一般葬　518,000円プラン',
                                                                'お花増量' => '一般葬　548,000円プラン'
                                                            },
                                                            'お花いっぱい一日葬' => new Map<String, String> {
                                                                '32.8万(無宗教)' => '安くて豪華　一日葬　328,000円プラン',
                                                                '34.8万(仏式)' => '安くて豪華　一日葬　348,000円プラン',
                                                                '36.8万(祭壇ランクアップ)' => '安くて豪華　一日葬　368,000円プラン'
                                                            },
                                                            'お花いっぱい家族葬' => new Map<String, String> {
                                                                '48.8万(無宗教)' => '安くて豪華　家族葬　488,000円プラン',
                                                                '50.8万(仏式)' => '安くて豪華　家族葬　508,000円プラン',
                                                                '52.8万(祭壇ランクアップ)' => '安くて豪華　家族葬　528,000円プラン'
                                                            }
                                                        };

}