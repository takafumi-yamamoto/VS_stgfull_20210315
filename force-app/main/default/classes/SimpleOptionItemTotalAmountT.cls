@isTest
private class SimpleOptionItemTotalAmountT{

	private static void beginSetUp(){
        Utility_Common.isMimicExecAsDataIkouProfile = true;
    }
	private static void endSetUp(){
        Insert new TriggerIsActive__c( name='default', isActive__c=true );
        Insert new JizenWariPlan__c( Code__c='Yoriso' );
        Insert new Account(
            RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','null'),
            FirstName = '_', LastName = '_'
        );
		Utility_Common.isMimicExecAsDataIkouProfile = false;
	}

	@isTest
	public static void doSimpleOptionItemTotalAmountCalculationT(){

		beginSetUp();

		Account accSogisha = new Account(
			Name = '_',										// お客様・提携先名
			RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Sogisya').getRecordTypeId(),
			KinyukikanCodeTosha__c = '_', 
			KinyukikanMeiTosha__c = '_', 
			KozaShubetsuTosha__c = '普通', 
			KozaBangoTosha__c = '_', 
			KozaMeigiKanaTosha__c = '_', 
			KozaMeigiTosha__c = '_', 
			ShitenCodeTosha__c = '_', 
			ShitenMeiTosha__c = '_'
		);
		insert accSogisha;
		
        Keiyaku__c keiyaku = new Keiyaku__c(
            Name = 'シンプル安豪契約',
            RecordTypeId = Schema.SObjectType.Keiyaku__c.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId(),
            Teikeisaki__c = accSogisha.Id,
            KeiyakuJokyo__c = '未契約',
            SeikyushoHassoCycle__c = '都度',
            NyukinSimekiriJouken__c = '請求書発送日から7日後'
        );
		insert keiyaku;
		
		List<k_ShohinCategory__c> insCategoryList = new List<k_ShohinCategory__c>();
		k_ShohinCategory__c sogisha = new k_ShohinCategory__c( Name = '葬儀オプション', ID__c = 'sougiOption');
		k_ShohinCategory__c yoriso = new k_ShohinCategory__c( Name = 'よりそうオプション', ID__c = 'yoriso-option');
		insCategoryList.add(sogisha);
		insCategoryList.add(yoriso);
		insert insCategoryList;

        k_Service__c kService = new k_Service__c( name='_', ID__c = '1' );
        insert kService;

        TesuryoPlan__c tesuryoPlan = new TesuryoPlan__c( 
            Name = '_',  CoreTesuryoPlanId__c = 1, ServiceRef__c = kService.Id,
            KobetsuPlanFlag__c = false, TesuryoNebikiSetteiKa__c = false );
        insert tesuryoPlan;

        TesuryoTekiyo__c tesuryoTekiyo = new TesuryoTekiyo__c(
            KeiyakuRef__c = keiyaku.Id,  
            ShoninStatus__c = 'ドラフト',
            TekiyoKaishiBi__c = Date.valueOf('1900-01-01'),
            TesuryoPlanRef__c = tesuryoPlan.Id,
            RyoriTesuryoAri__c = true,
            HenreihinTesuryoAri__c = true,
			OptionTesuryoAri__c = true,
			UrnOptionTesuryoFlg__c = true, 
            ServiceRef__c = kService.Id);
        insert tesuryoTekiyo;

        tesuryoTekiyo.ShoninStatus__c = '承認済';
        update tesuryoTekiyo;

        keiyaku.KeiyakuJokyo__c = '契約中';
        keiyaku.Keiyakukaishibi__c = Date.today();
        update keiyaku;

        List<Product2> pList = new List<Product2>{
			new Product2(Name = '本体', IsActive = true, ShohinBango__c = '1', k_ServiceRef__c = kService.Id, HinmokuBunrui__c = '本体'),
			new Product2(Name = '返礼品', IsActive = true, ShohinBango__c = '2', k_ServiceRef__c = kService.Id, HinmokuBunrui__c = '返礼品', k_ShohinCategoryRef__c = sogisha.Id),
			new Product2(Name = '料理', IsActive = true, ShohinBango__c = '3', k_ServiceRef__c = kService.Id, HinmokuBunrui__c = '料理', k_ShohinCategoryRef__c = sogisha.Id),
			new Product2(Name = 'ラストメイク', IsActive = true, ShohinBango__c = '4', k_ServiceRef__c = kService.Id, HinmokuBunrui__c = 'ラストメイク', k_ShohinCategoryRef__c = sogisha.Id),
			new Product2(Name = 'メイク＆ドレス(古式湯灌)', IsActive = true, ShohinBango__c = '5', k_ServiceRef__c = kService.Id, HinmokuBunrui__c = 'メイク＆ドレス(古式湯灌)', k_ShohinCategoryRef__c = sogisha.Id),
			new Product2(Name = '湯かん', IsActive = true, ShohinBango__c = '6', k_ServiceRef__c = kService.Id, HinmokuBunrui__c = '湯かん', k_ShohinCategoryRef__c = sogisha.Id),
			new Product2(Name = '枕花', IsActive = true, ShohinBango__c = '7', k_ServiceRef__c = kService.Id, HinmokuBunrui__c = '枕花', k_ShohinCategoryRef__c = sogisha.Id),
			new Product2(Name = '棺上花束', IsActive = true, ShohinBango__c = '8', k_ServiceRef__c = kService.Id, HinmokuBunrui__c = '棺上花束', k_ShohinCategoryRef__c = sogisha.Id),
			new Product2(Name = 'お別れ花', IsActive = true, ShohinBango__c = '9', k_ServiceRef__c = kService.Id, HinmokuBunrui__c = 'お別れ花', k_ShohinCategoryRef__c = sogisha.Id),
			new Product2(Name = '供花', IsActive = true, ShohinBango__c = '10', k_ServiceRef__c = kService.Id, HinmokuBunrui__c = '供花', k_ShohinCategoryRef__c = sogisha.Id),
			new Product2(Name = '供物', IsActive = true, ShohinBango__c = '11', k_ServiceRef__c = kService.Id, HinmokuBunrui__c = '供物', k_ShohinCategoryRef__c = sogisha.Id),
			new Product2(Name = '遺影写真', IsActive = true, ShohinBango__c = '12', k_ServiceRef__c = kService.Id, HinmokuBunrui__c = '遺影写真', k_ShohinCategoryRef__c = sogisha.Id),
			new Product2(Name = '看板', IsActive = true, ShohinBango__c = '13', k_ServiceRef__c = kService.Id, HinmokuBunrui__c = '看板', k_ShohinCategoryRef__c = sogisha.Id),
			new Product2(Name = '外装設備追加', IsActive = true, ShohinBango__c = '14', k_ServiceRef__c = kService.Id, HinmokuBunrui__c = '外装設備追加', k_ShohinCategoryRef__c = sogisha.Id),
			new Product2(Name = '骨壺ランクアップ', IsActive = true, ShohinBango__c = '15', k_ServiceRef__c = kService.Id, HinmokuBunrui__c = '骨壺ランクアップ', k_ShohinCategoryRef__c = sogisha.Id),
			new Product2(Name = '棺', IsActive = true, ShohinBango__c = '16', k_ServiceRef__c = kService.Id, HinmokuBunrui__c = '棺', k_ShohinCategoryRef__c = sogisha.Id),
			new Product2(Name = '祭壇', IsActive = true, ShohinBango__c = '17', k_ServiceRef__c = kService.Id, HinmokuBunrui__c = '祭壇', k_ShohinCategoryRef__c = sogisha.Id),
			new Product2(Name = 'エンバーミング', IsActive = true, ShohinBango__c = '18', k_ServiceRef__c = kService.Id, HinmokuBunrui__c = 'エンバーミング', k_ShohinCategoryRef__c = sogisha.Id),
			new Product2(Name = '事務手数料', IsActive = true, ShohinBango__c = '19', k_ServiceRef__c = kService.Id, HinmokuBunrui__c = '事務手数料'),
			new Product2(Name = '決済手数料(GMO後払い)', IsActive = true, ShohinBango__c = '20', k_ServiceRef__c = kService.Id, HinmokuBunrui__c = '決済手数料(GMO後払い)'),
			new Product2(Name = '祭壇', IsActive = true, ShohinBango__c = '21', k_ServiceRef__c = kService.Id, HinmokuBunrui__c = '祭壇', k_ShohinCategoryRef__c = yoriso.Id),
			new Product2(Name = '枕花', IsActive = true, ShohinBango__c = '22', k_ServiceRef__c = kService.Id, HinmokuBunrui__c = '枕花', k_ShohinCategoryRef__c = yoriso.Id),
			new Product2(Name = '棺上花束', IsActive = true, ShohinBango__c = '23', k_ServiceRef__c = kService.Id, HinmokuBunrui__c = '棺上花束', k_ShohinCategoryRef__c = yoriso.Id),
			new Product2(Name = 'お別れ花', IsActive = true, ShohinBango__c = '24', k_ServiceRef__c = kService.Id, HinmokuBunrui__c = 'お別れ花', k_ShohinCategoryRef__c = yoriso.Id)
        };
		insert pList;


		List<PricebookEntry> peList = new List<PricebookEntry>{
			new PricebookEntry(Pricebook2Id = Test.getStandardPricebookId(),Product2Id = pList.get(0).Id,UnitPrice = 1000,IsActive = true),
			new PricebookEntry(Pricebook2Id = Test.getStandardPricebookId(),Product2Id = pList.get(1).Id,UnitPrice = 1000,IsActive = true),
			new PricebookEntry(Pricebook2Id = Test.getStandardPricebookId(),Product2Id = pList.get(2).Id,UnitPrice = 1000,IsActive = true),
			new PricebookEntry(Pricebook2Id = Test.getStandardPricebookId(),Product2Id = pList.get(3).Id,UnitPrice = 1000,IsActive = true),
			new PricebookEntry(Pricebook2Id = Test.getStandardPricebookId(),Product2Id = pList.get(4).Id,UnitPrice = 1000,IsActive = true),
			new PricebookEntry(Pricebook2Id = Test.getStandardPricebookId(),Product2Id = pList.get(5).Id,UnitPrice = 1000,IsActive = true),
			new PricebookEntry(Pricebook2Id = Test.getStandardPricebookId(),Product2Id = pList.get(6).Id,UnitPrice = 1000,IsActive = true),
			new PricebookEntry(Pricebook2Id = Test.getStandardPricebookId(),Product2Id = pList.get(7).Id,UnitPrice = 1000,IsActive = true),
			new PricebookEntry(Pricebook2Id = Test.getStandardPricebookId(),Product2Id = pList.get(8).Id,UnitPrice = 1000,IsActive = true),
			new PricebookEntry(Pricebook2Id = Test.getStandardPricebookId(),Product2Id = pList.get(9).Id,UnitPrice = 1000,IsActive = true),
			new PricebookEntry(Pricebook2Id = Test.getStandardPricebookId(),Product2Id = pList.get(10).Id,UnitPrice = 1000,IsActive = true),
			new PricebookEntry(Pricebook2Id = Test.getStandardPricebookId(),Product2Id = pList.get(11).Id,UnitPrice = 1000,IsActive = true),
			new PricebookEntry(Pricebook2Id = Test.getStandardPricebookId(),Product2Id = pList.get(12).Id,UnitPrice = 1000,IsActive = true),
			new PricebookEntry(Pricebook2Id = Test.getStandardPricebookId(),Product2Id = pList.get(13).Id,UnitPrice = 1000,IsActive = true),
			new PricebookEntry(Pricebook2Id = Test.getStandardPricebookId(),Product2Id = pList.get(14).Id,UnitPrice = 1000,IsActive = true),
			new PricebookEntry(Pricebook2Id = Test.getStandardPricebookId(),Product2Id = pList.get(15).Id,UnitPrice = 1000,IsActive = true),
			new PricebookEntry(Pricebook2Id = Test.getStandardPricebookId(),Product2Id = pList.get(16).Id,UnitPrice = 1000,IsActive = true),
			new PricebookEntry(Pricebook2Id = Test.getStandardPricebookId(),Product2Id = pList.get(17).Id,UnitPrice = 1000,IsActive = true),
			new PricebookEntry(Pricebook2Id = Test.getStandardPricebookId(),Product2Id = pList.get(18).Id,UnitPrice = 1000,IsActive = true),
			new PricebookEntry(Pricebook2Id = Test.getStandardPricebookId(),Product2Id = pList.get(19).Id,UnitPrice = 1000,IsActive = true),
			new PricebookEntry(Pricebook2Id = Test.getStandardPricebookId(),Product2Id = pList.get(20).Id,UnitPrice = 1000,IsActive = true),
			new PricebookEntry(Pricebook2Id = Test.getStandardPricebookId(),Product2Id = pList.get(21).Id,UnitPrice = 1000,IsActive = true),
			new PricebookEntry(Pricebook2Id = Test.getStandardPricebookId(),Product2Id = pList.get(22).Id,UnitPrice = 1000,IsActive = true),
			new PricebookEntry(Pricebook2Id = Test.getStandardPricebookId(),Product2Id = pList.get(23).Id,UnitPrice = 1000,IsActive = true)
        };
		insert peList;

		//取引先の「お客様」データ作成
	    Account acc = new Account(
	      LastName ='TEST',
	      FirstName ='特約店手数料対応',
	      RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId()
	    );
	    Database.SaveResult lsracc = Database.insert(acc);

	    Keiyaku__c theKeiyaku = new Keiyaku__c(
			RecordTypeId = Schema.SObjectType.Keiyaku__c.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId(),
			Teikeisaki__c = accSogisha.Id
		);
		insert theKeiyaku;

		//シンプル安豪のデータ作成
	    SimpleYasugo__c simpleYasugo = new SimpleYasugo__c(
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
	      SimpleYasugoKeiyakuRef__c = keiyaku.Id,
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
	    Database.SaveResult lsrSimpleYasugo = Database.insert(simpleYasugo);

	    //商談のデータ作成
	    opportunity opp1 = new opportunity(
	      AccountId = lsracc.getId(),
	      RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId(),
	      TaishosyaRef__c = lsracc.getId(),
	      Name = 'TEST特約店手数料',
	      StageName = '問合せ受付',
	      Amount = 0,
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
	      Req_Day__c = null,
	      CloseDate = Date.today(),
	      ClamAri__c = FALSE,
	      KakuteibiSyodan__c = null,
	      KetteiKeinsyaHearingZumi__c = FALSE,
	      KiboShiharaiHouhou__c = '現金',
	      MosyuTourokuKubun__c = '本人',
	      RyosyuAtenaIsSodansha__c = FALSE,
	      RyosyuYou__c = FALSE,
	      SiryoSeikyoAri__c = FALSE,
	      SiryoSoufuSakiIsSoudansya__c = FALSE,
	      TryCount__c = 0,
	      TryLimit__c = 3,
	      Utiagebi__c = null,
	      TesuryoPartner__c = 0,
	      SodanshaNameTxt__c = 'TEST特約店手数料対応',
	      TaisyousyaNameTxt__c = 'TEST特約店手数料対応',
	      //KetteiSakiRef__c = lsrKeiyaku.getId(),
	      KetteiSakiKanaSerch__c = 'TEST特約店手数料対応',
	      JimuTesuryo__c = 0,
	      Pricebook2Id = Test.getStandardPricebookId(),
	      SimpleYasugoRef__c = simpleYasugo.Id
	    );
	    Database.SaveResult lsropp = Database.insert(opp1);

	    insert new List<OpportunityLineItem>{
	    	new OpportunityLineItem(OpportunityId = opp1.Id,Product2Id = pList.get(0).Id,TotalPrice = 1000,HinmokuBunrui__c = '本体'),
	    	new OpportunityLineItem(OpportunityId = opp1.Id,Product2Id = pList.get(1).Id,TotalPrice = 1000,HinmokuBunrui__c = '返礼品'),
	    	new OpportunityLineItem(OpportunityId = opp1.Id,Product2Id = pList.get(2).Id,TotalPrice = 1000,HinmokuBunrui__c = '料理'),
	    	new OpportunityLineItem(OpportunityId = opp1.Id,Product2Id = pList.get(3).Id,TotalPrice = 1000,HinmokuBunrui__c = 'ラストメイク'),
	    	new OpportunityLineItem(OpportunityId = opp1.Id,Product2Id = pList.get(4).Id,TotalPrice = 1000,HinmokuBunrui__c = 'メイク＆ドレス(古式湯灌)'),
	    	new OpportunityLineItem(OpportunityId = opp1.Id,Product2Id = pList.get(5).Id,TotalPrice = 1000,HinmokuBunrui__c = '湯かん'),
	    	new OpportunityLineItem(OpportunityId = opp1.Id,Product2Id = pList.get(6).Id,TotalPrice = 1000,HinmokuBunrui__c = '枕花'),
	    	new OpportunityLineItem(OpportunityId = opp1.Id,Product2Id = pList.get(7).Id,TotalPrice = 1000,HinmokuBunrui__c = '棺上花束'),
	    	new OpportunityLineItem(OpportunityId = opp1.Id,Product2Id = pList.get(8).Id,TotalPrice = 1000,HinmokuBunrui__c = 'お別れ花'),
	    	new OpportunityLineItem(OpportunityId = opp1.Id,Product2Id = pList.get(9).Id,TotalPrice = 1000,HinmokuBunrui__c = '供花'),
	    	new OpportunityLineItem(OpportunityId = opp1.Id,Product2Id = pList.get(10).Id,TotalPrice = 1000,HinmokuBunrui__c = '供物'),
	    	new OpportunityLineItem(OpportunityId = opp1.Id,Product2Id = pList.get(11).Id,TotalPrice = 1000,HinmokuBunrui__c = '遺影写真'),
	    	new OpportunityLineItem(OpportunityId = opp1.Id,Product2Id = pList.get(12).Id,TotalPrice = 1000,HinmokuBunrui__c = '看板'),
	    	new OpportunityLineItem(OpportunityId = opp1.Id,Product2Id = pList.get(13).Id,TotalPrice = 1000,HinmokuBunrui__c = '外装設備追加'),
	    	new OpportunityLineItem(OpportunityId = opp1.Id,Product2Id = pList.get(14).Id,TotalPrice = 1000,HinmokuBunrui__c = '骨壺ランクアップ'),
	    	new OpportunityLineItem(OpportunityId = opp1.Id,Product2Id = pList.get(15).Id,TotalPrice = 1000,HinmokuBunrui__c = '棺'),
	    	new OpportunityLineItem(OpportunityId = opp1.Id,Product2Id = pList.get(16).Id,TotalPrice = 1000,HinmokuBunrui__c = '祭壇'),
	    	new OpportunityLineItem(OpportunityId = opp1.Id,Product2Id = pList.get(17).Id,TotalPrice = 1000,HinmokuBunrui__c = 'エンバーミング'),
	    	new OpportunityLineItem(OpportunityId = opp1.Id,Product2Id = pList.get(18).Id,TotalPrice = 1000,HinmokuBunrui__c = '事務手数料'),
	    	new OpportunityLineItem(OpportunityId = opp1.Id,Product2Id = pList.get(19).Id,TotalPrice = 1000,HinmokuBunrui__c = '決済手数料(GMO後払い)'),
	    	new OpportunityLineItem(OpportunityId = opp1.Id,Product2Id = pList.get(20).Id,TotalPrice = 1000,HinmokuBunrui__c = '祭壇'),
	    	new OpportunityLineItem(OpportunityId = opp1.Id,Product2Id = pList.get(21).Id,TotalPrice = 1000,HinmokuBunrui__c = '枕花'),
	    	new OpportunityLineItem(OpportunityId = opp1.Id,Product2Id = pList.get(22).Id,TotalPrice = 1000,HinmokuBunrui__c = '棺上花束'),
	    	new OpportunityLineItem(OpportunityId = opp1.Id,Product2Id = pList.get(23).Id,TotalPrice = 1000,HinmokuBunrui__c = 'お別れ花')
	    };

        endSetUp();
		Test.startTest();
	    
	    SimpleOptionItemTotalAmount.doSimpleOptionItemTotalAmountCalculation(opp1.Id);

	    Test.stopTest();
	}
}