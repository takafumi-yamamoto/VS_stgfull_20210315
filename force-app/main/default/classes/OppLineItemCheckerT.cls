@isTest
private class OppLineItemCheckerT {
	@testSetup
	static void setup() {
		Account accCus = new Account(
				RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
				FirstName = '_', LastName = '_'
			);
		insert accCus;

		//標準価格表取得
		Id lsrstandardPricebook = Test.getStandardPricebookId();

		//取引先の「お客様」データ作成
		Account acc = new Account(
			LastName ='TEST',
			FirstName ='お客様',
			PersonBirthdate = Date.newInstance(2020, 6, 1),
			SeinengappiWareki__c = '令和2年06月01日',
			BotsunengappiWareki__c = '令和2年06月01日',
			PersonDeathDate__pc = Date.newInstance(2020, 6, 1),
			RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId()
		);
		Database.SaveResult lsracc = Database.insert(acc);
	
		Date TESTDate = Date.today();
		Date YukoKaishiBi = TESTDate.addDays(-2);
		Date YukoShuryoBi = TESTDate.addDays(5);
		Achievement__c Achiev = new Achievement__c(
			TorihikiSakiRef__c = lsracc.getid(),
			Syubetsu__c = 'campaign_sougi_bouquet',
			YukoFlag__c = true, 
			BaitaiToroku__c = 'Phone',
			YukoKaishiBi__c = YukoKaishiBi,
			YukoShuryoBi__c = YukoShuryoBi
		);
		insert Achiev;

		//取引先の「葬儀社」データ作成
		Account acc2 = new Account(
			Name ='システム動作確認用',
			RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Sogisya').getRecordTypeId(),
			Fax = '03-3493-87701'
		);
		Database.SaveResult lsracc2 = Database.insert(acc2);
	
		//パートナー契約の「シンプル安豪契約」データ作成
		Keiyaku__c Keiyaku = new Keiyaku__c(
			Name = 'シンプル安豪契約',
			RecordTypeId = Schema.getGlobalDescribe().get('Keiyaku__c').getDescribe().getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId(),
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
			campaign_sougi_bouquet__c = '対応不可'
		);
		Database.SaveResult lsrKeiyaku = Database.insert(Keiyaku);

		//商談のデータ作成
		opportunity opp1 = new opportunity(
			AccountId = lsracc.getId(),
			RecordTypeId = Schema.getGlobalDescribe().get('Opportunity').getDescribe().getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId(),
			Pricebook2Id = lsrstandardPricebook,
			Name = 'TEST特約店手数料',
			StageName = '問合せ受付',
			Amount = 151800,
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
			KiboShiharaiHouhou__c = '後払い（GMO）',
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

		Database.SaveResult lsropp = Database.insert(opp1);
		
		//シンプル安豪のデータ更新
		opportunity opp2 = [SELECT Id , SimpleYasugoRef__c FROM Opportunity WHERE Id = :lsropp.getId() limit 1];

		SimpleYasugo__c SimpleYasugo = new SimpleYasugo__c(
			Id = opp2.SimpleYasugoRef__c,
			addfee__c = 0,
			Amount__c = 0,
			TaiouKanouRiyu__c ='対応可能（斎場優先）',
			SimpleYasugoKeiyakuRef__c = lsrKeiyaku.getId(),
			TsuyaDateTime_Inp__c = Datetime.now(),
			KokubetsuDateTime_Inp__c = Datetime.now(),
			KasoDateTime_Inp__c = Datetime.now(),
			MitsumorijuryoDay__c = Date.today(),
			SoryoTehaiIraishoJuryobi__c = Date.today()
		);
		
		update SimpleYasugo;

	}

	@isTest
	static void myUnitTest() {
		Opportunity opp = [Select Id From Opportunity Where RecordType.Name = 'シンプル安豪' limit 1];
		OppLineItemChecker.getOldProductSize(opp.Id);
	}
}