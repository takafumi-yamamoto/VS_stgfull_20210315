/**
//マスタデータ作成
new SampleData().buildMaster();

//お坊さん便商談
new SampleData().buildObosanbinOpp();

//シンプル安豪
new SampleData().buildSimpleYasugo();

*/
global class SampleData implements SandboxPostCopy {


	global void runApexClass(SandboxContext context) {
		new SampleData().build();
	}

	public void build(){

		SampleData sd = new SampleData();
		////////////////////マスタデータ
		sd.buildMaster();

		////////////////////サンプルデータ
		//お坊さん便商談
		sd.buildObosanbinOpp();

		//シンプル安豪
		sd.buildSimpleYasugo();
	}


	public void buildMaster(){
		//事前割プラン
		insert getJizenWariPlan();

		//お客様
		List<Account> accList = new List<Account>();
		accList.add(getAccountNull());
		accList.add(getAccountSoryo());
		accList.add(getAccountCustomer());
		accList.add(getAccountDefault());
		accList.add(getAccountJiin());
		accList.add(getAccountMosyuDaikoSya());
		accList.add(getAccountSogisya());
		insert accList;

		//事前割プラン
		insert getKCoupon();
		insert getKService();
		insert getKWaribikiPlan();
		insert getKShohinCategory();
		insert getKShohinSyubetsu();

		//都道府県,市区郡
		List<TodoufuKen__c> todofukenList = getTodofuken();
		insert todofukenList;
		insert getShikugun(todofukenList);

		//手数プラン
		insert getTesuryoPlan();

		//施行可能エリア
		insert getSekoukanouarea();

		//施設
		insert getShisetsu();

		//手数料適用
		//insert sd.getTesuryoTekiyo();
	}

	//施設
	public List<Shisetsu__c> getShisetsu(){

		List<Shikugun__c> shikuguns = [select id from Shikugun__c limit 3];

		List<Shisetsu__c> shisetsuList = new List<Shisetsu__c>();
		Shisetsu__c shisetsu0 = new Shisetsu__c();
		shisetsu0.name = 'スズキテスト';   // 施設名
		// shisetsu0.accesshohobasu__c = '';    // アクセス方法(バス)
		// shisetsu0.accesshohokuruma__c = '';    // アクセス方法(車)
		// shisetsu0.accesshohosonota__c = '';    // アクセス方法(その他)
		// shisetsu0.accesshouhoudensha__c = '';    // アクセス方法(電車)
		// shisetsu0.addressfurigana__c = '';    // 住所(かな)
		shisetsu0.anchika__c = True;   // 安置可
		shisetsu0.anchimenkaika__c = True;   // 安置面会可
		// shisetsu0.anchinonresidentprice__c = '';    // 霊安室(安置)料金(市外)
		// shisetsu0.anchiresidentprice__c = '';    // 霊安室(安置)料金(市内)
		shisetsu0.bariafuri__c = True;   // バリアフリー
		shisetsu0.bebiroomari__c = True;   // ベビールーム有
		// shisetsu0.biko__c = '';    // 備考
		shisetsu0.chushadaisu__c = 6.0;   // 駐車台数
		shisetsu0.cityfeein__c = 0.0;   // 火葬場利用料金 (市内)
		shisetsu0.cityfeeout__c = 0.0;   // 火葬場利用料金 (市外)
		shisetsu0.city__c = '武蔵村山市';   // 市区郡
		// shisetsu0.closeday__c = '';    // 休館日
		// shisetsu0.fax__c = '';    // FAX
		shisetsu0.hallcityfeein2days__c = 0.0;   // 式場利用料金 (家族葬・一般葬, 市内)
		shisetsu0.hallcityfeein__c = 0.0;   // 式場利用料金 (一日葬, 市内)
		shisetsu0.hallcityfeeout2days__c = 0.0;   // 式場利用料金 (家族葬・一般葬, 市外)
		shisetsu0.hallcityfeeout__c = 0.0;   // 式場利用料金 (一日葬, 市外)
		shisetsu0.hoyoka__c = True;   // 法要可
		// shisetsu0.hpurl__c = '';    // HP URL
		shisetsu0.ichinichisoka__c = False;   // 一日葬可
		shisetsu0.idokedo__latitude__s = 35.7716572;   // 緯度経度 (Latitude)
		shisetsu0.idokedo__longitude__s = 139.3142127;   // 緯度経度 (Longitude)
		shisetsu0.ippansoka__c = False;   // 一般葬可
		shisetsu0.kasobashoristatus__c = '未連携';   // 火葬場用処理ステータス
		shisetsu0.kasoshikika__c = True;   // 火葬式可
		shisetsu0.kazokusoka__c = False;   // 家族葬可
		shisetsu0.kizzuroomari__c = True;   // キッズルーム有
		// shisetsu0.koeiminei__c = '';    // 公営民営
		// shisetsu0.mail__c = '';    // メール
		shisetsu0.moshujuminhyoshozaichitekiyoka__c = False;   // 喪主住民票所在地適用可
		// shisetsu0.organiser__c = '';    // 運営元(屋号)
		// shisetsu0.phone1__c = '';    // 電話番号1
		// shisetsu0.phone2__c = '';    // 電話番号2
		// shisetsu0.pkey__c = '';    // Pkey
		shisetsu0.postalcode__c = '1910001';   // 郵便番号
		// shisetsu0.riyoryobiko__c = '';    // 利用料備考
		shisetsu0.saijoshoristatus__c = '未連携';   // 斎場用処理ステータス
		// shisetsu0.scale__c = '';    // 対応可能規模
		shisetsu0.shawaroomari__c = True;   // シャワールーム有
		shisetsu0.shikugun__c = shikuguns[0].id;   // 市区郡
		// shisetsu0.shinzokuhikaenonresidentprice__c = '';    // 霊安室・親族控室(安置)料金(市外)
		// shisetsu0.shinzokuhikaeresidentprice__c = '';    // 霊安室・親族控室(安置)料金(市内)
		shisetsu0.shinzokuhikaeshitsuari__c = False;   // 親族控室有
		// shisetsu0.shisetsuannaipageurl__c = '';    // 施設案内ページURL(シンプル)
		// shisetsu0.shisetsubango__c = '';    // 施設番号
		// shisetsu0.shisetsuid__c = '';    // 施設ID
		shisetsu0.shisetsushubetsu__c = '斎場';   // 施設種別
		// shisetsu0.shisetsutantoshamei__c = '';    // 施設担当者名
		// shisetsu0.shisetsutantoshaphone__c = '';    // 施設担当者電話番号
		shisetsu0.shisetsumeifurigana__c = 'しせつ';   // 施設名(かな)
		// shisetsu0.shokaikinshiriyu__c = '';    // 紹介禁止理由
		shisetsu0.shokaikinshi__c = False;   // 紹介禁止
		// shisetsu0.shoristatusbiko__c = '';    // 処理ステータス備考
		shisetsu0.shukuhakuka__c = True;   // 宿泊可
		// shisetsu0.shutokenichibuchikiryokin__c = ;    // 首都圏一部地域料金
		shisetsu0.shutokenichibuchiki__c = False;   // 首都圏一部地域
		shisetsu0.simplekeisai__c = True;   // シンプル掲載
		shisetsu0.sogirebikeisai__c = False;   // 葬儀レビ掲載
		// shisetsu0.sogisha__c = '';    // 葬儀社
		// shisetsu0.sokyakujichuiten__c = '';    // 送客時注意点
		shisetsu0.state__c = '東京都';   // 都道府県
		shisetsu0.street__c = '栄町３－３－４3';   // 町名・番地
		// shisetsu0.titlekasoba__c = '';    // タイトル(火葬場)
		// shisetsu0.titlesaijo__c = '';    // タイトル(斎場)
		// shisetsu0.tokuchokasoba__c = '';    // 特徴(火葬場)
		// shisetsu0.tokuchosaijo__c = '';    // 特徴(斎場)
		// shisetsu0.trycount__c = ;    // 連携試行回数
		shisetsu0.trylimit__c = 3.0;   // 連携試行最大回数
		shisetsu0.tsukisoianchika__c = True;   // 付添安置可
		shisetsu0.zenshuhataioka__c = True;   // 全宗派対応可
		// shisetsu0.sp__c = '';    // sp
		shisetsu0.kasobamenkaifuka__c = False;   // 火葬場面会不可
		// shisetsu0.holesetsumeibun__c = '';    // ホール説明文（葬儀社記入）
		// shisetsu0.taiokanoninzu__c = ;    // 対応可能人数
		// shisetsu0.shukuhakushisetsuryokin__c = ;    // 宿泊施設料金
		// shisetsu0.shukuhakushisetsubiko__c = '';    // 宿泊施設備考
		shisetsu0.chushajoari__c = False;   // 駐車場有
		shisetsu0.junyushitsuari__c = False;   // 授乳室有
		shisetsu0.omutsukokandaiari__c = False;   // おむつ交換台有
		// shisetsu0.anchitaioninzu__c = ;    // 安置対応人数
		// shisetsu0.horeikosu__c = ;    // 保冷庫数
		shisetsu0.chokusoka__c = True;   // 直葬可
		// shisetsu0.shisetsuannaipageurlyasugo__c = '';    // 施設案内ページURL(安豪)
		shisetsu0.kasobakeisaijohoid__c = '1000300010';   // KasobaKeisaiJohoId
		shisetsu0.saijokeisaijohoid__c = '2000300010';   // SaijoKeisaiJohoId
		shisetsu0.kasomachiaishitsuari__c = True;   // 火葬待合室有
		shisetsu0.seqno__c = 300010.0;   // SeqNo
		shisetsu0.heisetsukubun__c = '併設';   // 併設区分
		// shisetsu0.sougirevikeisaiid__c = '';    // 葬儀レビ掲載ID
		shisetsuList.add(shisetsu0);

		Shisetsu__c shisetsu1 = new Shisetsu__c();
		shisetsu1.name = 'スズキ３';   // 施設名
		// shisetsu1.accesshohobasu__c = '';    // アクセス方法(バス)
		// shisetsu1.accesshohokuruma__c = '';    // アクセス方法(車)
		// shisetsu1.accesshohosonota__c = '';    // アクセス方法(その他)
		// shisetsu1.accesshouhoudensha__c = '';    // アクセス方法(電車)
		// shisetsu1.addressfurigana__c = '';    // 住所(かな)
		shisetsu1.anchika__c = False;   // 安置可
		shisetsu1.anchimenkaika__c = False;   // 安置面会可
		// shisetsu1.anchinonresidentprice__c = '';    // 霊安室(安置)料金(市外)
		// shisetsu1.anchiresidentprice__c = '';    // 霊安室(安置)料金(市内)
		shisetsu1.bariafuri__c = False;   // バリアフリー
		shisetsu1.bebiroomari__c = False;   // ベビールーム有
		// shisetsu1.biko__c = '';    // 備考
		// shisetsu1.chushadaisu__c = ;    // 駐車台数
		shisetsu1.cityfeein__c = 0.0;   // 火葬場利用料金 (市内)
		shisetsu1.cityfeeout__c = 0.0;   // 火葬場利用料金 (市外)
		shisetsu1.city__c = '日野市';   // 市区郡
		// shisetsu1.closeday__c = '';    // 休館日
		// shisetsu1.fax__c = '';    // FAX
		shisetsu1.hallcityfeein2days__c = 0.0;   // 式場利用料金 (家族葬・一般葬, 市内)
		shisetsu1.hallcityfeein__c = 0.0;   // 式場利用料金 (一日葬, 市内)
		shisetsu1.hallcityfeeout2days__c = 0.0;   // 式場利用料金 (家族葬・一般葬, 市外)
		shisetsu1.hallcityfeeout__c = 0.0;   // 式場利用料金 (一日葬, 市外)
		shisetsu1.hoyoka__c = False;   // 法要可
		// shisetsu1.hpurl__c = '';    // HP URL
		shisetsu1.ichinichisoka__c = False;   // 一日葬可
		shisetsu1.idokedo__latitude__s = 35.6849916;   // 緯度経度 (Latitude)
		shisetsu1.idokedo__longitude__s = 139.3904789;   // 緯度経度 (Longitude)
		shisetsu1.ippansoka__c = False;   // 一般葬可
		shisetsu1.kasobashoristatus__c = '未連携';   // 火葬場用処理ステータス
		shisetsu1.kasoshikika__c = False;   // 火葬式可
		shisetsu1.kazokusoka__c = False;   // 家族葬可
		shisetsu1.kizzuroomari__c = False;   // キッズルーム有
		// shisetsu1.koeiminei__c = '';    // 公営民営
		// shisetsu1.mail__c = '';    // メール
		shisetsu1.moshujuminhyoshozaichitekiyoka__c = False;   // 喪主住民票所在地適用可
		// shisetsu1.organiser__c = '';    // 運営元(屋号)
		// shisetsu1.phone1__c = '';    // 電話番号1
		// shisetsu1.phone2__c = '';    // 電話番号2
		// shisetsu1.pkey__c = '';    // Pkey
		// shisetsu1.postalcode__c = '';    // 郵便番号
		// shisetsu1.riyoryobiko__c = '';    // 利用料備考
		shisetsu1.saijoshoristatus__c = '未連携';   // 斎場用処理ステータス
		// shisetsu1.scale__c = '';    // 対応可能規模
		shisetsu1.shawaroomari__c = False;   // シャワールーム有
		shisetsu1.shikugun__c = shikuguns[1].id;   // 市区郡
		// shisetsu1.shinzokuhikaenonresidentprice__c = '';    // 霊安室・親族控室(安置)料金(市外)
		// shisetsu1.shinzokuhikaeresidentprice__c = '';    // 霊安室・親族控室(安置)料金(市内)
		shisetsu1.shinzokuhikaeshitsuari__c = False;   // 親族控室有
		// shisetsu1.shisetsuannaipageurl__c = '';    // 施設案内ページURL(シンプル)
		// shisetsu1.shisetsubango__c = '';    // 施設番号
		// shisetsu1.shisetsuid__c = '';    // 施設ID
		shisetsu1.shisetsushubetsu__c = '斎場';   // 施設種別
		// shisetsu1.shisetsutantoshamei__c = '';    // 施設担当者名
		// shisetsu1.shisetsutantoshaphone__c = '';    // 施設担当者電話番号
		// shisetsu1.shisetsumeifurigana__c = '';    // 施設名(かな)
		// shisetsu1.shokaikinshiriyu__c = '';    // 紹介禁止理由
		shisetsu1.shokaikinshi__c = False;   // 紹介禁止
		// shisetsu1.shoristatusbiko__c = '';    // 処理ステータス備考
		shisetsu1.shukuhakuka__c = False;   // 宿泊可
		// shisetsu1.shutokenichibuchikiryokin__c = ;    // 首都圏一部地域料金
		shisetsu1.shutokenichibuchiki__c = False;   // 首都圏一部地域
		shisetsu1.simplekeisai__c = False;   // シンプル掲載
		shisetsu1.sogirebikeisai__c = False;   // 葬儀レビ掲載
		// shisetsu1.sogisha__c = '';    // 葬儀社
		// shisetsu1.sokyakujichuiten__c = '';    // 送客時注意点
		shisetsu1.state__c = '東京都';   // 都道府県
		shisetsu1.street__c = '栄町3-3-40';   // 町名・番地
		// shisetsu1.titlekasoba__c = '';    // タイトル(火葬場)
		// shisetsu1.titlesaijo__c = '';    // タイトル(斎場)
		// shisetsu1.tokuchokasoba__c = '';    // 特徴(火葬場)
		// shisetsu1.tokuchosaijo__c = '';    // 特徴(斎場)
		// shisetsu1.trycount__c = ;    // 連携試行回数
		shisetsu1.trylimit__c = 3.0;   // 連携試行最大回数
		shisetsu1.tsukisoianchika__c = False;   // 付添安置可
		shisetsu1.zenshuhataioka__c = False;   // 全宗派対応可
		// shisetsu1.sp__c = '';    // sp
		shisetsu1.kasobamenkaifuka__c = False;   // 火葬場面会不可
		// shisetsu1.holesetsumeibun__c = '';    // ホール説明文（葬儀社記入）
		// shisetsu1.taiokanoninzu__c = ;    // 対応可能人数
		// shisetsu1.shukuhakushisetsuryokin__c = ;    // 宿泊施設料金
		// shisetsu1.shukuhakushisetsubiko__c = '';    // 宿泊施設備考
		shisetsu1.chushajoari__c = False;   // 駐車場有
		shisetsu1.junyushitsuari__c = False;   // 授乳室有
		shisetsu1.omutsukokandaiari__c = False;   // おむつ交換台有
		// shisetsu1.anchitaioninzu__c = ;    // 安置対応人数
		// shisetsu1.horeikosu__c = ;    // 保冷庫数
		shisetsu1.chokusoka__c = False;   // 直葬可
		// shisetsu1.shisetsuannaipageurlyasugo__c = '';    // 施設案内ページURL(安豪)
		shisetsu1.kasobakeisaijohoid__c = '1000300012';   // KasobaKeisaiJohoId
		shisetsu1.saijokeisaijohoid__c = '2000300012';   // SaijoKeisaiJohoId
		shisetsu1.kasomachiaishitsuari__c = False;   // 火葬待合室有
		shisetsu1.seqno__c = 300012.0;   // SeqNo
		shisetsu1.heisetsukubun__c = '併設';   // 併設区分
		// shisetsu1.sougirevikeisaiid__c = '';    // 葬儀レビ掲載ID
		shisetsuList.add(shisetsu1);

		return shisetsuList;


	}

	//施行可能エリア
	public List<SekouKanouArea__c> getSekoukanouarea(){

		List<Shikugun__c> shikuguns = [select id from Shikugun__c limit 3];

		List<SekouKanouArea__c> sekoukanouareaList = new List<SekouKanouArea__c>();
		SekouKanouArea__c sekoukanouarea0 = new SekouKanouArea__c();
		sekoukanouarea0.shikugunref__c = shikuguns[0].id;   // 市区郡
		sekoukanouarea0.sokyakuteishi__c = False;   // 送客停止
		//sekoukanouarea0.shisetsuref__c = 'a0y7F000000Fl9KQAS';   // 施設
		sekoukanouareaList.add(sekoukanouarea0);

		SekouKanouArea__c sekoukanouarea1 = new SekouKanouArea__c();
		sekoukanouarea1.shikugunref__c = shikuguns[1].id;   // 市区郡
		sekoukanouarea1.sokyakuteishi__c = False;   // 送客停止
		//sekoukanouarea1.shisetsuref__c = 'a0y7F000000Fl4FQAS';   // 施設
		sekoukanouareaList.add(sekoukanouarea1);

		SekouKanouArea__c sekoukanouarea2 = new SekouKanouArea__c();
		sekoukanouarea2.shikugunref__c = shikuguns[0].id;   // 市区郡
		sekoukanouarea2.sokyakuteishi__c = False;   // 送客停止
		sekoukanouareaList.add(sekoukanouarea2);

		return sekoukanouareaList;

	}

	//手数料適用
	public List<TesuryoTekiyo__c> getTesuryoTekiyo(){
		List<TesuryoTekiyo__c> tesuryotekiyoList = new List<TesuryoTekiyo__c>();
		TesuryoTekiyo__c tesuryotekiyo0 = new TesuryoTekiyo__c();
		tesuryotekiyo0.keiyakuref__c = 'a077F000004G3ESQA0';   // パートナー契約
		tesuryotekiyo0.shoristatus__c = '連携済';   // [削除]処理ステータス
		tesuryotekiyo0.shoristatusbiko__c = '連携が成功しました！';   // [削除]処理ステータス備考
		tesuryotekiyo0.tesuryoplanref__c = 'a1L0k000000Hb7xEAC';   // 手数料プラン
		tesuryotekiyo0.shoninstatus__c = 'ドラフト';   // 承認ステータス
		tesuryotekiyo0.trycount__c = 0.0;   // [削除]連携試行回数
		tesuryotekiyo0.trylimit__c = 3.0;   // [削除]連携試行最大回数
		tesuryotekiyo0.tekiyokaishibi__c = Date.newInstance(2018, 04, 19);   // 適用開始日
		tesuryotekiyo0.tekiyosyuryobi__c = Date.newInstance(2018, 12, 01);   // 適用終了日
		tesuryotekiyo0.ryoritesuryoari__c = False;   // 料理手数料有
		tesuryotekiyo0.henreihintesuryoari__c = False;   // 返礼品手数料有
		tesuryotekiyo0.optiontesuryoari__c = False;   // オプション手数料有
		tesuryotekiyo0.cardloantesuryoari__c = False;   // カードローン手数料有
		tesuryotekiyo0.atobaraitesuryoari__c = False;   // 後払手数料有
		tesuryotekiyo0.serviceref__c = 'a1G7F0000006p4mUAA';   // サービス
		tesuryotekiyoList.add(tesuryotekiyo0);

		TesuryoTekiyo__c tesuryotekiyo1 = new TesuryoTekiyo__c();
		tesuryotekiyo1.keiyakuref__c = 'a077F000004G3ESQA0';   // パートナー契約
		tesuryotekiyo1.shoristatus__c = '未連携';   // [削除]処理ステータス
		// tesuryotekiyo1.shoristatusbiko__c = '';    // [削除]処理ステータス備考
		// tesuryotekiyo1.tesuryoplanref__c = '';    // 手数料プラン
		tesuryotekiyo1.shoninstatus__c = 'ドラフト';   // 承認ステータス
		tesuryotekiyo1.trycount__c = 0.0;   // [削除]連携試行回数
		tesuryotekiyo1.trylimit__c = 3.0;   // [削除]連携試行最大回数
		tesuryotekiyo1.tekiyokaishibi__c = Date.newInstance(2018, 04, 22);   // 適用開始日
		tesuryotekiyo1.tekiyosyuryobi__c = Date.newInstance(2100, 12, 31);   // 適用終了日
		tesuryotekiyo1.ryoritesuryoari__c = False;   // 料理手数料有
		tesuryotekiyo1.henreihintesuryoari__c = False;   // 返礼品手数料有
		tesuryotekiyo1.optiontesuryoari__c = False;   // オプション手数料有
		tesuryotekiyo1.cardloantesuryoari__c = False;   // カードローン手数料有
		tesuryotekiyo1.atobaraitesuryoari__c = False;   // 後払手数料有
		// tesuryotekiyo1.serviceref__c = '';    // サービス
		tesuryotekiyoList.add(tesuryotekiyo1);

		TesuryoTekiyo__c tesuryotekiyo2 = new TesuryoTekiyo__c();
		// tesuryotekiyo2.id = 'a1N0k000000jrNAEAY';    // カスタムオブジェクト ID
		tesuryotekiyo2.keiyakuref__c = 'a077F000004G3EvQAK';   // パートナー契約
		tesuryotekiyo2.shoristatus__c = '未連携';   // [削除]処理ステータス
		// tesuryotekiyo2.shoristatusbiko__c = '';    // [削除]処理ステータス備考
		// tesuryotekiyo2.tesuryoplanref__c = '';    // 手数料プラン
		tesuryotekiyo2.shoninstatus__c = 'ドラフト';   // 承認ステータス
		tesuryotekiyo2.trycount__c = 0.0;   // [削除]連携試行回数
		tesuryotekiyo2.trylimit__c = 3.0;   // [削除]連携試行最大回数
		tesuryotekiyo2.tekiyokaishibi__c = Date.newInstance(2018, 06, 04);   // 適用開始日
		tesuryotekiyo2.tekiyosyuryobi__c = Date.newInstance(2100, 12, 31);   // 適用終了日
		tesuryotekiyo2.ryoritesuryoari__c = True;   // 料理手数料有
		tesuryotekiyo2.henreihintesuryoari__c = True;   // 返礼品手数料有
		tesuryotekiyo2.optiontesuryoari__c = True;   // オプション手数料有
		tesuryotekiyo2.cardloantesuryoari__c = True;   // カードローン手数料有
		tesuryotekiyo2.atobaraitesuryoari__c = True;   // 後払手数料有
		// tesuryotekiyo2.serviceref__c = '';    // サービス
		tesuryotekiyoList.add(tesuryotekiyo2);

		return tesuryotekiyoList;
	}

	public List<TesuryoPlan__c> getTesuryoPlan(){
		List<k_Service__c> kservice = [ select 
													Id,				//カスタムオブジェクト ID
													Name,				//サービス名
													ID__c				//ID
										from k_Service__c ];

		List<TesuryoPlan__c> tesuryoplanList = new List<TesuryoPlan__c>();
		TesuryoPlan__c tesuryoplan0 = new TesuryoPlan__c();
		// tesuryoplan0.id = 'a1L0k000000Hb95EAC';    // カスタムオブジェクト ID
		tesuryoplan0.name = '特約店　標準手数料プラン';   // 手数料プラン名
		tesuryoplan0.coretesuryoplanid__c = 1.0;   // コア手数料プランID
		tesuryoplan0.kobetsuplanflag__c = False;   // 個別プランフラグ
		tesuryoplan0.iskyutesuryotaio__c = False;   // 旧手数料対応
		tesuryoplan0.tesuryonebikisetteika__c = False;   // 手数料値引設定可
		tesuryoplan0.serviceref__c = kservice[0].id;   // サービス
		tesuryoplan0.searchtag__c = '@@';   // 検索タグ
		tesuryoplanList.add(tesuryoplan0);

		TesuryoPlan__c tesuryoplan1 = new TesuryoPlan__c();
		// tesuryoplan1.id = 'a1L0k000000SpmFEAS';    // カスタムオブジェクト ID
		tesuryoplan1.name = 'お坊さん便　旧手数料プラン';   // 手数料プラン名
		tesuryoplan1.coretesuryoplanid__c = 2.0;   // コア手数料プランID
		tesuryoplan1.kobetsuplanflag__c = False;   // 個別プランフラグ
		tesuryoplan1.iskyutesuryotaio__c = True;   // 旧手数料対応
		tesuryoplan1.tesuryonebikisetteika__c = False;   // 手数料値引設定可
		tesuryoplan1.serviceref__c = kservice[1].id;   // サービス
		tesuryoplan1.searchtag__c = '@@';   // 検索タグ
		tesuryoplanList.add(tesuryoplan1);

		TesuryoPlan__c tesuryoplan2 = new TesuryoPlan__c();
		// tesuryoplan2.id = 'a1L0k000000SpmKEAS';    // カスタムオブジェクト ID
		tesuryoplan2.name = 'お坊さん便　八正会・もんじゅ会プラン';   // 手数料プラン名
		tesuryoplan2.coretesuryoplanid__c = 3.0;   // コア手数料プランID
		tesuryoplan2.kobetsuplanflag__c = False;   // 個別プランフラグ
		tesuryoplan2.iskyutesuryotaio__c = False;   // 旧手数料対応
		tesuryoplan2.tesuryonebikisetteika__c = False;   // 手数料値引設定可
		tesuryoplan2.serviceref__c = kservice[2].id;   // サービス
		tesuryoplan2.searchtag__c = '@@';   // 検索タグ
		tesuryoplanList.add(tesuryoplan2);

		TesuryoPlan__c tesuryoplan3 = new TesuryoPlan__c();
		// tesuryoplan3.id = 'a1L0k000000Hb7xEAC';    // カスタムオブジェクト ID
		tesuryoplan3.name = 'お坊さん便　新手数料プラン';   // 手数料プラン名
		tesuryoplan3.coretesuryoplanid__c = 1.0;   // コア手数料プランID
		tesuryoplan3.kobetsuplanflag__c = False;   // 個別プランフラグ
		tesuryoplan3.iskyutesuryotaio__c = False;   // 旧手数料対応
		tesuryoplan3.tesuryonebikisetteika__c = False;   // 手数料値引設定可
		tesuryoplan3.serviceref__c = kservice[3].id;   // サービス
		tesuryoplan3.searchtag__c = '@@';   // 検索タグ
		tesuryoplanList.add(tesuryoplan3);

		return tesuryoplanList;


	}


	public List<TodoufuKen__c> getTodofuken(){
		List<TodoufuKen__c> todoufukenList = new List<TodoufuKen__c>();
		TodoufuKen__c todoufuken0 = new TodoufuKen__c();
		// todoufuken0.id = 'a177F000000NnGcQAK';    // カスタムオブジェクト ID
		todoufuken0.name = '愛知県';   // 都道府県
		todoufuken0.kencode__c = '23';   // 県コード
		todoufuken0.pkey__c = '愛知県';   // PKey
		todoufukenList.add(todoufuken0);

		TodoufuKen__c todoufuken1 = new TodoufuKen__c();
		// todoufuken1.id = 'a177F000000NnGdQAK';    // カスタムオブジェクト ID
		todoufuken1.name = '愛媛県';   // 都道府県
		todoufuken1.kencode__c = '38';   // 県コード
		todoufuken1.pkey__c = '愛媛県';   // PKey
		todoufukenList.add(todoufuken1);

		TodoufuKen__c todoufuken2 = new TodoufuKen__c();
		// todoufuken2.id = 'a177F000000NnGeQAK';    // カスタムオブジェクト ID
		todoufuken2.name = '茨城県';   // 都道府県
		todoufuken2.kencode__c = '08';   // 県コード
		todoufuken2.pkey__c = '茨城県';   // PKey
		todoufukenList.add(todoufuken2);

		TodoufuKen__c todoufuken3 = new TodoufuKen__c();
		// todoufuken3.id = 'a177F000000NnGfQAK';    // カスタムオブジェクト ID
		todoufuken3.name = '岡山県';   // 都道府県
		todoufuken3.kencode__c = '33';   // 県コード
		todoufuken3.pkey__c = '岡山県';   // PKey
		todoufukenList.add(todoufuken3);

		TodoufuKen__c todoufuken4 = new TodoufuKen__c();
		// todoufuken4.id = 'a177F000000NnGgQAK';    // カスタムオブジェクト ID
		todoufuken4.name = '沖縄県';   // 都道府県
		todoufuken4.kencode__c = '47';   // 県コード
		todoufuken4.pkey__c = '沖縄県';   // PKey
		todoufukenList.add(todoufuken4);

		TodoufuKen__c todoufuken5 = new TodoufuKen__c();
		// todoufuken5.id = 'a177F000000NnGhQAK';    // カスタムオブジェクト ID
		todoufuken5.name = '岩手県';   // 都道府県
		todoufuken5.kencode__c = '03';   // 県コード
		todoufuken5.pkey__c = '岩手県';   // PKey
		todoufukenList.add(todoufuken5);

		TodoufuKen__c todoufuken6 = new TodoufuKen__c();
		// todoufuken6.id = 'a177F000000NnGiQAK';    // カスタムオブジェクト ID
		todoufuken6.name = '岐阜県';   // 都道府県
		todoufuken6.kencode__c = '21';   // 県コード
		todoufuken6.pkey__c = '岐阜県';   // PKey
		todoufukenList.add(todoufuken6);

		TodoufuKen__c todoufuken7 = new TodoufuKen__c();
		// todoufuken7.id = 'a177F000000NnGjQAK';    // カスタムオブジェクト ID
		todoufuken7.name = '宮崎県';   // 都道府県
		todoufuken7.kencode__c = '45';   // 県コード
		todoufuken7.pkey__c = '宮崎県';   // PKey
		todoufukenList.add(todoufuken7);

		TodoufuKen__c todoufuken8 = new TodoufuKen__c();
		// todoufuken8.id = 'a177F000000NnGkQAK';    // カスタムオブジェクト ID
		todoufuken8.name = '宮城県';   // 都道府県
		todoufuken8.kencode__c = '04';   // 県コード
		todoufuken8.pkey__c = '宮城県';   // PKey
		todoufukenList.add(todoufuken8);

		TodoufuKen__c todoufuken9 = new TodoufuKen__c();
		// todoufuken9.id = 'a177F000000NnGlQAK';    // カスタムオブジェクト ID
		todoufuken9.name = '京都府';   // 都道府県
		todoufuken9.kencode__c = '26';   // 県コード
		todoufuken9.pkey__c = '京都府';   // PKey
		todoufukenList.add(todoufuken9);

		TodoufuKen__c todoufuken10 = new TodoufuKen__c();
		// todoufuken10.id = 'a177F000000NnGmQAK';    // カスタムオブジェクト ID
		todoufuken10.name = '熊本県';   // 都道府県
		todoufuken10.kencode__c = '43';   // 県コード
		todoufuken10.pkey__c = '熊本県';   // PKey
		todoufukenList.add(todoufuken10);

		TodoufuKen__c todoufuken11 = new TodoufuKen__c();
		// todoufuken11.id = 'a177F000000NnGnQAK';    // カスタムオブジェクト ID
		todoufuken11.name = '群馬県';   // 都道府県
		todoufuken11.kencode__c = '10';   // 県コード
		todoufuken11.pkey__c = '群馬県';   // PKey
		todoufukenList.add(todoufuken11);

		TodoufuKen__c todoufuken12 = new TodoufuKen__c();
		// todoufuken12.id = 'a177F000000NnGoQAK';    // カスタムオブジェクト ID
		todoufuken12.name = '広島県';   // 都道府県
		todoufuken12.kencode__c = '34';   // 県コード
		todoufuken12.pkey__c = '広島県';   // PKey
		todoufukenList.add(todoufuken12);

		TodoufuKen__c todoufuken13 = new TodoufuKen__c();
		// todoufuken13.id = 'a177F000000NnGpQAK';    // カスタムオブジェクト ID
		todoufuken13.name = '香川県';   // 都道府県
		todoufuken13.kencode__c = '37';   // 県コード
		todoufuken13.pkey__c = '香川県';   // PKey
		todoufukenList.add(todoufuken13);

		TodoufuKen__c todoufuken14 = new TodoufuKen__c();
		// todoufuken14.id = 'a177F000000NnGqQAK';    // カスタムオブジェクト ID
		todoufuken14.name = '高知県';   // 都道府県
		todoufuken14.kencode__c = '39';   // 県コード
		todoufuken14.pkey__c = '高知県';   // PKey
		todoufukenList.add(todoufuken14);

		TodoufuKen__c todoufuken15 = new TodoufuKen__c();
		// todoufuken15.id = 'a177F000000NnGrQAK';    // カスタムオブジェクト ID
		todoufuken15.name = '佐賀県';   // 都道府県
		todoufuken15.kencode__c = '41';   // 県コード
		todoufuken15.pkey__c = '佐賀県';   // PKey
		todoufukenList.add(todoufuken15);

		TodoufuKen__c todoufuken16 = new TodoufuKen__c();
		// todoufuken16.id = 'a177F000000NnGsQAK';    // カスタムオブジェクト ID
		todoufuken16.name = '埼玉県';   // 都道府県
		todoufuken16.kencode__c = '11';   // 県コード
		todoufuken16.pkey__c = '埼玉県';   // PKey
		todoufukenList.add(todoufuken16);

		TodoufuKen__c todoufuken17 = new TodoufuKen__c();
		// todoufuken17.id = 'a177F000000NnGtQAK';    // カスタムオブジェクト ID
		todoufuken17.name = '三重県';   // 都道府県
		todoufuken17.kencode__c = '24';   // 県コード
		todoufuken17.pkey__c = '三重県';   // PKey
		todoufukenList.add(todoufuken17);

		TodoufuKen__c todoufuken18 = new TodoufuKen__c();
		// todoufuken18.id = 'a177F000000NnGuQAK';    // カスタムオブジェクト ID
		todoufuken18.name = '山形県';   // 都道府県
		todoufuken18.kencode__c = '06';   // 県コード
		todoufuken18.pkey__c = '山形県';   // PKey
		todoufukenList.add(todoufuken18);

		TodoufuKen__c todoufuken19 = new TodoufuKen__c();
		// todoufuken19.id = 'a177F000000NnGvQAK';    // カスタムオブジェクト ID
		todoufuken19.name = '山口県';   // 都道府県
		todoufuken19.kencode__c = '35';   // 県コード
		todoufuken19.pkey__c = '山口県';   // PKey
		todoufukenList.add(todoufuken19);

		TodoufuKen__c todoufuken20 = new TodoufuKen__c();
		// todoufuken20.id = 'a177F000000NnGwQAK';    // カスタムオブジェクト ID
		todoufuken20.name = '山梨県';   // 都道府県
		todoufuken20.kencode__c = '19';   // 県コード
		todoufuken20.pkey__c = '山梨県';   // PKey
		todoufukenList.add(todoufuken20);

		TodoufuKen__c todoufuken21 = new TodoufuKen__c();
		// todoufuken21.id = 'a177F000000NnGxQAK';    // カスタムオブジェクト ID
		todoufuken21.name = '滋賀県';   // 都道府県
		todoufuken21.kencode__c = '25';   // 県コード
		todoufuken21.pkey__c = '滋賀県';   // PKey
		todoufukenList.add(todoufuken21);

		TodoufuKen__c todoufuken22 = new TodoufuKen__c();
		// todoufuken22.id = 'a177F000000NnGyQAK';    // カスタムオブジェクト ID
		todoufuken22.name = '鹿児島県';   // 都道府県
		todoufuken22.kencode__c = '46';   // 県コード
		todoufuken22.pkey__c = '鹿児島県';   // PKey
		todoufukenList.add(todoufuken22);

		TodoufuKen__c todoufuken23 = new TodoufuKen__c();
		// todoufuken23.id = 'a177F000000NnGzQAK';    // カスタムオブジェクト ID
		todoufuken23.name = '秋田県';   // 都道府県
		todoufuken23.kencode__c = '05';   // 県コード
		todoufuken23.pkey__c = '秋田県';   // PKey
		todoufukenList.add(todoufuken23);

		TodoufuKen__c todoufuken24 = new TodoufuKen__c();
		// todoufuken24.id = 'a177F000000NnH0QAK';    // カスタムオブジェクト ID
		todoufuken24.name = '新潟県';   // 都道府県
		todoufuken24.kencode__c = '15';   // 県コード
		todoufuken24.pkey__c = '新潟県';   // PKey
		todoufukenList.add(todoufuken24);

		TodoufuKen__c todoufuken25 = new TodoufuKen__c();
		// todoufuken25.id = 'a177F000000NnH1QAK';    // カスタムオブジェクト ID
		todoufuken25.name = '神奈川県';   // 都道府県
		todoufuken25.kencode__c = '14';   // 県コード
		todoufuken25.pkey__c = '神奈川県';   // PKey
		todoufukenList.add(todoufuken25);

		TodoufuKen__c todoufuken26 = new TodoufuKen__c();
		// todoufuken26.id = 'a177F000000NnH2QAK';    // カスタムオブジェクト ID
		todoufuken26.name = '青森県';   // 都道府県
		todoufuken26.kencode__c = '02';   // 県コード
		todoufuken26.pkey__c = '青森県';   // PKey
		todoufukenList.add(todoufuken26);

		TodoufuKen__c todoufuken27 = new TodoufuKen__c();
		// todoufuken27.id = 'a177F000000NnH3QAK';    // カスタムオブジェクト ID
		todoufuken27.name = '静岡県';   // 都道府県
		todoufuken27.kencode__c = '22';   // 県コード
		todoufuken27.pkey__c = '静岡県';   // PKey
		todoufukenList.add(todoufuken27);

		TodoufuKen__c todoufuken28 = new TodoufuKen__c();
		// todoufuken28.id = 'a177F000000NnH4QAK';    // カスタムオブジェクト ID
		todoufuken28.name = '石川県';   // 都道府県
		todoufuken28.kencode__c = '17';   // 県コード
		todoufuken28.pkey__c = '石川県';   // PKey
		todoufukenList.add(todoufuken28);

		TodoufuKen__c todoufuken29 = new TodoufuKen__c();
		// todoufuken29.id = 'a177F000000NnH5QAK';    // カスタムオブジェクト ID
		todoufuken29.name = '千葉県';   // 都道府県
		todoufuken29.kencode__c = '12';   // 県コード
		todoufuken29.pkey__c = '千葉県';   // PKey
		todoufukenList.add(todoufuken29);

		TodoufuKen__c todoufuken30 = new TodoufuKen__c();
		// todoufuken30.id = 'a177F000000NnH6QAK';    // カスタムオブジェクト ID
		todoufuken30.name = '大阪府';   // 都道府県
		todoufuken30.kencode__c = '27';   // 県コード
		todoufuken30.pkey__c = '大阪府';   // PKey
		todoufukenList.add(todoufuken30);

		TodoufuKen__c todoufuken31 = new TodoufuKen__c();
		// todoufuken31.id = 'a177F000000NnH7QAK';    // カスタムオブジェクト ID
		todoufuken31.name = '大分県';   // 都道府県
		todoufuken31.kencode__c = '44';   // 県コード
		todoufuken31.pkey__c = '大分県';   // PKey
		todoufukenList.add(todoufuken31);

		TodoufuKen__c todoufuken32 = new TodoufuKen__c();
		// todoufuken32.id = 'a177F000000NnH8QAK';    // カスタムオブジェクト ID
		todoufuken32.name = '長崎県';   // 都道府県
		todoufuken32.kencode__c = '42';   // 県コード
		todoufuken32.pkey__c = '長崎県';   // PKey
		todoufukenList.add(todoufuken32);

		TodoufuKen__c todoufuken33 = new TodoufuKen__c();
		// todoufuken33.id = 'a177F000000NnH9QAK';    // カスタムオブジェクト ID
		todoufuken33.name = '長野県';   // 都道府県
		todoufuken33.kencode__c = '20';   // 県コード
		todoufuken33.pkey__c = '長野県';   // PKey
		todoufukenList.add(todoufuken33);

		TodoufuKen__c todoufuken34 = new TodoufuKen__c();
		// todoufuken34.id = 'a177F000000NnHAQA0';    // カスタムオブジェクト ID
		todoufuken34.name = '鳥取県';   // 都道府県
		todoufuken34.kencode__c = '31';   // 県コード
		todoufuken34.pkey__c = '鳥取県';   // PKey
		todoufukenList.add(todoufuken34);

		TodoufuKen__c todoufuken35 = new TodoufuKen__c();
		// todoufuken35.id = 'a177F000000NnHBQA0';    // カスタムオブジェクト ID
		todoufuken35.name = '島根県';   // 都道府県
		todoufuken35.kencode__c = '32';   // 県コード
		todoufuken35.pkey__c = '島根県';   // PKey
		todoufukenList.add(todoufuken35);

		TodoufuKen__c todoufuken36 = new TodoufuKen__c();
		// todoufuken36.id = 'a177F000000NnHCQA0';    // カスタムオブジェクト ID
		todoufuken36.name = '東京都';   // 都道府県
		todoufuken36.kencode__c = '13';   // 県コード
		todoufuken36.pkey__c = '東京都';   // PKey
		todoufukenList.add(todoufuken36);

		TodoufuKen__c todoufuken37 = new TodoufuKen__c();
		// todoufuken37.id = 'a177F000000NnHDQA0';    // カスタムオブジェクト ID
		todoufuken37.name = '徳島県';   // 都道府県
		todoufuken37.kencode__c = '36';   // 県コード
		todoufuken37.pkey__c = '徳島県';   // PKey
		todoufukenList.add(todoufuken37);

		TodoufuKen__c todoufuken38 = new TodoufuKen__c();
		// todoufuken38.id = 'a177F000000NnHEQA0';    // カスタムオブジェクト ID
		todoufuken38.name = '栃木県';   // 都道府県
		todoufuken38.kencode__c = '09';   // 県コード
		todoufuken38.pkey__c = '栃木県';   // PKey
		todoufukenList.add(todoufuken38);

		TodoufuKen__c todoufuken39 = new TodoufuKen__c();
		// todoufuken39.id = 'a177F000000NnHFQA0';    // カスタムオブジェクト ID
		todoufuken39.name = '奈良県';   // 都道府県
		todoufuken39.kencode__c = '29';   // 県コード
		todoufuken39.pkey__c = '奈良県';   // PKey
		todoufukenList.add(todoufuken39);

		TodoufuKen__c todoufuken40 = new TodoufuKen__c();
		// todoufuken40.id = 'a177F000000NnHGQA0';    // カスタムオブジェクト ID
		todoufuken40.name = '富山県';   // 都道府県
		todoufuken40.kencode__c = '16';   // 県コード
		todoufuken40.pkey__c = '富山県';   // PKey
		todoufukenList.add(todoufuken40);

		TodoufuKen__c todoufuken41 = new TodoufuKen__c();
		// todoufuken41.id = 'a177F000000NnHHQA0';    // カスタムオブジェクト ID
		todoufuken41.name = '福井県';   // 都道府県
		todoufuken41.kencode__c = '18';   // 県コード
		todoufuken41.pkey__c = '福井県';   // PKey
		todoufukenList.add(todoufuken41);

		TodoufuKen__c todoufuken42 = new TodoufuKen__c();
		// todoufuken42.id = 'a177F000000NnHIQA0';    // カスタムオブジェクト ID
		todoufuken42.name = '福岡県';   // 都道府県
		todoufuken42.kencode__c = '40';   // 県コード
		todoufuken42.pkey__c = '福岡県';   // PKey
		todoufukenList.add(todoufuken42);

		TodoufuKen__c todoufuken43 = new TodoufuKen__c();
		// todoufuken43.id = 'a177F000000NnHJQA0';    // カスタムオブジェクト ID
		todoufuken43.name = '福島県';   // 都道府県
		todoufuken43.kencode__c = '07';   // 県コード
		todoufuken43.pkey__c = '福島県';   // PKey
		todoufukenList.add(todoufuken43);

		TodoufuKen__c todoufuken44 = new TodoufuKen__c();
		// todoufuken44.id = 'a177F000000NnHKQA0';    // カスタムオブジェクト ID
		todoufuken44.name = '兵庫県';   // 都道府県
		todoufuken44.kencode__c = '28';   // 県コード
		todoufuken44.pkey__c = '兵庫県';   // PKey
		todoufukenList.add(todoufuken44);

		TodoufuKen__c todoufuken45 = new TodoufuKen__c();
		// todoufuken45.id = 'a177F000000NnHLQA0';    // カスタムオブジェクト ID
		todoufuken45.name = '北海道';   // 都道府県
		todoufuken45.kencode__c = '01';   // 県コード
		todoufuken45.pkey__c = '北海道';   // PKey
		todoufukenList.add(todoufuken45);

		TodoufuKen__c todoufuken46 = new TodoufuKen__c();
		// todoufuken46.id = 'a177F000000NnHMQA0';    // カスタムオブジェクト ID
		todoufuken46.name = '和歌山県';   // 都道府県
		todoufuken46.kencode__c = '30';   // 県コード
		todoufuken46.pkey__c = '和歌山県';   // PKey
		todoufukenList.add(todoufuken46);

		return todoufukenList;


	}

	public List<Shikugun__c> getShikugun(List<TodoufuKen__c> todoufukenList){

		List<Shikugun__c> shikugunList = new List<Shikugun__c>();
		Shikugun__c shikugun1271 = new Shikugun__c();
		// shikugun1271.id = 'a0v7F000000aRqIQAU';    // カスタムオブジェクト ID
		shikugun1271.name = '東京都品川区';   // 市区郡名称
		shikugun1271.areacode__c = '13109';   // エリアコード
		shikugun1271.chiriichijouhou__latitude__s = 35.6092261;   // 地理位置情報 (Latitude)
		shikugun1271.chiriichijouhou__longitude__s = 139.7301861;   // 地理位置情報 (Longitude)
		shikugun1271.pkey__c = 'a1110000008LJ3iAAG';   // PKey
		shikugun1271.shikugunmeifurigana__c = 'しながわく';   // 市区郡名(かな)
		shikugun1271.todoufukenref__c = todoufukenList[36].Id;   // 都道府県
		shikugun1271.shikugunmei__c = '品川区';   // 市区郡名
		//shikugun1271.mukobi__c = DateTime.now();   // 無効日
		shikugunList.add(shikugun1271);

		Shikugun__c shikugun1306 = new Shikugun__c();
		// shikugun1306.id = 'a0v7F000000aRz6QAE';    // カスタムオブジェクト ID
		shikugun1306.name = '大阪府大阪市東成区';   // 市区郡名称
		shikugun1306.areacode__c = '27115';   // エリアコード
		shikugun1306.chiriichijouhou__latitude__s = 34.670002;   // 地理位置情報 (Latitude)
		shikugun1306.chiriichijouhou__longitude__s = 135.5412678;   // 地理位置情報 (Longitude)
		shikugun1306.pkey__c = 'a1110000008LJCcAAO';   // PKey
		shikugun1306.shikugunmeifurigana__c = 'おおさかしひがしなりく';   // 市区郡名(かな)
		shikugun1306.todoufukenref__c = todoufukenList[30].Id;   // 都道府県
		shikugun1306.shikugunmei__c = '大阪市東成区';   // 市区郡名
		//shikugun1306.mukobi__c = DateTime.now();   // 無効日
		shikugunList.add(shikugun1306);

		return shikugunList;

	}

	public List<k_ShohinSyubetsu__c> getKShohinSyubetsu(){

		List<k_ShohinSyubetsu__c> k_shohinsyubetsuList = new List<k_ShohinSyubetsu__c>();
		k_ShohinSyubetsu__c k_shohinsyubetsu0 = new k_ShohinSyubetsu__c();
		k_shohinsyubetsu0.name = '本体（委託）';   // 商品種別名
		k_shohinsyubetsu0.id__c = '1';   // ID
		k_shohinsyubetsu0.keijousyubetsu__c = 'グロス';   // 計上種別
		k_shohinsyubetsuList.add(k_shohinsyubetsu0);

		k_ShohinSyubetsu__c k_shohinsyubetsu1 = new k_ShohinSyubetsu__c();
		k_shohinsyubetsu1.name = '本体（手配）';   // 商品種別名
		k_shohinsyubetsu1.id__c = '2';   // ID
		k_shohinsyubetsu1.keijousyubetsu__c = 'ネット';   // 計上種別
		k_shohinsyubetsuList.add(k_shohinsyubetsu1);

		k_ShohinSyubetsu__c k_shohinsyubetsu2 = new k_ShohinSyubetsu__c();
		k_shohinsyubetsu2.name = 'オプション（委託）';   // 商品種別名
		k_shohinsyubetsu2.id__c = '3';   // ID
		k_shohinsyubetsu2.keijousyubetsu__c = 'グロス';   // 計上種別
		k_shohinsyubetsuList.add(k_shohinsyubetsu2);

		k_ShohinSyubetsu__c k_shohinsyubetsu3 = new k_ShohinSyubetsu__c();
		k_shohinsyubetsu3.name = 'オプション（手配）';   // 商品種別名
		k_shohinsyubetsu3.id__c = '4';   // ID
		k_shohinsyubetsu3.keijousyubetsu__c = 'ネット';   // 計上種別
		k_shohinsyubetsuList.add(k_shohinsyubetsu3);

		k_ShohinSyubetsu__c k_shohinsyubetsu4 = new k_ShohinSyubetsu__c();
		k_shohinsyubetsu4.name = '自社単体';   // 商品種別名
		k_shohinsyubetsu4.id__c = '5';   // ID
		k_shohinsyubetsu4.keijousyubetsu__c = 'グロス';   // 計上種別
		k_shohinsyubetsuList.add(k_shohinsyubetsu4);

		k_ShohinSyubetsu__c k_shohinsyubetsu5 = new k_ShohinSyubetsu__c();
		k_shohinsyubetsu5.name = 'アフィリエイト（仮）';   // 商品種別名
		k_shohinsyubetsu5.id__c = '7';   // ID
		k_shohinsyubetsuList.add(k_shohinsyubetsu5);

		k_ShohinSyubetsu__c k_shohinsyubetsu6 = new k_ShohinSyubetsu__c();
		k_shohinsyubetsu6.name = '割引等';   // 商品種別名
		k_shohinsyubetsu6.id__c = '6';   // ID
		k_shohinsyubetsuList.add(k_shohinsyubetsu6);

		return k_shohinsyubetsuList;


	}

	public List<k_ShohinCategory__c> getKShohinCategory(){
		List<k_ShohinCategory__c> k_shohincategoryList = new List<k_ShohinCategory__c>();
		k_ShohinCategory__c k_shohincategory0 = new k_ShohinCategory__c();
		k_shohincategory0.name = '直葬';   // 商品カテゴリ名
		k_shohincategory0.id__c = 'chokusou';   // ID
		k_shohincategoryList.add(k_shohincategory0);

		k_ShohinCategory__c k_shohincategory1 = new k_ShohinCategory__c();
		k_shohincategory1.name = '格安墓石';   // 商品カテゴリ名
		k_shohincategory1.id__c = 'boseki';   // ID
		k_shohincategoryList.add(k_shohincategory1);

		k_ShohinCategory__c k_shohincategory2 = new k_ShohinCategory__c();
		k_shohincategory2.name = '喪主代行';   // 商品カテゴリ名
		k_shohincategory2.id__c = 'daikou';   // ID
		k_shohincategoryList.add(k_shohincategory2);

		k_ShohinCategory__c k_shohincategory3 = new k_ShohinCategory__c();
		k_shohincategory3.name = '永代供養墓';   // 商品カテゴリ名
		k_shohincategory3.id__c = 'eitai';   // ID
		k_shohincategoryList.add(k_shohincategory3);

		k_ShohinCategory__c k_shohincategory4 = new k_ShohinCategory__c();
		k_shohincategory4.name = '永代供養オプション';   // 商品カテゴリ名
		k_shohincategory4.id__c = 'eitai-option';   // ID
		k_shohincategoryList.add(k_shohincategory4);

		k_ShohinCategory__c k_shohincategory5 = new k_ShohinCategory__c();
		k_shohincategory5.name = '法要';   // 商品カテゴリ名
		k_shohincategory5.id__c = 'houyou';   // ID
		k_shohincategoryList.add(k_shohincategory5);

		k_ShohinCategory__c k_shohincategory6 = new k_ShohinCategory__c();
		k_shohincategory6.name = '追加法要';   // 商品カテゴリ名
		k_shohincategory6.id__c = 'houyou-add';   // ID
		k_shohincategoryList.add(k_shohincategory6);

		k_ShohinCategory__c k_shohincategory7 = new k_ShohinCategory__c();
		k_shohincategory7.name = '一日葬';   // 商品カテゴリ名
		k_shohincategory7.id__c = 'ichinichi';   // ID
		k_shohincategoryList.add(k_shohincategory7);

		k_ShohinCategory__c k_shohincategory8 = new k_ShohinCategory__c();
		k_shohincategory8.name = '位牌引取';   // 商品カテゴリ名
		k_shohincategory8.id__c = 'ihai-hikitori';   // ID
		k_shohincategoryList.add(k_shohincategory8);

		k_ShohinCategory__c k_shohincategory9 = new k_ShohinCategory__c();
		k_shohincategory9.name = '一般葬';   // 商品カテゴリ名
		k_shohincategory9.id__c = 'ippansou';   // ID
		k_shohincategoryList.add(k_shohincategory9);

		k_ShohinCategory__c k_shohincategory10 = new k_ShohinCategory__c();
		k_shohincategory10.name = '事前割';   // 商品カテゴリ名
		k_shohincategory10.id__c = 'jizen';   // ID
		k_shohincategoryList.add(k_shohincategory10);

		k_ShohinCategory__c k_shohincategory11 = new k_ShohinCategory__c();
		k_shohincategory11.name = '戒名';   // 商品カテゴリ名
		k_shohincategory11.id__c = 'kaimyou';   // ID
		k_shohincategoryList.add(k_shohincategory11);

		k_ShohinCategory__c k_shohincategory12 = new k_ShohinCategory__c();
		k_shohincategory12.name = '海洋散骨';   // 商品カテゴリ名
		k_shohincategory12.id__c = 'kaiyou';   // ID
		k_shohincategoryList.add(k_shohincategory12);

		k_ShohinCategory__c k_shohincategory13 = new k_ShohinCategory__c();
		k_shohincategory13.name = '家族葬';   // 商品カテゴリ名
		k_shohincategory13.id__c = 'kazokusou';   // ID
		k_shohincategoryList.add(k_shohincategory13);

		k_ShohinCategory__c k_shohincategory14 = new k_ShohinCategory__c();
		k_shohincategory14.name = '枕経';   // 商品カテゴリ名
		k_shohincategory14.id__c = 'makurakyou';   // ID
		k_shohincategoryList.add(k_shohincategory14);

		k_ShohinCategory__c k_shohincategory15 = new k_ShohinCategory__c();
		k_shohincategory15.name = '脇僧追加';   // 商品カテゴリ名
		k_shohincategory15.id__c = 'obou-add';   // ID
		k_shohincategoryList.add(k_shohincategory15);

		k_ShohinCategory__c k_shohincategory16 = new k_ShohinCategory__c();
		k_shohincategory16.name = 'お坊さん移動';   // 商品カテゴリ名
		k_shohincategory16.id__c = 'obou-idou';   // ID
		k_shohincategoryList.add(k_shohincategory16);

		k_ShohinCategory__c k_shohincategory17 = new k_ShohinCategory__c();
		k_shohincategory17.name = '決済手数料';   // 商品カテゴリ名
		k_shohincategory17.id__c = 'payment';   // ID
		k_shohincategoryList.add(k_shohincategory17);

		k_ShohinCategory__c k_shohincategory18 = new k_ShohinCategory__c();
		k_shohincategory18.name = '初七日法要';   // 商品カテゴリ名
		k_shohincategory18.id__c = 'shonanoka';   // ID
		k_shohincategoryList.add(k_shohincategory18);

		k_ShohinCategory__c k_shohincategory19 = new k_ShohinCategory__c();
		k_shohincategory19.name = '葬儀読経';   // 商品カテゴリ名
		k_shohincategory19.id__c = 'sougidokyou';   // ID
		k_shohincategoryList.add(k_shohincategory19);

		k_ShohinCategory__c k_shohincategory20 = new k_ShohinCategory__c();
		k_shohincategory20.name = '葬儀オプション';   // 商品カテゴリ名
		k_shohincategory20.id__c = 'sougiOption';   // ID
		k_shohincategoryList.add(k_shohincategory20);

		k_ShohinCategory__c k_shohincategory21 = new k_ShohinCategory__c();
		k_shohincategory21.name = '葬儀レビ';   // 商品カテゴリ名
		k_shohincategory21.id__c = 'sougiRevi';   // ID
		k_shohincategoryList.add(k_shohincategory21);

		k_ShohinCategory__c k_shohincategory22 = new k_ShohinCategory__c();
		k_shohincategory22.name = '法要人数追加';   // 商品カテゴリ名
		k_shohincategory22.id__c = 'taishou-tuika';   // ID
		k_shohincategoryList.add(k_shohincategory22);

		k_ShohinCategory__c k_shohincategory23 = new k_ShohinCategory__c();
		k_shohincategory23.name = '安豪';   // 商品カテゴリ名
		k_shohincategory23.id__c = 'yasugou-ichinichi';   // ID
		k_shohincategoryList.add(k_shohincategory23);

		k_ShohinCategory__c k_shohincategory24 = new k_ShohinCategory__c();
		k_shohincategory24.name = '安豪';   // 商品カテゴリ名
		k_shohincategory24.id__c = 'yasugou-kasou';   // ID
		k_shohincategoryList.add(k_shohincategory24);

		k_ShohinCategory__c k_shohincategory25 = new k_ShohinCategory__c();
		k_shohincategory25.name = '安豪';   // 商品カテゴリ名
		k_shohincategory25.id__c = 'yasugou-kazoku';   // ID
		k_shohincategoryList.add(k_shohincategory25);

		k_ShohinCategory__c k_shohincategory26 = new k_ShohinCategory__c();
		k_shohincategory26.name = '安豪オプション';   // 商品カテゴリ名
		k_shohincategory26.id__c = 'yasugou-option';   // ID
		k_shohincategoryList.add(k_shohincategory26);

		k_ShohinCategory__c k_shohincategory27 = new k_ShohinCategory__c();
		k_shohincategory27.name = 'お葬式予約';   // 商品カテゴリ名
		k_shohincategory27.id__c = 'yoyaku';   // ID
		k_shohincategoryList.add(k_shohincategory27);

		k_ShohinCategory__c k_shohincategory28 = new k_ShohinCategory__c();
		k_shohincategory28.name = '火葬式';   // 商品カテゴリ名
		k_shohincategory28.id__c = 'kasou';   // ID
		k_shohincategoryList.add(k_shohincategory28);

		k_ShohinCategory__c k_shohincategory29 = new k_ShohinCategory__c();
		k_shohincategory29.name = 'ベスト仏壇';   // 商品カテゴリ名
		k_shohincategory29.id__c = 'butsudan';   // ID
		k_shohincategoryList.add(k_shohincategory29);

		k_ShohinCategory__c k_shohincategory30 = new k_ShohinCategory__c();
		k_shohincategory30.name = '遺品整理';   // 商品カテゴリ名
		k_shohincategory30.id__c = 'ihinseiri';   // ID
		k_shohincategoryList.add(k_shohincategory30);

		k_ShohinCategory__c k_shohincategory31 = new k_ShohinCategory__c();
		k_shohincategory31.name = '香典返し';   // 商品カテゴリ名
		k_shohincategory31.id__c = 'koudengaeshi';   // ID
		k_shohincategoryList.add(k_shohincategory31);

		k_ShohinCategory__c k_shohincategory32 = new k_ShohinCategory__c();
		k_shohincategory32.name = '思い出保存';   // 商品カテゴリ名
		k_shohincategory32.id__c = 'omoide';   // ID
		k_shohincategoryList.add(k_shohincategory32);

		k_ShohinCategory__c k_shohincategory33 = new k_ShohinCategory__c();
		k_shohincategory33.name = 'sorae';   // 商品カテゴリ名
		k_shohincategory33.id__c = 'sorae';   // ID
		k_shohincategoryList.add(k_shohincategory33);

		k_ShohinCategory__c k_shohincategory34 = new k_ShohinCategory__c();
		k_shohincategory34.name = '相続相談';   // 商品カテゴリ名
		k_shohincategory34.id__c = 'souzoku';   // ID
		k_shohincategoryList.add(k_shohincategory34);

		k_ShohinCategory__c k_shohincategory35 = new k_ShohinCategory__c();
		k_shohincategory35.name = '手元供養品';   // 商品カテゴリ名
		k_shohincategory35.id__c = 'temoto';   // ID
		k_shohincategoryList.add(k_shohincategory35);

		k_ShohinCategory__c k_shohincategory36 = new k_ShohinCategory__c();
		k_shohincategory36.name = '割引';   // 商品カテゴリ名
		k_shohincategory36.id__c = 'waribiki';   // ID
		k_shohincategoryList.add(k_shohincategory36);

		k_ShohinCategory__c k_shohincategory37 = new k_ShohinCategory__c();
		k_shohincategory37.name = '葬儀戒名';   // 商品カテゴリ名
		k_shohincategory37.id__c = 'sougikaimyou';   // ID
		k_shohincategoryList.add(k_shohincategory37);

		k_ShohinCategory__c k_shohincategory38 = new k_ShohinCategory__c();
		k_shohincategory38.name = 'お坊さん便オプション';   // 商品カテゴリ名
		k_shohincategory38.id__c = 'obou-option';   // ID
		k_shohincategoryList.add(k_shohincategory38);

		k_ShohinCategory__c k_shohincategory39 = new k_ShohinCategory__c();
		k_shohincategory39.name = 'お坊さん便移行';   // 商品カテゴリ名
		k_shohincategory39.id__c = 'obou-ikou';   // ID
		k_shohincategoryList.add(k_shohincategory39);

		return k_shohincategoryList;

	}

		

	public List<k_WaribikiPlan__c> getKWaribikiPlan(){
		List<k_WaribikiPlan__c> k_waribikiplanList = new List<k_WaribikiPlan__c>();
		k_WaribikiPlan__c k_waribikiplan0 = new k_WaribikiPlan__c();
		k_waribikiplan0.name = 'なし';   // 割引プラン名
		k_waribikiplan0.id__c = '0';   // ID
		k_waribikiplanList.add(k_waribikiplan0);

		k_WaribikiPlan__c k_waribikiplan1 = new k_WaribikiPlan__c();
		k_waribikiplan1.name = '資料請求割引';   // 割引プラン名
		k_waribikiplan1.id__c = '1';   // ID
		k_waribikiplanList.add(k_waribikiplan1);

		k_WaribikiPlan__c k_waribikiplan2 = new k_WaribikiPlan__c();
		k_waribikiplan2.name = '事前割';   // 割引プラン名
		k_waribikiplan2.id__c = '2';   // ID
		k_waribikiplanList.add(k_waribikiplan2);

		k_WaribikiPlan__c k_waribikiplan3 = new k_WaribikiPlan__c();
		k_waribikiplan3.name = '生前契約';   // 割引プラン名
		k_waribikiplan3.id__c = '3';   // ID
		k_waribikiplanList.add(k_waribikiplan3);

		k_WaribikiPlan__c k_waribikiplan4 = new k_WaribikiPlan__c();
		k_waribikiplan4.name = '無料会員';   // 割引プラン名
		k_waribikiplan4.id__c = '4';   // ID
		k_waribikiplanList.add(k_waribikiplan4);

		k_WaribikiPlan__c k_waribikiplan5 = new k_WaribikiPlan__c();
		k_waribikiplan5.name = '事前割会員';   // 割引プラン名
		k_waribikiplan5.id__c = '5';   // ID
		k_waribikiplanList.add(k_waribikiplan5);

		k_WaribikiPlan__c k_waribikiplan6 = new k_WaribikiPlan__c();
		k_waribikiplan6.name = 'お葬式予約会員';   // 割引プラン名
		k_waribikiplan6.id__c = '6';   // ID
		k_waribikiplanList.add(k_waribikiplan6);

		return k_waribikiplanList;


	}

	public List<k_Service__c> getKService(){
		List<k_Service__c> k_serviceList = new List<k_Service__c>();
		k_Service__c k_service0 = new k_Service__c();
		k_service0.name = '特約店';   // サービス名
		k_service0.id__c = '20';   // ID
		k_serviceList.add(k_service0);

		k_Service__c k_service1 = new k_Service__c();
		k_service1.name = 'シンプルな永代供養墓';   // サービス名
		k_service1.id__c = '5';   // ID
		k_serviceList.add(k_service1);

		k_Service__c k_service2 = new k_Service__c();
		k_service2.name = '葬儀レビ';   // サービス名
		k_service2.id__c = '10';   // ID
		k_serviceList.add(k_service2);

		k_Service__c k_service3 = new k_Service__c();
		k_service3.name = '相続相談';   // サービス名
		k_service3.id__c = '17';   // ID
		k_serviceList.add(k_service3);

		k_Service__c k_service4 = new k_Service__c();
		k_service4.name = '安くて豪華なお葬式';   // サービス名
		k_service4.id__c = '2';   // ID
		k_serviceList.add(k_service4);

		k_Service__c k_service5 = new k_Service__c();
		k_service5.name = '思い出保存';   // サービス名
		k_service5.id__c = '19';   // ID
		k_serviceList.add(k_service5);

		k_Service__c k_service6 = new k_Service__c();
		k_service6.name = '格安墓石';   // サービス名
		k_service6.id__c = '7';   // ID
		k_serviceList.add(k_service6);

		k_Service__c k_service7 = new k_Service__c();
		k_service7.name = '海洋散骨Umie';   // サービス名
		k_service7.id__c = '6';   // ID
		k_serviceList.add(k_service7);

		k_Service__c k_service8 = new k_Service__c();
		k_service8.name = '喪主代行';   // サービス名
		k_service8.id__c = '14';   // ID
		k_serviceList.add(k_service8);

		k_Service__c k_service9 = new k_Service__c();
		k_service9.name = 'シンプルなお葬式予約';   // サービス名
		k_service9.id__c = '13';   // ID
		k_serviceList.add(k_service9);

		k_Service__c k_service10 = new k_Service__c();
		k_service10.name = '供花配達レビ';   // サービス名
		k_service10.id__c = '8';   // ID
		k_serviceList.add(k_service10);

		k_Service__c k_service11 = new k_Service__c();
		k_service11.name = 'お坊さん便';   // サービス名
		k_service11.id__c = '3';   // ID
		k_serviceList.add(k_service11);

		k_Service__c k_service12 = new k_Service__c();
		k_service12.name = '手元供養品';   // サービス名
		k_service12.id__c = '16';   // ID
		k_serviceList.add(k_service12);

		k_Service__c k_service13 = new k_Service__c();
		k_service13.name = '宇宙葬Sorae';   // サービス名
		k_service13.id__c = '11';   // ID
		k_serviceList.add(k_service13);

		k_Service__c k_service14 = new k_Service__c();
		k_service14.name = 'ベスト仏壇';   // サービス名
		k_service14.id__c = '4';   // ID
		k_serviceList.add(k_service14);

		k_Service__c k_service15 = new k_Service__c();
		k_service15.name = '香典返し';   // サービス名
		k_service15.id__c = '15';   // ID
		k_serviceList.add(k_service15);

		k_Service__c k_service16 = new k_Service__c();
		k_service16.name = 'シンプルなお葬式';   // サービス名
		k_service16.id__c = '1';   // ID
		k_serviceList.add(k_service16);

		k_Service__c k_service17 = new k_Service__c();
		k_service17.name = '墓ピタ';   // サービス名
		k_service17.id__c = '9';   // ID
		k_serviceList.add(k_service17);

		k_Service__c k_service18 = new k_Service__c();
		k_service18.name = 'シンプルな事前割';   // サービス名
		k_service18.id__c = '12';   // ID
		k_serviceList.add(k_service18);

		return k_serviceList;
	}

	public List<k_Coupon__c> getKCoupon(){
		List<k_Coupon__c> k_couponList = new List<k_Coupon__c>();
		k_Coupon__c k_coupon0 = new k_Coupon__c();
		k_coupon0.name = 'お坊さん便　Web申込割引';   // クーポン名
		k_coupon0.id__c = '17';   // ID
		k_couponList.add(k_coupon0);

		k_Coupon__c k_coupon1 = new k_Coupon__c();
		k_coupon1.name = 'シンプルな海洋散骨　Umie　事前メンバー割引';   // クーポン名
		k_coupon1.id__c = '12';   // ID
		k_couponList.add(k_coupon1);

		k_Coupon__c k_coupon2 = new k_Coupon__c();
		k_coupon2.name = 'シンプルな永代供養墓　事前メンバー割引';   // クーポン名
		k_coupon2.id__c = '9';   // ID
		k_couponList.add(k_coupon2);

		k_Coupon__c k_coupon3 = new k_Coupon__c();
		k_coupon3.name = 'シンプルな海洋散骨　Umie　無料メンバー割引';   // クーポン名
		k_coupon3.id__c = '11';   // ID
		k_couponList.add(k_coupon3);

		k_Coupon__c k_coupon4 = new k_Coupon__c();
		k_coupon4.name = 'お坊さん便セット割（事前メンバー）';   // クーポン名
		k_coupon4.id__c = '6';   // ID
		k_couponList.add(k_coupon4);

		k_Coupon__c k_coupon5 = new k_Coupon__c();
		k_coupon5.name = 'シンプルな永代供養墓　お葬式予約メンバー割引';   // クーポン名
		k_coupon5.id__c = '10';   // ID
		k_couponList.add(k_coupon5);

		k_Coupon__c k_coupon6 = new k_Coupon__c();
		k_coupon6.name = 'シンプルな海洋散骨　Umie　お葬式予約メンバー割引';   // クーポン名
		k_coupon6.id__c = '13';   // ID
		k_couponList.add(k_coupon6);

		k_Coupon__c k_coupon7 = new k_Coupon__c();
		k_coupon7.name = 'お坊さん便セット割（お葬式予約メンバー）';   // クーポン名
		k_coupon7.id__c = '7';   // ID
		k_couponList.add(k_coupon7);

		k_Coupon__c k_coupon8 = new k_Coupon__c();
		k_coupon8.name = 'お坊さん便セット割（無料メンバー）';   // クーポン名
		k_coupon8.id__c = '5';   // ID
		k_couponList.add(k_coupon8);

		k_Coupon__c k_coupon9 = new k_Coupon__c();
		k_coupon9.name = 'お坊さん便リピート割（事前割メンバー）';   // クーポン名
		k_coupon9.id__c = '3';   // ID
		k_couponList.add(k_coupon9);

		k_Coupon__c k_coupon10 = new k_Coupon__c();
		k_coupon10.name = 'メンバー　事前準備シート記入割引';   // クーポン名
		k_coupon10.id__c = '1';   // ID
		k_couponList.add(k_coupon10);

		k_Coupon__c k_coupon11 = new k_Coupon__c();
		k_coupon11.name = 'お坊さん便リピート割（お葬式予約メンバー）';   // クーポン名
		k_coupon11.id__c = '4';   // ID
		k_couponList.add(k_coupon11);

		k_Coupon__c k_coupon12 = new k_Coupon__c();
		k_coupon12.name = 'シンプルな永代供養墓　無料メンバー割引';   // クーポン名
		k_coupon12.id__c = '8';   // ID
		k_couponList.add(k_coupon12);

		k_Coupon__c k_coupon13 = new k_Coupon__c();
		k_coupon13.name = 'お坊さん便リピート割（無料メンバー）';   // クーポン名
		k_coupon13.id__c = '2';   // ID
		k_couponList.add(k_coupon13);

		k_Coupon__c k_coupon14 = new k_Coupon__c();
		k_coupon14.name = 'ベスト仏壇　優待券（１万円割引）';   // クーポン名
		k_coupon14.id__c = '14';   // ID
		k_couponList.add(k_coupon14);

		k_Coupon__c k_coupon15 = new k_Coupon__c();
		k_coupon15.name = 'その他お客様向け割引（CS起因）';   // クーポン名
		k_coupon15.id__c = '15';   // ID
		k_couponList.add(k_coupon15);

		k_Coupon__c k_coupon16 = new k_Coupon__c();
		k_coupon16.name = 'その他お客様向け割引（パートナー起因）';   // クーポン名
		k_coupon16.id__c = '16';   // ID
		k_couponList.add(k_coupon16);

		return k_couponList;
	}

	public List<JizenWariPlan__c> getJizenWariPlan(){
		List<JizenWariPlan__c> jizenwariplanList = new List<JizenWariPlan__c>();
		JizenWariPlan__c jizenwariplan0 = new JizenWariPlan__c();
		jizenwariplan0.name = 'ポスタルクラブ';   // 事前割プラン名
		jizenwariplan0.code__c = 'PostalClub';   // Code
		jizenwariplan0.riyokaisuseigenari__c = True;   // 利用回数制限有
		jizenwariplan0.searchbunruitag__c = '@@';   // 検索分類タグ
		jizenwariplan0.yukotsukisu__c = 0.0;   // 有効月数
		jizenwariplanList.add(jizenwariplan0);

		JizenWariPlan__c jizenwariplan1 = new JizenWariPlan__c();
		jizenwariplan1.name = '旧制度 6年有効';   // 事前割プラン名
		jizenwariplan1.code__c = 'v2017_6Year';   // Code
		jizenwariplan1.riyokaisuseigenari__c = True;   // 利用回数制限有
		jizenwariplan1.searchbunruitag__c = '@@';   // 検索分類タグ
		jizenwariplan1.yukotsukisu__c = 72.0;   // 有効月数
		jizenwariplanList.add(jizenwariplan1);

		JizenWariPlan__c jizenwariplan2 = new JizenWariPlan__c();
		jizenwariplan2.name = 'よりそうメンバー';   // 事前割プラン名
		jizenwariplan2.code__c = 'Yoriso';   // Code
		jizenwariplan2.riyokaisuseigenari__c = False;   // 利用回数制限有
		jizenwariplan2.searchbunruitag__c = '@@';   // 検索分類タグ
		jizenwariplan2.yukotsukisu__c = 0.0;   // 有効月数
		jizenwariplanList.add(jizenwariplan2);

		JizenWariPlan__c jizenwariplan3 = new JizenWariPlan__c();
		jizenwariplan3.name = '旧制度　無期限';   // 事前割プラン名
		jizenwariplan3.code__c = 'v2017__Free';   // Code
		jizenwariplan3.riyokaisuseigenari__c = True;   // 利用回数制限有
		jizenwariplan3.searchbunruitag__c = '@@';   // 検索分類タグ
		jizenwariplan3.yukotsukisu__c = 0.0;   // 有効月数
		jizenwariplanList.add(jizenwariplan3);

		JizenWariPlan__c jizenwariplan4 = new JizenWariPlan__c();
		jizenwariplan4.name = '旧制度 3年有効';   // 事前割プラン名
		jizenwariplan4.code__c = 'v2017_3Year';   // Code
		jizenwariplan4.riyokaisuseigenari__c = True;   // 利用回数制限有
		jizenwariplan4.searchbunruitag__c = '@@';   // 検索分類タグ
		jizenwariplan4.yukotsukisu__c = 36.0;   // 有効月数
		jizenwariplanList.add(jizenwariplan4);

		return jizenwariplanList;
	}

	public Account getAccountNull(){
        RecordType defualtAccountRT = new RecordTypeDao().selectRecordBySobjectTypeDeveloperName('Account', 'null');
		Account dacc = new Account();
		dacc.LastName = 'Sample取引先を設定してください';
		dacc.Phone = '081-1234-0001';
		dacc.MobilePhone__c = '082-1234-0001';
		dacc.recordTypeId = defualtAccountRT.Id;
		return dacc;
	}
	public Account getAccountSoryo(){
        RecordType defualtAccountRT = new RecordTypeDao().selectRecordBySobjectTypeDeveloperName('Account', 'Soryo');
		Account dacc = new Account();
		dacc.LastName = 'Sample僧侶';
		dacc.Phone = '081-1234-0002';
		dacc.MobilePhone__c = '082-1234-0002';
		dacc.recordTypeId = defualtAccountRT.Id;
		return dacc;
	}
	public Account getAccountCustomer(){
        RecordType defualtAccountRT = new RecordTypeDao().selectRecordBySobjectTypeDeveloperName('Account', 'Customer');
		Account dacc = new Account();
		dacc.LastName = 'Sampleお客様';
		dacc.Phone = '081-1234-0003';
		dacc.MobilePhone__c = '082-1234-0003';
		dacc.recordTypeId = defualtAccountRT.Id;
		return dacc;
	}
	public Account getAccountDefault(){
        RecordType defualtAccountRT = new RecordTypeDao().selectRecordBySobjectTypeDeveloperName('Account', 'Default');
		Account dacc = new Account();
		dacc.Name = 'Sample取引先';
		dacc.Phone = '081-1234-0004';
		dacc.MobilePhone__c = '082-1234-0004';
		dacc.recordTypeId = defualtAccountRT.Id;
		return dacc;
	}
	public Account getAccountSoryoAccount(){
        RecordType defualtAccountRT = new RecordTypeDao().selectRecordBySobjectTypeDeveloperName('Account', 'SoryoAccount');
		Account dacc = new Account();
		dacc.Name = 'Sample僧侶(取引先)';
		dacc.Phone = '081-1234-0005';
		dacc.MobilePhone__c = '082-1234-0005';
		dacc.recordTypeId = defualtAccountRT.Id;
		return dacc;
	}
	public Account getAccountJiin(){
        RecordType defualtAccountRT = new RecordTypeDao().selectRecordBySobjectTypeDeveloperName('Account', 'Jiin');
		Account dacc = new Account();
		dacc.Name = 'Sample寺院';
		dacc.Phone = '081-1234-0006';
		dacc.MobilePhone__c = '082-1234-0006';
		dacc.recordTypeId = defualtAccountRT.Id;
		return dacc;
	}
	public Account getAccountMosyuDaikoSya(){
        RecordType defualtAccountRT = new RecordTypeDao().selectRecordBySobjectTypeDeveloperName('Account', 'MosyuDaikoSya');
		Account dacc = new Account();
		dacc.LastName = 'Sample喪主代行者';
		dacc.Phone = '081-1234-0007';
		dacc.MobilePhone__c = '082-1234-0007';
		dacc.recordTypeId = defualtAccountRT.Id;
		return dacc;
	}
	public Account getAccountSogisya(){
        RecordType defualtAccountRT = new RecordTypeDao().selectRecordBySobjectTypeDeveloperName('Account', 'Sogisya');
		Account dacc = new Account();
		dacc.Name = 'Sample葬儀社';
		dacc.Phone = '081-1234-0008';
		dacc.MobilePhone__c = '082-1234-0008';
		dacc.recordTypeId = defualtAccountRT.Id;
		return dacc;
	}

	public void buildSimpleYasugo(){
	    String json_str = '{'+
	    '\"mail_syori_id\":\"11111\",'+
	    '\"toiawase_date\":\"2017-04-10\",'+
	    '\"iriguchi_name\":\"資料請求\",'+	    
	    '\"customer_sei\":\"テスト\",'+
	    '\"customer_mei\":\"テスト\",'+
	    '\"customer_sei_kana\":\"テスト\",'+
	    '\"customer_mei_kana\":\"テスト\",'+
	    '\"customer_mail\":\"minrevi_yoriso_simpleyasugo@yoriso.test.test.jp\",'+
	    '\"customer_comment\":\"テストです\"'+
	    '}';
        Api_V1_SimpleYasugoToiawase.Data theData = (Api_V1_SimpleYasugoToiawase.Data)JSON.deserialize(json_str, Api_V1_SimpleYasugoToiawase.Data.class);

        // ケース作成
        Case newCase = new Case();
        newCase.RecordTypeId         = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','SimpleYasugoOtoiawaseWebForm');
        newCase.Status               = '新規';
        newCase.Origin               = 'Web';
        newCase.uniq_id__c           = theData.mail_syori_id;
        newCase.ToiawaseDate__c      = Com_Utility.toDateTime(theData.toiawase_date);
        newCase.Entrance__c          = theData.iriguchi_name;
        newCase.Lastname__c          = theData.customer_sei;
        newCase.Firstname__c         = theData.customer_mei;
        newCase.LastNameKana__c      = theData.customer_sei_kana;
        newCase.FirstNameKana__c     = theData.customer_mei_kana;
        newCase.MailAddress__c       = theData.customer_mail;
        newCase.OkyakusamaCommnet__c = theData.customer_comment;
        insert newCase;
	}

	public List<Opportunity> buildObosanbinOpp(){
		Api_V1_ObousanbinMoushikomi.Data theData = (Api_V1_ObousanbinMoushikomi.Data)JSON.deserialize(this.getObosanRequestString(), Api_V1_ObousanbinMoushikomi.Data.class);
        // ケース作成
        Case newCase = new Case();
        //レコードタイプID
        newCase.RecordTypeId         = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','ObousanbinNetYoyaku');

        newCase.Status               = '新規';
        newCase.Origin               = 'Web';            
        //メール処理Id
        newCase.uniq_id__c           = theData.mail_syori_id;
        //問合せ日
        newCase.ToiawaseDate__c      = Com_Utility.toDateTime(theData.toiawase_date);      
        //入口
        newCase.Entrance__c          = theData.iriguchi_name;
        //申込者姓
        newCase.LastName__c          = theData.customer_sei;
        //申込者名
        newCase.FirstName__c         = theData.customer_mei;
        //申込者姓(カナ)
        newCase.LastNameKana__c      = theData.customer_sei_kana;
        //申込者名(カナ)
        newCase.FirstNameKana__c     = theData.customer_mei_kana;            
        //電話番号            
        if(Com_Utility.isMobile(theData.customer_tel)) {
            newCase.KeitaiDenwa__c       = theData.customer_tel;
        }
        else{
            newCase.TelNo__c             = theData.customer_tel;
        }            
        //申込者メールアドレス
        newCase.MailAddress__c       = theData.customer_mail; 
        //申込者住所.郵便番号
        newCase.PostalCode__c       = theData.customer_postal_code;
        //申込者住所.都道府県
        newCase.State__c       = theData.customer_state;
        //申込者住所.市区郡
        newCase.City__c       = theData.customer_city;
        //申込者住所.町名番地
        newCase.Street__c       = theData.customer_street;
        //資料送付先住所.郵便番号
        newCase.ShiryohassosakiZipCode__c       = theData.siryo_sofu_postal_code;
        //資料送付先住所.都道府県
        newCase.ShiryohassosakiState__c       = theData.siryo_sofu_state;
        //資料送付先住所.市区郡
        newCase.ShiryohassosakiCity__c       = theData.siryo_sofu_city;
        //資料送付先住所.町名番地
        newCase.ShiryohassosakiStreet__c       = theData.siryo_sofu_street;
        //対象者姓
        newCase.TaishoshaSei__c       = theData.taisyosya_sei;
        //対象者名
        newCase.TaishoshaMei__c       = theData.taisyosya_mei;
        //対象者姓(カナ)
        newCase.TaishoshaSeiFurigana__c       = theData.taisyosya_sei_kana;
        //対象者名(カナ)
        newCase.TaishoshaMeiFurigana__c       = theData.taisyosya_mei_kana;
        //対象者生年月日
        newCase.TaishoshaSeinengappi__c       = Com_Utility.toDate(theData.taisyosya_birthday);        
        //対象者逝去日
        newCase.TaishoushaBotsunengappi__c       = Com_Utility.toDate(theData.taisyosya_seikyodate);      
        //対象者続柄
        newCase.ZokugaraSodanshaNitottenoTaishosha__c       = theData.taisyosya_zokugara;      
        //対象者宗派
        newCase.Shuha__c       = theData.taisyosya_syuha;
        //対象者その他宗派
        newCase.SonotanoSyukyoSyuha__c       = theData.taisyosya_sonotasyuha;
        //菩提寺有無
        newCase.TaishoshaBodaijinoUmu__c       = Api_V1_ItemValueMaster.getTaisyosyaBodaijiUmu(theData.taisyosya_bodaiji_umu);
        //法要場所.名称
        newCase.HoyobashoMei__c       = theData.hoyo_basyo_name;
        //法要場所.郵便番号
        newCase.HoyobashoZipCode__c       = theData.hoyo_basyo_postal_code;
        //法要場所.都道府県
        newCase.HoyobashoState__c       = theData.hoyo_basyo_state;
        //法要場所.市区郡
        newCase.HoyobashoCity__c       = theData.hoyo_basyo_city;
        //法要場所.町名番地
        newCase.HoyobashoStreet__c       = theData.hoyo_basyo_street;
        //法要場所2.名称
        newCase.TsuikahoyobashoMei__c       = theData.hoyo_basyo2_name;
        //法要場所2.郵便番号
        newCase.TsuikahoyobashoZipCode__c       = theData.hoyo_basyo2_postal_code;
        //法要場所2.都道府県
        newCase.TsuikahoyobashoState__c       = theData.hoyo_basyo2_state;
        //法要場所2.市区郡
        newCase.TsuikahoyobashoCity__c       = theData.hoyo_basyo2_city;
        //法要場所2.町名番地
        newCase.TsuikahoyobashoStreet__c       = theData.hoyo_basyo2_street;
        //第一希望.日付
        newCase.HoyoKiboDate1__c       = Com_Utility.toDate(theData.hoyo_date1);       
        //第一希望.時間
        newCase.HoyoKiboTime1__c       = theData.hoyo_hour1;
        //第一希望.分
        newCase.HoyoKiboMinute1__c       = theData.hoyo_minute1;
        //第二希望.日付
        newCase.HoyoKiboDate2__c       = Com_Utility.toDate(theData.hoyo_date2);                
        //第二希望.時間
        newCase.HoyoKiboTime2__c       = theData.hoyo_hour2;
        //第二希望.分
        newCase.HoyoKiboMinute2__c       = theData.hoyo_minute2;
        //第三希望.日付
        newCase.HoyoKiboDate3__c       = Com_Utility.toDate(theData.hoyo_date3);         
        //第三希望.時間
        newCase.HoyoKiboTime3__c       = theData.hoyo_hour3;
        //第三希望.分
        newCase.HoyoKiboMinute3__c       = theData.hoyo_minute3;
        //お坊さん便.法事法要
        newCase.HojiHoyo__c       = Api_V1_ItemValueMaster.getHojiHoyo(theData.hoyo);
        //お坊さん便.その他法要
        newCase.SonotanoHoyo__c       = theData.sonota_hoyo;    
        //お坊さん便.追加法要	
        newCase.TsuikaHoyo__c       = theData.tsuika_hoyo;
        //お坊さん便.戒名授与希望
        newCase.KaimyoHomeijuyo__c       = Api_V1_ItemValueMaster.getKaimyoHomeijuyo(theData.kaimyo_kibo);
        //お坊さん便.希望戒名
        newCase.KaimyoPlan__c       = Api_V1_ItemValueMaster.getKaimyoPlan(theData.kaimyo_plan); 
        //お客様コメント  
        newCase.OkyakusamaCommnet__c       = theData.customer_comment; 
        //確認連絡の希望有無
        newCase.KakuninRenrakuNoKiboUmu__c       = Api_V1_ItemValueMaster.getKakuninRenrakuNoKiboUmu(theData.kakunin_renraku_kibo);
        //利用回数
        newCase.Riyokaisu__c       = Api_V1_ItemValueMaster.getRiyokaisu(theData.riyokaisu); 
        //お盆セット
        newCase.Obonset__c       = Api_V1_ItemValueMaster.getObonsetMap(theData.obonset);
        //商品送付先
        newCase.ProductPlaceSelect__c       = theData.productPlaceSelect; 
            
        insert newCase;
		List<ObosanbinNittei__c> obousanbinNittei = new Ctl_ObosanbinService.ObosanbinNittei().FrontToObosanbinNittei(newCase, theData.tsuika_nitteis);
		List<Opportunity> obousanbinOpp = new Ctl_ObosanbinService.ObosanbinWebYouyaku().CaseToServiceOpportunity(newCase, obousanbinNittei);

        return obousanbinOpp;
	}	

	private String getObosanRequestString(){
		return '{' +
		'	"mail_syori_id": "%not null%",' +
		'	"toiawase_date": "%today%",' +
		'	"iriguchi_name": "メール",' +
		'	"riyokaisu": "hajimete",' +
		'	"hoyo": "hatsubonarabon",' +
		'	"sonota_hoyo": "",' +
		'	"taisyosya_syuha": "天台宗",' +
		'	"taisyosya_sonotasyuha": "",' +
		'	"taisyosya_bodaiji_umu": "yes",' +
		'	"tsuika_hoyo": "位牌開眼法要",' +
		'	"kaimyo_kibo": "yes",' +
		'	"kaimyo_plan": "shinjiShinnyo",' +
		'	"hoyo_date1": "43191",' +
		'	"hoyo_hour1": "",' +
		'	"hoyo_minute1": "",' +
		'	"hoyo_date2": "",' +
		'	"hoyo_hour2": "",' +
		'	"hoyo_minute2": "",' +
		'	"hoyo_date3": "",' +
		'	"hoyo_hour3": "",' +
		'	"hoyo_minute3": "",' +
		'	"customer_sei": "自動試験",' +
		'	"customer_mei": "Ｗｅｂ受付テスト１",' +
		'	"customer_sei_kana": "ジドウシケン201807031555",' +
		'	"customer_mei_kana": "タロウ201807031555",' +
		'	"customer_tel": "201807031555",' +
		'	"customer_mail": "dev-test+houjiyoyaku201807031555@minrevi.jp",' +
		'	"customer_postal_code": "1000001",' +
		'	"customer_state": "東京都",' +
		'	"customer_city": "千代田区",' +
		'	"customer_street": "千代田ａｂｃｄ１２３４５１２３４５",' +
		'	"hoyo_basyo_name": "斎場・ホール(斎場・ホールのテキスト)",' +
		'	"hoyo_basyo_postal_code": "1000001",' +
		'	"hoyo_basyo_state": "東京都",' +
		'	"hoyo_basyo_city": "千代田区",' +
		'	"hoyo_basyo_street": "千代田ａｂｃｄ１２３４５１２３４５",' +
		'	"hoyo_basyo2_name": "",' +
		'	"hoyo_basyo2_postal_code": "",' +
		'	"hoyo_basyo2_state": "",' +
		'	"hoyo_basyo2_city": "",' +
		'	"hoyo_basyo2_street": "",' +
		'	"siryo_sofu_postal_code": "1000001",' +
		'	"siryo_sofu_state": "東京都",' +
		'	"siryo_sofu_city": "千代田区",' +
		'	"siryo_sofu_street": "千代田ａｂｃｄ１２３４５１２３４５",' +
		'	"taisyosya_sei": "故人様姓",' +
		'	"taisyosya_mei": "故人様名",' +
		'	"taisyosya_sei_kana": "コジンサマセイ",' +
		'	"taisyosya_mei_kana": "コジンサマメイ",' +
		'	"taisyosya_birthday": "29221",' +
		'	"taisyosya_seikyodate": "42826",' +
		'	"customer_comment": "お坊さん便法事法要僧侶手配申込Web受付1abcd123451234543284",' +
		'	"kakunin_renraku_kibo": "no",' +
		'	"obonset": "yes",' +
		'	"productPlaceSelect": "あなたのご住所",' +
		'	"tsuika_nitteis" :' +
		'	[' +
		'	        { ' +
		'	                "plan_name": "四十九日法要", ' +
		'	                "yotei_date": "2018-08-19", ' +
		'	                "jizen_tsuchi_yotei_date" : "2018-08-20" ' +
		'	        } ,' +
		'	        { ' +
		'	                "plan_name": "一周忌法要", ' +
		'	                "yotei_date": "2019-08-01", ' +
		'	                "jizen_tsuchi_yotei_date" : "2019-08-02" ' +
		'	        } ' +
		'	]' +
		'}';
	}
}