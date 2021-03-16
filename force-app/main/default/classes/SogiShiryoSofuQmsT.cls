@isTest
private class SogiShiryoSofuQmsT {

    @testSetup
    static void setUp(){
        TriggerIsActive__c trgActive = new TriggerIsActive__c( name='default', isActive__c=false );
        Insert trgActive;
        Insert new JizenWariPlan__c( Code__c='Yoriso' );
        Insert new List<LoggingsConfig__c>{
            new LoggingsConfig__c(
                name='dev', LevelsToWrite__c='Error, Warn, Info', WriteLogAttributeRecords__c=true,
                DmlStatementsLeftToStopLogging__c = 10, DmlStatementsLeftToWarn__c = 20,
                DmlRowsLeftToStopLogging__c = 100, DmlRowsLeftToWarn__c = 200
                ),
            new LoggingsConfig__c(
                name='prod', LevelsToWrite__c='Error, Warn, Info', WriteLogAttributeRecords__c=true,
                DmlStatementsLeftToStopLogging__c = 10, DmlStatementsLeftToWarn__c = 20,
                DmlRowsLeftToStopLogging__c = 100, DmlRowsLeftToWarn__c = 200
                )
        };
        Insert new Account(
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId(),
            FirstName = '_', LastName = '_'
        );

        // 都道府県
		TodoufuKen__c todoufuKen = new TodoufuKen__c();
	    todoufuKen.name = '東京都';   // 都道府県
	    todoufuKen.kencode__c = '13';   // 県コード
	    todoufuKen.pkey__c = '東京都';   // PKey
	    insert todoufuKen;

		// 市区郡
	    Shikugun__c shikugun = new Shikugun__c();
	    shikugun.name = '東京都品川区';   // 市区郡名称
	    shikugun.areacode__c = '13109';   // エリアコード
	    shikugun.chiriichijouhou__latitude__s = 35.6092261;   // 地理位置情報 (Latitude)
	    shikugun.chiriichijouhou__longitude__s = 139.7301861;   // 地理位置情報 (Longitude)
	    shikugun.shikugunmeifurigana__c = 'しながわく';   // 市区郡名(かな)
	    shikugun.todoufukenref__c = todoufuKen.Id;   // 都道府県
	    shikugun.shikugunmei__c = '品川区';   // 市区郡名
	    insert shikugun;

		// 市区郡
	    Shikugun__c shibuya = new Shikugun__c();
	    shibuya.name = '東京都渋谷区';   // 市区郡名称
	    shibuya.areacode__c = '13113';   // エリアコード
	    shibuya.chiriichijouhou__latitude__s = 35.6617773;   // 地理位置情報 (Latitude)
	    shibuya.chiriichijouhou__longitude__s = 139.7040506;   // 地理位置情報 (Longitude)
	    shibuya.shikugunmeifurigana__c = 'しぶやく';   // 市区郡名(かな)
	    shibuya.todoufukenref__c = todoufuKen.Id;   // 都道府県
	    shibuya.shikugunmei__c = '渋谷区';   // 市区郡名
	    insert shibuya;

        //取引先の「葬儀社」データ作成
        Account acc2 = new Account(
            Name ='テスト葬儀社',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Sogisya').getRecordTypeId(),
            Fax = '03-3493-87701',
            Description = 'この葬儀社は、システム内で本番環境で動作確認する際に利用するテストデータの葬儀社です。',
			BillingPostalCode = '141-0031',
			BillingState = '東京都',
			BillingCity = '品川区',
			BillingStreet = '西五反田',
			BillingLatitude = 35.6092261,
	    	BillingLongitude = 139.7301861,
            PersonHasOptedOutOfEmail = FALSE,
            PersonHasOptedOutOfFax = FALSE,
            PersonDoNotCall = FALSE,
            BankAccountType__c = '普通預金',
            // AfterSalesTaisyoFlag__c = FALSE,
            MailAddress2__c = 'a1b2@aa.com',
            MailAddress__c = 'dev-test+2018@yoriso.com',
            MemberTourokuZumi__c = FALSE,
            // NewsLetterHaishinFlag__c = 0,
            // ObonDmSoushinFlag__c = 0,
            // OhakaAri__c = FALSE,
            KoukokuDmNg__c = FALSE,
            KoukokuFaxNg__c = FALSE,
            JizenwariMemberKa__c = FALSE,
            // IsDeleted__c = FALSE,
            IsPersonAccount__c = FALSE,
            BetsuinKatsudoKibo__c = FALSE,
            SomeiTorokuKibo__c = FALSE,
            NayoseMailAddress__c = 'a1b2@aa.com',
            NayoseMailAddress2__c = 'dev-test+2018@yoriso.com',
            JushoFubi__c = FALSE,
            PtWebAcceptedDate__c = Date.today(),
            //PtWebAccountRef__c = lsrPtWeb.getId(),
            IsOboStLineAcnt__c = FALSE,
            //YosinKanriRef__c = lsrYosinKanri.getId(),
            KaihoshiNG__c = FALSE,
            KoukokuMailNg__c = FALSE,
            KoukokuSmsNg__c = FALSE,
            NameYagouFurigana__c = 'システムドウサカクニンヨウ',
            NameShogoFurigana__c = 'システムドウサカクニンヨウ',
            NameShogo__c = 'システム動作確認用',
            SeikyuSakiAtena__c = 'システム動作確認用'
        );
        Database.SaveResult lsracc2 = Database.insert(acc2);
    
        //特約店手数料のデータ作成
        TokuyakutenTesuryo__c TokuyakutenTesuryo = new TokuyakutenTesuryo__c(
            Chokuso__c = 1000,
            Kasoshiki__c = 2000,
            Ichinichiso__c = 3000,
            Kazokuso__c = 4000,
            Ippanso__c = 5000
        );
        Database.SaveResult lsrTokuyakutenTesuryo = Database.insert(TokuyakutenTesuryo);

        //パートナー契約の「シンプル安豪契約」データ作成
        Keiyaku__c Keiyaku = new Keiyaku__c(
            Name = 'シンプル安豪契約',
            RecordTypeId = Schema.getGlobalDescribe().get('Keiyaku__c').getDescribe().getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId(),
            Teikeisaki__c = lsracc2.getId(),
            AmazonTaioka__c = FALSE,
            AreaTokureiAri__c = FALSE,
            KaiteKiyakuTekiyoZumi__c = FALSE,
            KeiyakuJokyo__c = '未契約',
            KeiyakuMousikomiBi__c = date.valueOf('2015-01-01'),
            KeiyakuSyoSyosiki__c = '2018年1月24改定以前規約',
            Keiyakukaishibi__c = date.valueOf('2015-01-01'),
            KyuTesuryoTaioFlag__c = FALSE,
            NyukinSimekiriJouken__c = '月末締め翌月末',
            SekoHosyoKeiyakuSu__c = 0,
            SekoHosyoYukoKeiyakuSu__c = 0,
            ShikiariNeageKosyoStatus__c = '未着手',
            ShoriStatus__c = '未連携',
            SimpleKeiyakuSu__c = 0,
            SimpleYukoKeiyakuSu__c = 0,
            TesuryoAtobaraiAri__c = FALSE,
            TesuryoCardLoanAri__c = FALSE,
            TesuryoHenreiHinAri__c = FALSE,
            TesuryoOptionAri__c = FALSE,
            TesuryoRyoriAri__c = FALSE,
            TokuyakutenKeiyakuSu__c = 0,
            TokuyakutenYukoKeiyakuSu__c = 0,
            TryCount__c = 0,
            TryLimit__c = 3,
            UnsoKyokasyoHikaeAri__c = FALSE,
            YasugoKeiyakuSu__c = 0,
            YasugoYukoKeiyakuSu__c = 0,
            Jizenkakuninhouhou__c = 'SMS',
            IsSoukyakujiFax__c = TRUE,
            SeikyushoHassoCycle__c = '月末',
            SeikyushoSakuseijiFax__c = FALSE
        );
        Database.SaveResult lsrKeiyaku = Database.insert(Keiyaku);

		TesuryoPlan__c theTesuryoPlan = new TesuryoPlan__c();
		theTesuryoPlan.CoreTesuryoPlanId__c = 11;
		INSERT theTesuryoPlan;

		TesuryoTekiyo__c theTesuryoTekiyo = new TesuryoTekiyo__c();
		theTesuryoTekiyo.KeiyakuRef__c = lsrKeiyaku.Id;
		theTesuryoTekiyo.TekiyoKaishiBi__c = Date.newInstance(2000,1,1);
		theTesuryoTekiyo.TesuryoPlanRef__c = theTesuryoPlan.Id; 
		theTesuryoTekiyo.ShoninStatus__c = '承認済';
		insert theTesuryoTekiyo;

        Keiyaku.KeiyakuJokyo__c = '契約中';
        update Keiyaku;

        //パートナー契約の「特約店契約」データ作成
        Keiyaku__c Keiyaku2 = new Keiyaku__c(
            Name = '特約店契約',
            RecordTypeId = Schema.getGlobalDescribe().get('Keiyaku__c').getDescribe().getRecordTypeInfosByDeveloperName().get('TokuyakuTen').getRecordTypeId(),
            Teikeisaki__c = lsracc2.getId(),
            AmazonTaioka__c = FALSE,
            AreaTokureiAri__c = FALSE,
            KaiteKiyakuTekiyoZumi__c = FALSE,
            KeiyakuJokyo__c = '契約中',
            KeiyakuMousikomiBi__c = date.valueOf('2015-01-01'),
            Keiyakukaishibi__c = date.valueOf('2015-01-01'),
            KyuTesuryoTaioFlag__c = FALSE,
            SekoHosyoKeiyakuSu__c = 0,
            SekoHosyoYukoKeiyakuSu__c = 0,
            ShikiariNeageKosyoStatus__c = '未着手',
            ShoriStatus__c = '未連携',
            SimpleKeiyakuSu__c = 0,
            SimpleYukoKeiyakuSu__c = 0,
            SyuKeiyakuRef__c = lsrKeiyaku.getId(),
            TesuryoAtobaraiAri__c = FALSE,
            TesuryoCardLoanAri__c = FALSE,
            TesuryoHenreiHinAri__c = FALSE,
            TesuryoOptionAri__c = FALSE,
            TesuryoRyoriAri__c = FALSE,
            TogetsuSokyakusu__c = 0,
            TokuyakutenKeiyakuSu__c = 0,
            TokuyakutenYukoKeiyakuSu__c = 0,
            TryCount__c = 0,
            TryLimit__c = 3,
            YasugoKeiyakuSu__c = 0,
            YasugoYukoKeiyakuSu__c = 0,
            Jizenkakuninhouhou__c = 'SMS',
            IsSoukyakujiFax__c = FALSE,
            SeikyushoSakuseijiFax__c = FALSE,
            TokuyakutenTesuryoRef__c = lsrTokuyakutenTesuryo.getId()
        );
        Database.SaveResult lsrKeiyaku2 = Database.insert(Keiyaku2);

        List<Shisetsu__c> shisetsuList = new List<Shisetsu__c>();
		Shisetsu__c shisetsu1 = new Shisetsu__c();
        shisetsu1.ShisetsuShubetsu__c='火葬場';        
        shisetsu1.Name='テスト火葬場';
        shisetsu1.State__c='東京都';
        shisetsu1.City__c='品川区';
        shisetsu1.Street__c='西五反田';
        shisetsu1.PostalCode__c='335-0016';
        shisetsu1.Shikugun__c=shikugun.id;
        shisetsu1.KoeiMinei__c='公営';
		shisetsu1.IdoKedo__latitude__s = 35.6092261;   // 地理位置情報 (Latitude)
	    shisetsu1.IdoKedo__longitude__s = 139.7301861;   // 地理位置情報 (Longitude)
        shisetsuList.add(shisetsu1);

		Shisetsu__c shisetsu2 = new Shisetsu__c();
        shisetsu2.ShisetsuShubetsu__c='火葬場';        
        shisetsu2.Name='テスト火葬場';
        shisetsu2.State__c='東京都';
        shisetsu2.City__c='品川区';
        shisetsu2.Street__c='西五反田';
        shisetsu2.PostalCode__c='335-0016';
        shisetsu2.Shikugun__c=shikugun.id;
        shisetsu2.KoeiMinei__c='民営';
		shisetsu2.IdoKedo__latitude__s = 35.6092261;   // 地理位置情報 (Latitude)
	    shisetsu2.IdoKedo__longitude__s = 139.7301861;   // 地理位置情報 (Longitude)
        shisetsuList.add(shisetsu2);
		insert shisetsuList;

		List<Saijo__c> sList = new List<Saijo__c>();
        Saijo__c s = new Saijo__c();
    	s.SaijoKeisaiJohoIdOld__c = '1111111111';
        s.SimpleHPKeisaiAri__c = true;
		s.Name = 'テスト自社斎場(市内)';
		s.KeisaiSaijoMeiKana__c = 'テスト';
		s.TokuchoSaijo__c = '特徴';
        s.ShikugunRef__c=shikugun.id;
		s.PostalCode__c = '141-0031';
		s.Street__c = '西五反田2-11-17　HI五反田ビル 4F';
        s.JushoKana__c = 'にしごたんだ';
        s.IdoKedo__Latitude__s = 35.6092261;
        s.IdoKedo__longitude__s = 139.7301861;
        s.AccessHohoKuruma__c = 'アクセス車';
        s.AccessHohoBasu__c = 'アクセスバス';
        s.AccessHouhouDensha__c = 'アクセス電車';
        s.AccessHohoBiko__c = 'アクセス備考';
		s.ShisetsuKubun__c = '自社';
		s.KasobaHeisetsuList__c = '有';
		s.UneimotoYago__c = 'よりそう';
		s.TaioShuha__c = '全宗派可';
		s.ShiminRyokinKubun__c = '設定なし(一律同額)';
		s.Kyukanbi__c = '土日';
		s.AnchiShisetsu__c = '有';
		s.KaminShisetsuUmuKokubetsushikiZenjitsu__c = '有';
		s.KaminKanoNinzu__c = 1;
		s.KurumaisuTaio__c = '有';
		s.ShinzokuHikaeshitsu__c = '有';
        s.Chushadaisu__c = 1;
		s.ElevatorUmu__c = '有';
        s.KidsRoomList__c = '有';
        s.JunyushitsuList__c = '有';
        s.KurumaisuKashidashiList__c = '有';
        s.OmutsuKokandaiList__c = '有';
		s.HoyuShutaiSogishaJiinRef__c = lsracc2.Id;
		s.SogishaKensakuHihyoji__c = false;
		s.MoyoriTohoFun__c = 10;
		s.Shunkonen__c = '2000';
		s.AnchiKikanMenkaiKahi__c = '可';
		s.MenkaiTaiojiTsuikaRyokinUmu__c = '有';
		s.KaminShisetsuUmuKokubetsushikiZenjitsu__c = '有';
		s.NyuyokuShisetsu__c = 'シャワー＆お風呂';
		s.FutonKashidashiKahi__c = '可';
		s.ShokujinoKahi__c = '可';
		s.ShokujiNoMochikomiKahi__c = '可';
		s.KurumaisuTaio__c = '可';
		s.KurumaisuKashidashiList__c = '有';
		s.ShokaiKa__c = true;
        sList.add(s);

		Saijo__c s1 = new Saijo__c();
	    s1.SaijoKeisaiJohoIdOld__c = '1111111112';
        s1.SimpleHPKeisaiAri__c = true;
		s1.Name = 'テスト自社斎場(市外)';
		s1.KeisaiSaijoMeiKana__c = 'テスト';
		s1.TokuchoSaijo__c = '特徴';
        s1.ShikugunRef__c=shibuya.id;
		s1.PostalCode__c = '150-0022';
		s1.Street__c = '恵比寿南';
        s1.JushoKana__c = 'えびすみなみ';
        s1.IdoKedo__Latitude__s = 35.6617773;
        s1.IdoKedo__longitude__s = 139.7040506;
        s1.AccessHohoKuruma__c = 'アクセス車';
        s1.AccessHohoBasu__c = 'アクセスバス';
        s1.AccessHouhouDensha__c = 'アクセス電車';
        s1.AccessHohoBiko__c = 'アクセス備考';
		s1.ShisetsuKubun__c = '自社';
		s1.KasobaHeisetsuList__c = '有';
		s1.UneimotoYago__c = 'よりそう';
		s1.TaioShuha__c = '全宗派可';
		s1.ShiminRyokinKubun__c = '設定なし(一律同額)';
		s1.Kyukanbi__c = '土日';
		s1.AnchiShisetsu__c = '有';
		s1.KaminShisetsuUmuKokubetsushikiZenjitsu__c = '有';
		s1.KaminKanoNinzu__c = 1;
		s1.KurumaisuTaio__c = '有';
		s1.ShinzokuHikaeshitsu__c = '有';
        s1.Chushadaisu__c = 1;
		s1.ElevatorUmu__c = '有';
        s1.KidsRoomList__c = '有';
        s1.JunyushitsuList__c = '有';
        s1.KurumaisuKashidashiList__c = '有';
        s1.OmutsuKokandaiList__c = '有';
		s1.HoyuShutaiSogishaJiinRef__c = lsracc2.Id;
		s1.SogishaKensakuHihyoji__c = false;
		s1.MoyoriTohoFun__c = 10;
		s1.Shunkonen__c = '2000';
		s1.AnchiKikanMenkaiKahi__c = '可';
		s1.MenkaiTaiojiTsuikaRyokinUmu__c = '有';
		s1.KaminShisetsuUmuKokubetsushikiZenjitsu__c = '有';
		s1.NyuyokuShisetsu__c = 'シャワー＆お風呂';
		s1.FutonKashidashiKahi__c = '可';
		s1.ShokujinoKahi__c = '可';
		s1.ShokujiNoMochikomiKahi__c = '可';
		s1.KurumaisuTaio__c = '可';
		s1.KurumaisuKashidashiList__c = '有';
		s1.ShokaiKa__c = true;
	    sList.add(s1);

		Saijo__c s2 = new Saijo__c();
	    s2.SaijoKeisaiJohoIdOld__c = '1111111113';
        s2.SimpleHPKeisaiAri__c = true;
		s2.Name = 'テスト公営斎場(併設)';
		s2.KeisaiSaijoMeiKana__c = 'テスト';
		s2.TokuchoSaijo__c = '特徴';
        s2.ShikugunRef__c=shikugun.id;
		s2.PostalCode__c = '141-0031';
		s2.Street__c = '西五反田2-11-17　HI五反田ビル 4F';
        s2.JushoKana__c = 'にしごたんだ';
        s2.IdoKedo__Latitude__s = 35.6092261;
        s2.IdoKedo__longitude__s = 139.7301861;
        s2.AccessHohoKuruma__c = 'アクセス車';
        s2.AccessHohoBasu__c = 'アクセスバス';
        s2.AccessHouhouDensha__c = 'アクセス電車';
        s2.AccessHohoBiko__c = 'アクセス備考';
		s2.ShisetsuKubun__c = '公営';
		s2.KasobaHeisetsuList__c = '有';
		s2.UneimotoYago__c = 'よりそう';
		s2.TaioShuha__c = '全宗派可';
		s2.ShiminRyokinKubun__c = '設定なし(一律同額)';
		s2.Kyukanbi__c = '土日';
		s2.AnchiShisetsu__c = '有';
		s2.KaminShisetsuUmuKokubetsushikiZenjitsu__c = '有';
		s2.KaminKanoNinzu__c = 1;
		s2.KurumaisuTaio__c = '有';
		s2.ShinzokuHikaeshitsu__c = '有';
        s2.Chushadaisu__c = 1;
		s2.ElevatorUmu__c = '有';
        s2.KidsRoomList__c = '有';
        s2.JunyushitsuList__c = '有';
        s2.KurumaisuKashidashiList__c = '有';
        s2.OmutsuKokandaiList__c = '有';
		s2.SogishaKensakuHihyoji__c = false;
		s2.ShokaiKa__c = true;
	    sList.add(s2);

		Saijo__c s3 = new Saijo__c();
	    s3.SaijoKeisaiJohoIdOld__c = '1111111114';
        s3.SimpleHPKeisaiAri__c = true;
		s3.Name = 'テスト公営斎場(非併設)';
		s3.KeisaiSaijoMeiKana__c = 'テスト';
		s3.TokuchoSaijo__c = '特徴';
        s3.ShikugunRef__c=shikugun.id;
		s3.PostalCode__c = '141-0031';
		s3.Street__c = '西五反田2-11-17　HI五反田ビル 4F';
        s3.JushoKana__c = 'にしごたんだ';
        s3.IdoKedo__Latitude__s = 35.6092261;
        s3.IdoKedo__longitude__s = 139.7301861;
        s3.AccessHohoKuruma__c = 'アクセス車';
        s3.AccessHohoBasu__c = 'アクセスバス';
        s3.AccessHouhouDensha__c = 'アクセス電車';
        s3.AccessHohoBiko__c = 'アクセス備考';
		s3.ShisetsuKubun__c = '公営';
		s3.KasobaHeisetsuList__c = '無';
		s3.UneimotoYago__c = 'よりそう';
		s3.TaioShuha__c = '全宗派可';
		s3.ShiminRyokinKubun__c = '設定なし(一律同額)';
		s3.Kyukanbi__c = '土日';
		s3.AnchiShisetsu__c = '有';
		s3.KaminShisetsuUmuKokubetsushikiZenjitsu__c = '有';
		s3.KaminKanoNinzu__c = 1;
		s3.KurumaisuTaio__c = '有';
		s3.ShinzokuHikaeshitsu__c = '有';
        s3.Chushadaisu__c = 1;
		s3.ElevatorUmu__c = '有';
        s3.KidsRoomList__c = '有';
        s3.JunyushitsuList__c = '有';
        s3.KurumaisuKashidashiList__c = '有';
        s3.OmutsuKokandaiList__c = '有';
		s3.SogishaKensakuHihyoji__c = false;
		s3.ShokaiKa__c = true;
	    sList.add(s3);

		Saijo__c s4 = new Saijo__c();
	    s4.SaijoKeisaiJohoIdOld__c = '1111111115';
        s4.SimpleHPKeisaiAri__c = true;
		s4.Name = 'テスト民営斎場';
		s4.KeisaiSaijoMeiKana__c = 'テスト';
		s4.TokuchoSaijo__c = '特徴';
        s4.ShikugunRef__c=shikugun.id;
		s4.PostalCode__c = '141-0031';
		s4.Street__c = '西五反田2-11-17　HI五反田ビル 4F';
        s4.JushoKana__c = 'にしごたんだ';
        s4.IdoKedo__Latitude__s = 35.6092261;
        s4.IdoKedo__longitude__s = 139.7301861;
        s4.AccessHohoKuruma__c = 'アクセス車';
        s4.AccessHohoBasu__c = 'アクセスバス';
        s4.AccessHouhouDensha__c = 'アクセス電車';
        s4.AccessHohoBiko__c = 'アクセス備考';
		s4.ShisetsuKubun__c = '民営';
		s4.KasobaHeisetsuList__c = '無';
		s4.UneimotoYago__c = 'よりそう';
		s4.TaioShuha__c = '全宗派可';
		s4.ShiminRyokinKubun__c = '設定なし(一律同額)';
		s4.Kyukanbi__c = '土日';
		s4.AnchiShisetsu__c = '有';
		s4.KaminShisetsuUmuKokubetsushikiZenjitsu__c = '有';
		s4.KaminKanoNinzu__c = 1;
		s4.KurumaisuTaio__c = '有';
		s4.ShinzokuHikaeshitsu__c = '有';
        s4.Chushadaisu__c = 1;
		s4.ElevatorUmu__c = '有';
        s4.KidsRoomList__c = '有';
        s4.JunyushitsuList__c = '有';
        s4.KurumaisuKashidashiList__c = '有';
        s4.OmutsuKokandaiList__c = '有';
		s4.SogishaKensakuHihyoji__c = false;
		s4.ShokaiKa__c = true;
	    sList.add(s4);

		Saijo__c s5 = new Saijo__c();
	    s5.SaijoKeisaiJohoIdOld__c = '1111111116';
        s5.SimpleHPKeisaiAri__c = true;
		s5.Name = 'テスト寺院斎場';
		s5.KeisaiSaijoMeiKana__c = 'テスト';
		s5.TokuchoSaijo__c = '特徴';
        s5.ShikugunRef__c=shikugun.id;
		s5.PostalCode__c = '141-0031';
		s5.Street__c = '西五反田2-11-17　HI五反田ビル 4F';
        s5.JushoKana__c = 'にしごたんだ';
        s5.IdoKedo__Latitude__s = 35.6092261;
        s5.IdoKedo__longitude__s = 139.7301861;
        s5.AccessHohoKuruma__c = 'アクセス車';
        s5.AccessHohoBasu__c = 'アクセスバス';
        s5.AccessHouhouDensha__c = 'アクセス電車';
        s5.AccessHohoBiko__c = 'アクセス備考';
		s5.ShisetsuKubun__c = '寺院';
		s5.KasobaHeisetsuList__c = '無';
		s5.UneimotoYago__c = 'よりそう';
		s5.TaioShuha__c = '全宗派可';
		s5.ShiminRyokinKubun__c = '設定なし(一律同額)';
		s5.Kyukanbi__c = '土日';
		s5.AnchiShisetsu__c = '有';
		s5.KaminShisetsuUmuKokubetsushikiZenjitsu__c = '有';
		s5.KaminKanoNinzu__c = 1;
		s5.KurumaisuTaio__c = '有';
		s5.ShinzokuHikaeshitsu__c = '有';
        s5.Chushadaisu__c = 1;
		s5.ElevatorUmu__c = '有';
        s5.KidsRoomList__c = '有';
        s5.JunyushitsuList__c = '有';
        s5.KurumaisuKashidashiList__c = '有';
        s5.OmutsuKokandaiList__c = '有';
		s5.SogishaKensakuHihyoji__c = false;
		s5.ShokaiKa__c = true;
	    sList.add(s5);

		Saijo__c s6 = new Saijo__c();
	    s6.SaijoKeisaiJohoIdOld__c = '1111111117';
        s6.SimpleHPKeisaiAri__c = true;
		s6.Name = 'テスト公営斎場';
		s6.KeisaiSaijoMeiKana__c = 'テスト';
		s6.TokuchoSaijo__c = '特徴';
        s6.ShikugunRef__c=shibuya.id;
		s6.PostalCode__c = '150-0022';
		s6.Street__c = '恵比寿南';
        s6.JushoKana__c = 'えびすみなみ';
        s6.IdoKedo__Latitude__s = 35.6617773;
        s6.IdoKedo__longitude__s = 139.7040506;
        s6.AccessHohoKuruma__c = 'アクセス車';
        s6.AccessHohoBasu__c = 'アクセスバス';
        s6.AccessHouhouDensha__c = 'アクセス電車';
        s6.AccessHohoBiko__c = 'アクセス備考';
		s6.ShisetsuKubun__c = '公営';
		s6.KasobaHeisetsuList__c = '無';
		s6.UneimotoYago__c = 'よりそう';
		s6.TaioShuha__c = '全宗派可';
		s6.ShiminRyokinKubun__c = '設定なし(一律同額)';
		s6.Kyukanbi__c = '土日';
		s6.AnchiShisetsu__c = '有';
		s6.KaminShisetsuUmuKokubetsushikiZenjitsu__c = '有';
		s6.KaminKanoNinzu__c = 1;
		s6.KurumaisuTaio__c = '有';
		s6.ShinzokuHikaeshitsu__c = '有';
        s6.Chushadaisu__c = 1;
		s6.ElevatorUmu__c = '有';
        s6.KidsRoomList__c = '有';
        s6.JunyushitsuList__c = '有';
        s6.KurumaisuKashidashiList__c = '有';
        s6.OmutsuKokandaiList__c = '有';
		s6.SogishaKensakuHihyoji__c = false;
		s6.ShokaiKa__c = true;
	    sList.add(s6);

		Saijo__c s7 = new Saijo__c();
	    s7.SaijoKeisaiJohoIdOld__c = '1111111118';
        s7.SimpleHPKeisaiAri__c = true;
		s7.Name = 'テスト民営斎場';
		s7.KeisaiSaijoMeiKana__c = 'テスト';
		s7.TokuchoSaijo__c = '特徴';
        s7.ShikugunRef__c=shibuya.id;
		s7.PostalCode__c = '150-0022';
		s7.Street__c = '恵比寿南';
        s7.JushoKana__c = 'えびすみなみ';
        s7.IdoKedo__Latitude__s = 35.6617773;
        s7.IdoKedo__longitude__s = 139.7040506;
        s7.AccessHohoKuruma__c = 'アクセス車';
        s7.AccessHohoBasu__c = 'アクセスバス';
        s7.AccessHouhouDensha__c = 'アクセス電車';
        s7.AccessHohoBiko__c = 'アクセス備考';
		s7.ShisetsuKubun__c = '民営';
		s7.KasobaHeisetsuList__c = '無';
		s7.UneimotoYago__c = 'よりそう';
		s7.TaioShuha__c = '全宗派可';
		s7.ShiminRyokinKubun__c = '設定なし(一律同額)';
		s7.Kyukanbi__c = '土日';
		s7.AnchiShisetsu__c = '有';
		s7.KaminShisetsuUmuKokubetsushikiZenjitsu__c = '有';
		s7.KaminKanoNinzu__c = 1;
		s7.KurumaisuTaio__c = '有';
		s7.ShinzokuHikaeshitsu__c = '有';
        s7.Chushadaisu__c = 1;
		s7.ElevatorUmu__c = '有';
        s7.KidsRoomList__c = '有';
        s7.JunyushitsuList__c = '有';
        s7.KurumaisuKashidashiList__c = '有';
        s7.OmutsuKokandaiList__c = '有';
		s7.SogishaKensakuHihyoji__c = false;
		s7.ShokaiKa__c = true;
	    sList.add(s7);

		Saijo__c s8 = new Saijo__c();
	    s8.SaijoKeisaiJohoIdOld__c = '1111111119';
        s8.SimpleHPKeisaiAri__c = true;
		s8.Name = 'テスト寺院斎場';
		s8.KeisaiSaijoMeiKana__c = 'テスト';
		s8.TokuchoSaijo__c = '特徴';
        s8.ShikugunRef__c=shibuya.id;
		s8.PostalCode__c = '150-0022';
		s8.Street__c = '恵比寿南';
        s8.JushoKana__c = 'えびすみなみ';
        s8.IdoKedo__Latitude__s = 35.6617773;
        s8.IdoKedo__longitude__s = 139.7040506;
        s8.AccessHohoKuruma__c = 'アクセス車';
        s8.AccessHohoBasu__c = 'アクセスバス';
        s8.AccessHouhouDensha__c = 'アクセス電車';
        s8.AccessHohoBiko__c = 'アクセス備考';
		s8.ShisetsuKubun__c = '寺院';
		s8.KasobaHeisetsuList__c = '無';
		s8.UneimotoYago__c = 'よりそう';
		s8.TaioShuha__c = '全宗派可';
		s8.ShiminRyokinKubun__c = '設定なし(一律同額)';
		s8.Kyukanbi__c = '土日';
		s8.AnchiShisetsu__c = '有';
		s8.KaminShisetsuUmuKokubetsushikiZenjitsu__c = '有';
		s8.KaminKanoNinzu__c = 1;
		s8.KurumaisuTaio__c = '有';
		s8.ShinzokuHikaeshitsu__c = '有';
        s8.Chushadaisu__c = 1;
		s8.ElevatorUmu__c = '有';
        s8.KidsRoomList__c = '有';
        s8.JunyushitsuList__c = '有';
        s8.KurumaisuKashidashiList__c = '有';
        s8.OmutsuKokandaiList__c = '有';
		s8.SogishaKensakuHihyoji__c = false;
		s8.ShokaiKa__c = true;
	    sList.add(s8);
		insert sList;

	    SaijoHall__c saijoHall = new SaijoHall__c();
	    saijoHall.SaijoRef__c = sList.get(0).Id;
	    saijoHall.Name = 'テストホール';
		saijoHall.TaioShikishubetsu__c = '一日葬';
		saijoHall.Sekisu__c = 1;
		saijoHall.JogenKaisoshasu__c = 1;
	    insert saijoHall;

		// 施行可能エリア
		List<SekouKanouArea__c> sekouKanouAreaList = new List<SekouKanouArea__c>{
			new SekouKanouArea__c(SimpleYasugoKeiyakuRef__c = Keiyaku.Id, ShikugunRef__c = shikugun.Id),
			new SekouKanouArea__c(ShisetsuRef__c = Shisetsu2.Id, ShikugunRef__c = shikugun.Id)
		};
		insert sekouKanouAreaList;

        trgActive.isActive__c = true;
        update trgActive;
    }

    @isTest
    static void doTest(){

        Test.startTest();

        insert new case(
                        RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SimpleYasugoShiryoSeikyuWebForm').getRecordTypeId(),
                        Lastname__c = 'テスト姓',
                        Firstname__c = 'テスト名',
                        FirstNameKana__c = 'テストセイ',
                        LastNameKana__c = 'テストメイ',
                        TelNo__c = '080-0001-0001',
                        KiboAreaState__c = '東京都',
                        KiboAreaCity__c = '品川区',
                        MailAddress__c = 'test@yoriso.com',
                        Origin = 'Web',
                        ShiryoSoufuHoho__c = 'メール'
                    );
        

        Test.stopTest();
    }
}