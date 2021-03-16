public class WrTkSdJizenWari1Y implements WrTkSds.IWrTkSeido, WrTkSbgMaps.IShohinBangoMap{

	public WrTkSds.WaribikiSeidoCodes waribikiSeidoCode(){ return WrTkSds.WaribikiSeidoCodes.Jizenwari1Year; }

	public Boolean isContextMatch( WrTkCtxs.ContextData pContext, String pShohinBango ){
		if( !this.m_shohinToWaribiki.containsKey(pShohinBango) ) return false;

		Boolean iJizenMember = false;
		if(pContext.sodanshaMemberKubun == 'Jizenwari' || pContext.taishoshaMemberKubun == 'Jizenwari') iJizenMember = true;

		Boolean i1Y = false;
		if(pContext.sodanshaJizenwariKekaKikan == '1年～2年' || pContext.taishoshaJizenwariKekaKikan == '1年～2年') i1Y = true;

		return iJizenMember && i1Y;
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
		if( pWaribikiSeidoCode == WrTkSds.WaribikiSeidoCodes.PostalClub ) return true;
		if( pWaribikiSeidoCode == WrTkSds.WaribikiSeidoCodes.Jizenwari2Year ) return true;
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
		'SBG-0003001' => new Set<String>{ 'SBG-0003500' }, //【19.12】よりそうのお葬式 火葬式 直葬プラン,			【19.12】よりそうのお葬式 事前割メンバー割引 (直葬)
		'SBG-0004001' => new Set<String>{ 'SBG-0003500' }, //【19.12】よりそうのお葬式 火葬式 直葬プラン,			【19.12】よりそうのお葬式 事前割メンバー割引 (直葬)
		'SBG-0003002' => new Set<String>{ 'SBG-0003503' }, //【19.12】よりそうのお葬式 火葬式 無宗教プラン,		【19.12】よりそうのお葬式 事前割メンバー割引 (火葬式) (2年未満)
		'SBG-0003003' => new Set<String>{ 'SBG-0003503' }, //【19.12】よりそうのお葬式 火葬式 仏式プラン,			【19.12】よりそうのお葬式 事前割メンバー割引 (火葬式) (2年未満)
		'SBG-0003004' => new Set<String>{ 'SBG-0003503' }, //【19.12】よりそうのお葬式 火葬式 花束プラン,			【19.12】よりそうのお葬式 事前割メンバー割引 (火葬式) (2年未満)
		'SBG-0003005' => new Set<String>{ 'SBG-0003507' }, //【19.12】よりそうのお葬式 一日葬 無宗教プラン,		【19.12】よりそうのお葬式 事前割メンバー割引 (一日葬) (2年未満)
		'SBG-0003006' => new Set<String>{ 'SBG-0003507' }, //【19.12】よりそうのお葬式 一日葬 仏式プラン,			【19.12】よりそうのお葬式 事前割メンバー割引 (一日葬) (2年未満)
		'SBG-0003007' => new Set<String>{ 'SBG-0003507' }, //【19.12】よりそうのお葬式 一日葬 お花増量プラン,		【19.12】よりそうのお葬式 事前割メンバー割引 (一日葬) (2年未満)
		'SBG-0003008' => new Set<String>{ 'SBG-0003511' }, //【19.12】よりそうのお葬式 家族葬 無宗教プラン,		【19.12】よりそうのお葬式 事前割メンバー割引 (家族葬) (2年未満)
		'SBG-0003009' => new Set<String>{ 'SBG-0003511' }, //【19.12】よりそうのお葬式 家族葬 仏式プラン,			【19.12】よりそうのお葬式 事前割メンバー割引 (家族葬) (2年未満)
		'SBG-0003010' => new Set<String>{ 'SBG-0003511' }, //【19.12】よりそうのお葬式 家族葬 お花増量プラン,		【19.12】よりそうのお葬式 事前割メンバー割引 (家族葬) (2年未満)
		'SBG-0003011' => new Set<String>{ 'SBG-0003515' }, //【19.12】よりそうのお葬式 一般葬 無宗教プラン,		【19.12】よりそうのお葬式 事前割メンバー割引 (一般葬) (2年未満)
		'SBG-0003012' => new Set<String>{ 'SBG-0003515' }, //【19.12】よりそうのお葬式 一般葬 仏式プラン,			【19.12】よりそうのお葬式 事前割メンバー割引 (一般葬) (2年未満)
		'SBG-0003013' => new Set<String>{ 'SBG-0003515' }, //【19.12】よりそうのお葬式 一般葬 お花増量プラン,		【19.12】よりそうのお葬式 事前割メンバー割引 (一般葬) (2年未満)
		'SBG-0003103' => new Set<String>{ 'SBG-0003521' }, //【19.12】お花いっぱいのお葬式 一日葬 無宗教プラン,	【19.12】お花いっぱいのお葬式 事前割メンバー割引 (一日葬) (2年未満)
		'SBG-0003104' => new Set<String>{ 'SBG-0003521' }, //【19.12】お花いっぱいのお葬式 一日葬 仏式プラン,		【19.12】お花いっぱいのお葬式 事前割メンバー割引 (一日葬) (2年未満)
		'SBG-0003105' => new Set<String>{ 'SBG-0003521' }, //【19.12】お花いっぱいのお葬式 一日葬 お花増量プラン,	【19.12】お花いっぱいのお葬式 事前割メンバー割引 (一日葬) (2年未満)
		'SBG-0003106' => new Set<String>{ 'SBG-0003525' }, //【19.12】お花いっぱいのお葬式 家族葬 無宗教プラン,	【19.12】お花いっぱいのお葬式 事前割メンバー割引 (家族葬) (2年未満)
		'SBG-0003107' => new Set<String>{ 'SBG-0003525' }, //【19.12】お花いっぱいのお葬式 家族葬 仏式プラン,		【19.12】お花いっぱいのお葬式 事前割メンバー割引 (家族葬) (2年未満)
		'SBG-0003108' => new Set<String>{ 'SBG-0003525' }  //【19.12】お花いっぱいのお葬式 家族葬 お花増量プラン,	【19.12】お花いっぱいのお葬式 事前割メンバー割引 (家族葬) (2年未満)
	};
}