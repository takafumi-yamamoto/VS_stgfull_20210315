/**
* クラス名      :   Ctrl_FuneralCompany
* クラス概要     :   葬儀社・火葬場画面
* @created  :   2017/11/30 Vinh Hua Quoc
* @modified :   
*/
public class Ctl_SogishaSearch {
    public SearchWrapper searchWrapper {get; set;}
    public List<FuneralCompanyWrapper> listFuneralCompanyWrapper {get; set;}
    public List<ShisetuWrapper> kasobaShisetsuWrapperList {get; set;}
    public List<SaijoWrapper> saijoShisetsuWrapperList {get; set;}
    public List<SogishaMarkWraper> sogishaMarkWraperList {get; set;}
    public static final String STR_MAP_CENTER_POSITION = '東京都都庁';
    public static final Decimal DECIMAL_OUT_TITUDE = 999;
    public static final Decimal DECIMAL_DEFAULT_LATITUDE = 35.689634;
    public static final Decimal DECIMAL_DEFAULT_LONGITUDE = 139.692101;

    private static ID keiyakuRtSimpleYasugo = Schema.SObjectType.Keiyaku__c.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId();
    private static ID keiyakuRtTokuyakuTen = Schema.SObjectType.Keiyaku__c.getRecordTypeInfosByDeveloperName().get('TokuyakuTen').getRecordTypeId();
    private static ID keiyakuRtPickUp = Schema.SObjectType.Keiyaku__c.getRecordTypeInfosByDeveloperName().get('PickUp').getRecordTypeId();
    private static ID keiyakuRtUmieTehaiDaiko = Schema.SObjectType.Keiyaku__c.getRecordTypeInfosByDeveloperName().get('UmieTehaiDaiko').getRecordTypeId();

    private static final Map<String, Boolean> mokuhyoMitasseiTokuyakutenSortFieldMap = new Map<String, Boolean>{
                                                                        'ptWebKa' => false
                                                                        ,'yuryoShozaiAri' => false
                                                                        ,'saijoAri' => false
                                                                        ,'tokuyakutenKeiyakuAri' => false
                                                                        ,'naibuSokyakuMokuhyosu' => false
                                                                        ,'sokyakuTasseiritsu' => true
                                                                        ,'tokuyakutenTsuryo' => false
                                                                        ,'tokuyakutenToraiaruChu' => false
                                                                        };

    private static final Map<String, Boolean> mokuhyoTasseiTokuyakutenSortFieldMap = new Map<String, Boolean>{
                                                                        'ptWebKa' => false
                                                                        ,'yuryoShozaiAri' => false
                                                                        ,'saijoAri' => false
                                                                        ,'tokuyakutenKeiyakuAri' => false
                                                                        ,'naibuSokyakuMokuhyosu' => false
                                                                        ,'sokyakuTasseiritsu' => true
                                                                        };

    private static final Map<String, Boolean> tsujoSogishaSortFieldMap = new Map<String, Boolean>{
                                                                        'ptWebKa' => false
                                                                        ,'yuryoShozaiAri' => false
                                                                        ,'saijoAri' => false
                                                                        ,'kametenTesuryoYusenJuni' => false
                                                                        };

    private static final Map<Decimal, Decimal> kasoshikiTesuryoYusenJuni = new Map<Decimal, Decimal>{
                                                                         11 => 1 // 【19.12】よりそうのお葬式 標準手数料プラン
                                                                        ,20 => 1 // 【19.12】よりそうのお葬式 標準手数料プラン（旧からの移行）
                                                                        ,21 => 1 // 【19.12】よりそうのお葬式 標準手数料プラン（旧旧からの移行）
                                                                        ,19 => 2 // 【19.12】よりそうのお葬式 式有プラン x30% 手数料プラン
                                                                        ,16 => 3 // 【19.12】よりそうのお葬式 全プラン x30% 手数料プラン
                                                                        ,15 => 4 // 【19.12】よりそうのお葬式 全プラン x25% 手数料プラン
                                                                        ,14 => 5 // 【19.12】よりそうのお葬式 全プラン x20% 手数料プラン
                                                                        ,17 => 5 // 【19.12】よりそうのお葬式 火葬式プラン x20% 手数料プラン
                                                                        ,13 => 6 // 【19.12】よりそうのお葬式 全プラン x15% 手数料プラン
                                                                        ,12 => 7 // 【19.12】よりそうのお葬式 全プラン x10% 手数料プラン
                                                                        };

    private static final Map<Decimal, Decimal> shikiAriTesuryoYusenJuni = new Map<Decimal, Decimal>{
                                                                         11 => 1 // 【19.12】よりそうのお葬式 標準手数料プラン
                                                                        ,20 => 1 // 【19.12】よりそうのお葬式 標準手数料プラン（旧からの移行）
                                                                        ,21 => 1 // 【19.12】よりそうのお葬式 標準手数料プラン（旧旧からの移行）
                                                                        ,17 => 2 // 【19.12】よりそうのお葬式 火葬式プラン x20% 手数料プラン
                                                                        ,16 => 3 // 【19.12】よりそうのお葬式 全プラン x30% 手数料プラン
                                                                        ,19 => 3 // 【19.12】よりそうのお葬式 式有プラン x30% 手数料プラン
                                                                        ,15 => 4 // 【19.12】よりそうのお葬式 全プラン x25% 手数料プラン
                                                                        ,14 => 5 // 【19.12】よりそうのお葬式 全プラン x20% 手数料プラン
                                                                        ,13 => 6 // 【19.12】よりそうのお葬式 全プラン x15% 手数料プラン
                                                                        ,12 => 7 // 【19.12】よりそうのお葬式 全プラン x10% 手数料プラン
                                                                        };
    
    public String searchType {get;set;}

    public Saijo__c saijoConditions {get;set;}

    public SaijoHall__c saijoHallConditions {get;set;}

    public String moyoriekiTohoValue {get; set;} 
    public List<SelectOption> moyoriekiTohoOptions{
        get{
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('', '--なし--'));
            options.add(new SelectOption('5', '5'));
            options.add(new SelectOption('10', '10'));
            options.add(new SelectOption('15', '15'));
            options.add(new SelectOption('20', '20'));
            options.add(new SelectOption('25', '25'));
            options.add(new SelectOption('30', '30'));
            return options;
        }
        set;
    }

    public String saijoKubunValue {get; set;} 
    public List<SelectOption> saijoKubunOptions{
        get{
            List<SelectOption> options = new List<SelectOption>();

            Schema.DescribeFieldResult fieldResult = Saijo__c.ShisetsuKubun__c.getDescribe();
            List<Schema.PicklistEntry> picklistEntries = fieldResult.getPicklistValues();

            for( Schema.PicklistEntry e : picklistEntries ){
                options.add(new SelectOption(e.getValue(), e.getLabel()));
            }

            return options;
        }
        set;
    }

    public String chikunensuValue {get; set;} 
    public List<SelectOption> chikunensuOptions{
        get{
            List<SelectOption> options = new List<SelectOption>();

            options.add(new SelectOption('', '--なし--'));
            options.add(new SelectOption('5', '5'));
            options.add(new SelectOption('10', '10'));
            options.add(new SelectOption('20', '20'));

            return options;
        }
        set;
    }

    public String menkaiKahiValue {get; set;}
    public List<SelectOption> menkaiKahiOptions{
        get{
            List<SelectOption> options = new List<SelectOption>();

            Schema.DescribeFieldResult fieldResult = Saijo__c.AnchiKikanMenkaiKahi__c.getDescribe();
            List<Schema.PicklistEntry> picklistEntries = fieldResult.getPicklistValues();

            for( Schema.PicklistEntry e : picklistEntries ){
                options.add(new SelectOption(e.getValue(), e.getLabel()));
            }

            return options;
        }
        set;
    }

    public String menkaijiTsuikaRyokinValue {get; set;}
    public List<SelectOption> menkaijiTsuikaRyokinOptions{
        get{
            List<SelectOption> options = new List<SelectOption>();

            Schema.DescribeFieldResult fieldResult = Saijo__c.MenkaiTaiojiTsuikaRyokinUmu__c.getDescribe();
            List<Schema.PicklistEntry> picklistEntries = fieldResult.getPicklistValues();

            for( Schema.PicklistEntry e : picklistEntries ){
                options.add(new SelectOption(e.getValue(), e.getLabel()));
            }

            return options;
        }
        set;
    }

    public String kaminShisetsuValue {get; set;}
    public List<SelectOption> kaminShisetsuOptions{
        get{
            List<SelectOption> options = new List<SelectOption>();

            Schema.DescribeFieldResult fieldResult = Saijo__c.KaminShisetsuUmuKokubetsushikiZenjitsu__c.getDescribe();
            List<Schema.PicklistEntry> picklistEntries = fieldResult.getPicklistValues();

            for( Schema.PicklistEntry e : picklistEntries ){
                options.add(new SelectOption(e.getValue(), e.getLabel()));
            }

            return options;
        }
        set;
    }

    public String nyuyokuShisetsuValue {get; set;}
    public List<SelectOption> nyuyokuShisetsuOptions{
        get{
            List<SelectOption> options = new List<SelectOption>();

            Schema.DescribeFieldResult fieldResult = Saijo__c.NyuyokuShisetsu__c.getDescribe();
            List<Schema.PicklistEntry> picklistEntries = fieldResult.getPicklistValues();

            for( Schema.PicklistEntry e : picklistEntries ){
                options.add(new SelectOption(e.getValue(), e.getLabel()));
            }

            return options;
        }
        set;
    }

    public String futonKashidashiValue {get; set;}
    public List<SelectOption> futonKashidashiOptions{
        get{
            List<SelectOption> options = new List<SelectOption>();

            Schema.DescribeFieldResult fieldResult = Saijo__c.FutonKashidashiKahi__c.getDescribe();
            List<Schema.PicklistEntry> picklistEntries = fieldResult.getPicklistValues();

            for( Schema.PicklistEntry e : picklistEntries ){
                options.add(new SelectOption(e.getValue(), e.getLabel()));
            }

            return options;
        }
        set;
    }

    public String shokujiValue {get; set;}
    public List<SelectOption> shokujiOptions{
        get{
            List<SelectOption> options = new List<SelectOption>();

            Schema.DescribeFieldResult fieldResult = Saijo__c.ShokujinoKahi__c.getDescribe();
            List<Schema.PicklistEntry> picklistEntries = fieldResult.getPicklistValues();

            for( Schema.PicklistEntry e : picklistEntries ){
                options.add(new SelectOption(e.getValue(), e.getLabel()));
            }

            return options;
        }
        set;
    }

    public String shokujiMochikomiValue {get; set;}
    public List<SelectOption> shokujiMochikomiOptions{
        get{
            List<SelectOption> options = new List<SelectOption>();

            Schema.DescribeFieldResult fieldResult = Saijo__c.ShokujiNoMochikomiKahi__c.getDescribe();
            List<Schema.PicklistEntry> picklistEntries = fieldResult.getPicklistValues();

            for( Schema.PicklistEntry e : picklistEntries ){
                options.add(new SelectOption(e.getValue(), e.getLabel()));
            }

            return options;
        }
        set;
    }

    public String kurumaisuTaioValue {get; set;}
    public List<SelectOption> kurumaisuTaioOptions{
        get{
            List<SelectOption> options = new List<SelectOption>();

            Schema.DescribeFieldResult fieldResult = Saijo__c.KurumaisuTaio__c.getDescribe();
            List<Schema.PicklistEntry> picklistEntries = fieldResult.getPicklistValues();

            for( Schema.PicklistEntry e : picklistEntries ){
                options.add(new SelectOption(e.getValue(), e.getLabel()));
            }

            return options;
        }
        set;
    }

    public String taioshikishubetsuValue {get; set;}
    public List<SelectOption> taioshikishubetsuOptions{
        get{
            List<SelectOption> options = new List<SelectOption>();

            Schema.DescribeFieldResult fieldResult = SaijoHall__c.TaioShikishubetsu__c.getDescribe();
            List<Schema.PicklistEntry> picklistEntries = fieldResult.getPicklistValues();

            for( Schema.PicklistEntry e : picklistEntries ){
                options.add(new SelectOption(e.getValue(), e.getLabel()));
            }

            return options;
        }
        set;
    }

    public Integer shiyoRyokin {get; set;}

    public String planRyokinGensanValue {get; set;}
    public List<SelectOption> planRyokinGensanOptions{
        get{
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('', '--なし--'));
            options.add(new SelectOption('一日葬', '一日葬'));
            options.add(new SelectOption('家族葬', '家族葬'));
            options.add(new SelectOption('一般葬', '一般葬'));
            return options;
        }
        set;
    }

    public String anchiShisetsuValue {get; set;}
    public List<SelectOption> anchiShisetsuOptions{
        get{
            List<SelectOption> options = new List<SelectOption>();

            Schema.DescribeFieldResult fieldResult = Saijo__c.AnchiShisetsu__c.getDescribe();
            List<Schema.PicklistEntry> picklistEntries = fieldResult.getPicklistValues();

            for( Schema.PicklistEntry e : picklistEntries ){
                options.add(new SelectOption(e.getValue(), e.getLabel()));
            }

            return options;
        }
        set;
    }

    public String kasobaHeisetsuListValue {get; set;}
    public List<SelectOption> kasobaHeisetsuListOptions{
        get{
            List<SelectOption> options = new List<SelectOption>();

            Schema.DescribeFieldResult fieldResult = Saijo__c.KasobaHeisetsuList__c.getDescribe();
            List<Schema.PicklistEntry> picklistEntries = fieldResult.getPicklistValues();

            for( Schema.PicklistEntry e : picklistEntries ){
                options.add(new SelectOption(e.getValue(), e.getLabel()));
            }

            return options;
        }
        set;
    }

    public String kidsRoomListValue {get; set;}
    public List<SelectOption> kidsRoomListOptions{
        get{
            List<SelectOption> options = new List<SelectOption>();

            Schema.DescribeFieldResult fieldResult = Saijo__c.KidsRoomList__c.getDescribe();
            List<Schema.PicklistEntry> picklistEntries = fieldResult.getPicklistValues();

            for( Schema.PicklistEntry e : picklistEntries ){
                options.add(new SelectOption(e.getValue(), e.getLabel()));
            }

            return options;
        }
        set;
    }

    public String junyushitsuListValue {get; set;}
    public List<SelectOption> junyushitsuListOptions{
        get{
            List<SelectOption> options = new List<SelectOption>();

            Schema.DescribeFieldResult fieldResult = Saijo__c.JunyushitsuList__c.getDescribe();
            List<Schema.PicklistEntry> picklistEntries = fieldResult.getPicklistValues();

            for( Schema.PicklistEntry e : picklistEntries ){
                options.add(new SelectOption(e.getValue(), e.getLabel()));
            }

            return options;
        }
        set;
    }

    public String omutsuKokandaiListValue {get; set;}
    public List<SelectOption> omutsuKokandaiListOptions{
        get{
            List<SelectOption> options = new List<SelectOption>();

            Schema.DescribeFieldResult fieldResult = Saijo__c.OmutsuKokandaiList__c.getDescribe();
            List<Schema.PicklistEntry> picklistEntries = fieldResult.getPicklistValues();

            for( Schema.PicklistEntry e : picklistEntries ){
                options.add(new SelectOption(e.getValue(), e.getLabel()));
            }

            return options;
        }
        set;
    }

    public String kurumaisuKashidashiListValue {get; set;}
    public List<SelectOption> kurumaisuKashidashiListOptions{
        get{
            List<SelectOption> options = new List<SelectOption>();

            Schema.DescribeFieldResult fieldResult = Saijo__c.KurumaisuKashidashiList__c.getDescribe();
            List<Schema.PicklistEntry> picklistEntries = fieldResult.getPicklistValues();

            for( Schema.PicklistEntry e : picklistEntries ){
                options.add(new SelectOption(e.getValue(), e.getLabel()));
            }

            return options;
        }
        set;
    }

    public String shisetsuShubetsuValue {get; set;}
    public List<SelectOption> shisetsuShubetsuOptions{
        get{
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('全式場','全式場'));
            options.add(new SelectOption('自社','自社'));
            options.add(new SelectOption('公営','公営'));
            options.add(new SelectOption('民営','民営'));
            options.add(new SelectOption('寺院','寺院'));
            if(oppId != null && oppId != '') options.add(new SelectOption('標準資料','標準資料'));
            return options;
        }
        set;
    }

    public String sortItemValue {get; set;} 
    public List<SelectOption> sortItemValueOptions{
        get{
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('初期表示', '初期表示'));
            options.add(new SelectOption('距離の近い順', '距離の近い順'));
            return options;
        }
        set;
    }

    public String shikiKubunValue {get; set;} 
    public List<SelectOption> shikiKubunOptions{
        get{
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('火葬式', '火葬式'));
            options.add(new SelectOption('式あり', '式あり'));
            return options;
        }
        set;
    }

    public List<ShisetsuTeianWrap> kasobaTeianKohoManualList {get;set;}
    public List<ShisetsuTeianWrap> saijoTeianKohoManualList {get;set;}
    public List<ShisetsuTeianWrap> kasobaTeianKohoAutoList {get;set;}
    public List<ShisetsuTeianWrap> saijoTeianKohoAutoList {get;set;}
    public List<ShisetsuTeianWrap> kasobaTeianFixList {get;set;}
    public List<ShisetsuTeianWrap> saijoTeianFixList {get;set;}
    public class ShisetsuTeianWrap {
        public Boolean teianListFlg {get;set;}
        public String shisetsuId {get;set;}
        public String shisetsuName {get;set;}
        public String shisetsuKubun {get;set;}

        public ShisetsuTeianWrap(){
            teianListFlg = false;
            shisetsuId = '';
            shisetsuName = '';
            shisetsuKubun = '';
        }
    }

    /*
    * Ctrl_FuneralCompany
    * コンストラクタ
    * @created: 2017/11/30 Vinh Hua Quoc
    * @modified:
    */
    public String p1 {get;set;}
    public String subTabName {get;set;}
    public String oppId {get;set;}
    public String kaiinAnnai {get;set;}
    public Ctl_SogishaSearch() {
        resultMsg = '';
        resultFlg = false;
        saijoConditions = new Saijo__c();
        saijoHallConditions = new SaijoHall__c();
        searchWrapper = new SearchWrapper();
        sogishaMarkWraperList = new List<SogishaMarkWraper>();
        subTabName = '';
        searchType = 'idKiboShikugunArea';
        hallJokenClearFlg = true;
        shiyoRyokin = 0;
        shikugunLabel = '';
        shiborikomiJoken = 'なし';
        shokaiKinshiHihyoji = true;
        shisetsuShubetsuValue = '全式場';
        chiikiTokusei = '';
        isSogishaMap = true;
        isKasobaMap = true;
        isSaijoMap = true;
        sortItemValue = '初期表示';
        shikiKubunValue = '火葬式';
        sogiShiryoSofuWrapList = new List<SogiShiryoSofuWrap>();
        kasobaTeianKohoManualList = new List<ShisetsuTeianWrap>();
        kasobaTeianDefaultMaxLimit(kasobaTeianKohoManualList);
        saijoTeianKohoManualList = new List<ShisetsuTeianWrap>();
        saijoTeianDefaultMaxLimit(saijoTeianKohoManualList);
        kasobaTeianKohoAutoList = new List<ShisetsuTeianWrap>();
        kasobaTeianDefaultMaxLimit(kasobaTeianKohoAutoList);
        saijoTeianKohoAutoList = new List<ShisetsuTeianWrap>();
        saijoTeianDefaultMaxLimit(saijoTeianKohoAutoList);
        kasobaTeianFixList = new List<ShisetsuTeianWrap>();
        kasobaTeianDefaultMaxLimit(kasobaTeianFixList);
        saijoTeianFixList = new List<ShisetsuTeianWrap>();
        saijoTeianDefaultMaxLimit(saijoTeianFixList);
        saveResultMsg = '';
        errFlg = false;
        standardTeianMessage = '';
        referShiryoSofu = new SogiShiryoSofu__c();
        shiryoSofuId = '';

        p1 = Apexpages.currentPage().getParameters().get('p1');
        oppId = Apexpages.currentPage().getParameters().get('oppId');
        kaiinAnnai = Apexpages.currentPage().getParameters().get('kaiinannai');
        System.debug('p1:' + p1);
        if(p1 != null && p1 != ''){
            hallJokenClearFlg = false;
            subTabName = Apexpages.currentPage().getParameters().get('p2');
            searchWrapper.account.ShikugunRef__c = p1;
            searchWrapper.address = subTabName;
            searchWrapper.shikugunName = subTabName;
            searchData();
        }

        if(oppId != null && oppId != ''){
            sogiShiryoSofuSetting();
        }
    }

    public String resultMsg {get;set;}
    public Boolean resultFlg {get;set;}

    public Decimal latitudeIn;
    public Decimal longitudeIn;

    public Boolean hallJokenClearFlg {get;set;}

    public Boolean ichinichiIppanFlg {get;set;}
    public Boolean ichinichiShiminFlg {get;set;}
    public Boolean ichinichiShimimgaiFlg {get;set;}
    public Boolean kazokuIppanIppanFlg {get;set;}
    public Boolean kazokuIppanShiminFlg {get;set;}
    public Boolean kazokuIppanShimimgaiFlg {get;set;}

    public Integer saijoKensu {get;set;}
    public String shiborikomiJoken {get;set;}
    public String shikugunLabel {get;set;}

    public Shikugun__c sltShikugun {get;set;}
    public Set<ID> shikugunIdSet {get;set;}

    public Boolean shokaiKinshiHihyoji {get;set;}
    public String chiikiTokusei {get;set;}
    public Boolean isSogishaMap {get;set;}
    public Boolean isKasobaMap {get;set;}
    public Boolean isSaijoMap {get;set;}

    /**
    * searchData
    * 検索アクション
    * @param なし
    * @return なし
    * @created: 2017/11/30 Vinh Hua Quoc
    * @modified: 
    */
    public void searchData(){

        resultMsg = '';
        resultFlg = false;
        listFuneralCompanyWrapper = new List<FuneralCompanyWrapper>();
        kasobaShisetsuWrapperList = new List<ShisetuWrapper>();
        saijoShisetsuWrapperList = new List<SaijoWrapper>();
        sogishaMarkWraperList = new List<SogishaMarkWraper>();
        saijoKensu = 0;
        latitudeIn = 0;
        longitudeIn = 0;
        shisetsuShubetsuValue = '全式場';
        chiikiTokusei = '';
        isSogishaMap = true;
        isKasobaMap = true;
        isSaijoMap = true;
        sortItemValue = '初期表示';

        sltShikugun = new Shikugun__c();
        List<Shikugun__c> lTempShikugun = new List<Shikugun__c>();
        if(p1 != null && p1 != '' && p1 != 'null'){
            lTempShikugun = [
                                SELECT Id,
                                    Chiriichijouhou__latitude__s, 
                                    Chiriichijouhou__longitude__s,
                                    name, 
                                    (
                                        SELECT Id, 
                                                Tokusei__c
                                        FROM ChiikiTokuseis__r
                                    )
                                FROM Shikugun__c 
                                WHERE name = :searchWrapper.shikugunName
                                LIMIT 1
                            ];
            if(lTempShikugun.size() == 0){
                resultMsg = '一致する市区郡マスタが存在しませんでした';
                return;
            }
            else if(!lTempShikugun.isEmpty() && lTempShikugun[0].Chiriichijouhou__latitude__s != null && lTempShikugun[0].Chiriichijouhou__longitude__s != null){
                sltShikugun = lTempShikugun[0];
                latitudeIn = lTempShikugun[0].Chiriichijouhou__latitude__s;
                longitudeIn = lTempShikugun[0].Chiriichijouhou__longitude__s;
                System.debug('lTempShikugun : ' + lTempShikugun);
                searchWrapper.latitudeAdress = lTempShikugun[0].Chiriichijouhou__latitude__s;
                searchWrapper.longitudeAdress = lTempShikugun[0].Chiriichijouhou__longitude__s;
                searchWrapper.centerLat = lTempShikugun[0].Chiriichijouhou__latitude__s;
                searchWrapper.centerLon = lTempShikugun[0].Chiriichijouhou__longitude__s;
                searchWrapper.defLat = lTempShikugun[0].Chiriichijouhou__latitude__s;
                searchWrapper.defLon = lTempShikugun[0].Chiriichijouhou__longitude__s;
                searchWrapper.displaySearchPostionName = lTempShikugun[0].name;
                searchWrapper.kensakuChitenJusho = lTempShikugun[0].name;
            }
            else{
                resultMsg = 'システムエラーが発生しました。管理者へ連絡してください。';
                return;
            }
            p1 = '';
        }
        else{
            latitudeIn  = searchWrapper.latitudeAdress;
            longitudeIn = searchWrapper.longitudeAdress;

            String soql = 'SELECT Id, ' + 
                            'Chiriichijouhou__latitude__s, ' + 
                            'Chiriichijouhou__longitude__s, ' + 
                            'Name, ' + 
                            '(SELECT Id, ' + 
                            ' Tokusei__c ' + 
                            ' FROM ChiikiTokuseis__r) ' + 
                            'FROM Shikugun__c ' + 
                            'WHERE Name Like \'%' + searchWrapper.shikugunName + '%\' ' + 
                            'ORDER BY DISTANCE(Chiriichijouhou__c, GEOLOCATION(' + latitudeIn + ',' + longitudeIn + '), \'km\') asc NULLS LAST';
            lTempShikugun = database.query(soql);

            if(lTempShikugun.size() == 0){
                resultMsg = '一致する市区郡マスタが存在しませんでした';
                return;
            }
            else if(lTempShikugun.size() > 1){

                if(searchType == 'idKiboShikugunArea'){
                    resultMsg = '複数の市区郡が検索されたので絞り込みを行ってください';
                    return;
                }
                else{
                    sltShikugun = lTempShikugun[0];
                    latitudeIn  = sltShikugun.Chiriichijouhou__latitude__s;
                    longitudeIn = sltShikugun.Chiriichijouhou__longitude__s;
                }
            }
            else if(lTempShikugun[0].Chiriichijouhou__latitude__s != null && lTempShikugun[0].Chiriichijouhou__longitude__s != null){
                sltShikugun = lTempShikugun[0];
                if(searchType == 'idKiboShikugunArea'){
                    latitudeIn  = sltShikugun.Chiriichijouhou__latitude__s;
                    longitudeIn = sltShikugun.Chiriichijouhou__longitude__s;
                }
            }
            else{
                resultMsg = 'システムエラーが発生しました。管理者へ連絡してください。';
                return;
            }

            searchWrapper.defLat = latitudeIn;
            searchWrapper.defLon = longitudeIn;
            searchWrapper.centerLat = latitudeIn;
            searchWrapper.centerLon = longitudeIn;

            if(searchType == 'idKiboShikugunArea'){
                searchWrapper.displaySearchPostionName = searchWrapper.shikugunName;
            }
            else{
                searchWrapper.displaySearchPostionName = searchWrapper.address2;
            }
        }

        if(sltShikugun.ChiikiTokuseis__r.size() > 0) chiikiTokusei = sltShikugun.ChiikiTokuseis__r.get(0).Tokusei__c;

        resultFlg = true;
        resultMsg = '「' + sltShikugun.Name + '」で検索を行っています。 (住所：' + searchWrapper.kensakuChitenJusho.replace('日本、', '') + ')';

        List<SekouKanouArea__c> lstSekouKanouArea = [
                                                        SELECT Id,
                                                            SimpleYasugoKeiyakuRef__c,
                                                            SimpleYasugoKeiyakuRef__r.Teikeisaki__c,
                                                            SokyakuTeishi__c
                                                        FROM SekouKanouArea__c
                                                        WHERE ShikugunRef__c = :sltShikugun.Id
                                                        AND SimpleYasugoKeiyakuRef__c != null
                                                        AND SimpleYasugoKeiyakuRef__r.KeiyakuJokyo__c = '契約中'
                                                    ];
                                                    
        Set<String> accountIdSet = new Set<String>();
        Map<Id, Boolean> accountIdMap = new Map<Id, Boolean>();
        for(SekouKanouArea__c item : lstSekouKanouArea){
            accountIdSet.add(item.SimpleYasugoKeiyakuRef__r.Teikeisaki__c);
            accountIdMap.put(item.SimpleYasugoKeiyakuRef__r.Teikeisaki__c, item.SokyakuTeishi__c);
        }

        Map<ID, Keiyaku__c> keiyakuIdMap = new Map<ID, Keiyaku__c>();
        List<ComparableSogisha> mokuhyoMitasseiTokuyakutenList = new List<ComparableSogisha>();
        List<ComparableSogisha> mokuhyoTasseiTokuyakutenList = new List<ComparableSogisha>();
        List<ComparableSogisha> tsujoSogishaList = new List<ComparableSogisha>();

        Map<Id,Account> targetAccountMap = new Map<Id,Account>([
                                                                select Id,
                                                                        Name,
                                                                        TokuyakutenKeiyakusu__c,
                                                                        BillingAddress, 
                                                                        DISTANCE(BillingAddress, GEOLOCATION(:latitudeIn,:longitudeIn), 'km') dist,
                                                                    (
                                                                        select Id,
                                                                            Name,
                                                                            RecordTypeId,
                                                                            SokyakuTasseiritsu__c,
                                                                            TokuyakutenToraiaruChuFlg__c,
                                                                            NaibuSokyakuMokuhyosu__c,
                                                                            KeiyakuChuFlg__c,
                                                                            JishasaijoAri__c,
                                                                            Sokyakujicyuiten__c,
                                                                            sokyakuChuijikoLabel__c,
                                                                            CoronaTaioKa__c, 
                                                                            CoronaTaioBiko__c,
                                                                            Teikeisaki__c,
                                                                            Teikeisaki__r.Name,
                                                                            Teikeisaki__r.BillingAddress,
                                                                            Teikeisaki__r.BillingState,
                                                                            Teikeisaki__r.BillingCity,
                                                                            Teikeisaki__r.BillingStreet,
                                                                            Teikeisaki__r.BillingPostalCode,
                                                                            Teikeisaki__r.BillingLatitude,
                                                                            Teikeisaki__r.BillingLongitude,
                                                                            Teikeisaki__r.CanPtWebSokyakuExp__c,
                                                                            TokkiJiko__c,
                                                                            SougisyaDenwaBango1__c,
                                                                            SougisyaFax__c,
                                                                            SougisyaSoukyakuRank__c,
                                                                            TeikeisakiJusyoIdo__c,
                                                                            TeikeisakiJusyoKeido__c,
                                                                            JisyaSaijoSyoyuJokyo__c,
                                                                            SyuKeiyakuRef__c,
                                                                            CyokuSoTaiouKa__c,
                                                                            ShikiariNeageKosyoStatus__c,
                                                                            sokyakuRenrakusakibiko__c,
                                                                            TokuyakutenTesuryoRef__r.Kasoshiki__c
                                                                        from KeiyakusTeikeisaki__r
                                                                        where (KeiyakuJokyo__c = '契約中' or TokuyakutenToraiaruChuFlg__c = true) 
                                                                        and RecordType.DeveloperName in ('SimpleYasugo', 'TokuyakuTen', 'PickUp', 'UmieTehaiDaiko')
                                                                    ),
                                                                    (
                                                                        select Id, 
                                                                                SimpleYasugoKeiyaku__c,
                                                                                Status__c,
                                                                                KaishiNichiji__c,
                                                                                ShuryoNichiji__c
                                                                        from SogishaSogishaSchedules__r 
                                                                        where Status__c != '完了' 
                                                                        order by ShuryoNichiji__c
                                                                    )
                                                                from Account
                                                                where Id = :accountIdMap.keySet()
                                                                ORDER BY DISTANCE(BillingAddress, GEOLOCATION(:latitudeIn,:longitudeIn), 'km') asc NULLS LAST
                                                            ]);
        
        Set<Id> keiyakuIdSet = new Set<Id>();
        for(Account targetAccount : targetAccountMap.values()){
            for(Keiyaku__c tempKeiyaku : targetAccount.KeiyakusTeikeisaki__r){
                if(tempKeiyaku.RecordTypeId == keiyakuRtSimpleYasugo){
                    keiyakuIdSet.add(tempKeiyaku.Id);
                    break;
                }
            }
        }

        Map<String, Decimal> keiyakuIdTesuryoPlanCodeMap = new Map<String, Decimal>();
        for(TesuryoTekiyo__c aTesuryoTekiyo : [select 
                                                    Id, 
                                                    KeiyakuRef__c, 
                                                    TesuryoPlanRef__r.CoreTesuryoPlanId__c 
                                                from TesuryoTekiyo__c 
                                                where KeiyakuRef__c = :keiyakuIdSet 
                                                    and ShoninStatus__c = '承認済' 
                                                order by TekiyoKaishiBi__c desc ]){
            if(!keiyakuIdTesuryoPlanCodeMap.containsKey(aTesuryoTekiyo.KeiyakuRef__c)){
                if(shikiKubunValue == '火葬式'){
                    if(kasoshikiTesuryoYusenJuni.containsKey(aTesuryoTekiyo.TesuryoPlanRef__r.CoreTesuryoPlanId__c)){
                        keiyakuIdTesuryoPlanCodeMap.put(aTesuryoTekiyo.KeiyakuRef__c, kasoshikiTesuryoYusenJuni.get(aTesuryoTekiyo.TesuryoPlanRef__r.CoreTesuryoPlanId__c));
                    }
                }
                if(shikiKubunValue == '式あり'){
                    if(shikiAriTesuryoYusenJuni.containsKey(aTesuryoTekiyo.TesuryoPlanRef__r.CoreTesuryoPlanId__c)){
                        keiyakuIdTesuryoPlanCodeMap.put(aTesuryoTekiyo.KeiyakuRef__c, shikiAriTesuryoYusenJuni.get(aTesuryoTekiyo.TesuryoPlanRef__r.CoreTesuryoPlanId__c));
                    }
                }
            }
        }

        for(Account targetAccount : targetAccountMap.values()){
            String keiyakuId = '';
            String accountName = '';
            Decimal kametenTesuryoYusenJuni = null;
            Decimal tokuyakutenTsuryo = 0;
            Decimal sokyakuTasseiritsu = null;
            Decimal tokuyakutenToraiaruChu = 0;
            Decimal naibuSokyakuMokuhyosu = 0;
            Decimal tokuyakutenKeiyakuAri = 0;
            Decimal saijoAri = 0;
            Decimal yuryoShozaiAri = 0;
            Decimal ptWebKa = 0;

            for(Keiyaku__c tempKeiyaku : targetAccount.KeiyakusTeikeisaki__r){

                if(tempKeiyaku.RecordTypeId == keiyakuRtSimpleYasugo){
                    keiyakuIdMap.put(tempKeiyaku.Id, tempKeiyaku);
                    keiyakuId = tempKeiyaku.Id;
                    accountName = targetAccount.Name;

                    if(tempKeiyaku.JisyaSaijoSyoyuJokyo__c == '有り') saijoAri = 1;
                    if(tempKeiyaku.Teikeisaki__r.CanPtWebSokyakuExp__c) ptWebKa = 1;
                    if(keiyakuIdTesuryoPlanCodeMap.containsKey(tempKeiyaku.Id)) kametenTesuryoYusenJuni = keiyakuIdTesuryoPlanCodeMap.get(tempKeiyaku.Id);
                }

                if(tempKeiyaku.RecordTypeId == keiyakuRtTokuyakuTen){
                    if(tempKeiyaku.TokuyakutenTesuryoRef__r.Kasoshiki__c != null) tokuyakutenTsuryo = tempKeiyaku.TokuyakutenTesuryoRef__r.Kasoshiki__c;

                    sokyakuTasseiritsu = tempKeiyaku.SokyakuTasseiritsu__c;
                    
                    if(tempKeiyaku.TokuyakutenToraiaruChuFlg__c){
                        tokuyakutenToraiaruChu = 1;
                    }
                    else if(tempKeiyaku.KeiyakuChuFlg__c){
                        naibuSokyakuMokuhyosu = tempKeiyaku.NaibuSokyakuMokuhyosu__c;
                        tokuyakutenKeiyakuAri = 1;
                    }
                }

                if(tempKeiyaku.RecordTypeId == keiyakuRtPickUp || tempKeiyaku.RecordTypeId == keiyakuRtUmieTehaiDaiko) yuryoShozaiAri = 1;
            }

            if(keiyakuId != ''){
                ComparableSogisha comparableSogishaTemp = new ComparableSogisha(new SogishaWrapper(
                                                                keiyakuId,
                                                                accountName,
                                                                tokuyakutenTsuryo,
                                                                kametenTesuryoYusenJuni,
                                                                sokyakuTasseiritsu,
                                                                tokuyakutenToraiaruChu,
                                                                naibuSokyakuMokuhyosu,
                                                                tokuyakutenKeiyakuAri,
                                                                saijoAri,
                                                                yuryoShozaiAri,
                                                                ptWebKa
                                                            ));

                if((sokyakuTasseiritsu != null && sokyakuTasseiritsu < 100) || tokuyakutenToraiaruChu == 1){
                    if(tokuyakutenToraiaruChu == 1 && sokyakuTasseiritsu >= 100){
                        comparableSogishaTemp.sogishaWrapper.tokuyakutenToraiaruChu = 0;
                    }
                    mokuhyoMitasseiTokuyakutenList.add(comparableSogishaTemp);
                }
                else if(tokuyakutenToraiaruChu == 0 && tokuyakutenKeiyakuAri == 1 && sokyakuTasseiritsu >= 100){
                    mokuhyoTasseiTokuyakutenList.add(comparableSogishaTemp);
                }
                else{
                    tsujoSogishaList.add(comparableSogishaTemp);
                }
            }
        }
        
        sortComparableSogisha(mokuhyoMitasseiTokuyakutenList, mokuhyoMitasseiTokuyakutenSortFieldMap, keiyakuIdMap);
        sortComparableSogisha(mokuhyoTasseiTokuyakutenList, mokuhyoTasseiTokuyakutenSortFieldMap, keiyakuIdMap);
        sortComparableSogisha(tsujoSogishaList, tsujoSogishaSortFieldMap, keiyakuIdMap);
        for(FuneralCompanyWrapper item : listFuneralCompanyWrapper){
            if(targetAccountMap.containsKey(item.keiyaku.Teikeisaki__c)){
                Account accountTemp = targetAccountMap.get(item.keiyaku.Teikeisaki__c);
                item.sokyakuTeishi = accountIdMap.get(item.keiyaku.Teikeisaki__c);
                
                item.tokuyakutenFlg = (accountTemp.TokuyakutenKeiyakusu__c > 0) ? true : false;
                item.toraiaruFlg = false;
                for(Keiyaku__c keiyakuTemp : accountTemp.KeiyakusTeikeisaki__r){

                    if(keiyakuTemp.RecordTypeId == keiyakuRtSimpleYasugo){
                        item.coronaTaioKa = keiyakuTemp.CoronaTaioKa__c != null ? keiyakuTemp.CoronaTaioKa__c : '不明';
                        item.kametenTesuryoYusenJuni = keiyakuIdTesuryoPlanCodeMap.containsKey(keiyakuTemp.Id) ? keiyakuIdTesuryoPlanCodeMap.get(keiyakuTemp.Id) : null;
                    }

                    if(keiyakuTemp.RecordTypeId == keiyakuRtTokuyakuTen){
                        item.sokyakuTasseiritsu = String.valueOf(keiyakuTemp.SokyakuTasseiritsu__c);

                        if(keiyakuTemp.TokuyakutenTesuryoRef__r.Kasoshiki__c != null){
                            item.tokuyakutenTsuryo = keiyakuTemp.TokuyakutenTesuryoRef__r.Kasoshiki__c;
                        }
                        
                        if(keiyakuTemp.TokuyakutenToraiaruChuFlg__c){
                            item.toraiaruFlg = true;    
                            break;
                        }
                    }
                }
                if(accountTemp.get('dist') != null){
                    Decimal distanceValue = Decimal.valueOf(String.valueOf(accountTemp.get('dist')));
                    item.distance = String.valueOf(distanceValue.setScale(1)) + 'km';
                }
                if(!item.sokyakuTeishi && accountTemp.SogishaSogishaSchedules__r.size() > 0){
                    SogishaSchedule__c ss = accountTemp.SogishaSogishaSchedules__r.get(0);
                    item.taiofukakikanId = ss.Id;
                    item.taiofukakikanStartDate = Utility_Common.paddingLeftZero(String.valueOf(ss.KaishiNichiji__c.month()), 2) + '/' + Utility_Common.paddingLeftZero(String.valueOf(ss.KaishiNichiji__c.day()), 2) + ' ' + Utility_Common.paddingLeftZero(String.valueOf(ss.KaishiNichiji__c.hour()), 2) + ':' + Utility_Common.paddingLeftZero(String.valueOf(ss.KaishiNichiji__c.minute()), 2);
                    item.taiofukakikanEndDate = Utility_Common.paddingLeftZero(String.valueOf(ss.ShuryoNichiji__c.month()), 2) + '/' + Utility_Common.paddingLeftZero(String.valueOf(ss.ShuryoNichiji__c.day()), 2) + ' ' + Utility_Common.paddingLeftZero(String.valueOf(ss.ShuryoNichiji__c.hour()), 2) + ':' + Utility_Common.paddingLeftZero(String.valueOf(ss.ShuryoNichiji__c.minute()), 2);

                    if(ss.KaishiNichiji__c <= datetime.now() && datetime.now() <= ss.ShuryoNichiji__c){
                        item.sokyakuTeishi = true;
                    }
                }
                item.Sokyakujicyuiten = mergesokyakuChuijiko(item.keiyaku.Sokyakujicyuiten__c ,item.keiyaku.sokyakuChuijikoLabel__c) ;
            }
        }

        List<Shisetsu__c> resultShisetsuList = [SELECT Id,
                                                    Name,
                                                    ShisetsumeiFurigana__c,
                                                    Phone1__c,
                                                    Jusho__c,
                                                    Sogisha__c,
                                                    Sogisha__r.TokuyakutenFlg__c,
                                                    ShisetsuShubetsu__c,
                                                    Shikugun__c, 
                                                    IdoKedo__latitude__s,
                                                    IdoKedo__longitude__s,
                                                    Biko__c,
                                                    KoeiMinei__c,
                                                    IdoKedo__c,
                                                    DISTANCE(IdoKedo__c, GEOLOCATION(:latitudeIn,:longitudeIn), 'km') dist,
                                                    HpUrl__c,
                                                    ShokaiKinshi__c,
                                                    KasobaMenkaiFuka__c,
                                                    Sogisha__r.SimpleYasugoKeiyakuKensu__c,
                                                    UrlOfKasobaPrint__c,
                                                    UrlOfSaijoPrint__c,
                                                    (
                                                        SELECT Id 
                                                        FROM SekoKanoAreasShisetsu__r
                                                        WHERE ShikugunRef__c = :sltShikugun.Id
                                                    )
                                                FROM Shisetsu__c 
                                                WHERE SogishaKensakuHihyoji__c = false 
                                                AND ShisetsuShubetsu__c != '斎場'
                                                ORDER BY DISTANCE(IdoKedo__c, GEOLOCATION(:latitudeIn,:longitudeIn), 'km') ASC NULLS LAST 
                                            ];

        Integer kasobaIndex = 0;
        Integer saijoIndex = 0;
        shikugunIdSet = new Set<ID>();
        for(Shisetsu__c resultShisetsu : resultShisetsuList){
            if(resultShisetsu.SekoKanoAreasShisetsu__r.size() > 0){
                if(resultShisetsu.ShisetsuShubetsu__c == '併設' || resultShisetsu.ShisetsuShubetsu__c == '火葬場'){
                    ShisetuWrapper temp = new ShisetuWrapper(kasobaIndex+1, resultShisetsu);
                    if(resultShisetsu.get('dist') != null){
                        Decimal distanceValue = Decimal.valueOf(String.valueOf(resultShisetsu.get('dist')));
                        temp.distance = String.valueOf(distanceValue.setScale(1)) + 'km';
                    }
                    kasobaShisetsuWrapperList.add(temp);
                    kasobaIndex++;

                    shikugunIdSet.add(resultShisetsu.Shikugun__c);
                }
            }
        }

        if(!hallJokenClearFlg) hallJokenClear();
        searchSaijoData();
    }

    public void hallJokenClear(){
        saijoConditions = new Saijo__c();
        saijoHallConditions = new SaijoHall__c();

        moyoriekiTohoValue = '';
        saijoKubunValue = '';
        chikunensuValue = '';
        menkaiKahiValue = '';
        menkaijiTsuikaRyokinValue = '';
        kaminShisetsuValue = '';
        nyuyokuShisetsuValue = '';
        futonKashidashiValue = '';
        shokujiValue = '';
        shokujiMochikomiValue = '';
        kurumaisuTaioValue = '';
        anchiShisetsuValue = '';
        taioshikishubetsuValue = '';

        shiyoRyokin = 0;
        planRyokinGensanValue = '';
        ichinichiIppanFlg = true;
        ichinichiIppanFlg = true;
        ichinichiShiminFlg = true;
        kazokuIppanIppanFlg = true;
        kazokuIppanShiminFlg = true;
        kazokuIppanShimimgaiFlg = true;
    }


    public void searchSaijoData(){

        if(latitudeIn == null || longitudeIn == null) return;

        saijoKensu = 0;
        shiborikomiJoken = '';

        String saijoWhereSoql = '';

        if(saijoConditions.ShikugunRef__c != null){
            saijoWhereSoql += ' and ShikugunRef__c = \'' + saijoConditions.ShikugunRef__c + '\'';
            shiborikomiJoken += '市区郡=' + shikugunLabel + ' | ';
        }

        if(moyoriekiTohoValue != null && moyoriekiTohoValue != ''){
            saijoWhereSoql += ' and MoyoriTohoFun__c <= ' + Integer.valueOf(moyoriekiTohoValue);
            shiborikomiJoken += '最寄り駅徒歩=' + moyoriekiTohoValue + '分以内' + ' | ';
        }

        if(saijoConditions.ChushaDaisu__c != null){
            saijoWhereSoql += ' and ChushaDaisu__c >= ' + saijoConditions.ChushaDaisu__c;
            shiborikomiJoken += '駐車台数=' + saijoConditions.ChushaDaisu__c + '台以上' + ' | ';
        }

        String[] saijoKubun;
        if(multiselectFlg(saijoKubunValue)){
            saijoKubun = multiselectValueList(saijoKubunValue);
            saijoWhereSoql += ' and ShisetsuKubun__c in :saijoKubun';
            shiborikomiJoken += '施設区分=' + saijoKubun + ' | ';
        }

        if(chikunensuValue != null && chikunensuValue != ''){
            saijoWhereSoql += ' and Chikunensu__c <= ' + Integer.valueOf(chikunensuValue);
            shiborikomiJoken += '築年数=' + chikunensuValue + '年以内' + ' | ';
        }

        String[] menkaiKahi;
        if(multiselectFlg(menkaiKahiValue)){
            menkaiKahi = multiselectValueList(menkaiKahiValue);
            saijoWhereSoql += ' and AnchiKikanMenkaiKahi__c in :menkaiKahi';
            shiborikomiJoken += '面会可否(安置中)=' + menkaiKahi + ' | ';
        }

        String[] menkaijiTsuikaRyokin;
        if(multiselectFlg(menkaijiTsuikaRyokinValue)){
            menkaijiTsuikaRyokin = multiselectValueList(menkaijiTsuikaRyokinValue);
            saijoWhereSoql += ' and MenkaiTaiojiTsuikaRyokinUmu__c in :menkaijiTsuikaRyokin';
            shiborikomiJoken += '面会時追加料金=' + menkaijiTsuikaRyokin + ' | ';
        }

        String[] kaminShisetsuUmuKokubetsushikiZenjitsu;
        if(multiselectFlg(kaminShisetsuValue)){
            kaminShisetsuUmuKokubetsushikiZenjitsu = multiselectValueList(kaminShisetsuValue);
            saijoWhereSoql += ' and KaminShisetsuUmuKokubetsushikiZenjitsu__c in :kaminShisetsuUmuKokubetsushikiZenjitsu';
            shiborikomiJoken += '仮眠施設(告別式前日)=' + kaminShisetsuUmuKokubetsushikiZenjitsu + ' | ';
        }

        if(saijoConditions.KaminKanoNinzu__c != null){
            saijoWhereSoql += ' and KaminKanoNinzu__c >= ' + saijoConditions.KaminKanoNinzu__c;
            shiborikomiJoken += '仮眠可能人数=' + saijoConditions.KaminKanoNinzu__c + '人以上' + ' | ';
        }

        String[] nyuyokuShisetsu;
        if(multiselectFlg(nyuyokuShisetsuValue)){
            nyuyokuShisetsu = multiselectValueList(nyuyokuShisetsuValue);
            saijoWhereSoql += ' and NyuyokuShisetsu__c in :nyuyokuShisetsu';
            shiborikomiJoken += '入浴施設=' + nyuyokuShisetsu + ' | ';
        }

        String[] futonKashidashi;
        if(multiselectFlg(futonKashidashiValue)){
            futonKashidashi = multiselectValueList(futonKashidashiValue);
            saijoWhereSoql += ' and FutonKashidashiKahi__c in :futonKashidashi';
            shiborikomiJoken += '布団貸出し=' + futonKashidashi + ' | ';
        }

        String[] shokuji;
        if(multiselectFlg(shokujiValue)){
            shokuji = multiselectValueList(shokujiValue);
            saijoWhereSoql += ' and ShokujinoKahi__c in :shokuji';
            shiborikomiJoken += '食事=' + shokuji + ' | ';
        }

        String[] shokujiMochikomi;
        if(multiselectFlg(shokujiMochikomiValue)){
            shokujiMochikomi = multiselectValueList(shokujiMochikomiValue);
            saijoWhereSoql += ' and ShokujiNoMochikomiKahi__c in :shokujiMochikomi';
            shiborikomiJoken += '食事持込=' + shokujiMochikomi + ' | ';
        }

        String[] kurumaisuTaio;
        if(multiselectFlg(kurumaisuTaioValue)){
            kurumaisuTaio = multiselectValueList(kurumaisuTaioValue);
            saijoWhereSoql += ' and KurumaisuTaio__c in :kurumaisuTaio';
            shiborikomiJoken += '車椅子可=' + kurumaisuTaio + ' | ';
        }

        String[] kurumaisuKashidashiList;
        if(multiselectFlg(kurumaisuKashidashiListValue)){
            kurumaisuKashidashiList = multiselectValueList(kurumaisuKashidashiListValue);
            saijoWhereSoql += ' and KurumaisuKashidashiList__c in :kurumaisuKashidashiList';
            shiborikomiJoken += '車椅子貸出=' + kurumaisuKashidashiList + ' | ';
        }

        String[] anchiShisetsu;
        if(multiselectFlg(anchiShisetsuValue)){
            anchiShisetsu = multiselectValueList(anchiShisetsuValue);
            saijoWhereSoql += ' and AnchiShisetsu__c in :anchiShisetsu';
            shiborikomiJoken += '安置施設=' + anchiShisetsu + ' | ';
        }

        String[] kasobaHeisetsuList;
        if(multiselectFlg(kasobaHeisetsuListValue)){
            kasobaHeisetsuList = multiselectValueList(kasobaHeisetsuListValue);
            saijoWhereSoql += ' and KasobaHeisetsuList__c in :kasobaHeisetsuList';
            shiborikomiJoken += '火葬場併設=' + kasobaHeisetsuList + ' | ';
        }

        String[] kidsRoomList;
        if(multiselectFlg(kidsRoomListValue)){
            kidsRoomList = multiselectValueList(kidsRoomListValue);
            saijoWhereSoql += ' and KidsRoomList__c in :kidsRoomList';
            shiborikomiJoken += 'キッズルーム=' + kidsRoomList + ' | ';
        }

        String[] junyushitsuList;
        if(multiselectFlg(junyushitsuListValue)){
            junyushitsuList = multiselectValueList(junyushitsuListValue);
            saijoWhereSoql += ' and JunyushitsuList__c in :junyushitsuList';
            shiborikomiJoken += '授乳室=' + junyushitsuList + ' | ';
        }

        String[] omutsuKokandaiList;
        if(multiselectFlg(omutsuKokandaiListValue)){
            omutsuKokandaiList = multiselectValueList(omutsuKokandaiListValue);
            saijoWhereSoql += ' and OmutsuKokandaiList__c in :omutsuKokandaiList';
            shiborikomiJoken += 'オムツ交換台=' + omutsuKokandaiList + ' | ';
        }

        if(shisetsuShubetsuValue != '全式場'){
            shisetsuShubetsuValue += '%';
            saijoWhereSoql += ' and ShisetsuKubun__c like :shisetsuShubetsuValue';
        }

        Boolean hallJokenFlg = false;
        String hallWhereSoql = '';
        String taioshikishubetsu;
        if(multiselectFlg(taioshikishubetsuValue)){
            taioshikishubetsu = multiselectValue(taioshikishubetsuValue);
            hallWhereSoql += ' and TaioShikishubetsu__c includes ' + taioshikishubetsu;
            hallJokenFlg = true;
            shiborikomiJoken += '対応式種別=' + taioshikishubetsu + ' | ';
        }

        if(saijoHallConditions.Sekisu__c != null){
            hallWhereSoql += ' and Sekisu__c >= ' + saijoHallConditions.Sekisu__c;
            hallJokenFlg = true;
            shiborikomiJoken += '席数=' + saijoHallConditions.Sekisu__c + '席以上' + ' | ';
        }

        if(saijoHallConditions.JogenKaisoshasu__c != null){
            hallWhereSoql += ' and JogenKaisoshasu__c >= ' + saijoHallConditions.JogenKaisoshasu__c;
            hallJokenFlg = true;
            shiborikomiJoken += '会葬者数=' + saijoHallConditions.JogenKaisoshasu__c + '人以上' + ' | ';
        }

        if(shiyoRyokin != null && shiyoRyokin > 0){
            shiborikomiJoken += '料金=' + shiyoRyokin + '円以内 ';
            if(planRyokinGensanValue != null){
                if(planRyokinGensanValue == '一日葬'){
                    shiyoRyokin = shiyoRyokin + 25000;
                }
                else if(planRyokinGensanValue == '家族葬'){
                    shiyoRyokin = shiyoRyokin + 50000;
                }
                else if(planRyokinGensanValue == '一般葬'){
                    shiyoRyokin = shiyoRyokin + 70000;
                }
                shiborikomiJoken += 'プラン減算=' + planRyokinGensanValue + ' ';
            }

            String ryokin = '';
            hallWhereSoql += 'and ( Id = null ';
            if(ichinichiIppanFlg && (String.isBlank(planRyokinGensanValue) || planRyokinGensanValue == '一日葬')){
                hallWhereSoql += ' or X1ShiyoRyokinIppan__c <= ' + shiyoRyokin;
                ryokin += '一日葬一般=有,';
            }

            if(ichinichiShiminFlg && (String.isBlank(planRyokinGensanValue) || planRyokinGensanValue == '一日葬')){
                hallWhereSoql += ' or X1ShiyoRyokinShimin__c <= ' + shiyoRyokin;
                ryokin += '一日葬市民=有,';
            }

            if(ichinichiShimimgaiFlg && (String.isBlank(planRyokinGensanValue) || planRyokinGensanValue == '一日葬')){
                hallWhereSoql += ' or X1ShiyoRyokinSonota__c <= ' + shiyoRyokin;
                ryokin += '一日葬市民外=有,';
            }

            if(kazokuIppanIppanFlg){
                hallWhereSoql += ' or X2ShiyoRyokinIppan__c <= ' + shiyoRyokin;
                ryokin += '家族/一般葬一般=有,';
            }

            if(kazokuIppanShiminFlg){
                hallWhereSoql += ' or X2ShiyoRyokinShimin__c <= ' + shiyoRyokin;
                ryokin += '家族/一般葬市民=有,';
            }

            if(kazokuIppanShimimgaiFlg){
                hallWhereSoql += ' or X2ShiyoRyokinSonota__c <= ' + shiyoRyokin;
                ryokin += '家族/一般葬市民外=有,';
            }
            hallWhereSoql += ') ';

            hallJokenFlg = true;
            shiborikomiJoken += ryokin + ' | ';
        }

        if(shiborikomiJoken == ''){
            shiborikomiJoken = 'なし';
        }

        String searchSaijoSoql = 'SELECT Id, ' + 
                                    'Name, ' + 
                                    'KeisaiSaijoMeiKana__c, ' + 
                                    'SeishikiSaijoMei__c, ' + 
                                    'SeishikiSaijoMeiKana__c, ' + 
                                    'JushoKana__c, ' + 
                                    'Tel1__c, ' + 
                                    'Jusho__c, ' + 
                                    'HoyuShutaiSogishaJiinRef__c, ' + 
                                    'HoyuShutaiSogishaJiinRef__r.TokuyakutenFlg__c, ' + 
                                    'HoyuShutaiSogishaJiinRef__r.SimpleYasugoKeiyakuKensu__c, ' + 
                                    'HoyuShutaiText__c, ' + 
                                    'ShikugunRef__c, ' + 
                                    'IdoKedo__latitude__s, ' + 
                                    'IdoKedo__longitude__s, ' + 
                                    'OkyakusamaMukeChuiten__c, ' + 
                                    'ShisetsuKubun__c, ' + 
                                    'KasobaHeisetsuList__c, ' + 
                                    'IdoKedo__c, ' + 
                                    'DISTANCE(IdoKedo__c, GEOLOCATION(:latitudeIn,:longitudeIn), \'km\') dist, ' + 
                                    'HP_URL__c, ' + 
                                    'ShokaiKa__c, ' + 
                                    'UrlOfSaijoPrint__c, ' + 
                                    'ChuiJiko__c, ' + 
                                    'AccessHouhouDensha__c, ' + 
                                    'SogishaRiyoSeigen__c, ' + 
                                    'SogishaRiyoSeigenShosai__c, ' + 
                                    'TaioShuha__c, ' + 
                                    'TaioShuhaBiko__c, ' + 
                                    'ShiminRyokinKubun__c, ' + 
                                    'ShiminRyokinTaishoGyoseiKubunKojinRef__c, ' + 
                                    'ShiminRyokinTaishoGyoseiKubunMoshuRef__c, ' + 
                                    'AnchiShisetsu__c, ' + 
                                    'AnchiKikanMenkaiKahi__c, ' + 
                                    'KaminShisetsuUmuAnchiKikanchu__c, ' + 
                                    'KaminShisetsuJokentsukiBikoAnchi__c, ' + 
                                    'ModoriShonanokaKahi__c, ' + 
                                    'ModorishonanokaJokentsukiBiko__c, ' + 
                                    'ChushaDaisu__c, ' + 
                                    'ShokujinoKahi__c, ' + 
                                    'ShikijoKengakuKahi__c, ' + 
                                    'ZeiKubun__c, ' + 
                                    'HallSu__c, ' + 
                                    'KidsRoomList__c, ' + 
                                    'JunyushitsuList__c, ' + 
                                    'OmutsuKokandaiList__c, ' + 
                                    'KurumaisuKashidashiList__c, ' + 
                                    'SuishoSaijo__c, ' + 
                                    'SuishoRiyu__c, ' + 
                                    'Nickname__c, ' + 
                                    '(' + 
                                        'SELECT Id, ' + 
                                                'Name, ' + 
                                                'Sekisu__c, ' + 
                                                'JogenKaisoshasu__c, ' + 
                                                'ShikijonoYokohabaShaku__c, ' + 
                                                'TaioShikishubetsu__c, ' + 
                                                'X1ShiyoRyokinIppan__c, ' + 
                                                'X1ShiyoRyokinShimin__c, ' + 
                                                'X1ShiyoRyokinSonota__c, ' + 
                                                'X2ShiyoRyokinIppan__c, ' + 
                                                'X2ShiyoRyokinShimin__c, ' + 
                                                'X2ShiyoRyokinSonota__c, ' + 
                                                'ShiyoRyokinBiko__c ' + 
                                        'FROM SaijoShikijos__r ' + 
                                        'WHERE Id != null ' + hallWhereSoql + 
                                        'ORDER BY Sekisu__c, X2ShiyoRyokinIppan__c, X2ShiyoRyokinShimin__c ' + 
                                    ') ' + 
                                'FROM Saijo__c ' + 
                                'WHERE SogishaKensakuHihyoji__c = false and ' + 
                                'DISTANCE(IdoKedo__c, GEOLOCATION(:latitudeIn,:longitudeIn), \'km\') < 50 ' + saijoWhereSoql + 
                                ' ORDER BY DISTANCE(IdoKedo__c, GEOLOCATION(:latitudeIn,:longitudeIn), \'km\') ASC NULLS LAST';
        System.debug('searchSaijoSoql:' + searchSaijoSoql);
        List<Saijo__c> resultSaijoList = Database.query(searchSaijoSoql);

        Integer saijoIndex = 0;
        List<SaijoWrapper> saijoShisetsuWrapperTempList = new List<SaijoWrapper>();
        saijoShisetsuWrapperList = new List<SaijoWrapper>();

        saijoKensu = resultSaijoList.size();
        Decimal gensan = 0;
        if(planRyokinGensanValue == '一日葬'){
            gensan = 25000;
        }
        else if(planRyokinGensanValue == '家族葬'){
            gensan = 50000;
        }
        else if(planRyokinGensanValue == '一般葬'){
            gensan = 70000;
        }

        System.debug('sortItemValue:' + sortItemValue);

        if(sortItemValue == '初期表示'){
            List<Saijo__c> saijoKasobaHeisetsuList = new List<Saijo__c>();
            List<Saijo__c> saijoKoeiList = new List<Saijo__c>();
            List<Saijo__c> saijoTokyyakutenJishaList = new List<Saijo__c>();
            List<Saijo__c> saijoKameitenJishaList = new List<Saijo__c>();
            List<Saijo__c> saijoKyoriList = new List<Saijo__c>();

            for(Saijo__c resultSaijo : resultSaijoList){

                if(resultSaijo.KasobaHeisetsuList__c == '有' && shikugunIdSet.contains(resultSaijo.ShikugunRef__c)){
                    saijoKasobaHeisetsuList.add(resultSaijo);
                }
                else if(resultSaijo.ShisetsuKubun__c == '公営' && (resultSaijo.ShikugunRef__c == sltShikugun.Id || resultSaijo.ShiminRyokinTaishoGyoseiKubunKojinRef__c == sltShikugun.Id)){
                    saijoKoeiList.add(resultSaijo);
                }
                else if(resultSaijo.HoyuShutaiSogishaJiinRef__r.TokuyakutenFlg__c && Decimal.valueOf(String.valueOf(resultSaijo.get('dist'))) <= 20){
                    saijoTokyyakutenJishaList.add(resultSaijo);
                }
                else if(!resultSaijo.HoyuShutaiSogishaJiinRef__r.TokuyakutenFlg__c && resultSaijo.ShisetsuKubun__c == '自社' && Decimal.valueOf(String.valueOf(resultSaijo.get('dist'))) <= 20){
                    saijoKameitenJishaList.add(resultSaijo);
                }
                else{
                    saijoKyoriList.add(resultSaijo);
                }
            }

            saijoShisetsuWrapperTempList = setSaijoList(saijoKasobaHeisetsuList, saijoShisetsuWrapperTempList, gensan);
            saijoShisetsuWrapperTempList = setSaijoList(saijoTokyyakutenJishaList, saijoShisetsuWrapperTempList, gensan);
            saijoShisetsuWrapperTempList = setSaijoList(saijoKoeiList, saijoShisetsuWrapperTempList, gensan);
            saijoShisetsuWrapperTempList = setSaijoList(saijoKameitenJishaList, saijoShisetsuWrapperTempList, gensan);
            saijoShisetsuWrapperTempList = setSaijoList(saijoKyoriList, saijoShisetsuWrapperTempList, gensan);

            sortSaijoList(saijoShisetsuWrapperTempList);
        }
        else if(sortItemValue == '距離の近い順'){

            for(Saijo__c resultSaijo : resultSaijoList){

                saijoIndex++;
                SaijoWrapper temp = new SaijoWrapper(saijoIndex, resultSaijo, gensan);
                if(resultSaijo.get('dist') != null){
                   Decimal distanceValue = Decimal.valueOf(String.valueOf(resultSaijo.get('dist')));
                   temp.distance = String.valueOf(distanceValue.setScale(1)) + 'km';
                }

                saijoShisetsuWrapperTempList.add(temp);

                if(saijoShisetsuWrapperTempList.size() > 100) break;
            }

            sortKyoriSaijoList(saijoShisetsuWrapperTempList);
        }       

        saijoKensu = saijoShisetsuWrapperList.size();
    }

    public Boolean multiselectFlg(String selectValue){
        if(selectValue == null || selectValue == '' || selectValue == '[]'){
            return false;
        }
        return true;
    }

    public String[] multiselectValueList(String selectValue){
        String[] splitSelectValueList = selectValue.replace(' ','').replace('[','').replace(']','').split(',');
        return splitSelectValueList;
    }

    public String multiselectValue(String selectValue){
        String[] splitSelectValueList = selectValue.replace(' ','').replace('[','').replace(']','').split(',');
        String returnSelectValue = '(';
        for(String splitSelectValue : splitSelectValueList){
            returnSelectValue += '\'' + splitSelectValue + '\',';
        }
        returnSelectValue = returnSelectValue.substring(0, returnSelectValue.length() - 1);
        returnSelectValue += ')';
        return returnSelectValue;
    }

    public void sortComparableSogisha(List<ComparableSogisha> sogishaKeiyakuList, Map<String, Boolean> sortFieldMap, Map<ID, Keiyaku__c> keiyakuIdMap){

        List<ComparableSogisha> comparableSogishaList;
        List<ComparableSogisha> comparableSogishaTempList = sogishaKeiyakuList;
        for(String sortField : sortFieldMap.keySet()){

            comparableSogishaList = new List<ComparableSogisha>();
            for(ComparableSogisha sogishaKeiyaku : comparableSogishaTempList){
                comparableSogishaList.add(new ComparableSogisha(sogishaKeiyaku.sogishaWrapper, sortField, sortFieldMap.get(sortField)));
            }
            comparableSogishaList.sort();
            comparableSogishaTempList = comparableSogishaList;
        }


        Integer i = listFuneralCompanyWrapper.size();
        for(ComparableSogisha comparableSogisha : comparableSogishaList){
            Keiyaku__c keiyakuTemp = keiyakuIdMap.get(comparableSogisha.sogishaWrapper.keiyakuId);
            FuneralCompanyWrapper temp = new FuneralCompanyWrapper(i+1, keiyakuTemp);
            listFuneralCompanyWrapper.add(temp);

            if(temp.checkHaveMark()){
                SogishaMarkWraper myMark = new SogishaMarkWraper(i+1, keiyakuTemp);
                sogishaMarkWraperList.add(myMark);
            }
            i++;
        }
    }

    /**
    * clearData
    * データをクリアする
    * @param なし
    * @return なし
    * @created: 2017/11/30 Vinh Hua Quoc
    * @modified: 
    */
    public void clearData(){
        searchWrapper = new SearchWrapper();
        listFuneralCompanyWrapper = new List<FuneralCompanyWrapper>();
        kasobaShisetsuWrapperList = new List<ShisetuWrapper>();
        saijoShisetsuWrapperList = new List<SaijoWrapper>();
        sogishaMarkWraperList = new List<SogishaMarkWraper>();
        return;
    }

    public void hallJokenClearAction(){
        hallJokenClear();
        searchSaijoData();
    }


    public void reloadMap(){searchData();return;}

    /**
    * クラス名      :   SearchWrapper
    * クラス概要     :   葬儀社・火葬場検索
    * @created  :   2017/11/30 Vinh Hua Quoc
    * @modified :   
    */
    public class SearchWrapper {
        public Keiyaku__c keiyaku {get; set;}
        public Account account {get;set;}
        public String address {get; set;}
        public String address2 {get; set;}
        public Decimal latitudeAdress {get; set;}
        public Decimal longitudeAdress {get; set;}
        public String shikugunName {get;set;}
        public String chitenKasoba {get;set;}
        public String displaySearchPostionName{get; set;}
        public Boolean radioLookup {get; set;}
        public Boolean radioText {get; set;}
        public Decimal centerLat {get; set;}
        public Decimal centerLon {get; set;}
        public Decimal defLat {get; set;}
        public Decimal defLon {get; set;}
        public String kensakuChitenJusho {get;set;}

        public SearchWrapper() {
            keiyaku = new Keiyaku__c();
            account = new Account();
            address = '';
            address2 = '';
            latitudeAdress = DECIMAL_DEFAULT_LATITUDE;
            longitudeAdress = DECIMAL_DEFAULT_LONGITUDE;
            centerLat = DECIMAL_DEFAULT_LATITUDE;
            centerLon = DECIMAL_DEFAULT_LONGITUDE;
            defLat = DECIMAL_DEFAULT_LATITUDE;
            defLon = DECIMAL_DEFAULT_LONGITUDE;
            shikugunName = '東京都新宿区';
            chitenKasoba = '東京都新宿区';
            displaySearchPostionName= STR_MAP_CENTER_POSITION;
            radioLookup = true;
            radioText = false;
            kensakuChitenJusho = '';
        }
    }

    /**
    * クラス名      :   FuneralCompanyWrapper
    * クラス概要     :   葬儀社
    * @created  :   2017/11/30 Vinh Hua Quoc
    * @modified :   
    */
    public class FuneralCompanyWrapper {
        public Integer resultIndex {get;set;}
        public Keiyaku__c keiyaku {get; set;}
        public String distance {get; set;} 
        public Decimal tokuyakutenTsuryo {get; set;} 
        public Decimal kametenTesuryoYusenJuni {get; set;} 
        public Boolean sokyakuTeishi {get;set;}
        public Boolean tokuyakutenFlg {get;set;}
        public Boolean toraiaruFlg {get;set;}
        public String sokyakuTasseiritsu {get;set;}
        public Double lat {get;set;}
        public Double lon {get;set;}
        public String taiofukakikanId {get;set;}
        public String taiofukakikanStartDate {get;set;}
        public String taiofukakikanEndDate {get;set;}
        public String coronaTaioKa {get;set;}
        public String Sokyakujicyuiten {get;set;}
        public FuneralCompanyWrapper(Integer resultIndex, Keiyaku__c keiyaku){
            this.resultIndex = resultIndex;
            this.keiyaku = keiyaku;
            this.sokyakuTeishi = false;
            this.tokuyakutenFlg = false;
            this.toraiaruFlg = false;
            this.sokyakuTasseiritsu = null;
            this.distance = '';
            this.tokuyakutenTsuryo = 0;
            this.kametenTesuryoYusenJuni = 0;
            this.taiofukakikanId = '';
            this.taiofukakikanStartDate = '';
            this.taiofukakikanEndDate = '';
            this.coronaTaioKa = '';
            if(keiyaku.Teikeisaki__r.BillingAddress != null){
                Address addr = keiyaku.Teikeisaki__r.BillingAddress;
                this.lat = addr.latitude;
                this.lon = addr.longitude;
            }
            else{
                this.lat = 0;
                this.lon = 0;
            }
        }
        private Boolean checkHaveMark(){
            if(this.keiyaku.TeikeisakiJusyoIdo__c == null || this.keiyaku.TeikeisakiJusyoKeido__c == null){
                return false;
            }
            return true;
        }
    }

    public class SogishaMarkWraper {
        public Integer resultIndex {get;set;}
        public Keiyaku__c keiyaku {get;set;} 
        public SogishaMarkWraper(Integer resultIndex, Keiyaku__c keiyaku){
            this.resultIndex = resultIndex;
            this.keiyaku = keiyaku;
        }
    }

    /**
    * クラス名      :   ShisetuWrapper
    * クラス概要     :   施設
    * @created  :   2017/11/30 Vinh Hua Quoc
    * @modified :   
    */
    public class ShisetuWrapper {
        public Integer resultIndex {get;set;}
        public Shisetsu__c shisetu {get; set;}
        public String distance {get; set;}
        public Boolean sokyakuTeishi {get;set;}
        public Boolean tokuyakutenFlg {get;set;}
        public Boolean toraiaruFlg {get;set;}
        public Double lat {get;set;}
        public Double lon {get;set;}
        public Boolean teianListFlg {get;set;}
        public ShisetuWrapper(Integer resultIndex, Shisetsu__c shisetu){
            this.resultIndex = resultIndex;
            this.shisetu = shisetu;
            this.distance = '';
            this.sokyakuTeishi = false;
            this.tokuyakutenFlg = false;
            this.toraiaruFlg = false;
            if(shisetu.IdoKedo__c != null){
                this.lat = shisetu.IdoKedo__latitude__s;
                this.lon = shisetu.IdoKedo__longitude__s;
            }
            else{
                this.lat = 0;
                this.lon = 0;
            }
            this.teianListFlg = false;
        }
    }

    /**
    * クラス名      :   ShisetuWrapper
    * クラス概要     :   施設
    * @created  :   2017/11/30 Vinh Hua Quoc
    * @modified :   
    */
    public class SaijoWrapper {
        public Integer resultIndex {get;set;}
        public Saijo__c saijo {get; set;}
        public String distance {get; set;}
        public Boolean sokyakuTeishi {get;set;}
        public Boolean tokuyakutenFlg {get;set;}
        public Boolean sogishaListNashi {get;set;}
        public Boolean toraiaruFlg {get;set;}
        public String testMsg {get;set;}
        public Double lat {get;set;}
        public Double lon {get;set;}
        public Boolean teianListFlg {get;set;}
        public List<SaijoHallWrapper> saijoHallOtherList{get;set;}
        public SaijoWrapper(Integer resultIndex, Saijo__c saijo, Decimal gensan){
            this.resultIndex = resultIndex;
            this.saijo = saijo;
            this.distance = '';
            this.sokyakuTeishi = false;
            this.tokuyakutenFlg = false;
            this.sogishaListNashi = false;
            this.toraiaruFlg = false;
            this.testMsg = '';
            if(saijo.IdoKedo__c != null){
                this.lat = saijo.IdoKedo__latitude__s;
                this.lon = saijo.IdoKedo__longitude__s;
            }
            else{
                this.lat = 0;
                this.lon = 0;
            }
            teianListFlg = false;

            this.saijoHallOtherList = new List<SaijoHallWrapper>();

            if(saijo.SaijoShikijos__r.size() > 0){
                for(SaijoHall__c sh : saijo.SaijoShikijos__r){
                    this.saijoHallOtherList.add(new SaijoHallWrapper(sh, gensan));
                }
            }
        }
    }

    public class SaijoHallWrapper {
        public SaijoHall__c saijoHall {get;set;}
        public Decimal gensanX1ShiyoRyokinIppan {get;set;}
        public Decimal gensanX1ShiyoRyokinShimin {get;set;}
        public Decimal gensanX1ShiyoRyokinShimingai {get;set;}
        public Decimal gensanX2ShiyoRyokinIppan {get;set;}
        public Decimal gensanX2ShiyoRyokinShimin {get;set;}
        public Decimal gensanX2ShiyoRyokinShimingai {get;set;}

        public SaijoHallWrapper(SaijoHall__c pSaijoHall, Decimal pGensan){
            saijoHall = pSaijoHall;
            if(pSaijoHall.X1ShiyoRyokinIppan__c != null){
                gensanX1ShiyoRyokinIppan = pSaijoHall.X1ShiyoRyokinIppan__c - pGensan;
            }
            if(pSaijoHall.X1ShiyoRyokinShimin__c != null){
                gensanX1ShiyoRyokinShimin = pSaijoHall.X1ShiyoRyokinShimin__c - pGensan;
            }
            if(pSaijoHall.X1ShiyoRyokinSonota__c != null){
                gensanX1ShiyoRyokinShimingai = pSaijoHall.X1ShiyoRyokinSonota__c - pGensan;
            }
            if(pSaijoHall.X2ShiyoRyokinIppan__c != null){
                gensanX2ShiyoRyokinIppan = pSaijoHall.X2ShiyoRyokinIppan__c - pGensan;
            }
            if(pSaijoHall.X2ShiyoRyokinShimin__c != null){
                gensanX2ShiyoRyokinShimin = pSaijoHall.X2ShiyoRyokinShimin__c - pGensan;
            }
            if(pSaijoHall.X2ShiyoRyokinSonota__c != null){
                gensanX2ShiyoRyokinShimingai = pSaijoHall.X2ShiyoRyokinSonota__c - pGensan;
            }
        }
    }

    public Decimal pLat {get; set;}
    public Decimal pLon {get; set;}

    public void moveCenterPosition(){
        searchWrapper.centerLat = pLat;
        searchWrapper.centerLon = pLon;
    }

    @RemoteAction
    public static list<Shikugun__c> rmtActGetShikugun(String pParam) {
        System.debug('pParam:' + pParam);
        list<Shikugun__c> shikugunList = new list<Shikugun__c>();
        if(pParam != '') {
            String soql = 'SELECT Name FROM Shikugun__c ';
            soql += '            WHERE (Name Like \'%' + pParam + '%\')';
            soql += '            ORDER BY Name';
            soql += '            LIMIT 10';
            shikugunList = database.query(soql);
        }
        System.debug('shikugunList:' + shikugunList);
        return shikugunList;      // クエリーの結果を返す
    }

    @RemoteAction
    public static list<Saijo__c> rmtActGetShisetsu(String pParam) {
        System.debug('pParam:' + pParam);
        list<Saijo__c> shisetsuList = new list<Saijo__c>();
        if(pParam != '') {
            String soql = 'SELECT Id,Name,KeisaiSaijoMeiKana__c FROM Saijo__c ';
            soql += '            WHERE (Name Like \'%' + pParam + '%\'';
            soql += '            OR KeisaiSaijoMeiKana__c Like \'%' + pParam + '%\')';
            soql += '            AND SogishaKensakuHihyoji__c = false';
            soql += '            ORDER BY Name';
            soql += '            LIMIT 10';
            shisetsuList = database.query(soql);
        }
        System.debug('shisetsuList:' + shisetsuList);
        return shisetsuList;      // クエリーの結果を返す
    }

    private static List<SaijoWrapper> setSaijoList(List<Saijo__c> resultSaijoList, List<SaijoWrapper> saijoShisetsuWrapperTempList, Decimal gensan){
        Integer saijoIndex = saijoShisetsuWrapperTempList.size();
        for(Saijo__c resultSaijo : resultSaijoList){

            saijoIndex++;
            SaijoWrapper temp = new SaijoWrapper(saijoIndex, resultSaijo, gensan);
            if(resultSaijo.get('dist') != null){
               Decimal distanceValue = Decimal.valueOf(String.valueOf(resultSaijo.get('dist')));
               temp.distance = String.valueOf(distanceValue.setScale(1)) + 'km';
            }

            saijoShisetsuWrapperTempList.add(temp);

            if(saijoShisetsuWrapperTempList.size() > 100) break;
        }

        return saijoShisetsuWrapperTempList;
    }

    private void sortSaijoList(List<SaijoWrapper> saijoShisetsuWrapperTempList){
        Integer saijoIndex = 0;
        Map<ID, SaijoWrapper> saijoShisetsuMap = new Map<ID, SaijoWrapper>();
        for(SaijoWrapper saijoShisetsuWrapperTemp : saijoShisetsuWrapperTempList){
            for(FuneralCompanyWrapper item : listFuneralCompanyWrapper){
                if(item.keiyaku.Teikeisaki__c == saijoShisetsuWrapperTemp.saijo.HoyuShutaiSogishaJiinRef__c && 
                    saijoShisetsuWrapperTemp.saijo.ShisetsuKubun__c == '自社' && 
                    saijoShisetsuWrapperTemp.saijo.ShikugunRef__c == sltShikugun.Id){
                    System.debug('b1 : ' + saijoShisetsuWrapperTemp.saijo.Id + ' ' + saijoShisetsuWrapperTemp.saijo.Name);
                    saijoIndex++;
                    saijoShisetsuMap.put(saijoShisetsuWrapperTemp.saijo.Id,saijoShisetsuWrapperTemp);
                    saijoShisetsuWrapperTemp.resultIndex = saijoIndex;

                    if(saijoShisetsuWrapperTemp.saijo.HoyuShutaiSogishaJiinRef__r.SimpleYasugoKeiyakuKensu__c == 0){
                        saijoShisetsuWrapperTemp.saijo.ShokaiKa__c = false;
                    }
                    saijoShisetsuWrapperTemp.sokyakuTeishi = item.sokyakuTeishi;
                    saijoShisetsuWrapperTemp.tokuyakutenFlg = item.tokuyakutenFlg;
                    saijoShisetsuWrapperTemp.toraiaruFlg = item.toraiaruFlg;
                    saijoShisetsuWrapperList.add(saijoShisetsuWrapperTemp);
                    break;
                }
            }
            if(saijoShisetsuWrapperList.size() >= 100) break;
        }
        
        for(SaijoWrapper saijoShisetsuWrapperTemp : saijoShisetsuWrapperTempList){
            for(FuneralCompanyWrapper item : listFuneralCompanyWrapper){
                if(!saijoShisetsuMap.containsKey(saijoShisetsuWrapperTemp.saijo.Id) && 
                    saijoShisetsuWrapperTemp.saijo.ShisetsuKubun__c == '自社' && 
                    item.keiyaku.Teikeisaki__c == saijoShisetsuWrapperTemp.saijo.HoyuShutaiSogishaJiinRef__c){
                    System.debug('b2 : ' + saijoShisetsuWrapperTemp.saijo.Id + ' ' + saijoShisetsuWrapperTemp.saijo.Name);
                    saijoIndex++;
                    saijoShisetsuMap.put(saijoShisetsuWrapperTemp.saijo.Id,saijoShisetsuWrapperTemp);
                    saijoShisetsuWrapperTemp.resultIndex = saijoIndex;

                    if(saijoShisetsuWrapperTemp.saijo.HoyuShutaiSogishaJiinRef__r.SimpleYasugoKeiyakuKensu__c == 0){
                        saijoShisetsuWrapperTemp.saijo.ShokaiKa__c = false;
                    }
                    saijoShisetsuWrapperTemp.sokyakuTeishi = item.sokyakuTeishi;
                    saijoShisetsuWrapperTemp.tokuyakutenFlg = item.tokuyakutenFlg;
                    saijoShisetsuWrapperTemp.toraiaruFlg = item.toraiaruFlg;
                    saijoShisetsuWrapperList.add(saijoShisetsuWrapperTemp);
                    break;
                }
            }
            if(saijoShisetsuWrapperList.size() >= 100) break;
        }

        for(SaijoWrapper saijoShisetsuWrapperTemp : saijoShisetsuWrapperTempList){
            if(!saijoShisetsuMap.containsKey(saijoShisetsuWrapperTemp.saijo.Id) && 
                saijoShisetsuWrapperTemp.saijo.KasobaHeisetsuList__c == '有' && shikugunIdSet.contains(saijoShisetsuWrapperTemp.saijo.ShikugunRef__c)){
                System.debug('b3 : ' + saijoShisetsuWrapperTemp.saijo.Id + ' ' + saijoShisetsuWrapperTemp.saijo.Name);
                saijoIndex++;
                saijoShisetsuMap.put(saijoShisetsuWrapperTemp.saijo.Id,saijoShisetsuWrapperTemp);
                saijoShisetsuWrapperTemp.resultIndex = saijoIndex;

                if(saijoShisetsuWrapperTemp.saijo.HoyuShutaiSogishaJiinRef__c != null && saijoShisetsuWrapperTemp.saijo.HoyuShutaiSogishaJiinRef__r.SimpleYasugoKeiyakuKensu__c == 0){
                    saijoShisetsuWrapperTemp.saijo.ShokaiKa__c = false;
                }
                saijoShisetsuWrapperTemp.tokuyakutenFlg = saijoShisetsuWrapperTemp.saijo.HoyuShutaiSogishaJiinRef__r.TokuyakutenFlg__c;
                saijoShisetsuWrapperTemp.resultIndex = saijoIndex;
                saijoShisetsuWrapperList.add(saijoShisetsuWrapperTemp);

                if(saijoShisetsuWrapperList.size() >= 100) break;
            }
        }

        for(SaijoWrapper saijoShisetsuWrapperTemp : saijoShisetsuWrapperTempList){
            if(!saijoShisetsuMap.containsKey(saijoShisetsuWrapperTemp.saijo.Id) && 
                saijoShisetsuWrapperTemp.saijo.ShisetsuKubun__c == '公営' && 
                (saijoShisetsuWrapperTemp.saijo.ShikugunRef__c == sltShikugun.Id || saijoShisetsuWrapperTemp.saijo.ShiminRyokinTaishoGyoseiKubunKojinRef__c == sltShikugun.Id)){
                System.debug('b4 : ' + saijoShisetsuWrapperTemp.saijo.Id + ' ' + saijoShisetsuWrapperTemp.saijo.Name);
                saijoIndex++;
                saijoShisetsuMap.put(saijoShisetsuWrapperTemp.saijo.Id,saijoShisetsuWrapperTemp);
                saijoShisetsuWrapperTemp.resultIndex = saijoIndex;

                if(saijoShisetsuWrapperTemp.saijo.HoyuShutaiSogishaJiinRef__c != null && saijoShisetsuWrapperTemp.saijo.HoyuShutaiSogishaJiinRef__r.SimpleYasugoKeiyakuKensu__c == 0){
                    saijoShisetsuWrapperTemp.saijo.ShokaiKa__c = false;
                }
                saijoShisetsuWrapperTemp.tokuyakutenFlg = saijoShisetsuWrapperTemp.saijo.HoyuShutaiSogishaJiinRef__r.TokuyakutenFlg__c;
                saijoShisetsuWrapperTemp.resultIndex = saijoIndex;
                saijoShisetsuWrapperList.add(saijoShisetsuWrapperTemp);

                if(saijoShisetsuWrapperList.size() >= 100) break;
            }
        }

        for(SaijoWrapper saijoShisetsuWrapperTemp : saijoShisetsuWrapperTempList){
            if(!saijoShisetsuMap.containsKey(saijoShisetsuWrapperTemp.saijo.Id) && 
                saijoShisetsuWrapperTemp.saijo.HoyuShutaiSogishaJiinRef__c != null && 
                saijoShisetsuWrapperTemp.saijo.ShisetsuKubun__c == '自社' && 
                (saijoShisetsuWrapperTemp.saijo.ShikugunRef__c == sltShikugun.Id || saijoShisetsuWrapperTemp.saijo.ShiminRyokinTaishoGyoseiKubunKojinRef__c == sltShikugun.Id)){
                System.debug('b5 : ' + saijoShisetsuWrapperTemp.saijo.Id + ' ' + saijoShisetsuWrapperTemp.saijo.Name);
                saijoIndex++;
                saijoShisetsuMap.put(saijoShisetsuWrapperTemp.saijo.Id,saijoShisetsuWrapperTemp);
                saijoShisetsuWrapperTemp.resultIndex = saijoIndex;

                if(saijoShisetsuWrapperTemp.saijo.HoyuShutaiSogishaJiinRef__c != null && saijoShisetsuWrapperTemp.saijo.HoyuShutaiSogishaJiinRef__r.SimpleYasugoKeiyakuKensu__c == 0){
                    saijoShisetsuWrapperTemp.saijo.ShokaiKa__c = false;
                }
                saijoShisetsuWrapperTemp.tokuyakutenFlg = saijoShisetsuWrapperTemp.saijo.HoyuShutaiSogishaJiinRef__r.TokuyakutenFlg__c;
                saijoShisetsuWrapperTemp.resultIndex = saijoIndex;
                saijoShisetsuWrapperTemp.sogishaListNashi = true;
                saijoShisetsuWrapperList.add(saijoShisetsuWrapperTemp);

                if(saijoShisetsuWrapperList.size() >= 100) break;
            }
        }

        for(SaijoWrapper saijoShisetsuWrapperTemp : saijoShisetsuWrapperTempList){
            if(!saijoShisetsuMap.containsKey(saijoShisetsuWrapperTemp.saijo.Id) && 
                saijoShisetsuWrapperTemp.saijo.HoyuShutaiSogishaJiinRef__c != null && 
                saijoShisetsuWrapperTemp.saijo.ShisetsuKubun__c == '自社'){
                System.debug('b6 : ' + saijoShisetsuWrapperTemp.saijo.Id + ' ' + saijoShisetsuWrapperTemp.saijo.Name);
                saijoIndex++;
                saijoShisetsuMap.put(saijoShisetsuWrapperTemp.saijo.Id,saijoShisetsuWrapperTemp);
                saijoShisetsuWrapperTemp.resultIndex = saijoIndex;

                if(saijoShisetsuWrapperTemp.saijo.HoyuShutaiSogishaJiinRef__c != null && saijoShisetsuWrapperTemp.saijo.HoyuShutaiSogishaJiinRef__r.SimpleYasugoKeiyakuKensu__c == 0){
                    saijoShisetsuWrapperTemp.saijo.ShokaiKa__c = false;
                }
                saijoShisetsuWrapperTemp.tokuyakutenFlg = saijoShisetsuWrapperTemp.saijo.HoyuShutaiSogishaJiinRef__r.TokuyakutenFlg__c;
                saijoShisetsuWrapperTemp.resultIndex = saijoIndex;
                saijoShisetsuWrapperTemp.sogishaListNashi = true;
                saijoShisetsuWrapperList.add(saijoShisetsuWrapperTemp);

                if(saijoShisetsuWrapperList.size() >= 100) break;
            }
        }

        for(SaijoWrapper saijoShisetsuWrapperTemp : saijoShisetsuWrapperTempList){
            if(!saijoShisetsuMap.containsKey(saijoShisetsuWrapperTemp.saijo.Id) && 
                saijoShisetsuWrapperTemp.saijo.ShisetsuKubun__c == '民営' && 
                (saijoShisetsuWrapperTemp.saijo.ShikugunRef__c == sltShikugun.Id || saijoShisetsuWrapperTemp.saijo.ShiminRyokinTaishoGyoseiKubunKojinRef__c == sltShikugun.Id)){
                System.debug('b7 : ' + saijoShisetsuWrapperTemp.saijo.Id + ' ' + saijoShisetsuWrapperTemp.saijo.Name);
                saijoIndex++;
                saijoShisetsuMap.put(saijoShisetsuWrapperTemp.saijo.Id,saijoShisetsuWrapperTemp);
                saijoShisetsuWrapperTemp.resultIndex = saijoIndex;

                if(saijoShisetsuWrapperTemp.saijo.HoyuShutaiSogishaJiinRef__c != null && saijoShisetsuWrapperTemp.saijo.HoyuShutaiSogishaJiinRef__r.SimpleYasugoKeiyakuKensu__c == 0){
                    saijoShisetsuWrapperTemp.saijo.ShokaiKa__c = false;
                }
                saijoShisetsuWrapperTemp.tokuyakutenFlg = saijoShisetsuWrapperTemp.saijo.HoyuShutaiSogishaJiinRef__r.TokuyakutenFlg__c;
                saijoShisetsuWrapperTemp.resultIndex = saijoIndex;
                saijoShisetsuWrapperList.add(saijoShisetsuWrapperTemp);

                if(saijoShisetsuWrapperList.size() >= 100) break;
            }
        }

        for(SaijoWrapper saijoShisetsuWrapperTemp : saijoShisetsuWrapperTempList){
            if(!saijoShisetsuMap.containsKey(saijoShisetsuWrapperTemp.saijo.Id) && 
                saijoShisetsuWrapperTemp.saijo.ShisetsuKubun__c == '寺院' && 
                (saijoShisetsuWrapperTemp.saijo.ShikugunRef__c == sltShikugun.Id || saijoShisetsuWrapperTemp.saijo.ShiminRyokinTaishoGyoseiKubunKojinRef__c == sltShikugun.Id)){
                System.debug('b8 : ' + saijoShisetsuWrapperTemp.saijo.Id + ' ' + saijoShisetsuWrapperTemp.saijo.Name);
                saijoIndex++;
                saijoShisetsuMap.put(saijoShisetsuWrapperTemp.saijo.Id,saijoShisetsuWrapperTemp);
                saijoShisetsuWrapperTemp.resultIndex = saijoIndex;

                if(saijoShisetsuWrapperTemp.saijo.HoyuShutaiSogishaJiinRef__c != null && saijoShisetsuWrapperTemp.saijo.HoyuShutaiSogishaJiinRef__r.SimpleYasugoKeiyakuKensu__c == 0){
                    saijoShisetsuWrapperTemp.saijo.ShokaiKa__c = false;
                }
                saijoShisetsuWrapperTemp.tokuyakutenFlg = saijoShisetsuWrapperTemp.saijo.HoyuShutaiSogishaJiinRef__r.TokuyakutenFlg__c;
                saijoShisetsuWrapperTemp.resultIndex = saijoIndex;
                saijoShisetsuWrapperList.add(saijoShisetsuWrapperTemp);

                if(saijoShisetsuWrapperList.size() >= 100) break;
            }
        }

        for(SaijoWrapper saijoShisetsuWrapperTemp : saijoShisetsuWrapperTempList){
            if(!saijoShisetsuMap.containsKey(saijoShisetsuWrapperTemp.saijo.Id) && 
                saijoShisetsuWrapperTemp.saijo.ShisetsuKubun__c == '公営'){
                System.debug('b9 : ' + saijoShisetsuWrapperTemp.saijo.Id + ' ' + saijoShisetsuWrapperTemp.saijo.Name);
                saijoIndex++;
                saijoShisetsuMap.put(saijoShisetsuWrapperTemp.saijo.Id,saijoShisetsuWrapperTemp);
                saijoShisetsuWrapperTemp.resultIndex = saijoIndex;

                if(saijoShisetsuWrapperTemp.saijo.HoyuShutaiSogishaJiinRef__c != null && saijoShisetsuWrapperTemp.saijo.HoyuShutaiSogishaJiinRef__r.SimpleYasugoKeiyakuKensu__c == 0){
                    saijoShisetsuWrapperTemp.saijo.ShokaiKa__c = false;
                }
                saijoShisetsuWrapperTemp.tokuyakutenFlg = saijoShisetsuWrapperTemp.saijo.HoyuShutaiSogishaJiinRef__r.TokuyakutenFlg__c;
                saijoShisetsuWrapperTemp.resultIndex = saijoIndex;
                saijoShisetsuWrapperList.add(saijoShisetsuWrapperTemp);

                if(saijoShisetsuWrapperList.size() >= 100) break;
            }
        }

        for(SaijoWrapper saijoShisetsuWrapperTemp : saijoShisetsuWrapperTempList){
            if(!saijoShisetsuMap.containsKey(saijoShisetsuWrapperTemp.saijo.Id) && 
                saijoShisetsuWrapperTemp.saijo.ShisetsuKubun__c == '民営'){
                System.debug('b10 : ' + saijoShisetsuWrapperTemp.saijo.Id + ' ' + saijoShisetsuWrapperTemp.saijo.Name);
                saijoIndex++;
                saijoShisetsuMap.put(saijoShisetsuWrapperTemp.saijo.Id,saijoShisetsuWrapperTemp);
                saijoShisetsuWrapperTemp.resultIndex = saijoIndex;

                if(saijoShisetsuWrapperTemp.saijo.HoyuShutaiSogishaJiinRef__c != null && saijoShisetsuWrapperTemp.saijo.HoyuShutaiSogishaJiinRef__r.SimpleYasugoKeiyakuKensu__c == 0){
                    saijoShisetsuWrapperTemp.saijo.ShokaiKa__c = false;
                }
                saijoShisetsuWrapperTemp.tokuyakutenFlg = saijoShisetsuWrapperTemp.saijo.HoyuShutaiSogishaJiinRef__r.TokuyakutenFlg__c;
                saijoShisetsuWrapperTemp.resultIndex = saijoIndex;
                saijoShisetsuWrapperList.add(saijoShisetsuWrapperTemp);

                if(saijoShisetsuWrapperList.size() >= 100) break;
            }
        }

        for(SaijoWrapper saijoShisetsuWrapperTemp : saijoShisetsuWrapperTempList){
            if(!saijoShisetsuMap.containsKey(saijoShisetsuWrapperTemp.saijo.Id) && 
                saijoShisetsuWrapperTemp.saijo.ShisetsuKubun__c == '寺院'){
                System.debug('b11 : ' + saijoShisetsuWrapperTemp.saijo.Id + ' ' + saijoShisetsuWrapperTemp.saijo.Name);
                saijoIndex++;
                saijoShisetsuMap.put(saijoShisetsuWrapperTemp.saijo.Id,saijoShisetsuWrapperTemp);
                saijoShisetsuWrapperTemp.resultIndex = saijoIndex;

                if(saijoShisetsuWrapperTemp.saijo.HoyuShutaiSogishaJiinRef__c != null && saijoShisetsuWrapperTemp.saijo.HoyuShutaiSogishaJiinRef__r.SimpleYasugoKeiyakuKensu__c == 0){
                    saijoShisetsuWrapperTemp.saijo.ShokaiKa__c = false;
                }
                saijoShisetsuWrapperTemp.tokuyakutenFlg = saijoShisetsuWrapperTemp.saijo.HoyuShutaiSogishaJiinRef__r.TokuyakutenFlg__c;
                saijoShisetsuWrapperTemp.resultIndex = saijoIndex;
                saijoShisetsuWrapperList.add(saijoShisetsuWrapperTemp);

                if(saijoShisetsuWrapperList.size() >= 100) break;
            }
        }
    }

    private void sortKyoriSaijoList(List<SaijoWrapper> saijoShisetsuWrapperTempList){
        Integer saijoIndex = 0;
        Map<ID, SaijoWrapper> saijoShisetsuMap = new Map<ID, SaijoWrapper>();
        for(SaijoWrapper saijoShisetsuWrapperTemp : saijoShisetsuWrapperTempList){

            System.debug('saijoShisetsuWrapperTemp:' + saijoShisetsuWrapperTemp);
            saijoIndex++;
            saijoShisetsuWrapperTemp.resultIndex = saijoIndex;

            if(saijoShisetsuWrapperTemp.saijo.HoyuShutaiSogishaJiinRef__c != null && saijoShisetsuWrapperTemp.saijo.HoyuShutaiSogishaJiinRef__r.SimpleYasugoKeiyakuKensu__c == 0){
                saijoShisetsuWrapperTemp.saijo.ShokaiKa__c = false;
            }
            saijoShisetsuWrapperTemp.tokuyakutenFlg = saijoShisetsuWrapperTemp.saijo.HoyuShutaiSogishaJiinRef__r.TokuyakutenFlg__c;

            if(saijoShisetsuWrapperTemp.saijo.ShisetsuKubun__c == '自社' && saijoShisetsuWrapperTemp.saijo.ShikugunRef__c == sltShikugun.Id){
                for(FuneralCompanyWrapper item : listFuneralCompanyWrapper){
                    if(item.keiyaku.Teikeisaki__c == saijoShisetsuWrapperTemp.saijo.HoyuShutaiSogishaJiinRef__c){
                        System.debug('b1 : ' + saijoShisetsuWrapperTemp.saijo.Id + ' ' + saijoShisetsuWrapperTemp.saijo.Name);
                        
                        saijoShisetsuWrapperTemp.sokyakuTeishi = item.sokyakuTeishi;
                        saijoShisetsuWrapperTemp.toraiaruFlg = item.toraiaruFlg;
                        break;
                    }
                }
            }
            else if(!saijoShisetsuMap.containsKey(saijoShisetsuWrapperTemp.saijo.Id) && saijoShisetsuWrapperTemp.saijo.ShisetsuKubun__c == '自社'){
                for(FuneralCompanyWrapper item : listFuneralCompanyWrapper){
                    if(item.keiyaku.Teikeisaki__c == saijoShisetsuWrapperTemp.saijo.HoyuShutaiSogishaJiinRef__c){
                        System.debug('b2 : ' + saijoShisetsuWrapperTemp.saijo.Id + ' ' + saijoShisetsuWrapperTemp.saijo.Name);

                        saijoShisetsuWrapperTemp.sokyakuTeishi = item.sokyakuTeishi;
                        saijoShisetsuWrapperTemp.toraiaruFlg = item.toraiaruFlg;
                        break;
                    }
                }
            }
            else if(!saijoShisetsuMap.containsKey(saijoShisetsuWrapperTemp.saijo.Id) && 
                saijoShisetsuWrapperTemp.saijo.HoyuShutaiSogishaJiinRef__c != null && 
                saijoShisetsuWrapperTemp.saijo.ShisetsuKubun__c == '自社' && 
                (saijoShisetsuWrapperTemp.saijo.ShikugunRef__c == sltShikugun.Id || saijoShisetsuWrapperTemp.saijo.ShiminRyokinTaishoGyoseiKubunKojinRef__c == sltShikugun.Id)){
                System.debug('b5 : ' + saijoShisetsuWrapperTemp.saijo.Id + ' ' + saijoShisetsuWrapperTemp.saijo.Name);

                saijoShisetsuWrapperTemp.sogishaListNashi = true;
            }
            else if(!saijoShisetsuMap.containsKey(saijoShisetsuWrapperTemp.saijo.Id) && 
                saijoShisetsuWrapperTemp.saijo.HoyuShutaiSogishaJiinRef__c != null && 
                saijoShisetsuWrapperTemp.saijo.ShisetsuKubun__c == '自社'){
                System.debug('b6 : ' + saijoShisetsuWrapperTemp.saijo.Id + ' ' + saijoShisetsuWrapperTemp.saijo.Name);

                saijoShisetsuWrapperTemp.sogishaListNashi = true;
            }


            saijoShisetsuWrapperList.add(saijoShisetsuWrapperTemp);

            if(saijoShisetsuWrapperList.size() >= 100) break;
        }
    }

    public List<SogiShiryoSofuWrap> sogiShiryoSofuWrapList {get;set;}
    public class SogiShiryoSofuWrap {
        public Boolean sltFlg {get;set;}
        public SogiShiryoSofu__c sogiShiryoSofu {get;set;}
        public String atesakiCustom {get;set;}

        public SogiShiryoSofuWrap(){
            sltFlg = false;
            sogiShiryoSofu = new SogiShiryoSofu__c();
            atesakiCustom = '';
        }
    }

    public void sogiShiryoSofuSetting(){
        saveResultMsg = '';
        errFlg = false;
        shiryoSofuId = '';
        referShiryoSofu = new SogiShiryoSofu__c();

        sogiShiryoSofuWrapList = new List<SogiShiryoSofuWrap>();
        for(SogiShiryoSofu__c initSogiShiryoSofu : [select Id, 
                                                            Name, 
                                                            Fax__c, 
                                                            PamphletYohi__c, 
                                                            Mail__c, 
                                                            Atena__c, 
                                                            SofuNichiji__c, 
                                                            InsatsubutsuIchiran__c, 
                                                            City__c, 
                                                            OpportunityRef__c, 
                                                            SofuShubetsu__c, 
                                                            SofuJokyo__c, 
                                                            Street__c, 
                                                            State__c, 
                                                            YusoShubetsu__c, 
                                                            PostalCode__c, 
                                                            HosokuSetsumei__c, 
                                                            CreatedBy.LastName, 
                                                            CreatedDate 
                                                    from SogiShiryoSofu__c 
                                                    where OpportunityRef__c = :oppId 
                                                    order by CreatedDate desc]){
            SogiShiryoSofuWrap initSogiShiryoSofuWrap = new SogiShiryoSofuWrap();
            initSogiShiryoSofuWrap.sogiShiryoSofu = initSogiShiryoSofu;
            if(initSogiShiryoSofu.SofuShubetsu__c == '郵便') initSogiShiryoSofuWrap.atesakiCustom = initSogiShiryoSofu.PostalCode__c + ' ' + initSogiShiryoSofu.State__c + ' ' + initSogiShiryoSofu.City__c + ' ' + initSogiShiryoSofu.Street__c;
            if(initSogiShiryoSofu.SofuShubetsu__c == 'メール') initSogiShiryoSofuWrap.atesakiCustom = initSogiShiryoSofu.Mail__c;
            if(initSogiShiryoSofu.SofuShubetsu__c == 'FAX') initSogiShiryoSofuWrap.atesakiCustom = initSogiShiryoSofu.Fax__c;
            sogiShiryoSofuWrapList.add(initSogiShiryoSofuWrap);
        }
    }

    public void addKasobaTeianKohoManualList(){
        saveResultMsg = '';
        errFlg = false;

        List<ShisetsuTeianWrap> tempList = new List<ShisetsuTeianWrap>();
        for(ShisetsuTeianWrap temp : kasobaTeianKohoManualList){
            if(temp.shisetsuId != '') {
                tempList.add(temp);
            }
        }
        
        for(ShisetuWrapper kasobaShisetsuWrapper : kasobaShisetsuWrapperList){
            if(kasobaShisetsuWrapper.teianListFlg){
                
                Boolean addFlg = true;
                for(ShisetsuTeianWrap chkKasobaTeianKohoManual : kasobaTeianKohoManualList){
                    if(chkKasobaTeianKohoManual.shisetsuId == String.valueOf(kasobaShisetsuWrapper.shisetu.Id)) {
                        addFlg = false;
                        break;
                    }
                }
                
                if(addFlg){
                    ShisetsuTeianWrap addKasobaTeianKohoManual = new ShisetsuTeianWrap();
                    addKasobaTeianKohoManual.shisetsuId = kasobaShisetsuWrapper.shisetu.Id;
                    addKasobaTeianKohoManual.shisetsuName = kasobaShisetsuWrapper.shisetu.Name;
                    tempList.add(addKasobaTeianKohoManual);
                }
            }
        }

        kasobaTeianKohoManualList.clear();
        kasobaTeianKohoManualList.addAll(tempList); 

        kasobaTeianDefaultMaxLimit(kasobaTeianKohoManualList);
    }

    public void addSaijoTeianKohoManualList(){
        saveResultMsg = '';
        errFlg = false;

        List<ShisetsuTeianWrap> tempList = new List<ShisetsuTeianWrap>();
        for(ShisetsuTeianWrap temp : saijoTeianKohoManualList){
            if(temp.shisetsuId != '') {
                tempList.add(temp);
            }
        }

        for(SaijoWrapper saijoShisetsuWrapper : saijoShisetsuWrapperList){
            
            if(saijoShisetsuWrapper.teianListFlg){
                
                Boolean addFlg = true;
                for(ShisetsuTeianWrap chkSaijoTeianKohoManual : saijoTeianKohoManualList){
                    if(chkSaijoTeianKohoManual.shisetsuId == String.valueOf(saijoShisetsuWrapper.saijo.Id)) {
                        addFlg = false;
                        break;
                    }
                }

                if(addFlg){
                    ShisetsuTeianWrap addSaijoTeianKohoManual = new ShisetsuTeianWrap();
                    addSaijoTeianKohoManual.shisetsuId = saijoShisetsuWrapper.saijo.Id;
                    addSaijoTeianKohoManual.shisetsuName = saijoShisetsuWrapper.saijo.Name;
                    tempList.add(addSaijoTeianKohoManual);
                }
            }
        }
        
        saijoTeianKohoManualList.clear();
        saijoTeianKohoManualList.addAll(tempList); 

        saijoTeianDefaultMaxLimit(saijoTeianKohoManualList);
    }

    public void addKasobaTeianFixList(){
        saveResultMsg = '';
        errFlg = false;

        List<ShisetsuTeianWrap> tempList = new List<ShisetsuTeianWrap>();
        for(ShisetsuTeianWrap temp : kasobaTeianFixList){
            if(temp.shisetsuId != '') {
                tempList.add(temp);
            }
        }

        for(ShisetsuTeianWrap kasobaTeianKohoManual : kasobaTeianKohoManualList){
            if(kasobaTeianKohoManual.teianListFlg){
                Boolean addFlg = true;
                for(ShisetsuTeianWrap chkKasobaTeianFix : kasobaTeianFixList){
                    if(chkKasobaTeianFix.shisetsuId == kasobaTeianKohoManual.shisetsuId) {
                        addFlg = false;
                        break;
                    }
                }

                if(addFlg){
                    ShisetsuTeianWrap addKasobaTeianFix = new ShisetsuTeianWrap();
                    addKasobaTeianFix.shisetsuId = kasobaTeianKohoManual.shisetsuId;
                    addKasobaTeianFix.shisetsuName = kasobaTeianKohoManual.shisetsuName;
                    tempList.add(addKasobaTeianFix);
                }
            }
        }

        kasobaTeianFixList.clear();
        kasobaTeianFixList.addAll(tempList); 
        kasobaTeianDefaultMaxLimit(kasobaTeianFixList);
    }

    public void delKasobaTeianFixList(){
        saveResultMsg = '';
        errFlg = false;

        List<ShisetsuTeianWrap> tempKasobaTeianManualList = new List<ShisetsuTeianWrap>();
        for(ShisetsuTeianWrap chkKasobaTeianKohoManual : kasobaTeianKohoManualList){
            if(chkKasobaTeianKohoManual.shisetsuId != '') {
                tempKasobaTeianManualList.add(chkKasobaTeianKohoManual);
            }
        }

        List<ShisetsuTeianWrap> tempList = new List<ShisetsuTeianWrap>();
        for(ShisetsuTeianWrap temp : kasobaTeianFixList){
            if(!temp.teianListFlg) {
                tempList.add(temp);
            }
            else{
                Boolean addFlg = true;
                for(ShisetsuTeianWrap chkKasobaTeianKohoManual : kasobaTeianKohoManualList){
                    if(chkKasobaTeianKohoManual.shisetsuId == temp.shisetsuId) {
                        addFlg = false;
                        break;
                    }
                }

                if(addFlg){
                    ShisetsuTeianWrap addKasobaTeianFix = new ShisetsuTeianWrap();
                    addKasobaTeianFix.shisetsuId = temp.shisetsuId;
                    addKasobaTeianFix.shisetsuName = temp.shisetsuName;
                    tempKasobaTeianManualList.add(addKasobaTeianFix);
                }
            }
        }

        kasobaTeianFixList.clear();
        kasobaTeianFixList.addAll(tempList); 
        kasobaTeianDefaultMaxLimit(kasobaTeianFixList);

        kasobaTeianKohoManualList.clear();
        kasobaTeianKohoManualList.addAll(tempKasobaTeianManualList); 
        kasobaTeianDefaultMaxLimit(kasobaTeianKohoManualList);
    }

    public void addSaijoTeianFixList(){
        saveResultMsg = '';
        errFlg = false;

        List<ShisetsuTeianWrap> tempList = new List<ShisetsuTeianWrap>();
        for(ShisetsuTeianWrap temp : saijoTeianFixList){
            if(temp.shisetsuId != '') {
                tempList.add(temp);
            }
        }

        for(ShisetsuTeianWrap saijoTeianKohoManual : saijoTeianKohoManualList){
            if(saijoTeianKohoManual.teianListFlg){
                Boolean addFlg = true;
                for(ShisetsuTeianWrap chkSaijoTeianFix : saijoTeianFixList){
                    if(chkSaijoTeianFix.shisetsuId == saijoTeianKohoManual.shisetsuId) {
                        addFlg = false;
                        break;
                    }
                }

                if(addFlg){
                    ShisetsuTeianWrap addSaijoTeianFix = new ShisetsuTeianWrap();
                    addSaijoTeianFix.shisetsuId = saijoTeianKohoManual.shisetsuId;
                    addSaijoTeianFix.shisetsuName = saijoTeianKohoManual.shisetsuName;
                    tempList.add(addSaijoTeianFix);
                }
            }
        }

        saijoTeianFixList.clear();
        saijoTeianFixList.addAll(tempList); 
        saijoTeianDefaultMaxLimit(saijoTeianFixList);
    }

    public void delSaijoTeianFixList(){
        saveResultMsg = '';
        errFlg = false;

        List<ShisetsuTeianWrap> tempSaijoTeianManualList = new List<ShisetsuTeianWrap>();
        for(ShisetsuTeianWrap chkSaijoTeianKohoManual : saijoTeianKohoManualList){
            if(chkSaijoTeianKohoManual.shisetsuId != '') {
                tempSaijoTeianManualList.add(chkSaijoTeianKohoManual);
            }
        }

        List<ShisetsuTeianWrap> tempList = new List<ShisetsuTeianWrap>();
        for(ShisetsuTeianWrap temp : saijoTeianFixList){
            if(!temp.teianListFlg) {
                tempList.add(temp);
            }
            else{
                Boolean addFlg = true;
                for(ShisetsuTeianWrap chkSaijoTeianKohoManual : saijoTeianKohoManualList){
                    if(chkSaijoTeianKohoManual.shisetsuId == temp.shisetsuId) {
                        addFlg = false;
                        break;
                    }
                }

                if(addFlg){
                    ShisetsuTeianWrap addSaijoTeianFix = new ShisetsuTeianWrap();
                    addSaijoTeianFix.shisetsuId = temp.shisetsuId;
                    addSaijoTeianFix.shisetsuName = temp.shisetsuName;
                    tempSaijoTeianManualList.add(addSaijoTeianFix);
                }
            }
        }

        saijoTeianFixList.clear();
        saijoTeianFixList.addAll(tempList); 
        saijoTeianDefaultMaxLimit(saijoTeianFixList);

        saijoTeianKohoManualList.clear();
        saijoTeianKohoManualList.addAll(tempSaijoTeianManualList); 
        saijoTeianDefaultMaxLimit(saijoTeianKohoManualList);
    }

    public void addKasobaTeianStandardToFixList(){
        saveResultMsg = '';
        errFlg = false;

        List<ShisetsuTeianWrap> tempList = new List<ShisetsuTeianWrap>();
        for(ShisetsuTeianWrap temp : kasobaTeianFixList){
            if(temp.shisetsuId != '') {
                tempList.add(temp);
            }
        }

        for(ShisetsuTeianWrap kasobaTeianKohoManual : kasobaTeianKohoAutoList){
            
            if(kasobaTeianKohoManual.teianListFlg){
                
                Boolean addFlg = true;
                for(ShisetsuTeianWrap chkKasobaTeianFix : kasobaTeianFixList){
                    if(chkKasobaTeianFix.shisetsuId == kasobaTeianKohoManual.shisetsuId) {
                        addFlg = false;
                        break;
                    }
                }

                if(addFlg){
                    ShisetsuTeianWrap addKasobaTeianFix = new ShisetsuTeianWrap();
                    addKasobaTeianFix.shisetsuId = kasobaTeianKohoManual.shisetsuId;
                    addKasobaTeianFix.shisetsuName = kasobaTeianKohoManual.shisetsuName;
                    tempList.add(addKasobaTeianFix);
                }
            }
        }

        kasobaTeianFixList.clear();
        kasobaTeianFixList.addAll(tempList); 

        kasobaTeianDefaultMaxLimit(kasobaTeianFixList);
    }

    public void addSaijoTeianStandardToFixList(){
        saveResultMsg = '';
        errFlg = false;

        List<ShisetsuTeianWrap> tempList = new List<ShisetsuTeianWrap>();
        for(ShisetsuTeianWrap temp : saijoTeianFixList){
            if(temp.shisetsuId != '') {
                tempList.add(temp);
            }
        }

        for(ShisetsuTeianWrap kasobaTeianKohoManual : saijoTeianKohoAutoList){
            
            if(kasobaTeianKohoManual.teianListFlg){
                
                Boolean addFlg = true;
                for(ShisetsuTeianWrap chkKasobaTeianFix : saijoTeianFixList){
                    if(chkKasobaTeianFix.shisetsuId == kasobaTeianKohoManual.shisetsuId) {
                        addFlg = false;
                        break;
                    }
                }

                if(addFlg){
                    ShisetsuTeianWrap addKasobaTeianFix = new ShisetsuTeianWrap();
                    addKasobaTeianFix.shisetsuId = kasobaTeianKohoManual.shisetsuId;
                    addKasobaTeianFix.shisetsuName = kasobaTeianKohoManual.shisetsuName;
                    tempList.add(addKasobaTeianFix);
                }
            }
        }

        saijoTeianFixList.clear();
        saijoTeianFixList.addAll(tempList); 

        saijoTeianDefaultMaxLimit(saijoTeianFixList);
    }

    public String shiryoSofuId {get;set;}
    public SogiShiryoSofu__c referShiryoSofu {get;set;}
    public void referShiryoSofu(){
        saveResultMsg = '';
        errFlg = false;

        shiryoSofuId = Apexpages.currentPage().getParameters().get('pShiryoSofuId');

        referShiryoSofu = [select Id, 
                                    Name, 
                                    Fax__c, 
                                    PamphletYohi__c, 
                                    Mail__c, 
                                    Atena__c, 
                                    SofuNichiji__c, 
                                    InsatsubutsuIchiran__c, 
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
                                    HikitsugiJiko__c, 
                                    TaSofubutsu1__c, 
                                    TaSofubutsu2__c, 
                                    TaSofubutsu3__c, 
                                    CreatedBy.LastName, 
                                    CreatedDate, 
                                    (
                                        select Id, 
                                                SaijoRef__c,
                                                SaijoRef__r.Name, 
                                                ShisetsuRef__c, 
                                                ShisetsuRef__r.Name, 
                                                ShisetsuKubun__c, 
                                                SogiShiryoSofuRef__c, 
                                                Hyojijun__c 
                                        from SogiShiryoSofuMeisais__r 
                                        order by Hyojijun__c 
                                    ) 
                                from SogiShiryoSofu__c 
                                where Id = :shiryoSofuId];

        kasobaTeianFixList = new List<ShisetsuTeianWrap>();
        saijoTeianFixList = new List<ShisetsuTeianWrap>();
        for(SogiShiryoSofuMeisai__c sltSogiShiryoSofuMeisai : referShiryoSofu.SogiShiryoSofuMeisais__r){
            
            if(sltSogiShiryoSofuMeisai.ShisetsuKubun__c == '火葬場') {
                ShisetsuTeianWrap addKasobaTeianFix = new ShisetsuTeianWrap();
                addKasobaTeianFix.shisetsuId = sltSogiShiryoSofuMeisai.ShisetsuRef__c;
                addKasobaTeianFix.shisetsuName = sltSogiShiryoSofuMeisai.ShisetsuRef__r.Name;
                kasobaTeianFixList.add(addKasobaTeianFix);
            }
            if(sltSogiShiryoSofuMeisai.ShisetsuKubun__c == '斎場') {
                ShisetsuTeianWrap addSaijoTeianFix = new ShisetsuTeianWrap();
                addSaijoTeianFix.shisetsuId = sltSogiShiryoSofuMeisai.SaijoRef__c;
                addSaijoTeianFix.shisetsuName = sltSogiShiryoSofuMeisai.SaijoRef__r.Name;
                saijoTeianFixList.add(addSaijoTeianFix);
            }
        }

        kasobaTeianDefaultMaxLimit(kasobaTeianFixList);
        saijoTeianDefaultMaxLimit(saijoTeianFixList);
    }

    private void kasobaTeianDefaultMaxLimit(List<ShisetsuTeianWrap> targetList){
        for(Integer i = targetList.size(); i < 2; i++){
            targetList.add(new ShisetsuTeianWrap());
        }
    }

    private void saijoTeianDefaultMaxLimit(List<ShisetsuTeianWrap> targetList){
        for(Integer i = targetList.size(); i < 20; i++){
            targetList.add(new ShisetsuTeianWrap());
        }
    }

    public String saveResultMsg {get;set;}
    public Boolean errFlg {get;set;}
    public void saveShiryoSofuMeisai(){
        saveResultMsg = '';
        errFlg = false;

        if(shiryoSofuId == '') return;

        Savepoint sp = Database.setSavepoint();
        try{

            delete [select Id from SogiShiryoSofuMeisai__c where SogiShiryoSofuRef__c = :shiryoSofuId];

            List<SogiShiryoSofuMeisai__c> insSogiShiryoSofuMeisaiList = new List<SogiShiryoSofuMeisai__c>();

            Integer indexKasobaTeian = 0;
            for(ShisetsuTeianWrap kasobaTeianFix : kasobaTeianFixList){

                if(kasobaTeianFix.shisetsuId == '') continue;

                indexKasobaTeian++;
                SogiShiryoSofuMeisai__c tempSogiShiryoSofuMeisai = new SogiShiryoSofuMeisai__c();
                tempSogiShiryoSofuMeisai.SogiShiryoSofuRef__c = shiryoSofuId;
                tempSogiShiryoSofuMeisai.ShisetsuRef__c = kasobaTeianFix.shisetsuId;
                tempSogiShiryoSofuMeisai.Hyojijun__c = indexKasobaTeian;
                tempSogiShiryoSofuMeisai.ShisetsuKubun__c = '火葬場';
                tempSogiShiryoSofuMeisai.Name = shiryoSofuId + '_' + '火葬場' + '_' + kasobaTeianFix.shisetsuName;
                insSogiShiryoSofuMeisaiList.add(tempSogiShiryoSofuMeisai);
            }

            Integer indexSaijoTeian = 0;
            for(ShisetsuTeianWrap saijoTeianFix : saijoTeianFixList){

                if(saijoTeianFix.shisetsuId == '') continue;

                indexSaijoTeian++;
                SogiShiryoSofuMeisai__c tempSogiShiryoSofuMeisai = new SogiShiryoSofuMeisai__c();
                tempSogiShiryoSofuMeisai.SogiShiryoSofuRef__c = shiryoSofuId;
                tempSogiShiryoSofuMeisai.SaijoRef__c = saijoTeianFix.shisetsuId;
                tempSogiShiryoSofuMeisai.Hyojijun__c = indexSaijoTeian;
                tempSogiShiryoSofuMeisai.ShisetsuKubun__c = '斎場';
                tempSogiShiryoSofuMeisai.Name = shiryoSofuId + '_' + '斎場' + '_' + saijoTeianFix.shisetsuName;
                insSogiShiryoSofuMeisaiList.add(tempSogiShiryoSofuMeisai);
            }

            insert insSogiShiryoSofuMeisaiList;
            
            saveResultMsg = '保存しました';
            errFlg = false;
        }
        catch(Exception e){
            Database.rollback(sp);

            saveResultMsg = 'エラーが発生しました。' + e.getMessage();
            errFlg = true;
        }
    }

    public String standardTeianMessage {get;set;}
    public void getShisetsuTeianStandardList(){
        saveResultMsg = '';
        errFlg = false;
        standardTeianMessage = '';
        
        if(sltShikugun == null) {
            standardTeianMessage = '検索条件を設定して検索を行ってください';
            return;
        }
        
        kasobaTeianKohoAutoList = new List<ShisetsuTeianWrap>();
        saijoTeianKohoAutoList = new List<ShisetsuTeianWrap>();
        
        ShiryoSofuTeianShisetsu.TeianShisetsuListWrap standardTeianListWrap = ShiryoSofuTeianShisetsu.getShiryoSofuTeianShisetsu(sltShikugun.Id);
        standardTeianMessage = standardTeianListWrap.message;

        for(ShiryoSofuTeianShisetsu.TeianShisetsuWrap standardKasoba : standardTeianListWrap.standardKasobaList){
            ShisetsuTeianWrap shisetsuTeianWrap = new ShisetsuTeianWrap();
            shisetsuTeianWrap.shisetsuId = standardKasoba.shisetsuId;
            shisetsuTeianWrap.shisetsuName = standardKasoba.shisetsuName;
            shisetsuTeianWrap.shisetsuKubun = standardKasoba.shisetsuKubun;
            kasobaTeianKohoAutoList.add(shisetsuTeianWrap);
        }

        for(Integer i=2; i<kasobaTeianKohoAutoList.size(); i++){
            ShisetsuTeianWrap chkSaijoTeianFix = kasobaTeianKohoAutoList.get(i);
            if(chkSaijoTeianFix.shisetsuId == '') {
                kasobaTeianKohoAutoList.remove(i);
                i--;
            }
        }

        for(ShiryoSofuTeianShisetsu.TeianShisetsuWrap standardSaijo : standardTeianListWrap.standardSaijoList){
            ShisetsuTeianWrap shisetsuTeianWrap = new ShisetsuTeianWrap();
            shisetsuTeianWrap.shisetsuId = standardSaijo.shisetsuId;
            shisetsuTeianWrap.shisetsuName = standardSaijo.shisetsuName;
            shisetsuTeianWrap.shisetsuKubun = standardSaijo.shisetsuKubun;
            saijoTeianKohoAutoList.add(shisetsuTeianWrap);
        }

        for(Integer i=10; i<saijoTeianKohoAutoList.size(); i++){
            ShisetsuTeianWrap chkSaijoTeianFix = saijoTeianKohoAutoList.get(i);
            if(chkSaijoTeianFix.shisetsuId == '') {
                saijoTeianKohoAutoList.remove(i);
                i--;
            }
        }
    }

    public void getShisetsuTeianStandardListTrial(){
        saveResultMsg = '';
        errFlg = false;
        standardTeianMessage = '';
        
        if(sltShikugun == null) {
            standardTeianMessage = '検索条件を設定して検索を行ってください';
            return;
        }
        
        kasobaTeianKohoAutoList = new List<ShisetsuTeianWrap>();
        saijoTeianKohoAutoList = new List<ShisetsuTeianWrap>();
        
        ShiryoSofuTeianShisetsuTrial.TeianShisetsuListWrap standardTeianListWrap = new ShiryoSofuTeianShisetsuTrial().getShiryoSofuTeianShisetsu(sltShikugun.Id);
        standardTeianMessage = standardTeianListWrap.message;

        for(ShiryoSofuTeianShisetsuTrial.TeianShisetsuWrap standardKasoba : standardTeianListWrap.standardKasobaList){
            ShisetsuTeianWrap shisetsuTeianWrap = new ShisetsuTeianWrap();
            shisetsuTeianWrap.shisetsuId = standardKasoba.shisetsuId;
            shisetsuTeianWrap.shisetsuName = standardKasoba.shisetsuName;
            shisetsuTeianWrap.shisetsuKubun = standardKasoba.shisetsuKubun;
            kasobaTeianKohoAutoList.add(shisetsuTeianWrap);
        }

        for(Integer i=2; i<kasobaTeianKohoAutoList.size(); i++){
            ShisetsuTeianWrap chkSaijoTeianFix = kasobaTeianKohoAutoList.get(i);
            if(chkSaijoTeianFix.shisetsuId == '') {
                kasobaTeianKohoAutoList.remove(i);
                i--;
            }
        }

        for(ShiryoSofuTeianShisetsuTrial.TeianShisetsuWrap standardSaijo : standardTeianListWrap.standardSaijoList){
            ShisetsuTeianWrap shisetsuTeianWrap = new ShisetsuTeianWrap();
            shisetsuTeianWrap.shisetsuId = standardSaijo.shisetsuId;
            shisetsuTeianWrap.shisetsuName = standardSaijo.shisetsuName;
            shisetsuTeianWrap.shisetsuKubun = standardSaijo.shisetsuKubun;
            saijoTeianKohoAutoList.add(shisetsuTeianWrap);
        }

        for(Integer i=10; i<saijoTeianKohoAutoList.size(); i++){
            ShisetsuTeianWrap chkSaijoTeianFix = saijoTeianKohoAutoList.get(i);
            if(chkSaijoTeianFix.shisetsuId == '') {
                saijoTeianKohoAutoList.remove(i);
                i--;
            }
        }
    }

    public void createShiryoSofu(){
        saveResultMsg = '';
        errFlg = false;

        SogiTeianshoIkkatsuSakuseiJoken__c insertJoken = new SogiTeianshoIkkatsuSakuseiJoken__c();
        insertJoken.ShikijoMeisaiHyokiName__c = '式場追加料金（プラン内式場料金超過分）';
        insertJoken.KasobaMeisaiHyokiName__c = '火葬料金（非課税）';
        insert insertJoken;

        List<String> insatsubutsuIchiranList = new List<String>{'送付状','斎場資料'};
        if(kaiinAnnai == 'true') insatsubutsuIchiranList.add('会員案内');

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

    public void upKasobaTeianFixList(){
        saveResultMsg = '';
        errFlg = false;

        for(Integer i=0; i<kasobaTeianFixList.size()-1; i++){
            ShisetsuTeianWrap temp1 = kasobaTeianFixList.get(i);
            ShisetsuTeianWrap temp2 = kasobaTeianFixList.get(i+1);
            if(!temp1.teianListFlg && temp2.teianListFlg) {
                kasobaTeianFixList.set(i, temp2);
                kasobaTeianFixList.set(i+1, temp1);
            }
            else{
                kasobaTeianFixList.set(i, temp1);
                kasobaTeianFixList.set(i+1, temp2);
            }
        }
    }

    public void downKasobaTeianFixList(){
        saveResultMsg = '';
        errFlg = false;

        for(Integer i=kasobaTeianFixList.size()-1; i>0; i--){
            ShisetsuTeianWrap temp1 = kasobaTeianFixList.get(i);
            ShisetsuTeianWrap temp2 = kasobaTeianFixList.get(i-1);

            if(temp1.shisetsuId == '') continue;

            if(!temp1.teianListFlg && temp2.teianListFlg) {
                kasobaTeianFixList.set(i, temp2);
                kasobaTeianFixList.set(i-1, temp1);
            }
            else{
                kasobaTeianFixList.set(i, temp1);
                kasobaTeianFixList.set(i-1, temp2);
            }
        }
    }

    public void upSaijoTeianFixList(){
        saveResultMsg = '';
        errFlg = false;

        for(Integer i=0; i<saijoTeianFixList.size()-1; i++){
            ShisetsuTeianWrap temp1 = saijoTeianFixList.get(i);
            ShisetsuTeianWrap temp2 = saijoTeianFixList.get(i+1);

            if(temp2.shisetsuId == '') break;

            if(!temp1.teianListFlg && temp2.teianListFlg) {
                saijoTeianFixList.set(i, temp2);
                saijoTeianFixList.set(i+1, temp1);
            }
            else{
                saijoTeianFixList.set(i, temp1);
                saijoTeianFixList.set(i+1, temp2);
            }
        }
    }

    public void downSaijoTeianFixList(){
        saveResultMsg = '';
        errFlg = false;

        for(Integer i=saijoTeianFixList.size()-1; i>0; i--){
            ShisetsuTeianWrap temp1 = saijoTeianFixList.get(i);
            ShisetsuTeianWrap temp2 = saijoTeianFixList.get(i-1);

            if(temp1.shisetsuId == '') continue;

            if(!temp1.teianListFlg && temp2.teianListFlg) {
                saijoTeianFixList.set(i, temp2);
                saijoTeianFixList.set(i-1, temp1);
            }
            else{
                saijoTeianFixList.set(i, temp1);
                saijoTeianFixList.set(i-1, temp2);
            }
        }
    }

    public void searchHyojunTeianSaijo(){
        ShiryoSofuTeianShisetsuTrial.TeianShisetsuListWrap standardTeianListWrap = new ShiryoSofuTeianShisetsuTrial().getShiryoSofuTeianShisetsu(sltShikugun.Id);

        List<String> saijoIdList = new List<String>();
        for(ShiryoSofuTeianShisetsuTrial.TeianShisetsuWrap standardSaijo : standardTeianListWrap.standardSaijoList){ saijoIdList.add(standardSaijo.shisetsuId); }

        String searchSaijoSoql = 'SELECT Id, ' + 
                                    'Name, ' + 
                                    'KeisaiSaijoMeiKana__c, ' + 
                                    'SeishikiSaijoMei__c, ' + 
                                    'SeishikiSaijoMeiKana__c, ' + 
                                    'JushoKana__c, ' + 
                                    'Tel1__c, ' + 
                                    'Jusho__c, ' + 
                                    'HoyuShutaiSogishaJiinRef__c, ' + 
                                    'HoyuShutaiSogishaJiinRef__r.TokuyakutenFlg__c, ' + 
                                    'HoyuShutaiSogishaJiinRef__r.SimpleYasugoKeiyakuKensu__c, ' + 
                                    'HoyuShutaiText__c, ' + 
                                    'ShikugunRef__c, ' + 
                                    'IdoKedo__latitude__s, ' + 
                                    'IdoKedo__longitude__s, ' + 
                                    'OkyakusamaMukeChuiten__c, ' + 
                                    'ShisetsuKubun__c, ' + 
                                    'KasobaHeisetsuList__c, ' + 
                                    'IdoKedo__c, ' + 
                                    'DISTANCE(IdoKedo__c, GEOLOCATION(:latitudeIn,:longitudeIn), \'km\') dist, ' + 
                                    'HP_URL__c, ' + 
                                    'ShokaiKa__c, ' + 
                                    'UrlOfSaijoPrint__c, ' + 
                                    'ChuiJiko__c, ' + 
                                    'AccessHouhouDensha__c, ' + 
                                    'SogishaRiyoSeigen__c, ' + 
                                    'SogishaRiyoSeigenShosai__c, ' + 
                                    'TaioShuha__c, ' + 
                                    'TaioShuhaBiko__c, ' + 
                                    'ShiminRyokinKubun__c, ' + 
                                    'ShiminRyokinTaishoGyoseiKubunKojinRef__c, ' + 
                                    'ShiminRyokinTaishoGyoseiKubunMoshuRef__c, ' + 
                                    'AnchiShisetsu__c, ' + 
                                    'AnchiKikanMenkaiKahi__c, ' + 
                                    'KaminShisetsuUmuAnchiKikanchu__c, ' + 
                                    'KaminShisetsuJokentsukiBikoAnchi__c, ' + 
                                    'ModoriShonanokaKahi__c, ' + 
                                    'ModorishonanokaJokentsukiBiko__c, ' + 
                                    'ChushaDaisu__c, ' + 
                                    'ShokujinoKahi__c, ' + 
                                    'ShikijoKengakuKahi__c, ' + 
                                    'ZeiKubun__c, ' + 
                                    'HallSu__c, ' + 
                                    'KidsRoomList__c, ' + 
                                    'JunyushitsuList__c, ' + 
                                    'OmutsuKokandaiList__c, ' + 
                                    'KurumaisuKashidashiList__c, ' + 
                                    'SuishoSaijo__c, ' + 
                                    'SuishoRiyu__c, ' + 
                                    'Nickname__c, ' + 
                                    '(' + 
                                        'SELECT Id, ' + 
                                                'Name, ' + 
                                                'Sekisu__c, ' + 
                                                'JogenKaisoshasu__c, ' + 
                                                'ShikijonoYokohabaShaku__c, ' + 
                                                'TaioShikishubetsu__c, ' + 
                                                'X1ShiyoRyokinIppan__c, ' + 
                                                'X1ShiyoRyokinShimin__c, ' + 
                                                'X1ShiyoRyokinSonota__c, ' + 
                                                'X2ShiyoRyokinIppan__c, ' + 
                                                'X2ShiyoRyokinShimin__c, ' + 
                                                'X2ShiyoRyokinSonota__c, ' + 
                                                'ShiyoRyokinBiko__c ' + 
                                        'FROM SaijoShikijos__r ' + 
                                        'WHERE Id != null ' + 
                                        'ORDER BY Sekisu__c, X2ShiyoRyokinIppan__c, X2ShiyoRyokinShimin__c ' + 
                                    ') ' + 
                                    'FROM Saijo__c ' + 
                                    'WHERE Id =: saijoIdList';
        System.debug('searchSaijoSoql:' + searchSaijoSoql);
        Map <Id, Saijo__c> resultSaijoMap = new Map<Id, Saijo__c>( (List<Saijo__c>)Database.query(searchSaijoSoql) );

        Integer saijoIndex = 0;
        List<SaijoWrapper> saijoShisetsuWrapperTempList = new List<SaijoWrapper>();
        saijoShisetsuWrapperList = new List<SaijoWrapper>();

        saijoKensu = resultSaijoMap.size();
        Decimal gensan = 0;
        if(planRyokinGensanValue == '一日葬'){
            gensan = 25000;
        }
        else if(planRyokinGensanValue == '家族葬'){
            gensan = 50000;
        }
        else if(planRyokinGensanValue == '一般葬'){
            gensan = 70000;
        }

        for(String saijoId : saijoIdList){
            Saijo__c resultSaijo = resultSaijoMap.get(saijoId);
            saijoIndex++;
            SaijoWrapper temp = new SaijoWrapper(saijoIndex, resultSaijo, gensan);
            if(resultSaijo.get('dist') != null){
                Decimal distanceValue = Decimal.valueOf(String.valueOf(resultSaijo.get('dist')));
                temp.distance = String.valueOf(distanceValue.setScale(1)) + 'km';
            }

            saijoShisetsuWrapperTempList.add(temp);

            if(saijoShisetsuWrapperTempList.size() > 100) break;
        }

        sortKyoriSaijoList(saijoShisetsuWrapperTempList);
    }

    public String mergesokyakuChuijiko(String Sokyakujicyuiten , String sokyakuChuijikoLabel){
        if(sokyakuChuijikoLabel != null){
            List<String> sokyakuchuijikoList = new List<String>();
            sokyakuchuijikoList = sokyakuChuijikoLabel.split(';');
            for(String sokyakuchuijiko : sokyakuchuijikoList){
                Sokyakujicyuiten = '【'+sokyakuchuijiko+'】' + '\n' + Sokyakujicyuiten  ;
            }
        }
        if(Sokyakujicyuiten != null ){
            Sokyakujicyuiten =  Sokyakujicyuiten.replaceAll('\n', '</br>').replaceAll('\r\n', '</br>');
        }
        
        return Sokyakujicyuiten;
    }
}