@isTest
private class SogiMitsumoriNyuryokuFormT {

    static String DATA_KUBUN_2 = '2:割引プラン';
    static String DATA_KUBUN_3 = '3:クーポン';
        
    @testSetup
    static void initializeTestData() {

        RecordType defualtAccountRT = new RecordTypeDao().selectRecordBySobjectTypeDeveloperName('Account', 'null');
        Account dacc=new Account();
        dacc.LastName='xxxdefualt';
        dacc.Phone='088-0000-0001';
        dacc.MobilePhone__c='888-0000-0001';
        dacc.recordTypeId = defualtAccountRT.Id;
        insert dacc;
        
        JizenWariPlan__c JizenWariPlan=new JizenWariPlan__c();
        JizenWariPlan.Code__c='Yoriso';
        insert JizenWariPlan;

        //カスタム設定のTriggerIsActive__cのデータを作成
        TriggerIsActive__c TriggerIsActive=new TriggerIsActive__c();
        TriggerIsActive.name='default';
        TriggerIsActive.isActive__c=false;
        insert TriggerIsActive;

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

        String pMailAddress = 'thisIsTest@thisIsTest.com';
        TesterMails.f_instance = new TesterMails(new TesterMailEnts.TesterMailEntriesStub().addEntry(pMailAddress),
                                            new Environments.Env());


    }


    static testMethod void testCase(){

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

        //取引先の「お客様」データ作成
        Account taishosha = new Account(
            LastName ='TEST',
            FirstName ='お客様',
            PersonBirthdate = Date.newInstance(2020, 6, 1),
            SeinengappiWareki__c = '令和2年06月01日',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId()
        );
        Database.SaveResult lsrtaishosha = Database.insert(taishosha);

        //取引先の「お客様」データ作成
        Account moshu = new Account(
            LastName ='TEST',
            FirstName ='お客様',
            PersonBirthdate = Date.newInstance(2020, 6, 1),
            SeinengappiWareki__c = '令和2年06月01日',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId()
        );
        Database.SaveResult lsrmoshu = Database.insert(moshu);

        //標準価格表取得
        Id lsrstandardPricebook = Test.getStandardPricebookId();

        k_Service__c MainSsobj = new k_Service__c(
            Name = 'シンプルなお葬式',// サービス名
            ID__c = '1'             // ID
        );
        Database.SaveResult MainService = Database.insert(MainSsobj);

        opportunity opp = new opportunity();
        opp = beginSetUp(lsracc.getId(),lsrtaishosha.getId(),lsrmoshu.getId(),lsrstandardPricebook,MainService);
        
        beginOldPlanSetUp(opp,lsrstandardPricebook,MainService);


        Map<String, Ken_all__c> the_Ken_all = new Map<String, Ken_all__c>{
            '住所-1' => new Ken_all__c(
                post_code__c = '1000001',
                todofuken__c = '東京都',
                shikugun__c = '千代田区',
                tyoumei__c = '千代田',
                AreaCode__c = '13101'
            ),
            '住所-2' => new Ken_all__c(
                post_code__c = '1000012',
                todofuken__c = '東京都',
                shikugun__c = '千代田区',
                tyoumei__c = '日比谷公園',
                AreaCode__c = '13101'
            )
        };
        Insert the_Ken_all.values();

        List<Id> fixedSearchResults = new List<Id>();
        fixedSearchResults.add(the_Ken_all.get('住所-1').Id);
        fixedSearchResults.add(the_Ken_all.get('住所-2').Id);
        Test.setFixedSearchResults(fixedSearchResults);

        TriggerIsActive__c TriggerIsActive= [select Id from TriggerIsActive__c where name = 'default'];
        TriggerIsActive.isActive__c=true;
        update TriggerIsActive;

        System.test.startTest();  
        
        ApexPages.StandardController stdOpp = new ApexPages.StandardController(opp);

        SogiMitsumoriNyuryokuFormCtl smnfCtl = new SogiMitsumoriNyuryokuFormCtl(stdOpp);
        smnfCtl.init();
        System.assertEquals(smnfCtl.nengoPickList.isEmpty(), false);
        System.assertEquals(smnfCtl.pahseWrap.phaseOptions.isEmpty(), false);
        System.assertEquals(smnfCtl.pahseWrap.subPhaseOptions.isEmpty(), false);
        smnfCtl.sodanshaWrap.setSeinengappiSeirekiNenTsukiHi();
        smnfCtl.sodanshaWrap.setBotsunengappiWarekiNenTsukiHi();
        smnfCtl.sodanshaWrap.setSeinengappiWarekiNenTsukiHi();
        smnfCtl.sodanshaWrap.setBotsunengappiSeirekiNenTsukiHi();
        smnfCtl.taishoshaWrap.setSeinengappiSeirekiNenTsukiHi();
        smnfCtl.taishoshaWrap.setSeinengappiWarekiNenTsukiHi();
        smnfCtl.taishoshaWrap.setBotsunengappiSeirekiNenTsukiHi();
        smnfCtl.taishoshaWrap.setBotsunengappiWarekiNenTsukiHi();
        smnfCtl.moshuWrap.setSeinengappiSeirekiNenTsukiHi();
        smnfCtl.moshuWrap.setSeinengappiWarekiNenTsukiHi();
        list<Product2> PlanShohin = new list<Product2>();
        PlanShohin = SogiMitsumoriNyuryokuFormCtl.rmtActGetPlanShohin('【19.12】よりそうのお葬式 火葬式 無宗教プラン');
        ApexPages.currentPage().getParameters().put('ojbAddIndex', '0');
        smnfCtl.addStandardItem();
        ApexPages.currentPage().getParameters().put('ojbDelIndex', '1');
        smnfCtl.delStandardItem();
        ApexPages.currentPage().getParameters().put('planItemBango', 'SBG-0003002');
        smnfCtl.changePlanItem();
        ApexPages.currentPage().getParameters().put('planItemBango', 'SBG-0003002');
        smnfCtl.changePlanItem();
        SogiMitsumoriNyuryokuFormCtl.OptionItemWrap oiw = smnfCtl.sogiItemWrap.optionItemWraps.get(0);
        oiw.optionItemName = '料理';
        oiw.quantityCustom = 1;
        oiw.unitPriceCustom = 1;
        List<SogiMitsumoriNyuryokuFormCtl.Addres> ListAddres = new List<SogiMitsumoriNyuryokuFormCtl.Addres>();
        ListAddres = SogiMitsumoriNyuryokuFormCtl.searchAddress('東京');
        smnfCtl.doSave();

        System.test.stopTest();
    }

    static testMethod void testCase2(){

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

        //標準価格表取得
        Id lsrstandardPricebook = Test.getStandardPricebookId();

        k_Service__c MainSsobj = new k_Service__c(
            Name = 'シンプルなお葬式',// サービス名
            ID__c = '1'             // ID
        );
        Database.SaveResult MainService = Database.insert(MainSsobj);

        opportunity opp = new opportunity();
        opp = beginSetUp(lsracc.getId(),lsracc.getId(),lsracc.getId(),lsrstandardPricebook,MainService);
        
        beginPlanSetUp(opp,lsrstandardPricebook,MainService);

        TriggerIsActive__c TriggerIsActive= [select Id from TriggerIsActive__c where name = 'default'];
        TriggerIsActive.isActive__c=true;
        update TriggerIsActive;

        System.test.startTest();  
        
        ApexPages.StandardController stdOpp = new ApexPages.StandardController(opp);

        SogiMitsumoriNyuryokuFormCtl smnfCtl = new SogiMitsumoriNyuryokuFormCtl(stdOpp);
        smnfCtl.init();
        System.assertEquals(smnfCtl.nengoPickList.isEmpty(), false);
        System.assertEquals(smnfCtl.pahseWrap.phaseOptions.isEmpty(), false);
        System.assertEquals(smnfCtl.pahseWrap.subPhaseOptions.isEmpty(), false);
        smnfCtl.sodanshaWrap.setSeinengappiSeirekiNenTsukiHi();
        smnfCtl.sodanshaWrap.setBotsunengappiWarekiNenTsukiHi();
        smnfCtl.sodanshaWrap.setSeinengappiWarekiNenTsukiHi();
        smnfCtl.sodanshaWrap.setBotsunengappiSeirekiNenTsukiHi();
        smnfCtl.taishoshaWrap.setSeinengappiSeirekiNenTsukiHi();
        smnfCtl.taishoshaWrap.setSeinengappiWarekiNenTsukiHi();
        smnfCtl.taishoshaWrap.setBotsunengappiSeirekiNenTsukiHi();
        smnfCtl.taishoshaWrap.setBotsunengappiWarekiNenTsukiHi();
        smnfCtl.moshuWrap.setSeinengappiSeirekiNenTsukiHi();
        smnfCtl.moshuWrap.setSeinengappiWarekiNenTsukiHi();
        list<Product2> PlanShohin = new list<Product2>();
        PlanShohin = SogiMitsumoriNyuryokuFormCtl.rmtActGetPlanShohin('【20.11】よりそう家族葬 一日プラン');
        ApexPages.currentPage().getParameters().put('ojbAddIndex', '0');
        smnfCtl.addStandardItem();
        smnfCtl.addYorisoItem();
        ApexPages.currentPage().getParameters().put('ojbDelIndex', '1');
        smnfCtl.delStandardItem();
        smnfCtl.delYorisoItem();
        ApexPages.currentPage().getParameters().put('planItemBango', 'SBG-0005001');
        smnfCtl.changePlanItem();
        SogiMitsumoriNyuryokuFormCtl.OptionItemWrap oiw = smnfCtl.sogiItemWrap.optionItemWraps.get(0);
        oiw.optionItemName = '料理';
        oiw.quantityCustom = 1;
        oiw.unitPriceCustom = 1;
        SogiMitsumoriNyuryokuFormCtl.YorisoOptionItemWrap WYorisoOption = smnfCtl.yorisoItemWrap.yorisoOptionItemWraps.get(0);
        WYorisoOption.optionItemName  = 'SBG-0005407';
        WYorisoOption.unitPriceCustom = 1;
        WYorisoOption.quantityCustom = 1;
        smnfCtl.doSave();

        System.test.stopTest();
    }

    static testMethod void testCase3(){

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

        //標準価格表取得
        Id lsrstandardPricebook = Test.getStandardPricebookId();

        k_Service__c MainSsobj = new k_Service__c(
            Name = 'シンプルなお葬式',// サービス名
            ID__c = '1'             // ID
        );
        Database.SaveResult MainService = Database.insert(MainSsobj);

        opportunity opp = new opportunity();
        opp = beginSetUp(lsracc.getId(),lsracc.getId(),lsracc.getId(),lsrstandardPricebook,MainService);
        
        beginPlanSetUp(opp,lsrstandardPricebook,MainService);

        TriggerIsActive__c TriggerIsActive= [select Id from TriggerIsActive__c where name = 'default'];
        TriggerIsActive.isActive__c=true;
        update TriggerIsActive;

        System.test.startTest();  
        
        ApexPages.StandardController stdOpp = new ApexPages.StandardController(opp);

        SogiMitsumoriNyuryokuFormCtl smnfCtl = new SogiMitsumoriNyuryokuFormCtl(stdOpp);
        smnfCtl.init();
        System.assertEquals(smnfCtl.nengoPickList.isEmpty(), false);
        System.assertEquals(smnfCtl.pahseWrap.phaseOptions.isEmpty(), false);
        System.assertEquals(smnfCtl.pahseWrap.subPhaseOptions.isEmpty(), false);
        smnfCtl.sodanshaWrap.setSeinengappiSeirekiNenTsukiHi();
        smnfCtl.sodanshaWrap.setBotsunengappiWarekiNenTsukiHi();
        smnfCtl.sodanshaWrap.setSeinengappiWarekiNenTsukiHi();
        smnfCtl.sodanshaWrap.setBotsunengappiSeirekiNenTsukiHi();
        smnfCtl.taishoshaWrap.setSeinengappiSeirekiNenTsukiHi();
        smnfCtl.taishoshaWrap.setSeinengappiWarekiNenTsukiHi();
        smnfCtl.taishoshaWrap.setBotsunengappiSeirekiNenTsukiHi();
        smnfCtl.taishoshaWrap.setBotsunengappiWarekiNenTsukiHi();
        smnfCtl.moshuWrap.setSeinengappiSeirekiNenTsukiHi();
        smnfCtl.moshuWrap.setSeinengappiWarekiNenTsukiHi();
        list<Product2> PlanShohin = new list<Product2>();
        PlanShohin = SogiMitsumoriNyuryokuFormCtl.rmtActGetPlanShohin('【20.11】よりそう家族葬 一日プラン');
        ApexPages.currentPage().getParameters().put('ojbAddIndex', '0');
        smnfCtl.addStandardItem();
        smnfCtl.addYorisoItem();
        ApexPages.currentPage().getParameters().put('ojbDelIndex', '1');
        smnfCtl.delStandardItem();
        smnfCtl.delYorisoItem();
        ApexPages.currentPage().getParameters().put('planItemBango', 'SBG-0005001');
        smnfCtl.changePlanItem();
        SogiMitsumoriNyuryokuFormCtl.OptionItemWrap oiw = smnfCtl.sogiItemWrap.optionItemWraps.get(0);
        oiw.optionItemName = '湯かん';
        oiw.quantityCustom = 1;
        oiw.unitPriceCustom = 1;
        SogiMitsumoriNyuryokuFormCtl.YorisoOptionItemWrap WYorisoOption = smnfCtl.yorisoItemWrap.yorisoOptionItemWraps.get(0);
        WYorisoOption.optionItemName  = 'SBG-0005407';
        WYorisoOption.unitPriceCustom = 1;
        WYorisoOption.quantityCustom = 1;
        ApexPages.currentPage().getParameters().put('ojbIndex', '1');
        smnfCtl.setRyokinhyoYorisoOption();
        smnfCtl.doSave();

        System.test.stopTest();
    }

    private static opportunity beginSetUp(String accid, String taishoshaid,String moshuid,Id lsrstandardPricebook,Database.SaveResult MainService){
    

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

        //取引先の「葬儀社」データ作成
        Account acc2 = new Account(
            Name ='システム動作確認用',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Sogisya').getRecordTypeId(),
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

		TesuryoPlan__c objTesuryoPlan = new TesuryoPlan__c(
			Name = '【19.12】よりそうのお葬式 標準手数料プラン',
			ServiceRef__c = MainService.getId(),
			KobetsuPlanFlag__c = false,
			TesuryoNebikiSetteiKa__c = true,
			CoreTesuryoPlanId__c = 11,
			isKyuTesuryoTaio__c = false,
			SearchTag__c = '@@'
		);
		Database.SaveResult DS_TesuryoPlan = Database.insert(objTesuryoPlan);

		TesuryoTekiyo__c objTesuryoTekiyo = new TesuryoTekiyo__c(
			TekiyoKaishiBi__c = Date.valueOf('2019-12-26'),
			KeiyakuRef__c = lsrKeiyaku.getId(),
			ShoninStatus__c = '承認済',
			TesuryoPlanRef__c = DS_TesuryoPlan.getId(),
			UrnOptionTesuryoFlg__c = true,
			YorisoOptionFlowersTesuryoFlg__c = true,
			RyoriTesuryoAri__c = true,
			HenreihinTesuryoAri__c = true,
			OptionTesuryoAri__c = true,
			CardLoanTesuryoAri__c = true,
			AtobaraiTesuryoAri__c = true
		);
		Database.SaveResult DS_TesuryoTekiyo = Database.insert(objTesuryoTekiyo);


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

        //取引商談のデータ作成
        opportunity torihikiopp = new opportunity(
            AccountId = accid,
            RecordTypeId = Schema.getGlobalDescribe().get('Opportunity').getDescribe().getRecordTypeInfosByDeveloperName().get('TorihikiShodan').getRecordTypeId(),
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
        
        //商談のデータ作成
        opportunity opp1 = new opportunity(
            AccountId = accid,
            RecordTypeId = Schema.getGlobalDescribe().get('Opportunity').getDescribe().getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId(),
            Pricebook2Id = lsrstandardPricebook,
            TorihikiShodanRef__c = lsrtorihikiopp.getId(),
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
        if(string.isNotBlank(taishoshaid) ){
            opp1.TaishosyaRef__c = taishoshaid;
        }

        Database.SaveResult lsropp = Database.insert(opp1);
        
        //シンプル安豪のデータ更新
        opportunity opp2 = [SELECT Id , SimpleYasugoRef__c FROM Opportunity WHERE Id = :lsropp.getId() limit 1];

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
            MonkArrangements__c ='未確認',
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
            TaiouKanouRiyu__c ='対応可能（斎場優先）',
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
            ShiryoSofuJokyo__c ='未送付',
            SimpleYasugoKeiyakuRef__c = lsrKeiyaku.getId(),
            SogiPlanToSogiPlanGaKotonaru__c = FALSE,
            SokyakugoPlanHenkoUmu__c = FALSE,
            SougisyaKaisyuAmount__c = 0,
            TesuryoShubetsu__c ='規定通り',
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
            PlanNaiyo__c ='一日葬 151,800円',
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
            KeisatsuAnkenKenanryo__c = FALSE,
            TsuyaDateTime_Inp__c = Datetime.now(),
            KokubetsuDateTime_Inp__c = Datetime.now(),
            KasoDateTime_Inp__c = Datetime.now(),
            MitsumorijuryoDay__c = Date.today(),
            SoryoTehaiIraishoJuryobi__c = Date.today()
        );
        
        if(string.isNotBlank(taishoshaid) ){
            SimpleYasugo.TaishoshaRef__c = taishoshaid;
        }
        if(string.isNotBlank(moshuid) ){
            SimpleYasugo.MoshuRef__c = moshuid;
        }

        update SimpleYasugo;

        // 商談クローズするために「請求方法」「請求金額」「決済日」を設定
        OkyakusamaSeikyuMeisai__c oOkyakusamaSeikyuMeisai = new OkyakusamaSeikyuMeisai__c(
            RecordTypeId = Schema.getGlobalDescribe().get('OkyakusamaSeikyuMeisai__c').getDescribe().getRecordTypeInfosByDeveloperName().get('KobetsuSeikyu').getRecordTypeId(),
            OpportunityRef__c = opp2.Id,
            ServiceSyubetsu__c = 'シンプル安豪',
            SeikyuHouhou__c = 'パートナー回収',
            SeikyuKingaku__c = 151800,
            Kessaibi__c = Date.today(),
            SeikyuHohoCode__c = '1'
        );
        Database.SaveResult lsroOkyakusamaSeikyuMeisai = Database.insert(oOkyakusamaSeikyuMeisai);

        return opp2;

    }

    private static void beginOldPlanSetUp(opportunity opp2,Id lsrstandardPricebook,Database.SaveResult MainService){
    
        k_ShohinCategory__c MainCsobj = new k_ShohinCategory__c(
            Name = '火葬式',    // 商品カテゴリ名
            ID__c = 'kasou' // ID
        );
        Database.SaveResult MainCategory = Database.insert(MainCsobj);

		k_ShohinCategory__c MainCIchinichisobj = new k_ShohinCategory__c(
			Name = '一日葬',       // 商品カテゴリ名
			 ID__c = 'ichinichi'  // ID
		);
        Database.SaveResult MainCategoryIchinichi = Database.insert(MainCIchinichisobj);

		k_ShohinCategory__c objYoriso = new k_ShohinCategory__c(
			Name = 'よりそうオプション',
			ID__c = 'yoriso-option'
		);
		Database.SaveResult DS_objYoriso = Database.insert(objYoriso);

        k_ShohinCategory__c OptionShohin = new k_ShohinCategory__c(
            Name = '葬儀オプション',    // 商品カテゴリ名
            ID__c = 'sougiOption' // ID
        );
        Database.SaveResult OptionCategory = Database.insert(OptionShohin);
        
        k_ShohinSyubetsu__c MainShohin = new k_ShohinSyubetsu__c(
            Name = '本体（委託）',                    // 商品種別名
            ID__c = '1',                                // ID
            KeijouSyubetsu__c = 'グロス'   // 計上種別
        );
        Database.SaveResult MainSyubetsu = Database.insert(MainShohin);

        k_ShohinSyubetsu__c OptionShohinSyubetsu = new k_ShohinSyubetsu__c(
            Name = 'オプション（委託）',                    // 商品種別名
            ID__c = '3',                                // ID
            KeijouSyubetsu__c = 'グロス'   // 計上種別
        );
        Database.SaveResult OptionSyubetsu = Database.insert(OptionShohinSyubetsu);
        
        k_ShohinCategory__c waribikiCsobj = new k_ShohinCategory__c(
            Name = '割引',             // 商品カテゴリ名
            ID__c = 'waribiki'  // ID
        );
        Database.SaveResult waribikiCategory = Database.insert(waribikiCsobj);
        
        k_ShohinSyubetsu__c WAribikiShohin = new k_ShohinSyubetsu__c(
            Name = '割引等',                       // 商品種別名
            ID__c = '6'                          // ID
        );
        Database.SaveResult waribikiSyubetsu= Database.insert(WAribikiShohin);
        
        k_WaribikiPlan__c WaribikiPsobj = new k_WaribikiPlan__c(
            Name = '事前割メンバー (30日未満)',// 割引プラン名
            ID__c = '8'                          // ID
        );
        Database.SaveResult WaribikiPlan= Database.insert(WaribikiPsobj);

        k_Coupon__c Couponsobj = new k_Coupon__c(
            Name = '【19.12】よりそうのお葬式 オファリング 5,000円値引き',// クーポン名
            ID__c = '22'                                                             // ID
        );
        Database.SaveResult Coupon = Database.insert(Couponsobj);

        Product2 MAINsobj = new Product2(
            ShohinBango__c = 'SBG-0003002',                              // 商品番号
            IsActive = true,                                                                    // 有効
            Name = '【19.12】よりそうのお葬式 火葬式 無宗教プラン',                            // 商品名
            NameForCustomer__c = 'よりそうのお葬式 火葬式 無宗教プラン',          // お客様向け商品名
            ShohinKamoku__c = '通常',                                                  // 商品科目
            SireKingakuKeisanHousiki__c = '設定金額',                        // 仕入金額計算方式
            SireKingaku__c = 162800,                                                    // 仕入金額
            TesuryoKingakuKeisanHoushiki__c = '計算しない',              // 手数料金額計算方式
            TesuryoKingaku__c = 0,                                                      // 手数料金額
            TesuryoCyoseiKingakuKeisanHoushiki__c = '計算しない',    // 手数料調整金額計算方式
            HanbaiKaishiBi__c = Date.valueOf('2020-11-01'),  // 販売開始日
            HanbaiSyuryoBi__c = Date.valueOf('2100-12-31'),  // 販売終了日
            DataKubun__c = '1:通常商品',                                                    // データ区分
            k_ServiceRef__c = MainService.getId(),                          // k_サービス
            k_ShohinCategoryRef__c = MainCategory.getId(),           // k_商品カテゴリ
            k_ShohinSyubetsuRef__c = MainSyubetsu.getId(),           // k_商品種別
            BunruiKensakuTag__c = '@@SCU',                                      // 分類検索タグ
            IsKingakuHenkouFuka__c = false,                                  // 金額変更不可
            HinmokuBunrui__c = '本体',                                                    // 品目分類
            SougiPlan__c = true                                                         // 葬儀プラン
        );
        Database.SaveResult MainProduct = Database.insert(MAINsobj);

        //価格表エントリオブジェクトに価格エントリ番号「StandardSBG-0003002」のデータを作成
        PricebookEntry sPEntry = new PricebookEntry(
            Pricebook2Id = lsrstandardPricebook,
            Product2Id = MainProduct.getId(),
            UnitPrice = 162800,
            UseStandardPrice = FALSE,
            IsActive = true,
            KakakuEntryBango__c = 'StandardSBG-0003002'
        );
        Database.SaveResult lsrstandardPricebookEntry = Database.insert(sPEntry);

        Product2 OPTIONsobj = new Product2(
            ShohinBango__c = 'SBG-0003018',                              // 商品番号
            IsActive = true,                                                                    // 有効
            Name = '【19.12】よりそうのお葬式 オプション 料理',                            // 商品名
            NameForCustomer__c = 'よりそうのお葬式 オプション 料理',          // お客様向け商品名
            ShohinKamoku__c = '通常',                                                  // 商品科目
            SireKingakuKeisanHousiki__c = '販売金額',                        // 仕入金額計算方式
            SireKingaku__c = 0,                                                    // 仕入金額
            TesuryoKingakuKeisanHoushiki__c = '計算しない',              // 手数料金額計算方式
            TesuryoKingaku__c = 0,                                                      // 手数料金額
            TesuryoCyoseiKingakuKeisanHoushiki__c = '計算しない',    // 手数料調整金額計算方式
            HanbaiKaishiBi__c = Date.valueOf('2020-11-01'),  // 販売開始日
            HanbaiSyuryoBi__c = Date.valueOf('2100-12-31'),  // 販売終了日
            DataKubun__c = '1:通常商品',                                                    // データ区分
            k_ServiceRef__c = MainService.getId(),                          // k_サービス
            k_ShohinCategoryRef__c = OptionCategory.getId(),           // k_商品カテゴリ
            k_ShohinSyubetsuRef__c = OptionSyubetsu.getId(),           // k_商品種別
            BunruiKensakuTag__c = '@@SCU',                                      // 分類検索タグ
            IsKingakuHenkouFuka__c = false,                                  // 金額変更不可
            HinmokuBunrui__c = '料理',                                                    // 品目分類
            SougiPlan__c = false                                                         // 葬儀プラン
        );
        Database.SaveResult OptionProduct = Database.insert(OPTIONsobj);

        //価格表エントリオブジェクトに価格エントリ番号「OptionSBG-0003018」のデータを作成
        PricebookEntry oPEntry = new PricebookEntry(
            Pricebook2Id = lsrstandardPricebook,
            Product2Id = OptionProduct.getId(),
            UnitPrice = 0,
            UseStandardPrice = FALSE,
            IsActive = true,
            KakakuEntryBango__c = 'OptionSBG-0003018'
        );
        Database.SaveResult lsrstandardPricebookEntry2 = Database.insert(oPEntry);

        Product2 WARIBIKIsobj = new Product2(
            ShohinBango__c = 'SBG-0003501',                                              // 商品番号
            IsActive = true,                                                                                    // 有効
            Name = '【19.12】よりそうのお葬式 事前割メンバー割引 (火葬式) (30日未満)',                // 商品名
            NameForCustomer__c = 'よりそうのお葬式 事前割メンバー割引 (火葬式) (30日未満)',    // お客様向け商品名
            ShohinKamoku__c = '通常',                                                                  // 商品科目
            SireKingakuKeisanHousiki__c = '設定金額',                                        // 仕入金額計算方式
            SireKingaku__c = -5500,                                                                     // 仕入金額
            TesuryoKingakuKeisanHoushiki__c = '計算しない',                              // 手数料金額計算方式
            TesuryoKingaku__c = 0,                                                                      // 手数料金額
            TesuryoCyoseiKingakuKeisanHoushiki__c = '計算しない',                    // 手数料調整金額計算方式
            HanbaiKaishiBi__c = Date.valueOf('2020-11-01'),                  // 販売開始日
            HanbaiSyuryoBi__c = Date.valueOf('2100-12-31'),                  // 販売終了日
            DataKubun__c = DATA_KUBUN_2,                                                                 // データ区分
            k_ServiceRef__c = MainService.getId(),                                          // k_サービス
            k_ShohinCategoryRef__c = waribikiCategory.getId(),                           // k_商品カテゴリ
            k_ShohinSyubetsuRef__c = waribikiSyubetsu.getId(),                           // k_商品種別
            k_WaribikiPlan__c = WaribikiPlan.getId(),                                       // k_割引プラン
            BunruiKensakuTag__c = '@@SCW',                                                      // 分類検索タグ
            IsKingakuHenkouFuka__c = false,                                                  // 金額変更不可
            SougiPlan__c = false                                                                         // 葬儀プラン
        );
        Database.SaveResult WAP = Database.insert(WARIBIKIsobj);
        
        //価格表エントリオブジェクトに価格エントリ番号「StandardSBG-0003501」のデータを作成
        PricebookEntry sPEntry2 = new PricebookEntry(
            Pricebook2Id = lsrstandardPricebook,
            Product2Id = WAP.getId(),
            UnitPrice = -5500,
            UseStandardPrice = FALSE,
            IsActive = true,
            KakakuEntryBango__c = 'StandardSBG-0003501'
        );
        Database.SaveResult lsrstandardPricebookEntry3 = Database.insert(sPEntry2);
        
        Product2 WARIBIKISYVsobj = new Product2(
            ShohinBango__c = 'SBG-0003527',                              // 商品番号
            IsActive = true,                                                                    // 有効
            Name = '【19.12】よりそうのお葬式 式後アンケート割引',                          // 商品名
            NameForCustomer__c = 'よりそうのお葬式 式後アンケート割引',              // お客様向け商品名
            ShohinKamoku__c = '通常',                                                  // 商品科目
            SireKingakuKeisanHousiki__c = '計算しない',                      // 仕入金額計算方式
            SireKingaku__c = -5500,                                                     // 仕入金額
            TesuryoKingakuKeisanHoushiki__c = '計算しない',              // 手数料金額計算方式
            TesuryoKingaku__c = 0,                                                      // 手数料金額
            TesuryoCyoseiKingakuKeisanHoushiki__c = '計算しない',    // 手数料調整金額計算方式
            HanbaiKaishiBi__c = Date.valueOf('2020-11-01'),  // 販売開始日
            HanbaiSyuryoBi__c = Date.valueOf('2100-12-31'),  // 販売終了日
            DataKubun__c = DATA_KUBUN_2,                                                 // データ区分
            k_ServiceRef__c = MainService.getId(),                          // k_サービス
            k_ShohinCategoryRef__c = waribikiCategory.getId(),           // k_商品カテゴリ
            k_ShohinSyubetsuRef__c = waribikiSyubetsu.getId(),           // k_商品種別
            BunruiKensakuTag__c = '@@',                                          // 分類検索タグ
            IsKingakuHenkouFuka__c = false,                                  // 金額変更不可
            SougiPlan__c = false                                                         // 葬儀プラン
        );
        Database.SaveResult WASP = Database.insert(WARIBIKISYVsobj);
        
        //価格表エントリオブジェクトに価格エントリ番号「StandardSBG-0003527」のデータを作成
        PricebookEntry sPEntry3 = new PricebookEntry(
            Pricebook2Id = lsrstandardPricebook,
            Product2Id = WASP.getId(),
            UnitPrice = -5500,
            UseStandardPrice = FALSE,
            IsActive = true,
            KakakuEntryBango__c = 'StandardSBG-0003527'
        );
        Database.SaveResult lsrstandardPricebookEntry4 = Database.insert(sPEntry3);

        Product2 Kusobj = new Product2(
            ShohinBango__c = 'SBG-0003531',                              // 商品番号
            IsActive = true,                                                                    // 有効
            Name = '【19.12】よりそうのお葬式 オファリング 5,000円値引き',              // 商品名
            NameForCustomer__c = 'よりそう負担特別割引',                              // お客様向け商品名
            ShohinKamoku__c = '通常',                                                  // 商品科目
            SireKingakuKeisanHousiki__c = '計算しない',                      // 仕入金額計算方式
            SireKingaku__c = 5500,                                                      // 仕入金額
            TesuryoKingakuKeisanHoushiki__c = '計算しない',              // 手数料金額計算方式
            TesuryoKingaku__c = 0,                                                      // 手数料金額
            TesuryoCyoseiKingakuKeisanHoushiki__c = '計算しない',    // 手数料調整金額計算方式
            HanbaiKaishiBi__c = Date.valueOf('2020-11-01'),  // 販売開始日
            HanbaiSyuryoBi__c = Date.valueOf('2100-12-31'),  // 販売終了日
            DataKubun__c = DATA_KUBUN_3,                                                    // データ区分
            k_ServiceRef__c = MainService.getId(),                          // k_サービス
            k_ShohinCategoryRef__c = waribikiCategory.getId(),           // k_商品カテゴリ
            k_Coupon__c = Coupon.getId(),                                   // k_クーポン
            k_ShohinSyubetsuRef__c = waribikiSyubetsu.getId(),           // k_商品種別
            BunruiKensakuTag__c = '@@',                                          // 分類検索タグ
            IsKingakuHenkouFuka__c = false,                                  // 金額変更不可
            SougiPlan__c = false                                                         // 葬儀プラン
        );
        Database.SaveResult kupon = Database.insert(Kusobj);
        
        //価格表エントリオブジェクトに価格エントリ番号「StandardSBG-0003531」のデータを作成
        PricebookEntry sPEntry5 = new PricebookEntry(
            Pricebook2Id = lsrstandardPricebook,
            Product2Id = kupon.getId(),
            UnitPrice = -55000,
            UseStandardPrice = FALSE,
            IsActive = true,
            KakakuEntryBango__c = 'StandardSBG-0003531'
        );
        Database.SaveResult lsrstandardPricebookEntry5 = Database.insert(sPEntry5);

        List<OpportunityLineItem> Listoitem = new List<OpportunityLineItem>();
        // 商談商品のデータ作成
        OpportunityLineItem oli = new OpportunityLineItem(
            Product2Id = MainProduct.getId(),
            OpportunityId = opp2.Id,
            Quantity = 1,
            PricebookEntryId = lsrstandardPricebookEntry.Id,
            UnitPrice = 162800
            //TotalPrice = 162800
        );
        Listoitem.add(oli);
        
        // 商談商品のデータ作成
        OpportunityLineItem oli2 = new OpportunityLineItem(
            Product2Id = OptionProduct.getId(),
            OpportunityId = opp2.Id,
            Quantity = 1,
            PricebookEntryId = lsrstandardPricebookEntry2.Id,
            UnitPrice = -5500
            //TotalPrice = -5500
        );
        Listoitem.add(oli2);

        // 商談商品のデータ作成
        OpportunityLineItem oli5 = new OpportunityLineItem(
            Product2Id = WAP.getId(),
            OpportunityId = opp2.Id,
            Quantity = 1,
            PricebookEntryId = lsrstandardPricebookEntry3.Id,
            UnitPrice = 15500
            //TotalPrice = -5500
        );
        Listoitem.add(oli5);

        // 商談商品のデータ作成
        OpportunityLineItem oli3 = new OpportunityLineItem(
            Product2Id = WASP.getId(),
            OpportunityId = opp2.Id,
            Quantity = 1,
            PricebookEntryId = lsrstandardPricebookEntry4.Id,
            UnitPrice = -5500
            //TotalPrice = -5500
        );
        Listoitem.add(oli3);

        // 商談商品のデータ作成
        OpportunityLineItem oli4 = new OpportunityLineItem(
            Product2Id = kupon.getId(),
            OpportunityId = opp2.Id,
            Quantity = 1,
            PricebookEntryId = lsrstandardPricebookEntry5.Id,
            UnitPrice = -5500
            //TotalPrice = -5500
        );
        Listoitem.add(oli4);


        List<Database.SaveResult> lsroli = Database.insert(Listoitem);

	}

    private static void beginPlanSetUp(opportunity opp2,Id lsrstandardPricebook,Database.SaveResult MainService){
    
        k_ShohinCategory__c MainCsobj = new k_ShohinCategory__c(
            Name = '火葬式',    // 商品カテゴリ名
            ID__c = 'kasou' // ID
        );
        Database.SaveResult MainCategory = Database.insert(MainCsobj);

		k_ShohinCategory__c MainCIchinichisobj = new k_ShohinCategory__c(
			Name = '一日葬',       // 商品カテゴリ名
			 ID__c = 'ichinichi'  // ID
		);
        Database.SaveResult MainCategoryIchinichi = Database.insert(MainCIchinichisobj);

		k_ShohinCategory__c objYoriso = new k_ShohinCategory__c(
			Name = 'よりそうオプション',
			ID__c = 'yoriso-option'
		);
		Database.SaveResult DS_objYoriso = Database.insert(objYoriso);

        k_ShohinCategory__c OptionShohin = new k_ShohinCategory__c(
            Name = '葬儀オプション',    // 商品カテゴリ名
            ID__c = 'sougiOption' // ID
        );
        Database.SaveResult OptionCategory = Database.insert(OptionShohin);
        
        k_ShohinSyubetsu__c MainShohin = new k_ShohinSyubetsu__c(
            Name = '本体（委託）',                    // 商品種別名
            ID__c = '1',                                // ID
            KeijouSyubetsu__c = 'グロス'   // 計上種別
        );
        Database.SaveResult MainSyubetsu = Database.insert(MainShohin);

        k_ShohinSyubetsu__c OptionShohinSyubetsu = new k_ShohinSyubetsu__c(
            Name = 'オプション（委託）',                    // 商品種別名
            ID__c = '3',                                // ID
            KeijouSyubetsu__c = 'グロス'   // 計上種別
        );
        Database.SaveResult OptionSyubetsu = Database.insert(OptionShohinSyubetsu);
        
        k_ShohinCategory__c waribikiCsobj = new k_ShohinCategory__c(
            Name = '割引',             // 商品カテゴリ名
            ID__c = 'waribiki'  // ID
        );
        Database.SaveResult waribikiCategory = Database.insert(waribikiCsobj);
        
        k_ShohinSyubetsu__c WAribikiShohin = new k_ShohinSyubetsu__c(
            Name = '割引等',                       // 商品種別名
            ID__c = '6'                          // ID
        );
        Database.SaveResult waribikiSyubetsu= Database.insert(WAribikiShohin);
        
        k_WaribikiPlan__c WaribikiPsobj = new k_WaribikiPlan__c(
            Name = '事前割メンバー (30日未満)',// 割引プラン名
            ID__c = '8'                          // ID
        );
        Database.SaveResult WaribikiPlan= Database.insert(WaribikiPsobj);

        k_Coupon__c Couponsobj = new k_Coupon__c(
            Name = '【19.12】よりそうのお葬式 オファリング 5,000円値引き',// クーポン名
            ID__c = '22'                                                             // ID
        );
        Database.SaveResult Coupon = Database.insert(Couponsobj);

		Product2 objMainYoriso = new Product2(
			ShohinBango__c = 'SBG-0005001',
			IsActive = true,
			Name = '【20.11】よりそう家族葬 一日プラン',
			NameForCustomer__c = 'よりそう家族葬 一日プラン',
			LatestFlg__c = true,
			ShohinKamoku__c = '通常',
			SireKingakuKeisanHousiki__c = '設定金額',
			SireKingaku__c = 355300,
			TesuryoKingakuKeisanHoushiki__c = '計算しない',
			TesuryoKingaku__c = 0,
			TesuryoCyoseiKingakuKeisanHoushiki__c = '計算しない',
			HanbaiKaishiBi__c = Date.valueOf('2020-11-01'),
			HanbaiSyuryoBi__c = Date.valueOf('2100-12-30'),
			DataKubun__c = '1:通常商品',
			k_ServiceRef__c = MainService.getId(),
			k_ShohinCategoryRef__c = MainCategoryIchinichi.getId(),
			k_ShohinSyubetsuRef__c = MainSyubetsu.getId(),
			BunruiKensakuTag__c = '@@',
			IsKingakuHenkouFuka__c = false,
			HinmokuBunrui__c = '本体',
			SougiPlan__c = true
		);
		Database.SaveResult MainYoriso = Database.insert(objMainYoriso);


		//価格表エントリオブジェクトに価格エントリ番号「StandardSBG-0005001」のデータを作成
		PricebookEntry sPEntry5001 = new PricebookEntry(
			Pricebook2Id = lsrstandardPricebook,
			Product2Id = MainYoriso.getId(),
			UnitPrice = 355300,
			UseStandardPrice = FALSE,
			IsActive = true,
			KakakuEntryBango__c = 'StandardSBG-0005001'
		);
		Database.SaveResult lsrstandardPricebookEntry = Database.insert(sPEntry5001);

		Product2 objYorisoOption = new Product2(
			ShohinBango__c = 'SBG-0005407',
			IsActive = true,
			Name = '【20.11】よりそうオプション お別れ花 S',
			NameForCustomer__c = 'よりそうお葬式 オプション お別れ花 S',
			LatestFlg__c = true,
			ShohinKamoku__c = '通常',
			SireKingakuKeisanHousiki__c = '設定金額',
			SireKingaku__c = 22000,
			TesuryoKingakuKeisanHoushiki__c = '計算しない',
			TesuryoKingaku__c = 0,
			TesuryoCyoseiKingakuKeisanHoushiki__c = '計算しない',
			HanbaiKaishiBi__c = Date.valueOf('2020-11-01'),
			HanbaiSyuryoBi__c = Date.valueOf('2100-12-31'),
			DataKubun__c = '1:通常商品',
			k_ServiceRef__c = MainService.getId(),
			k_ShohinCategoryRef__c = DS_objYoriso.getId(),
			k_ShohinSyubetsuRef__c = OptionSyubetsu.getId(),
			BunruiKensakuTag__c = '@@',
			IsKingakuHenkouFuka__c = false,
			HinmokuBunrui__c = 'お別れ花',
			SougiPlan__c = false
		);

		Database.SaveResult YorisoOptin = Database.insert(objYorisoOption);

		//価格表エントリオブジェクトに価格エントリ番号「StandardSBG-0005407」のデータを作成
		PricebookEntry sPEntry0005407 = new PricebookEntry(
			Pricebook2Id = lsrstandardPricebook,
			Product2Id = YorisoOptin.getId(),
			UnitPrice = 22000,
			UseStandardPrice = FALSE,
			IsActive = true,
			KakakuEntryBango__c = 'StandardSBG-0005407'
		);
		Database.SaveResult lsrstandardPricebookEntry2 = Database.insert(sPEntry0005407);

		Product2 OPTIONsobj0005501 = new Product2(
			ShohinBango__c = 'SBG-0005501',
			IsActive = true,
			Name = '【20.11】葬儀社オプション 料理',
			NameForCustomer__c = 'よりそうお葬式 オプション 料理',
			LatestFlg__c = true,
			ShohinKamoku__c = '通常',
			SireKingakuKeisanHousiki__c = '販売金額',
			SireKingaku__c = 0,
			TesuryoKingakuKeisanHoushiki__c = '計算しない',
			TesuryoKingaku__c = 0,
			TesuryoCyoseiKingakuKeisanHoushiki__c = '計算しない',
			HanbaiKaishiBi__c = Date.valueOf('2020-11-01'),
			HanbaiSyuryoBi__c = Date.valueOf('2100-12-31'),
			DataKubun__c = '1:通常商品',
			k_ServiceRef__c = MainService.getId(),
			k_ShohinCategoryRef__c = OptionCategory.getId(),
			k_ShohinSyubetsuRef__c = OptionSyubetsu.getId(),
			BunruiKensakuTag__c = '@@',
			IsKingakuHenkouFuka__c = false,
			HinmokuBunrui__c = '料理',
			SougiPlan__c = false
		);
		Database.SaveResult OPTION0005501 = Database.insert(OPTIONsobj0005501);

		//価格表エントリオブジェクトに価格エントリ番号「StandardSBG-0005501」のデータを作成
		PricebookEntry sPEntry0005501 = new PricebookEntry(
			Pricebook2Id = lsrstandardPricebook,
			Product2Id = OPTION0005501.getId(),
			UnitPrice = 0,
			UseStandardPrice = FALSE,
			IsActive = true,
			KakakuEntryBango__c = 'StandardSBG-0005501'
		);
		Database.SaveResult lsrstandardPricebookEntry3 = Database.insert(sPEntry0005501);
        
        List<OpportunityLineItem> Listoitem = new List<OpportunityLineItem>();
        // 商談商品のデータ作成
        OpportunityLineItem oli = new OpportunityLineItem(
            Product2Id = MainYoriso.getId(),
            OpportunityId = opp2.Id,
            Quantity = 1,
            PricebookEntryId = lsrstandardPricebookEntry.Id,
            UnitPrice = 355300
            //TotalPrice = 162800
        );
        Listoitem.add(oli);
        
        // 商談商品のデータ作成
        OpportunityLineItem oli2 = new OpportunityLineItem(
            Product2Id = YorisoOptin.getId(),
            OpportunityId = opp2.Id,
            Quantity = 1,
            PricebookEntryId = lsrstandardPricebookEntry2.Id,
            UnitPrice = 22000
            //TotalPrice = -5500
        );
        Listoitem.add(oli2);

        // 商談商品のデータ作成
        OpportunityLineItem oli3 = new OpportunityLineItem(
            Product2Id = OPTION0005501.getId(),
            OpportunityId = opp2.Id,
            Quantity = 1,
            PricebookEntryId = lsrstandardPricebookEntry3.Id,
            UnitPrice = 15500
            //TotalPrice = -5500
        );
        Listoitem.add(oli3);

        List<Database.SaveResult> lsroli = Database.insert(Listoitem);

	}

}