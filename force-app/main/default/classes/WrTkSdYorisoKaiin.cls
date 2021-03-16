public  class WrTkSdYorisoKaiin implements WrTkSds.IWrTkSeido, WrTkSbgMaps.IShohinBangoMap {
    
    public WrTkSds.WaribikiSeidoCodes waribikiSeidoCode(){ return WrTkSds.WaribikiSeidoCodes.YorisoKaiin; }

    public Boolean isContextMatch( WrTkCtxs.ContextData pContext, String pShohinBango ){
        if( !this.m_shohinToWaribiki.containsKey(pShohinBango) ) return false;
        if( pContext.sodanshaMemberKubun == 'YorisoKaiin' || pContext.taishoshaMemberKubun == 'YorisoKaiin' ) return true;
        return false;
    }

    public Boolean existsHeiyoRiyoNg( List<WrTkSds.WaribikiSeidoCodes> pWaribikiSeidoCodes ){
        Boolean isNg = false;
        for(WrTkSds.WaribikiSeidoCodes aSeidoCode : pWaribikiSeidoCodes){
            if( this.isHeiyoRiyoNg(aSeidoCode) ){ isNg = true; break; }
        }
        return isNg;
    }
    
    private Boolean isHeiyoRiyoNg( WrTkSds.WaribikiSeidoCodes pWaribikiSeidoCode ){
        if( pWaribikiSeidoCode == WrTkSds.WaribikiSeidoCodes.OsoshikiYoyaku ) return true;
        if( pWaribikiSeidoCode == WrTkSds.WaribikiSeidoCodes.OldYorisoKaiin ) return true;
        return false;
    }

    public Set<String> getWaribikiShohinBangos(String pShohinBango){
        Set<String> theWaribikiShohinBangos = new Set<String>();
        if( !this.m_shohinToWaribiki.containsKey(pShohinBango) ) return theWaribikiShohinBangos;

        for( String aWaribikiShohinBango : this.m_shohinToWaribiki.get(pShohinBango) ){
            theWaribikiShohinBangos.add(aWaribikiShohinBango);
        }
        return theWaribikiShohinBangos;
    }

    public Map<String, Set<String>> getShohinBangoMap(){
        Map<String, Set<String>> theMapping = new Map<String, Set<String>>();
        for( String aKey : this.m_shohinToWaribiki.keySet() ){
            theMapping.put( aKey, new Set<String>() );
            theMapping.get( aKey ).addAll( this.m_shohinToWaribiki.get(aKey) );
        }
        return theMapping;
    }
    private Map<String, Set<String>> m_shohinToWaribiki = new Map<String, Set<String>>{
        'SBG-0005001' => new Set<String>{ 'SBG-0005101' }, //【20.11】よりそう家族葬 一日プラン,	【20.11】よりそう会員割 (家族葬 一日プラン)
        'SBG-0005006' => new Set<String>{ 'SBG-0005101' },  //【20.12】よりそう家族葬 一日プラン,	【20.11】よりそう会員割 (家族葬 一日プラン)
        'SBG-0005002' => new Set<String>{ 'SBG-0005102' }, //【20.11】よりそう家族葬 二日プラン,	【20.11】よりそう会員割 (家族葬 二日プラン)
        'SBG-0005003' => new Set<String>{ 'SBG-0005103' }, //【20.11】よりそう家族葬 華やかプラン, 【20.11】よりそう会員割 (家族葬 華やかプラン)
        'SBG-0005004' => new Set<String>{ 'SBG-0005104' }, //【20.11】よりそう火葬式 直葬プラン, 【20.11】よりそう会員割 (火葬式 直葬プラン)
        'SBG-0005007' => new Set<String>{ 'SBG-0005104' },  //【20.12】よりそう火葬式 直葬プラン, 【20.11】よりそう会員割 (火葬式 直葬プラン)
        'SBG-0005005' => new Set<String>{ 'SBG-0005105' }, //【20.11】よりそう火葬式 標準プラン, 【20.11】よりそう会員割 (火葬式 標準プラン)
        'SBG-0005009' => new Set<String>{ 'SBG-0005104' },  //【21.03】よりそう火葬式 直葬Liteプラン, 【20.11】よりそう会員割 (火葬式 直葬プラン)
        'SBG-0005008' => new Set<String>{ 'SBG-0005101' },  //【20.11】よりそう家族葬 一日プラン,	     【20.11】よりそう会員割 (家族葬 一日プラン)

        'SBG-0005013' => new Set<String>{ 'SBG-0005219' }, //【21.04】よりそう火葬式 シンプルプラン,	 【21.04】よりそう会員割 (火葬式 シンプルプラン)
        'SBG-0005014' => new Set<String>{ 'SBG-0005220' }, //【21.04】よりそう火葬式 基本プラン,         【21.04】よりそう会員割 (火葬式 基本プラン)
        'SBG-0005015' => new Set<String>{ 'SBG-0005221' },//【21.04】よりそう火葬式 仏具セットプラン,     【21.04】よりそう会員割 (火葬式 仏具セットプラン)
        'SBG-0005016' => new Set<String>{ 'SBG-0005222' }, // 【21.04】よりそう火葬式 お花セットプラン,    【21.04】よりそう会員割 (火葬式 お花セットプラン)
        'SBG-0005010' => new Set<String>{ 'SBG-0005216' }, // 【21.04】よりそう家族葬 一日プラン, 【21.04】よりそう会員割 (家族葬 一日プラン)
        'SBG-0005011' => new Set<String>{ 'SBG-0005217' }, // 【21.04】よりそう家族葬 二日プラン,【21.04】よりそう会員割 (家族葬 二日プラン)
        'SBG-0005012' => new Set<String>{ 'SBG-0005218' } // 【21.04】よりそう家族葬 華やかプラン,【21.04】よりそう会員割 (家族葬 華やかプラン)
    };
}