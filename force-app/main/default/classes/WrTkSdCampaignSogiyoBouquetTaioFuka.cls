public class WrTkSdCampaignSogiyoBouquetTaioFuka implements WrTkSds.IWrTkSeido, WrTkSbgMaps.IShohinBangoMap{

    public WrTkSds.WaribikiSeidoCodes waribikiSeidoCode(){ return WrTkSds.WaribikiSeidoCodes.CampaignSogiyoBouquetTaioFuka; }

    public Boolean isContextMatch( WrTkCtxs.ContextData pContext, String pShohinBango ){
        
        if( !this.m_shohinToWaribiki.containsKey(pShohinBango) ) return false;
        return pContext.campaignSogiBouquetAchievement && pContext.campaignSogiBouquetTaio == '対応不可';
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
        'SBG-0005001' => new Set<String>{ 'SBG-0000214' }, //【20.11】よりそう家族葬 一日プラン,	その他お客様向け割引（CS起因）
        'SBG-0005002' => new Set<String>{ 'SBG-0000214' }, //【20.11】よりそう家族葬 二日プラン,	その他お客様向け割引（CS起因）
        'SBG-0005003' => new Set<String>{ 'SBG-0000214' }, //【20.11】よりそう家族葬 華やかプラン,	その他お客様向け割引（CS起因）
        'SBG-0005006' => new Set<String>{ 'SBG-0000214' }, //【20.12】よりそう家族葬 一日プラン,	その他お客様向け割引（CS起因）
        'SBG-0005008' => new Set<String>{ 'SBG-0000214' }, //【20.12】よりそう家族葬 一日プラン,	その他お客様向け割引（CS起因）
        'SBG-0005010' => new Set<String>{ 'SBG-0000214' }, //【21.04】よりそう家族葬 一日プラン,	その他お客様向け割引（CS起因）
        'SBG-0005011' => new Set<String>{ 'SBG-0000214' }  //【21.04】よりそう家族葬 二日プラン,	その他お客様向け割引（CS起因）
    };
}