public class WrTkSdOldKasoChokuso implements WrTkSds.IWrTkSeido, WrTkSbgMaps.IShohinBangoMap{

    public WrTkSds.WaribikiSeidoCodes waribikiSeidoCode(){ return WrTkSds.WaribikiSeidoCodes.OldKasoChokuso; }

    public Boolean isContextMatch( WrTkCtxs.ContextData pContext, String pShohinBango ){
        if( !this.m_shohinToWaribiki.containsKey(pShohinBango) ) return false;
        if( pContext.sodanshaMemberKubun == 'OsoshikiYoyaku' || pContext.taishoshaMemberKubun == 'OsoshikiYoyaku' ) return true;
        if( pContext.sodanshaMemberKubun == 'Jizenwari' || pContext.taishoshaMemberKubun == 'Jizenwari' ) return true;
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
        'SBG-0005004' => new Set<String>{ 'SBG-0005112' }, //【20.11】よりそう火葬式 直葬プラン, 【20.11】旧事前割（2年）割引 (火葬式 直葬プラン)
        'SBG-0005007' => new Set<String>{ 'SBG-0005112' }  //【20.12】よりそう火葬式 直葬プラン, 【20.11】旧事前割（2年）割引 (火葬式 直葬プラン)
    };
}