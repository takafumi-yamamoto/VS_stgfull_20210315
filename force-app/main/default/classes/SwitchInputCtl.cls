public class SwitchInputCtl {

    public String oppId {get;set;}
    public Opportunity opp {get; set;}
    public OtaiShienSogiyo__c ota {get; set;}
    public List<ContactHistory> contactHistoryList {get;set;}
    public List<Task> hikitsugiList {get; set;}
    public Task sogishaKaden {get;set;}

    public List<CrossSellingTeian__c> crossSellingTeianList {get;set;}
    public List<CrossSellingTeian__c> delCrossSellingTeianList {get;set;}

    public String warekiNen {get;set;}
    public String warekiTsuki {get;set;}
    public String warekiHi {get;set;}
    public Date seirekiNenTsukiHi {get;set;}
    public Boolean shohinFlg {get;set;}
    public Boolean mikanryoTaskFlg {get;set;}

    public String strYubinShiryoSofubi {get;set;}
    public String strMailShiryoSofubi {get;set;}
    public String strFaxShiryoSofubi {get;set;}
    public Boolean onloadFlg {get;set;}

    public List<String> goannaizumiRyuijikoSlt {get; set;}
    public List<String> goannaizumiRyuijikoSlt2 {get; set;}
    public List<SelectOption> goannaizumiRyuijikoOpt{
        get{
            List<SelectOption> options = new List<SelectOption>();

            Schema.DescribeFieldResult fieldResult = OtaiShienSogiyo__c.GoannaizumiRyuijiko__c.getDescribe();
            List<Schema.PicklistEntry> picklistEntries = fieldResult.getPicklistValues();

            for( Schema.PicklistEntry e : picklistEntries ){
                options.add(new SelectOption(e.getValue(), e.getLabel()));
            }

            return options;
        }
        set;
    }

    public List<WaribikiSummary.WaribikiSummaryEntry> waribikiList {get;set;}
    public String moshuTanshobi {get;set;}
    public Boolean jizenJunbiWariFlg {get;set;}
    public Boolean jizenJunbiWariDisableFlg {get;set;}
    public Boolean anketoWariDisableFlg {get;set;}
    public String taishogaiPlanMsg {get;set;}
    public static String keiyakuSimpleRecordTypeId = Schema.SObjectType.Keiyaku__c.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId();
    public String konnyusakiSogishaTeikeiId {get;set;}
    public String konnyusakiSogishaTeikeiName {get;set;}
    public String konnyusakiSogishaTeikeiJokyo {get; set;}
    public String konnyusakiKasobaTeikeiId {get; set;}
    public String konnyusakiKasobaTeikeiName {get; set;}
    public String konnyusakiSaijoTeikeiId {get; set;}
    public String konnyusakiSaijoTeikeiName {get;set;}
    public String konnyusakiSaijoTeikeiJokyo {get; set;}

    
    public List<SogiShiryoSofuWrap> sogiShiryoSofuWrapList {get;set;}

    public class SogiShiryoSofuWrap {
        public SogiShiryoSofu__c sogiShiryoSofu {get;set;}
        public String atesakiCustom {get;set;}
        public String teiansho {get;set;}

        public SogiShiryoSofuWrap(){
            sogiShiryoSofu = new SogiShiryoSofu__c();
            atesakiCustom = '';
            teiansho = '';
        }
    }

    public InputSogiShiroSofuWrap inputSogiShiroSofuWrap {get;set;}
    public class InputSogiShiroSofuWrap {
        public Boolean inputSogiShiryoSofuFlg {get;set;}
        public SogiShiryoSofuWrap inputSogiShiryoSofu {get;set;}
        public List<SogiShiryoSofuMeisai__c> kasobaTeianList {get;set;}
        public List<SogiShiryoSofuMeisai__c> saijoTeianList {get;set;}
        public List<TeianSho__c> teianshoList {get;set;}
        public Integer teianshoNum {get;set;}

        public InputSogiShiroSofuWrap(){
            sofuJokyoValue = '';
            inputSogiShiryoSofuFlg = false;
            insatsubutsuIchiranValue = new List<String>();
            inputSogiShiryoSofu = new SogiShiryoSofuWrap();
            kasobaTeianList = new List<SogiShiryoSofuMeisai__c>();
            saijoTeianList = new List<SogiShiryoSofuMeisai__c>();
            teianshoList = new List<TeianSho__c>();
            teianshoNum = 0;
            for(Integer i = 0; i < 2; i++) kasobaTeianList.add(new SogiShiryoSofuMeisai__c());
            for(Integer i = 0; i < 10; i++) saijoTeianList.add(new SogiShiryoSofuMeisai__c());
        }

        public List<String> insatsubutsuIchiranValue {get; set;}
        public List<SelectOption> insatsubutsuIchiranOption{
            get{
                List<SelectOption> options = new List<SelectOption>();

                Schema.DescribeFieldResult fieldResult = SogiShiryoSofu__c.InsatsubutsuIchiran__c.getDescribe();
                List<Schema.PicklistEntry> picklistEntries = fieldResult.getPicklistValues();

                for( Schema.PicklistEntry e : picklistEntries ){
                    options.add(new SelectOption(e.getValue(), e.getLabel()));
                }

                return options;
            }
            set;
        }

        public String sofuJokyoValue {get; set;}
        public List<SelectOption> sofuJokyoEditOption{
            get{
                List<SelectOption> options = new List<SelectOption>();
                options.add(new SelectOption('資料作成中', '資料作成中'));
                options.add(new SelectOption('情報確認中', '情報確認中'));
                options.add(new SelectOption('印刷待ち', '印刷待ち'));
                options.add(new SelectOption('送付中止', '送付中止'));
                return options;
            }
            set;
        }
        public List<SelectOption> sofuJokyoDisabledOption{
            get{
                List<SelectOption> options = new List<SelectOption>();
                options.add(new SelectOption('資料作成中', '資料作成中'));
                options.add(new SelectOption('印刷待ち', '印刷待ち'));
                options.add(new SelectOption('印刷済', '印刷済'));
                options.add(new SelectOption('送付済', '送付済'));
                options.add(new SelectOption('送付中止', '送付中止'));
                return options;
            }
            set;
        }
    }

    //issues3806--Start--
    public String ToiawaseKiinsha {get; set;}
    public List<SelectOption> ToiawaseKiinshaOpt {get; set;}

    public String TaishoshaKyojuKeitai {get; set;}
    public List<SelectOption> TaishoshaKyojuKeitaiOpt {get; set;}

    public String TaishoshaKyojuKeitaiGenzai {get; set;}
    public List<SelectOption> TaishoshaKyojuKeitaiGenzaiOpt {get; set;}

    public String TaishoushaJokyo {get; set;}
    public List<SelectOption> TaishoushaJokyoOpt {get; set;}

    public String TaishoushaJokyoGenzai {get; set;}
    public List<SelectOption> TaishoushaJokyoGenzaiOpt {get; set;}

    public String TaishoshaYomeiKikan {get; set;}
    public List<SelectOption> TaishoshaYomeiKikanOpt {get; set;}

    public String TaishoshaYomeiKikanGenzai {get; set;}
    public List<SelectOption> TaishoshaYomeiKikanGenzaiOpt {get; set;}

    public List<Report> ReportData {get; set;}
    public String ReportURL {get; set;}
    //issues3806--End--

    public String KakakuOffering {get; set;}
    public List<SelectOption> KakakuOfferingSelectOption {get; set;}

    public String AimitsumoriJokyo {get; set;}
    public List<SelectOption> AimitsumoriJokyoSelectOption {get; set;}

    public String YorisoWoSittaKikkake {get; set;}
    public List<SelectOption> YorisoWoSittaKikkakeSelectOption {get; set;}

    public ContactHistoryWrap contactHistoryWrap {get;set;}
    public class ContactHistoryWrap {
        public SwitchContactHistory__c contactHistory {get;set;}

        public Integer tsuyaHour {get;set;}
        public Integer tsuyaMinute {get;set;}
        public Integer kokubetsushikiHour {get;set;}
        public Integer kokubetsushikiMinute {get;set;}
        public Integer kasoHour {get;set;}
        public Integer kasoMinute {get;set;}

        public List<String> okyakusamaPlanNaiyoValue {get; set;}
        public List<SelectOption> okyakusamaPlanNaiyoOption{
            get{
                List<SelectOption> options = new List<SelectOption>();
                for( Schema.PicklistEntry e : SwitchContactHistory__c.OkyakusamaPlanNaiyo__c.getDescribe().getPicklistValues()){
                    options.add(new SelectOption(e.getValue(), e.getLabel()));
                }
                return options;
            }
            set;
        }

        public List<String> okyakusamaPlanKingakuValue {get; set;}
        public List<SelectOption> okyakusamaPlanKingakuOption{
            get{
                List<SelectOption> options = new List<SelectOption>();
                for( Schema.PicklistEntry e : SwitchContactHistory__c.OkyakusamaPlanKingaku__c.getDescribe().getPicklistValues()){
                    options.add(new SelectOption(e.getValue(), e.getLabel()));
                }
                return options;
            }
            set;
        }

        public List<String> okyakusamaOsoshiYoyakuValue {get; set;}
        public List<SelectOption> okyakusamaOsoshiYoyakuOption{
            get{
                List<SelectOption> options = new List<SelectOption>();
                for( Schema.PicklistEntry e : SwitchContactHistory__c.OkyakusamaOsoshiYoyaku__c.getDescribe().getPicklistValues()){
                    options.add(new SelectOption(e.getValue(), e.getLabel()));
                }
                return options;
            }
            set;
        }

        public List<String> okyakusamaKeisatsuAnkenValue {get; set;}
        public List<SelectOption> okyakusamaKeisatsuAnkenOption{
            get{
                List<SelectOption> options = new List<SelectOption>();
                for( Schema.PicklistEntry e : SwitchContactHistory__c.OkyakusamaKeisatsuAnken__c.getDescribe().getPicklistValues()){
                    options.add(new SelectOption(e.getValue(), e.getLabel()));
                }
                return options;
            }
            set;
        }

        public List<String> okyakusamaSosaiFujoValue {get; set;}
        public List<SelectOption> okyakusamaSosaiFujoOption{
            get{
                List<SelectOption> options = new List<SelectOption>();
                for( Schema.PicklistEntry e : SwitchContactHistory__c.OkyakusamaSosaiFujo__c.getDescribe().getPicklistValues()){
                    options.add(new SelectOption(e.getValue(), e.getLabel()));
                }
                return options;
            }
            set;
        }

        public List<String> okyakusamaHenkinHoshoValue {get; set;}
        public List<SelectOption> okyakusamaHenkinHoshoOption{
            get{
                List<SelectOption> options = new List<SelectOption>();
                for( Schema.PicklistEntry e : SwitchContactHistory__c.OkyakusamaHenkinHosho__c.getDescribe().getPicklistValues()){
                    options.add(new SelectOption(e.getValue(), e.getLabel()));
                }
                return options;
            }
            set;
        }

        public List<String> okyakusamaSoryoTehaiAnnaiValue {get; set;}
        public List<SelectOption> okyakusamaSoryoTehaiAnnaiOption{
            get{
                List<SelectOption> options = new List<SelectOption>();
                for( Schema.PicklistEntry e : SwitchContactHistory__c.OkyakusamaSoryoTehaiAnnai__c.getDescribe().getPicklistValues()){
                    options.add(new SelectOption(e.getValue(), e.getLabel()));
                }
                return options;
            }
            set;
        }

        public ContactHistoryWrap(String oppId){
            List<SwitchContactHistory__c> contactHistoryList = getSwitchContactHistoryList(oppId);
            contactHistory = new SwitchContactHistory__c(OpportunityRef__c = oppId, ContactShubetsu__c = 'お客様');
            okyakusamaPlanNaiyoValue = new List<String>();
            okyakusamaPlanKingakuValue = new List<String>();
            okyakusamaOsoshiYoyakuValue = new List<String>();
            okyakusamaKeisatsuAnkenValue = new List<String>();
            okyakusamaSosaiFujoValue = new List<String>();
            okyakusamaHenkinHoshoValue = new List<String>();
            okyakusamaSoryoTehaiAnnaiValue = new List<String>();
            if(contactHistoryList.size() > 0) {
                contactHistory = contactHistoryList.get(0);
                okyakusamaPlanNaiyoValue = String.isBlank(contactHistory.OkyakusamaPlanNaiyo__c) ? new List<String>() : contactHistory.OkyakusamaPlanNaiyo__c.split(';');
                okyakusamaPlanKingakuValue = String.isBlank(contactHistory.OkyakusamaPlanKingaku__c) ? new List<String>() : contactHistory.OkyakusamaPlanKingaku__c.split(';');
                okyakusamaOsoshiYoyakuValue = String.isBlank(contactHistory.OkyakusamaOsoshiYoyaku__c) ? new List<String>() : contactHistory.OkyakusamaOsoshiYoyaku__c.split(';');
                okyakusamaKeisatsuAnkenValue = String.isBlank(contactHistory.OkyakusamaKeisatsuAnken__c) ? new List<String>() : contactHistory.OkyakusamaKeisatsuAnken__c.split(';');
                okyakusamaSosaiFujoValue = String.isBlank(contactHistory.OkyakusamaSosaiFujo__c) ? new List<String>() : contactHistory.OkyakusamaSosaiFujo__c.split(';');
                okyakusamaHenkinHoshoValue = String.isBlank(contactHistory.OkyakusamaHenkinHosho__c) ? new List<String>() : contactHistory.OkyakusamaHenkinHosho__c.split(';');
                okyakusamaSoryoTehaiAnnaiValue = String.isBlank(contactHistory.OkyakusamaSoryoTehaiAnnai__c) ? new List<String>() : contactHistory.OkyakusamaSoryoTehaiAnnai__c.split(';');
                tsuyaHour = contactHistory.SogishaTsuyaHour__c == null ? null : contactHistory.SogishaTsuyaHour__c.intValue();
                tsuyaMinute = contactHistory.SogishaTsuyaMinute__c == null ? null : contactHistory.SogishaTsuyaMinute__c.intValue();
                kokubetsushikiHour = contactHistory.SogishaKokubetsushikiHour__c == null ? null : contactHistory.SogishaKokubetsushikiHour__c.intValue();
                kokubetsushikiMinute = contactHistory.SogishaKokubetsushikiMinute__c == null ? null : contactHistory.SogishaKokubetsushikiMinute__c.intValue();
                kasoHour = contactHistory.SogishaKasoHour__c == null ? null : contactHistory.SogishaKasoHour__c.intValue();
                kasoMinute = contactHistory.SogishaKasoMinute__c == null ? null : contactHistory.SogishaKasoMinute__c.intValue();
            }
        }

        private List<SwitchContactHistory__c> getSwitchContactHistoryList(String oppId){
            return [SELECT 
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
                    OkyakusamaOptionKanjoHanataba__c,
                    OkyakusamaOptionIeishashin__c,
                    OkyakusamaOptionKoshikiYukan__c,
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
                    OkyakusamaSoryoTehaiAnnai__c,
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
                    SogishaUchiawaseYotei__c,
                    SogishaTsuyaHour__c,
                    SogishaTsuyaMinute__c,
                    SogishaKokubetsushikiHour__c,
                    SogishaKokubetsushikiMinute__c,
                    SogishaKasoHour__c,
                    SogishaKasoMinute__c,
                    SogishaPlan__c,
                    OpportunityRef__c, 
                    ContactShubetsu__c 
                FROM SwitchContactHistory__c 
                WHERE OpportunityRef__c =:oppId];
        }
    }

    public List<SwitchLongTextTempleteWrap> sokyakushoKisaijikoLTTempleteWrapList {get;set;}
    public class SwitchLongTextTempleteWrap {
        public SwitchLongTextTemplete__c longTextTemplete {get;set;}
        public SwitchLongTextTempleteWrap(){}
    }

    public SwitchInputCtl(ApexPages.StandardController controller){
        onloadFlg = true;
        oppId = controller.getRecord().id;
        String backOppId = Apexpages.currentPage().getParameters().get('oppid');
        if(!String.isBlank(backOppId)){
            oppId = backOppId;
            onloadFlg = false;
        }
        opp = new Opportunity();
        ota = new OtaiShienSogiyo__c();
        ota.RyokinhyoRiyoStatus__c = '利用無';
        contactHistoryList = new List<ContactHistory>();
        crossSellingTeianList = new List<CrossSellingTeian__c>();
        delCrossSellingTeianList = new List<CrossSellingTeian__c>();
        hikitsugiList = new List<Task>();
        sogishaKaden = new Task();
        sogiTalkScript = new SogiTalkScript__mdt();
        saveResult = '';
        nengoValue = '';
        warekiNen = '';
        warekiTsuki = '';
        warekiHi = '';
        seirekiNenTsukiHi = null;
        errFlg = false;
        hozonMsg = '';
        shohinFlg = false;
        mikanryoTaskFlg = false;
        strYubinShiryoSofubi = '';
        strMailShiryoSofubi = '';
        strFaxShiryoSofubi = '';
        judenLogTitle = '受電ログ表示';
        goannaizumiRyuijikoSlt = new List<String>();
        goannaizumiRyuijikoSlt2 = new List<String>();
        jizenJunbiWariFlg = false;
        jizenJunbiWariDisableFlg = true;
        anketoWariDisableFlg = false;
        taishogaiPlanMsg = '';
        konnyusakiSogishaTeikeiId = '';
        konnyusakiSogishaTeikeiName = '';
        konnyusakiSogishaTeikeiJokyo = '';
        konnyusakiKasobaTeikeiId = '';
        konnyusakiKasobaTeikeiName = '';
        konnyusakiSaijoTeikeiId = '';
        konnyusakiSaijoTeikeiName = '';
        konnyusakiSaijoTeikeiJokyo = '';
        ankenShubetsu = '有効';
        toiawaseJogaiKubun = '';
        sogiShiryoSofuWrapList = new List<SogiShiryoSofuWrap>();
        inputSogiShiroSofuWrap = new InputSogiShiroSofuWrap();
        shiryoSofuId = '';
        shiryoSofuErrMsg = '';
        campaignSogiyoBouquetFlg = false;
        sokyakushoKisaijikoLTTempleteWrapList = new List<SwitchLongTextTempleteWrap>();
        moshuTanshobi = '';

        //issues3806--Start--

        ToiawaseKiinsha = '';
        ToiawaseKiinshaOpt = new List<SelectOption>();
        List<Schema.PicklistEntry> ToiawaseKiinshaPicklist = getPicklist('OtaiShienSogiyo__c','ToiawaseKiinsha__c');
        for(Schema.PicklistEntry sToiawaseKiinshaPicklis :ToiawaseKiinshaPicklist){
            ToiawaseKiinshaOpt.add(new SelectOption(String.valueOf(sToiawaseKiinshaPicklis.getValue()),String.valueOf(sToiawaseKiinshaPicklis.getLabel())));
        }

        TaishoshaKyojuKeitai = '';
        TaishoshaKyojuKeitaiOpt = new List<SelectOption>();
        List<Schema.PicklistEntry> TaishoshaKyojuKeitaiPicklist = getPicklist('OtaiShienSogiyo__c','TaishoshaKyojuKeitai__c');
        for(Schema.PicklistEntry sTaishoshaKyojuKeitaiPicklis :TaishoshaKyojuKeitaiPicklist){
            TaishoshaKyojuKeitaiOpt.add(new SelectOption(String.valueOf(sTaishoshaKyojuKeitaiPicklis.getValue()),String.valueOf(sTaishoshaKyojuKeitaiPicklis.getLabel())));
        }

        TaishoshaKyojuKeitaiGenzai = '';
        TaishoshaKyojuKeitaiGenzaiOpt = new List<SelectOption>();
        List<Schema.PicklistEntry> TaishoshaKyojuKeitaiGenzaiPicklist = getPicklist('OtaiShienSogiyo__c','TaishoshaKyojuKeitaiGenzai__c');
        for(Schema.PicklistEntry sTaishoshaKyojuKeitaiGenzaiPicklis :TaishoshaKyojuKeitaiGenzaiPicklist){
            TaishoshaKyojuKeitaiGenzaiOpt.add(new SelectOption(String.valueOf(sTaishoshaKyojuKeitaiGenzaiPicklis.getValue()),String.valueOf(sTaishoshaKyojuKeitaiGenzaiPicklis.getLabel())));
        }

        TaishoushaJokyo = '';
        TaishoushaJokyoOpt = new List<SelectOption>();
        List<Schema.PicklistEntry> TaishoushaJokyoPicklist = getPicklist('OtaiShienSogiyo__c','TaishoushaJokyo__c');
        for(Schema.PicklistEntry sTaishoushaJokyoPicklis :TaishoushaJokyoPicklist){
            TaishoushaJokyoOpt.add(new SelectOption(String.valueOf(sTaishoushaJokyoPicklis.getValue()),String.valueOf(sTaishoushaJokyoPicklis.getLabel())));
        }

        TaishoushaJokyoGenzai = '';
        TaishoushaJokyoGenzaiOpt = new List<SelectOption>();
        List<Schema.PicklistEntry> TaishoushaJokyoGenzaiPicklist = getPicklist('OtaiShienSogiyo__c','TaishoushaJokyoGenzai__c');
        for(Schema.PicklistEntry sTaishoushaJokyoGenzaiPicklis :TaishoushaJokyoGenzaiPicklist){
            TaishoushaJokyoGenzaiOpt.add(new SelectOption(String.valueOf(sTaishoushaJokyoGenzaiPicklis.getValue()),String.valueOf(sTaishoushaJokyoGenzaiPicklis.getLabel())));
        }

        TaishoshaYomeiKikan = '';
        TaishoshaYomeiKikanOpt = new List<SelectOption>();
        List<Schema.PicklistEntry> TaishoshaYomeiKikanPicklist = getPicklist('OtaiShienSogiyo__c','TaishoshaYomeiKikan__c');
        for(Schema.PicklistEntry sTaishoshaYomeiKikanPicklis :TaishoshaYomeiKikanPicklist){
            TaishoshaYomeiKikanOpt.add(new SelectOption(String.valueOf(sTaishoshaYomeiKikanPicklis.getValue()),String.valueOf(sTaishoshaYomeiKikanPicklis.getLabel())));
        }

        TaishoshaYomeiKikanGenzai = '';
        TaishoshaYomeiKikanGenzaiOpt = new List<SelectOption>();
        List<Schema.PicklistEntry> TaishoshaYomeiKikanGenzaiPicklist = getPicklist('OtaiShienSogiyo__c','TaishoshaYomeiKikanGenzai__c');
        for(Schema.PicklistEntry sTaishoshaYomeiKikanGenzaiPicklis :TaishoshaYomeiKikanGenzaiPicklist){
            TaishoshaYomeiKikanGenzaiOpt.add(new SelectOption(String.valueOf(sTaishoshaYomeiKikanGenzaiPicklis.getValue()),String.valueOf(sTaishoshaYomeiKikanGenzaiPicklis.getLabel())));
        }

        KakakuOffering = '';
        KakakuOfferingSelectOption = new List<SelectOption>();
        List<Schema.PicklistEntry> KakakuOfferingPicklist = getPicklist('OtaiShienSogiyo__c','KakakuOffering__c');
        for(Schema.PicklistEntry sKakakuOfferingPicklis :KakakuOfferingPicklist){
            KakakuOfferingSelectOption.add(new SelectOption(String.valueOf(sKakakuOfferingPicklis.getValue()),String.valueOf(sKakakuOfferingPicklis.getLabel())));
        }

        AimitsumoriJokyo = '';
        AimitsumoriJokyoSelectOption = new List<SelectOption>();
        List<Schema.PicklistEntry> AimitsumoriJokyoPicklist = getPicklist('OtaiShienSogiyo__c','AimitsumoriJokyo__c');
        for(Schema.PicklistEntry sAimitsumoriJokyoPicklis :AimitsumoriJokyoPicklist){
            AimitsumoriJokyoSelectOption.add(new SelectOption(String.valueOf(sAimitsumoriJokyoPicklis.getValue()),String.valueOf(sAimitsumoriJokyoPicklis.getLabel())));
        }

        YorisoWoSittaKikkake = '';
        YorisoWoSittaKikkakeSelectOption = new List<SelectOption>();
        List<Schema.PicklistEntry> YorisoWoSittaKikkakePicklist = getPicklist('OtaiShienSogiyo__c','YorisoWoSittaKikkake__c');
        for(Schema.PicklistEntry sYorisoWoSittaKikkakePicklis :YorisoWoSittaKikkakePicklist){
            YorisoWoSittaKikkakeSelectOption.add(new SelectOption(String.valueOf(sYorisoWoSittaKikkakePicklis.getValue()),String.valueOf(sYorisoWoSittaKikkakePicklis.getLabel())));
        }

        ReportData = new List<Report>();
        if(!Test.isRunningTest()){
            ReportData = [SELECT Id, Name, DeveloperName FROM Report where DeveloperName = 'report_Sogi_KPIKomokuKoshin' LIMIT 1];
        }
        ReportURL = '';
        //issues3806--End--

        contactHistoryWrap = new ContactHistoryWrap(oppId);
    }

    public void init() {

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
                        Account.MemberKubunCode__c,
                        Account.RecordTypeId, 
                        Account.BodaijiSoryoTehaiBiko__c, 
                        Account.JizenJizenSheetTeishutsuzumi__c, 
                        Account.JizenwariKekaKikan__c, 
                        Account.JizenwariShoshoHassoDate__c, 
                        Account.MemberKubun__c, 
                        Account.Tel_Sogifollow_SmsPermission__c, 
                        SurveySendWayHopeEmail__c, 
                        SurveySendWayHopeSms__c, 
                        SurveyDiscountAgreeStatus__c, 
                        StageName,
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
                        TaishoushaJokyoKeteiFlg__c,
                        //issues3806--End--
                        Ketteisha__c,
                        JuyoRenrakuJiko__c,
                        ShodanBangoF__c,
                        GoannaizumiRyuijiko__c, 
                        ShiharaiHohoMikakuteiRiyu__c, 
                        AllianceRef__c, 
                        AnkenShubetsu__c, 
                        AimitsumoriHiaringuSha__c, 
                        AimitsumoriJokyo__c, 
                        AimitsumoriPointKakaku__c, 
                        AimitsumoriPointShikijo__c, 
                        AimitsumoriPointSonota__c, 
                        KakakuOffering__c, 
                        AimitsumoriHiaringuBiko__c, 
                        YorisoWoSittaKikkake__c, 
                        SimpleYasugoRef__c, 
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
                        SimpleYasugoRef__r.TaishoshaRef__r.JizenwariKekaKikan__c, 
                        SimpleYasugoRef__r.TaishoshaRef__r.MemberKubun__c, 
                        SimpleYasugoRef__r.TaishoshaRef__r.MemberKubunCode__c, 
                        SimpleYasugoRef__r.TaishoshaRef__r.JizenJizenSheetTeishutsuzumi__c, 
                        SimpleYasugoRef__r.MosyuRef__c,
                        SimpleYasugoRef__r.MoshuRef__r.LastName,
                        SimpleYasugoRef__r.MoshuRef__r.LastNameFurigana__pc,
                        SimpleYasugoRef__r.MoshuRef__r.FirstName,
                        SimpleYasugoRef__r.MoshuRef__r.FirstNameFurigana__pc,
                        SimpleYasugoRef__r.MoshuRef__r.Gender__pc,
                        SimpleYasugoRef__r.MoshuRef__r.PersonBirthdate,
                        SimpleYasugoRef__r.MoshuRef__r.BillingPostalCode,
                        SimpleYasugoRef__r.MoshuRef__r.BillingState,
                        SimpleYasugoRef__r.MoshuRef__r.BillingCity,
                        SimpleYasugoRef__r.MoshuRef__r.BillingStreet,
                        SimpleYasugoRef__r.MoshuRef__r.MobilePhone__c,
                        SimpleYasugoRef__r.MoshuRef__r.Phone,
                        SimpleYasugoRef__r.KiboGoanchisaki__c,
                        SimpleYasugoRef__r.MonkArrangements__c,
                        SimpleYasugoRef__r.FamilyTempleObtainConsensus__c,
                        SimpleYasugoRef__r.Kaimyojuyo__c,
                        SimpleYasugoRef__r.Kaimyo__c,
                        SimpleYasugoRef__r.MoshuNoJuminhyoRef__c,
                        SimpleYasugoRef__r.KiboAreaRef__c,
                        SimpleYasugoRef__r.KiboArea2Ref__c,
                        SimpleYasugoRef__r.KiboArea3Ref__c,
                        SimpleYasugoRef__r.KiboArea4Ref__c,
                        Account.MemberSeidoGoannaiJokyo__c,
                        SimpleYasugoRef__r.OmukaeSakiName__c,
                        SimpleYasugoRef__r.OmukaeSakiZipcode__c,
                        SimpleYasugoRef__r.OmukaeSakiState__c,
                        SimpleYasugoRef__r.OmukaeSakiCity__c,
                        SimpleYasugoRef__r.OmukaeSakiStreet__c,
                        SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__c,
                        SimpleYasugoRef__r.SokyakushoKisaiJiko__c,
                        SimpleYasugoRef__r.TaiouKanouRiyu__c,
                        //issues3806--Start--
                        //コメントアウト
                        //SimpleYasugoRef__r.TaishoshasamaKyojuKeitai__c,
                        //issues3806--End--
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
                        SimpleYasugoRef__r.GoanchiMenkaiKiboUmu__c, 
                        SimpleYasugoRef__r.GoanchisakiJusho__c, 
                        SimpleYasugoRef__r.TaioYusenRiyuShosai__c, 
                        SimpleYasugoRef__r.SogishaTsuikaEigyoNg__c, 
                        SimpleYasugoRef__r.RyokinAnnaiBiko__c, 
                        SimpleYasugoRef__r.SonotaGoanchiKanrenTokkijiko__c, 
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
                        SimpleYasugoRef__r.ButsuguNashiKibo__c, 
                        SimpleYasugoRef__r.KagobanaKibo__c, 
                        SimpleYasugoRef__r.KanjoHanatabaKibo__c, 
                        SimpleYasugoRef__r.SaidanKibo__c, 
                        SimpleYasugoRef__r.MakurabanaKibo__c, 
                        RecordType.DeveloperName,
                    (
                        select Id, 
                                Product2Id 
                        from OpportunityLineItems where HinmokuBunrui__c = '本体'
                    )
                from Opportunity 
                where id = :oppId];
        if(opp.OpportunityLineItems.size() > 0){
            shohinFlg = true;
        }

        sogiShiryoSofuSetting();

        List<OtaiShienSogiyo__c> otaList = [select Id,
                                                    Name,
                                                    FreeText__c,
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
                                                    TaishoshaKyojuKeitaiGenzai__c,
                                                    TaishoushaJokyoGenzai__c,
                                                    TaishoshaYomeiKikanGenzai__c,
                                                    ToiawaseKiinsha__c,
                                                    KinkyudoLVGenzai__c,
                                                    SoteiLeadTimeGenzai__c,
                                                    SogiKPIGenzai__c,
                                                    SogiKPIGenzaiKoshinbi__c,
                                                    TaishoushaJokyoKeteiFlg__c,
                                                    //issues3806--End--
                                                    BenefitOneID__c,
                                                    BenefitOneName__c,
                                                    PostalClubKaiinBango__c,
                                                    SodanshaSei__c,
                                                    SodanshaMei__c,
                                                    SodanshaSeibetsu__c,
                                                    GoannaizumiRyuijiko__c,
                                                    GoannaizumiRyuijiko2__c,
                                                    //issues3806--Start--
                                                    //コメントアウト
                                                    //TaishoshasamaKyojuKeitai__c,
                                                    //issues3806--End--
                                                    TaishoshaSei__c,
                                                    TaishoshaMei__c,
                                                    TaishoshaSeiKana__c,
                                                    TaishoshaMeiKana__c,
                                                    TaishoshaSeibetsu__c,
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
                                                    ButsuguNashiKibo__c,
                                                    SaidanKibo__c, 
                                                    KanjoHanatabaKibo__c, 
                                                    MakurabanaKibo__c, 
                                                    KagobanaKibo__c, 
                                                    KiboGoanchisaki__c,
                                                    MonkArrangements__c,
                                                    FamilyTempleObtainConsensus__c,
                                                    SanretsushaShinzokuFrom__c,
                                                    SanretsushaShinzokuTo__c,
                                                    SanretsushaShinzokuigaiFrom__c,
                                                    SanretsushaShinzokuigaiTo__c,
                                                    Kaimyojuyo__c,
                                                    Kaimyo__c,
                                                    MoshuNoJuminhyoRef__c,
                                                    TaishoshaJuminhyoState__c,
                                                    TaishoshaJuminhyoCity__c,
                                                    ZokugaraSodanshaNitottenoTaishosha__c,
                                                    PreExecuteArea__c,
                                                    PreExecuteArea2__c,
                                                    PreExecuteArea3__c,
                                                    PreExecuteArea4__c,
                                                    Ketteisha__c,
                                                    Shiharaihouhou__c,
                                                    ShiryoseikyushaMail__c,
                                                    ShiryoseikyushaPostalCode__c,
                                                    ShiryoseikyushaStateText__c,
                                                    ShiryoseikyushaCity__c,
                                                    ShiryoseikyushaStreet__c,
                                                    SodanshaMemberTourokuZumi__c, 
                                                    JizenJunbiSheetGoannaiJokyo__c, 
                                                    JizenJunbiSheetGoteishutsuShudan__c, 
                                                    JizenJunbiSheetDairiNyuryokuTantoshaRef__c, 
                                                    JizenwariShoshoHassoDate__c, 
                                                    PreliminaryConsultationDate__c, 
                                                    MemberSeidoGoannaiJokyo__c,
                                                    JuyoRenrakuJiko__c,
                                                    Shiharaihouhou2__c,
                                                    OmukaeSakiName__c,
                                                    OmukaeSakiJusho__c,
                                                    SimpleYasugoKeiyakuRef__c,
                                                    TaiouKanouRiyu__c,
                                                    SokyakushoKisaiJiko__c,
                                                    ShohinRef__c,
                                                    BotsunengappiWareki__c,
                                                    TaishoshaNoJuminhyoRef__c,
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
                                                    SodanshaRef__c,
                                                    SodanshaRef__r.MemberKubunCode__c,
                                                    TaishoshaRef__c,
                                                    TaishoshaRef__r.MemberKubunCode__c,
                                                    SeinengappiSeireki__c,
                                                    BotsunengappiSeireki__c,
                                                    OfferingJokyo__c,
                                                    IchijiHozonFlg__c, 
                                                    // KiboKingaku__c, 
                                                    GoanchiMenkaiKiboUmu__c, 
                                                    GoanchisakiJusho__c, 
                                                    ShiharaiHohoMikakuteiRiyu__c, 
                                                    ShiharaiHohoMikakuteiRiyu2__c, 
                                                    TaioYusenRiyuShosai__c, 
                                                    SogishaTsuikaEigyoNg__c, 
                                                    RyokinAnnaiBiko__c, 
                                                    RyokinhyoRiyoStatus__c, 
                                                    AllianceRef__c, 
                                                    Tel_Sogifollow_SmsPermission__c, 
                                                    BodaijiSoryoTehaiBiko__c, 
                                                    SonotaGoanchiKanrenTokkijiko__c, 
                                                    JizenJizenSheetTeishutsuzumi__c, 
                                                    SurveySendWayHopeEmail__c, 
                                                    SurveySendWayHopeSms__c, 
                                                    SurveyDiscountAgreeStatus__c, 
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
                                                    JogaiKubun__c, 
                                                    PlanBiko__c, 
                                                    ShikijoKasojoBiko__c, 
                                                    AimitsumoriHiaringuSha__c, 
                                                    AimitsumoriJokyo__c, 
                                                    AimitsumoriPointKakaku__c, 
                                                    AimitsumoriPointShikijo__c, 
                                                    AimitsumoriPointSonota__c, 
                                                    KakakuOffering__c, 
                                                    AimitsumoriHiaringuBiko__c, 
                                                    YorisoWoSittaKikkake__c, 
                                                    (
                                                    select Id, 
                                                            Name,
                                                            OpportunityRef__c,
                                                            Comment__c,
                                                            CrossSellingSakiOpportunityRef__c,
                                                            OtaiShienSogiyoRef__c,
                                                            KiboNashiNoRiyu__c,
                                                            Juchubi__c,
                                                            TeianKekka__c,
                                                            TeianShaRef__c,
                                                            TeianShohin__c,
                                                            Teianbi__c,
                                                            RiyuBiko__c 
                                                    from OtaiShienSogiyos__r
                                                    order by CreatedDate 
                                                    )
                                                FROM OtaiShienSogiyo__c 
                                                where OpportunityRef__c = :oppId];

        if(otaList.size() > 0){
            ota = otaList.get(0);

            goannaizumiRyuijikoSlt = String.isBlank(ota.GoannaizumiRyuijiko__c) ? new List<String>() : ota.GoannaizumiRyuijiko__c.split(';');
            goannaizumiRyuijikoSlt2 = String.isBlank(ota.GoannaizumiRyuijiko2__c) ? new List<String>() : ota.GoannaizumiRyuijiko2__c.split(';');

            for(CrossSellingTeian__c cst : ota.OtaiShienSogiyos__r){
                crossSellingTeianList.add(cst);
            }

            if(ota.Konnyusaki__c == '葬儀社'){
                konnyusakiSogishaTeikeiId = ota.KonnyusakiSogishaRef__c;
                konnyusakiSogishaTeikeiName = ota.KonnyusakiSaijoText__c;
                konnyusakiSogishaTeikeiJokyo = ota.TeikeiJokyo__c;
            }
            else if(ota.Konnyusaki__c == '火葬場'){
                konnyusakiKasobaTeikeiId = ota.KonnyusakiKasobaRef__c;
                konnyusakiKasobaTeikeiName = ota.KonnyusakiKasobaText__c;
            }
            else if(ota.Konnyusaki__c == '斎場'){
                konnyusakiSaijoTeikeiId = ota.KonnyusakiSaijoRef__c;
                konnyusakiSaijoTeikeiName = ota.KonnyusakiSaijoText__c;
                konnyusakiSaijoTeikeiJokyo = ota.TeikeiJokyo__c;
            }
            if(ota.AnkenShubetsu__c != null && ota.AnkenShubetsu__c != ''){
                ankenShubetsu = ota.AnkenShubetsu__c;
            }
            
            toiawaseJogaiKubun = ota.JogaiKubun__c;
        }
        
        if(crossSellingTeianList.size() == 0){
            CrossSellingTeian__c newCst = new CrossSellingTeian__c();
            crossSellingTeianList.add(newCst);
        }

        //issues3806--Start--
        TaishoushaJokyo = ota.TaishoushaJokyo__c;
        TaishoshaKyojuKeitai = ota.TaishoshaKyojuKeitai__c;
        TaishoshaYomeiKikan = ota.TaishoshaYomeiKikan__c;
        TaishoushaJokyoGenzai = ota.TaishoushaJokyoGenzai__c;
        TaishoshaKyojuKeitaiGenzai = ota.TaishoshaKyojuKeitaiGenzai__c;
        TaishoshaYomeiKikanGenzai = ota.TaishoshaYomeiKikanGenzai__c;
        ToiawaseKiinsha = ota.ToiawaseKiinsha__c;
        if(ReportData.size() > 0){
            ReportURL = '/lightning/r/Report/' + ReportData[0].id + '/view?fv0=' + oppId;
        }
        //issues3806--End--

        KakakuOffering = ota.KakakuOffering__c;
        AimitsumoriJokyo = ota.AimitsumoriJokyo__c;
        YorisoWoSittaKikkake = ota.YorisoWoSittaKikkake__c;

        if(!ota.IchijiHozonFlg__c){
            onloadFlg = false;
            setOpportunityValue();
        }

        sltTaskList();

        WaribikiSummary.DataCtxProvider dcp = new WaribikiSummary.DataCtxProvider();
        WaribikiSummary.DataContext dc = dcp.getDataCtx(oppId);
        waribikiList = dc.entries;

        for(WaribikiSummary.WaribikiSummaryEntry wari : waribikiList){
            if(wari.name == '事前アンケート割　：'){
                jizenJunbiWariFlg = wari.descr == 'あり' ? true : false;
            }
        }

        setBotsunengappi();

        ota.BotsunengappiWareki__c = JpCalendar.convertSeirekiToWareki(ota.BotsunengappiSeireki__c);
        setNenrei();

        initWaribiki();

        bouquetCampaignCheck();

        for(SwitchLongTextTemplete__c sltSwitchLongTextTemplete : [select Id, Body__c, Title__c, ShiyoBasho__c from SwitchLongTextTemplete__c order by SortOrder__c]){
            SwitchLongTextTempleteWrap tempSwitchLongTextTempleteWrap = new SwitchLongTextTempleteWrap();
            tempSwitchLongTextTempleteWrap.longTextTemplete = sltSwitchLongTextTemplete;
            if(sltSwitchLongTextTemplete.ShiyoBasho__c == '送客書記載事項') sokyakushoKisaijikoLTTempleteWrapList.add(tempSwitchLongTextTempleteWrap);
        }

        if(opp.SimpleYasugoRef__r.MoshuRef__r.PersonBirthdate != null){
            Date dMoshuTanjobi = opp.SimpleYasugoRef__r.MoshuRef__r.PersonBirthdate;
            moshuTanshobi = dMoshuTanjobi.year() + '/' + dMoshuTanjobi.month() + '/' + dMoshuTanjobi.day();
        }
    }

    public Boolean campaignSogiyoBouquetFlg {get;set;}

    private void bouquetCampaignCheck(){
        if(opp.Account.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId()) return;

        if([select Id from Achievement__c where TorihikiSakiRef__c = :opp.AccountId and Syubetsu__c = 'campaign_sougi_bouquet' and YukoKaishiBi__c <= :date.today() and YukoShuryoBi__c >= :date.today()].size() > 0) campaignSogiyoBouquetFlg = true;
    }

    public void sltTaskList(){
        contactHistoryList = new List<ContactHistory>();

        hikitsugiList = TaskDao.sltTaskTaskById(oppId);
        for(Task hikitsugi : hikitsugiList){
            if(hikitsugi.Status != '完了'){
                mikanryoTaskFlg = true;
                break;
            }
        }

        String taskQuery = 'select ' + 
                            'Id, ' + 
                            'Subject, ' + 
                            'Description, ' + 
                            'WhoId, ' + 
                            'WhatId, ' + 
                            'ActivityDate, ' + 
                            'OwnerId, ' + 
                            'RecordType.DeveloperName, ' + 
                            'KadenSogisha__c, ' + 
                            'KadenSogisha__r.Name, ' + 
                            'TaioFukaRiyu__c, ' + 
                            'TaioFukaRiyuSonota__c, ' + 
                            'Kijitsu__c, ' + 
                            'ServiceType__c, ' + 
                            'ShiborikomiJoken__c, ' + 
                            'YokenSyubetsu__c, ' + 
                            'SaisetteiKijitsu__c, ' + 
                            'CreatedDate, ' + 
                            'CreatedById, ' + 
                            'CreatedBy.Name, ' + 
                            'LastModifiedDate, ' + 
                            'LastModifiedBy.Name, ' + 
                            'Claim__c, ' + 
                            'WavUrlImg__c, ' + 
                            'IsArchived ' + 
                            'from Task ' + 
                            'where (WhatId = \'' + oppId + '\' and TaskSubtype = \'Call\') ';

        if(opp.Account.RecordTypeId != Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId()){
            taskQuery += ' or (WhoId = \'' + opp.Account.PersonContactId + '\' AND TaskSubtype = \'Task\' AND RecordTypeId = \'' + Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('BizTel').getRecordTypeId() + '\')';
        }

        taskQuery += ' order by Kijitsu__c desc ALL ROWS';

        for(Task t : Database.query(taskQuery)){
            ContactHistory c = new ContactHistory(
                                                    'Task',
                                                    t.CreatedDate, 
                                                    t,
                                                    null);
            contactHistoryList.add(c);
        }

        for(VOC__c v : [select Id, Name, Naiyo__c, VOCType__c, Keiro__c, HasshinmotoFrom__c, HasshinsakiTo__c, CreatedBy.Id, CreatedBy.Name, CreatedDate, LastModifiedBy.Name, LastModifiedDate, OwnerId, TaishoRepMeiRef__r.Id, TaishoRepMeiRef__r.Name, TaishoPartnerMeiRef__r.Id, TaishoPartnerMeiRef__r.Name, Sonota__c from VOC__c where TaishoOpportunityRef__c = :oppId]){
            ContactHistory c = new ContactHistory(
                                                    'VOC',
                                                    v.CreatedDate, 
                                                    null,
                                                    v);
            contactHistoryList.add(c);
        }
        contactHistoryList = sortContactHistory(contactHistoryList);
    }

    public void onloadSetOpportunityValue(){
        onloadFlg = false;
        setOpportunityValue();
    }

    public void setBotsunengappi(){
        if(ota.SeinengappiWareki__c == null || ota.SeinengappiWareki__c == ''){
            nengoValue = '昭和';
            warekiNen = '';
            warekiTsuki = '';
            warekiHi = '';
        }
        else{
            String tempNengo = ota.SeinengappiWareki__c.trim().substring(0,2);
            if(tempNengo == '明治' || 
                tempNengo == '大正' ||
                tempNengo == '昭和' ||
                tempNengo == '平成' ||
                tempNengo == '令和'){
                nengoValue = tempNengo;
            }
            String tempNenTsukiHi = ota.SeinengappiWareki__c.substring(2);
            Integer indexNen = tempNenTsukiHi.indexOf('年');
            Integer indexTsuki = tempNenTsukiHi.indexOf('月');
            Integer indexHi = tempNenTsukiHi.indexOf('日');
            String tempNen = tempNenTsukiHi.substring(0, indexNen);
            String tempTsuki = tempNenTsukiHi.substring(indexNen + 1, indexTsuki);
            String tempHi = tempNenTsukiHi.substring(indexTsuki + 1, indexHi);
            warekiNen = tempNen;
            warekiTsuki = tempTsuki;
            warekiHi = tempHi;
        }
    }

    public void setOpportunityValue(){
        ota.FreeText__c = '';
        if(ota.OpportunityRef__c == null){
            ota.OpportunityRef__c = oppId;
        }

        if(opp.Account.RecordTypeId != Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId()){
            ota.SodanshaRef__c = opp.AccountId;
            ota.SodanshaSeiKana__c = opp.Account.LastNameFurigana__pc;
            ota.SodanshaMeiKana__c = opp.Account.FirstNameFurigana__pc;
            ota.SodanshaSei__c = opp.Account.LastName;
            ota.SodanshaMei__c = opp.Account.FirstName;
            ota.SodanshaSeibetsu__c = opp.Account.Gender__pc;
            ota.MobilePhone__c = opp.Account.MobilePhone__c;
            ota.Phone__c = opp.Account.Phone;
            if(opp.Account.YusenTelNoKubun__c == '携帯1'){
                ota.TelNoPrimaryKubun__c = '携帯電話';
            }
            else if(opp.Account.YusenTelNoKubun__c == '電話1'){
                ota.TelNoPrimaryKubun__c = '固定電話';
            }

            ota.ShiryoseikyushaMail__c = opp.Account.MailAddress__c;
            ota.ShiryoseikyushaPostalCode__c = opp.Account.BillingPostalCode;
            ota.ShiryoseikyushaStateText__c = opp.Account.BillingState;
            ota.ShiryoseikyushaCity__c = opp.Account.BillingCity;
            ota.ShiryoseikyushaStreet__c = opp.Account.BillingStreet;
            ota.SodanshaMemberTourokuZumi__c = opp.Account.MemberTourokuZumi__c;
            ota.BodaijiSoryoTehaiBiko__c = opp.Account.BodaijiSoryoTehaiBiko__c;
            ota.JizenJizenSheetTeishutsuzumi__c = opp.Account.JizenJizenSheetTeishutsuzumi__c;
            ota.Tel_Sogifollow_SmsPermission__c = opp.Account.Tel_Sogifollow_SmsPermission__c;
        }
        else{
            ota.SodanshaSeiKana__c = '';
            ota.SodanshaMeiKana__c = '';
            ota.SodanshaSei__c = '';
            ota.SodanshaMei__c = '';
            ota.SodanshaSeibetsu__c = '';
            ota.MobilePhone__c = '';
            ota.Phone__c = '';
            ota.TelNoPrimaryKubun__c = '';
            ota.ShiryoseikyushaMail__c = '';
            ota.ShiryoseikyushaPostalCode__c = '';
            ota.ShiryoseikyushaStateText__c = '';
            ota.ShiryoseikyushaCity__c = '';
            ota.ShiryoseikyushaStreet__c = '';
            ota.SodanshaMemberTourokuZumi__c = false;
        }

        //issues3806--Start--
        ota.TaishoushaJokyo__c = opp.TaishoushaJokyo__c;
        TaishoushaJokyo = opp.TaishoushaJokyo__c;

        ota.TaishoshaKyojuKeitai__c = opp.TaishoshaKyojuKeitai__c;
        TaishoshaKyojuKeitai = opp.TaishoshaKyojuKeitai__c;

        ota.TaishoshaYomeiKikan__c = opp.TaishoshaYomeiKikan__c;
        TaishoshaYomeiKikan = opp.TaishoshaYomeiKikan__c;

        ota.TaishoushaJokyoGenzai__c = opp.TaishoushaJokyoGenzai__c;
        TaishoushaJokyoGenzai = opp.TaishoushaJokyoGenzai__c;

        ota.TaishoshaKyojuKeitaiGenzai__c = opp.TaishoshaKyojuKeitaiGenzai__c;
        TaishoshaKyojuKeitaiGenzai = opp.TaishoshaKyojuKeitaiGenzai__c;

        ota.TaishoshaYomeiKikanGenzai__c = opp.TaishoshaYomeiKikanGenzai__c;
        TaishoshaYomeiKikanGenzai = opp.TaishoshaYomeiKikanGenzai__c;

        ota.ToiawaseKiinsha__c = opp.ToiawaseKiinsha__c;
        ToiawaseKiinsha = opp.ToiawaseKiinsha__c;

        ota.SogiKPIGenzai__c = opp.SogiKPIGenzai__c;
        ota.KinkyudoLVGenzai__c = opp.KinkyudoLVGenzai__c;
        ota.SoteiLeadTimeGenzai__c = opp.SoteiLeadTimeGenzai__c;
        ota.SogiKPIGenzaiKoshinbi__c = opp.SogiKPIGenzaiKoshinbi__c;
        ota.TaishoushaJokyoKeteiFlg__c = opp.TaishoushaJokyoKeteiFlg__c;

        if(ReportData.size() > 0){
            ReportURL = '/lightning/r/Report/' + ReportData[0].id + '/view?fv0=' + oppId;
        }
       //issues3806--End--

        ota.KakakuOffering__c = opp.KakakuOffering__c;
        KakakuOffering = opp.KakakuOffering__c;

        ota.AimitsumoriJokyo__c = opp.AimitsumoriJokyo__c;
        AimitsumoriJokyo = opp.AimitsumoriJokyo__c;

        ota.YorisoWoSittaKikkake__c = opp.YorisoWoSittaKikkake__c;
        YorisoWoSittaKikkake = opp.YorisoWoSittaKikkake__c;

        ota.BenefitOneID__c = opp.BenefitOneID__c;
        ota.BenefitOneName__c = opp.BenefitOneName__c;
        ota.PostalClubKaiinBango__c = opp.PostalClubKaiinBango__c;
        ota.AllianceRef__c = opp.AllianceRef__c;
        ota.SurveySendWayHopeEmail__c = opp.SurveySendWayHopeEmail__c;
        ota.SurveySendWayHopeSms__c = opp.SurveySendWayHopeSms__c;
        ota.SurveyDiscountAgreeStatus__c = opp.SurveyDiscountAgreeStatus__c;
        //issues3806--Start--
        //コメントアウト
        //ota.TaishoshasamaKyojuKeitai__c = opp.SimpleYasugoRef__r.TaishoshasamaKyojuKeitai__c;
        //issues3806--End--
        ota.TaishoshaSei__c = opp.SimpleYasugoRef__r.TaishoshaRef__r.LastName;
        ota.TaishoshaMei__c = opp.SimpleYasugoRef__r.TaishoshaRef__r.FirstName;
        ota.TaishoshaSeiKana__c = opp.SimpleYasugoRef__r.TaishoshaRef__r.LastNameFurigana__pc;
        ota.TaishoshaMeiKana__c = opp.SimpleYasugoRef__r.TaishoshaRef__r.FirstNameFurigana__pc;
        ota.TaishoshaSeibetsu__c = opp.SimpleYasugoRef__r.TaishoshaRef__r.Gender__pc;
        ota.SeinengappiWareki__c = opp.SimpleYasugoRef__r.TaishoshaRef__r.SeinengappiWareki__c;
        setBotsunengappi();

        ota.TaishoshaPostalCode__c = opp.SimpleYasugoRef__r.TaishoshaRef__r.BillingPostalCode;
        ota.TaiishoshaStateText__c = opp.SimpleYasugoRef__r.TaishoshaRef__r.BillingState;
        ota.TaishoshaCity__c = opp.SimpleYasugoRef__r.TaishoshaRef__r.BillingCity;
        ota.TaishoshaStreet__c = opp.SimpleYasugoRef__r.TaishoshaRef__r.BillingStreet;
        ota.Syushi__c = opp.SimpleYasugoRef__r.TaishoshaRef__r.Syushi__c;
        ota.Syuha__c = opp.SimpleYasugoRef__r.TaishoshaRef__r.Syuha__c;
        ota.BodaijinoUmu__c = opp.SimpleYasugoRef__r.TaishoshaRef__r.BodaijinoUmu__c;
        ota.HakaUmuKubun__c = opp.SimpleYasugoRef__r.TaishoshaRef__r.HakaUmuKubun__c;

        taishogaiPlanMsg = '';
        ota.KiboKeishiki__c = '';
        if(!String.isBlank(opp.SimpleYasugoRef__r.SogiPlanUketsuke__c)){
            if(oppPlanOtaPlanTable.contains(opp.SimpleYasugoRef__r.SogiPlanUketsuke__c)){
                ota.KiboKeishiki__c = opp.SimpleYasugoRef__r.SogiPlanUketsuke__c;
            }
            else{
                taishogaiPlanMsg = 'Switch対象外プランが設定されています「' + opp.SimpleYasugoRef__r.SogiPlanUketsuke__c + '」';
            }
        }
        ota.ButsuguNashiKibo__c = opp.SimpleYasugoRef__r.ButsuguNashiKibo__c;
        ota.KagobanaKibo__c = opp.SimpleYasugoRef__r.KagobanaKibo__c;
        ota.KanjoHanatabaKibo__c = opp.SimpleYasugoRef__r.KanjoHanatabaKibo__c;
        ota.SaidanKibo__c = opp.SimpleYasugoRef__r.SaidanKibo__c;
        ota.MakurabanaKibo__c = opp.SimpleYasugoRef__r.MakurabanaKibo__c;

        ota.KiboGoanchisaki__c = opp.SimpleYasugoRef__r.KiboGoanchisaki__c;
        ota.MonkArrangements__c = opp.SimpleYasugoRef__r.MonkArrangements__c;
        ota.FamilyTempleObtainConsensus__c = opp.SimpleYasugoRef__r.FamilyTempleObtainConsensus__c;
        ota.SanretsushaShinzokuFrom__c = opp.SimpleYasugoRef__r.NumberRelatives__c;
        ota.SanretsushaShinzokuTo__c = opp.SimpleYasugoRef__r.SanretsushaShinzokuTo__c;
        ota.SanretsushaShinzokuigaiFrom__c = opp.SimpleYasugoRef__r.MournersNumber__c;
        ota.SanretsushaShinzokuigaiTo__c = opp.SimpleYasugoRef__r.SanretsushaShinzokuigaiTo__c;
        ota.Kaimyojuyo__c = opp.SimpleYasugoRef__r.Kaimyojuyo__c;
        ota.Kaimyo__c = opp.SimpleYasugoRef__r.Kaimyo__c;
        ota.MoshuNoJuminhyoRef__c = opp.SimpleYasugoRef__r.MoshuNoJuminhyoRef__c;
        ota.ZokugaraSodanshaNitottenoTaishosha__c = opp.SimpleYasugoRef__r.ZokugaraSodanshaNitottenoTaishosha__c;
        ota.PreExecuteArea__c = opp.SimpleYasugoRef__r.KiboAreaRef__c;
        ota.PreExecuteArea2__c = opp.SimpleYasugoRef__r.KiboArea2Ref__c;
        ota.PreExecuteArea3__c = opp.SimpleYasugoRef__r.KiboArea3Ref__c;
        ota.PreExecuteArea4__c = opp.SimpleYasugoRef__r.KiboArea4Ref__c;
        ota.Ketteisha__c = opp.Ketteisha__c;
        ota.Shiharaihouhou__c = opp.KiboShiharaiHouhou__c;
        ota.MemberSeidoGoannaiJokyo__c = opp.Account.MemberSeidoGoannaiJokyo__c;
        ota.JizenJunbiSheetGoannaiJokyo__c = opp.SimpleYasugoRef__r.JizenJunbiSheetGoannaiJokyo__c;
        ota.JizenJunbiSheetGoteishutsuShudan__c = opp.SimpleYasugoRef__r.JizenJunbiSheetGoteishutsuShudan__c;
        ota.JizenJunbiSheetDairiNyuryokuTantoshaRef__c = opp.SimpleYasugoRef__r.JizenJunbiSheetDairiNyuryokuTantoshaRef__c;
        ota.PreliminaryConsultationDate__c = opp.SimpleYasugoRef__r.PreliminaryConsultationDate__c;
        ota.JuyoRenrakuJiko__c = opp.JuyoRenrakuJiko__c;
        ota.Shiharaihouhou2__c = opp.KiboShiharaiHouhou__c;
        ota.ShiharaiHohoMikakuteiRiyu__c = opp.ShiharaiHohoMikakuteiRiyu__c;
        ota.ShiharaiHohoMikakuteiRiyu2__c = opp.ShiharaiHohoMikakuteiRiyu__c;
        ota.OmukaeSakiName__c = opp.SimpleYasugoRef__r.OmukaeSakiName__c;
        ota.OmukaeSakiJusho__c = opp.SimpleYasugoRef__r.OmukaeSakiStreet__c;
        ota.SimpleYasugoKeiyakuRef__c = opp.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__c;
        ota.TaiouKanouRiyu__c = opp.SimpleYasugoRef__r.TaiouKanouRiyu__c;
        ota.SokyakushoKisaiJiko__c = opp.SimpleYasugoRef__r.SokyakushoKisaiJiko__c;
        if(opp.OpportunityLineItems.size() > 0){
            ota.ShohinRef__c = opp.OpportunityLineItems.get(0).Product2Id;
        }
        else{
            ota.ShohinRef__c = null;
        }
        
        ota.BotsunengappiWareki__c = opp.SimpleYasugoRef__r.TaishoshaRef__r.BotsunengappiWareki__c;

        if(opp.SimpleYasugoRef__r.TaishoshaRef__r.JuminhyouState__c != null && opp.SimpleYasugoRef__r.TaishoshaRef__r.JuminhyouState__c != '' && 
            opp.SimpleYasugoRef__r.TaishoshaRef__r.JuminhyouCity__c != null && opp.SimpleYasugoRef__r.TaishoshaRef__r.JuminhyouCity__c != ''){
            String sltShikugun = opp.SimpleYasugoRef__r.TaishoshaRef__r.JuminhyouState__c + opp.SimpleYasugoRef__r.TaishoshaRef__r.JuminhyouCity__c;
            List<Shikugun__c> shikugunList = [select Id from Shikugun__c where Name = :sltShikugun];
            if(shikugunList.size() == 1){
                ota.TaishoshaNoJuminhyoRef__c = shikugunList.get(0).Id;
            }
            else{
                ota.TaishoshaNoJuminhyoRef__c = null;
            }
        }
        else{
            ota.TaishoshaNoJuminhyoRef__c = null;
        }
        ota.AnchiRyokin2hakuOr3haku__c = opp.SimpleYasugoRef__r.AnchiRyokin2hakuOr3haku__c;
        ota.ShikijoShiyoryo2man5senOr5man__c = opp.SimpleYasugoRef__r.ShikijoShiyoryo2man5senOr5man__c;
        ota.KasobaShiyoryoPlangai__c = opp.SimpleYasugoRef__r.KasobaShiyoryoPlangai__c;
        ota.HansoKyori50km__c = opp.SimpleYasugoRef__r.HansoKyori50km__c;
        ota.HansoKaisu2kaiOr3kai__c = opp.SimpleYasugoRef__r.HansoKaisu2kaiOr3kai__c;
        ota.ChokusoPlanMenkaiFuka__c = opp.SimpleYasugoRef__r.ChokusoPlanMenkaiFuka__c;
        ota.KeisatsuAnkenKenanryo__c = opp.SimpleYasugoRef__r.KeisatsuAnkenKenanryo__c;
        ota.KeisatsuAnken__c = opp.SimpleYasugoRef__r.KeisatsuAnken__c;
        ota.SosaiFujo__c = opp.SimpleYasugoRef__r.SosaiFujo__c;
        ota.TashaAnchi__c = opp.SimpleYasugoRef__r.TashaAnchi__c;
        ota.TaijiAnken__c = opp.SimpleYasugoRef__r.TaijiAnken__c;
        ota.TaishoshaRef__c = opp.SimpleYasugoRef__r.TaishoshaRef__c;
        ota.SeinengappiSeireki__c = opp.SimpleYasugoRef__r.TaishoshaRef__r.PersonBirthdate;
        ota.BotsunengappiSeireki__c = opp.SimpleYasugoRef__r.TaishoshaRef__r.PersonDeathDate__pc;
        ota.OfferingJokyo__c = opp.OfferingJokyo__c;
        ota.GoanchiMenkaiKiboUmu__c = opp.SimpleYasugoRef__r.GoanchiMenkaiKiboUmu__c;
        ota.GoanchisakiJusho__c = opp.SimpleYasugoRef__r.GoanchisakiJusho__c;
        ota.TaioYusenRiyuShosai__c = opp.SimpleYasugoRef__r.TaioYusenRiyuShosai__c;
        ota.SogishaTsuikaEigyoNg__c = opp.SimpleYasugoRef__r.SogishaTsuikaEigyoNg__c;
        ota.RyokinAnnaiBiko__c = opp.SimpleYasugoRef__r.RyokinAnnaiBiko__c;
        ota.SonotaGoanchiKanrenTokkijiko__c = opp.SimpleYasugoRef__r.SonotaGoanchiKanrenTokkijiko__c;
        goannaizumiRyuijikoSlt = String.isBlank(opp.GoannaizumiRyuijiko__c) ? new List<String>() : opp.GoannaizumiRyuijiko__c.split(';');
        goannaizumiRyuijikoSlt2 = String.isBlank(opp.GoannaizumiRyuijiko__c) ? new List<String>() : opp.GoannaizumiRyuijiko__c.split(';');
    }

    public Boolean errFlg {get;set;}
    public String hozonMsg {get;set;}
    public void temporarilySave(){

        try{

            Account sodanshaMst = new Account();

            if(ota.SodanshaRef__c == null && 
                (ota.SodanshaSeiKana__c != null || 
                    ota.SodanshaSei__c != null || 
                    ota.SodanshaMeiKana__c != null || 
                    ota.SodanshaMei__c != null || 
                    ota.SodanshaSeibetsu__c != null || 
                    ota.MobilePhone__c != null || 
                    ota.Phone__c != null || 
                    ota.ShiryoseikyushaMail__c != null || 
                    ota.ShiryoseikyushaPostalCode__c != null || 
                    ota.ShiryoseikyushaStateText__c != null || 
                    ota.ShiryoseikyushaCity__c != null || 
                    ota.ShiryoseikyushaStreet__c != null || 
                    ota.BodaijiSoryoTehaiBiko__c != null)
                ){
                sodanshaMst.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
                sodanshaMst.LastNameFurigana__pc = ota.SodanshaSeiKana__c;
                if(String.isBlank(ota.SodanshaSei__c)){
                    if(String.isBlank(ota.SodanshaSeiKana__c)){
                        String sodanshaSei = '相談者' + opp.ShodanBangoF__c;
                        sodanshaMst.LastName = sodanshaSei;
                        ota.SodanshaSei__c = sodanshaSei;
                    }
                    else{
                        sodanshaMst.LastName = ota.SodanshaSeiKana__c;
                        ota.SodanshaSei__c = ota.SodanshaSeiKana__c;
                    }
                }
                else{
                    sodanshaMst.LastName = ota.SodanshaSei__c;
                }

                if(!String.isBlank(ota.SodanshaMei__c)){
                    sodanshaMst.FirstName = ota.SodanshaMei__c;
                }
                else if(!String.isBlank(ota.SodanshaMeiKana__c)){
                    sodanshaMst.FirstName = ota.SodanshaMeiKana__c;
                    ota.SodanshaMei__c = ota.SodanshaMeiKana__c;
                }
                sodanshaMst.MobilePhone__c = ota.MobilePhone__c;
                sodanshaMst.MailAddress__c = ota.ShiryoseikyushaMail__c;
                if(ota.SodanshaMemberTourokuZumi__c){
                    sodanshaMst.MemberTourokuZumi__c = ota.SodanshaMemberTourokuZumi__c;
                }
                sodanshaMst.Tel_Sogifollow_SmsPermission__c = ota.Tel_Sogifollow_SmsPermission__c;
                sodanshaMst.JizenwariShoshoHassoDate__c = ota.JizenwariShoshoHassoDate__c;

                Database.SaveResult saveResult2 = Database.insert(sodanshaMst, false);
                if (!saveResult2.isSuccess()) {
                    for (Database.Error error : saveResult2.getErrors()) {
                        if (error instanceof Database.DuplicateError) {
                            Database.DMLOptions dml = new Database.DMLOptions();
                            dml.DuplicateRuleHeader.AllowSave = true;
                            Database.SaveResult sr2 = Database.insert(sodanshaMst, dml);
                        }
                        else {
                            errFlg = true;
                            hozonMsg = 'エラーが発生しました。' + error.getMessage();
                            return;
                        }
                    }
                }
                ota.SodanshaRef__c = sodanshaMst.id;
            }
            else{
                sodanshaMst.Id=ota.SodanshaRef__c;
                sodanshaMst.MobilePhone__c = ota.MobilePhone__c;
                sodanshaMst.MailAddress__c = ota.ShiryoseikyushaMail__c;
                if(ota.SodanshaMemberTourokuZumi__c){
                    sodanshaMst.MemberTourokuZumi__c = ota.SodanshaMemberTourokuZumi__c;
                }
                sodanshaMst.Tel_Sogifollow_SmsPermission__c = ota.Tel_Sogifollow_SmsPermission__c;

                Database.SaveResult saveResult2 = Database.update(sodanshaMst, false);
                if (!saveResult2.isSuccess()) {
                    for (Database.Error error : saveResult2.getErrors()) {
                        if (error instanceof Database.DuplicateError) {
                            Database.DMLOptions dml = new Database.DMLOptions();
                            dml.DuplicateRuleHeader.AllowSave = true;
                            Database.SaveResult sr2 = Database.update(sodanshaMst, dml);
                        }
                        else {
                            errFlg = true;
                            hozonMsg = 'エラーが発生しました。' + error.getMessage();
                            return;
                        }
                    }
                }
            }

            if(ota.TaishoshaRef__c == null && 
                (ota.TaishoshaSeiKana__c != null || 
                    ota.TaishoshaMeiKana__c != null || 
                    ota.TaishoshaSei__c != null || 
                    ota.TaishoshaMei__c != null || 
                    ota.TaishoshaSeibetsu__c != null || 
                    ota.SeinengappiSeireki__c != null || 
                    ota.BotsunengappiSeireki__c != null || 
                    ota.TaishoshaPostalCode__c != null || 
                    ota.TaiishoshaStateText__c != null || 
                    ota.TaishoshaCity__c != null || 
                    ota.TaishoshaStreet__c != null || 
                    ota.BodaijinoUmu__c != null || 
                    ota.HakaUmuKubun__c != null || 
                    ota.Syushi__c != null || 
                    ota.Syuha__c != null || 
                    ota.TaishoshaNoJuminhyoRef__c != null)
                ){
                    Account taishoshaMst = new Account();
                    taishoshaMst.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
                    taishoshaMst.LastNameFurigana__pc = ota.TaishoshaSeiKana__c;
                    if(String.isBlank(ota.TaishoshaSei__c)){
                        if(String.isBlank(ota.TaishoshaSeiKana__c)){
                            String taishoshaSei = '対象者' + opp.ShodanBangoF__c;
                            taishoshaMst.LastName = taishoshaSei;
                            ota.TaishoshaSei__c = taishoshaSei;
                        }
                        else{
                            taishoshaMst.LastName = ota.TaishoshaSeiKana__c;
                            ota.TaishoshaSei__c = ota.TaishoshaSeiKana__c;
                        }
                    }
                    else{
                        taishoshaMst.LastName = ota.TaishoshaSei__c;
                    }
                    if(!String.isBlank(ota.TaishoshaMei__c)){
                        taishoshaMst.FirstName = ota.TaishoshaMei__c;
                    }
                    else if(!String.isBlank(ota.TaishoshaMeiKana__c)){
                        taishoshaMst.FirstName = ota.TaishoshaMeiKana__c;
                        ota.TaishoshaMei__c = ota.TaishoshaMeiKana__c;
                    }
                    insert taishoshaMst;
                    ota.TaishoshaRef__c = taishoshaMst.id;
            }
            
            ota.SeinengappiWareki__c = nengoValue + warekiNen + '年' + warekiTsuki + '月' + warekiHi + '日';
            ota.BotsunengappiWareki__c = JpCalendar.convertSeirekiToWareki(ota.BotsunengappiSeireki__c);
            ota.IchijiHozonFlg__c = true;

            String goannaizumiRyuijikoSlted = '';
            for(String g : goannaizumiRyuijikoSlt){
                goannaizumiRyuijikoSlted += g + ';';
            }
            ota.GoannaizumiRyuijiko__c = goannaizumiRyuijikoSlted;
            ota.GoannaizumiRyuijiko2__c = goannaizumiRyuijikoSlted;
            ota.KonnyusakiSogishaRef__c = null;
            ota.KonnyusakiSogishaText__c = '';
            ota.KonnyusakiKasobaRef__c = null;
            ota.KonnyusakiKasobaText__c = '';
            ota.KonnyusakiSaijoRef__c = null;
            ota.KonnyusakiSaijoText__c = '';
            ota.TeikeiJokyo__c = '';

            String konnyusaki = ota.Konnyusaki__c;
            if(konnyusaki == '葬儀社'){
                if(konnyusakiSogishaTeikeiId != null && konnyusakiSogishaTeikeiId != ''){
                    ota.KonnyusakiSogishaRef__c = konnyusakiSogishaTeikeiId;
                }
                ota.KonnyusakiSogishaText__c = konnyusakiSogishaTeikeiName;
                ota.TeikeiJokyo__c = konnyusakiSogishaTeikeiJokyo;
            }
            else if(konnyusaki == '火葬場'){
                if(konnyusakiKasobaTeikeiId != null && konnyusakiKasobaTeikeiId != ''){
                    ota.KonnyusakiKasobaRef__c = konnyusakiKasobaTeikeiId;
                }
                ota.KonnyusakiKasobaText__c = konnyusakiKasobaTeikeiName;
            }
            else if(konnyusaki == '斎場'){
                if(konnyusakiSogishaTeikeiId != null && konnyusakiSogishaTeikeiId != ''){
                    ota.KonnyusakiSogishaRef__c = konnyusakiSogishaTeikeiId;
                }

                if(konnyusakiSaijoTeikeiId != null && konnyusakiSaijoTeikeiId != ''){
                    ota.KonnyusakiSaijoRef__c = konnyusakiSaijoTeikeiId;
                }
                ota.KonnyusakiSaijoText__c = konnyusakiSaijoTeikeiName;
                ota.TeikeiJokyo__c = konnyusakiSaijoTeikeiJokyo;
            }

            ota.AnkenShubetsu__c = ankenShubetsu;

            //issues3806--Start--
            ota.TaishoushaJokyo__c = TaishoushaJokyo;
            ota.TaishoshaKyojuKeitai__c = TaishoshaKyojuKeitai;
            ota.TaishoshaYomeiKikan__c = TaishoshaYomeiKikan;
            ota.TaishoushaJokyoGenzai__c = TaishoushaJokyoGenzai;
            ota.TaishoshaKyojuKeitaiGenzai__c = TaishoshaKyojuKeitaiGenzai;
            ota.TaishoshaYomeiKikanGenzai__c = TaishoshaYomeiKikanGenzai;
            ota.ToiawaseKiinsha__c = ToiawaseKiinsha;
            //issues3806--End--

            ota.KakakuOffering__c = KakakuOffering;
            ota.AimitsumoriJokyo__c = AimitsumoriJokyo;
            ota.YorisoWoSittaKikkake__c = YorisoWoSittaKikkake;

            upsert ota;

            List<CrossSellingTeian__c> upsertCrossSellingTeianList = new List<CrossSellingTeian__c>();
            for(CrossSellingTeian__c crossSellingTeian : crossSellingTeianList){
                if(crossSellingTeian.TeianShohin__c != '' && 
                    crossSellingTeian.TeianShaRef__c != null && 
                    crossSellingTeian.Teianbi__c != null && 
                    crossSellingTeian.TeianKekka__c != ''){
                        CrossSellingTeian__c cloneCrossSellingTeian = crossSellingTeian;

                        if(crossSellingTeian.OtaiShienSogiyoRef__c == null){
                            cloneCrossSellingTeian.OtaiShienSogiyoRef__c = ota.Id;
                        }
                        
                        upsertCrossSellingTeianList.add(cloneCrossSellingTeian);
                }
            }
            upsert upsertCrossSellingTeianList;

            crossSellingTeianList = [select Id, 
                                                            Name,
                                                            OpportunityRef__c,
                                                            Comment__c,
                                                            CrossSellingSakiOpportunityRef__c,
                                                            OtaiShienSogiyoRef__c,
                                                            KiboNashiNoRiyu__c,
                                                            Juchubi__c,
                                                            TeianKekka__c,
                                                            TeianShaRef__c,
                                                            TeianShohin__c,
                                                            Teianbi__c,
                                                            RiyuBiko__c 
                                                    from CrossSellingTeian__c 
                                                    where Id = :upsertCrossSellingTeianList 
                                                    order by CreatedDate];
            delete delCrossSellingTeianList;

            String okyakusamaPlanNaiyoSelect = '';
            for(String val : contactHistoryWrap.okyakusamaPlanNaiyoValue){ okyakusamaPlanNaiyoSelect += val + ';'; }

            String okyakusamaPlanKingakuSelect = '';
            for(String val : contactHistoryWrap.okyakusamaPlanKingakuValue){ okyakusamaPlanKingakuSelect += val + ';'; }

            String okyakusamaOsoshiYoyakuSelect = '';
            for(String val : contactHistoryWrap.okyakusamaOsoshiYoyakuValue){ okyakusamaOsoshiYoyakuSelect += val + ';'; }

            String okyakusamaKeisatsuAnkenSelect = '';
            for(String val : contactHistoryWrap.okyakusamaKeisatsuAnkenValue){ okyakusamaKeisatsuAnkenSelect += val + ';'; }

            String okyakusamaSosaiFujoSelect = '';
            for(String val : contactHistoryWrap.okyakusamaSosaiFujoValue){ okyakusamaSosaiFujoSelect += val + ';'; }

            String okyakusamaHenkinHoshoSelect = '';
            for(String val : contactHistoryWrap.okyakusamaHenkinHoshoValue){ okyakusamaHenkinHoshoSelect += val + ';'; }

            String okyakusamaSoryoTehaiAnnaiSelect = '';
            for(String val : contactHistoryWrap.okyakusamaSoryoTehaiAnnaiValue){ okyakusamaSoryoTehaiAnnaiSelect += val + ';'; }
            
            
            contactHistoryWrap.contactHistory.OkyakusamaPlanNaiyo__c = okyakusamaPlanNaiyoSelect;
            contactHistoryWrap.contactHistory.OkyakusamaPlanKingaku__c = okyakusamaPlanKingakuSelect;
            contactHistoryWrap.contactHistory.OkyakusamaOsoshiYoyaku__c = okyakusamaOsoshiYoyakuSelect;
            contactHistoryWrap.contactHistory.OkyakusamaKeisatsuAnken__c = okyakusamaKeisatsuAnkenSelect;
            contactHistoryWrap.contactHistory.OkyakusamaSosaiFujo__c = okyakusamaSosaiFujoSelect;
            contactHistoryWrap.contactHistory.OkyakusamaHenkinHosho__c = okyakusamaHenkinHoshoSelect;
            contactHistoryWrap.contactHistory.OkyakusamaSoryoTehaiAnnai__c = okyakusamaSoryoTehaiAnnaiSelect;
            contactHistoryWrap.contactHistory.SogishaTsuyaHour__c = contactHistoryWrap.tsuyaHour;
            contactHistoryWrap.contactHistory.SogishaTsuyaMinute__c = contactHistoryWrap.tsuyaMinute;
            contactHistoryWrap.contactHistory.SogishaKokubetsushikiHour__c = contactHistoryWrap.kokubetsushikiHour;
            contactHistoryWrap.contactHistory.SogishaKokubetsushikiMinute__c = contactHistoryWrap.kokubetsushikiMinute;
            contactHistoryWrap.contactHistory.SogishaKasoHour__c = contactHistoryWrap.kasoHour;
            contactHistoryWrap.contactHistory.SogishaKasoMinute__c = contactHistoryWrap.kasoMinute;
            upsert contactHistoryWrap.contactHistory;

            errFlg = false;
            hozonMsg = '保存しました ※商談へ反映されていません';
        }
        catch(Exception e){
            errFlg = true;
            hozonMsg = 'エラーが発生しました。' + e.getMessage();
        }
    }

    public String saveResult {get;set;}
    public Pagereference save(){
        temporarilySave();

        if(errFlg){
            return null;
        }

        Pagereference pr = Page.SwitchConfirm;
        pr.getParameters().put('otaid', ota.id);
        pr.getParameters().put('oppid', oppId);
        return pr;
    }

    public void saijotoiawase() {

        ota.KonnyusakiSogishaRef__c = null;
        ota.KonnyusakiKasobaRef__c = null;
        ota.KonnyusakiSaijoRef__c = null;
        ota.TeikeiJokyo__c = '';

        if(konnyusakiSogishaTeikeiId != null && konnyusakiSogishaTeikeiId != ''){
            ota.KonnyusakiSogishaRef__c = konnyusakiSogishaTeikeiId;
        } 
        if(konnyusakiKasobaTeikeiId != null && konnyusakiKasobaTeikeiId != ''){
            ota.KonnyusakiKasobaRef__c = konnyusakiKasobaTeikeiId;
        }
        if(konnyusakiSaijoTeikeiId != null && konnyusakiSaijoTeikeiId != ''){
            ota.KonnyusakiSaijoRef__c = konnyusakiSaijoTeikeiId;
        }
        ota.AnkenShubetsu__c = ankenShubetsu;
        ota.JogaiKubun__c = toiawaseJogaiKubun;
        if(ota.Konnyusaki__c == '葬儀社'){
            ota.TeikeiJokyo__c = konnyusakiSogishaTeikeiJokyo;
        }
        else if(ota.Konnyusaki__c == '斎場'){
            ota.TeikeiJokyo__c = konnyusakiSaijoTeikeiJokyo;
        }
        upsert ota;

        SaijoToiawaseCtl.futureSaijoJogai(oppId, 
                                            opp.SimpleYasugoRef__c, 
                                            ota.ToiawaseNaiyo__c, 
                                            ota.Konnyusaki__c, 
                                            ota.KonnyusakiSogishaRef__c, 
                                            ota.KonnyusakiSogishaText__c, 
                                            konnyusakiSogishaTeikeiJokyo, 
                                            ota.KonnyusakiKasobaRef__c, 
                                            ota.KonnyusakiKasobaText__c, 
                                            ota.KonnyusakiSaijoRef__c, 
                                            ota.KonnyusakiSaijoText__c, 
                                            konnyusakiSaijoTeikeiJokyo, 
                                            ota.KonnyusakiKyogoTasha__c, 
                                            ota.KonnyusakiKyogoTashaText__c, 
                                            ota.TashaSodanJokyo__c, 
                                            ankenShubetsu, 
                                            toiawaseJogaiKubun);

        hozonMsg = '斎場問合せ処理を受付ました';
    }

    public SogiTalkScript__mdt sogiTalkScript {get;set;}
 
    public pagereference setTalkScript(){
        String talkscriptKey = Apexpages.currentPage().getParameters().get('talkscriptKey');
        sogiTalkScript = [SELECT TalkScript__c FROM SogiTalkScript__mdt where DeveloperName = :talkscriptKey];

        return null;
    }

    public List<SelectOption> nengoPickList{
        get{
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('明治', '明治'));
            options.add(new SelectOption('大正', '大正'));
            options.add(new SelectOption('昭和', '昭和'));
            options.add(new SelectOption('平成', '平成'));
            options.add(new SelectOption('令和', '令和'));
            return options;
        }
        set;
    }

    public String nengoValue {get; set;}
    public void setSeinengappiSeirekiNenTsukiHi(){
        ota.SeinengappiSeireki__c = JpCalendar.convertWarekiToSeireki(nengoValue + warekiNen + '年' + warekiTsuki + '月' + warekiHi + '日');
        setNenrei();
    }

    public void setBotsunengappiWarekiNenTsukiHi(){
        ota.BotsunengappiWareki__c = JpCalendar.convertSeirekiToWareki(ota.BotsunengappiSeireki__c);
        setNenrei();
    }

    public String strNenrei {get;set;}
    public void setNenrei(){
        Integer nissu = 0;
        if(ota.SeinengappiSeireki__c != null && ota.BotsunengappiSeireki__c != null){
            nissu = ota.SeinengappiSeireki__c.daysBetween(ota.BotsunengappiSeireki__c);
            strNenrei = String.valueOf(nissu / 365);
        }
        else if(ota.SeinengappiSeireki__c != null && ota.BotsunengappiSeireki__c == null){
            nissu = ota.SeinengappiSeireki__c.daysBetween(Date.today());
            strNenrei = String.valueOf(nissu / 365);
        }
        else{
            strNenrei = '';
        }
    }

    public String sogishaKadenMsg {get;set;}
    public void createSogishaKaden(){
        sogishaKaden.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('SogishaKadenKiroku').getRecordTypeId();
        sogishaKaden.WhoId = opp.Account.PersonContactId;
        sogishaKaden.WhatId = oppId;
        sogishaKaden.Status = '完了';
        sogishaKaden.Subject = '葬儀社架電記録 [0045]';
        sogishaKaden.TaskSubtype = 'Call';
        sogishaKaden.OwnerId = UserInfo.getUserId();
        insert sogishaKaden;

        sogishaKadenMsg = '葬儀社架電を作成しました';
        sogishaKaden = new Task();
    }

    // public void setKiboKingaku(){
    //     if(!String.isBlank(ota.KiboKeishiki__c) && !String.isBlank(ota.KiboPlan__c)){
    //         Map<String, String> sltPlan = otaPlanKingakuTable.get(ota.KiboKeishiki__c);
    //         ota.KiboKingaku__c = sltPlan.get(ota.KiboPlan__c);
    //     }
    // }

    // public void setKiboPlan(){
    //     if(!String.isBlank(ota.KiboKingaku__c)){
    //         List<String> sltPlan = otaKingakuPlanTable.get(ota.KiboKingaku__c);
    //         ota.KiboKeishiki__c = sltPlan.get(0);
    //         ota.KiboPlan__c = sltPlan.get(1); 
    //     }
    // }

    public String judenLogTitle {get;set;}
    public void displayJudenLog(){
        if(judenLogTitle == '受電ログ非表示'){
            judenLogTitle = '受電ログ表示';
        }
        else{
            judenLogTitle = '受電ログ非表示';
        }
    }

    public void addCrossSellingTeian(){
        String strIndex = Apexpages.currentPage().getParameters().get('ojbAddCrossSellingTeianIndex');
        Integer iIndex = Integer.valueOf(strIndex);
        CrossSellingTeian__c newCst = new CrossSellingTeian__c(OtaiShienSogiyoRef__c=ota.Id);
        crossSellingTeianList.add(newCst);
    }

    public void delCrossSellingTeian(){
        String strIndex = Apexpages.currentPage().getParameters().get('ojbDelCrossSellingTeianIndex');
        Integer iIndex = Integer.valueOf(strIndex);
        CrossSellingTeian__c delCrossSellingTeian = crossSellingTeianList.get(iIndex);
        if(delCrossSellingTeian.Id != null){
            delCrossSellingTeianList.add(delCrossSellingTeian);
        }
        
        crossSellingTeianList.remove(iIndex);
    }

    public class ContactHistory{
            ContactHistory(
                        String objectType,
                        DateTime activitydate, 
                        Task ta,
                        VOC__c vo){
            this.objectType = objectType;
            this.activitydate = activitydate;
            this.ta = ta;
            this.vo = vo;
        }

        public String objectType{get;set;}
        public DateTime activitydate{get;set;}
        public Task ta{get;set;}
        public Voc__c vo{get;set;}
    }

    public static List<ContactHistory> sortContactHistory(List<ContactHistory> chList){
        for(Integer i = 0; i < chList.size() - 1; i++){
            for(Integer j = chList.size() - 1; j > i; j--){
                ContactHistory chTemp1 = chList.get(j - 1);
                ContactHistory chTemp2 = chList.get(j);
                if(chTemp1.activitydate < chTemp2.activitydate){
                    ContactHistory chTemp3 = chTemp1;
                    chList.set(j - 1, chTemp2);
                    chList.set(j, chTemp3);
                }
            }
        }

        return chList;
    }

    public String pToiawasenaiyo;
    public String pKonnyusaki;
    public String pTashaSodanJokyo;

    public void checkTeikeiJokyoSogisha(){
        pToiawasenaiyo = Apexpages.currentPage().getParameters().get('pToiawasenaiyo');
        pKonnyusaki = Apexpages.currentPage().getParameters().get('pKonnyusaki');
        konnyusakiSogishaTeikeiId = Apexpages.currentPage().getParameters().get('pKonnyusakiSogishaId');
        konnyusakiSogishaTeikeiName = Apexpages.currentPage().getParameters().get('pKonnyusakiSogishaName');
        pTashaSodanJokyo = Apexpages.currentPage().getParameters().get('pTashaSodanJokyo');

        if(konnyusakiSogishaTeikeiId != null && konnyusakiSogishaTeikeiId != ''){
            Keiyaku__c keiyaku = [select Id, KeiyakuJokyo__c from Keiyaku__c where Id = :konnyusakiSogishaTeikeiId];
            konnyusakiSogishaTeikeiJokyo = keiyaku.KeiyakuJokyo__c;
        }
        else if(konnyusakiSogishaTeikeiName != null && konnyusakiSogishaTeikeiName != ''){
            List<Keiyaku__c> keiyakuList = [select Id, KeiyakuJokyo__c 
                                            from Keiyaku__c 
                                            where RecordTypeId = :keiyakuSimpleRecordTypeId  
                                            AND (Teikeisaki__r.Name = :konnyusakiSogishaTeikeiName 
                                            OR Teikeisaki__r.NameYagouFurigana__c = :konnyusakiSogishaTeikeiName
                                            OR Teikeisaki__r.NameShogo__c = :konnyusakiSogishaTeikeiName
                                            OR Teikeisaki__r.NameShogoFurigana__c = :konnyusakiSogishaTeikeiName)];

            if(keiyakuList.size() > 0) {
                konnyusakiSogishaTeikeiId = keiyakuList.get(0).Id;
                konnyusakiSogishaTeikeiJokyo = keiyakuList.get(0).KeiyakuJokyo__c;
            }
            else{
                konnyusakiSogishaTeikeiId = '';
                konnyusakiSogishaTeikeiJokyo = '非提携';
            }
        }
        else{
            konnyusakiSogishaTeikeiId = '';
            konnyusakiSogishaTeikeiJokyo = '';
        }
        doAnkenShubetsu(pToiawasenaiyo, pKonnyusaki, konnyusakiSogishaTeikeiId, konnyusakiSogishaTeikeiJokyo, pTashaSodanJokyo);
    }

    public void checkTeikeiJokyoKasoba(){
        pToiawasenaiyo = Apexpages.currentPage().getParameters().get('pToiawasenaiyo');
        pKonnyusaki = Apexpages.currentPage().getParameters().get('pKonnyusaki');
        konnyusakiKasobaTeikeiId = Apexpages.currentPage().getParameters().get('pKonnyusakiKasobaId');
        konnyusakiKasobaTeikeiName = Apexpages.currentPage().getParameters().get('pKonnyusakiKasobaName');
        pTashaSodanJokyo = Apexpages.currentPage().getParameters().get('pTashaSodanJokyo');

        if(konnyusakiKasobaTeikeiId != null && konnyusakiKasobaTeikeiId != ''){
            Shisetsu__c shisetsu = [select Id from Shisetsu__c where Id = :konnyusakiKasobaTeikeiId];
            konnyusakiKasobaTeikeiId = shisetsu.Id;
        }
        else if(konnyusakiKasobaTeikeiName != null && konnyusakiKasobaTeikeiName != ''){
            List<Shisetsu__c> shisetsuList = [select Id 
                                            from Shisetsu__c 
                                            where Name = :konnyusakiKasobaTeikeiName 
                                            OR ShisetsumeiFurigana__c = :konnyusakiKasobaTeikeiName];

            if(shisetsuList.size() > 0) {
                konnyusakiKasobaTeikeiId = shisetsuList.get(0).Id;
            }
        }
        doAnkenShubetsu(pToiawasenaiyo, pKonnyusaki, konnyusakiKasobaTeikeiId, konnyusakiKasobaTeikeiName, pTashaSodanJokyo);
    }

    public void checkTeikeiJokyoSaijo(){
        pToiawasenaiyo = Apexpages.currentPage().getParameters().get('pToiawasenaiyo');
        pKonnyusaki = Apexpages.currentPage().getParameters().get('pKonnyusaki');
        konnyusakiSaijoTeikeiId = Apexpages.currentPage().getParameters().get('pKonnyusakiSaijoId');
        konnyusakiSaijoTeikeiName = Apexpages.currentPage().getParameters().get('pKonnyusakiSaijoName');
        pTashaSodanJokyo = Apexpages.currentPage().getParameters().get('pTashaSodanJokyo');

        String hoyuShutaiId = '';
        if(konnyusakiSaijoTeikeiId != null && konnyusakiSaijoTeikeiId != ''){
            Saijo__c saijo = [select Id, HoyuShutaiSogishaJiinRef__c from Saijo__c where Id = :konnyusakiSaijoTeikeiId];
            hoyuShutaiId = saijo.HoyuShutaiSogishaJiinRef__c;
        }
        else if(konnyusakiSaijoTeikeiName != null && konnyusakiSaijoTeikeiName != ''){
            List<Saijo__c> saijoList = [select Id, HoyuShutaiSogishaJiinRef__c 
                                            from Saijo__c 
                                            where (Name = :konnyusakiSaijoTeikeiName 
                                            OR KeisaiSaijoMeiKana__c = :konnyusakiSaijoTeikeiName
                                            OR SeishikiSaijoMei__c = :konnyusakiSaijoTeikeiName
                                            OR SeishikiSaijoMeiKana__c = :konnyusakiSaijoTeikeiName)];

            if(saijoList.size() > 0) {
                konnyusakiSaijoTeikeiId = saijoList.get(0).Id;
                hoyuShutaiId = saijoList.get(0).HoyuShutaiSogishaJiinRef__c;
            }
            else{
                konnyusakiSaijoTeikeiJokyo = '非提携';
            }
        }
        else{
            konnyusakiSaijoTeikeiJokyo = '';
        }

        
        if(hoyuShutaiId != ''){
            List<Keiyaku__c> keiyaku = [select Id, KeiyakuJokyo__c from Keiyaku__c where Teikeisaki__c = :hoyuShutaiId and RecordTypeId = :keiyakuSimpleRecordTypeId];
            if(keiyaku.size() > 0){
                konnyusakiSogishaTeikeiId = keiyaku.get(0).Id;
                konnyusakiSaijoTeikeiJokyo = keiyaku.get(0).KeiyakuJokyo__c;
            }
            else{
                konnyusakiSaijoTeikeiJokyo = '非提携';
            }
        }
        doAnkenShubetsu(pToiawasenaiyo, pKonnyusaki, konnyusakiSaijoTeikeiId, konnyusakiSaijoTeikeiJokyo, pTashaSodanJokyo);
    }

    public void setAnkenShubetsu(){
        String toiawase = Apexpages.currentPage().getParameters().get('pToiawase');
        String konnyusaki = Apexpages.currentPage().getParameters().get('pKonnyusaki');
        String konnyusakiId = Apexpages.currentPage().getParameters().get('pKonnyusakiId');
        String konnyusakiJokyo = Apexpages.currentPage().getParameters().get('pKonnyusakiJokyo');
        String tashaTeianJokyo = Apexpages.currentPage().getParameters().get('pTashaSodanJokyo');
        doAnkenShubetsu(toiawase, konnyusaki, konnyusakiId, konnyusakiJokyo, tashaTeianJokyo);
    }

    public String ankenShubetsu {get; set;}
    public String toiawasePhase;
    public String toiawaseJogaiKubun {get; set;}
    
    public void doAnkenShubetsu(String toiawase, String konnyusaki, String konnyusakiId, String konnyusakiJokyo, String tashaTeianJokyo){
        if(toiawase == '直ぎれ／間違い電話'){ //3
            System.debug('doAnkenShubetsu : 3');
            ankenShubetsu = '除外';
            toiawasePhase = '除外';
            toiawaseJogaiKubun = '直ぎれ／間違い電話';
        }
        else if(konnyusaki == 'それ以外'){ //4
            System.debug('doAnkenShubetsu : 4');
            ankenShubetsu = '除外';
            toiawasePhase = '除外';
            toiawaseJogaiKubun = '直ぎれ／間違い電話';
        }
        else if(tashaTeianJokyo == '葬儀依頼済'){ //5
            System.debug('doAnkenShubetsu : 5');
            ankenShubetsu = '除外';
            toiawasePhase = '除外';
            toiawaseJogaiKubun = '斎場問合せ(葬儀依頼済)';
        }
        else if(toiawase == 'マナー問合せ'){ //6
            System.debug('doAnkenShubetsu : 6');
            ankenShubetsu = '除外';
            toiawasePhase = '除外';
            toiawaseJogaiKubun = 'マナー問合せ';
        }
        else if(toiawase == '提供外サービス'){ //7
            System.debug('doAnkenShubetsu : 7');
            ankenShubetsu = '除外';
            toiawasePhase = '除外';
            toiawaseJogaiKubun = '参列問合せ';
        }
        else if(toiawase == '参列問合せ'){ //8
            System.debug('doAnkenShubetsu : 8');
            ankenShubetsu = '除外';
            toiawasePhase = '除外';
            toiawaseJogaiKubun = '提供外サービス';
        }
        else if(toiawase == '葬儀依頼' && konnyusaki == '火葬場'){ //9
            System.debug('doAnkenShubetsu : 9');
            ankenShubetsu = '準有効';
            toiawasePhase = '';
            toiawaseJogaiKubun = '';
        }
        else if(toiawase == '事前相談' && konnyusaki == '火葬場'){ //10
            System.debug('doAnkenShubetsu : 10');
            ankenShubetsu = '準有効';
            toiawasePhase = '';
            toiawaseJogaiKubun = '';
        }
        else if(toiawase == '葬儀依頼' && konnyusaki == '競合他社'){ //11
            System.debug('doAnkenShubetsu : 11');
            ankenShubetsu = '準有効';
            toiawasePhase = '';
            toiawaseJogaiKubun = '';
        }
        else if(toiawase == '事前相談' && konnyusaki == '競合他社'){ //12
            System.debug('doAnkenShubetsu : 12');
            ankenShubetsu = '準有効';
            toiawasePhase = '';
            toiawaseJogaiKubun = '';
        }
        else if(tashaTeianJokyo == '未相談'){ //13
            System.debug('doAnkenShubetsu : 13');
            ankenShubetsu = '準有効';
            toiawasePhase = '';
            toiawaseJogaiKubun = '';
        }
        else if(toiawase == '葬儀依頼' && konnyusaki == '斎場' && konnyusakiJokyo == '契約中' && tashaTeianJokyo == '事前相談済'){ //15
            System.debug('doAnkenShubetsu : 15');
            ankenShubetsu = '除外';
            toiawasePhase = '除外';
            toiawaseJogaiKubun = '斎場問合せ(提携先顧客)';
        }
        else if(toiawase == '葬儀依頼' && konnyusaki == '斎場' && konnyusakiJokyo == '契約中' && tashaTeianJokyo == '会員・積み立て'){ //16
            System.debug('doAnkenShubetsu : 16');
            ankenShubetsu = '除外';
            toiawasePhase = '除外';
            toiawaseJogaiKubun = '斎場問合せ(提携先顧客)';
        }
        // else if(toiawase == '葬儀依頼' && konnyusaki == '斎場' && konnyusakiJokyo == '契約中' && tashaTeianJokyo == '葬儀依頼済'){ //17
        //     System.debug('doAnkenShubetsu : 17');
        //     ankenShubetsu = '除外';
        //     toiawasePhase = '除外';
        //     toiawaseJogaiKubun = '斎場問合せ(提携先顧客)';
        // }
        else if(toiawase == '事前相談' && konnyusaki == '斎場' && konnyusakiJokyo == '契約中' && tashaTeianJokyo == '事前相談済'){ //19
            System.debug('doAnkenShubetsu : 19');
            ankenShubetsu = '除外';
            toiawasePhase = '除外';
            toiawaseJogaiKubun = '斎場問合せ(提携先顧客)';
        }
        else if(toiawase == '事前相談' && konnyusaki == '斎場' && konnyusakiJokyo == '契約中' && tashaTeianJokyo == '会員・積み立て'){ //20
            System.debug('doAnkenShubetsu : 20');
            ankenShubetsu = '除外';
            toiawasePhase = '除外';
            toiawaseJogaiKubun = '斎場問合せ(提携先顧客)';
        }
        // else if(toiawase == '事前相談' && konnyusaki == '斎場' && konnyusakiJokyo == '契約中' && tashaTeianJokyo == '葬儀依頼済'){ //21
        //     System.debug('doAnkenShubetsu : 21');
        //     ankenShubetsu = '除外';
        //     toiawasePhase = '除外';
        //     toiawaseJogaiKubun = '斎場問合せ(提携先顧客)';
        // }
        else if(toiawase == '葬儀依頼' && konnyusaki == '斎場' && konnyusakiJokyo == '非提携' && tashaTeianJokyo == '事前相談済'){ //23
            System.debug('doAnkenShubetsu : 23');
            ankenShubetsu = '準有効';
            toiawasePhase = '';
            toiawaseJogaiKubun = '';
        }
        else if(toiawase == '葬儀依頼' && konnyusaki == '斎場' && konnyusakiJokyo == '非提携' && tashaTeianJokyo == '会員・積み立て'){ //24
            System.debug('doAnkenShubetsu : 24');
            ankenShubetsu = '準有効';
            toiawasePhase = '';
            toiawaseJogaiKubun = '';
        }
        // else if(toiawase == '葬儀依頼' && konnyusaki == '斎場' && konnyusakiJokyo == '非提携' && tashaTeianJokyo == '葬儀依頼済'){ //25
        //     System.debug('doAnkenShubetsu : 25');
        //     ankenShubetsu = '除外';
        //     toiawasePhase = '除外';
        //     toiawaseJogaiKubun = '斎場問合せ(葬儀依頼済)';
        // }
        else if(toiawase == '事前相談' && konnyusaki == '斎場' && konnyusakiJokyo == '非提携' && tashaTeianJokyo == '事前相談済'){ //27
            System.debug('doAnkenShubetsu : 27');
            ankenShubetsu = '準有効';
            toiawasePhase = '';
            toiawaseJogaiKubun = '';
        }
        else if(toiawase == '事前相談' && konnyusaki == '斎場' && konnyusakiJokyo == '非提携' && tashaTeianJokyo == '会員・積み立て'){ //28
            System.debug('doAnkenShubetsu : 28');
            ankenShubetsu = '準有効';
            toiawasePhase = '';
            toiawaseJogaiKubun = '';
        }
        // else if(toiawase == '事前相談' && konnyusaki == '斎場' && konnyusakiJokyo == '非提携' && tashaTeianJokyo == '葬儀依頼済'){ //29
        //     System.debug('doAnkenShubetsu : 29');
        //     ankenShubetsu = '除外';
        //     toiawasePhase = '除外';
        //     toiawaseJogaiKubun = '斎場問合せ(葬儀依頼済)';
        // }
        else if(toiawase == '葬儀依頼' && konnyusaki == '葬儀社' && konnyusakiJokyo == '契約中' && tashaTeianJokyo == '事前相談済'){ //39
            System.debug('doAnkenShubetsu : 39');
            ankenShubetsu = '除外';
            toiawasePhase = '除外';
            toiawaseJogaiKubun = '斎場問合せ(提携先顧客)';
        }
        else if(toiawase == '葬儀依頼' && konnyusaki == '葬儀社' && konnyusakiJokyo == '契約中' && tashaTeianJokyo == '会員・積み立て'){ //40
            System.debug('doAnkenShubetsu : 40');
            ankenShubetsu = '除外';
            toiawasePhase = '除外';
            toiawaseJogaiKubun = '斎場問合せ(提携先顧客)';
        }
        // else if(toiawase == '葬儀依頼' && konnyusaki == '葬儀社' && konnyusakiJokyo == '契約中' && tashaTeianJokyo == '葬儀依頼済'){ //41
        //     System.debug('doAnkenShubetsu : 41');
        //     ankenShubetsu = '除外';
        //     toiawasePhase = '除外';
        //     toiawaseJogaiKubun = '斎場問合せ(提携先顧客)';
        // }
        else if(toiawase == '事前相談' && konnyusaki == '葬儀社' && konnyusakiJokyo == '契約中' && tashaTeianJokyo == '事前相談済'){ //43
            System.debug('doAnkenShubetsu : 43');
            ankenShubetsu = '除外';
            toiawasePhase = '除外';
            toiawaseJogaiKubun = '斎場問合せ(提携先顧客)';
        }
        else if(toiawase == '事前相談' && konnyusaki == '葬儀社' && konnyusakiJokyo == '契約中' && tashaTeianJokyo == '会員・積み立て'){ //44
            System.debug('doAnkenShubetsu : 44');
            ankenShubetsu = '除外';
            toiawasePhase = '除外';
            toiawaseJogaiKubun = '斎場問合せ(提携先顧客)';
        }
        // else if(toiawase == '事前相談' && konnyusaki == '葬儀社' && konnyusakiJokyo == '契約中' && tashaTeianJokyo == '葬儀依頼済'){ //45
        //     System.debug('doAnkenShubetsu : 45');
        //     ankenShubetsu = '除外';
        //     toiawasePhase = '除外';
        //     toiawaseJogaiKubun = '斎場問合せ(提携先顧客)';
        // }
        else if(toiawase == '葬儀依頼' && konnyusaki == '葬儀社' && konnyusakiJokyo == '非提携' && tashaTeianJokyo == '事前相談済'){ //47
            System.debug('doAnkenShubetsu : 47');
            ankenShubetsu = '準有効';
            toiawasePhase = '';
            toiawaseJogaiKubun = '';
        }
        else if(toiawase == '葬儀依頼' && konnyusaki == '葬儀社' && konnyusakiJokyo == '非提携' && tashaTeianJokyo == '会員・積み立て'){ //48
            System.debug('doAnkenShubetsu : 48');
            ankenShubetsu = '準有効';
            toiawasePhase = '';
            toiawaseJogaiKubun = '';
        }
        // else if(toiawase == '葬儀依頼' && konnyusaki == '葬儀社' && konnyusakiJokyo == '非提携' && tashaTeianJokyo == '葬儀依頼済'){ //49
        //     System.debug('doAnkenShubetsu : 49');
        //     ankenShubetsu = '除外';
        //     toiawasePhase = '除外';
        //     toiawaseJogaiKubun = '斎場問合せ(葬儀依頼済)';
        // }
        else if(toiawase == '事前相談' && konnyusaki == '葬儀社' && konnyusakiJokyo == '非提携' && tashaTeianJokyo == '事前相談済'){ //51
            System.debug('doAnkenShubetsu : 51');
            ankenShubetsu = '準有効';
            toiawasePhase = '';
            toiawaseJogaiKubun = '';
        }
        else if(toiawase == '事前相談' && konnyusaki == '葬儀社' && konnyusakiJokyo == '非提携' && tashaTeianJokyo == '会員・積み立て'){ //52
            System.debug('doAnkenShubetsu : 52');
            ankenShubetsu = '準有効';
            toiawasePhase = '';
            toiawaseJogaiKubun = '';
        }
        // else if(toiawase == '事前相談' && konnyusaki == '葬儀社' && konnyusakiJokyo == '非提携' && tashaTeianJokyo == '葬儀依頼済'){ //53
        //     System.debug('doAnkenShubetsu : 53');
        //     ankenShubetsu = '除外';
        //     toiawasePhase = '除外';
        //     toiawaseJogaiKubun = '斎場問合せ(葬儀依頼済)';
        // }
        else if(toiawase == '' && konnyusaki == '' && konnyusakiJokyo == '' && tashaTeianJokyo == ''){
            System.debug('doAnkenShubetsu : 有効');
            ankenShubetsu = '有効';
            toiawasePhase = '';
            toiawaseJogaiKubun = '';
        }
        else{
            System.debug('doAnkenShubetsu : 不明');
            ankenShubetsu = '不明';
            toiawasePhase = '除外';
            toiawaseJogaiKubun = '斎場問合せ(詳細不明)';
        }
    }

    //issues3806--Start--
    //選択リストのValuesとLabelの取得処理
    public static List<Schema.PicklistEntry> getPicklist(String sObjName, String fieldName){
        List<Schema.PicklistEntry> pickList;
        Schema.SObjectType sObjType = (Schema.SObjectType) Schema.getGlobalDescribe().get(sObjName);
        if(sObjType != null){
            Map<String, Schema.SObjectField> fieldmap = sObjType.getDescribe().fields.getMap();
            Schema.SObjectField f = (Schema.SObjectField) fieldmap.get(fieldName);
            if(f != null){
                Schema.DescribeFieldResult r = f.getDescribe();
                pickList = r.getPicklistValues();
            }
        }
        return pickList;
    }

    public void setSogiKPI(){
        
        TaishoushaJokyoGenzai = TaishoushaJokyo;
        TaishoshaYomeiKikanGenzai = TaishoshaYomeiKikan;
        TaishoshaKyojuKeitaiGenzai = TaishoshaKyojuKeitai;
        
        setSogiKPIGenzai();

    }

    public void setSogiKPIGenzai(){
        
        NurturingCRMSimpleYasugoOpportunity SogiKPICheck = new NurturingCRMSimpleYasugoOpportunity();
        
        String StrSogiKPICheckNo = SogiKPICheck.StatusInformation(TaishoushaJokyoGenzai ,TaishoshaYomeiKikanGenzai,TaishoshaKyojuKeitaiGenzai);
        
        if (SogiKPICheck.MAPSimpleYasugoJokyoStatusInfo.containsKey(StrSogiKPICheckNo)){
            ota.SogiKPIGenzai__c = SogiKPICheck.MAPSimpleYasugoJokyoStatusInfo.get(StrSogiKPICheckNo).SogiKPI__c ;
            ota.KinkyudoLVGenzai__c  = SogiKPICheck.MAPSimpleYasugoJokyoStatusInfo.get(StrSogiKPICheckNo).KinkyudoLV__c ;
            ota.SoteiLeadTimeGenzai__c = SogiKPICheck.MAPSimpleYasugoJokyoStatusInfo.get(StrSogiKPICheckNo).SoteiLeadTime__c ;
        }
    }

    public void resetSogiKPI(){

        TaishoushaJokyo = ota.TaishoushaJokyo__c;
        TaishoshaKyojuKeitai = ota.TaishoshaKyojuKeitai__c;
        TaishoshaYomeiKikan = ota.TaishoshaYomeiKikan__c;
        TaishoushaJokyoGenzai = ota.TaishoushaJokyoGenzai__c;
        TaishoshaKyojuKeitaiGenzai = ota.TaishoshaKyojuKeitaiGenzai__c;
        TaishoshaYomeiKikanGenzai = ota.TaishoshaYomeiKikanGenzai__c;

        setSogiKPIGenzai();

    }

    //issues3806--End--

    private SogiTeianshoIkkatsuSakuseiJoken__c teianshoSakuseiJokenSetting(){

        if(shiryoSofuMemberWaribiki == '' && ota.SodanshaMemberTourokuZumi__c) shiryoSofuMemberWaribiki = 'よりそう会員';

        Boolean shiryoSofuButsuguNashi = false;
        if(ota.ButsuguNashiKibo__c == '仏具なし') shiryoSofuButsuguNashi = true;

        Boolean shiryoSofuJizenJunbiSheet = false;
        if(shiryoSofuJizenJizenSheetWaribiki || ota.JizenJunbiSheetGoannaiJokyo__c == '受領') shiryoSofuJizenJunbiSheet = true;

        Boolean shiryoSofuShikigoSurvey = false;
        if(ota.SurveyDiscountAgreeStatus__c == '同意済') shiryoSofuShikigoSurvey = true;

        String shiryoSofuSoryoTehai = '';
        if(ota.MonkArrangements__c == '有') {
            if(ota.Kaimyojuyo__c == '戒名の授与を希望する') shiryoSofuSoryoTehai = 'お坊さん手配（戒名あり）';
            if(ota.Kaimyojuyo__c == '戒名の授与を希望しない') shiryoSofuSoryoTehai = 'お坊さん手配（戒名なし）';
        }

        String shiryoSofuKiboArea = '';
        if(ota.PreExecuteArea__c != null) shiryoSofuKiboArea = [select Id, Name from Shikugun__c where Id = :ota.PreExecuteArea__c].Name;

        String shiryoSofuAllianceWari = '';
        if(ota.AllianceRef__c != null){
            String allianceName = [select Id, Name from Keiyaku__c where Id = :ota.AllianceRef__c].Name;
            if(allianceName.indexOf('ベネフィット') != -1) shiryoSofuAllianceWari = 'ベネフィット';
            else if(allianceName.indexOf('カカクコム') != -1) shiryoSofuAllianceWari = '価格コム';
        }

        return new SogiTeianshoIkkatsuSakuseiJoken__c(
                                                        MemberSeido__c = shiryoSofuMemberWaribiki, 
                                                        ButsuguNashi__c = shiryoSofuButsuguNashi, 
                                                        JizenJunbiSheet__c = shiryoSofuJizenJunbiSheet, 
                                                        ShikigoSurvey__c = shiryoSofuShikigoSurvey, 
                                                        ObosanTehai__c = shiryoSofuSoryoTehai, 
                                                        KibouArea__c = shiryoSofuKiboArea, 
                                                        SonotaWaribiki__c = shiryoSofuAllianceWari
                                                    );
    }

    public void teianshoSakuseiJokenKoshin(){

        Savepoint sp = Database.setSavepoint();

        shiryoSofuErrMsg = '';
        if(inputSogiShiroSofuWrap.sofuJokyoValue != '資料作成中' && inputSogiShiroSofuWrap.sofuJokyoValue != '情報確認中'){
            shiryoSofuErrMsg = '条件更新が行えるのは【送付状況】が資料作成中か情報確認中のみです';
            return;
        }

        try{
            SogiTeianshoIkkatsuSakuseiJoken__c upsertJoken = teianshoSakuseiJokenSetting();
            if(inputSogiShiroSofuWrap.inputSogiShiryoSofu.sogiShiryoSofu.SogiTeianshoIkkatsuSakuseiJokenRef__c != null){
                upsertJoken.Id = inputSogiShiroSofuWrap.inputSogiShiryoSofu.sogiShiryoSofu.SogiTeianshoIkkatsuSakuseiJokenRef__c;
                update upsertJoken;
            }
            else{
                upsertJoken.ShikijoMeisaiHyokiName__c = '式場追加料金（プラン内式場料金超過分）';
                upsertJoken.KasobaMeisaiHyokiName__c = '火葬料金（非課税）';
                insert upsertJoken;

                inputSogiShiroSofuWrap.inputSogiShiryoSofu.sogiShiryoSofu.SogiTeianshoIkkatsuSakuseiJokenRef__c = upsertJoken.Id;
                update inputSogiShiroSofuWrap.inputSogiShiryoSofu.sogiShiryoSofu;
            }
        }
        catch(Exception e){
            Database.rollback(sp);
            shiryoSofuErrMsg = e.getMessage();
            return;
        }
        
    }

    public void createShiryoSofu(){

        SogiTeianshoIkkatsuSakuseiJoken__c insertJoken = teianshoSakuseiJokenSetting();
        insertJoken.ShikijoMeisaiHyokiName__c = '式場追加料金（プラン内式場料金超過分）';
        insertJoken.KasobaMeisaiHyokiName__c = '火葬料金（非課税）';
        insert insertJoken;

        List<String> insatsubutsuIchiranList = new List<String>{'送付状','斎場資料'};
        if(ota.PreliminaryConsultationDate__c == null) insatsubutsuIchiranList.add('会員案内');

        insert new SogiShiryoSofu__c(
                                        OpportunityRef__c = oppId, 
                                        PamphletYohi__c = '要',
                                        SofuJokyo__c = '資料作成中',
                                        InsatsubutsuIchiran__c = String.join(insatsubutsuIchiranList, ';'),
                                        Template__c = '標準',
                                        SogiTeianshoIkkatsuSakuseiJokenRef__c = insertJoken.Id
                                    );
        sogiShiryoSofuSetting();
    }

    public String shiryoSofuId {get;set;}
    public void referShiryoSofu(){
        shiryoSofuErrMsg = '';
        shiryoSofuId = Apexpages.currentPage().getParameters().get('pShiryoSofuId');
        
        SogiShiryoSofu__c sltShiryoSofu = getShiryoSofuList();

        inputSogiShiroSofuWrap.inputSogiShiryoSofu.sogiShiryoSofu = sltShiryoSofu;
        inputSogiShiroSofuWrap.inputSogiShiryoSofuFlg = true;
        inputSogiShiroSofuWrap.teianshoNum = sltShiryoSofu.Teianshos__r.size();
        inputSogiShiroSofuWrap.sofuJokyoValue = sltShiryoSofu.SofuJokyo__c;
        inputSogiShiroSofuWrap.insatsubutsuIchiranValue = new List<String>();
        if(sltShiryoSofu.InsatsubutsuIchiran__c != null){
            for(String strInsatsubutsuIchiran : sltShiryoSofu.InsatsubutsuIchiran__c.split(';')){
                inputSogiShiroSofuWrap.insatsubutsuIchiranValue.add(strInsatsubutsuIchiran);
            }
        }

        inputSogiShiroSofuWrap.kasobaTeianList = new List<SogiShiryoSofuMeisai__c>();
        inputSogiShiroSofuWrap.saijoTeianList = new List<SogiShiryoSofuMeisai__c>();
        for(SogiShiryoSofuMeisai__c sltSogiShiryoSofuMeisai : sltShiryoSofu.SogiShiryoSofuMeisais__r){
            if(sltSogiShiryoSofuMeisai.ShisetsuKubun__c == '火葬場') inputSogiShiroSofuWrap.kasobaTeianList.add(sltSogiShiryoSofuMeisai);
            if(sltSogiShiryoSofuMeisai.ShisetsuKubun__c == '斎場') inputSogiShiroSofuWrap.saijoTeianList.add(sltSogiShiryoSofuMeisai);
        }

        for(Integer i = inputSogiShiroSofuWrap.kasobaTeianList.size(); i < 2; i++){
            inputSogiShiroSofuWrap.kasobaTeianList.add(new SogiShiryoSofuMeisai__c());
        }

        for(Integer i = inputSogiShiroSofuWrap.saijoTeianList.size(); i < 10; i++){
            inputSogiShiroSofuWrap.saijoTeianList.add(new SogiShiryoSofuMeisai__c());
        }
    }

    public void copyShiryoSofu(){
        shiryoSofuErrMsg = '';
        shiryoSofuId = Apexpages.currentPage().getParameters().get('pShiryoSofuId');

        SogiShiryoSofu__c sltShiryoSofu = getShiryoSofuList();
        
        inputSogiShiroSofuWrap.inputSogiShiryoSofu.sogiShiryoSofu = sltShiryoSofu.clone(false, true);

        if(String.isNotBlank(sltShiryoSofu.SogiTeianshoIkkatsuSakuseiJokenRef__c)){
            SogiTeianshoIkkatsuSakuseiJoken__c joken = [select 
                                                            Id 
                                                        from SogiTeianshoIkkatsuSakuseiJoken__c
                                                        where Id = :sltShiryoSofu.SogiTeianshoIkkatsuSakuseiJokenRef__c];
            SogiTeianshoIkkatsuSakuseiJoken__c copyJoken = joken.clone(false, true);
            insert copyJoken;
            inputSogiShiroSofuWrap.inputSogiShiryoSofu.sogiShiryoSofu.SogiTeianshoIkkatsuSakuseiJokenRef__c = copyJoken.Id;
        }
        
        inputSogiShiroSofuWrap.inputSogiShiryoSofu.sogiShiryoSofu.Fax__c = null;
        inputSogiShiroSofuWrap.inputSogiShiryoSofu.sogiShiryoSofu.Mail__c = null;
        inputSogiShiroSofuWrap.inputSogiShiryoSofu.sogiShiryoSofu.SofuNichiji__c = null;
        inputSogiShiroSofuWrap.inputSogiShiryoSofu.sogiShiryoSofu.City__c = null;
        inputSogiShiroSofuWrap.inputSogiShiryoSofu.sogiShiryoSofu.SofuShubetsu__c = null;
        inputSogiShiroSofuWrap.inputSogiShiryoSofu.sogiShiryoSofu.SofuJokyo__c = '資料作成中';
        inputSogiShiroSofuWrap.sofuJokyoValue = '資料作成中';
        inputSogiShiroSofuWrap.inputSogiShiryoSofu.sogiShiryoSofu.Street__c = null;
        inputSogiShiroSofuWrap.inputSogiShiryoSofu.sogiShiryoSofu.State__c = null;
        inputSogiShiroSofuWrap.inputSogiShiryoSofu.sogiShiryoSofu.YusoShubetsu__c = null;
        inputSogiShiroSofuWrap.inputSogiShiryoSofu.sogiShiryoSofu.IsogiTaio__c = false;
        inputSogiShiroSofuWrap.inputSogiShiryoSofu.sogiShiryoSofu.PostalCode__c = null;
        inputSogiShiroSofuWrap.inputSogiShiryoSofu.sogiShiryoSofu.SofuShiryoURL__c = null;
        inputSogiShiroSofuWrap.inputSogiShiryoSofu.sogiShiryoSofu.PassWord__c = null;
        inputSogiShiroSofuWrap.inputSogiShiryoSofuFlg = true;
        inputSogiShiroSofuWrap.insatsubutsuIchiranValue = new List<String>();
        if(sltShiryoSofu.InsatsubutsuIchiran__c != null){
            for(String strInsatsubutsuIchiran : sltShiryoSofu.InsatsubutsuIchiran__c.split(';')){
                inputSogiShiroSofuWrap.insatsubutsuIchiranValue.add(strInsatsubutsuIchiran);
            }
        }
        insert inputSogiShiroSofuWrap.inputSogiShiryoSofu.sogiShiryoSofu;

        List<SogiShiryoSofuMeisai__c> insSogiShiryoSofuMeisaiList = new List<SogiShiryoSofuMeisai__c>();
        for(SogiShiryoSofuMeisai__c tempSogiShiryoSofuMeisai : sltShiryoSofu.SogiShiryoSofuMeisais__r){
            SogiShiryoSofuMeisai__c copySogiShiryoSofuMeisai = tempSogiShiryoSofuMeisai.clone(false, true);
            copySogiShiryoSofuMeisai.SogiShiryoSofuRef__c = inputSogiShiroSofuWrap.inputSogiShiryoSofu.sogiShiryoSofu.Id;
            insSogiShiryoSofuMeisaiList.add(copySogiShiryoSofuMeisai);
        }
        insert insSogiShiryoSofuMeisaiList;

        List<TeianSho__c> insTeianShoList = new List<TeianSho__c>();
        for(TeianSho__c tempTeianSho : sltShiryoSofu.Teianshos__r){
            TeianSho__c copTeianSho = tempTeianSho.clone(false, true);
            copTeianSho.SogiShiryoSofuRef__c = inputSogiShiroSofuWrap.inputSogiShiryoSofu.sogiShiryoSofu.Id;
            insTeianShoList.add(copTeianSho);
        }
        insert insTeianShoList;

        sogiShiryoSofuSetting();
    }

    public String shiryoSofuErrMsg {get;set;}

    public void saveSogiShiryoSofu(){
        shiryoSofuErrMsg = '';

        if(String.isNotBlank(inputSogiShiroSofuWrap.inputSogiShiryoSofu.sogiShiryoSofu.PostalCode__c)){
            String strPostalCode = inputSogiShiroSofuWrap.inputSogiShiryoSofu.sogiShiryoSofu.PostalCode__c;
            Pattern p = Pattern.compile('[0-9]{7}');
            Matcher m= p.matcher(strPostalCode);
            if(m.matches()) inputSogiShiroSofuWrap.inputSogiShiryoSofu.sogiShiryoSofu.PostalCode__c = strPostalCode.substring(0,3) + '-' + strPostalCode.substring(3);
        }

        inputSogiShiroSofuWrap.inputSogiShiryoSofu.sogiShiryoSofu.SofuJokyo__c = inputSogiShiroSofuWrap.sofuJokyoValue;
        if(inputSogiShiroSofuWrap.insatsubutsuIchiranValue.size() > 0){
            String strInsatsubutsuIchiranValue = '';
            for(String splitInsatsubutsuIchiranValue : inputSogiShiroSofuWrap.insatsubutsuIchiranValue){
                strInsatsubutsuIchiranValue += splitInsatsubutsuIchiranValue + ';';
            }
            inputSogiShiroSofuWrap.inputSogiShiryoSofu.sogiShiryoSofu.InsatsubutsuIchiran__c = strInsatsubutsuIchiranValue;
        }

        SogiShiryoSofu__c checkSogiShiryoSofu = [select Id, SofuJokyo__c, SogiShiryoSakuseiKekkaRef__r.StatusCode__c from SogiShiryoSofu__c where Id = :inputSogiShiroSofuWrap.inputSogiShiryoSofu.sogiShiryoSofu.Id];

        if(checkSogiShiryoSofu.SofuJokyo__c != '印刷待ち' && 
            inputSogiShiroSofuWrap.inputSogiShiryoSofu.sogiShiryoSofu.SofuJokyo__c == '印刷待ち' && 
            String.isBlank(inputSogiShiroSofuWrap.inputSogiShiryoSofu.sogiShiryoSofu.SofuShiryoURL__c)) {
            
            if(!Test.isRunningTest()){
                try{
                    SougiShiryoSakusei.SougiShiryoSakuseiResult result = new SougiShiryoSakusei().postOproPdf(inputSogiShiroSofuWrap.inputSogiShiryoSofu.sogiShiryoSofu);
                    inputSogiShiroSofuWrap.inputSogiShiryoSofu.sogiShiryoSofu.SofuShiryoURL__c = OpfcConfs.getConfig().base_url + result.path;
                    inputSogiShiroSofuWrap.inputSogiShiryoSofu.sogiShiryoSofu.PassWord__c = result.password;
                }
                catch(SougiShiryoSakusei.RequestServiceUnavailableException e){
                    inputSogiShiroSofuWrap.sofuJokyoValue = '資料作成中';
                    shiryoSofuErrMsg = '他商談でPDFを作成中のため少し待ってから再実行してください';
                    return;
                }
                catch(Exception e){
                    inputSogiShiroSofuWrap.sofuJokyoValue = '資料作成中';
                    shiryoSofuErrMsg = 'エラーが発生しました。システム管理者に通知されました。';
                    Loggings.writeLog(
                        Loggings.createLogEntry(Loggings.Level.Error, '20200712-1136-01', '葬儀資料送付保存処理')
                        .putAttr('theResult.descr', e.getMessage())
                    );
                    return;
                }
            }
        }

        if(checkSogiShiryoSofu.SofuJokyo__c == '印刷待ち' && 
            String.isNotBlank(inputSogiShiroSofuWrap.inputSogiShiryoSofu.sogiShiryoSofu.SogiShiryoSakuseiKekkaRef__c) && 
            (inputSogiShiroSofuWrap.inputSogiShiryoSofu.sogiShiryoSofu.SofuJokyo__c == '資料作成中' || inputSogiShiroSofuWrap.inputSogiShiryoSofu.sogiShiryoSofu.SofuJokyo__c == '情報確認中')){
            inputSogiShiroSofuWrap.inputSogiShiryoSofu.sogiShiryoSofu.SofuShiryoURL__c = null;
            inputSogiShiroSofuWrap.inputSogiShiryoSofu.sogiShiryoSofu.PassWord__c = null;
            
            try{
                update new SogiShiryoSakuseiKekka__c(
                    Id = inputSogiShiroSofuWrap.inputSogiShiryoSofu.sogiShiryoSofu.SogiShiryoSakuseiKekkaRef__c,
                    StatusCode__c = null,
                    Message__c = null
                );
            }
            catch(Exception e){
                shiryoSofuErrMsg = e.getMessage();
                return;
            }
        }

        try{
            upsert inputSogiShiroSofuWrap.inputSogiShiryoSofu.sogiShiryoSofu;
        }
        catch(Exception e){
            shiryoSofuErrMsg = e.getMessage();
            return;
        }

        List<SogiShiryoSofuMeisai__c> insSogiShiryoSofuMeisaiList = new List<SogiShiryoSofuMeisai__c>();
        for(SogiShiryoSofuMeisai__c tempSogiShiryoSofuMeisai : inputSogiShiroSofuWrap.kasobaTeianList){
            if(tempSogiShiryoSofuMeisai.Id == null && tempSogiShiryoSofuMeisai.ShisetsuRef__c != null) {
                tempSogiShiryoSofuMeisai.SogiShiryoSofuRef__c = inputSogiShiroSofuWrap.inputSogiShiryoSofu.sogiShiryoSofu.Id;
                insSogiShiryoSofuMeisaiList.add(tempSogiShiryoSofuMeisai);
            }
        }

        for(SogiShiryoSofuMeisai__c tempSogiShiryoSofuMeisai : inputSogiShiroSofuWrap.saijoTeianList){
            if(tempSogiShiryoSofuMeisai.Id == null && tempSogiShiryoSofuMeisai.SaijoRef__c != null) {
                tempSogiShiryoSofuMeisai.SogiShiryoSofuRef__c = inputSogiShiroSofuWrap.inputSogiShiryoSofu.sogiShiryoSofu.Id;
                insSogiShiryoSofuMeisaiList.add(tempSogiShiryoSofuMeisai);
            }
        }
        insert insSogiShiryoSofuMeisaiList;

        sogiShiryoSofuSetting();
    }
    
    public void sendMailSogiShiryoSofu(){

        inputSogiShiroSofuWrap.inputSogiShiryoSofu.sogiShiryoSofu.SofuJokyo__c = '送付済';
        inputSogiShiroSofuWrap.inputSogiShiryoSofu.sogiShiryoSofu.SofuNichiji__c = datetime.now();
        upsert inputSogiShiroSofuWrap.inputSogiShiryoSofu.sogiShiryoSofu;

        if(inputSogiShiroSofuWrap.inputSogiShiryoSofu.sogiShiryoSofu.Template__c == '標準'){
            YorisoNoOsoshikiShiryoSofuUrlMail.CreateMailArg theArgUrl = new YorisoNoOsoshikiShiryoSofuUrlMail.CreateMailArg();
            theArgUrl.atena = inputSogiShiroSofuWrap.inputSogiShiryoSofu.sogiShiryoSofu.Atena__c;
            theArgUrl.mailaddress = inputSogiShiroSofuWrap.inputSogiShiryoSofu.sogiShiryoSofu.Mail__c;
            theArgUrl.pdfUrl = inputSogiShiroSofuWrap.inputSogiShiryoSofu.sogiShiryoSofu.SofuShiryoURL__c;
            theArgUrl.passWord = inputSogiShiroSofuWrap.inputSogiShiryoSofu.sogiShiryoSofu.PassWord__c;
            INSERT new YorisoNoOsoshikiShiryoSofuUrlMail().createMail(theArgUrl);
        }

        if(inputSogiShiroSofuWrap.inputSogiShiryoSofu.sogiShiryoSofu.Template__c == '施行可能葬儀社なし' && ota.PreExecuteArea__c != null){
            String shiryoSofuKiboArea = [select Id, Name from Shikugun__c where Id = :ota.PreExecuteArea__c].Name;
            SekoKanoSogishaNashiShiryoSofuMail.CreateMailArg theArgUrl = new SekoKanoSogishaNashiShiryoSofuMail.CreateMailArg();
            theArgUrl.atena = inputSogiShiroSofuWrap.inputSogiShiryoSofu.sogiShiryoSofu.Atena__c;
            theArgUrl.mailaddress = inputSogiShiroSofuWrap.inputSogiShiryoSofu.sogiShiryoSofu.Mail__c;
            theArgUrl.kiboarea = shiryoSofuKiboArea;
            INSERT new SekoKanoSogishaNashiShiryoSofuMail().createMail(theArgUrl);
        }

        if(inputSogiShiroSofuWrap.inputSogiShiryoSofu.sogiShiryoSofu.InsatsubutsuIchiran__c.indexOf('会員案内') != -1){
            if(opp.Account.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId()){
                ota.JizenwariShoshoHassoDate__c = date.today();
            }
            else if(opp.Account.RecordTypeId != Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId() && 
                opp.Account.JizenwariShoshoHassoDate__c == null){
                update new Account(Id = opp.AccountId, JizenwariShoshoHassoDate__c = date.today());
            }
        }
        
        sogiShiryoSofuSetting();
    }

    public void sogiShiryoSofuSetting(){

        shiryoSofuId = '';
        shiryoSofuErrMsg = '';
        sogiShiryoSofuWrapList = new List<SogiShiryoSofuWrap>();
        for(SogiShiryoSofu__c initSogiShiryoSofu : [select Id, 
                                                            Name, 
                                                            Fax__c, 
                                                            PamphletYohi__c, 
                                                            Mail__c, 
                                                            SofuShiryoURL__c, 
                                                            PassWord__c, 
                                                            Atena__c, 
                                                            SofuNichiji__c, 
                                                            InsatsubutsuIchiran__c, 
                                                            SogiShiryoSakuseiKekkaRef__c, 
                                                            City__c, 
                                                            OpportunityRef__c, 
                                                            SofuShubetsu__c, 
                                                            SofuJokyo__c, 
                                                            Street__c, 
                                                            State__c, 
                                                            YusoShubetsu__c, 
                                                            IsogiTaio__c, 
                                                            PostalCode__c, 
                                                            HosokuSetsumei__c, 
                                                            SogiShiryoSakuseiKekkaRef__r.StatusCode__c, 
                                                            PdfSakuseiJokyo__c, 
                                                            CreatedBy.LastName, 
                                                            CreatedDate, 
                                                            (
                                                                select Id 
                                                                from Teianshos__r
                                                            )
                                                    from SogiShiryoSofu__c 
                                                    where OpportunityRef__c = :oppId 
                                                    order by CreatedDate desc]){
            SogiShiryoSofuWrap initSogiShiryoSofuWrap = new SogiShiryoSofuWrap();
            initSogiShiryoSofuWrap.sogiShiryoSofu = initSogiShiryoSofu;
            if(initSogiShiryoSofu.SofuShubetsu__c == '郵便') initSogiShiryoSofuWrap.atesakiCustom = initSogiShiryoSofu.PostalCode__c + ' ' + initSogiShiryoSofu.State__c + ' ' + initSogiShiryoSofu.City__c + ' ' + initSogiShiryoSofu.Street__c;
            if(initSogiShiryoSofu.SofuShubetsu__c == 'メール') initSogiShiryoSofuWrap.atesakiCustom = initSogiShiryoSofu.Mail__c;
            if(initSogiShiryoSofu.SofuShubetsu__c == 'FAX') initSogiShiryoSofuWrap.atesakiCustom = initSogiShiryoSofu.Fax__c;
            initSogiShiryoSofuWrap.teiansho = initSogiShiryoSofu.Teianshos__r.size() > 0 ? '有' : '無';
            sogiShiryoSofuWrapList.add(initSogiShiryoSofuWrap);
        }

        inputSogiShiroSofuWrap = new InputSogiShiroSofuWrap();
    }

    public void delSogiShiryoSofu(){
        delete inputSogiShiroSofuWrap.inputSogiShiryoSofu.sogiShiryoSofu;

        sogiShiryoSofuSetting();
    }

    public void getTeianList(){

        SogiShiryoSofu__c sltShiryoSofu = [select Id, 
                                                Name, 
                                                Fax__c, 
                                                PamphletYohi__c, 
                                                Mail__c, 
                                                SofuShiryoURL__c, 
                                                PassWord__c, 
                                                Atena__c, 
                                                SofuNichiji__c, 
                                                InsatsubutsuIchiran__c, 
                                                SogiShiryoSakuseiKekkaRef__c, 
                                                City__c, 
                                                OpportunityRef__c, 
                                                OpportunityRef__r.ShodanBangoF__c,
                                                OpportunityRef__r.Account.AcvmJizenWariMinDate__c,
                                                OpportunityRef__r.Account.JizenwariKekaKikan__c,
                                                OpportunityRef__r.Account.Name,
                                                SofuShubetsu__c, 
                                                SofuJokyo__c, 
                                                Street__c, 
                                                State__c, 
                                                YusoShubetsu__c, 
                                                IsogiTaio__c, 
                                                PostalCode__c, 
                                                HosokuSetsumei__c, 
                                                HikitsugiJiko__c, 
                                                TaSofubutsu1__c, 
                                                TaSofubutsu2__c, 
                                                TaSofubutsu3__c, 
                                                Template__c, 
                                                KasoshikiyoMongon__c, 
                                                CreatedBy.LastName, 
                                                CreatedDate, 
                                                (
                                                    select Id, 
                                                            SaijoRef__r.Name, 
                                                            SaijoRef__r.ShisetsuKubun__c, 
                                                            SaijoRef__r.ShikugunRef__r.Name, 
                                                            ShisetsuRef__r.Name, 
                                                            ShisetsuRef__r.KoeiMinei__c, 
                                                            ShisetsuRef__r.Shikugun__r.Name, 
                                                            ShisetsuRef__r.ShutokenIchibuChiki__c, 
                                                            ShisetsuKubun__c, 
                                                            SogiShiryoSofuRef__c, 
                                                            Hyojijun__c 
                                                    from SogiShiryoSofuMeisais__r 
                                                    order by Hyojijun__c 
                                                ) 
                                            from SogiShiryoSofu__c 
                                            where Id = :shiryoSofuId];

        inputSogiShiroSofuWrap.kasobaTeianList = new List<SogiShiryoSofuMeisai__c>();
        inputSogiShiroSofuWrap.saijoTeianList = new List<SogiShiryoSofuMeisai__c>();
        for(SogiShiryoSofuMeisai__c sltSogiShiryoSofuMeisai : sltShiryoSofu.SogiShiryoSofuMeisais__r){
            if(sltSogiShiryoSofuMeisai.ShisetsuKubun__c == '火葬場') inputSogiShiroSofuWrap.kasobaTeianList.add(sltSogiShiryoSofuMeisai);
            if(sltSogiShiryoSofuMeisai.ShisetsuKubun__c == '斎場') inputSogiShiroSofuWrap.saijoTeianList.add(sltSogiShiryoSofuMeisai);
        }

        for(Integer i = inputSogiShiroSofuWrap.kasobaTeianList.size(); i < 2; i++){
            inputSogiShiroSofuWrap.kasobaTeianList.add(new SogiShiryoSofuMeisai__c());
        }

        for(Integer i = inputSogiShiroSofuWrap.saijoTeianList.size(); i < 10; i++){
            inputSogiShiroSofuWrap.saijoTeianList.add(new SogiShiryoSofuMeisai__c());
        }
    }

    public void faxPdfOutput(){

        SogiShiryoSofu__c shiryo = [select Id, SofuJokyo__c, SofuNichiji__c, InsatsubutsuIchiran__c from SogiShiryoSofu__c where Id = :Apexpages.currentPage().getParameters().get('pShiryoSofuId')];
        if(shiryo.SofuJokyo__c != '送付済'){
            shiryo.SofuJokyo__c = '送付済';
            shiryo.SofuNichiji__c = datetime.now();
            update shiryo;
        }

        if(shiryo.InsatsubutsuIchiran__c.indexOf('会員案内') != -1){
            if(opp.Account.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId()){
                ota.JizenwariShoshoHassoDate__c = date.today();
            }
            else if(opp.Account.RecordTypeId != Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId() && 
                opp.Account.JizenwariShoshoHassoDate__c == null){
                update new Account(Id = opp.AccountId, JizenwariShoshoHassoDate__c = date.today());
            }
        }
        
        sogiShiryoSofuSetting();
    }

    private SogiShiryoSofu__c getShiryoSofuList(){
        return [select Id, 
                    Name, 
                    Fax__c, 
                    PamphletYohi__c, 
                    Mail__c, 
                    SofuShiryoURL__c, 
                    PassWord__c, 
                    Atena__c, 
                    SofuNichiji__c, 
                    InsatsubutsuIchiran__c, 
                    City__c, 
                    OpportunityRef__c, 
                    OpportunityRef__r.ShodanBangoF__c,
                    OpportunityRef__r.Account.AcvmJizenWariMinDate__c,
                    OpportunityRef__r.Account.JizenwariKekaKikan__c,
                    OpportunityRef__r.Account.Name,
                    SofuShubetsu__c, 
                    SofuJokyo__c, 
                    Street__c, 
                    State__c, 
                    YusoShubetsu__c, 
                    IsogiTaio__c, 
                    PostalCode__c, 
                    HosokuSetsumei__c, 
                    HikitsugiJiko__c, 
                    TaSofubutsu1__c, 
                    TaSofubutsu2__c, 
                    TaSofubutsu3__c, 
                    Template__c, 
                    KasoshikiyoMongon__c, 
                    SogiTeianshoIkkatsuSakuseiJokenRef__c, 
                    SogiShiryoSakuseiKekkaRef__c, 
                    PdfSakuseiJokyo__c, 
                    CreatedBy.LastName, 
                    CreatedDate, 
                    (
                        select Id, 
                                SaijoRef__r.Name, 
                                SaijoRef__r.ShisetsuKubun__c, 
                                SaijoRef__r.ShikugunRef__r.Name, 
                                ShisetsuRef__r.Name, 
                                ShisetsuRef__r.KoeiMinei__c, 
                                ShisetsuRef__r.Shikugun__r.Name, 
                                ShisetsuRef__r.ShutokenIchibuChiki__c, 
                                ShisetsuKubun__c, 
                                SogiShiryoSofuRef__c, 
                                Hyojijun__c 
                        from SogiShiryoSofuMeisais__r 
                        order by Hyojijun__c 
                    ), 
                    (
                        select Id, 
                                Service__c, 
                                Plan__c, 
                                PlanKihonKingaku__c, 
                                PlanKihonKingakZeinuki__c, 
                                MemberSeido__c, 
                                KasobaName__c, 
                                KasobaMeisaiKingaku__c, 
                                KasobaMeisaiHyokiName__c, 
                                Waribiki1_Kingaku__c, 
                                Waribiki1_KingakuZeinuki__c, 
                                Waribiki1_Hinmei__c, 
                                Waribiki2_Kingaku__c, 
                                Waribiki2_KingakuZeinuki__c, 
                                Waribiki2_Hinmei__c, 
                                Waribiki3_Kingaku__c, 
                                Waribiki3_KingakuZeinuki__c, 
                                Waribiki3_Hinmei__c, 
                                Waribiki4_Kingaku__c, 
                                Waribiki4_KingakuZeinuki__c, 
                                Waribiki4_Hinmei__c, 
                                KiboArea__c, 
                                GoukeiKingaku__c, 
                                JizenJunbiSheet__c, 
                                ShikigoSurvey__c, 
                                ShikijoName__c, 
                                ShikijoMeisaiKingaku__c, 
                                ShikijoMeisaiHyokiName__c, 
                                Shokei1Zeikomi__c, 
                                Shokei2Zeikomi__c, 
                                Shokei3Zeikomi__c, 
                                SogiShiryoSofuRef__c, 
                                TsuikaRyokin1_Kingaku__c, 
                                TsuikaRyokin1_Suryo__c, 
                                TsuikaRyokin1_Hinmei__c, 
                                TsuikaRyokin2_Kingaku__c, 
                                TsuikaRyokin2_Suryo__c, 
                                TsuikaRyokin2_Hinmei__c, 
                                TsuikaRyokin3_Kingaku__c, 
                                TsuikaRyokin3_Suryo__c, 
                                TsuikaRyokin3_Hinmei__c, 
                                TsuikaRyokin4_Kingaku__c, 
                                TsuikaRyokin4_Suryo__c, 
                                TsuikaRyokin4_Hinmei__c  
                        from Teianshos__r 
                    )
                from SogiShiryoSofu__c 
                where Id = :shiryoSofuId];
    }

    public String shiryoSofuMemberWaribiki {get;set;}
    public Boolean shiryoSofuJizenJizenSheetWaribiki {get;set;}
    private void initWaribiki(){
        
        shiryoSofuMemberWaribiki = '';
        shiryoSofuJizenJizenSheetWaribiki = false;

        if(opp.Account.MemberKubunCode__c == 'OsoshikiYoyaku' || opp.SimpleYasugoRef__r.TaishoshaRef__r.MemberKubunCode__c == 'OsoshikiYoyaku'){ 
            shiryoSofuMemberWaribiki = 'お葬式予約会員';
        }
        else if(opp.Account.MemberKubunCode__c == 'YorisoKaiin' || opp.SimpleYasugoRef__r.TaishoshaRef__r.MemberKubunCode__c == 'YorisoKaiin'){
            shiryoSofuMemberWaribiki = 'よりそう会員';
        }
        else if(opp.Account.MemberKubunCode__c == 'Jizenwari' || opp.SimpleYasugoRef__r.TaishoshaRef__r.MemberKubunCode__c == 'Jizenwari'){
            shiryoSofuMemberWaribiki = '旧よりそう会員';
        } 

        if((opp.Account.RecordTypeId != Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId() && opp.Account.JizenJizenSheetTeishutsuzumi__c) || 
            ota.JizenJunbiSheetGoannaiJokyo__c == '受領') {
                shiryoSofuJizenJizenSheetWaribiki = true;
        }
    }

    Map<String, Map<String, String>> otaPlanKingakuTable = new Map<String, Map<String, String>> {
                                                            '【20.06】火葬式' => new Map<String, String> {
                                                                '直葬'   => '(税抜:103,000　税込:113,300)'
                                                            },
                                                            '【19.12】火葬式' => new Map<String, String> {
                                                                '直葬'   => '(税抜:128,000　税込:140,800)',
                                                                '無宗教' => '(税抜:148,000　税込:162,800)',
                                                                '仏式'   => '(税抜:168,000　税込:184,800)',
                                                                '花束'   => '(税抜:188,000　税込:206,800)'
                                                            },
                                                            '【19.12】一日葬' => new Map<String, String> {
                                                                '無宗教'   => '(税抜:278,000　税込:305,800)',
                                                                '仏式'    => '(税抜:298,000　税込:327,800)',
                                                                'お花増量' => '(税抜:318,000　税込:349,800)'
                                                            },
                                                            '【19.12】家族葬' => new Map<String, String> {
                                                                '無宗教'   => '(税抜:408,000　税込:448,800)',
                                                                '仏式'    => '(税抜:428,000　税込:470,800)',
                                                                'お花増量' => '(税抜:448,000　税込:492,800)'
                                                            },
                                                            '【19.12】一般葬' => new Map<String, String> {
                                                                '無宗教'   => '(税抜:548,000　税込:602,800)',
                                                                '仏式'    => '(税抜:568,000　税込:624,800)',
                                                                'お花増量' => '(税抜:618,000　税込:679,800)'
                                                            },
                                                            '【19.12】お花いっぱい一日葬' => new Map<String, String> {
                                                                '無宗教'         => '(税抜:338,000　税込:371,800)',
                                                                '仏式'           => '(税抜:358,000　税込:393,800)',
                                                                'お花増量' => '(税抜:378,000　税込:415,800)'
                                                            },
                                                            '【19.12】お花いっぱい家族葬' => new Map<String, String> {
                                                                '無宗教'         => '(税抜:528,000　税込:580,800)',
                                                                '仏式'           => '(税抜:548,000　税込:602,800)',
                                                                'お花増量' => '(税抜:568,000　税込:624,800)'
                                                            }
                                                        };

   Map<String, List<String>> otaKingakuPlanTable = new Map<String, List<String>> {
                                                            '(税抜:103,000　税込:113,300)' => new List<String> {'【20.06】火葬式','直葬'},
                                                            '(税抜:128,000　税込:140,800)' => new List<String> {'【19.12】火葬式','直葬'},
                                                            '(税抜:148,000　税込:162,800)' => new List<String> {'【19.12】火葬式','無宗教'},
                                                            '(税抜:168,000　税込:184,800)' => new List<String> {'【19.12】火葬式','仏式'},
                                                            '(税抜:188,000　税込:206,800)' => new List<String> {'【19.12】火葬式','花束'},
                                                            '(税抜:278,000　税込:305,800)' => new List<String> {'【19.12】一日葬','無宗教'},
                                                            '(税抜:298,000　税込:327,800)' => new List<String> {'【19.12】一日葬','仏式'},
                                                            '(税抜:318,000　税込:349,800)' => new List<String> {'【19.12】一日葬','お花増量'},
                                                            '(税抜:408,000　税込:448,800)' => new List<String> {'【19.12】家族葬','無宗教'},
                                                            '(税抜:428,000　税込:470,800)' => new List<String> {'【19.12】家族葬','仏式'},
                                                            '(税抜:448,000　税込:492,800)' => new List<String> {'【19.12】家族葬','お花増量'},
                                                            '(税抜:548,000　税込:602,800)' => new List<String> {'【19.12】一般葬','無宗教'},
                                                            '(税抜:568,000　税込:624,800)' => new List<String> {'【19.12】一般葬','仏式'},
                                                            '(税抜:618,000　税込:679,800)' => new List<String> {'【19.12】一般葬','お花増量'},
                                                            '(税抜:338,000　税込:371,800)' => new List<String> {'【19.12】お花いっぱい一日葬','無宗教'},
                                                            '(税抜:358,000　税込:393,800)' => new List<String> {'【19.12】お花いっぱい一日葬','仏式'},
                                                            '(税抜:378,000　税込:415,800)' => new List<String> {'【19.12】お花いっぱい一日葬','お花増量'},
                                                            '(税抜:528,000　税込:580,800)' => new List<String> {'【19.12】お花いっぱい家族葬','無宗教'}
                                                        };

    Set<String> oppPlanOtaPlanTable = new Set<String> {'【20.11】よりそう家族葬 一日プラン',
                                                        '【20.11】よりそう家族葬 二日プラン',
                                                        '【20.11】よりそう家族葬 華やかプラン',
                                                        '【20.11】よりそう火葬式 直葬プラン',
                                                        '【21.03】よりそう火葬式 シンプルプラン',
                                                        '【20.11】よりそう火葬式 標準プラン'
                                                    };
}