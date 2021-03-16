public class WrTkSdButsuguNashi implements WrTkSds.IWrTkSeido, WrTkSbgMaps.IShohinBangoMap{

    public WrTkSds.WaribikiSeidoCodes waribikiSeidoCode(){ return WrTkSds.WaribikiSeidoCodes.ButsugiNashi; }

    public Boolean isContextMatch( WrTkCtxs.ContextData pContext, String pShohinBango ){
        if( !this.m_shohinToWaribiki.containsKey(pShohinBango) ) return false;

        Boolean isButsuguNashi = false;
        if(pContext.butsuguNashiKibo == '仏具なし') isButsuguNashi = true;
        //if(pContext.butsuguNashiKibo) isButsuguNashi = true;

        return isButsuguNashi;
    }

    public Boolean existsHeiyoRiyoNg( List<WrTkSds.WaribikiSeidoCodes> pWaribikiSeidoCodes ){
        Boolean isNg = false;
        for(WrTkSds.WaribikiSeidoCodes aSeidoCode : pWaribikiSeidoCodes){
            if( this.isHeiyoRiyoNg(aSeidoCode) ){ isNg = true; break; }
        }
        return isNg;
    }
    
    private Boolean isHeiyoRiyoNg( WrTkSds.WaribikiSeidoCodes pWaribikiSeidoCode ){
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
        'SBG-0005001' => new Set<String>{ 'SBG-0005108' }, //【20.11】よりそう家族葬 一日プラン,    【20.11】よりそうお葬式 仏具なし割引
        'SBG-0005002' => new Set<String>{ 'SBG-0005108' }, //【20.11】よりそう家族葬 二日プラン,    【20.11】よりそうお葬式 仏具なし割引
        'SBG-0005003' => new Set<String>{ 'SBG-0005108' }, //【20.11】よりそう家族葬 華やかプラン,  【20.11】よりそうお葬式 仏具なし割引
        'SBG-0005005' => new Set<String>{ 'SBG-0005108' }, //【20.11】よりそう火葬式 標準プラン,    【20.11】よりそうお葬式 仏具なし割引
        'SBG-0005006' => new Set<String>{ 'SBG-0005108' }, //【20.12】よりそう家族葬 一日プラン,    【20.11】よりそうお葬式 仏具なし割引
        'SBG-0005008' => new Set<String>{ 'SBG-0005108' }, //【21.03】よりそう家族葬 一日プラン,    【20.11】よりそうお葬式 仏具なし割引
        'SBG-0005010' => new Set<String>{ 'SBG-0005225' }, //【21.04】よりそう家族葬 一日プラン,    【21.04】よりそうお葬式 仏具なし割引
        'SBG-0005011' => new Set<String>{ 'SBG-0005225' }, //【21.04】よりそう家族葬 二日プラン,    【21.04】よりそうお葬式 仏具なし割引
        'SBG-0005012' => new Set<String>{ 'SBG-0005225' }  //【21.04】よりそう家族葬 華やかプラン,    【21.04】よりそうお葬式 仏具なし割引
    };
}