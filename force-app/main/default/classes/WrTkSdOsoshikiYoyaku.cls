public class WrTkSdOsoshikiYoyaku implements WrTkSds.IWrTkSeido, WrTkSbgMaps.IShohinBangoMap{

	public WrTkSds.WaribikiSeidoCodes waribikiSeidoCode(){ return WrTkSds.WaribikiSeidoCodes.OsoshikiYoyaku; }

	public Boolean isContextMatch( WrTkCtxs.ContextData pContext, String pShohinBango ){
		if( !this.m_shohinToWaribiki.containsKey(pShohinBango) ) return false;
		if(pContext.sodanshaMemberKubun == 'OsoshikiYoyaku') return true;
		if(pContext.taishoshaMemberKubun == 'OsoshikiYoyaku') return true;
		return false;
	}

	public Boolean existsHeiyoRiyoNg( List<WrTkSds.WaribikiSeidoCodes> pWaribikiSeidoCodes ){ return false; }

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
		'SBG-0000001' => new Set<String>{ 'SBG-0000189' }, //シンプルなお葬式　火葬式　直葬プラン[2019/9/30迄],		シンプルなお葬式　無料メンバー割引
		'SBG-0000002' => new Set<String>{ 'SBG-0000196' }, //シンプルなお葬式　火葬式　無宗教プラン[2019/9/30迄],	シンプルなお葬式　お葬式予約メンバー割引 (火葬式)[2019/9/30迄]
		'SBG-0000003' => new Set<String>{ 'SBG-0000196' }, //シンプルなお葬式　火葬式　仏式プラン[2019/9/30迄],		シンプルなお葬式　お葬式予約メンバー割引 (火葬式)[2019/9/30迄]
		'SBG-0000004' => new Set<String>{ 'SBG-0000196' }, //シンプルなお葬式　火葬式　花束プラン[2019/9/30迄],		シンプルなお葬式　お葬式予約メンバー割引 (火葬式)[2019/9/30迄]
		'SBG-0000005' => new Set<String>{ 'SBG-0000197' }, //シンプルなお葬式　一日葬　無宗教プラン[2019/9/30迄],	シンプルなお葬式　お葬式予約メンバー割引 (一日葬)[2019/9/30迄]
		'SBG-0000006' => new Set<String>{ 'SBG-0000197' }, //シンプルなお葬式　一日葬　仏式プラン[2019/9/30迄],		シンプルなお葬式　お葬式予約メンバー割引 (一日葬)[2019/9/30迄]
		'SBG-0000007' => new Set<String>{ 'SBG-0000197' }, //シンプルなお葬式　一日葬　お花増量プラン[2019/9/30迄],	シンプルなお葬式　お葬式予約メンバー割引 (一日葬)[2019/9/30迄]
		'SBG-0000008' => new Set<String>{ 'SBG-0000198' }, //シンプルなお葬式　家族葬　無宗教プラン[2019/9/30迄],	シンプルなお葬式　お葬式予約メンバー割引 (家族葬)[2019/9/30迄]
		'SBG-0000009' => new Set<String>{ 'SBG-0000198' }, //シンプルなお葬式　家族葬　仏式プラン[2019/9/30迄],		シンプルなお葬式　お葬式予約メンバー割引 (家族葬)[2019/9/30迄]
		'SBG-0000010' => new Set<String>{ 'SBG-0000198' }, //シンプルなお葬式　家族葬　お花増量プラン[2019/9/30迄],	シンプルなお葬式　お葬式予約メンバー割引 (家族葬)[2019/9/30迄]
		'SBG-0000011' => new Set<String>{ 'SBG-0000199' }, //シンプルなお葬式　一般葬　無宗教プラン[2019/9/30迄],	シンプルなお葬式　お葬式予約メンバー割引 (一般葬)[2019/9/30迄]
		'SBG-0000012' => new Set<String>{ 'SBG-0000199' }, //シンプルなお葬式　一般葬　仏式プラン[2019/9/30迄],		シンプルなお葬式　お葬式予約メンバー割引 (一般葬)[2019/9/30迄]
		'SBG-0000013' => new Set<String>{ 'SBG-0000199' }, //シンプルなお葬式　一般葬　お花増量プラン[2019/9/30迄],	シンプルなお葬式　お葬式予約メンバー割引 (一般葬)[2019/9/30迄]

		'SBG-0001001' => new Set<String>{ 'SBG-0001195' }, //よりそうのお葬式　火葬式　直葬プラン,					よりそうのお葬式　お葬式予約メンバー割引 (直葬)
		'SBG-0001002' => new Set<String>{ 'SBG-0001196' }, //よりそうのお葬式　火葬式　無宗教プラン,				よりそうのお葬式　お葬式予約メンバー割引 (火葬式)
		'SBG-0001003' => new Set<String>{ 'SBG-0001196' }, //よりそうのお葬式　火葬式　仏式プラン,					よりそうのお葬式　お葬式予約メンバー割引 (火葬式)
		'SBG-0001004' => new Set<String>{ 'SBG-0001196' }, //よりそうのお葬式　火葬式　花束プラン,					よりそうのお葬式　お葬式予約メンバー割引 (火葬式)
		'SBG-0001005' => new Set<String>{ 'SBG-0001197' }, //よりそうのお葬式　一日葬　無宗教プラン,				よりそうのお葬式　お葬式予約メンバー割引 (一日葬)
		'SBG-0001006' => new Set<String>{ 'SBG-0001197' }, //よりそうのお葬式　一日葬　仏式プラン,					よりそうのお葬式　お葬式予約メンバー割引 (一日葬)
		'SBG-0001007' => new Set<String>{ 'SBG-0001197' }, //よりそうのお葬式　一日葬　お花増量プラン,				よりそうのお葬式　お葬式予約メンバー割引 (一日葬)
		'SBG-0001008' => new Set<String>{ 'SBG-0001198' }, //よりそうのお葬式　家族葬　無宗教プラン,				よりそうのお葬式　お葬式予約メンバー割引 (家族葬)
		'SBG-0001009' => new Set<String>{ 'SBG-0001198' }, //よりそうのお葬式　家族葬　仏式プラン,					よりそうのお葬式　お葬式予約メンバー割引 (家族葬)
		'SBG-0001010' => new Set<String>{ 'SBG-0001198' }, //よりそうのお葬式　家族葬　お花増量プラン,				よりそうのお葬式　お葬式予約メンバー割引 (家族葬)
		'SBG-0001011' => new Set<String>{ 'SBG-0001199' }, //よりそうのお葬式　一般葬　無宗教プラン,				よりそうのお葬式　お葬式予約メンバー割引 (一般葬)
		'SBG-0001012' => new Set<String>{ 'SBG-0001199' }, //よりそうのお葬式　一般葬　仏式プラン,					よりそうのお葬式　お葬式予約メンバー割引 (一般葬)
		'SBG-0001013' => new Set<String>{ 'SBG-0001199' }, //よりそうのお葬式　一般葬　お花増量プラン,				よりそうのお葬式　お葬式予約メンバー割引 (一般葬)

		'SBG-0003002' => new Set<String>{ 'SBG-0003196' }, //【19.12】よりそうのお葬式 火葬式 無宗教プラン			【19.12】よりそうのお葬式 お葬式予約メンバー割引 (火葬式)
		'SBG-0003003' => new Set<String>{ 'SBG-0003196' }, //【19.12】よりそうのお葬式 火葬式 仏式プラン				【19.12】よりそうのお葬式 お葬式予約メンバー割引 (火葬式)
		'SBG-0003004' => new Set<String>{ 'SBG-0003196' }, //【19.12】よりそうのお葬式 火葬式 花束プラン				【19.12】よりそうのお葬式 お葬式予約メンバー割引 (火葬式)
		'SBG-0003005' => new Set<String>{ 'SBG-0003197' }, //【19.12】よりそうのお葬式 一日葬 無宗教プラン			【19.12】よりそうのお葬式 お葬式予約メンバー割引 (一日葬)
		'SBG-0003006' => new Set<String>{ 'SBG-0003197' }, //【19.12】よりそうのお葬式 一日葬 仏式プラン				【19.12】よりそうのお葬式 お葬式予約メンバー割引 (一日葬)
		'SBG-0003007' => new Set<String>{ 'SBG-0003197' }, //【19.12】よりそうのお葬式 一日葬 お花増量プラン			【19.12】よりそうのお葬式 お葬式予約メンバー割引 (一日葬)
		'SBG-0003008' => new Set<String>{ 'SBG-0003198' }, //【19.12】よりそうのお葬式 家族葬 無宗教プラン			【19.12】よりそうのお葬式 お葬式予約メンバー割引 (家族葬)
		'SBG-0003009' => new Set<String>{ 'SBG-0003198' }, //【19.12】よりそうのお葬式 家族葬 仏式プラン				【19.12】よりそうのお葬式 お葬式予約メンバー割引 (家族葬)
		'SBG-0003010' => new Set<String>{ 'SBG-0003198' }, //【19.12】よりそうのお葬式 家族葬 お花増量プラン			【19.12】よりそうのお葬式 お葬式予約メンバー割引 (家族葬)
		'SBG-0003011' => new Set<String>{ 'SBG-0003199' }, //【19.12】よりそうのお葬式 一般葬 無宗教プラン			【19.12】よりそうのお葬式 お葬式予約メンバー割引 (一般葬)
		'SBG-0003012' => new Set<String>{ 'SBG-0003199' }, //【19.12】よりそうのお葬式 一般葬 仏式プラン				【19.12】よりそうのお葬式 お葬式予約メンバー割引 (一般葬)
		'SBG-0003013' => new Set<String>{ 'SBG-0003199' }, //【19.12】よりそうのお葬式 一般葬 お花増量プラン			【19.12】よりそうのお葬式 お葬式予約メンバー割引 (一般葬)
		'SBG-0003103' => new Set<String>{ 'SBG-0003517' }, //【19.12】お花いっぱいのお葬式 一日葬 無宗教プラン		【19.12】お花いっぱいのお葬式 お葬式予約メンバー割引 (一日葬)
		'SBG-0003104' => new Set<String>{ 'SBG-0003517' }, //【19.12】お花いっぱいのお葬式 一日葬 仏式プラン			【19.12】お花いっぱいのお葬式 お葬式予約メンバー割引 (一日葬)
		'SBG-0003105' => new Set<String>{ 'SBG-0003517' }, //【19.12】お花いっぱいのお葬式 一日葬 お花増量プラン		【19.12】お花いっぱいのお葬式 お葬式予約メンバー割引 (一日葬)
		'SBG-0003106' => new Set<String>{ 'SBG-0003518' }, //【19.12】お花いっぱいのお葬式 家族葬 無宗教プラン		【19.12】お花いっぱいのお葬式 お葬式予約メンバー割引 (家族葬)
		'SBG-0003107' => new Set<String>{ 'SBG-0003518' }, //【19.12】お花いっぱいのお葬式 家族葬 仏式プラン			【19.12】お花いっぱいのお葬式 お葬式予約メンバー割引 (家族葬)
		'SBG-0003108' => new Set<String>{ 'SBG-0003518' },  //【19.12】お花いっぱいのお葬式 家族葬 お花増量プラン		【19.12】お花いっぱいのお葬式 お葬式予約メンバー割引 (家族葬)
		'SBG-0005001' => new Set<String>{ 'SBG-0005114' }, //【20.11】よりそう家族葬 一日プラン,	【20.11】お葬式予約会員割 (家族葬 一日プラン)
        'SBG-0005002' => new Set<String>{ 'SBG-0005115' }, //【20.11】よりそう家族葬 二日プラン,	【20.11】お葬式予約会員割 (家族葬 二日プラン)
        'SBG-0005003' => new Set<String>{ 'SBG-0005116' }, //【20.11】よりそう家族葬 華やかプラン,	【20.11】お葬式予約会員割 (家族葬 華やかプラン)
        'SBG-0005004' => new Set<String>{ 'SBG-0005117' }, //【20.11】よりそう火葬式 直葬プラン,	【20.11】お葬式予約会員割 (火葬式 直葬プラン)
		'SBG-0005005' => new Set<String>{ 'SBG-0005118' }, //【20.11】よりそう火葬式 標準プラン,	【20.11】お葬式予約会員割 (火葬式 標準プラン)
		'SBG-0005006' => new Set<String>{ 'SBG-0005114' }, //【20.12】よりそう家族葬 一日プラン,	【20.11】お葬式予約会員割 (家族葬 一日プラン)
		'SBG-0005007' => new Set<String>{ 'SBG-0005117' }, //【20.12】よりそう火葬式 直葬プラン,	【20.11】お葬式予約会員割 (火葬式 直葬プラン)
		'SBG-0005009' => new Set<String>{ 'SBG-0005117' }, //【21.03】よりそう火葬式 シンプルプラン	【20.11】お葬式予約会員割 (火葬式 直葬プラン)
		'SBG-0005008' => new Set<String>{ 'SBG-0005114' }, //【21.03】よりそう家族葬 一日プラン,	【20.11】お葬式予約会員割 (家族葬 一日プラン)

		'SBG-0005013' => new Set<String>{ 'SBG-0005236' }, // 【21.04】よりそう火葬式 シンプルプラン, 【21.04】お葬式予約会員割 (火葬式 シンプルプラン)
		'SBG-0005014' => new Set<String>{ 'SBG-0005237' }, // 【21.04】よりそう火葬式 基本プラン, 【21.04】お葬式予約会員割 (火葬式 基本プラン)
		'SBG-0005015' => new Set<String>{ 'SBG-0005238' }, // 【21.04】よりそう火葬式 仏具セットプラン,【21.04】お葬式予約会員割 (火葬式 仏具セットプラン)
		'SBG-0005016' => new Set<String>{ 'SBG-0005239' }, // 【21.04】よりそう火葬式 お花セットプラン,【21.04】お葬式予約会員割 (火葬式 お花セットプラン)
		'SBG-0005010' => new Set<String>{ 'SBG-0005114' },// 【21.04】よりそう家族葬 一日プラン	,【20.11】お葬式予約会員割 (家族葬 一日プラン)
		'SBG-0005011' => new Set<String>{ 'SBG-0005115' },// 【21.04】よりそう家族葬 二日プラン	,【20.11】お葬式予約会員割 (家族葬 二日プラン)
		'SBG-0005012' => new Set<String>{ 'SBG-0005116' } // 【21.04】よりそう家族葬 華やかプラン	,【20.11】お葬式予約会員割 (家族葬 華やかプラン)
		
	};
}