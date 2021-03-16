@isTest
public class KeiriSokyakuTeishiBatT {

	private static void beginSetUp(){
		Utility_Common.isMimicExecAsDataIkouProfile = true;
	}

	private static void endSetUp(){
		Insert new TriggerIsActive__c( name='default', isActive__c=true );
		Insert new JizenWariPlan__c( Code__c='Yoriso' );
		Insert new Account(
			RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId(),
			FirstName = '_', LastName = '_'
		);
		Utility_Common.isMimicExecAsDataIkouProfile = false;
	}

	private static void TESTData( Boolean p_Acc_KeiriSokyakuTeishiFlag , String p_KeiyakuJokyo , Boolean p_IsYosinOverStop , Boolean p_KeiyakuSikkouKasiFlag ){
		Map<String, Account> theAcc = new Map<String, Account>{
			'theAcc1' => new Account(
				RecordTypeId                = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Sogisya').getRecordTypeId(),
				Name                        = '株式会社テスト',
				NameYagouFurigana__c        = 'カブシキテスト',
				NameShogo__c                = '株式会社テスト',
				NameShogoFurigana__c        = 'カブシキガイシャテスト',
				KeiriSokyakuTeishiFlag__c   = p_Acc_KeiriSokyakuTeishiFlag
			)
		};
		INSERT theAcc.values();

		Map<String, KeiriSokyakuTeishi__c> theKeiriSokyakuTeishi = new Map<String, KeiriSokyakuTeishi__c>{
			'theKeiriSokyakuTeishi1' => new KeiriSokyakuTeishi__c(
				AccIdBango__c                   = theAcc.get('theAcc1').Id, 
				AccName__c                      = '株式会社テスト',
				URL__c                          = URL.getOrgDomainUrl().toExternalForm() + '/' + theAcc.get('theAcc1').Id , 
				KeiriSokyakuTeishiFlag__c       = p_Acc_KeiriSokyakuTeishiFlag ,
				OppVersion__c                   = Long.valueOf(Datetime.now().format('yyyyMMddHHmmssSSS')),
				LastProcVersion__c              = 0
			)
		};
		INSERT theKeiriSokyakuTeishi.values();

		Map<String, Keiyaku__c> theKeiyaku = new Map<String, Keiyaku__c>{
			'theKeiyaku1' => new Keiyaku__c(
				RecordTypeId                = Schema.SObjectType.Keiyaku__c.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId(),
				Name                        = '株式会社テスト',
				Teikeisaki__c               = theAcc.get('theAcc1').Id,
				KeiyakuJokyo__c             = p_KeiyakuJokyo,
				KeiyakuMousikomiBi__c       = Date.valueOf('2018-12-20'),
				Keiyakukaishibi__c          = Date.valueOf('2018-12-25'),
				KeiriSokyakuTeishiFlag__c   = TRUE,
				IsYosinOverStop__c          = p_IsYosinOverStop
			)
		};
		INSERT theKeiyaku.values();
		
		if( p_KeiyakuSikkouKasiFlag ){
			Keiyaku__c aKeiyaku = [SELECT ID, KeiyakuSikkouKasibi__c, KeiyakuSikkoRiyu__c, KeiyakuSikkouKaijoBi__c FROM Keiyaku__c WHERE ID = :theKeiyaku.get('theKeiyaku1').Id].get(0);
			aKeiyaku.KeiyakuSikkouKasibi__c      = Date.valueOf('2018-12-28');
			aKeiyaku.KeiyakuSikkoRiyu__c         = '株式会社テスト';
			aKeiyaku.KeiyakuSikkouKaijoBi__c     = Date.valueOf('2018-12-26');
			update aKeiyaku;
		}
		
		TodoufuKen__c sTodoufuKen = new TodoufuKen__c(
			Name       = '埼玉県',
			PKey__c    = '埼玉県',
			KenCode__c = '11'
		);
		
		Database.SaveResult lsrTodoufuKen = Database.insert(sTodoufuKen);
		
		
		Shikugun__c sShikugun = new Shikugun__c(
			Name                    = '埼玉県越谷市',
			TodoufuKenRef__c        = lsrTodoufuKen.getId(),
			AreaCode__c             = '11222',
			ShikugunMei__c          = '越谷市',
			ShikugunMeiFurigana__c  = 'こしがやし'
		);
		Database.SaveResult lsrShikugun = Database.insert(sShikugun);
		
		
		Saijo__c sSaijo = new Saijo__c(
			Name                          = '株式会社テスト',
			KeisaiSaijoMeiKana__c         = 'カブシキテスト',
			PostalCode__c                 = '343-0024',
			ShikugunRef__c                = lsrShikugun.getId(),
			Street__c                     = '越ヶ谷１丁目5番5号',
		 	HoyuShutaiSogishaJiinRef__c   = theAcc.get('theAcc1').Id,
			KeiriSokyakuTeishiFlag__c     = TRUE
		);
		Database.SaveResult lsrSaijo = Database.insert(sSaijo);

	}

	@isTest static void doTest1(){
		beginSetUp();
		Boolean m_Acc_KeiriSokyakuTeishiFlag = True;
		String m_KeiyakuJokyo = '契約中';
		Boolean m_IsYosinOverStop = False;
		Boolean m_KeiyakuSikkouKasiFlag = False;
		TESTData(m_Acc_KeiriSokyakuTeishiFlag,m_KeiyakuJokyo,m_IsYosinOverStop,m_KeiyakuSikkouKasiFlag);
		endSetUp();

		Test.startTest();
		KeiriSokyakuTeishiBat.Batstart();
		Test.stopTest();

	}

	@isTest static void doTest2(){
		beginSetUp();
		Boolean m_Acc_KeiriSokyakuTeishiFlag = False;
		String m_KeiyakuJokyo = '失効中';
		Boolean m_IsYosinOverStop = False;
		Boolean m_KeiyakuSikkouKasiFlag = False;
		TESTData(m_Acc_KeiriSokyakuTeishiFlag,m_KeiyakuJokyo,m_IsYosinOverStop,m_KeiyakuSikkouKasiFlag);
		endSetUp();

		Test.startTest();
		KeiriSokyakuTeishiBat.Batstart();
		Test.stopTest();

	}

	@isTest static void doTest3(){
		beginSetUp();
		Boolean m_Acc_KeiriSokyakuTeishiFlag = False;
		String m_KeiyakuJokyo = '失効中';
		Boolean m_IsYosinOverStop = True;
		Boolean m_KeiyakuSikkouKasiFlag = False;
		TESTData(m_Acc_KeiriSokyakuTeishiFlag,m_KeiyakuJokyo,m_IsYosinOverStop,m_KeiyakuSikkouKasiFlag);
		endSetUp();

		Test.startTest();
		KeiriSokyakuTeishiBat.Batstart();
		Test.stopTest();

	}

	@isTest static void doTest4(){
		beginSetUp();
		Boolean m_Acc_KeiriSokyakuTeishiFlag = False;
		String m_KeiyakuJokyo = '失効中';
		Boolean m_IsYosinOverStop = False;
		Boolean m_KeiyakuSikkouKasiFlag = True;
		TESTData(m_Acc_KeiriSokyakuTeishiFlag,m_KeiyakuJokyo,m_IsYosinOverStop,m_KeiyakuSikkouKasiFlag);
		endSetUp();

		Test.startTest();
		KeiriSokyakuTeishiBat.Batstart();
		Test.stopTest();

	}
}