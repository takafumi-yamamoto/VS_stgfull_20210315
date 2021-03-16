public class WrTkSdKazoku1nichiTokubetsuKakaku implements WrTkSds.IWrTkSeido, WrTkSbgMaps.IShohinBangoMap{

    public WrTkSds.WaribikiSeidoCodes waribikiSeidoCode(){ return WrTkSds.WaribikiSeidoCodes.Kazoku1nichiTokubetsuKakaku; }

    public Boolean isContextMatch( WrTkCtxs.ContextData pContext, String pShohinBango ){
        return true;
    }

    public Boolean existsHeiyoRiyoNg( List<WrTkSds.WaribikiSeidoCodes> pWaribikiSeidoCodes ){
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
        'SBG-0005001' => new Set<String>{ 'SBG-0005187' } //【20.11】よりそう家族葬 一日プラン,	【20.11】よりそう家族葬 一日プラン 特別割引 特別価格調整金額
    };
}