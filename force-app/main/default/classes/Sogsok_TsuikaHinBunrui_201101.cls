public class Sogsok_TsuikaHinBunrui_201101 {

    public class Entry{
        public String code = '';
        public String label = '';
        public List<Hinmoku> hinmokus = new List<Hinmoku>();
    }

    public class Hinmoku{
        public String code = '';
        public String label = '';
        public String name = '';
        public Decimal unit_price = 0;
        public String shohin_bango = '';
    }

    public static String getEntries(){

        List<Hinmoku> hinmokusSogisha = new List<Hinmoku>();
        List<Hinmoku> hinmokusYoriso = new List<Hinmoku>();
        
        for(Product2 shohinMaster : [select Id, 
                                            ShohinBango__c, 
                                            Name, 
                                            NameForCustomerExp__c, 
                                            k_ShohinCategory_Id_exp__c, 
                                            (select Id, 
                                                    name, 
                                                    UnitPrice 
                                            from PricebookEntries 
                                            where IsActive = true)
                                    from Product2 
                                    where k_ShohinCategory_Id_exp__c in ('sougiOption','yoriso-option','yoriso-option-campaign')
                                    and LatestFlg__c = true 
                                    order by ShohinBango__c]){
            List<Hinmoku>  hinmokus = shohinMaster.k_ShohinCategory_Id_exp__c == 'sougiOption' ? hinmokusSogisha : hinmokusYoriso;
            Hinmoku hin = new Hinmoku();
            hin.label = shohinMaster.NameForCustomerExp__c.replace('よりそうお葬式 オプション ', '');
            hin.name = hin.label;
            hin.code = shohinMaster.k_ShohinCategory_Id_exp__c == 'sougiOption' ? '葬儀社_' + hin.label : 'よりそう_' + hin.label;
            hin.unit_price = shohinMaster.PricebookEntries.size() > 0 ? shohinMaster.PricebookEntries.get(0).UnitPrice : 0;
            hin.shohin_bango = shohinMaster.ShohinBango__c;
            hinmokus.add(hin);
        }

        List<Entry> entrys = new List<Entry>();
        Entry enSogisha = new Entry();
        enSogisha.code = '葬儀社様';
        enSogisha.label = '葬儀社様';
        enSogisha.hinmokus = hinmokusSogisha;

        Entry enYoriso = new Entry();
        enYoriso.code = 'よりそう';
        enYoriso.label = 'よりそう';
        enYoriso.hinmokus = hinmokusYoriso;

        entrys.add(enYoriso);
        entrys.add(enSogisha);

        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeObject(entrys);
        System.debug('gen.getAsString():' + gen.getAsString());
        return gen.getAsString();
    }

    @TestVisible
    private static Map<String, String> BindToSimpleShohinCd = new Map<String, String>{
        '案内看板' => 'SBG-0003014',
        '料理' => 'SBG-0003018',
        '返礼品' => 'SBG-0003019',
        'ラストメイク' => 'SBG-0003020',
        'メイク＆ドレス(古式湯灌)' => 'SBG-0003021',
        '湯灌' => 'SBG-0003022',
        '枕花' => 'SBG-0003023',
        '棺上花束' => 'SBG-0003024',
        'お別れ花' => 'SBG-0003025',
        '供花' => 'SBG-0003026',
        '遺影写真' => 'SBG-0003027',
        '正面看板' => 'SBG-0003028',
        '外装設備追加' => 'SBG-0003029',
        '骨壷ランクアップ' => 'SBG-0003030',
        '棺' => 'SBG-0003031',
        '火葬場料金' => 'SBG-0003015',
        '斎場追加料金' => 'SBG-0003282',
        '祭壇' => 'SBG-0003287',
        'エンバーミング' => 'SBG-0003288',
        'その他オプション' => 'SBG-0003016',
        '決済手数料(GMO後払い)' => 'SBG-0002010'
    };

    private static Map<String, Product2> mapOfShohinCdToProductCache = null;

    @TestVisible
    private static Map<String, Product2> getShohinCdToProductMap(){

        if(mapOfShohinCdToProductCache == null){
            mapOfShohinCdToProductCache = new Map<String, Product2>();
            List<Product2> theProds =
                [
                    select 
                    Id, ShohinBango__c, Name
                    from Product2

                ];
            for(Product2 aProduct2 : theProds){
                if(!String.isBlank(aProduct2.ShohinBango__c)){
                    mapOfShohinCdToProductCache.put(aProduct2.ShohinBango__c, aProduct2);
                }
            }
        }

        return mapOfShohinCdToProductCache;
    }

    public static Product2 getProduct(String pShohinBango){
            
        Product2 theProduct = getShohinCdToProductMap().get(pShohinBango);
        if(theProduct == null){ theProduct = getShohinCdToProductMap().get('SBG-0005517'); } //【20.11】葬儀社オプション その他オプション

        return theProduct;
    }

    @TestVisible
    private static Map<String, String> BindFromShohinCd = new Map<String, String>{
        'SBG-0002010' => '葬儀社様;葬儀社_よりそうお葬式 後払いご利用料金',
    	'SBG-0005401' => 'よりそう;よりそう_祭壇アップグレード M (家族葬 一日プラン)',
    	'SBG-0005402' => 'よりそう;よりそう_祭壇アップグレード L (家族葬 一日プラン)',
        'SBG-0005403' => 'よりそう;よりそう_祭壇アップグレード LL (家族葬 一日プラン)',
        'SBG-0005404' => 'よりそう;よりそう_祭壇アップグレード L (家族葬 二日プラン)',
        'SBG-0005405' => 'よりそう;よりそう_祭壇アップグレード LL (家族葬 二日プラン)',
        'SBG-0005406' => 'よりそう;よりそう_祭壇アップグレード LL (家族葬 華やかプラン)',
        'SBG-0005407' => 'よりそう;よりそう_お別れ花 S',
        'SBG-0005408' => 'よりそう;よりそう_お別れ花 M',
        'SBG-0005409' => 'よりそう;よりそう_お別れ花 L',
        'SBG-0005410' => 'よりそう;よりそう_棺上花束 S',
        'SBG-0005411' => 'よりそう;よりそう_棺上花束 M',
        'SBG-0005412' => 'よりそう;よりそう_棺上花束 L',
        'SBG-0005413' => 'よりそう;よりそう_枕花 S',
        'SBG-0005414' => 'よりそう;よりそう_枕花 M',
        'SBG-0005415' => 'よりそう;よりそう_枕花 L',
        'SBG-0005416' => 'よりそう;よりそう_遺影写真 (大小2枚)',
        'SBG-0005417' => 'よりそう;よりそう_付添安置 (1泊)',
        'SBG-0005418' => 'よりそう;よりそう_搬送超過料金',
        'SBG-0005419' => 'よりそう;よりそう_ご安置追加料金',
        'SBG-0005420' => 'よりそう;よりそう_葬儀用ブーケ (キャンペーンプレゼント)',
        'SBG-0005501' => '葬儀社様;葬儀社_料理',
        'SBG-0005502' => '葬儀社様;葬儀社_返礼品',
        'SBG-0005503' => '葬儀社様;葬儀社_祭壇',
        'SBG-0005504' => '葬儀社様;葬儀社_エンバーミング',
        'SBG-0005505' => '葬儀社様;葬儀社_ラストメイク',
        'SBG-0005506' => '葬儀社様;葬儀社_メイク＆ドレス(古式湯灌)',
        'SBG-0005507' => '葬儀社様;葬儀社_湯かん',
        'SBG-0005508' => '葬儀社様;葬儀社_枕花',
        'SBG-0005509' => '葬儀社様;葬儀社_棺上花束',
        'SBG-0005510' => '葬儀社様;葬儀社_供花',
        'SBG-0005511' => '葬儀社様;葬儀社_お別れ花',
        'SBG-0005512' => '葬儀社様;葬儀社_遺影写真',
        'SBG-0005513' => '葬儀社様;葬儀社_外装設備追加',
        'SBG-0005514' => '葬儀社様;葬儀社_骨壺ランクアップ',
        'SBG-0005515' => '葬儀社様;葬儀社_棺',
        'SBG-0005516' => '葬儀社様;葬儀社_看板',
        'SBG-0005517' => '葬儀社様;葬儀社_その他オプション',
        'SBG-0005518' => '葬儀社様;葬儀社_火葬場料金',
        'SBG-0005519' => '葬儀社様;葬儀社_斎場追加料金'
    };

    public static String tryGetKeyFromShohinCd(String pShohinBango){
        if( !BindFromShohinCd.containsKey(pShohinBango) ) return 'その他オプション';
        return BindFromShohinCd.get(pShohinBango);
    }
}