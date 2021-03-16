@isTest
public class Tes_PartnerContract {

	static testMethod void test1(){

		Account sogisha = new Account();
		sogisha.Name = 'テスト葬儀社';
		sogisha.RecordTypeId = new RecordTypeDao().selectRecordBySobjectTypeDeveloperName('Account', 'Sogisya').Id;
		insert sogisha;

		Contact sogishaTantosha = new Contact();
		sogishaTantosha.LastName = '葬儀社';
		sogishaTantosha.FirstName = '担当者';
		sogishaTantosha.AccountId = sogisha.Id;
		sogishaTantosha.RecordTypeId = new RecordTypeDao().selectRecordBySobjectTypeDeveloperName('Contact', 'FuneralStaff').Id;
		insert sogishaTantosha;
		
		Shisetsu__c shisetsu = new Shisetsu__c();
		shisetsu.Name = '施設';
		shisetsu.Sogisha__c = sogisha.Id;
		insert shisetsu;

		PartnerMoshikomi_Sogisha__c partnerMoshikomiSogisha = new PartnerMoshikomi_Sogisha__c();
		partnerMoshikomiSogisha.Fax__c = '1';
		partnerMoshikomiSogisha.Website__c = '1';
		partnerMoshikomiSogisha.SekoRyunyuHiritsuInternet__c = '1';
		partnerMoshikomiSogisha.TeikeisakiName__c = '1';
		partnerMoshikomiSogisha.SekoRyunyuHiritsuSonota__c = '1';
		partnerMoshikomiSogisha.SekoHiritsuSonota__c = '1';
		partnerMoshikomiSogisha.MailAddress__c = 'test1@minrevi.jp';
		partnerMoshikomiSogisha.SekoHiritsuIchinichiso__c = '1';
		partnerMoshikomiSogisha.UnsoKyokasyoKubun__c = '1';
		partnerMoshikomiSogisha.SekoHiritsuIppanso__c = '1';
		partnerMoshikomiSogisha.UneiKeitai__c = '1';
		partnerMoshikomiSogisha.UneiKeitaiSonota__c = '1';
		partnerMoshikomiSogisha.NameYagouFurigana__c = '1';
		partnerMoshikomiSogisha.SekoHiritsuKazokuso__c = '1';
		partnerMoshikomiSogisha.BankBranchName__c = '1';
		partnerMoshikomiSogisha.BankName__c = '1';
		partnerMoshikomiSogisha.KeiriTantoshaTel__c = '1';
		partnerMoshikomiSogisha.KeiriTantoshasei__c = '1';
		partnerMoshikomiSogisha.KeiriTantoshaseiKana__c = '1';
		partnerMoshikomiSogisha.KeiriTantoshamei__c = '1';
		partnerMoshikomiSogisha.KeiriTantoshameiKana__c = '1';
		partnerMoshikomiSogisha.BankAccountType__c = '1';
		partnerMoshikomiSogisha.BankAccountNo__c = '1';
		partnerMoshikomiSogisha.BankAccountMeigi__c = '1';
		partnerMoshikomiSogisha.SaidaiEnkiNissuKasoshiki__c = '1';
		partnerMoshikomiSogisha.SaidaiEnkiNissuShikiari__c = '1';
		partnerMoshikomiSogisha.SaidaiBunkatuKaisuKasoshiki__c = '1';
		partnerMoshikomiSogisha.SaidaiBunkatsuKaisuShikiari__c = '1';
		partnerMoshikomiSogisha.SeikyuSakiAddrCity__c = '1';
		partnerMoshikomiSogisha.ShiharaiHoho__c = '1';
		partnerMoshikomiSogisha.ShiharaiHohoSonota__c = '1';
		partnerMoshikomiSogisha.SekoStaffNinzu__c = '1';
		partnerMoshikomiSogisha.SekoKanoKensuTsuki__c = '1';
		partnerMoshikomiSogisha.SekoHekinTanka__c = '1';
		partnerMoshikomiSogisha.JisyaSaijoSyoyuSu__c = '1';
		partnerMoshikomiSogisha.SekoRyunyuHiritsuJishaShukaku__c = '1';
		partnerMoshikomiSogisha.JishaSyukyakujiTaiokanoNaiyo__c = '1';
		partnerMoshikomiSogisha.ShuyoRenrakusaki__c = '1';
		partnerMoshikomiSogisha.BillingCity__c = '1';
		partnerMoshikomiSogisha.BillingStreet__c = '1';
		partnerMoshikomiSogisha.BillingState__c = '東京都';
		partnerMoshikomiSogisha.BillingPostalCode__c = '1';
		partnerMoshikomiSogisha.NameShogo__c = '1';
		partnerMoshikomiSogisha.NameShogoFurigana__c = '1';
		partnerMoshikomiSogisha.ShindaishaShoyusu__c = '1';
		partnerMoshikomiSogisha.MoshikomiService__c = 'シンプルなお葬式(よりそうのお葬式);葬儀レビ';
		partnerMoshikomiSogisha.SeikyusakiFax__c = '1';
		partnerMoshikomiSogisha.SeikyusakiTel__c = '1';
		partnerMoshikomiSogisha.SeikyusakiYago__c = '1';
		partnerMoshikomiSogisha.SeikyusakiYagokana__c = '1';
		partnerMoshikomiSogisha.SeikyusakiShogo__c = '1';
		partnerMoshikomiSogisha.SeikyusakiShogoKana__c = '1';
		partnerMoshikomiSogisha.SeikyusakiTantoshasei__c = '1';
		partnerMoshikomiSogisha.SeikyusakiTantoshaseiKana__c = '1';
		partnerMoshikomiSogisha.SeikyusakiTantoshamei__c = '1';
		partnerMoshikomiSogisha.SeikyusakiTantoshameiKana__c = '1';
		partnerMoshikomiSogisha.SogiBrandTaioKanoNaiyo__c = '1';
		partnerMoshikomiSogisha.SosaiDirectorNinzu__c = '1';
		partnerMoshikomiSogisha.SosaiPlannerNinzu__c = '1';
		partnerMoshikomiSogisha.TaiouKanouArea__c = '1';
		partnerMoshikomiSogisha.Daihyoshasei__c = '1';
		partnerMoshikomiSogisha.DaihyoshaseiKana__c = '1';
		partnerMoshikomiSogisha.Daihyoshamei__c = '1';
		partnerMoshikomiSogisha.DaihyoshameiKana__c = '1';
		partnerMoshikomiSogisha.KeiyakuTantoEmail__c = 'test2@minrevi.jp';
		partnerMoshikomiSogisha.KeiyakuTantoTelNo__c = '1';
		partnerMoshikomiSogisha.KeiyakuTantoshasei__c = '1';
		partnerMoshikomiSogisha.KeiyakuTantoshaseiKana__c = '1';
		partnerMoshikomiSogisha.KeiyakuTantoshamei__c = '1';
		partnerMoshikomiSogisha.KeiyakuTantoshameiKana__c = '1';
		partnerMoshikomiSogisha.KeiyakuTantoYakuShoku__c = '1';
		partnerMoshikomiSogisha.SeikyuSakiAddrStreet__c = '1';
		partnerMoshikomiSogisha.SekoHiritsuChokuso__c = '1';
		partnerMoshikomiSogisha.Phone__c = '1';
		partnerMoshikomiSogisha.SeikyuSakiAddrState__c = '埼玉県';
		partnerMoshikomiSogisha.TokkijikoPartnerKinyu__c = '1';
		partnerMoshikomiSogisha.SekoHiritsuHansoAnken__c = '1';
		partnerMoshikomiSogisha.SekorRyunyuHiritsuByoinKesatsuKaigo__c = '1';
		partnerMoshikomiSogisha.HekinSekoKensuNen__c = '1';
		partnerMoshikomiSogisha.SeikyuSakiAddrPostalCode__c = '1';
		insert partnerMoshikomiSogisha;

		PartnerMoshikomi_Saijo__c partnerMoshikomiSaijo = new PartnerMoshikomi_Saijo__c();
		partnerMoshikomiSaijo.Sogisha__c = partnerMoshikomiSogisha.Id;
		partnerMoshikomiSaijo.FAX__c = '1';
		partnerMoshikomiSaijo.HpUrl__c = '1';
		partnerMoshikomiSaijo.AccessHohoBasu__c = '1';
		partnerMoshikomiSaijo.AccessHohoKuruma__c = '1';
		partnerMoshikomiSaijo.AccessHouhouDensha__c = '1';
		partnerMoshikomiSaijo.OmutsuKokandaiAri__c = '1';
		partnerMoshikomiSaijo.KizzuRoomAri__c = '1';
		partnerMoshikomiSaijo.ShawaRoomAri__c = '1';
		partnerMoshikomiSaijo.Bariafuri__c = '1';
		partnerMoshikomiSaijo.BebiRoomAri__c = '1';
		partnerMoshikomiSaijo.HoleSetsumeibun__c = '1';
		partnerMoshikomiSaijo.AnchiKa__c = '1';
		partnerMoshikomiSaijo.AnchiTaioNinzu__c = '1';
		partnerMoshikomiSaijo.AnchiMenkaiKa__c = '1';
		partnerMoshikomiSaijo.IchinichisoKa__c = '1';
		partnerMoshikomiSaijo.IppansoKa__c = '1';
		partnerMoshikomiSaijo.Organiser__c = '1';
		partnerMoshikomiSaijo.KazokusoKa__c = '1';
		partnerMoshikomiSaijo.KasoshikiKa__c = '1';
		partnerMoshikomiSaijo.CloseDay__c = '1';
		partnerMoshikomiSaijo.KoeiMinei__c = '1';
		partnerMoshikomiSaijo.City__c = '1';
		partnerMoshikomiSaijo.Saijomei__c = '1';
		partnerMoshikomiSaijo.ShisetsumeiFurigana__c = '1';
		partnerMoshikomiSaijo.JunyushitsuAri__c = '1';
		partnerMoshikomiSaijo.ShukuhakuKa__c = '1';
		partnerMoshikomiSaijo.ShukuhakuShisetsuBiko__c = '1';
		partnerMoshikomiSaijo.ShukuhakuShisetsuRyokin__c = '1';
		partnerMoshikomiSaijo.ShinzokuHikaeshitsuAri__c = '1';
		partnerMoshikomiSaijo.ZenShuhaTaioKa__c = '1';
		partnerMoshikomiSaijo.TaioKanoNinzu__c = '1';
		partnerMoshikomiSaijo.ChushajoAri__c = '1';
		partnerMoshikomiSaijo.Chushadaisu__c = '1';
		partnerMoshikomiSaijo.Street__c = '1';
		partnerMoshikomiSaijo.ChokusoKa__c = '1';
		partnerMoshikomiSaijo.Phone1__c = '1';
		partnerMoshikomiSaijo.State__c = '1';
		partnerMoshikomiSaijo.TsukisoiAnchiKa__c = '1';
		partnerMoshikomiSaijo.Horeikosu__c = '1';
		partnerMoshikomiSaijo.HoyoKa__c = '1';
		partnerMoshikomiSaijo.PostalCode__c = '1';
		partnerMoshikomiSaijo.AnchiResidentPrice__c = '1';
		insert partnerMoshikomiSaijo;

		List<Keiyaku__c> keiyakuList = new List<Keiyaku__c>();
		Keiyaku__c simpleKeiyaku = new Keiyaku__c();
		simpleKeiyaku.Name = 'テスト葬儀社_シンプル安豪契約';
		simpleKeiyaku.Teikeisaki__c = sogisha.Id;
		simpleKeiyaku.KeiyakuJokyo__c = '契約中';
		simpleKeiyaku.SeikyushoHassoCycle__c = '都度';
		simpleKeiyaku.NyukinSimekiriJouken__c = '月末締め翌月末';
		simpleKeiyaku.RecordTypeId = new RecordTypeDao().selectRecordBySobjectTypeDeveloperName('Keiyaku__c', 'SimpleYasugo').Id;
		keiyakuList.add(simpleKeiyaku);

		Keiyaku__c sogireviKeiyaku = new Keiyaku__c();
		sogireviKeiyaku.Name = 'テスト葬儀社_葬儀レビ契約';
		sogireviKeiyaku.Teikeisaki__c = sogisha.Id;
		sogireviKeiyaku.KeiyakuJokyo__c = '契約中';
		sogireviKeiyaku.RecordTypeId = new RecordTypeDao().selectRecordBySobjectTypeDeveloperName('Keiyaku__c', 'SougiRevi').Id;
		keiyakuList.add(sogireviKeiyaku);
		insert keiyakuList;

		Test.startTest();

		Ctl_PartnerContract.auraUpdateSogisha(partnerMoshikomiSogisha.Id, sogisha.Id);
		Ctl_PartnerContract.auraUpdateContact(partnerMoshikomiSogisha.Id, sogishaTantosha.Id);
		Ctl_PartnerContract.auraUpdateSaijo(partnerMoshikomiSaijo.Id, shisetsu.Id);

		Test.stopTest();
	}


	static testMethod void test2(){

		Account jiin_syozoku = new Account();
		jiin_syozoku.Name = '所属寺院';
		jiin_syozoku.RecordTypeId = new RecordTypeDao().selectRecordBySobjectTypeDeveloperName('Account', 'Jiin').Id;
		insert jiin_syozoku;
		Account jiin_zaiseki = new Account();
		jiin_zaiseki.Name = '在籍寺院';
		jiin_zaiseki.RecordTypeId = new RecordTypeDao().selectRecordBySobjectTypeDeveloperName('Account', 'Jiin').Id;
		insert jiin_zaiseki;

		Account souryo = new Account();
		souryo.Name = 'テスト僧侶';
		souryo.ShozokuSangouSangoJiin__c = jiin_syozoku.Id;
		souryo.ZaisekiSaki__c = jiin_zaiseki.Id;
		souryo.RecordTypeId = new RecordTypeDao().selectRecordBySobjectTypeDeveloperName('Account', 'SoryoAccount').Id;
		insert souryo;

		List<Keiyaku__c> keiyakuList = new List<Keiyaku__c>();
		for(Integer i=0; i<1; i++){
			Keiyaku__c keiyaku = new Keiyaku__c();
			keiyaku.KeiyakuJokyo__c = '契約中';
			keiyaku.Teikeisaki__c = souryo.Id;
			keiyakuList.add(keiyaku);
		}
		insert keiyakuList;
		

		List<PartnerMoshikomi_Obosanbin__c> partnermoshikomi_obosanbinList = new List<PartnerMoshikomi_Obosanbin__c>();
		for(Integer i=0; i<5; i++){
			PartnerMoshikomi_Obosanbin__c partnermoshikomi_obosanbin = new PartnerMoshikomi_Obosanbin__c();
			partnermoshikomi_obosanbin.LastNameFurigana__c = 'VOmxSl0' + string.valueof(i) ;    //姓（カナ）
			partnermoshikomi_obosanbin.FirstNameFurigana__c = 'f3mopAN' + string.valueof(i) ;    //名（カナ）
			partnermoshikomi_obosanbin.LastName__c = 'uwZRAmV' + string.valueof(i) ;    //姓
			partnermoshikomi_obosanbin.FirstName__c = 'S7iYoyk' + string.valueof(i) ;    //名
			partnermoshikomi_obosanbin.Gender__c = '4rqdXlk' + string.valueof(i) ;    //性別
			partnermoshikomi_obosanbin.JiinSyuha__c = '44X9HVP' + string.valueof(i) ;    //宗派
			partnermoshikomi_obosanbin.JiinShuhaSonotaKana__c = '1woBCKd' + string.valueof(i) ;    //宗派その他(カナ)
			partnermoshikomi_obosanbin.JiinShuhaSonota__c = 'YVZZRN0' + string.valueof(i) ;    //宗派その他
			partnermoshikomi_obosanbin.MoshikomishaKyojuchiPostalcode__c = 'mxsj7j4' + string.valueof(i) ;    //住所(請求先)(郵便番号)
			partnermoshikomi_obosanbin.MoshikomishaKyojuchiState__c = 'KaMR0nm' + string.valueof(i) ;    //住所(請求先)(都道府県)
			partnermoshikomi_obosanbin.MoshikomishaKyojuchiCity__c = 'TSE4KdC' + string.valueof(i) ;    //住所(請求先)(市区郡)
			partnermoshikomi_obosanbin.MoshikomishaKyojuchiStreet__c = 'v3gUCWV' + string.valueof(i) ;    //住所(請求先)(町名・番地)
			partnermoshikomi_obosanbin.Phone__c = 'jwxPfAS' + string.valueof(i) ;    //電話1
			partnermoshikomi_obosanbin.Fax__c = 'bGKyp20' + string.valueof(i) ;    //Fax
			partnermoshikomi_obosanbin.MobilePhone__c = 'j6WVQIk' + string.valueof(i) ;    //携帯1
			partnermoshikomi_obosanbin.HomutaiokanoArea__c = 'qxHH2WI' + string.valueof(i) ;    //法務対応可能エリア
			partnermoshikomi_obosanbin.PersonBirthdate__c = '2001-10-10' ;    //生年月日
			partnermoshikomi_obosanbin.HoninKakuninSyoruiSyubetsu__c = 'VLSfiAn' + string.valueof(i) ;    //本人確認書類種別
			partnermoshikomi_obosanbin.MailAddress__c = 'xhVIxFz' + string.valueof(i) ;    //メールアドレス1
			partnermoshikomi_obosanbin.JiinJiinshuha__c = 'xIrZ0JL' + string.valueof(i) ;    //宗派
			partnermoshikomi_obosanbin.JiinJiinshuhaSonotaKana__c = 'ReP5IxX' + string.valueof(i) ;    //宗派その他(カナ)
			partnermoshikomi_obosanbin.JiinJiinshuhaSonota__c = 'puTmpZY' + string.valueof(i) ;    //宗派その他
			partnermoshikomi_obosanbin.SangoJiinMeiFurigana__c = 'IUBkSkD' + string.valueof(i) ;    //山号寺院名（カナ）
			partnermoshikomi_obosanbin.KatudojiinJiinName__c = 'QF02ZVK' + string.valueof(i) ;    //所属寺院名
			partnermoshikomi_obosanbin.KatudojiinJiinjushoPostalcode__c = 'uE3s9FH' + string.valueof(i) ;    //住所(請求先)(郵便番号)
			partnermoshikomi_obosanbin.KatudojiinJiinjushoState__c = 'wSDKJxb' + string.valueof(i) ;    //住所(請求先)(都道府県)
			partnermoshikomi_obosanbin.KatudojiinJiinjushoCity__c = 'wMAfXet' + string.valueof(i) ;    //住所(請求先)(市区郡)
			partnermoshikomi_obosanbin.KatudojiinJiinjushoStreet__c = 'NeJRK3d' + string.valueof(i) ;    //住所(請求先)(町名・番地)
			partnermoshikomi_obosanbin.JiinTel__c = 'JglV9uF' + string.valueof(i) ;    //電話1
			partnermoshikomi_obosanbin.JiinFax__c = 'u0zkyXr' + string.valueof(i) ;    //Fax
			partnermoshikomi_obosanbin.JiinsekininshaseiKana__c = '0EkOaxz' + string.valueof(i) ;    //姓（カナ）
			partnermoshikomi_obosanbin.JiinsekininshameiKana__c = 'Wqufy1O' + string.valueof(i) ;    //名（カナ）
			partnermoshikomi_obosanbin.Jiinsekininshasei__c = 'Ud4ntBD' + string.valueof(i) ;    //姓
			partnermoshikomi_obosanbin.Jiinsekininshamei__c = 'KZ4kWOU' + string.valueof(i) ;    //名
			partnermoshikomi_obosanbin.JiinHpurl__c = 'y4TfPyl' + string.valueof(i) ;    //Web サイト
			partnermoshikomi_obosanbin.JiinTanisyubetsu__c = 'PHHBDwj' + string.valueof(i) ;    //宗教法人単位種別
			partnermoshikomi_obosanbin.JiinHojintoki__c = 'Ctte87I' + string.valueof(i) ;    //宗教法人格有
			partnermoshikomi_obosanbin.JiinjohoBetsuinjushoPostalcode__c = 'veAkNE9' + string.valueof(i) ;    //住所(請求先)(郵便番号)
			partnermoshikomi_obosanbin.JiinjohoBetsuinjushoState__c = '79EB36K' + string.valueof(i) ;    //住所(請求先)(都道府県)
			partnermoshikomi_obosanbin.JiinjohoBetsuinjushoCity__c = 'ax5Cmud' + string.valueof(i) ;    //住所(請求先)(市区郡)
			partnermoshikomi_obosanbin.JiinjohoBetsuinjushoStreet__c = 'wHY2mp3' + string.valueof(i) ;    //住所(請求先)(町名・番地)
			partnermoshikomi_obosanbin.JiinjohoBetsuindenokatsudo__c = '1' ;    //別院での活動を希望
			partnermoshikomi_obosanbin.JiinjohoBetsuintel__c = 'RLPRvma' + string.valueof(i) ;    //電話1
			partnermoshikomi_obosanbin.JiinjohoBetsuinfax__c = 'wGeZXKe' + string.valueof(i) ;    //Fax
			partnermoshikomi_obosanbin.JiinjohoZaisekijiinmeiKana__c = 'S1su7BY' + string.valueof(i) ;    //山号寺院名（カナ）
			partnermoshikomi_obosanbin.JiinjohoZaisekijiinmei__c = 'JOAwrwm' + string.valueof(i) ;    //在籍寺院名
			partnermoshikomi_obosanbin.JiinjohoZaisekijiinjushoPostalcode__c = 'upu8A7x' + string.valueof(i) ;    //住所(請求先)(郵便番号)
			partnermoshikomi_obosanbin.JiinjohoZaisekijiinjushoState__c = 'V1WvLcK' + string.valueof(i) ;    //住所(請求先)(都道府県)
			partnermoshikomi_obosanbin.JiinjohoZaisekijiinjushoCity__c = '0tbFmTp' + string.valueof(i) ;    //住所(請求先)(市区郡)
			partnermoshikomi_obosanbin.JiinjohoZaisekijiinjushoStreet__c = 'AknmlnU' + string.valueof(i) ;    //住所(請求先)(町名・番地)
			partnermoshikomi_obosanbin.JiinjohoZaisekijiintel__c = 'Enf4iax' + string.valueof(i) ;    //電話1
			partnermoshikomi_obosanbin.JiinjohoZaisekijiinfax__c = 'KCYvsVO' + string.valueof(i) ;    //Fax
			partnermoshikomi_obosanbin.BankName__c = 'ZehsUyi' + string.valueof(i) ;    //銀行名
			partnermoshikomi_obosanbin.BankBranchName__c = 'DIPf6hr' + string.valueof(i) ;    //銀行支店名
			partnermoshikomi_obosanbin.BankAccountType__c = 'YNDIWp5' + string.valueof(i) ;    //口座種別
			partnermoshikomi_obosanbin.BankAccountNo__c = 'F0ubVU2' + string.valueof(i) ;    //口座番号
			partnermoshikomi_obosanbin.BankAccountMeigi__c = 'dHj8cYU' + string.valueof(i) ;    //口座名義
			partnermoshikomi_obosanbin.Kaimyojuyonomiirai__c = 'hGUSJPI' + string.valueof(i) ;    //戒名授与のみ依頼
			partnermoshikomi_obosanbin.KaimyojuyoIraiYosodan__c = 'L4XgVrr' + string.valueof(i) ;    //戒名授与のみ依頼要相談
			partnermoshikomi_obosanbin.IdoSyudan__c = 'ZrF1gJL' + string.valueof(i) ;    //移動手段
			partnermoshikomi_obosanbin.JizenanketoIdoshudanSonota__c = 'SE2Trzn' + string.valueof(i) ;    //移動手段その他
			partnermoshikomi_obosanbin.Iraisyosofuhouhou__c = 'oXnYsc6' + string.valueof(i) ;    //依頼書送付方法
			partnermoshikomi_obosanbin.ToubaTaioKahiKubun__c = 'FEz4u3I' + string.valueof(i) ;    //塔婆対応可否区分
			partnermoshikomi_obosanbin.TobaTaioYosodan__c = 'rOEeuu7' + string.valueof(i) ;    //塔婆対応要相談
			partnermoshikomi_obosanbin.TobaTaioKingakuFrom__c = '1000' ;    //塔婆対応金額
			partnermoshikomi_obosanbin.TobaTaioKingakuTo__c = '1000' ;    //塔婆対応金額
			partnermoshikomi_obosanbin.KakoTyoKinyuTaiouKahiKubun__c = 'Fvzp458' + string.valueof(i) ;    //過去帳記入対応可否区分
			partnermoshikomi_obosanbin.KakochoKinyuYosodan__c = '3yK1q2S' + string.valueof(i) ;    //過去帳記入要相談
			partnermoshikomi_obosanbin.KakochoKinyuKingakuFrom__c = '200000' ;    //過去帳記入金額
			partnermoshikomi_obosanbin.KakochoKinyuKingakuTo__c = '200000' ;    //過去帳記入金額
			partnermoshikomi_obosanbin.SyuzaiTaiouKahiKubun__c = 'dddqExs' + string.valueof(i) ;    //取材対応区分
			partnermoshikomi_obosanbin.JiinDenoHoyoKa__c = 'kOfoJuO' + string.valueof(i) ;    //寺院での法要可
			partnermoshikomi_obosanbin.SyuyoNinzu__c = '11';    //収容人数
			partnermoshikomi_obosanbin.CyusyaJoUmu__c = '有' ;    //駐車場有無
			partnermoshikomi_obosanbin.CyusyaKanouDaisu__c = '199' ;    //駐車可能台数
			partnermoshikomi_obosanbin.Somei__c = '5N1e7iX' + string.valueof(i) ;    //僧名
			partnermoshikomi_obosanbin.JizenanketoSomeidenotorokuwokibo__c = '1' ;    //僧名での登録を希望
			partnermoshikomi_obosanbin.JizenanketoTashaservicetoroku__c = '2L168fy' + string.valueof(i) ;    //他社サービス登録
			partnermoshikomi_obosanbin.JizenanketoTashaservicetorokumei__c = 'av88GHc' + string.valueof(i) ;    //他社サービス登録名
			partnermoshikomi_obosanbin.JiindenohoyoYosodan__c = '2PvScxP' + string.valueof(i) ;    //寺院での法要要相談
			partnermoshikomi_obosanbin.SomeiKana__c = 'VW1cQVF' + string.valueof(i) ;    //僧名(カナ)
			partnermoshikomi_obosanbin.moshikomisha_sosekishuhakeito__c = '1DV03h2' + string.valueof(i) ;    //僧籍宗派系統
			partnermoshikomi_obosanbinList.add(partnermoshikomi_obosanbin);
		}
		insert partnermoshikomi_obosanbinList;

		Ctl_PartnerContract.auraUpdateSouryou(partnermoshikomi_obosanbinList[0].Id, souryo.Id);

	}
}