@isTest
public class Tes_OkyakusamaSeikyuMeisai {

    @testSetup
    static void initializeTestData() {
 
        // default の取引先を設定
        RecordType defualtAccountRT = new RecordTypeDao().selectRecordBySobjectTypeDeveloperName('Account', 'null');
		Account dacc = new Account();
		dacc.LastName = 'xxxdefualt';
		dacc.Phone = '088-0000-0001';
		dacc.MobilePhone__c = '888-0000-0001';
		dacc.recordTypeId = defualtAccountRT.Id;
		insert dacc;

        // カスタム設定のTriggerIsActive__cのデータを作成
		TriggerIsActive__c TriggerIsActive = new TriggerIsActive__c();
		TriggerIsActive.name = 'default';
		TriggerIsActive.isActive__c = true;
		insert TriggerIsActive;
		JizenWariPlan__c JizenWariPlan = new JizenWariPlan__c();
        JizenWariPlan.Code__c = 'Yoriso';
        insert JizenWariPlan;        

        // 取引先のデータ作成
		Account acc = new Account();
		acc.name = 'defualt';
		acc.Phone = '080-0000-0001';
		acc.MobilePhone__c = '080-0000-0001';
		insert acc;
        
        opportunity opp = new opportunity();
        opp.accountid = acc.id;
        opp.Name = 'test';
        opp.StageName = '商談開始';
        opp.CloseDate = system.today();
        opp.TaishoushaJokyo__c = '_';
        opp.recordtypeid = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo');
        insert opp;
    }

    /**
     * テスト観点：seikyuHohoCodeMap に指定した code が正しくセットされているかどうか
     **/
	static testMethod void testInitialProcessing(){
        
        String expected = '9';
        String actual = '';

        Opportunity opp = [SELECT Id, Name, StageName, CloseDate, TaishoushaJokyo__c FROM Opportunity WHERE Name = 'test'];
        OkyakusamaSeikyuMeisai__c okyakusamaSeikyuMeisai = new OkyakusamaSeikyuMeisai__c();
		okyakusamaSeikyuMeisai.OpportunityRef__c = opp.id;
        okyakusamaSeikyuMeisai.SeikyuHouhou__c = 'paydesign_cvs_den';
        insert okyakusamaSeikyuMeisai;

        List<OkyakusamaSeikyuMeisai__c> targetSeikyuMeisais = [SELECT
                                                                Id, SeikyuHohoCode__c
                                                                FROM OkyakusamaSeikyuMeisai__c
                                                                WHERE OpportunityRef__c = :opp.id];

        if(!targetSeikyuMeisais.isEmpty()){
            for(OkyakusamaSeikyuMeisai__c target : targetSeikyuMeisais){
                actual = target.SeikyuHohoCode__c;
            }
        }
        System.assertEquals(expected, actual);
	}

    /**
     * テスト観点：請求明細連番と請求番号に同じ値がセットされているかどうか
     **/
	static testMethod void testPutSeikyuBango(){

        String expected = '';
        String actual = '';

        Opportunity opp = [SELECT Id, Name, StageName, CloseDate, TaishoushaJokyo__c FROM Opportunity WHERE Name = 'test'];
        OkyakusamaSeikyuMeisai__c okyakusamaSeikyuMeisai = new OkyakusamaSeikyuMeisai__c();
		okyakusamaSeikyuMeisai.OpportunityRef__c = opp.id;
        okyakusamaSeikyuMeisai.SeikyuHouhou__c = 'paydesign_cvs_den';
        insert okyakusamaSeikyuMeisai;

        List<OkyakusamaSeikyuMeisai__c> targetSeikyuMeisais = [SELECT
                                                                Id, SeikyuBango__c, SeikyuMeisaiNo__c
                                                                FROM OkyakusamaSeikyuMeisai__c
                                                                WHERE OpportunityRef__c = :opp.id];

        if(!targetSeikyuMeisais.isEmpty()){
            for(OkyakusamaSeikyuMeisai__c target : targetSeikyuMeisais){
                expected = target.SeikyuBango__c;
                actual = target.SeikyuMeisaiNo__c;
            }
        }
        System.assertEquals(expected, actual);
	}

    /**
     * テスト観点：
     * 請求方法が「クレカ (オリコ)」のケース
     **/
	static testMethod void testSetShiharaiKanrenJohoOricoCredit(){

        String expected = '';
        String actual = '';

        Opportunity opp = [SELECT Id, Name, StageName, CloseDate, TaishoushaJokyo__c, SimpleYasugoRef__c FROM Opportunity WHERE Name = 'test'];
        OkyakusamaSeikyuMeisai__c okyakusamaSeikyuMeisai = new OkyakusamaSeikyuMeisai__c();
		okyakusamaSeikyuMeisai.OpportunityRef__c = opp.id;
        okyakusamaSeikyuMeisai.SeikyuHouhou__c = 'orico_credit';
        okyakusamaSeikyuMeisai.SeikyuKingaku__c = 100;
        okyakusamaSeikyuMeisai.Kessaibi__c = system.today();
        insert okyakusamaSeikyuMeisai;

        System.debug('opp.SimpleYasugoRef__c : ' + opp.SimpleYasugoRef__c);

        SimpleYasugo__c simpleYasugo = [SELECT
                                            Id,
                                            ReportShiharaihoho__c,
                                            ReportNyukingaku__c,
                                            ReportNyukinbi__c,
                                            ReportMaeukekin__c
                                            FROM SimpleYasugo__c
                                            WHERE Id = :opp.SimpleYasugoRef__c];

        System.debug('simpleYasugo.ReportShiharaihoho__c : ' + simpleYasugo.ReportShiharaihoho__c);
        System.debug('simpleYasugo.ReportNyukingaku__c : ' + simpleYasugo.ReportNyukingaku__c);
        System.debug('simpleYasugo.ReportNyukinbi__c : ' + simpleYasugo.ReportNyukinbi__c);
        System.debug('simpleYasugo.ReportMaeukekin__c : ' + simpleYasugo.ReportMaeukekin__c);

        System.assertEquals('クレカ (オリコ)', simpleYasugo.ReportShiharaihoho__c);
        System.assertEquals(100, simpleYasugo.ReportNyukingaku__c);
        System.assertEquals(system.today(), simpleYasugo.ReportNyukinbi__c);
        System.assertEquals(0, simpleYasugo.ReportMaeukekin__c);
	}

    /**
     * テスト観点：
     * 請求方法が「ローン (オリコ)」のケース
     **/
	static testMethod void testSetShiharaiKanrenJohoOricoLoan(){

        String expected = '';
        String actual = '';

        Opportunity opp = [SELECT Id, Name, StageName, CloseDate, TaishoushaJokyo__c, SimpleYasugoRef__c FROM Opportunity WHERE Name = 'test'];
        OkyakusamaSeikyuMeisai__c okyakusamaSeikyuMeisai = new OkyakusamaSeikyuMeisai__c();
		okyakusamaSeikyuMeisai.OpportunityRef__c = opp.id;
        okyakusamaSeikyuMeisai.SeikyuHouhou__c = 'orico_loan';
        okyakusamaSeikyuMeisai.SeikyuKingaku__c = 100;
        okyakusamaSeikyuMeisai.Kessaibi__c = system.today();
        insert okyakusamaSeikyuMeisai;

        System.debug('opp.SimpleYasugoRef__c : ' + opp.SimpleYasugoRef__c);

        SimpleYasugo__c simpleYasugo = [SELECT
                                            Id,
                                            ReportShiharaihoho__c,
                                            ReportNyukingaku__c,
                                            ReportNyukinbi__c,
                                            ReportMaeukekin__c
                                            FROM SimpleYasugo__c
                                            WHERE Id = :opp.SimpleYasugoRef__c];

        System.debug('simpleYasugo.ReportShiharaihoho__c : ' + simpleYasugo.ReportShiharaihoho__c);
        System.debug('simpleYasugo.ReportNyukingaku__c : ' + simpleYasugo.ReportNyukingaku__c);
        System.debug('simpleYasugo.ReportNyukinbi__c : ' + simpleYasugo.ReportNyukinbi__c);
        System.debug('simpleYasugo.ReportMaeukekin__c : ' + simpleYasugo.ReportMaeukekin__c);

        System.assertEquals('ローン (オリコ)', simpleYasugo.ReportShiharaihoho__c);
        System.assertEquals(100, simpleYasugo.ReportNyukingaku__c);
        System.assertEquals(system.today(), simpleYasugo.ReportNyukinbi__c);
        System.assertEquals(0, simpleYasugo.ReportMaeukekin__c);
	}

    /**
     * テスト観点：
     * 請求方法が「コンビニ (サガワ)」のケース
     **/
	static testMethod void testSetShiharaiKanrenJohoSagawaCvs(){

        String expected = '';
        String actual = '';

        Opportunity opp = [SELECT Id, Name, StageName, CloseDate, TaishoushaJokyo__c, SimpleYasugoRef__c FROM Opportunity WHERE Name = 'test'];
        OkyakusamaSeikyuMeisai__c okyakusamaSeikyuMeisai = new OkyakusamaSeikyuMeisai__c();
		okyakusamaSeikyuMeisai.OpportunityRef__c = opp.id;
        okyakusamaSeikyuMeisai.SeikyuHouhou__c = 'sagawa_cvs';
        okyakusamaSeikyuMeisai.SeikyuKingaku__c = 100;
        okyakusamaSeikyuMeisai.Kessaibi__c = system.today();
        insert okyakusamaSeikyuMeisai;

        System.debug('opp.SimpleYasugoRef__c : ' + opp.SimpleYasugoRef__c);

        SimpleYasugo__c simpleYasugo = [SELECT
                                            Id,
                                            ReportShiharaihoho__c,
                                            ReportNyukingaku__c,
                                            ReportNyukinbi__c,
                                            ReportMaeukekin__c
                                            FROM SimpleYasugo__c
                                            WHERE Id = :opp.SimpleYasugoRef__c];

        System.debug('simpleYasugo.ReportShiharaihoho__c : ' + simpleYasugo.ReportShiharaihoho__c);
        System.debug('simpleYasugo.ReportNyukingaku__c : ' + simpleYasugo.ReportNyukingaku__c);
        System.debug('simpleYasugo.ReportNyukinbi__c : ' + simpleYasugo.ReportNyukinbi__c);
        System.debug('simpleYasugo.ReportMaeukekin__c : ' + simpleYasugo.ReportMaeukekin__c);

        System.assertEquals('コンビニ (サガワ)', simpleYasugo.ReportShiharaihoho__c);
        System.assertEquals(100, simpleYasugo.ReportNyukingaku__c);
        System.assertEquals(system.today(), simpleYasugo.ReportNyukinbi__c);
        System.assertEquals(0, simpleYasugo.ReportMaeukekin__c);
	}

    /**
     * テスト観点：
     * 請求方法が「前受相殺」のケース
     **/
	static testMethod void testSetShiharaiKanrenJohoSousai(){

        String expected = '';
        String actual = '';

        Opportunity opp = [SELECT Id, Name, StageName, CloseDate, TaishoushaJokyo__c, SimpleYasugoRef__c FROM Opportunity WHERE Name = 'test'];
        OkyakusamaSeikyuMeisai__c okyakusamaSeikyuMeisai = new OkyakusamaSeikyuMeisai__c();
		okyakusamaSeikyuMeisai.OpportunityRef__c = opp.id;
        okyakusamaSeikyuMeisai.SeikyuHouhou__c = 'sousai';
        okyakusamaSeikyuMeisai.SeikyuKingaku__c = 100;
        okyakusamaSeikyuMeisai.Kessaibi__c = system.today();
        insert okyakusamaSeikyuMeisai;

        System.debug('opp.SimpleYasugoRef__c : ' + opp.SimpleYasugoRef__c);

        SimpleYasugo__c simpleYasugo = [SELECT
                                            Id,
                                            ReportShiharaihoho__c,
                                            ReportNyukingaku__c,
                                            ReportNyukinbi__c,
                                            ReportMaeukekin__c
                                            FROM SimpleYasugo__c
                                            WHERE Id = :opp.SimpleYasugoRef__c];

        System.debug('simpleYasugo.ReportShiharaihoho__c : ' + simpleYasugo.ReportShiharaihoho__c);
        System.debug('simpleYasugo.ReportNyukingaku__c : ' + simpleYasugo.ReportNyukingaku__c);
        System.debug('simpleYasugo.ReportNyukinbi__c : ' + simpleYasugo.ReportNyukinbi__c);
        System.debug('simpleYasugo.ReportMaeukekin__c : ' + simpleYasugo.ReportMaeukekin__c);

        System.assertEquals(null, simpleYasugo.ReportShiharaihoho__c);
        System.assertEquals(0, simpleYasugo.ReportNyukingaku__c);
        System.assertEquals(null, simpleYasugo.ReportNyukinbi__c);
        System.assertEquals(100, simpleYasugo.ReportMaeukekin__c);
	}

    /**
     * テスト観点：
     * 請求方法が「混合 (要確認)」のケース
     **/
	static testMethod void testSetShiharaiKanrenJohoKongo(){

        String expected = '';
        String actual = '';

        Opportunity opp = [SELECT Id, Name, StageName, CloseDate, TaishoushaJokyo__c, SimpleYasugoRef__c FROM Opportunity WHERE Name = 'test'];
        List<OkyakusamaSeikyuMeisai__c> insOkyakusamaSeikyuMeisaiList = new List<OkyakusamaSeikyuMeisai__c>();

        OkyakusamaSeikyuMeisai__c okyakusamaSeikyuMeisai1 = new OkyakusamaSeikyuMeisai__c();
		okyakusamaSeikyuMeisai1.OpportunityRef__c = opp.id;
        okyakusamaSeikyuMeisai1.SeikyuHouhou__c = 'orico_credit';
        okyakusamaSeikyuMeisai1.SeikyuKingaku__c = 100;
        okyakusamaSeikyuMeisai1.Kessaibi__c = system.today();
        // insert okyakusamaSeikyuMeisai1;
        insOkyakusamaSeikyuMeisaiList.add(okyakusamaSeikyuMeisai1);

        OkyakusamaSeikyuMeisai__c okyakusamaSeikyuMeisai2 = new OkyakusamaSeikyuMeisai__c();
		okyakusamaSeikyuMeisai2.OpportunityRef__c = opp.id;
        okyakusamaSeikyuMeisai2.SeikyuHouhou__c = 'orico_loan';
        okyakusamaSeikyuMeisai2.SeikyuKingaku__c = 100;
        okyakusamaSeikyuMeisai2.Kessaibi__c = system.today();
        // insert okyakusamaSeikyuMeisai2;
        insOkyakusamaSeikyuMeisaiList.add(okyakusamaSeikyuMeisai2);
        
        OkyakusamaSeikyuMeisai__c okyakusamaSeikyuMeisai3 = new OkyakusamaSeikyuMeisai__c();
		okyakusamaSeikyuMeisai3.OpportunityRef__c = opp.id;
        okyakusamaSeikyuMeisai3.SeikyuHouhou__c = 'sousai';
        okyakusamaSeikyuMeisai3.SeikyuKingaku__c = 100;
        okyakusamaSeikyuMeisai3.Kessaibi__c = system.today();
        // insert okyakusamaSeikyuMeisai3;
        insOkyakusamaSeikyuMeisaiList.add(okyakusamaSeikyuMeisai3);

        insert insOkyakusamaSeikyuMeisaiList;
        System.debug('opp.SimpleYasugoRef__c : ' + opp.SimpleYasugoRef__c);

        SimpleYasugo__c simpleYasugo = [SELECT
                                            Id,
                                            ReportShiharaihoho__c,
                                            ReportNyukingaku__c,
                                            ReportNyukinbi__c,
                                            ReportMaeukekin__c
                                            FROM SimpleYasugo__c
                                            WHERE Id = :opp.SimpleYasugoRef__c];

        System.debug('simpleYasugo.ReportShiharaihoho__c : ' + simpleYasugo.ReportShiharaihoho__c);
        System.debug('simpleYasugo.ReportNyukingaku__c : ' + simpleYasugo.ReportNyukingaku__c);
        System.debug('simpleYasugo.ReportNyukinbi__c : ' + simpleYasugo.ReportNyukinbi__c);
        System.debug('simpleYasugo.ReportMaeukekin__c : ' + simpleYasugo.ReportMaeukekin__c);

        System.assertEquals('混合 (要確認)', simpleYasugo.ReportShiharaihoho__c);
        System.assertEquals(200, simpleYasugo.ReportNyukingaku__c);
        System.assertEquals(system.today(), simpleYasugo.ReportNyukinbi__c);
        System.assertEquals(100, simpleYasugo.ReportMaeukekin__c);
	}

    /**
     * テスト観点：
     * お客様請求明細が作成時に決済日が入力された場合(レコードタイプが永代供養/ベスト仏壇の場合)
     **/
	static testMethod void testInsertSetKessaibi(){

        Opportunity opp = [SELECT Id, Name, StageName, CloseDate, TaishoushaJokyo__c FROM Opportunity WHERE Name = 'test'];
        Account acc = [SELECT Id FROM Account WHERE name = 'defualt'];
        //==============SimpleYasugo__c===============
        // SimpleYasugo__c simpleYasugo = new SimpleYasugo__c(TaishoshaRef__c = Acc2.Id,ZokugaraSodanshaNitottenoTaishosha__c='夫');
		// insert simpleYasugo;			
	    String oppSimpleYasugoRdId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo');
		Opportunity oppSimpleYasugo = new Opportunity(
			Name = 'テスト商談', AccountId = acc.Id, RecordTypeId = oppSimpleYasugoRdId,  
			StageName = 'フォロー',CloseDate = system.today(), TaishoushaJokyo__c = '_'
			);
		insert oppSimpleYasugo;
        
        //クロスセル提案をInsertする
        List<CrossSellingTeian__c> insCsTeianList = new List<CrossSellingTeian__c>();
        CrossSellingTeian__c csteianEitai = new CrossSellingTeian__c();
        csteianEitai.OpportunityRef__c = oppSimpleYasugo.Id;
        csteianEitai.TeianShohin__c = '永代供養';
        csteianEitai.TeianKekka__c = 'クロスセル希望あり';
        insCsTeianList.add(csteianEitai);

        CrossSellingTeian__c csteianIhai = new CrossSellingTeian__c();
        csteianIhai.OpportunityRef__c = oppSimpleYasugo.Id;
        csteianIhai.TeianShohin__c = '位牌';
        csteianIhai.TeianKekka__c = 'クロスセル希望あり';
        insCsTeianList.add(csteianIhai);
        insert insCsTeianList;
        //トリガーにより作成された商談を取得し、その商談のお客様請求明細の決済日を更新する
        CrossSellingTeian__c crossSellingTeianEitai = [
            SELECT
                Id
                // ,OpportunityRef__c
                ,CrossSellingSakiOpportunityRef__c
            FROM CrossSellingTeian__c
            WHERE Id =:csteianEitai.Id
        ];
        CrossSellingTeian__c crossSellingTeianIhai = [
            SELECT
                Id
                // ,OpportunityRef__c
                ,CrossSellingSakiOpportunityRef__c
            FROM CrossSellingTeian__c
            WHERE Id =:csteianIhai.Id
        ];
        //お客様請求明細の作成
        Test.startTest();
        List<OkyakusamaSeikyuMeisai__c> insOkyakusamaSeikyuMeisaiList = new List<OkyakusamaSeikyuMeisai__c>();
        // 永代供養
        OkyakusamaSeikyuMeisai__c okyakusamaSeikyuMeisai = new OkyakusamaSeikyuMeisai__c();
		okyakusamaSeikyuMeisai.OpportunityRef__c = crossSellingTeianEitai.CrossSellingSakiOpportunityRef__c;
        okyakusamaSeikyuMeisai.SeikyuHouhou__c = 'paydesign_cvs_den';
        okyakusamaSeikyuMeisai.Kessaibi__c = date.today();
        insOkyakusamaSeikyuMeisaiList.add(okyakusamaSeikyuMeisai);
        // 位牌
        OkyakusamaSeikyuMeisai__c okyakusamaSeikyuMeisaiIhai = new OkyakusamaSeikyuMeisai__c();
		okyakusamaSeikyuMeisaiIhai.OpportunityRef__c = crossSellingTeianIhai.CrossSellingSakiOpportunityRef__c;
        okyakusamaSeikyuMeisaiIhai.SeikyuHouhou__c = 'paydesign_cvs_den';
        okyakusamaSeikyuMeisaiIhai.Kessaibi__c = date.today();
        insOkyakusamaSeikyuMeisaiList.add(okyakusamaSeikyuMeisaiIhai);

        insert insOkyakusamaSeikyuMeisaiList;
        Test.stopTest();

        //商談が更新されていること
        // 永代供養
        Opportunity resultOpportunity = [
            SELECT
                Id
                ,KakuteibiSyodan__c
            FROM Opportunity
            WHERE Id =:crossSellingTeianEitai.CrossSellingSakiOpportunityRef__c
        ];
        System.assertEquals(datetime.newInstance(date.today().year(), date.today().month(), date.today().day()), resultOpportunity.KakuteibiSyodan__c);
        // 位牌
        Opportunity resultOpportunityIhai = [
            SELECT
                Id
                ,KakuteibiSyodan__c
            FROM Opportunity
            WHERE Id =:crossSellingTeianIhai.CrossSellingSakiOpportunityRef__c
        ];
        System.assertEquals(datetime.newInstance(date.today().year(), date.today().month(), date.today().day()), resultOpportunityIhai.KakuteibiSyodan__c);
        
        //クロスセル提案が更新されていること
        // 永代供養
        CrossSellingTeian__c resultCrossSellingTeianEitai = [
            SELECT
                Id
                ,Juchubi__c
            FROM CrossSellingTeian__c
            WHERE Id =:crossSellingTeianEitai.Id
        ];
        System.assertEquals(date.today(), resultCrossSellingTeianEitai.Juchubi__c);
        // 位牌
        CrossSellingTeian__c resultCrossSellingTeianIhai = [
            SELECT
                Id
                ,Juchubi__c
            FROM CrossSellingTeian__c
            WHERE Id =:crossSellingTeianIhai.Id
        ];
        System.assertEquals(date.today(), resultCrossSellingTeianIhai.Juchubi__c);
    }

}