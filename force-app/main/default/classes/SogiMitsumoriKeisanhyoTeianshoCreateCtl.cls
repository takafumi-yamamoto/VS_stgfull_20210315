public class SogiMitsumoriKeisanhyoTeianshoCreateCtl {

    public SogiMitsumoriKeisanhyoTeianshoCreateCtl(ApexPages.StandardController controller){
        shiryoSofuId = controller.getRecord().Id;
        oppId = [select Id, OpportunityRef__c from SogiShiryoSofu__c where Id = :shiryoSofuId].OpportunityRef__c;
    }

    public String oppId {get;set;}
    public String shiryoSofuId {get;set;}
    public List<SogiMitsumoriKeisanhyoWrap> keisanhyoWrapList {get;set;}
    public Boolean teianshoSakuseiKekkaFlg {get;set;}
    public String teianshoSakuseiKekkaMsg {get;set;}

    private SogiMitsumoriKeisanhyoHinmokuPrice.IPrice_Calculator iPrice_Calculator = SogiMitsumoriKeisanhyoHinmokuPrice.get_IPrice_Calculator_instance();
    private Map<String, PricebookEntry> shohinCode_to_pricebookEntry_map = new Map<String, PricebookEntry>();

    public class SogiMitsumoriKeisanhyoWrap{
        public Boolean isSlt {get;set;}

        public SogiMitsumoriKeisanhyo__c keisanhyoObj {get;set;}

        public SogiMitsumoriKeisanhyoWrap(){
        }
    }

    public class WaribikiShohinData {
        public String waribikiShohinName = '';
        public Decimal waribikiKingaku = 0;

        public WaribikiShohinData(PricebookEntry aPricebookEntry){
            waribikiShohinName = aPricebookEntry.Product2.NameForCustomer__c;
            waribikiKingaku = aPricebookEntry.UnitPrice;
        }
    }


    public void init(){
        teianshoSakuseiKekkaFlg = false;
        teianshoSakuseiKekkaMsg = '';
        keisanhyoWrapList = new List<SogiMitsumoriKeisanhyoWrap>();
        shohinCode_to_pricebookEntry_map = iPrice_Calculator.get_priceBookEntry_map();
        getMitsumoriKeisanhyoDataList();
    }

    public void getMitsumoriKeisanhyoDataList(){
        keisanhyoWrapList = new List<SogiMitsumoriKeisanhyoWrap>();

        for(SogiMitsumoriKeisanhyo__c sltKeisanhyo : getSogiMitsumoriKeisanhyoDataList()){
            SogiMitsumoriKeisanhyoWrap wrap = new SogiMitsumoriKeisanhyoWrap();
            wrap.isSlt = false;
            wrap.keisanhyoObj = sltKeisanhyo;
            keisanhyoWrapList.add(wrap);
        }
    }

    private List<SogiMitsumoriKeisanhyo__c> getSogiMitsumoriKeisanhyoDataList(){
        return [select 
                    Id, 
                    Name, 
                    KaimyoHomyo__c, 
                    KaimyoKibo__c, 
                    WaribikiService__c, 
                    KiboPlan__c, 
                    MitsumoriKeisanBiko__c, 
                    SanretsushaShinzokuFrom__c, 
                    SanretsushaShinzokuTo__c, 
                    SanretsushaShinzokuigaiFrom__c, 
                    SanretsushaShinzokuigaiTo__c, 
                    JizenSurvey__c, 
                    ShikigoSurvey__c, 
                    OpportunityRef__c, 
                    SoryoTehaiKibo__c, 
                    ButsuguUmu__c, 
                    CustomName__c, 
                    KazokusoIchinichi__c, 
                    KazokusoHanayaka__c, 
                    KazokusoFutsuka__c, 
                    KasoshikiSimple__c, 
                    KasoshikiKihon__c, 
                    KasoshikiButsugu__c, 
                    KasoshikiOhana__c, 
                    KiboAreaRef__r.Name, 
                    KasobaMeisaiHyokimei__c, 
                    ShikijoMeisaiHyokimei__c, 
                    Saijo__c, 
                    Kasojo__c, 
                    Alliance__c, 
                    CreatedDate, 
                    (
                        select 
                            Id,
                            ItemCode__c, 
                            ItemName__c, 
                            OptionName__c, 
                            Suryo__c, 
                            UnitPriceZeikomi__c, 
                            UnitPriceZeinuki__c, 
                            MeisaiType__c, 
                            Kazoku1nichiFee__c, 
                            Kazoku2nichiFee__c, 
                            KazokuhanayakaFee__c, 
                            KasoSimpleFee__c, 
                            KasoKihonFee__c, 
                            KasoButsuguFee__c, 
                            KasoOhanaFee__c 
                        from SogiMitsumoriKeisanMeisais__r
                        where SltFlg__c = true 
                        and MeisaiType__c in ('火葬料金', '斎場料金', '戒名授与', '僧侶手配(読経)', '祭壇', 'よりそうオプション', '葬儀社オプション' , 'その他オプション') 
                        order by HinmokuBunruiNaiJunjo__c 
                    )
                from SogiMitsumoriKeisanhyo__c 
                where OpportunityRef__c = :oppId 
                order by CreatedDate desc];
    }

    public void actCreateTeiansho(){
        teianshoSakuseiKekkaFlg = false;
        teianshoSakuseiKekkaMsg = '';

        try{
            List<TeianSho__c> insTeianShoList = new List<TeianSho__c>();

            for(SogiMitsumoriKeisanhyoWrap wrap : keisanhyoWrapList){
                if(wrap.isSlt){

                    SogiMitsumoriKeisanhyo__c keisanhyo = wrap.keisanhyoObj;

                    List<String> planList = new List<String>();
                    if(keisanhyo.KazokusoIchinichi__c) planList.add('SBG-0005010');
                    if(keisanhyo.KazokusoFutsuka__c) planList.add('SBG-0005011');
                    if(keisanhyo.KazokusoHanayaka__c) planList.add('SBG-0005012');
                    if(keisanhyo.KasoshikiSimple__c) planList.add('SBG-0005013');
                    if(keisanhyo.KasoshikiKihon__c) planList.add('SBG-0005014');
                    if(keisanhyo.KasoshikiButsugu__c) planList.add('SBG-0005015');
                    if(keisanhyo.KasoshikiOhana__c) planList.add('SBG-0005016');

                    for(String aPlan : planList){

                        PricebookEntry targetPricebookEntry = shohinCode_to_pricebookEntry_map.get(aPlan);

                        TeianSho__c aTeiansho = new TeianSho__c();
                        aTeiansho.SogiShiryoSofuRef__c = shiryoSofuId;
                        aTeiansho.Service__c = 'よりそうお葬式';
                        aTeiansho.KiboArea__c = keisanhyo.KiboAreaRef__r.Name;
                        aTeiansho.Plan__c = targetPricebookEntry.Product2.NameForCustomer__c;
                        aTeiansho.KasobaName__c = keisanhyo.Kasojo__c;
                        aTeiansho.KasobaMeisaiKingaku__c = 0;
                        aTeiansho.KasobaMeisaiHyokiName__c = keisanhyo.KasobaMeisaiHyokimei__c;
                        aTeiansho.ShikijoName__c = keisanhyo.Saijo__c;
                        aTeiansho.ShikijoMeisaiKingaku__c = 0;
                        aTeiansho.ShikijoMeisaiHyokiName__c = keisanhyo.ShikijoMeisaiHyokimei__c;
                        aTeiansho.TsuikaRyokin1_Kingaku__c = 0;
                        aTeiansho.TsuikaRyokin2_Kingaku__c = 0;
                        aTeiansho.TsuikaRyokin3_Kingaku__c = 0;
                        aTeiansho.TsuikaRyokin4_Kingaku__c = 0;
                        aTeiansho.TsuikaRyokin5_Kingaku__c = 0;
                        aTeiansho.TsuikaRyokin6_Kingaku__c = 0;

                        String soryoTehaiKaimyoName = '';
                        if(keisanhyo.SoryoTehaiKibo__c == '希望する' && keisanhyo.KaimyoKibo__c == '希望する'){
                            if(aPlan == 'SBG-0005013' || aPlan == 'SBG-0005014' || aPlan == 'SBG-0005015' || aPlan == 'SBG-0005016'){ soryoTehaiKaimyoName = '僧侶手配なし(戒名あり：' + keisanhyo.KaimyoHomyo__c + ')'; } // 火葬プラン
                            else{ soryoTehaiKaimyoName = '僧侶手配あり(戒名あり：' + keisanhyo.KaimyoHomyo__c + ')'; }
                        }
                        else if(keisanhyo.SoryoTehaiKibo__c == '希望する' && keisanhyo.KaimyoKibo__c == '希望しない'){
                            if(aPlan == 'SBG-0005013' || aPlan == 'SBG-0005014' || aPlan == 'SBG-0005015' || aPlan == 'SBG-0005016'){ soryoTehaiKaimyoName = '僧侶手配なし(戒名なし)'; } // 火葬プラン
                            else{ soryoTehaiKaimyoName = '僧侶手配あり(戒名なし)'; }
                        }
                        else if(keisanhyo.SoryoTehaiKibo__c == '希望しない' && keisanhyo.KaimyoKibo__c == '希望する'){
                            soryoTehaiKaimyoName = '僧侶手配なし(戒名あり：' + keisanhyo.KaimyoHomyo__c + ')';
                        }
                        aTeiansho.TsuikaRyokin1_Hinmei__c = soryoTehaiKaimyoName;
                        aTeiansho.TsuikaRyokin1_Suryo__c = 1;

                        Decimal soryoTehaiKingaku = 0;
                        Decimal kaimyoKingaku = 0;
                        for(SogiMitsumoriKeisanMeisai__c meisai : keisanhyo.SogiMitsumoriKeisanMeisais__r){

                            if(aPlan != 'SBG-0005010' && meisai.ItemCode__c == 'SBG-0005401') continue;
                            if(aPlan != 'SBG-0005010' && meisai.ItemCode__c == 'SBG-0005402') continue;
                            if(aPlan != 'SBG-0005010' && meisai.ItemCode__c == 'SBG-0005403') continue;
                            if(aPlan != 'SBG-0005011' && meisai.ItemCode__c == 'SBG-0005404') continue;
                            if(aPlan != 'SBG-0005011' && meisai.ItemCode__c == 'SBG-0005405') continue;
                            if(aPlan != 'SBG-0005012' && meisai.ItemCode__c == 'SBG-0005406') continue;
                            
                            if(meisai.ItemCode__c == 'SBG-0005518'){
                                if(aPlan == 'SBG-0005010'){ aTeiansho.KasobaMeisaiKingaku__c = meisai.Kazoku1nichiFee__c; }
                                else if(aPlan == 'SBG-0005011'){ aTeiansho.KasobaMeisaiKingaku__c = meisai.Kazoku2nichiFee__c; }
                                else if(aPlan == 'SBG-0005012'){ aTeiansho.KasobaMeisaiKingaku__c = meisai.KazokuhanayakaFee__c; }
                                else if(aPlan == 'SBG-0005013'){ aTeiansho.KasobaMeisaiKingaku__c = meisai.KasoSimpleFee__c; }
                                else if(aPlan == 'SBG-0005014'){ aTeiansho.KasobaMeisaiKingaku__c = meisai.KasoKihonFee__c; }
                                else if(aPlan == 'SBG-0005015'){ aTeiansho.KasobaMeisaiKingaku__c = meisai.KasoButsuguFee__c; }
                                else if(aPlan == 'SBG-0005016'){ aTeiansho.KasobaMeisaiKingaku__c = meisai.KasoOhanaFee__c; }
                                continue;
                            }

                            if(meisai.ItemCode__c == 'SBG-0005519'){
                                if(aPlan == 'SBG-0005010'){ aTeiansho.ShikijoMeisaiKingaku__c = meisai.Kazoku1nichiFee__c; }
                                else if(aPlan == 'SBG-0005011'){ aTeiansho.ShikijoMeisaiKingaku__c = meisai.Kazoku2nichiFee__c; }
                                else if(aPlan == 'SBG-0005012'){ aTeiansho.ShikijoMeisaiKingaku__c = meisai.KazokuhanayakaFee__c; }
                                continue;
                            }

                            if(meisai.MeisaiType__c == '僧侶手配(読経)'){
                                if(aPlan == 'SBG-0005010'){ soryoTehaiKingaku = meisai.Kazoku1nichiFee__c; }
                                if(aPlan == 'SBG-0005011'){ soryoTehaiKingaku = meisai.Kazoku2nichiFee__c; }
                                if(aPlan == 'SBG-0005012'){ soryoTehaiKingaku = meisai.KazokuhanayakaFee__c; }
                                if(aPlan == 'SBG-0005005'){ soryoTehaiKingaku = meisai.KasohyojunFee__c; }
                                continue;
                            }

                            if(meisai.MeisaiType__c == '戒名授与'){
                                if(aPlan == 'SBG-0005010'){ kaimyoKingaku = meisai.Kazoku1nichiFee__c; }
                                if(aPlan == 'SBG-0005011'){ kaimyoKingaku = meisai.Kazoku2nichiFee__c; }
                                if(aPlan == 'SBG-0005012'){ kaimyoKingaku = meisai.KazokuhanayakaFee__c; }
                                if(aPlan == 'SBG-0005013'){ kaimyoKingaku = meisai.KasoSimpleFee__c; }
                                if(aPlan == 'SBG-0005014'){ kaimyoKingaku = meisai.KasoKihonFee__c; }
                                if(aPlan == 'SBG-0005015'){ kaimyoKingaku = meisai.KasoButsuguFee__c; }
                                if(aPlan == 'SBG-0005016'){ kaimyoKingaku = meisai.KasoOhanaFee__c; }
                                continue;
                            }

                            TsuikaRyokinData data = new TsuikaRyokinData(meisai, shohinCode_to_pricebookEntry_map);

                            if(String.isBlank(aTeiansho.TsuikaRyokin1_Hinmei__c)){
                                aTeiansho.TsuikaRyokin1_Hinmei__c = data.shohinName;
                                aTeiansho.TsuikaRyokin1_Suryo__c = meisai.Suryo__c;
                                aTeiansho.TsuikaRyokin1_Kingaku__c = data.kingaku * meisai.Suryo__c;
                            }

                            else if(String.isBlank(aTeiansho.TsuikaRyokin2_Hinmei__c)){
                                aTeiansho.TsuikaRyokin2_Hinmei__c = data.shohinName;
                                aTeiansho.TsuikaRyokin2_Suryo__c = meisai.Suryo__c;
                                aTeiansho.TsuikaRyokin2_Kingaku__c = data.kingaku * meisai.Suryo__c;
                            }

                            else if(String.isBlank(aTeiansho.TsuikaRyokin3_Hinmei__c)){
                                aTeiansho.TsuikaRyokin3_Hinmei__c = data.shohinName;
                                aTeiansho.TsuikaRyokin3_Suryo__c = meisai.Suryo__c;
                                aTeiansho.TsuikaRyokin3_Kingaku__c = data.kingaku * meisai.Suryo__c;
                            }

                            else if(String.isBlank(aTeiansho.TsuikaRyokin4_Hinmei__c)){
                                aTeiansho.TsuikaRyokin4_Hinmei__c = data.shohinName;
                                aTeiansho.TsuikaRyokin4_Suryo__c = meisai.Suryo__c;
                                aTeiansho.TsuikaRyokin4_Kingaku__c = data.kingaku * meisai.Suryo__c;
                            }

                            else if(String.isBlank(aTeiansho.TsuikaRyokin5_Hinmei__c)){
                                aTeiansho.TsuikaRyokin5_Hinmei__c = data.shohinName;
                                aTeiansho.TsuikaRyokin5_Suryo__c = meisai.Suryo__c;
                                aTeiansho.TsuikaRyokin5_Kingaku__c = data.kingaku * meisai.Suryo__c;
                            }

                            else if(String.isBlank(aTeiansho.TsuikaRyokin6_Hinmei__c)){
                                aTeiansho.TsuikaRyokin6_Hinmei__c = data.shohinName;
                                aTeiansho.TsuikaRyokin6_Suryo__c = meisai.Suryo__c;
                                aTeiansho.TsuikaRyokin6_Kingaku__c = data.kingaku * meisai.Suryo__c;
                            }
                        }

                        if(String.isNotBlank(soryoTehaiKaimyoName)) {
                            aTeiansho.TsuikaRyokin1_Kingaku__c = soryoTehaiKingaku + kaimyoKingaku;
                        }

                        if(aPlan == 'SBG-0005013' || aPlan == 'SBG-0005014' || aPlan == 'SBG-0005015'  || aPlan == 'SBG-0005016') { // 火葬式プラン
                            aTeiansho.ShikijoName__c = '';
                            aTeiansho.ShikijoMeisaiKingaku__c = 0;
                            aTeiansho.ShikijoMeisaiHyokiName__c = '';
                        }

                        aTeiansho.PlanKihonKingaku__c = targetPricebookEntry.UnitPrice;
                        aTeiansho.PlanKihonKingakZeinuki__c = targetPricebookEntry.UnitPrice / 1.1;

                        List<WaribikiShohinData> waribikiShohinDataList = new List<WaribikiShohinData>();
                        if(keisanhyo.ButsuguUmu__c == '仏具なし' && aPlan != 'SBG-0005013' && aPlan != 'SBG-0005014' && aPlan != 'SBG-0005015' && aPlan != 'SBG-0005016') waribikiShohinDataList.add(new WaribikiShohinData(shohinCode_to_pricebookEntry_map.get('SBG-0005108'))); // 【20.11】よりそうお葬式 仏具なし割引

                        if(keisanhyo.WaribikiService__c == 'よりそう会員'){
                            if(aPlan == 'SBG-0005010') waribikiShohinDataList.add(new WaribikiShohinData(shohinCode_to_pricebookEntry_map.get('SBG-0005216'))); //【20.12】よりそう家族葬 一日プラン
                            if(aPlan == 'SBG-0005011') waribikiShohinDataList.add(new WaribikiShohinData(shohinCode_to_pricebookEntry_map.get('SBG-0005217'))); //【20.11】よりそう家族葬 二日プラン
                            if(aPlan == 'SBG-0005012') waribikiShohinDataList.add(new WaribikiShohinData(shohinCode_to_pricebookEntry_map.get('SBG-0005218'))); //【20.11】よりそう家族葬 華やかプラン
                            if(aPlan == 'SBG-0005013') waribikiShohinDataList.add(new WaribikiShohinData(shohinCode_to_pricebookEntry_map.get('SBG-0005219'))); //【21.03】よりそう火葬式 シンプルプラン
                            if(aPlan == 'SBG-0005014') waribikiShohinDataList.add(new WaribikiShohinData(shohinCode_to_pricebookEntry_map.get('SBG-0005220'))); //【20.11】よりそう火葬式 基本プラン
                            if(aPlan == 'SBG-0005015') waribikiShohinDataList.add(new WaribikiShohinData(shohinCode_to_pricebookEntry_map.get('SBG-0005221'))); //【20.11】よりそう火葬式 仏具プラン
                            if(aPlan == 'SBG-0005016') waribikiShohinDataList.add(new WaribikiShohinData(shohinCode_to_pricebookEntry_map.get('SBG-0005222'))); //【20.11】よりそう火葬式 お花プラン
                        }
                        else if(keisanhyo.WaribikiService__c == '旧よりそう会員'){
                            if(aPlan == 'SBG-0005010') waribikiShohinDataList.add(new WaribikiShohinData(shohinCode_to_pricebookEntry_map.get('SBG-0005226'))); //【20.12】よりそう家族葬 一日プラン
                            if(aPlan == 'SBG-0005011') waribikiShohinDataList.add(new WaribikiShohinData(shohinCode_to_pricebookEntry_map.get('SBG-0005227'))); //【20.11】よりそう家族葬 二日プラン
                            if(aPlan == 'SBG-0005012') waribikiShohinDataList.add(new WaribikiShohinData(shohinCode_to_pricebookEntry_map.get('SBG-0005228'))); //【20.11】よりそう家族葬 華やかプラン
                            if(aPlan == 'SBG-0005013') waribikiShohinDataList.add(new WaribikiShohinData(shohinCode_to_pricebookEntry_map.get('SBG-0005229'))); //【21.03】よりそう火葬式 シンプルプラン
                            if(aPlan == 'SBG-0005014') waribikiShohinDataList.add(new WaribikiShohinData(shohinCode_to_pricebookEntry_map.get('SBG-0005230'))); //【20.11】よりそう火葬式 基本プラン
                            if(aPlan == 'SBG-0005015') waribikiShohinDataList.add(new WaribikiShohinData(shohinCode_to_pricebookEntry_map.get('SBG-0005231'))); //【20.11】よりそう火葬式 仏具プラン
                            if(aPlan == 'SBG-0005016') waribikiShohinDataList.add(new WaribikiShohinData(shohinCode_to_pricebookEntry_map.get('SBG-0005232'))); //【20.11】よりそう火葬式 お花プラン
                        }
                        else if(keisanhyo.WaribikiService__c == 'お葬式予約会員'){
                            if(aPlan == 'SBG-0005010') waribikiShohinDataList.add(new WaribikiShohinData(shohinCode_to_pricebookEntry_map.get('SBG-0005233'))); //【20.12】よりそう家族葬 一日プラン
                            if(aPlan == 'SBG-0005011') waribikiShohinDataList.add(new WaribikiShohinData(shohinCode_to_pricebookEntry_map.get('SBG-0005234'))); //【20.11】よりそう家族葬 二日プラン
                            if(aPlan == 'SBG-0005012') waribikiShohinDataList.add(new WaribikiShohinData(shohinCode_to_pricebookEntry_map.get('SBG-0005235'))); //【20.11】よりそう家族葬 華やかプラン
                            if(aPlan == 'SBG-0005013') waribikiShohinDataList.add(new WaribikiShohinData(shohinCode_to_pricebookEntry_map.get('SBG-0005236'))); //【21.03】よりそう火葬式 シンプルプラン
                            if(aPlan == 'SBG-0005014') waribikiShohinDataList.add(new WaribikiShohinData(shohinCode_to_pricebookEntry_map.get('SBG-0005237'))); //【20.11】よりそう火葬式 基本プラン
                            if(aPlan == 'SBG-0005016') waribikiShohinDataList.add(new WaribikiShohinData(shohinCode_to_pricebookEntry_map.get('SBG-0005238'))); //【20.11】よりそう火葬式 仏具プラン
                            if(aPlan == 'SBG-0005016') waribikiShohinDataList.add(new WaribikiShohinData(shohinCode_to_pricebookEntry_map.get('SBG-0005239'))); //【20.11】よりそう火葬式 お花プラン
                        }
                        else{
                            if(keisanhyo.Alliance__c != null && keisanhyo.Alliance__c != 'null' && keisanhyo.Alliance__c != '') waribikiShohinDataList.add(new WaribikiShohinData(shohinCode_to_pricebookEntry_map.get(keisanhyo.Alliance__c)));
                        }
                        if(keisanhyo.JizenSurvey__c) waribikiShohinDataList.add(new WaribikiShohinData(shohinCode_to_pricebookEntry_map.get('SBG-0005223'))); //【20.11】よりそうお葬式 事前アンケート割
                        if(keisanhyo.ShikigoSurvey__c) waribikiShohinDataList.add(new WaribikiShohinData(shohinCode_to_pricebookEntry_map.get('SBG-0005224'))); //【20.11】よりそうお葬式 式後アンケート割
                        Decimal waribikiGaku = 0;
                        for(Integer i=0; i<waribikiShohinDataList.size(); i++){
                            WaribikiShohinData tempWaribikiShohinData = waribikiShohinDataList.get(i);
                            if(i == 0){
                                aTeiansho.Waribiki1_Hinmei__c = tempWaribikiShohinData.waribikiShohinName;
                                aTeiansho.Waribiki1_Kingaku__c = tempWaribikiShohinData.waribikiKingaku * -1;
                                aTeiansho.Waribiki1_KingakuZeinuki__c = tempWaribikiShohinData.waribikiKingaku / 1.1 * -1;
                                waribikiGaku += aTeiansho.Waribiki1_Kingaku__c;
                            }
                            if(i == 1){
                                aTeiansho.Waribiki2_Hinmei__c = tempWaribikiShohinData.waribikiShohinName;
                                aTeiansho.Waribiki2_Kingaku__c = tempWaribikiShohinData.waribikiKingaku * -1;
                                aTeiansho.Waribiki2_KingakuZeinuki__c = tempWaribikiShohinData.waribikiKingaku / 1.1 * -1;
                                waribikiGaku += aTeiansho.Waribiki2_Kingaku__c;
                            }
                            if(i == 2){
                                aTeiansho.Waribiki3_Hinmei__c = tempWaribikiShohinData.waribikiShohinName;
                                aTeiansho.Waribiki3_Kingaku__c = tempWaribikiShohinData.waribikiKingaku * -1;
                                aTeiansho.Waribiki3_KingakuZeinuki__c = tempWaribikiShohinData.waribikiKingaku / 1.1 * -1;
                                waribikiGaku += aTeiansho.Waribiki3_Kingaku__c;
                            }
                            if(i == 3){
                                aTeiansho.Waribiki4_Hinmei__c = tempWaribikiShohinData.waribikiShohinName;
                                aTeiansho.Waribiki4_Kingaku__c = tempWaribikiShohinData.waribikiKingaku * -1;
                                aTeiansho.Waribiki4_KingakuZeinuki__c = tempWaribikiShohinData.waribikiKingaku / 1.1 * -1;
                                waribikiGaku += aTeiansho.Waribiki4_Kingaku__c;
                            }
                            if(i == 4){
                                aTeiansho.Waribiki5_Hinmei__c = tempWaribikiShohinData.waribikiShohinName;
                                aTeiansho.Waribiki5_Kingaku__c = tempWaribikiShohinData.waribikiKingaku * -1;
                                aTeiansho.Waribiki5_KingakuZeinuki__c = tempWaribikiShohinData.waribikiKingaku / 1.1 * -1;
                                waribikiGaku += aTeiansho.Waribiki5_Kingaku__c;
                            }
                        }

                        aTeiansho.Shokei1Zeikomi__c = aTeiansho.PlanKihonKingaku__c - waribikiGaku;
                        aTeiansho.Shokei2Zeikomi__c = aTeiansho.KasobaMeisaiKingaku__c + aTeiansho.ShikijoMeisaiKingaku__c;
                        aTeiansho.Shokei3Zeikomi__c = 
                        aTeiansho.TsuikaRyokin1_Kingaku__c + aTeiansho.TsuikaRyokin2_Kingaku__c + aTeiansho.TsuikaRyokin3_Kingaku__c + 
                        aTeiansho.TsuikaRyokin4_Kingaku__c + aTeiansho.TsuikaRyokin5_Kingaku__c + aTeiansho.TsuikaRyokin6_Kingaku__c;
                        aTeiansho.GoukeiKingaku__c = aTeiansho.Shokei1Zeikomi__c + aTeiansho.Shokei2Zeikomi__c + aTeiansho.Shokei3Zeikomi__c;
                        insTeianShoList.add(aTeiansho);
                    }
                }
            }

            insert insTeianShoList;
            teianshoSakuseiKekkaMsg = '提案書を作成しました';
        }
        catch(DmlException e){
            teianshoSakuseiKekkaFlg = true;
            teianshoSakuseiKekkaMsg = e.getDmlMessage(0);
        }
        catch(Exception e){
            teianshoSakuseiKekkaFlg = true;
            teianshoSakuseiKekkaMsg = 'システム管理者へ連絡してください。' + e.getMessage();
        }
    }

    public class TsuikaRyokinData {

        public String shohinName = '';
        public Decimal kingaku = 0;

        public TsuikaRyokinData(SogiMitsumoriKeisanMeisai__c tsuikaShohin, Map<String, PricebookEntry> p_shohinCode_to_pricebookEntry_map){
            if(tsuikaShohin.ItemCode__c == 'SBG-0005517'){
                shohinName = tsuikaShohin.OptionName__c.replace('よりそうお葬式 オプション ' , '');
                kingaku = tsuikaShohin.UnitPriceZeikomi__c;
            }
            else{
                PricebookEntry pe = p_shohinCode_to_pricebookEntry_map.get(tsuikaShohin.ItemCode__c);
                shohinName = pe.Product2.NameForCustomer__c.replace('よりそうお葬式 オプション ' , '');
                kingaku = tsuikaShohin.ItemName__c == '葬儀社オプション' ? tsuikaShohin.UnitPriceZeikomi__c : pe.UnitPrice;
            }
        }
    }
}