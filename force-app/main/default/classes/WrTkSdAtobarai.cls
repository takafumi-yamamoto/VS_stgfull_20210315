public class WrTkSdAtobarai implements WrTkSds.IWrTkSeido, WrTkSbgMaps.IShohinBangoMap{

	public WrTkSds.WaribikiSeidoCodes waribikiSeidoCode(){ return WrTkSds.WaribikiSeidoCodes.Atobarai; }

	public Boolean isContextMatch( WrTkCtxs.ContextData pContext, String pShohinBango ){
		if( !this.m_shohinToWaribiki.containsKey(pShohinBango) ) return false;
		if(pContext.kiboShiharaiHouhou == '後払い（GMO）') return true;
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
		'SBG-0003001' => new Set<String>{ 'SBG-0002010' }, //【19.12】よりそうのお葬式 火葬式 直葬プラン,			よりそうのお葬式 後払いご利用料金
		'SBG-0004001' => new Set<String>{ 'SBG-0002010' }, //【19.12】よりそうのお葬式 火葬式 直葬プラン,			よりそうのお葬式 後払いご利用料金
		'SBG-0003002' => new Set<String>{ 'SBG-0002010' }, //【19.12】よりそうのお葬式 火葬式 無宗教プラン,		よりそうのお葬式 後払いご利用料金
		'SBG-0003003' => new Set<String>{ 'SBG-0002010' }, //【19.12】よりそうのお葬式 火葬式 仏式プラン,			よりそうのお葬式 後払いご利用料金
		'SBG-0003004' => new Set<String>{ 'SBG-0002010' }, //【19.12】よりそうのお葬式 火葬式 花束プラン,			よりそうのお葬式 後払いご利用料金
		'SBG-0003005' => new Set<String>{ 'SBG-0002010' }, //【19.12】よりそうのお葬式 一日葬 無宗教プラン,		よりそうのお葬式 後払いご利用料金
		'SBG-0003006' => new Set<String>{ 'SBG-0002010' }, //【19.12】よりそうのお葬式 一日葬 仏式プラン,			よりそうのお葬式 後払いご利用料金
		'SBG-0003007' => new Set<String>{ 'SBG-0002010' }, //【19.12】よりそうのお葬式 一日葬 お花増量プラン,		よりそうのお葬式 後払いご利用料金
		'SBG-0003008' => new Set<String>{ 'SBG-0002010' }, //【19.12】よりそうのお葬式 家族葬 無宗教プラン,		よりそうのお葬式 後払いご利用料金
		'SBG-0003009' => new Set<String>{ 'SBG-0002010' }, //【19.12】よりそうのお葬式 家族葬 仏式プラン,			よりそうのお葬式 後払いご利用料金
		'SBG-0003010' => new Set<String>{ 'SBG-0002010' }, //【19.12】よりそうのお葬式 家族葬 お花増量プラン,		よりそうのお葬式 後払いご利用料金
		'SBG-0003011' => new Set<String>{ 'SBG-0002010' }, //【19.12】よりそうのお葬式 一般葬 無宗教プラン,		よりそうのお葬式 後払いご利用料金
		'SBG-0003012' => new Set<String>{ 'SBG-0002010' }, //【19.12】よりそうのお葬式 一般葬 仏式プラン,			よりそうのお葬式 後払いご利用料金
		'SBG-0003013' => new Set<String>{ 'SBG-0002010' }, //【19.12】よりそうのお葬式 一般葬 お花増量プラン,		よりそうのお葬式 後払いご利用料金
		'SBG-0003103' => new Set<String>{ 'SBG-0002011' }, //【19.12】お花いっぱいのお葬式 一日葬 無宗教プラン,	お花いっぱいのお葬式 後払いご利用料金
		'SBG-0003104' => new Set<String>{ 'SBG-0002011' }, //【19.12】お花いっぱいのお葬式 一日葬 仏式プラン,		お花いっぱいのお葬式 後払いご利用料金
		'SBG-0003105' => new Set<String>{ 'SBG-0002011' }, //【19.12】お花いっぱいのお葬式 一日葬 お花増量プラン,	お花いっぱいのお葬式 後払いご利用料金
		'SBG-0003106' => new Set<String>{ 'SBG-0002011' }, //【19.12】お花いっぱいのお葬式 家族葬 無宗教プラン,	お花いっぱいのお葬式 後払いご利用料金
		'SBG-0003107' => new Set<String>{ 'SBG-0002011' }, //【19.12】お花いっぱいのお葬式 家族葬 仏式プラン,		お花いっぱいのお葬式 後払いご利用料金
		'SBG-0003108' => new Set<String>{ 'SBG-0002011' }, //【19.12】お花いっぱいのお葬式 家族葬 お花増量プラン,	お花いっぱいのお葬式 後払いご利用料金
		'SBG-0005001' => new Set<String>{ 'SBG-0002010' }, //【20.11】よりそう家族葬 一日プラン,	よりそうお葬式 後払いご利用料金
        'SBG-0005002' => new Set<String>{ 'SBG-0002010' }, //【20.11】よりそう家族葬 二日プラン,	よりそうお葬式 後払いご利用料金
        'SBG-0005003' => new Set<String>{ 'SBG-0002010' }, //【20.11】よりそう家族葬 華やかプラン,	よりそうお葬式 後払いご利用料金
        'SBG-0005004' => new Set<String>{ 'SBG-0002010' }, //【20.11】よりそう火葬式 直葬プラン,	よりそうお葬式 後払いご利用料金
		'SBG-0005005' => new Set<String>{ 'SBG-0002010' }, //【20.11】よりそう火葬式 標準プラン,	よりそうお葬式 後払いご利用料金
		'SBG-0005006' => new Set<String>{ 'SBG-0002010' }, //【20.12】よりそう家族葬 一日プラン,	よりそうお葬式 後払いご利用料金
		'SBG-0005007' => new Set<String>{ 'SBG-0002010' },  //【20.12】よりそう火葬式 直葬プラン,	よりそうお葬式 後払いご利用料金
		'SBG-0005009' => new Set<String>{ 'SBG-0002010' },  //【21.03】よりそう火葬式 直葬Liteプラン, よりそうお葬式 後払いご利用料金
		'SBG-0005008' => new Set<String>{ 'SBG-0002010' } //【21.03】よりそう家族葬 一日プラン,	よりそうお葬式 後払いご利用料金
	};
}