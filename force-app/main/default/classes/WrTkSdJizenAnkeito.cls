public class WrTkSdJizenAnkeito implements WrTkSds.IWrTkSeido, WrTkSbgMaps.IShohinBangoMap{

    public WrTkSds.WaribikiSeidoCodes waribikiSeidoCode(){ return WrTkSds.WaribikiSeidoCodes.JizenAnkeito; }

    public Boolean isContextMatch( WrTkCtxs.ContextData pContext, String pShohinBango ){
		if( !this.m_shohinToWaribiki.containsKey(pShohinBango) ) return false;
		Boolean isJizenJunbi = false;
		if(pContext.sodanshaJizenJunbiDate != null) isJizenJunbi = true;
		if(pContext.taishoshaJizenJunbiDate != null) isJizenJunbi = true;

		return isJizenJunbi;
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
        'SBG-0005001' => new Set<String>{ 'SBG-0005106' }, //【20.11】よりそう家族葬 一日プラン,	【20.11】よりそうお葬式 事前アンケート割
        'SBG-0005002' => new Set<String>{ 'SBG-0005106' }, //【20.11】よりそう家族葬 二日プラン,	【20.11】よりそうお葬式 事前アンケート割
        'SBG-0005003' => new Set<String>{ 'SBG-0005106' }, //【20.11】よりそう家族葬 華やかプラン,	【20.11】よりそうお葬式 事前アンケート割
        'SBG-0005004' => new Set<String>{ 'SBG-0005106' }, //【20.11】よりそう火葬式 直葬プラン,	【20.11】よりそうお葬式 事前アンケート割
		'SBG-0005005' => new Set<String>{ 'SBG-0005106' }, //【20.11】よりそう火葬式 標準プラン,	【20.11】よりそうお葬式 事前アンケート割
		'SBG-0005006' => new Set<String>{ 'SBG-0005106' }, //【20.12】よりそう家族葬 一日プラン,	【20.11】よりそうお葬式 事前アンケート割
		'SBG-0005007' => new Set<String>{ 'SBG-0005106' },  //【20.12】よりそう火葬式 直葬プラン,	【20.11】よりそうお葬式 事前アンケート割
		'SBG-0005009' => new Set<String>{ 'SBG-0005106' },  //【21.03】よりそう火葬式 シンプルプラン,	【20.11】よりそうお葬式 事前アンケート割
		'SBG-0005008' => new Set<String>{ 'SBG-0005106' }, //【20.12】よりそう家族葬 一日プラン,	【20.11】よりそうお葬式 事前アンケート割

		'SBG-0005010' => new Set<String>{ 'SBG-0005223' }, //【21.04】よりそう家族葬 一日プラン,	【21.04】よりそうお葬式 事前アンケート割
		'SBG-0005011' => new Set<String>{ 'SBG-0005223' }, //【21.04】よりそう家族葬 二日プラン,	【21.04】よりそうお葬式 事前アンケート割
		'SBG-0005012' => new Set<String>{ 'SBG-0005223' }, //【21.04】よりそう家族葬 華やかプラン,	【21.04】よりそうお葬式 事前アンケート割
		'SBG-0005013' => new Set<String>{ 'SBG-0005223' }, //【21.04】よりそう火葬式 シンプルプラン,	【21.04】よりそうお葬式 事前アンケート割
		'SBG-0005014' => new Set<String>{ 'SBG-0005223' }, //【21.04】よりそう火葬式 基本プラン,	【21.04】よりそうお葬式 事前アンケート割
		'SBG-0005015' => new Set<String>{ 'SBG-0005223' }, //【21.04】よりそう火葬式 仏具セットプラン,	【21.04】よりそうお葬式 事前アンケート割
		'SBG-0005016' => new Set<String>{ 'SBG-0005223' }  //【21.04】よりそう火葬式 お花セットプラン,	【21.04】よりそうお葬式 事前アンケート割
	};
}