public class Api_V1_ItemValueMaster {

	public static final Map<String, String> memberTourokuKiboMap = new Map<String, String>{
		'yes' => '希望する'
		, 'no' => '希望しない'
	};

	public static String getMemberTourokuKibo(String key){
		return memberTourokuKiboMap.get(key);
	}

	public static final Map<String, String> webAccountKiboMap = new Map<String, String>{
		'yes' => '希望する'
		, 'no' => '希望しない'
	};

	public static String getWebAccountKibo(String key){
		return webAccountKiboMap.get(key);
	}

	public static final Map<String, String> sozokuSodanKiboMap = new Map<String, String>{
		'yes' => '希望する'
		, 'no' => '希望しない'
	};

	public static String getSozokuSodanKibo(String key){
		return sozokuSodanKiboMap.get(key);
	}

	public static final Map<String, String> shiryoSoufuHohoMap = new Map<String, String>{
		'email' => 'メール希望'
		, 'post' => '郵送希望'
	};

	public static String getShiryoSoufuHoho(String key){
		return shiryoSoufuHohoMap.get(key);
	}
	//issues3806--Start--
	public static final Map<String, String> taishoushaJokyoMap = new Map<String, String>{
		'goseikyo' => 'すでにご逝去', 
		'kitoku' => '危篤', 
		'yomeisenkoku' => '余命宣告', 
		'nyuinchu' => '入院中', 
		'tsuinchu' => '通院中', 
		'kenzai' => '健在'
	};
	//issues3806--End--
	public static String getTaishoushaJokyo(String key){
		return taishoushaJokyoMap.get(key);
	}
	
	public static final Map<String, String> hakapitaSyuhaMap = new Map<String, String>{
		'shukyofumon' => '宗教不問'
		,'shingonshu' => '真言宗'
		,'jodoshinshu' => '浄土真宗'
		,'tendaishu' => '天台宗'
		,'rinzaishu' => '臨済宗'
		,'sokagakkai' => '創価学会'
		,'obakushu' => '黄壁宗'
		,'yuzunenbutsushu' => '融通念仏宗'
		,'shinshutakadaha' => '真宗高田派'
		,'shinshuotaniha' => '真宗大谷派'
		,'zairaibukkyo' => '在来仏教'
		,'jodoshu' => '浄土宗'
		,'nichirenshu' => '日蓮宗'
		,'sotoshu' => '曹洞宗'
		,'shindo' => '神道'
		,'hokkeshu' => '法華宗'
		,'sonota' => 'その他'
	};

	public static String getHakapitaSyuha(String key){
		return hakapitaSyuhaMap.get(key);
	}
	public static final Map<String, String> taisyosyaBodaijiUmuMap = new Map<String, String>{
		'yes' => '有'
		, 'no' => '無'
		, 'fumei' => '不明'
	};

	public static String getTaisyosyaBodaijiUmu(String key){
		return taisyosyaBodaijiUmuMap.get(key);
	}

	public static final Map<String, String> taisyosyaFromCustomerMap = new Map<String, String>{
		'father' => '父'
		, 'mother' => '母'
		, 'husband' => '夫'
		, 'wife' => '妻'
		, 'grandfather' => '祖父'
		, 'grandmother' => '祖母'
		, 'honnin' => '本人'
		, 'son' => '息子'
		, 'daughter' => '娘'
		, 'other' => 'その他'
	};

	public static String getTaisyosyaFromCustomer(String key){
		return taisyosyaFromCustomerMap.get(key);
	}

	public static final Map<String, String> anchisakiKubunMap = new Map<String, String>{
		'jitaku' => '自宅安置'
		, 'sougisya' => '葬儀社預かり安置'
		, 'mitei' => '未定'
	};

	public static String getAnchisakiKubun(String key){
		return anchisakiKubunMap.get(key);
	}

	public static final Map<String, String> simpleyasugoPlanMap =  new Map<String, String>{
		'simple_kaso_mus' => '【19.12】火葬式　無宗教プラン(税抜:148,000　税込:162,800)'
		,'simple_kaso_bud' => '【19.12】火葬式　仏式プラン(税抜:168,000　税込:184,800)'
		,'simple_kaso_hana' => '【19.12】火葬式　花束プラン(税抜:188,000　税込:206,800)'
		,'simple_kaso_choku' => '【20.06】火葬式　直葬プラン(税抜:103,000　税込:113,300)'
		,'simple_1day_mus' => '【19.12】一日葬　無宗教プラン(税抜:278,000　税込:305,800)'
		,'simple_1day_bud' => '【19.12】一日葬　仏式プラン(税抜:298,000　税込:327,800)'
		,'simple_1day_han' => '【19.12】一日葬　お花増量プラン(税抜:318,000　税込:349,800)'
		,'simple_family_mus' => '【19.12】家族葬　無宗教プラン(税抜:408,000　税込:448,800)'
		,'simple_family_bud' => '【19.12】家族葬　仏式プラン(税抜:428,000　税込:470,800)'
		,'simple_family_han' => '【19.12】家族葬　お花増量プラン(税抜:448,000　税込:492,800)'
		,'simple_ippan_mus' => '【19.12】一般葬　無宗教プラン(税抜:548,000　税込:602,800)'
		,'simple_ippan_bud' => '【19.12】一般葬　仏式プラン(税抜:568,000　税込:624,800)'
		,'simple_ippan_han' => '【19.12】一般葬　お花増量プラン(税抜:618,000　税込:679,800)'
		,'ohana_1day_mus' => '【19.12】お花いっぱい　一日葬　無宗教プラン(税抜:338,000　税込:371,800)'
		,'ohana_1day_bud' => '【19.12】お花いっぱい　一日葬　仏式プラン(税抜:358,000　税込:393,800)'
		,'ohana_1day_han' => '【19.12】お花いっぱい　一日葬　お花増量プラン(税抜:378,000　税込:415,800)'
		,'ohana_family_mus' => '【19.12】お花いっぱい　家族葬　無宗教プラン(税抜:528,000　税込:580,800)'
		,'ohana_family_bud' => '【19.12】お花いっぱい　家族葬　仏式プラン(税抜:548,000　税込:602,800)'
		,'ohana_family_han' => '【19.12】お花いっぱい　家族葬　お花増量プラン(税抜:568,000　税込:624,800)'
		,'yoriso_1day' => '【20.11】よりそう家族葬 一日プラン'
		,'yoriso_2day' => '【20.11】よりそう家族葬 二日プラン'
		,'yoriso_hanayaka' => '【20.11】よりそう家族葬 華やかプラン'
		,'yoriso_choku' => '【20.11】よりそう火葬式 直葬プラン'
		,'yoriso_standard' => '【20.11】よりそう火葬式 標準プラン'
		,'yoriso_simple' => '【21.03】よりそう火葬式 シンプルプラン'
		,'yoriso_1day_2104' => '【21.04】よりそう家族葬 一日プラン'
		,'yoriso_2day_2104' => '【21.04】よりそう家族葬 二日プラン'
		,'yoriso_hanayaka_2104' => '【21.04】よりそう家族葬 華やかプラン'
		,'yoriso_simple_2104' => '【21.04】よりそう火葬式 シンプルプラン'
		,'yoriso_standard_2104' => '【21.04】よりそう火葬式 基本プラン'
		,'yoriso_butsugu_2104' => '【21.04】よりそう火葬式 仏具セットプラン'
		,'yoriso_ohana_2104' => '【21.04】よりそう火葬式 お花セットプラン'
	};

	public static String getSimpleyasugoPlan(String key){
		return simpleyasugoPlanMap.get(key);
	}

	public static final Map<String, String> simpleyasugoObousanbinPlanMap = new Map<String, String>{
		'none' => 'なし'
		, 'dokkyo_only' => '葬儀読経のみ'
		, 'dokkyo_and_kaimyo' => '葬儀読経＋戒名授与'
	};

	public static String getSimpleyasugoObousanbinPlan(String key){
		return simpleyasugoObousanbinPlanMap.get(key);
	}

	public static final Map<String, String> siryoSofuHohoMap = new Map<String, String>{
		'yes' => 'はい'
		, 'no' => 'いいえ'
	};

	public static String getSiryoSofuHoho(String key){
		return siryoSofuHohoMap.get(key);
	}

	public static final Map<String, String> taisyosyaIsCustomerMap = new Map<String, String>{
		'1' => 'お申込み者以外の方（ご家族等）'
		, '2' => 'お申込者ご自身'
	};

	public static String getTaisyosyaIsCustomer(String key){
		return taisyosyaIsCustomerMap.get(key);
	}

	public static final Map<String, String> taisyosyaMosyuUmuMap = new Map<String, String>{
		'yes' => '喪主となる方がいる'
		, 'no' => '喪主となる方がいない'
	};
	public static String getTaisyosyaMosyuUmu(String key){
		return taisyosyaMosyuUmuMap.get(key);
	}
	public static final Map<String, String> HojiHoyoMap = new Map<String, String>{
		'kiboshinai' => '法事・法要は希望しない'
		,'wakaranai' => 'どの法要を選べばよいのかわからない'
		,'1shuki' => '一周忌法要'
		,'3kaiki' => '三回忌法要'
		,'7kaiki' => '七回忌法要'
		,'13kaiki' => '十三回忌法要'
		,'17kaiki' => '十七回忌法要'
		,'23kaiki' => '二十三回忌法要'
		,'27kaiki' => '二十七回忌法要'
		,'33kaiki' => '三十三回忌法要'
		,'37kaiki' => '三十七回忌法要'
		,'43kaiki' => '四十三回忌法要'
		,'47kaiki' => '四十七回忌法要'
		,'50kaiki' => '五十回忌法要'
		,'7nichi' => '初七日法要'
		,'27nichi' => '二七日法要'
		,'37nichi' => '三七日法要'
		,'47nichi' => '四七日法要'
		,'49nichi' => '四十九日法要'
		,'57nichi' => '五七日法要'
		,'67nichi' => '六七日法要'
		,'100nichi' => '百ヶ日法要'
		,'sonotahoyo' => 'その他の法要'
		,'nokotsuhoyo' => '納骨法要'
		,'hatsubonarabon' => '初盆・新盆'
		,'ohigan' => 'お彼岸'
		,'obonsenzokuyo' => 'お盆（先祖供養）'
		,'obonkojin' => 'お盆（故人1名のみ）'
		,'kaigenhoyo' => '開眼法要'
		,'ihaikaigenhoyo' => '位牌開眼'
		,'ihaihegenhoyo' => '位牌閉眼'
		,'kaimyo-only' => '戒名・法名のみ'
		,'sougidokyo_kaso' => '火葬式'
		,'sougidokyo_ichinichi' => '一日葬'
		,'sougidokyo_ippan' => '一般葬'
		,'mikakutei' => 'プラン未確定'
	};

	public static String getHojiHoyo(String key){
		return HojiHoyoMap.get(key);
	}	
	public static final Map<String, String> KaimyoHomeijuyoMap = new Map<String, String>{
		'yes' => '戒名の授与を希望する'
		, 'no' => '戒名の授与を希望しない'
	};

	public static String getKaimyoHomeijuyo(String key){
		return KaimyoHomeijuyoMap.get(key);
	}

	public static final Map<String, String> KakuninRenrakuNoKiboUmuMap = new Map<String, String>{
		'yes' => '確認連絡を希望する', 
		'no' => '確認連絡を希望しない'
	};

	public static String getKakuninRenrakuNoKiboUmu(String key){
		return KakuninRenrakuNoKiboUmuMap.get(key);
	}

	public static final Map<String, String> HoyouYoteiStausMap = new Map<String, String>{
		'kimatte_iru' => '決まっている', 
		'kimatte_inai' => '決まっていない', 
		'yotei_nashi' => '法要予定はない'
	};

	public static String getHoyouYoteiStaus(String key){
		return HoyouYoteiStausMap.get(key);
	}

	//お坊さん便.戒名プラン
	public static final Map<String, String> kaimyoPlanMap = new Map<String, String>{
		'syakuSyakuni' => '釋・釋尼'
		, 'shinjiShinnyo' =>'信士・信女'
		, 'insinjiInsinnyo' => '院信士・院信女'
		, 'kojiDaishi' => '居士・大姉'
		, 'insyakuSyakuni' => '院釋・釋尼'
		, 'innichisinjiInnichisinnyo' => ' 院日信士・院日信女'
		, 'inkojiIndaishi' => ' 院居士・院大姉'
	};

	public static String getKaimyoPlan(String key){
		return kaimyoPlanMap.get(key);
	}

	public static final Map<String, String> sankotsuKaiikiMap = new Map<String, String>{
		'okinawahonto' => '沖縄本島'
		, 'tokyowan' => '東京湾'
		, 'surugawan' => '駿河湾'
		, 'iseshima' => '伊勢志摩'
		, 'nankishirahama' => '南紀白浜'
		, 'shonan' => '湘南'
		, 'hakatawan' => '博多湾'
	};

	public static String getSankotsuKaiiki(String key){
		return sankotsuKaiikiMap.get(key);
	}	
	public static final Map<String, String> entranceMap = new Map<String, String>{
		'iriguchi' => '入口'
		, 'shiryoseikyu' => '資料請求'
		, 'kengakumoshikomi' => '見学申し込み'
		, 'shiryokengakumoshikomi ' => '資料・見学申し込み'
	};

	public static String getEntrance(String key){
		return entranceMap.get(key);
	}

	public static final Map<String, String> riyokaisuMap = new Map<String, String>{
		'hajimete' => '初めて', 
		'2kaimeiko' => '2回目以降'
	};

	public static String getRiyokaisu(String key){
		return riyokaisuMap.get(key);
	}

	public static final Map<String, String> ObonsetMap = new Map<String, String>{
		'yes' => '新盆セット+お盆用提灯(1万1000円)'
	};
	public static String getObonsetMap(String key){
		return ObonsetMap.get(key);
	}
}