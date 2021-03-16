@isTest
public class KeiriSokyakuTeishiActivatorT {

    @isTest static void doTest(){
	
		ID AccountTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Sogisya').getRecordTypeId();
		Account acc = new Account(
			Name = '株式会社ティア',										// お客様・提携先名
			NameYagouFurigana__c = 'カブシキガイシャティア',				// 屋号（カナ）
			NameShogo__c = '株式会社ティア',								// 商号
			NameShogoFurigana__c = 'カブシキガイシャティア',				// 商号（カナ）
			KeisaiMeiSogiRebiYo__c = '株式会社ティア',						// 掲載名（葬儀レビ用）
			AllianceType__c = '提携中',									// 提携種別
			Phone = '048-969-1200',											// 電話1
			Fax = '048-969-2300',											// Fax
			MailAddress__c = 'k-kondou@tear.co.jp',							// メールアドレス1
			DaihyoName__c = '冨安　徳久',									// 代表名
			SeikyuSakiTantoName__c = '鵜野　智教',							// 経理担当者名
			SeikyuSakiTantoNameFurigana__c = 'ウノ　トモノリ',				// 経理担当者名(カナ)
			SeikyuSakiPhone1__c = '052-918-8220',							// 電話1（請求先）
			SeikyuSakiAddrPostalCode__c = '462-0841',						// 郵便番号（請求先）
			SeikyuSakiAddrState__c = '愛知県',								// 都道府県（請求先）
			SeikyuSakiAddrCity__c = '名古屋市北区',							// 市区郡（請求先）
			SeikyuSakiAddrStreet__c = '黒川本通3-35-1　ティア黒川5F',		// 町名・番地（請求先）
			NayosePhone1__c = '0489691200',									// 【名寄せ】電話1
			NayosePhone2__c = '0489691200',									// 【名寄せ】電話2
			NayoseMailAddress__c = 'k-kondou@tear.co.jp',					// 【名寄せ】メールアドレス1
			RecordTypeId = AccountTypeId,									// お客様・提携先レコードタイプ
			NayoseMailAddress2__c = 'k-kondou@tear.co.jp'					// 【名寄せ】メールアドレス2
		);
		Database.SaveResult lsracc = Database.insert(acc);
		
		ID KeiyakuId = Schema.SObjectType.Keiyaku__c.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId();
		Keiyaku__c sKeiyaku = new Keiyaku__c(
			RecordTypeId = KeiyakuId,																	// レコードタイプ
			Name = '株式会社ティア_シンプル安豪契約',													// パートナー契約名
			Teikeisaki__c = lsracc.getId(),																// 提携先
			KeiyakuJokyo__c = '契約中',																	// 契約状況
			KeiyakuMousikomiBi__c = Date.valueOf('2018-12-20'),											// 契約申込日
			Keiyakukaishibi__c = Date.valueOf('2018-12-25'),											// 契約開始日
			KeiyakuSyoSyosiki__c = '2018年1月24日改定規約',												// 契約書書式
			UnsoKyokasyoKubun__c = '自社取得',															// 一般貨物自動車運送許可書区分
			UnsoKyokasyoHikaeAri__c = false,															// 運送許可書控え有
			KeyakuTantoshaRef__c = '0037F000018mphf',													// 契約担当者名
			JisyaSaijoSyoyuJokyo__c = '有り',															// 自社斎場所有状況
			CyokuSoTaiouKa__c = '対応可能',																// 直葬対応可
			TaiouKanouPlan__c = '直葬; 火葬式プラン; 一日葬プラン; 家族葬プラン; 一般葬プラン',			// 対応可能プラン
			ShikiariNeageKosyoStatus__c = '完了(新手数料)',												// 式有値上交渉
			AreaTokureiAri__c = false,																	// エリア特例有
			SeikyushoHassoCycle__c = '月末',															// 請求書発送サイクル
			NyukinSimekiriJouken__c = '月末締め翌月20日',												// 入金締切条件
			SeikyushoSakuseijiFax__c = false,															// 請求書作成時Fax要
			TokkiJiko__c = '葬祭扶助案件は、翌々月20日入金締切日で請求（先方希望により）201908柴垣',	// 特記事項
			FaxSoshinsakiFukusuAri__c = false,															// Fax送信先複数有
			IsSoukyakujiFax__c = false																	// 送客時Fax要
		);
		Database.SaveResult lsrKeiyaku = Database.insert(sKeiyaku);
		
		TodoufuKen__c sTodoufuKen = new TodoufuKen__c(
			Name = '埼玉県',	// 都道府県
			PKey__c = '埼玉県',	// PKey
			KenCode__c = '11'	// 県コード
		);
		
		Database.SaveResult lsrTodoufuKen = Database.insert(sTodoufuKen);
		
		
		Shikugun__c sShikugun = new Shikugun__c(
			Name = '埼玉県越谷市',					// 市区郡名称
			TodoufuKenRef__c = lsrTodoufuKen.getId(),	// 都道府県
			AreaCode__c = '11222',					// エリアコード
			ShikugunMei__c = '越谷市',				// 市区郡名
			ShikugunMeiFurigana__c = 'こしがやし'	// 市区郡名(かな)
		);
		Database.SaveResult lsrShikugun = Database.insert(sShikugun);
		
		
		Saijo__c sSaijo = new Saijo__c(
		  Name = 'ティア越谷',									// 掲載斎場名
		  KeisaiSaijoMeiKana__c = 'てぃあこしがや',				// 掲載斎場名(かな)
		  PostalCode__c = '343-0024',							// 郵便番号
		  ShikugunRef__c = lsrShikugun.getId(),					// 市区郡
		  Street__c = '越ヶ谷１丁目5番5号',						// 町名・番地
		  HoyuShutaiSogishaJiinRef__c = lsracc.getId()		// 保有主体（葬儀社・寺院）
		);
		Database.SaveResult lsrSaijo = Database.insert(sSaijo);

		KeiriSokyakuTeishiBat__mdt ACSP = [SELECT 
												updateShokaiKa__c,
												updateSimpleHPKeisaiAri__c,
												updateKeiyakuJokyoSTOP__c,
												updateKeiyakuJokyoKaijo__c
											FROM KeiriSokyakuTeishiBat__mdt
											WHERE DeveloperName = 'KeiriSokyakuTeishiBat'
											Limit 1];
		
		Test.startTest();
		ID accid = lsracc.getId();
		Account acc5 = [SELECT
							Id,
							Name,
							RecordTypeId,
							KeiriSokyakuTeishiCount__c,
							KeiriSokyakuTeishiFlag__c
						FROM Account
						WHERE Id = :accid];
		MAP<ID,Account> MAPacc = new MAP<ID,Account>();
		MAPacc.put(acc5.id, acc5);
		Account acc2 = [SELECT
							Id,
							Name,
							RecordTypeId,
							KeiriSokyakuTeishiCount__c,
							KeiriSokyakuTeishiFlag__c
						FROM Account
						WHERE Id = :accid];
		acc2.KeiriSokyakuTeishiFlag__c = TRUE;
		List<Account> lacc = new List<Account>();
		lacc.add(acc2);
		new KeiriSokyakuTeishi().OnBeforeUpdate(lacc,MAPacc);
		update acc2;
		new KeiriSokyakuTeishi().OnAfterUpdate(lacc,MAPacc);

		Account acc4 = [SELECT
							Id,
							Name,
							KeiriSokyakuTeishiFlag__c
						FROM Account
						WHERE Id = :accid];		
		List<Account> listAcc = new List<Account>();
		listAcc.add(acc4);
		new KeiriSokyakuTeishi().UpdateVersionToBe(listAcc);
		KeiriSokyakuTeishiActivator TESTJOB = new KeiriSokyakuTeishiActivator();
		TESTJOB.scheduleNew();
		
		Saijo__c Saijo1 = [SELECT
								Id,
								Name,
								KeiriSokyakuTeishiFlag__c
							FROM Saijo__c
							WHERE Id = :lsrSaijo.getId()];
		Saijo1.KeiriSokyakuTeishiFlag__c = TRUE;
		update Saijo1;
		Saijo__c Saijo2 = [SELECT
								Id,
								Name,
								KeiriSokyakuTeishiFlag__c,
								ShokaiKa__c,
								SimpleHPKeisaiAri__c
							FROM Saijo__c
							WHERE Id = :lsrSaijo.getId()];
		Saijo2.ShokaiKa__c = ACSP.updateShokaiKa__c;
		Saijo2.SimpleHPKeisaiAri__c = ACSP.updateSimpleHPKeisaiAri__c;
		LIST<Saijo__c> SaijoL = new LIST<Saijo__c>();
		SaijoL.add(Saijo2);
		SaijoShokaiCheck.OnBeforeUpdate(SaijoL);
		Saijo__c Saijo3 = [SELECT
								Id,
								Name,
								KeiriSokyakuTeishiFlag__c,
								ShokaiKa__c,
								SimpleHPKeisaiAri__c
							FROM Saijo__c
							WHERE Id = :lsrSaijo.getId()];
		Saijo3.ShokaiKa__c = !ACSP.updateShokaiKa__c;
		Saijo3.SimpleHPKeisaiAri__c = ACSP.updateSimpleHPKeisaiAri__c;
		LIST<Saijo__c> SaijoL2 = new LIST<Saijo__c>();
		SaijoL2.add(Saijo3);
		SaijoShokaiCheck.OnBeforeUpdate(SaijoL2);
		
		Keiyaku__c sKeiyaku2 = [SELECT
								Id,
								RecordTypeId,
								Name,
								KeiriSokyakuTeishiFlag__c,
								KeiyakuJokyo__c
							FROM Keiyaku__c
							WHERE Id = :lsrKeiyaku.getId()];
		sKeiyaku2.KeiriSokyakuTeishiFlag__c = TRUE;
		sKeiyaku2.KeiyakuJokyo__c = ACSP.updateKeiyakuJokyoKaijo__c;
		List<Keiyaku__c> ListKeiyaku = new List<Keiyaku__c>();
		ListKeiyaku.add(sKeiyaku2);
		KeiriKeiyakuJokyoCheck.OnBeforeUpdate(ListKeiyaku);
		
		Test.stopTest();
	}
}