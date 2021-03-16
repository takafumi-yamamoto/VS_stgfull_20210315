/**
* クラス名      :   Ctrl_FuneralCompany
* クラス概要     :   葬儀社・火葬場画面
* @created  :   2017/11/30 Vinh Hua Quoc
* @modified :   
*/
public with sharing class Ctrl_FuneralCompany {
    public SearchWrapper searchWrapper {get; set;}
    public List<FuneralCompanyWrapper> listFuneralCompanyWrapper {get; set;}
    public List<ShisetuWrapper> listShisetuWrapper {get; set;}
    public List<MarkWraper> markWraperList {get; set;}
    public static final String STR_MAP_CENTER_POSITION = '東京都都庁';
    public String getSTR_MAP_CENTER_POSITION(){
        return STR_MAP_CENTER_POSITION;
    }
    public static final String STR_RADIO_LOOKUP = 'Lookup';
    public String getSTR_RADIO_LOOKUP(){
        return STR_RADIO_LOOKUP;
    }
    public static final String STR_RADIO_TEXT = 'Text';
    public String getSTR_RADIO_TEXT(){
        return STR_RADIO_TEXT;
    }
    public static final Decimal DECIMAL_OUT_TITUDE = 999;
    public static final Decimal DECIMAL_DEFAULT_LATITUDE = 35.689634;
    public static final Decimal DECIMAL_DEFAULT_LONGITUDE = 139.692101;
    public static final String DECIMAL_DISTANCE_NOINFO = '-1';
    public String getDECIMAL_DISTANCE_NOINFO(){
        return DECIMAL_DISTANCE_NOINFO;
    }
    private static final Decimal DECIMAL_HANKEI = 20;
    
    /*
    * Ctrl_FuneralCompany
    * コンストラクタ
    * @created: 2017/11/30 Vinh Hua Quoc
    * @modified:
    */
    public Ctrl_FuneralCompany() {
        searchWrapper = new SearchWrapper();
        markWraperList = new List<MarkWraper>();
    }
    /**
    * searchData
    * 検索アクション
    * @param なし
    * @return なし
    * @created: 2017/11/30 Vinh Hua Quoc
    * @modified: 
    */
    public void searchData(){

        listFuneralCompanyWrapper = new List<FuneralCompanyWrapper>();
        listShisetuWrapper = new List<ShisetuWrapper>();
        markWraperList = new List<MarkWraper>();

        Set<String> setKeiyakuIdLookup = new Set<String>();

        String strQueryKeiyaku = 'SELECT Id,'
                        + 'Teikeisaki__c,'
                        + 'Teikeisaki__r.Name,'
                        + 'Teikeisaki__r.BillingState,'
                        + 'Teikeisaki__r.BillingCity,'
                        + 'Teikeisaki__r.BillingStreet,'
                        + 'Teikeisaki__r.BillingPostalCode,'
                        + 'SokyakujiCyuitenAri__c,'
                        + 'SogisyaTokkijikoAri__c,'
                        + 'SougisyaDenwaBango1__c,'
                        + 'SougisyaFax__c,'
                        + 'SougisyaSoukyakuRank__c,'
                        + 'TeikeisakiJusyoIdo__c,'
                        + 'TeikeisakiJusyoKeido__c,'
                        + 'Teikeisaki__r.JisyaSaijoSyoyuJokyo__c'
                        + ' FROM Keiyaku__c ';

        String strWhereKeiyaku = '';
        String strOrderKeiyaku = '';

        if(searchWrapper.radioLookup && String.isNotBlank(searchWrapper.account.ShikugunRef__c)){
            List<Shikugun__c> lTempShikugun = [
                SELECT Id,
                    Chiriichijouhou__latitude__s, 
                    Chiriichijouhou__longitude__s,
                    name
                FROM Shikugun__c 
                WHERE Id = :searchWrapper.account.ShikugunRef__c
                LIMIT 1
            ];
            System.debug('==lTempShikugun==' + lTempShikugun);
            System.debug('==Chiriichijouhou__latitude__s==' + lTempShikugun[0].Chiriichijouhou__latitude__s);
            System.debug('==Chiriichijouhou__latitude__s==' + lTempShikugun[0].Chiriichijouhou__longitude__s);
            if(!lTempShikugun.isEmpty() && lTempShikugun[0].Chiriichijouhou__latitude__s != null && lTempShikugun[0].Chiriichijouhou__longitude__s != null){
                searchWrapper.latitudeAdress = lTempShikugun[0].Chiriichijouhou__latitude__s;
                searchWrapper.longitudeAdress = lTempShikugun[0].Chiriichijouhou__longitude__s;
                searchWrapper.DisplaySearchPostionName = lTempShikugun[0].name;
            }
            List<SekouKanouArea__c> lstSekouKanouArea = [
                SELECT Id,
                    SimpleYasugoKeiyakuRef__c
                FROM SekouKanouArea__c
                WHERE ShikugunRef__c = :searchWrapper.account.ShikugunRef__c
            ];
            
            for(SekouKanouArea__c item : lstSekouKanouArea){
                if(String.isNotBlank(item.SimpleYasugoKeiyakuRef__c)){
                    setKeiyakuIdLookup.add(item.SimpleYasugoKeiyakuRef__c);
                }
            }
            System.debug('==setKeiyakuIdLookup==' + setKeiyakuIdLookup);
        }else{
        	if (String.isNotBlank(searchWrapper.address)){
        		searchWrapper.DisplaySearchPostionName = searchWrapper.address;
        	}
        }
        System.debug('==searchWrapper.latitudeAdress==' + searchWrapper.latitudeAdress);
        System.debug('==searchWrapper.longitudeAdress==' + searchWrapper.longitudeAdress);
        if(searchWrapper.latitudeAdress != DECIMAL_OUT_TITUDE && searchWrapper.longitudeAdress != DECIMAL_OUT_TITUDE){
            // I)　葬儀社検索
            if(!setKeiyakuIdLookup.isEmpty()){
                strWhereKeiyaku +=  ' AND Id IN : setKeiyakuIdLookup';
            }
            strWhereKeiyaku += ' AND DISTANCE(Teikeisaki__r.BillingAddress, GEOLOCATION(' + searchWrapper.latitudeAdress + ',' + searchWrapper.longitudeAdress + '), \'km\') < ' + DECIMAL_HANKEI +' and recordtypeid=\''+label.RecordTypeIdKeiyakuSimpleYasu+'\' ';
            strOrderKeiyaku = ' ORDER BY SougisyaSoukyakuRank__c ASC NULLS LAST limit 49';

            strWhereKeiyaku = strWhereKeiyaku.replaceFirst('AND', 'WHERE');
            strQueryKeiyaku += strWhereKeiyaku;
            strQueryKeiyaku += strOrderKeiyaku;

            if( (searchWrapper.radioLookup && !setKeiyakuIdLookup.isEmpty()) || searchWrapper.radioText){
                System.debug('===strQueryKeiyaku===' + strQueryKeiyaku);
                List<Keiyaku__c> searchResultKeiyaku = database.query(strQueryKeiyaku);
                System.debug('===searchResultKeiyaku===' + searchResultKeiyaku.size());
                Set<String> accountSetId = new Set<String>();
                // Set data to show
                for(Integer i = 0; i < Math.min(searchResultKeiyaku.size(), 100); i++){                
                    FuneralCompanyWrapper temp = new FuneralCompanyWrapper(i+1, searchResultKeiyaku[i]);
                    listFuneralCompanyWrapper.add(temp);
                    system.debug('***temp***'+temp);
                    if(temp.checkHaveMark() && !accountSetId.contains(searchResultKeiyaku[i].Teikeisaki__c)){
                        MarkWraper myMark = new MarkWraper(i+1,
                                                            temp.keiyaku.TeikeisakiJusyoIdo__c,
                                                            temp.keiyaku.TeikeisakiJusyoKeido__c,
                                                            temp.keiyaku.Teikeisaki__r.Name,
                                                            false,
                                                            temp.keiyaku.SougisyaDenwaBango1__c);
                        markWraperList.add(myMark);
                    }
                    accountSetId.add(searchResultKeiyaku[i].Teikeisaki__c);
                }
                System.debug('===markWraperList UUU===' + markWraperList.size());
                System.debug('===markWraperList===' + markWraperList);
                System.debug('===listFuneralCompanyWrapper UUU===' + listFuneralCompanyWrapper.size());
                //System.debug('===searchWrapper.latitudeAdress===' + searchWrapper.latitudeAdress);
                //System.debug('===searchWrapper.longitudeAdress===' + searchWrapper.longitudeAdress);
                // Set distance
                if(!accountSetId.isEmpty() && searchWrapper.latitudeAdress != DECIMAL_OUT_TITUDE && searchWrapper.longitudeAdress != DECIMAL_OUT_TITUDE){
                    Decimal latitudeIn  = searchWrapper.latitudeAdress;
                    Decimal longitudeIn = searchWrapper.longitudeAdress;
                    Map<Id,Account> searchResultAccountMap = new Map<Id,Account>([
                        SELECT Id, DISTANCE(BillingAddress, GEOLOCATION(:latitudeIn,:longitudeIn), 'km') dist
                        FROM Account
                        WHERE Id IN :accountSetId
                    ]);
                    //System.debug('===searchResultAccountMap===' + searchResultAccountMap.size());
                    for(FuneralCompanyWrapper item : listFuneralCompanyWrapper){
                        if(searchResultAccountMap.containsKey(item.keiyaku.Teikeisaki__c)){
                            Decimal distanceValue = Decimal.valueOf(String.valueOf(searchResultAccountMap.get(item.keiyaku.Teikeisaki__c).get('dist')));
                            item.distance = String.valueOf(distanceValue.setScale(2)) + 'km';
                        }
                    }
                }
            }
            

            //II)　検索結果(斎場・火葬場)
            String strDistanceShisetu = ' DISTANCE(IdoKedo__c, GEOLOCATION(' + searchWrapper.latitudeAdress + ',' + searchWrapper.longitudeAdress + '), \'km\') dist, ';
            String strOrderShisetu = ' ORDER BY DISTANCE(IdoKedo__c, GEOLOCATION(' + searchWrapper.latitudeAdress + ',' + searchWrapper.longitudeAdress + '), \'km\') ASC NULLS LAST limit 50';
            String strWhereShisetu = ' AND DISTANCE(IdoKedo__c, GEOLOCATION(' + searchWrapper.latitudeAdress + ',' + searchWrapper.longitudeAdress + '), \'km\') < ' + DECIMAL_HANKEI + ' ';

            String strQueryShisetu = 'SELECT Id,'
                    + 'Name,'
                    + 'Phone1__c,'
                    + 'Jusho__c,'
                    + 'Sogisha__c,'
                    + 'ShisetsuShubetsu__c,'
                    + 'IdoKedo__latitude__s,'
                    + 'IdoKedo__longitude__s,'
                    + 'Biko__c,'
                    + 'KoeiMinei__c,'
                    + strDistanceShisetu
                    + 'HpUrl__c'
                    + ' FROM Shisetsu__c ';

            if(String.isNotBlank(strWhereShisetu)){
                strWhereShisetu = strWhereShisetu.replaceFirst('AND', 'WHERE');
                strQueryShisetu += strWhereShisetu;
                strQueryShisetu += strOrderShisetu;
            }
            System.debug('==strQueryShisetu==' + strQueryShisetu);
            List<Shisetsu__c> searchResultShisetu = database.query(strQueryShisetu);
            for(Integer i = 0; i < Math.min(searchResultShisetu.size(), 100); i++){
                ShisetuWrapper temp = new ShisetuWrapper(i+1, searchResultShisetu[i]);
                if(searchResultShisetu[i].get('dist') != null){
                    Decimal distanceValue = Decimal.valueOf(String.valueOf(searchResultShisetu[i].get('dist')));
                    temp.distance = String.valueOf(distanceValue.setScale(2)) + 'km';
                    // Map mark
                    MarkWraper myMark = new MarkWraper(i+1,
                                                        temp.shisetu.IdoKedo__latitude__s,
                                                        temp.shisetu.IdoKedo__longitude__s,
                                                        temp.shisetu.Name,
                                                        true,
                                                        temp.shisetu.Phone1__c);
                    markWraperList.add(myMark);
                    System.debug('==myMarkXXX==' + myMark);
                }
                listShisetuWrapper.add(temp);
            }
            System.debug('===markWraperList2 uuu===' + markWraperList.size());
            System.debug('===markWraperList2===' + markWraperList);
            //System.debug('==listShisetuWrapper==' + listShisetuWrapper.size());
        }
        return;
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
        listShisetuWrapper = new List<ShisetuWrapper>();
        markWraperList = new List<MarkWraper>();
        return;
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
        public Decimal latitudeAdress {get; set;}
        public Decimal longitudeAdress {get; set;}
        public string DisplaySearchPostionName{get; set;}
        public Boolean radioLookup {get; set;}
        public Boolean radioText {get; set;}
        public SearchWrapper() {
            keiyaku = new Keiyaku__c();
            account = new Account();
            address = '';
            //latitudeAdress = Ctrl_FuneralCompany.DECIMAL_OUT_TITUDE;
            //longitudeAdress = Ctrl_FuneralCompany.DECIMAL_OUT_TITUDE;
            latitudeAdress=DECIMAL_DEFAULT_LATITUDE;
            longitudeAdress=DECIMAL_DEFAULT_LONGITUDE;
            DisplaySearchPostionName= STR_MAP_CENTER_POSITION;
            radioLookup = true;
            radioText = false;
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
        public FuneralCompanyWrapper(Integer resultIndex, Keiyaku__c keiyaku){
            this.resultIndex = resultIndex;
            this.keiyaku = keiyaku;
            this.distance = Ctrl_FuneralCompany.DECIMAL_DISTANCE_NOINFO;
        }
        private Boolean checkHaveMark(){
            if(this.keiyaku.TeikeisakiJusyoIdo__c == null || this.keiyaku.TeikeisakiJusyoKeido__c == null){
                return false;
            }
            return true;
        }
    }

    public class MarkWraper {
        public Integer resultIndex {get;set;}
        public Decimal latitude {get; set;}
        public Decimal longitude {get; set;}
        public String positionName {get; set;}
        public boolean isShisetsu {get; set;}
        public String denwaBango {get; set;}
        public MarkWraper(Integer resultIndex, Decimal inLat, Decimal inLong, String inTitle, boolean inShisetsu, String denwaBango){
            this.resultIndex = resultIndex;
            this.latitude = inLat;
            this.longitude = inLong;
            this.positionName = inTitle;
            this.isShisetsu = inShisetsu;
            this.denwaBango = denwaBango;
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
        public ShisetuWrapper(Integer resultIndex, Shisetsu__c shisetu){
            this.resultIndex = resultIndex;
            this.shisetu = shisetu;
            this.distance = Ctrl_FuneralCompany.DECIMAL_DISTANCE_NOINFO;
        }
    }
}