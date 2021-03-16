public class WrTkSdKazoku2nichi implements WrTkSds.IWrTkSeido, WrTkSbgMaps.IShohinBangoMap{

    public WrTkSds.WaribikiSeidoCodes waribikiSeidoCode(){ return WrTkSds.WaribikiSeidoCodes.Kazoku2nichi; }

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
        if( pWaribikiSeidoCode == WrTkSds.WaribikiSeidoCodes.OldKazoku2nichi ) return true;
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
        'SBG-0005002' => new Set<String>{ 'SBG-0005102' } //【20.11】よりそう家族葬 二日プラン,	【20.11】よりそう会員割 (家族葬 二日プラン)
    };
}