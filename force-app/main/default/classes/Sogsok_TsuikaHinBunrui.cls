public class Sogsok_TsuikaHinBunrui {
    private static Map<String,String> EntriesAll = new Map<String, String>{
        '案内看板' => '案内看板',
        '料理' => '料理',
        '返礼品' => '返礼品',
        'ラストメイク' => 'ラストメイク',
        'メイク＆ドレス(古式湯灌)' => 'メイク＆ドレス(古式湯灌)',
        '湯灌' => '湯灌',
        '枕花' => '枕花',
        '棺上花束' => '棺上花束',
        'お別れ花' => 'お別れ花',
        '供花' => '供花',
        '遺影写真' => '遺影写真',
        '正面看板' => '正面看板',
        '外装設備追加' => '外装設備追加',
        '骨壷ランクアップ' => '骨壷ランクアップ',
        '棺' => '棺',
        '首都圏一部地域斎場追加料金' => '首都圏一部地域斎場追加料金',
        '首都圏一部地域火葬場追加料金' => '首都圏一部地域火葬場追加料金',
        '祭壇' => '祭壇',
        'エンバーミング' => 'エンバーミング',
        'その他オプション' => 'その他オプション',
        '火葬場料金' => '火葬場料金',
        '斎場追加料金' => '斎場追加料金',
        '決済手数料(GMO後払い)' => '決済手数料(GMO後払い)'
    };

    public static Map<String,String> getEntrieAlls(){ return EntriesAll; }

    private static Map<String,String> Entries = new Map<String, String>{
        '案内看板' => '案内看板',
        '料理' => '料理',
        '返礼品' => '返礼品',
        'ラストメイク' => 'ラストメイク',
        'メイク＆ドレス(古式湯灌)' => 'メイク＆ドレス(古式湯灌)',
        '湯灌' => '湯灌',
        '枕花' => '枕花',
        '棺上花束' => '棺上花束',
        'お別れ花' => 'お別れ花',
        '供花' => '供花',
        '遺影写真' => '遺影写真',
        '正面看板' => '正面看板',
        '外装設備追加' => '外装設備追加',
        '骨壷ランクアップ' => '骨壷ランクアップ',
        '棺' => '棺',
        '首都圏一部地域斎場追加料金' => '首都圏一部地域斎場追加料金',
        '首都圏一部地域火葬場追加料金' => '首都圏一部地域火葬場追加料金',
        '祭壇' => '祭壇',
        'エンバーミング' => 'エンバーミング',
        'その他オプション' => 'その他オプション'
    };

    public static Map<String,String> getEntries(){ return Entries; }

    public static String tryGetLabel(String pValue, String pNotFoundValue){
        if ( !Entries.containsKey(pValue) ) return pNotFoundValue;
        return Entries.get(pValue);
    }

    private static Map<String, String> BindToSimpleShohinCd = new Map<String, String>{
        '案内看板' => 'SBG-0000014',
        '料理' => 'SBG-0000018',
        '返礼品' => 'SBG-0000019',
        'ラストメイク' => 'SBG-0000020',
        'メイク＆ドレス(古式湯灌)' => 'SBG-0000021',
        '湯灌' => 'SBG-0000022',
        '枕花' => 'SBG-0000023',
        '棺上花束' => 'SBG-0000024',
        'お別れ花' => 'SBG-0000025',
        '供花' => 'SBG-0000026',
        '遺影写真' => 'SBG-0000027',
        '正面看板' => 'SBG-0000028',
        '外装設備追加' => 'SBG-0000029',
        '骨壷ランクアップ' => 'SBG-0000030',
        '棺' => 'SBG-0000031',
        '首都圏一部地域斎場追加料金' => 'SBG-0000282',
        '首都圏一部地域火葬場追加料金' => 'SBG-0000015',
        '祭壇' => 'SBG-0000287',
        'エンバーミング' => 'SBG-0000288',
        'その他オプション' => 'SBG-0000016',
        '決済手数料(GMO後払い)' => 'SBG-0002010'
    };

    private static Map<String, String> BindToYasugoShohinCd = new Map<String, String>{
        '案内看板' => 'SBG-0000120',
        '料理' => 'SBG-0000109',
        '返礼品' => 'SBG-0000110',
        'ラストメイク' => 'SBG-0000111',
        'メイク＆ドレス(古式湯灌)' => 'SBG-0000112',
        '湯灌' => 'SBG-0000113',
        '枕花' => 'SBG-0000114',
        '棺上花束' => 'SBG-0000115',
        'お別れ花' => 'SBG-0000116',
        '供花' => 'SBG-0000117',
        '遺影写真' => 'SBG-0000118',
        '正面看板' => 'SBG-0000119',
        '外装設備追加' => 'SBG-0000121',
        '骨壷ランクアップ' => 'SBG-0000122',
        '棺' => 'SBG-0000123',
        '首都圏一部地域斎場追加料金' => 'SBG-0000125',
        '首都圏一部地域火葬場追加料金' => 'SBG-0000124',
        '祭壇' => 'SBG-0000289',
        'エンバーミング' => 'SBG-0000290',
        'その他オプション' => 'SBG-0000125',
        '決済手数料(GMO後払い)' => 'SBG-0002011'
    };

    private static Map<String, Product2> mapOfShohinCdToProductCache = null;
    private static Map<String, Product2> getShohinCdToProductMap(){

        Set<String> theShohinBangos = new Set<String>();
        theShohinBangos.addAll(BindToSimpleShohinCd.values());
        theShohinBangos.addAll(BindToYasugoShohinCd.values());

        if(mapOfShohinCdToProductCache == null){
            mapOfShohinCdToProductCache = new Map<String, Product2>();
            List<Product2> theProds =
                [
                    select 
                    Id, ShohinBango__c, Name
                    from Product2
                    where ShohinBango__c = :new List<String>(theShohinBangos)
                ];
            for(Product2 aProduct2 : theProds){
                if(!String.isBlank(aProduct2.ShohinBango__c)){
                    mapOfShohinCdToProductCache.put(aProduct2.ShohinBango__c, aProduct2);
                }
            }
        }

        return mapOfShohinCdToProductCache;
    }

    public static Product2 getProduct(String pServiceId, String pHinmokuBunrui){
        String theShohinCode = 
            pServiceId == '1' 
            ? BindToSimpleShohinCd.get(pHinmokuBunrui) 
            : BindToYasugoShohinCd.get(pHinmokuBunrui)
            ;
            
        Product2 theProduct = getShohinCdToProductMap().get(theShohinCode);
        if(theProduct == null){
            String theSonotaOptionShohinCode = 
                pServiceId == '1' 
                ? BindToSimpleShohinCd.get('その他オプション') 
                : BindToYasugoShohinCd.get('その他オプション')
                ;
            theProduct = getShohinCdToProductMap().get(theSonotaOptionShohinCode);
        }

        return theProduct;
    }

    private static Map<String, String> BindFromShohinCd = new Map<String, String>{
        'SBG-0000014'	=>	'案内看板',
        'SBG-0000018'	=>	'料理',
        'SBG-0000019'	=>	'返礼品',
        'SBG-0000020'	=>	'ラストメイク',
        'SBG-0000021'	=>	'メイク＆ドレス(古式湯灌)',
        'SBG-0000022'	=>	'湯灌',
        'SBG-0000023'	=>	'枕花',
        'SBG-0000024'	=>	'棺上花束',
        'SBG-0000025'	=>	'お別れ花',
        'SBG-0000026'	=>	'供花',
        'SBG-0000027'	=>	'遺影写真',
        'SBG-0000028'	=>	'正面看板',
        'SBG-0000029'	=>	'外装設備追加',
        'SBG-0000030'	=>	'骨壷ランクアップ',
        'SBG-0000031'	=>	'棺',
        'SBG-0000282'	=>	'首都圏一部地域斎場追加料金',
        'SBG-0000015'	=>	'首都圏一部地域火葬場追加料金',
        'SBG-0000016'	=>	'その他オプション',
        'SBG-0000120'	=>	'案内看板',
        'SBG-0000109'	=>	'料理',
        'SBG-0000110'	=>	'返礼品',
        'SBG-0000111'	=>	'ラストメイク',
        'SBG-0000112'	=>	'メイク＆ドレス(古式湯灌)',
        'SBG-0000113'	=>	'湯灌',
        'SBG-0000114'	=>	'枕花',
        'SBG-0000115'	=>	'棺上花束',
        'SBG-0000116'	=>	'お別れ花',
        'SBG-0000117'	=>	'供花',
        'SBG-0000118'	=>	'遺影写真',
        'SBG-0000119'	=>	'正面看板',
        'SBG-0000121'	=>	'外装設備追加',
        'SBG-0000122'	=>	'骨壷ランクアップ',
        'SBG-0000123'	=>	'棺',
        'SBG-0000125'	=>	'首都圏一部地域斎場追加料金',
        'SBG-0000124'	=>	'首都圏一部地域火葬場追加料金',
        'SBG-0000287'	=>	'祭壇',
        'SBG-0000288'	=>	'エンバーミング',
        'SBG-0000289'	=>	'祭壇',
        'SBG-0000290'	=>	'エンバーミング',
        'SBG-0000125'	=>	'その他オプション',
        'SBG-0003014'   =>  '案内看板',
        'SBG-0003018'   =>  '料理',
        'SBG-0003019'   =>  '返礼品',
        'SBG-0003020'   =>  'ラストメイク',
        'SBG-0003021'   =>  'メイク＆ドレス(古式湯灌)',
        'SBG-0003022'   =>  '湯灌',
        'SBG-0003023'   =>  '枕花',
        'SBG-0003024'   =>  '棺上花束',
        'SBG-0003025'   =>  'お別れ花',
        'SBG-0003026'   =>  '供花',
        'SBG-0003027'   =>  '遺影写真',
        'SBG-0003028'   =>  '正面看板',
        'SBG-0003029'   =>  '外装設備追加',
        'SBG-0003030'   =>  '骨壷ランクアップ',
        'SBG-0003031'   =>  '棺',
        'SBG-0003282'   =>  '首都圏一部地域斎場追加料金',
        'SBG-0003015'   =>  '首都圏一部地域火葬場追加料金',
        'SBG-0003287'   =>  '祭壇',
        'SBG-0003288'   =>  'エンバーミング',
        'SBG-0003016'   =>  'その他オプション',
        'SBG-0003120'   =>  '案内看板',
        'SBG-0003109'   =>  '料理',
        'SBG-0003110'   =>  '返礼品',
        'SBG-0003111'   =>  'ラストメイク',
        'SBG-0003112'   =>  'メイク＆ドレス(古式湯灌)',
        'SBG-0003113'   =>  '湯灌',
        'SBG-0003114'   =>  '枕花',
        'SBG-0003115'   =>  '棺上花束',
        'SBG-0003116'   =>  'お別れ花',
        'SBG-0003117'   =>  '供花',
        'SBG-0003118'   =>  '遺影写真',
        'SBG-0003119'   =>  '正面看板',
        'SBG-0003121'   =>  '外装設備追加',
        'SBG-0003122'   =>  '骨壷ランクアップ',
        'SBG-0003123'   =>  '棺',
        'SBG-0003124'   =>  '首都圏一部地域火葬場追加料金',
        'SBG-0003289'   =>  '祭壇',
        'SBG-0003290'   =>  'エンバーミング',
        'SBG-0003125'   =>  'その他オプション',
        'SBG-0002010'   =>  '決済手数料(GMO後払い)',
        'SBG-0002011'   =>  '決済手数料(GMO後払い)'
    };

    public static String tryGetKeyFromShohinCd(String pShohinBango){
        if( !BindFromShohinCd.containsKey(pShohinBango) ) return 'その他オプション';
        return BindFromShohinCd.get(pShohinBango);
    }
}