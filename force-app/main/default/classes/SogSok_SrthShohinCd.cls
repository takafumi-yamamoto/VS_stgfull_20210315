public class SogSok_SrthShohinCd {

    private class ShohinCodeEntry{
        public ShohinCodeEntry(String pShohinCode, Decimal pPriceForTest ){this.ShohinCode = pShohinCode; this.PriceForTest = pPriceForTest; }
        String ShohinCode = ''; 
        Decimal PriceForTest = 0; //価格による商品一致確認テスト用
    }

    private static Set<String> KaimyoRanks = new Set<String>{
        '釋|釋尼',
        '信士|信女',
        '居士|大姉',
        '院釋|院釋尼',
        '院信士|院信女',
        '院日信士|院日信女',
        '院居士|院大姉'
    };
    private static Map<String,String> BindingKaimyoToKaimyoRank = new Map<String,String>{
        '釋' => '釋|釋尼',
        '釋尼' => '釋|釋尼',
        '信士' => '信士|信女',
        '信女' => '信士|信女',
        '居士' => '居士|大姉',
        '大姉' => '居士|大姉',
        '院釋' => '院釋|院釋尼',
        '院釋尼' => '院釋|院釋尼',
        '院信士' => '院信士|院信女',
        '院信女' => '院信士|院信女',
        '院日信士' => '院日信士|院日信女',
        '院日信女' => '院日信士|院日信女',
        '院居士' => '院居士|院大姉',
        '院大姉' => '院居士|院大姉',
        'none' => 'none'
    };

    private String createSogiPlusKaimyoRankCode(String pSogi, String pKaimyo){
        String theKaimyoRank = BindingKaimyoToKaimyoRank.get(pKaimyo);
        return 
            String.Format('{0}+{1}', new List<String>{
                pSogi == null ? '' : pSogi,
                theKaimyoRank == null ? '' : theKaimyoRank
            });
    }
    private static Map<String,ShohinCodeEntry> BindingSogiAndKaimyoRankToShohinCode = new Map<String,ShohinCodeEntry>{
        'kaso+none' => new ShohinCodeEntry('SBG-0000046', 35000),
        'ichinichi+none' => new ShohinCodeEntry('SBG-0000047', 65000),
        'ippan+none' => new ShohinCodeEntry('SBG-0000048', 140000),
        'none+釋|釋尼' => new ShohinCodeEntry('SBG-0000060', 20000),
        'none+院釋|院釋尼' => new ShohinCodeEntry('SBG-0000064', 20000),
        'none+信士|信女' => new ShohinCodeEntry('SBG-0000061', 60000),
        'none+居士|大姉' => new ShohinCodeEntry('SBG-0000063', 60000),
        'none+院信士|院信女' => new ShohinCodeEntry('SBG-0000062', 160000),
        'none+院日信士|院日信女' => new ShohinCodeEntry('SBG-0000065', 160000),
        'none+院居士|院大姉' => new ShohinCodeEntry('SBG-0000066', 200000),
        'kaso+釋|釋尼' => new ShohinCodeEntry('SBG-0000225', 55000),
        'kaso+院釋|院釋尼' => new ShohinCodeEntry('SBG-0000226', 195000),
        'kaso+信士|信女' => new ShohinCodeEntry('SBG-0000227', 55000),
        'kaso+居士|大姉' => new ShohinCodeEntry('SBG-0000228', 95000),
        'kaso+院信士|院信女' => new ShohinCodeEntry('SBG-0000229', 95000),
        'kaso+院日信士|院日信女' => new ShohinCodeEntry('SBG-0000230', 195000),
        'kaso+院居士|院大姉' => new ShohinCodeEntry('SBG-0000231', 235000),
        'ichinichi+釋|釋尼' => new ShohinCodeEntry('SBG-0000232', 85000),
        'ichinichi+院釋|院釋尼' => new ShohinCodeEntry('SBG-0000233', 225000),
        'ichinichi+信士|信女' => new ShohinCodeEntry('SBG-0000234', 85000),
        'ichinichi+居士|大姉' => new ShohinCodeEntry('SBG-0000235', 125000),
        'ichinichi+院信士|院信女' => new ShohinCodeEntry('SBG-0000236', 125000),
        'ichinichi+院日信士|院日信女' => new ShohinCodeEntry('SBG-0000237', 225000),
        'ichinichi+院居士|院大姉' => new ShohinCodeEntry('SBG-0000238', 265000),
        'ippan+釋|釋尼' => new ShohinCodeEntry('SBG-0000239', 160000),
        'ippan+院釋|院釋尼' => new ShohinCodeEntry('SBG-0000240', 300000),
        'ippan+信士|信女' => new ShohinCodeEntry('SBG-0000241', 160000),
        'ippan+居士|大姉' => new ShohinCodeEntry('SBG-0000242', 200000),
        'ippan+院信士|院信女' => new ShohinCodeEntry('SBG-0000243', 200000),
        'ippan+院日信士|院日信女' => new ShohinCodeEntry('SBG-0000244', 300000),
        'ippan+院居士|院大姉' => new ShohinCodeEntry('SBG-0000245', 340000),
        'none+none' => new ShohinCodeEntry('', 0)
    };

    private static Map<String,ShohinCodeEntry> BindingMakurakyoToShohinCode = new Map<String,ShohinCodeEntry>{
        'kokubetsu_zenzitsu' => new ShohinCodeEntry('SBG-0000055', 35000),
        'kokubetsu_toujitsu' => new ShohinCodeEntry('SBG-0000056', 20000),
        'tsuya_zenzitsu' => new ShohinCodeEntry('SBG-0000055', 35000),
        'tsuya_toujitsu' => new ShohinCodeEntry('SBG-0000056', 20000),
        'kasoshiki' => new ShohinCodeEntry('SBG-0000045', 35000),
        'none' => new ShohinCodeEntry('', 0)
    };

    public Set<String> getShohinCodes(String pSrthPlanCode, String pKaimyoCode, String pMakurakyoCode){
        Set<String> theShohinCodes = new Set<String>();
        
        String theSogiPlusKaimyoRankCode = this.createSogiPlusKaimyoRankCode(pSrthPlanCode, pKaimyoCode);
        String thePlanKaimyoShohinCode = 
            BindingSogiAndKaimyoRankToShohinCode.get( theSogiPlusKaimyoRankCode  ).ShohinCode;
        if( !String.isBlank(thePlanKaimyoShohinCode) ) theShohinCodes.add( thePlanKaimyoShohinCode );

        String theMakurakyoShohinCode = BindingMakurakyoToShohinCode.get(pMakurakyoCode).ShohinCode;
        if( !String.isBlank(theMakurakyoShohinCode) ) theShohinCodes.add( theMakurakyoShohinCode );

        return theShohinCodes;
    }
}