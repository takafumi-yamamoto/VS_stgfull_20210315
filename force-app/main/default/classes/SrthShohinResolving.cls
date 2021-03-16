public class SrthShohinResolving {
	

// public interface

    public class ShohinLine{
        public String shohinCode = ''; //商品番号

        public ShohinLine(String shohinCode){
            this.shohinCode = shohinCode;
        }
    }    

    public class Request{
        public String riyokaisu; //利用回数区分
        public String hojiHoyo; //仏事
        public String kaimyoPlan = 'none'; //戒名 = | なし | 信士・信女 | 
        public String makurakyoCode = 'none'; //枕経 = | なし | 告別式前日 | ...

        public Request setRiyokaisu(String riyokaisu){
            this.riyokaisu = riyokaisu;
            return this;
        }
        public Request setHojiHoyo(String hojiHoyo){
            this.hojiHoyo = hojiHoyo;
            return this;
        }
        public Request setKaimyoPlan(String kaimyoPlan){
            this.kaimyoPlan = kaimyoPlan;
            return this;
        }
        public Request setMakurakyoCode(String makurakyoCode){
            this.makurakyoCode = makurakyoCode;
            return this;
        }
    }

    public List<ShohinLine> getShohinLines(Request req){

        if( String.isBlank(req.kaimyoPlan) ) req.kaimyoPlan = 'none';
        

        List<ShohinLine> lines = new List<ShohinLine>();
        Set<String> theShohinCodes = new Set<String>();
        if(this.isSougiDokyou(req.hojiHoyo)){ 
            
            theShohinCodes = this.getShohinCodes(
                this.getSogiCode(req.hojiHoyo) , this.getKaimyoCode(req.kaimyoPlan), req.makurakyoCode
            );
        } else {

            if( req.hojiHoyo != '戒名・法名のみ' ){
                // 初回商品　OR　二回目　移行商品を追加
                theShohinCodes.add( req.riyokaisu == '初めて' ? 'SBG-0000038' : 'SBG-0000039' );
            }

            // 戒名商品を追加
            if(KaimyoPlanToKaimyoCodeMap.containsKey(req.kaimyoPlan)){
                theShohinCodes.addAll( this.getShohinCodes(
                    'none' , this.getKaimyoCode(req.kaimyoPlan), req.makurakyoCode
                ));
            }
        }

        for(String code : theShohinCodes){
            lines.add(new ShohinLine(code));
        }

        return lines;
    }

// kaimyo mapping
    private static List<String> kaimyoPlans = new List<String>{
        '釋・釋尼',
        '院釋・釋尼',
        '信士・信女',
        '院信士・院信女',
        '院日信士・院日信女',
        '居士・大姉',
        '院居士・院大姉',
        'none','none'
    };

    private static final Map<String, String> KaimyoPlanToKaimyoCodeMap = new Map<String, String>{
        '釋・釋尼'     =>'釋',
        '院釋・釋尼'     =>'院釋',
        '信士・信女'     =>'信士',
        '院信士・院信女'     =>'院信士',
        '院日信士・院日信女'     =>'院日信士',
        '居士・大姉'     =>'居士',
        '院居士・院大姉'     =>'院居士',
        'none' => 'none'
    };
    private String getKaimyoCode(String kaimyoPlan){
        return KaimyoPlanToKaimyoCodeMap.get(kaimyoPlan);
    }

    private static List<String> kaimyoCodes = new List<String>{
        '釋','釋尼',
        '信士','信女',
        '居士','大姉',
        '院釋','院釋尼',
        '院信士','院信女',
        '院日信士','院日信女',
        '院居士','院大姉',
        'none'
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

    private static Set<String> KaimyoRanks = new Set<String>{
        '釋|釋尼',
        '信士|信女',
        '居士|大姉',
        '院釋|院釋尼',
        '院信士|院信女',
        '院日信士|院日信女',
        '院居士|院大姉'
    };

// sogi mapping
    private static Set<String> SogiCodes = new Set<String>{
        'kaso',
        'ichinichi',
        'ippan'
    };

    private static final Map<String, String> HojiHoyoToSogiCodeMap = new Map<String, String>{
        '火葬式' => 'kaso'
        ,'一日葬' => 'ichinichi'
        ,'一般葬' => 'ippan'
    };
    private String getSogiCode(String hojiHoyo){
        return HojiHoyoToSogiCodeMap.get(hojiHoyo);
    }    
    private Boolean isSougiDokyou(String hojiHoyo){
        return HojiHoyoToSogiCodeMap.containsKey(hojiHoyo);
    }

//商品コードマッピング


    private Set<String> getShohinCodes(String pSogiCode, String pKaimyoCode, String pMakurakyoCode){
        Set<String> theShohinCodes = new Set<String>();
        

        String theSogiPlusKaimyoRankCode = this.createSogiPlusKaimyoRankCode(pSogiCode, pKaimyoCode);
        String thePlanKaimyoShohinCode = 
            BindingSogiAndKaimyoRankToShohinCode.get( theSogiPlusKaimyoRankCode  ).ShohinCode;
        if( !String.isBlank(thePlanKaimyoShohinCode) ) theShohinCodes.add( thePlanKaimyoShohinCode );

        String theMakurakyoShohinCode = BindingMakurakyoToShohinCode.get(pMakurakyoCode).ShohinCode;
        if( !String.isBlank(theMakurakyoShohinCode) ) theShohinCodes.add( theMakurakyoShohinCode );

        return theShohinCodes;
    }

    private String createSogiPlusKaimyoRankCode(String pSogi, String pKaimyo){
        String theKaimyoRank = BindingKaimyoToKaimyoRank.get(pKaimyo);
        return 
            String.Format('{0}+{1}', new List<String>{
                pSogi == null ? 'none' : pSogi,
                theKaimyoRank == null ? 'none' : theKaimyoRank
            });
    }

    private class ShohinCodeEntry{
        public ShohinCodeEntry(String pShohinCode){this.ShohinCode = pShohinCode; }
        String ShohinCode = ''; 
    }


    private static Map<String,ShohinCodeEntry> BindingSogiAndKaimyoRankToShohinCode = new Map<String,ShohinCodeEntry>{
        'kaso+none' => new ShohinCodeEntry('SBG-0000046'),
        'ichinichi+none' => new ShohinCodeEntry('SBG-0000047'),
        'ippan+none' => new ShohinCodeEntry('SBG-0000048'),
        'none+釋|釋尼' => new ShohinCodeEntry('SBG-0000060'),
        'none+院釋|院釋尼' => new ShohinCodeEntry('SBG-0000064'),
        'none+信士|信女' => new ShohinCodeEntry('SBG-0000061'),
        'none+居士|大姉' => new ShohinCodeEntry('SBG-0000063'),
        'none+院信士|院信女' => new ShohinCodeEntry('SBG-0000062'),
        'none+院日信士|院日信女' => new ShohinCodeEntry('SBG-0000065'),
        'none+院居士|院大姉' => new ShohinCodeEntry('SBG-0000066'),
        'kaso+釋|釋尼' => new ShohinCodeEntry('SBG-0000225'),
        'kaso+院釋|院釋尼' => new ShohinCodeEntry('SBG-0000226'),
        'kaso+信士|信女' => new ShohinCodeEntry('SBG-0000227'),
        'kaso+居士|大姉' => new ShohinCodeEntry('SBG-0000228'),
        'kaso+院信士|院信女' => new ShohinCodeEntry('SBG-0000229'),
        'kaso+院日信士|院日信女' => new ShohinCodeEntry('SBG-0000230'),
        'kaso+院居士|院大姉' => new ShohinCodeEntry('SBG-0000231'),
        'ichinichi+釋|釋尼' => new ShohinCodeEntry('SBG-0000232'),
        'ichinichi+院釋|院釋尼' => new ShohinCodeEntry('SBG-0000233'),
        'ichinichi+信士|信女' => new ShohinCodeEntry('SBG-0000234'),
        'ichinichi+居士|大姉' => new ShohinCodeEntry('SBG-0000235'),
        'ichinichi+院信士|院信女' => new ShohinCodeEntry('SBG-0000236'),
        'ichinichi+院日信士|院日信女' => new ShohinCodeEntry('SBG-0000237'),
        'ichinichi+院居士|院大姉' => new ShohinCodeEntry('SBG-0000238'),
        'ippan+釋|釋尼' => new ShohinCodeEntry('SBG-0000239'),
        'ippan+院釋|院釋尼' => new ShohinCodeEntry('SBG-0000240'),
        'ippan+信士|信女' => new ShohinCodeEntry('SBG-0000241'),
        'ippan+居士|大姉' => new ShohinCodeEntry('SBG-0000242'),
        'ippan+院信士|院信女' => new ShohinCodeEntry('SBG-0000243'),
        'ippan+院日信士|院日信女' => new ShohinCodeEntry('SBG-0000244'),
        'ippan+院居士|院大姉' => new ShohinCodeEntry('SBG-0000245'),
        'none+none' => new ShohinCodeEntry('')
    };

    private static Map<String,ShohinCodeEntry> BindingMakurakyoToShohinCode = new Map<String,ShohinCodeEntry>{
        'kokubetsu_zenzitsu' => new ShohinCodeEntry('SBG-0000055'),
        'kokubetsu_toujitsu' => new ShohinCodeEntry('SBG-0000056'),
        'tsuya_zenzitsu' => new ShohinCodeEntry('SBG-0000055'),
        'tsuya_toujitsu' => new ShohinCodeEntry('SBG-0000056'),
        'kasoshiki' => new ShohinCodeEntry('SBG-0000045'),
        'none' => new ShohinCodeEntry('')
    };

}