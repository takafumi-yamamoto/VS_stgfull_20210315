public class SogSok_SrthRyokin {

    private class PriceEntry{
        public PriceEntry(String pShohinCodeForTest, Decimal pPrice ){this.ShohinCodeForTest = pShohinCodeForTest; this.price = pPrice; }
        String ShohinCodeForTest = ''; //価格一致確認テスト用
        Decimal price = 0;
    }

    private static Map<String,PriceEntry> BindingSrthPlanToPrice = new Map<String,PriceEntry>{
        'kaso' => new PriceEntry('SBG-0000046', 35000),
        'ichinichi' => new PriceEntry('SBG-0000047', 65000),
        'ippan' => new PriceEntry('SBG-0000048', 140000),
        'none' => new PriceEntry('', 0)
    };
    private Decimal getPriceFromSrthPlan(String pValue){
        return BindingSrthPlanToPrice.get(pValue).price;
    }

    private static Map<String,PriceEntry> BindingKaimyoToPrice = new Map<String,PriceEntry>{
        '釋' => new PriceEntry('SBG-0000060', 20000),
        '釋尼' => new PriceEntry('SBG-0000060', 20000),
        '信士' => new PriceEntry('SBG-0000061', 20000),
        '信女' => new PriceEntry('SBG-0000061', 20000),
        '居士' => new PriceEntry('SBG-0000063', 60000),
        '大姉' => new PriceEntry('SBG-0000063', 60000),
        '院釋' => new PriceEntry('SBG-0000064', 160000),
        '院釋尼' => new PriceEntry('SBG-0000064', 160000),
        '院信士' => new PriceEntry('SBG-0000062', 60000),
        '院信女' => new PriceEntry('SBG-0000062', 60000),
        '院日信士' => new PriceEntry('SBG-0000065', 160000),
        '院日信女' => new PriceEntry('SBG-0000065', 160000),
        '院居士' => new PriceEntry('SBG-0000066', 200000),
        '院大姉' => new PriceEntry('SBG-0000066', 200000),
        'none' => new PriceEntry('', 0)
    };
    private Decimal getPriceFromKaimyo(String pValue){
        return BindingKaimyoToPrice.get(pValue).price;
    }

    private static Map<String,PriceEntry> BindingMakurakyoToPrice = new Map<String,PriceEntry>{
        'tsuya_zenzitsu' => new PriceEntry('SBG-0000055', 35000),
        'tsuya_toujitsu' => new PriceEntry('SBG-0000056', 20000),
        'kokubetsu_zenzitsu' => new PriceEntry('SBG-0000055', 35000),
        'kokubetsu_toujitsu' => new PriceEntry('SBG-0000056', 20000),
        'kasoshiki' => new PriceEntry('SBG-0000045', 35000),
        'none' => new PriceEntry('', 0)
    };
    private Decimal getPriceFromMakurakyo(String pValue){
        return BindingMakurakyoToPrice.get(pValue).price;
    }

    public Decimal getPrice(String pSrthPlanCode, String pKaimyoCode, String pMakurakyoCode){
        Decimal thePrice = 0;
        thePrice += this.getPriceFromSrthPlan(pSrthPlanCode);
        thePrice += this.getPriceFromKaimyo(pKaimyoCode);
        thePrice += this.getPriceFromMakurakyo(pMakurakyoCode);
        return thePrice;
    }

    private static Map<String,String> BindingSrthToObouPlan = new Map<String,String>{
        'kaso' => '火葬式',
        'ichinichi' => '一日葬',
        'ippan' => '一般葬',
        'kaimyo-only' => '戒名・法名のみ',
        'makurakyo-only' => '枕経のみ'
    };
    public String tryGetObouPlanFromSrth(String pSrthPlanCode, String pKaimyoCode, String pMakurakyoCode){
        
        if( String.isBlank(pSrthPlanCode) || String.isBlank(pKaimyoCode) || String.isBlank(pMakurakyoCode)) return null;

        String theKey = '';
        if(String.isBlank(theKey) && pSrthPlanCode == 'none' && pMakurakyoCode == 'none' && pKaimyoCode != 'none'){
            theKey = 'kaimyo-only';
        }
        if(String.isBlank(theKey) && pSrthPlanCode == 'none' && pKaimyoCode == 'none' && pMakurakyoCode != 'none'){
            theKey = 'makurakyo-only';
        }
        if(String.isBlank(theKey) && pSrthPlanCode == 'kaso'){ theKey = 'kaso'; }
        if(String.isBlank(theKey) && pSrthPlanCode == 'ichinichi'){ theKey = 'ichinichi'; }
        if(String.isBlank(theKey) && pSrthPlanCode == 'ippan'){ theKey = 'ippan'; }

        return BindingSrthToObouPlan.get(theKey);
    }

}