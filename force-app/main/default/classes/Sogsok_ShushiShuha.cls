public class Sogsok_ShushiShuha {

    private static Map<String, String> shushis = new Map<String, String>{
        '浄土真宗' => '浄土真宗',
        '真宗' => '真宗',
        '曹洞宗' => '曹洞宗',
        '真言宗' => '真言宗',
        '高野山真言宗' => '高野山真言宗',
        '日蓮宗' => '日蓮宗',
        '浄土宗' => '浄土宗',
        '西山浄土宗' => '西山浄土宗',
        '天台宗' => '天台宗',
        '臨済宗' => '臨済宗',
        '禅宗' => '禅宗',
        'こだわりなし' => 'こだわりなし',
        '今の時点でわからない' => '今の時点でわからない',
        'その他' => 'その他'
    };
    public static String tryGetShushiLabel( String pKey, String pNotFoundValue){
        return shushis.containsKey(pKey) ? shushis.get(pKey) : pNotFoundValue;
    }

    private static Map<String, String> shuhas = new Map<String, String>{
        '浄土真宗_本願寺派' => '本願寺派',
        '浄土真宗_木辺派' => '木辺派',
        '浄土真宗_興正派' => '興正派',
        '浄土真宗_高田派' => '高田派',
        '浄土真宗_東本願寺派' => '東本願寺派',
        '浄土真宗_仏光寺派' => '仏光寺派',
        '浄土真宗_こだわりなし' => 'こだわりなし',
        '真宗_大谷派' => '大谷派',
        '曹洞宗_宗派なし' => '',
        '真言宗_豊山派' => '豊山派',
        '真言宗_智山派' => '智山派',
        '真言宗_こだわりなし' => 'こだわりなし',
        '高野山真言宗_宗派なし' => '',
        '日蓮宗_宗派なし' => '',
        '浄土宗_宗派なし' => '',
        '西山浄土宗_宗派なし' => '',
        '天台宗_宗派なし' => '',
        '臨済宗_妙心寺派' => '妙心寺派',
        '臨済宗_こだわりなし' => 'こだわりなし',
        '禅宗_宗派なし' => '',
        'こだわりなし_宗派なし' => '',
        '今の時点でわからない_宗派なし' => '',
        'その他_宗派なし' => ''
    };
    public static String tryGetShuhaLabel( String pKey, String pNotFoundValue){
        return shuhas.containsKey(pKey) ? shuhas.get(pKey) : pNotFoundValue;
    }

    public static Map<String, Set<String>> shushiShuhas = new Map<String, Set<String>>{
        '浄土真宗' => 
            new Set<String>{
                '浄土真宗_本願寺派',
                '浄土真宗_木辺派',
                '浄土真宗_興正派',
                '浄土真宗_高田派',
                '浄土真宗_東本願寺派',
                '浄土真宗_仏光寺派',
                '浄土真宗_こだわりなし'
            },
        '真宗' => 
            new Set<String>{'真宗_大谷派'},
        '曹洞宗' => 
            new Set<String>{'曹洞宗_宗派なし'},
        '真言宗' => 
            new Set<String>{
                '真言宗_豊山派', 
                '真言宗_智山派', 
                '真言宗_こだわりなし'
            },
        '高野山真言宗' => 
            new Set<String>{'高野山真言宗_宗派なし'},
        '日蓮宗' => 
            new Set<String>{'日蓮宗_宗派なし'},
        '浄土宗' => 
            new Set<String>{'浄土宗_宗派なし'},
        '西山浄土宗' => 
            new Set<String>{'西山浄土宗_宗派なし'},
        '天台宗' => 
            new Set<String>{'天台宗_宗派なし'},
        '臨済宗' => 
            new Set<String>{
                '臨済宗_こだわりなし',
                '臨済宗_妙心寺派'
            },
        '禅宗' => 
            new Set<String>{ '禅宗_宗派なし' },
        'こだわりなし' => 
            new Set<String>{ 'こだわりなし_宗派なし' },
        '今の時点でわからない' => 
            new Set<String>{ '今の時点でわからない_宗派なし' },
        'その他' => 
            new Set<String>{ 'その他_宗派なし' }
    };
    private static String tryGetShushiFromShuha(String pShuha, String pNotFoundValue){
        Map<String, Set<String>> theShushiShuhas = shushiShuhas;
        for(String aShushi : shushiShuhas.keySet() ){
            if( shushiShuhas.get(aShushi).contains(pShuha) ) return aShushi;
        }
        return pNotFoundValue;
    }

    public static Map<String, String> bindCustomerAccountShuhaToShuha = new Map<String,String>{
        '浄土真宗本願寺派' => '浄土真宗_本願寺派',
        '浄土真宗本願寺派（西）' => '浄土真宗_本願寺派',
        '浄土真宗（本願寺派・西）' => '浄土真宗_本願寺派' ,
        '浄土真宗木辺派' => '浄土真宗_木辺派',
        '浄土真宗興正派' => '浄土真宗_興正派',
        '浄土真宗高田派' => '浄土真宗_高田派',
        '浄土真宗東本願寺派' => '浄土真宗_東本願寺派',
        '浄土真宗仏光寺派' => '浄土真宗_仏光寺派',
        '浄土真宗(こだわりなし)' => '浄土真宗_こだわりなし',
        '浄土真宗（大谷派・東）' => '真宗_大谷派',
        '真宗大谷派' => '真宗_大谷派',
        '真宗大谷派（東）' => '真宗_大谷派',
        '曹洞宗' => '曹洞宗_宗派なし',
        '真言宗豊山派' => '真言宗_豊山派',
        '真言宗智山派' => '真言宗_智山派',
        '真言宗' => '真言宗_こだわりなし',
        '真言宗（こだわりなし）' => '真言宗_こだわりなし',
        '高野山真言宗' => '高野山真言宗_宗派なし',
        '日蓮宗' => '日蓮宗_宗派なし',
        '浄土宗' => '浄土宗_宗派なし',
        '浄土宗（こだわりなし）' => '浄土宗_宗派なし',
        '西山浄土宗' => '西山浄土宗_宗派なし',
        '天台宗' => '天台宗_宗派なし',
        '臨済宗' => '臨済宗_こだわりなし',
        '臨済宗妙心寺派' => '臨済宗_妙心寺派',
        '禅宗' => '禅宗_宗派なし',
        '日蓮正宗' => 'その他_宗派なし',
        '法華宗本門流' => 'その他_宗派なし',
        '法華宗' => 'その他_宗派なし',
        'こだわりなし' => 'こだわりなし_宗派なし',
        '今の時点でわからない' => '今の時点でわからない_宗派なし',
        'その他' => 'その他_宗派なし'
    };
    public static String tryGetShuhaFromCustomerAccountShuha(String pShuha, String pNotFoundValue){
        Map<String, String> theBindCustomerAccountShuhaToShuha = bindCustomerAccountShuhaToShuha;
        return theBindCustomerAccountShuhaToShuha.containsKey(pShuha) 
            ? theBindCustomerAccountShuhaToShuha.get(pShuha)
            : pNotFoundValue
            ;
    }
    public static String tryGetShushiFromCustomerAccountShuha(String pShuha, String pNotFoundValue){
        String theShuha = tryGetShuhaFromCustomerAccountShuha(pShuha, null);
        if(theShuha == null) return pNotFoundValue;
        String theShushi = tryGetShushiFromShuha( theShuha , pNotFoundValue );
        return theShushi;
    }

    public static Map<String, String> bindShuhaToCustomerAccountShuha = new Map<String,String>{
        '浄土真宗_本願寺派' => '浄土真宗本願寺派',
        '浄土真宗_木辺派' => '浄土真宗木辺派',
        '浄土真宗_興正派' => '浄土真宗興正派',
        '浄土真宗_高田派' => '浄土真宗高田派',
        '浄土真宗_東本願寺派' => '浄土真宗東本願寺派',
        '浄土真宗_仏光寺派' => '浄土真宗仏光寺派',
        '浄土真宗_こだわりなし' => '浄土真宗(こだわりなし)',
        '真宗_大谷派' => '真宗大谷派',
        '曹洞宗_宗派なし' => '曹洞宗',
        '真言宗_豊山派' => '真言宗豊山派',
        '真言宗_智山派' => '真言宗智山派',
        '真言宗_こだわりなし' => '真言宗（こだわりなし）',
        '高野山真言宗_宗派なし' => '高野山真言宗',
        '日蓮宗_宗派なし' => '日蓮宗',
        '浄土宗_宗派なし' => '浄土宗',
        '西山浄土宗_宗派なし' => '西山浄土宗',
        '天台宗_宗派なし' => '天台宗',
        '臨済宗_こだわりなし' => '臨済宗',
        '臨済宗_妙心寺派' => '臨済宗妙心寺派',
        '禅宗_宗派なし' => '禅宗',
        'こだわりなし_宗派なし' => 'こだわりなし',
        '今の時点でわからない_宗派なし' => '今の時点でわからない',
        'その他_宗派なし' => 'その他'
    };
    public static String tryGetCustomerAccountShuhaFromShuha(String pShuha, String pNotFoundValue){
        Map<String, String> thebindShuhaToCustomerAccountShuha = bindShuhaToCustomerAccountShuha;
        return thebindShuhaToCustomerAccountShuha.containsKey(pShuha) 
            ? thebindShuhaToCustomerAccountShuha.get(pShuha)
            : pNotFoundValue
            ;
    }
}