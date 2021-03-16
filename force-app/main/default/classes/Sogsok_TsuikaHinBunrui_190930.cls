/**
 * 2019/10/01の税率10%用の商品マスタMapクラス
 * 以降価格改定があった場合、商品の販売開始日ごとにクラスを追加していく予定。
 */
public class Sogsok_TsuikaHinBunrui_190930 {
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
        '火葬場料金' => '火葬場料金',
        '斎場追加料金' => '斎場追加料金',
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
        '案内看板' => 'SBG-0001014',
        '料理' => 'SBG-0001018',
        '返礼品' => 'SBG-0001019',
        'ラストメイク' => 'SBG-0001020',
        'メイク＆ドレス(古式湯灌)' => 'SBG-0001021',
        '湯灌' => 'SBG-0001022',
        '枕花' => 'SBG-0001023',
        '棺上花束' => 'SBG-0001024',
        'お別れ花' => 'SBG-0001025',
        '供花' => 'SBG-0001026',
        '遺影写真' => 'SBG-0001027',
        '正面看板' => 'SBG-0001028',
        '外装設備追加' => 'SBG-0001029',
        '骨壷ランクアップ' => 'SBG-0001030',
        '棺' => 'SBG-0001031',
        '火葬場料金' => 'SBG-0001015',
        '斎場追加料金' => 'SBG-0001282',
        '祭壇' => 'SBG-0001287',
        'エンバーミング' => 'SBG-0001288',
        'その他オプション' => 'SBG-0001016',
        '決済手数料(GMO後払い)' => 'SBG-0002010'
    };

    private static Map<String, String> BindToYasugoShohinCd = new Map<String, String>{
        '料理' => 'SBG-0001109',
        '返礼品' => 'SBG-0001110',
        'ラストメイク' => 'SBG-0001111',
        'メイク＆ドレス(古式湯灌)' => 'SBG-0001112',
        '湯灌' => 'SBG-0001113',
        '枕花' => 'SBG-0001114',
        '棺上花束' => 'SBG-0001115',
        'お別れ花' => 'SBG-0001116',
        '供花' => 'SBG-0001117',
        '遺影写真' => 'SBG-0001118',
        '正面看板' => 'SBG-0001119',
        '案内看板' => 'SBG-0001120',
        '外装設備追加' => 'SBG-0001121',
        '骨壷ランクアップ' => 'SBG-0001122',
        '棺' => 'SBG-0001123',
        '火葬場料金' => 'SBG-0001124',
        'その他オプション' => 'SBG-0001125',
        '祭壇' => 'SBG-0001289',
        'エンバーミング' => 'SBG-0001290',
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
        'SBG-0001014' => '案内看板',
    	'SBG-0001015' => '火葬場料金',
    	'SBG-0001016' => 'その他オプション',
        'SBG-0001018' => '料理',
        'SBG-0001019' => '返礼品',
        'SBG-0001020' => 'ラストメイク',
        'SBG-0001021' => 'メイク＆ドレス(古式湯灌)',
        'SBG-0001022' => '湯灌',
        'SBG-0001023' => '枕花',
        'SBG-0001024' => '棺上花束',
        'SBG-0001025' => 'お別れ花',
        'SBG-0001026' => '供花',
        'SBG-0001027' => '遺影写真',
        'SBG-0001028' => '正面看板',
        'SBG-0001029' => '外装設備追加',
        'SBG-0001030' => '骨壷ランクアップ',
        'SBG-0001031' => '棺',
        'SBG-0001282' => '斎場追加料金',
        'SBG-0001287' => '祭壇',
        'SBG-0001288' => 'エンバーミング',
        'SBG-0001109' => '料理',
        'SBG-0001110' => '返礼品',
        'SBG-0001111' => 'ラストメイク',
        'SBG-0001112' => 'メイク＆ドレス(古式湯灌)',
        'SBG-0001113' => '湯灌',
        'SBG-0001114' => '枕花',
        'SBG-0001115' => '棺上花束',
        'SBG-0001116' => 'お別れ花',
        'SBG-0001117' => '供花',
        'SBG-0001118' => '遺影写真',
        'SBG-0001119' => '正面看板',
        'SBG-0001120' => '案内看板',
        'SBG-0001121' => '外装設備追加',
        'SBG-0001122' => '骨壷ランクアップ',
        'SBG-0001123' => '棺',
        'SBG-0001124' => '火葬場料金',
        'SBG-0001125' => 'その他オプション',
        'SBG-0001289' => '祭壇',
        'SBG-0001290' => 'エンバーミング',
        'SBG-0002010' => '決済手数料(GMO後払い)',
        'SBG-0002011' => '決済手数料(GMO後払い)'
    };

    public static String tryGetKeyFromShohinCd(String pShohinBango){
        if( !BindFromShohinCd.containsKey(pShohinBango) ) return 'その他オプション';
        return BindFromShohinCd.get(pShohinBango);
    }
}