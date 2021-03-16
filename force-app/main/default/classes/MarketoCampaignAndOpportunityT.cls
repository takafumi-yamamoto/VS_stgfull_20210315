@isTest
public class MarketoCampaignAndOpportunityT {
	
	@isTest static void doTest_scheduleNew(){
		//k_割引プランオブジェクトに割引プラン名「なし」のデータを作成
		k_WaribikiPlan__c WaribikiP = new k_WaribikiPlan__c(
			Name = 'なし',
			ID__c = '0'
		);
		Database.SaveResult lsrWaribikiP = Database.insert(WaribikiP);
		
		//k_クーポンオブジェクトにクーポン名「【理想の旅立ち・よりそう】一日葬」のデータを作成
		k_Coupon__c Coupon_k = new k_Coupon__c(
			Name = '【理想の旅立ち・よりそう】一日葬',
			ID__c = '18'
		);
		Database.SaveResult lsrCoupon_k = Database.insert(Coupon_k);

		//k_サービスオブジェクトにサービス名「シンプルなお葬式」のデータを作成
		k_Service__c Service_k = new k_Service__c(
			Name = 'シンプルなお葬式',
			ID__c = '1'
		);
		Database.SaveResult lsrService_k = Database.insert(Service_k);

		//k_商品カテゴリオブジェクトに商品カテゴリ名「一日葬」のデータを作成
		k_ShohinCategory__c ShohinCategory_k = new k_ShohinCategory__c(
			Name = '一日葬',
			ID__c = 'ichinichi'
		);
		Database.SaveResult lsrShohinCategory_k = Database.insert(ShohinCategory_k);

		//k_商品種別オブジェクトに商品種別名「本体（委託）」のデータを作成
		k_ShohinSyubetsu__c ShohinSyubetsu_k = new k_ShohinSyubetsu__c(
			Name = '本体（委託）',
			ID__c = '1',
			KeijouSyubetsu__c = 'グロス'
		);
		Database.SaveResult lsrShohinSyubetsu_k = Database.insert(ShohinSyubetsu_k);

		//商品オブジェクトに商品名「【新】よりそうのお葬式　一日葬　無宗教プラン」のデータを作成
		Product2 ProdOne = new Product2(
			Name = '【新】よりそうのお葬式　一日葬　無宗教プラン',
			IsActive = TRUE,
			BunruiKensakuTag__c = '@@SCU',
			DataKubun__c = '1:通常商品',
			HanbaiKaishiBi__c = date.valueOf('2010-09-30'),
			HanbaiSyuryoBi__c = date.valueOf('2100-12-30'),
			IsKingakuHenkouFuka__c = FALSE,
			NameForCustomer__c = 'よりそうのお葬式 一日葬 無宗教プラン',
			ShohinBango__c = 'SBG-0001005',
			ShohinKamoku__c = '通常',
			SireKingaku__c = 294800,
			SougiPlan__c = TRUE,
			k_Coupon__c = lsrCoupon_k.getId(),
			k_ServiceRef__c = lsrService_k.getId(),
			k_ShohinCategoryRef__c = lsrShohinCategory_k.getId(),
			k_ShohinSyubetsuRef__c = lsrShohinSyubetsu_k.getId(),
			k_WaribikiPlan__c = lsrWaribikiP.getId(),
			HinmokuBunrui__c = '本体',
			TesuryoKingaku__c = 0,
			SireKingakuKeisanHousiki__c = '設定金額',
			TesuryoKingakuKeisanHoushiki__c = '計算しない',
			CoreRenkeiShinai__c = FALSE,
			TesuryoCyoseiKingakuKeisanHoushiki__c = '計算しない'
		);
		Database.SaveResult lsrProdOne = Database.insert(ProdOne);

		//価格表オブジェクトのデータを作成
		id lsrstandardPricebook = Test.getStandardPricebookId();

		//価格表エントリオブジェクトに価格エントリ番号「StandardSBG-0001005」のデータを作成
		PricebookEntry sPEntry = new PricebookEntry(
			Pricebook2Id = lsrstandardPricebook,
			Product2Id = lsrProdOne.getId(),
			UnitPrice = 294800,
			UseStandardPrice = FALSE,
			IsActive = true,
			KakakuEntryBango__c = 'StandardSBG-0001005'
		);
		Database.SaveResult lsrstandardPricebookEntry = Database.insert(sPEntry);

		//与信管理オブジェクトにデータを作成
		YosinKanri__c YosinKanri= new YosinKanri__c(
			Gendogaku__c = 300000,
			NyukinSimekiriJouken__c = '請求書発送日から7日後',
			YukokigenFrom__c = date.valueOf('2018-01-01'),
			YukokigenTo__c = date.valueOf('2099-01-01')
		);
		Database.SaveResult lsrYosinKanri = Database.insert(YosinKanri);

		//PtWebAccountオブジェクトにデータを作成
		PtWebAccount__c PtWeb = new PtWebAccount__c(
			mailAddress__c = 'dev-test+2018@yoriso.com'
		);
		Database.SaveResult lsrPtWeb = Database.insert(PtWeb);

		//取引先の「お客様」データ作成
		Account acc = new Account(
			LastName ='TEST',
			FirstName ='特約店手数料対応',
			PermissionFlag__pc = '受け取る',
			MemberTourokuZumi__c = TRUE,
			PersonEmail = 'mail@yoriso.com',
			YusenMailAddressKubun__c = 'メールアドレス1',
			//Phone ='080-0000-0001',
			//MobilePhone__c ='080-0000-0001',
			RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer')
		);
		Database.SaveResult lsracc = Database.insert(acc);

		//取引先の「葬儀社」データ作成
		Account acc2 = new Account(
			Name ='システム動作確認用',
			RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Sogisya'), 
			Fax = '03-3493-87701',
			Description = 'この葬儀社は、システム内で本番環境で動作確認する際に利用するテストデータの葬儀社です。',
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
			PtWebAccountRef__c = lsrPtWeb.getId(),
			IsOboStLineAcnt__c = FALSE,
			YosinKanriRef__c = lsrYosinKanri.getId(),
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
			RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Keiyaku__c','SimpleYasugo'),
			Teikeisaki__c = lsracc2.getId(),
			AmazonTaioka__c = FALSE,
			AreaTokureiAri__c = FALSE,
			KaiteKiyakuTekiyoZumi__c = FALSE,
			KeiyakuJokyo__c = '契約中',
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

		//パートナー契約の「特約店契約」データ作成
		Keiyaku__c Keiyaku2 = new Keiyaku__c(
			Name = '特約店契約',
			RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Keiyaku__c','TokuyakuTen'),
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

		String oppTorihikiRdId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','TorihikiShodan');
		//取引商談のデータ作成
		opportunity torihikiopp = new opportunity(
			AccountId = lsracc.getId(),
			RecordTypeId = oppTorihikiRdId,
			IsPrivate = FALSE,
			Name = 'TEST特約店手数料',
			StageName = '問合せ受付',
			BodaijiKyokaAri__c = FALSE,
			FBNaiyoKakunin__c = FALSE,
			UwanoseTesuryoBaSettei__c = FALSE,
			uriagekakuteizumi__c = FALSE,
			OppEditDate__c = Date.today(),
			Req_Day__c = Date.today(),
			CloseDate = Date.today(),
			ClamAri__c = FALSE,
			KetteiKeinsyaHearingZumi__c = FALSE,
			MosyuTourokuKubun__c = '本人',
			RyosyuAtenaIsSodansha__c = FALSE,
			RyosyuYou__c = FALSE,
			SiryoSeikyoAri__c = FALSE,
			SiryoSoufuSakiIsSoudansya__c = FALSE,
			TryCount__c = 0,
			TryLimit__c = 0,
			TesuryoPartner__c = 0,
			SodanshaNameTxt__c = 'TEST特約店手数料対応',
			JimuTesuryo__c = 0
		);
		Database.SaveResult lsrtorihikiopp = Database.insert(torihikiopp);
		
		String oppSYRdId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId();
		//商談のデータ作成
		opportunity opp = new opportunity(
			AccountId = lsracc.getId(),
			RecordTypeId = oppSYRdId,
			Pricebook2Id = lsrstandardPricebook,
			TorihikiShodanRef__c = lsrtorihikiopp.getId(),
			TaishosyaRef__c = lsracc.getId(),
			MosyuRef__c = lsracc.getId(),
			Name = 'TEST特約店手数料',
			StageName = '問合せ受付',
			SubPhase__c = '3分コール接続待',
			TaishoushaJokyo__c = '危篤', 
			Amount = 294800,
			IsPrivate = FALSE,
			Probability = 0,
			TotalOpportunityQuantity = 1,
			ForecastCategoryName = 'パイプライン',
			BodaijiKyokaAri__c = FALSE,
			FBNaiyoKakunin__c = FALSE,
			ReportPhaseSubPhase__c = 'Y-01-99. 問合せ受付：‐',
			TokuyakutenTesuryoKihonbun__c = 0,
			TokuyakutenTesuryoUwanosebun__c = 0,
			UwanoseTesuryoBaSettei__c = FALSE,
			uriagekakuteizumi__c = FALSE,
			OppEditDate__c = Date.today(),
			Req_Day__c = Date.today(),
			CloseDate = Date.today(),
			ClamAri__c = FALSE,
			KetteiKeinsyaHearingZumi__c = FALSE,
			KiboShiharaiHouhou__c = '現金',
			MosyuTourokuKubun__c = '本人',
			RyosyuAtenaIsSodansha__c = FALSE,
			RyosyuYou__c = FALSE,
			SiryoSeikyoAri__c = FALSE,
			SiryoSoufuSakiIsSoudansya__c = FALSE,
			TryCount__c = 0,
			TryLimit__c = 3,
			Utiagebi__c = date.today(),
			TesuryoPartner__c = 0,
			SodanshaNameTxt__c = 'TEST特約店手数料対応',
			TaisyousyaNameTxt__c = 'TEST特約店手数料対応',
			KetteiSakiRef__c = lsrKeiyaku.getId(),
			KetteiSakiKanaSerch__c = 'TEST特約店手数料対応',
			JimuTesuryo__c = 0

		);

		Database.SaveResult lsropp = Database.insert(opp);
		
		//シンプル安豪のデータ更新
		Opportunity opp2 = [SELECT Id , SimpleYasugoRef__c FROM Opportunity WHERE Id = :lsropp.getId() limit 1];

		SimpleYasugo__c SimpleYasugo = new SimpleYasugo__c(
			Id = opp2.SimpleYasugoRef__c,
			addfee__c = 0,
			Amount__c = 0,
			CardLoanSettlementAmount__c = 0,
			CookingCharge__c = 0,
			CookingTotalFee__c = 0,
			FaceToFace_free_jizenwari__c = FALSE,
			FamilyTempleObtainConsensus__c = FALSE,
			JimuTesuryo__c = 0,
			KantoFlagHallFee__c = FALSE,
			KantoFlag__c = FALSE,
			MonkArrangements__c  ='未確認',
			OmukaeFree__c = FALSE,
			optiontotal__c = 0,
			PlanChargeFee__c = 0,
			PlanFee__c = 0,
			planchargefixed__c = 0,
			ReturnGoodsCharge__c = 0,
			ReturnGoodsTotalFee__c = 0,
			RyoshusyoAtenaSoudansha__c = FALSE,
			SeizenKeiyakuSousaiGaku__c = 0,
			SeizennkeiyakuKessaiFlg__c = FALSE,
			SougisyaSeikyuuGaku__c = 0,
			SougisyaSiharaiGaku__c = 0,
			Syuzai__c = FALSE,
			TaiouKanouRiyu__c  ='対応可能（斎場優先）',
			Transport_free__c = FALSE,
			UriageKakuteiflag__c = FALSE,
			BouquetCharge__c = 0,
			BouquetPrice__c = 0,
			ClamAri__c = FALSE,
			ExteriorCharge__c = 0,
			ExteriorPrice__c = 0,
			FaxSofuYohi__c = FALSE,
			FollowTelFuyo__c = FALSE,
			FrontSignCharge__c = 0,
			FrontSignPrice__c = 0,
			GoanchiMenkaiKiboUmu__c = FALSE,
			IeiCharge__c = 0,
			IeiPrice__c = 0,
			InformationSignCharge__c = 0,
			InformationSignPrice__c = 0,
			InteriorCharge__c = 0,
			InteriorPrice__c = 0,
			KugeCharge__c = 0,
			KugePrice__c = 0,
			LastMakeupCharge__c = 0,
			LastMakeupPrice__c = 0,
			MailSofuYohi__c = FALSE,
			MakeupDressCharge__c = 0,
			MakeupDressPrice__c = 0,
			MakurahanaCharge__c = 0,
			MakurahanaPrice__c = 0,
			OkyakusamaHenkingaku__c = 0,
			OptionChargeTotal__c = 0,
			PartingCharge__c = 0,
			PartingPrice__c = 0,
			PlanChargeRsFP__c = 0,
			SeikyushojuryoDay__c = Date.today(),
			ShiryoSofuJokyo__c  ='未送付',
			SimpleYasugoKeiyakuRef__c = lsrKeiyaku.getId(),
			SogiPlanToSogiPlanGaKotonaru__c = FALSE,
			SokyakugoPlanHenkoUmu__c = FALSE,
			SougisyaKaisyuAmount__c = 0,
			TaishoshaRef__c = lsracc.getId(),
			TesuryoShubetsu__c  ='規定通り',
			Tesuryo__c = 0,
			TheCoffinSizeCharge__c = 0,
			TheCoffinSizePrice__c = 0,
			TheCoffinTypeCharge__c = 0,
			TheCoffinTypePrice__c = 0,
			UrnCharge__c = 0,
			UrnPrice__c = 0,
			YukanCharge__c = 0,
			YukanPrice__c = 0,
			discountfee__c = 0,
			kumotuCharge__c = 0,
			kumotu__c = 0,
			Hitsugi__c = 0,
			PlanNaiyo__c  ='一日葬 294,800円',
			ReportNyukingaku__c = 0,
			ReportMaeukekin__c = 0,
			ReportCouponWaribiki__c = 0,
			AnchiRyokin2hakuOr3haku__c = FALSE,
			HansoKaisu2kaiOr3kai__c = FALSE,
			HansoKyori50km__c = FALSE,
			KasojoShiyoryo1man5sen__c = FALSE,
			KeisatsuAnken__c = FALSE,
			ShikijoShiyoryo2man5senOr5man__c = FALSE,
			SosaiFujo__c = FALSE,
			TaijiAnken__c = FALSE,
			TashaAnchi__c = FALSE,
			SaidanPrice__c = 0,
			EmbalmingPrice__c = 0,
			KasobaShiyoryoPlangai__c = FALSE,
			ChokusoPlanMenkaiFuka__c = FALSE,
			KeisatsuAnkenKenanryo__c = FALSE
		);

		update SimpleYasugo;

		Campaign sCampaign = new Campaign(
		  Name = 'Marketoステップメール [階層の表示]',	   // キャンペーン名
		  IsActive = true,						 // 有効
		  Status = '進行中',						  // 状況
		  Type = 'メールマーケティング'					 // 種別
		);
		Database.SaveResult CampaignMarketoStepMail = Database.insert(sCampaign);

		MarketoManagement__c sMarketoStepMail = new MarketoManagement__c(
		  MarketoName__c = 'MarketoStepMail2nd',	 // Marketo連携処理名
		  Campaign__c = CampaignMarketoStepMail.getId(),			 // キャンペーン
		  MarketoClassName__c = 'MarketoStepMail2nd',  // Marketo連携用APEXクラス名
		  MarketoFlg__c = true,						// Marketo送信フラグ更新処理の実施可否フラグ
		  TESTMarketoFlg__c = true					// Marketo送信TESTフラグ
		);
		Database.SaveResult inMarketoStepMail = Database.insert(sMarketoStepMail);

		LIST<Opportunity> OpportunityMarketoStepMial = [SELECT Id  FROM Opportunity];

		MarketoManagement__c MarketoManagement = [SELECT Id,
													MarketoName__c,
													MarketoFlg__c,
													TESTMarketoFlg__c,
													Campaign__c,
													MarketoClassName__c
												FROM MarketoManagement__c
												WHERE Id = :inMarketoStepMail.getId()
												limit 1];
		Test.startTest();
		MarketoCampaignAndOpportunity cTEST = new MarketoCampaignAndOpportunity();
		cTEST.addLinkMarketoCampaignAndOpportunity(OpportunityMarketoStepMial,MarketoManagement.Campaign__c);
		Test.stopTest();
	}
}