@isTest
private class ShinkiToiawaseSogiyoCtlT {

    @testSetup
    static void initializeTestData() {

        Utility_Common.isMimicExecAsDataIkouProfile = true;

        Account dacc=new Account();
        dacc.LastName='xxxdefualt';
        dacc.Phone='088-0000-0001';
        dacc.MobilePhone__c='888-0000-0001';
        dacc.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId();
        insert dacc;

        TriggerIsActive__c TriggerIsActive=new TriggerIsActive__c();
        TriggerIsActive.name='default';
        TriggerIsActive.isActive__c=true;
        insert TriggerIsActive;

        JizenWariPlan__c JizenWariPlan=new JizenWariPlan__c();
        JizenWariPlan.Code__c='Yoriso';
        insert JizenWariPlan;        

        //取引先のデータ作成
        Account acc=new Account();
        acc.LastName='姓';
        acc.FirstName='名';
        acc.Phone='080-0000-0001';
        acc.MobilePhone__c='080-0000-0001';
        acc.MailAddress__c = 'test@yoriso.com';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
        insert acc;

        List<k_Service__c> kServiceList = new List<k_Service__c>{
            new k_Service__c(name='シンプルなお葬式', ID__c = '1' ),
            new k_Service__c(name='安くて豪華なお葬式', ID__c = '2' ),
            new k_Service__c(name='お坊さん便', ID__c = '3' )
        };
        insert kServiceList;

        Pricebook2 standardPricebook = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = true
        );
        update standardPricebook;

        Id pricebookId = Test.getStandardPricebookId();
        k_ShohinSyubetsu__c k_ShohinSyubetsu=new k_ShohinSyubetsu__c();
        k_ShohinSyubetsu.ID__c='1';
        insert k_ShohinSyubetsu;
        
        List<Product2> pList = new List<Product2>{
            new Product2(Name = 'お坊さん便　戒名　釋・釋尼', IsActive = true, ShohinBango__c = 'SBG-0000060', k_ServiceRef__c = kServiceList.get(2).Id),
            new Product2(Name = 'お坊さん便　戒名　信士・信女', IsActive = true, ShohinBango__c = 'SBG-0000061', k_ServiceRef__c = kServiceList.get(2).Id),
            new Product2(Name = 'お坊さん便　戒名　院信士・院信女', IsActive = true, ShohinBango__c = 'SBG-0000062', k_ServiceRef__c = kServiceList.get(2).Id),
            new Product2(Name = 'お坊さん便　戒名　居士・大姉', IsActive = true, ShohinBango__c = 'SBG-0000063', k_ServiceRef__c = kServiceList.get(2).Id),
            new Product2(Name = 'お坊さん便　戒名　院釋・釋尼', IsActive = true, ShohinBango__c = 'SBG-0000064', k_ServiceRef__c = kServiceList.get(2).Id),
            new Product2(Name = 'お坊さん便　戒名　院日信士・院日信女', IsActive = true, ShohinBango__c = 'SBG-0000065', k_ServiceRef__c = kServiceList.get(2).Id),
            new Product2(Name = 'お坊さん便　戒名　院居士・院大姉', IsActive = true, ShohinBango__c = 'SBG-0000066', k_ServiceRef__c = kServiceList.get(2).Id),

            new Product2(Name = '【19.12】よりそうのお葬式 事前割メンバー割引 (直葬)', IsActive = true, ShohinBango__c = 'SBG-0003500', k_ServiceRef__c = kServiceList.get(0).Id),
            new Product2(Name = '【19.12】よりそうのお葬式 事前割メンバー割引 (火葬式) (30日未満)', IsActive = true, ShohinBango__c = 'SBG-0003501', k_ServiceRef__c = kServiceList.get(0).Id),
            new Product2(Name = '【19.12】よりそうのお葬式 事前割メンバー割引 (一日葬) (30日未満)', IsActive = true, ShohinBango__c = 'SBG-0003505', k_ServiceRef__c = kServiceList.get(0).Id),
            new Product2(Name = '【19.12】よりそうのお葬式 事前割メンバー割引 (家族葬) (30日未満)', IsActive = true, ShohinBango__c = 'SBG-0003509', k_ServiceRef__c = kServiceList.get(0).Id),
            new Product2(Name = '【19.12】よりそうのお葬式 事前割メンバー割引 (一般葬) (30日未満)', IsActive = true, ShohinBango__c = 'SBG-0003513', k_ServiceRef__c = kServiceList.get(0).Id),
            new Product2(Name = '【19.12】よりそうのお葬式 事前割メンバー割引 (火葬式) (1年未満)', IsActive = true, ShohinBango__c = 'SBG-0003502', k_ServiceRef__c = kServiceList.get(0).Id),
            new Product2(Name = '【19.12】よりそうのお葬式 事前割メンバー割引 (一日葬) (1年未満)', IsActive = true, ShohinBango__c = 'SBG-0003506', k_ServiceRef__c = kServiceList.get(0).Id),
            new Product2(Name = '【19.12】よりそうのお葬式 事前割メンバー割引 (家族葬) (1年未満)', IsActive = true, ShohinBango__c = 'SBG-0003510', k_ServiceRef__c = kServiceList.get(0).Id),
            new Product2(Name = '【19.12】よりそうのお葬式 事前割メンバー割引 (一般葬) (1年未満)', IsActive = true, ShohinBango__c = 'SBG-0003514', k_ServiceRef__c = kServiceList.get(0).Id),
            new Product2(Name = '【19.12】よりそうのお葬式 事前割メンバー割引 (火葬式) (2年未満)', IsActive = true, ShohinBango__c = 'SBG-0003503', k_ServiceRef__c = kServiceList.get(0).Id),
            new Product2(Name = '【19.12】よりそうのお葬式 事前割メンバー割引 (一日葬) (2年未満)', IsActive = true, ShohinBango__c = 'SBG-0003507', k_ServiceRef__c = kServiceList.get(0).Id),
            new Product2(Name = '【19.12】よりそうのお葬式 事前割メンバー割引 (家族葬) (2年未満)', IsActive = true, ShohinBango__c = 'SBG-0003511', k_ServiceRef__c = kServiceList.get(0).Id),
            new Product2(Name = '【19.12】よりそうのお葬式 事前割メンバー割引 (一般葬) (2年未満)', IsActive = true, ShohinBango__c = 'SBG-0003515', k_ServiceRef__c = kServiceList.get(0).Id),
            new Product2(Name = '【19.12】よりそうのお葬式 事前割メンバー割引 (火葬式) (2年以上)', IsActive = true, ShohinBango__c = 'SBG-0003504', k_ServiceRef__c = kServiceList.get(0).Id),
            new Product2(Name = '【19.12】よりそうのお葬式 事前割メンバー割引 (一日葬) (2年以上)', IsActive = true, ShohinBango__c = 'SBG-0003508', k_ServiceRef__c = kServiceList.get(0).Id),
            new Product2(Name = '【19.12】よりそうのお葬式 事前割メンバー割引 (家族葬) (2年以上)', IsActive = true, ShohinBango__c = 'SBG-0003512', k_ServiceRef__c = kServiceList.get(0).Id),
            new Product2(Name = '【19.12】よりそうのお葬式 事前割メンバー割引 (一般葬) (2年以上)', IsActive = true, ShohinBango__c = 'SBG-0003516', k_ServiceRef__c = kServiceList.get(0).Id),
            new Product2(Name = '【19.12】よりそうのお葬式 お葬式予約メンバー割引 (火葬式)', IsActive = true, ShohinBango__c = 'SBG-0003196', k_ServiceRef__c = kServiceList.get(0).Id),
            new Product2(Name = '【19.12】よりそうのお葬式 お葬式予約メンバー割引 (一日葬)', IsActive = true, ShohinBango__c = 'SBG-0003197', k_ServiceRef__c = kServiceList.get(0).Id),
            new Product2(Name = '【19.12】よりそうのお葬式 お葬式予約メンバー割引 (家族葬)', IsActive = true, ShohinBango__c = 'SBG-0003198', k_ServiceRef__c = kServiceList.get(0).Id),
            new Product2(Name = '【19.12】よりそうのお葬式 お葬式予約メンバー割引 (一般葬)', IsActive = true, ShohinBango__c = 'SBG-0003199', k_ServiceRef__c = kServiceList.get(0).Id)
        };
        insert pList;

        List<PricebookEntry> pbEntryList = new List<PricebookEntry>{
            new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = pList.get(0).Id,UnitPrice = 1000,IsActive = true),
            new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = pList.get(1).Id,UnitPrice = 1000,IsActive = true),
            new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = pList.get(2).Id,UnitPrice = 1000,IsActive = true),
            new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = pList.get(3).Id,UnitPrice = 1000,IsActive = true),
            new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = pList.get(4).Id,UnitPrice = 1000,IsActive = true),
            new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = pList.get(5).Id,UnitPrice = 1000,IsActive = true),
            new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = pList.get(6).Id,UnitPrice = 1000,IsActive = true),
            new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = pList.get(7).Id,UnitPrice = 1000,IsActive = true),
            new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = pList.get(8).Id,UnitPrice = 1000,IsActive = true),
            new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = pList.get(9).Id,UnitPrice = 1000,IsActive = true),
            new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = pList.get(10).Id,UnitPrice = 1000,IsActive = true),
            new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = pList.get(11).Id,UnitPrice = 1000,IsActive = true),
            new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = pList.get(12).Id,UnitPrice = 1000,IsActive = true),
            new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = pList.get(13).Id,UnitPrice = 1000,IsActive = true),
            new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = pList.get(14).Id,UnitPrice = 1000,IsActive = true),
            new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = pList.get(15).Id,UnitPrice = 1000,IsActive = true),
            new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = pList.get(16).Id,UnitPrice = 1000,IsActive = true),
            new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = pList.get(17).Id,UnitPrice = 1000,IsActive = true),
            new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = pList.get(18).Id,UnitPrice = 1000,IsActive = true),
            new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = pList.get(19).Id,UnitPrice = 1000,IsActive = true),
            new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = pList.get(20).Id,UnitPrice = 1000,IsActive = true),
            new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = pList.get(21).Id,UnitPrice = 1000,IsActive = true),
            new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = pList.get(22).Id,UnitPrice = 1000,IsActive = true),
            new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = pList.get(23).Id,UnitPrice = 1000,IsActive = true),
            new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = pList.get(24).Id,UnitPrice = 1000,IsActive = true),
            new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = pList.get(25).Id,UnitPrice = 1000,IsActive = true),
            new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = pList.get(26).Id,UnitPrice = 1000,IsActive = true),
            new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = pList.get(27).Id,UnitPrice = 1000,IsActive = true)
        };
        insert pbEntryList;

        Case c = new Case();
        c.Status = '対応中';
        c.Origin = '電話';
        c.Priority = '中';
        c.Type = 'サービス利用';
        c.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SimpleYasugoOtoiawase').getRecordTypeId();
        c.ToiawaseDate__c = datetime.now();
        insert c;

        SimpleYasugo__c simpleYasugo = new SimpleYasugo__c();
        insert simpleYasugo;
                
        opportunity opp=new opportunity();
        opp.CaseRef__c=c.Id;
        opp.accountid=acc.id;
        opp.Name='test';
        opp.StageName='商談開始';
        opp.Req_Day__c = Date.today();
        opp.CloseDate = Date.today();
        opp.KakuteibiSyodan__c = Date.today();
        opp.Utiagebi__c = Date.today();
        opp.accountid=acc.id;
        opp.TesuryoPartner__c = 5000;
        opp.TaishoushaJokyo__c = '_';
        opp.SimpleYasugoRef__c = simpleYasugo.Id;
        opp.recordtypeid=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId();
        insert opp;

        //取引先の「葬儀社」データ作成
        Account acc2 = new Account(
            Name ='テスト葬儀社',
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

        TodoufuKen__c TodoufuKen = new TodoufuKen__c();
        TodoufuKen.name='東京都';
        insert TodoufuKen;
        
        Shikugun__c Shikugun=new Shikugun__c();
        Shikugun.Name='中央区';
        Shikugun.TodoufuKenRef__c=TodoufuKen.id;
        insert Shikugun;   
        
        Shisetsu__c Shisetsu2=new Shisetsu__c();
        Shisetsu2.ShisetsuShubetsu__c='火葬場';        
        Shisetsu2.Name='テスト火葬場';
        Shisetsu2.State__c='東京都';
        Shisetsu2.City__c='中央区';
        Shisetsu2.Street__c='2-2-2';
        Shisetsu2.PostalCode__c='335-0016';
        Shisetsu2.Shikugun__c=Shikugun.id;
        shisetsu2.KoeiMinei__c='民営';
        insert Shisetsu2;

        Saijo__c s = new Saijo__c();
        s.SaijoKeisaiJohoIdOld__c = '1111111111';
        s.SimpleHPKeisaiAri__c = true;
        s.Name = 'テスト斎場';
        s.KeisaiSaijoMeiKana__c = 'テスト';
        s.TokuchoSaijo__c = '特徴';
        s.ShikugunRef__c=Shikugun.id;
        s.PostalCode__c = '141-0031';
        s.Street__c = '西五反田2-11-17　HI五反田ビル 4F';
        s.JushoKana__c = 'にしごたんだ';
        s.IdoKedo__Latitude__s = 35.626471;
        s.IdoKedo__longitude__s = 139.722161;
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
        insert s;

        Utility_Common.isMimicExecAsDataIkouProfile = false;
    }
    
    @isTest static void testMethod_case1(){

        Opportunity opp = [select Id from Opportunity where Name = 'test'];

        Test.startTest();

        ApexPages.StandardController stdOpp = new ApexPages.StandardController(opp);

        ShinkiToiawaseSogiyoCtl sts = new ShinkiToiawaseSogiyoCtl(stdOpp);

        System.assertEquals(sts.goannaizumiRyuijikoOpt.isEmpty(), false);
        System.assertEquals(sts.inputSogiShiroSofuWrap.insatsubutsuIchiranOption.isEmpty(), false);
        System.assertEquals(sts.inputSogiShiroSofuWrap.sofuJokyoEditOption.isEmpty(), false);
        System.assertEquals(sts.inputSogiShiroSofuWrap.sofuJokyoDisabledOption.isEmpty(), false);
        System.assertEquals(sts.contactHistoryWrap.okyakusamaPlanNaiyoOption.isEmpty(), false);
        System.assertEquals(sts.contactHistoryWrap.okyakusamaPlanKingakuOption.isEmpty(), false);
        System.assertEquals(sts.contactHistoryWrap.okyakusamaOsoshiYoyakuOption.isEmpty(), false);
        System.assertEquals(sts.contactHistoryWrap.okyakusamaKeisatsuAnkenOption.isEmpty(), false);
        System.assertEquals(sts.contactHistoryWrap.okyakusamaSosaiFujoOption.isEmpty(), false);
        System.assertEquals(sts.contactHistoryWrap.okyakusamaHenkinHoshoOption.isEmpty(), false);
        System.assertEquals(sts.contactHistoryWrap.okyakusamaSoryoTehaiAnnaiOption.isEmpty(), false);
        System.assertEquals(sts.nengoPickList.isEmpty(), false);

        sts.init();
        sts.ota.BodaijiSoryoTehaiBiko__c = '菩提寺僧侶手配備考';
        sts.ota.Syuha__c = 'こだわりなし';

        ApexPages.currentPage().getParameters().put('talkscriptKey', 'AreaChoshu');
        sts.setTalkScript();

        sts.temporarilySave();

        sts.save();

        sts.init();

        sts.nengoValue = '平成';
        sts.warekiNen = '1';
        sts.warekiTsuki = '1';
        sts.warekiHi = '1';
        sts.setSeinengappiSeirekiNenTsukiHi();

        sts.ota.BotsunengappiSeireki__c = date.today();
        sts.setBotsunengappiWarekiNenTsukiHi();

        sts.createSogishaKaden();

        sts.ota.KiboKeishiki__c = '【19.12】火葬式';
        sts.ota.KiboPlan__c = '無宗教';

        sts.displayJudenLog();

        ApexPages.currentPage().getParameters().put('ojbAddCrossSellingTeianIndex', '0');
        sts.addCrossSellingTeian();

        ApexPages.currentPage().getParameters().put('ojbDelCrossSellingTeianIndex', '1');
        sts.delCrossSellingTeian();
        
        Test.stopTest();
    }

    @isTest static void testMethod_case2(){

        Opportunity opp = [select Id from Opportunity where Name = 'test'];

        Test.startTest();

        ApexPages.StandardController stdOpp = new ApexPages.StandardController(opp);

        ShinkiToiawaseSogiyoCtl sts = new ShinkiToiawaseSogiyoCtl(stdOpp);

        sts.init();

        Apexpages.currentPage().getParameters().put('pToiawase', '直ぎれ／間違い電話');
        sts.setAnkenShubetsu();
        Apexpages.currentPage().getParameters().put('pToiawase', '');
        
        Apexpages.currentPage().getParameters().put('pKonnyusaki', 'それ以外');
        sts.setAnkenShubetsu();
        Apexpages.currentPage().getParameters().put('pKonnyusaki', '');
        
        Apexpages.currentPage().getParameters().put('pTashaSodanJokyo', '葬儀依頼済');
        sts.setAnkenShubetsu();
        Apexpages.currentPage().getParameters().put('pTashaSodanJokyo', '');

        Apexpages.currentPage().getParameters().put('pToiawase', 'マナー問合せ');
        sts.setAnkenShubetsu();
        Apexpages.currentPage().getParameters().put('pToiawase', '');

        Apexpages.currentPage().getParameters().put('pToiawase', '提供外サービス');
        sts.setAnkenShubetsu();
        Apexpages.currentPage().getParameters().put('pToiawase', '');

        Apexpages.currentPage().getParameters().put('pToiawase', '参列問合せ');
        sts.setAnkenShubetsu();
        Apexpages.currentPage().getParameters().put('pToiawase', '');

        Apexpages.currentPage().getParameters().put('pToiawase', '葬儀依頼');
        Apexpages.currentPage().getParameters().put('pKonnyusaki', '火葬場');
        sts.setAnkenShubetsu();
        Apexpages.currentPage().getParameters().put('pToiawase', '');
        Apexpages.currentPage().getParameters().put('pKonnyusaki', '');

        Apexpages.currentPage().getParameters().put('pToiawase', '事前相談');
        Apexpages.currentPage().getParameters().put('pKonnyusaki', '火葬場');
        sts.setAnkenShubetsu();
        Apexpages.currentPage().getParameters().put('pToiawase', '');
        Apexpages.currentPage().getParameters().put('pKonnyusaki', '');

        Apexpages.currentPage().getParameters().put('pToiawase', '葬儀依頼');
        Apexpages.currentPage().getParameters().put('pKonnyusaki', '競合他社');
        sts.setAnkenShubetsu();
        Apexpages.currentPage().getParameters().put('pToiawase', '');
        Apexpages.currentPage().getParameters().put('pKonnyusaki', '');

        Apexpages.currentPage().getParameters().put('pToiawase', '事前相談');
        Apexpages.currentPage().getParameters().put('pKonnyusaki', '競合他社');
        sts.setAnkenShubetsu();
        Apexpages.currentPage().getParameters().put('pToiawase', '');
        Apexpages.currentPage().getParameters().put('pKonnyusaki', '');

        Apexpages.currentPage().getParameters().put('pTashaSodanJokyo', '未相談');
        sts.setAnkenShubetsu();
        Apexpages.currentPage().getParameters().put('pTashaSodanJokyo', '');

        Apexpages.currentPage().getParameters().put('pToiawase', '葬儀依頼');
        Apexpages.currentPage().getParameters().put('pKonnyusaki', '斎場');
        Apexpages.currentPage().getParameters().put('pKonnyusakiJokyo', '契約中');
        Apexpages.currentPage().getParameters().put('pTashaSodanJokyo', '事前相談済');
        sts.setAnkenShubetsu();
        Apexpages.currentPage().getParameters().put('pToiawase', '');
        Apexpages.currentPage().getParameters().put('pKonnyusaki', '');
        Apexpages.currentPage().getParameters().put('pKonnyusakiJokyo', '');
        Apexpages.currentPage().getParameters().put('pTashaSodanJokyo', '');

        Apexpages.currentPage().getParameters().put('pToiawase', '葬儀依頼');
        Apexpages.currentPage().getParameters().put('pKonnyusaki', '斎場');
        Apexpages.currentPage().getParameters().put('pKonnyusakiJokyo', '契約中');
        Apexpages.currentPage().getParameters().put('pTashaSodanJokyo', '会員・積み立て');
        sts.setAnkenShubetsu();
        Apexpages.currentPage().getParameters().put('pToiawase', '');
        Apexpages.currentPage().getParameters().put('pKonnyusaki', '');
        Apexpages.currentPage().getParameters().put('pKonnyusakiJokyo', '');
        Apexpages.currentPage().getParameters().put('pTashaSodanJokyo', '');

        Apexpages.currentPage().getParameters().put('pToiawase', '葬儀依頼');
        Apexpages.currentPage().getParameters().put('pKonnyusaki', '斎場');
        Apexpages.currentPage().getParameters().put('pKonnyusakiJokyo', '契約中');
        Apexpages.currentPage().getParameters().put('pTashaSodanJokyo', '葬儀依頼済');
        sts.setAnkenShubetsu();
        Apexpages.currentPage().getParameters().put('pToiawase', '');
        Apexpages.currentPage().getParameters().put('pKonnyusaki', '');
        Apexpages.currentPage().getParameters().put('pKonnyusakiJokyo', '');
        Apexpages.currentPage().getParameters().put('pTashaSodanJokyo', '');

        Apexpages.currentPage().getParameters().put('pToiawase', '事前相談');
        Apexpages.currentPage().getParameters().put('pKonnyusaki', '斎場');
        Apexpages.currentPage().getParameters().put('pKonnyusakiJokyo', '契約中');
        Apexpages.currentPage().getParameters().put('pTashaSodanJokyo', '事前相談済');
        sts.setAnkenShubetsu();
        Apexpages.currentPage().getParameters().put('pToiawase', '');
        Apexpages.currentPage().getParameters().put('pKonnyusaki', '');
        Apexpages.currentPage().getParameters().put('pKonnyusakiJokyo', '');
        Apexpages.currentPage().getParameters().put('pTashaSodanJokyo', '');

        Apexpages.currentPage().getParameters().put('pToiawase', '事前相談');
        Apexpages.currentPage().getParameters().put('pKonnyusaki', '斎場');
        Apexpages.currentPage().getParameters().put('pKonnyusakiJokyo', '契約中');
        Apexpages.currentPage().getParameters().put('pTashaSodanJokyo', '会員・積み立て');
        sts.setAnkenShubetsu();
        Apexpages.currentPage().getParameters().put('pToiawase', '');
        Apexpages.currentPage().getParameters().put('pKonnyusaki', '');
        Apexpages.currentPage().getParameters().put('pKonnyusakiJokyo', '');
        Apexpages.currentPage().getParameters().put('pTashaSodanJokyo', '');

        Apexpages.currentPage().getParameters().put('pToiawase', '事前相談');
        Apexpages.currentPage().getParameters().put('pKonnyusaki', '斎場');
        Apexpages.currentPage().getParameters().put('pKonnyusakiJokyo', '契約中');
        Apexpages.currentPage().getParameters().put('pTashaSodanJokyo', '葬儀依頼済');
        sts.setAnkenShubetsu();
        Apexpages.currentPage().getParameters().put('pToiawase', '');
        Apexpages.currentPage().getParameters().put('pKonnyusaki', '');
        Apexpages.currentPage().getParameters().put('pKonnyusakiJokyo', '');
        Apexpages.currentPage().getParameters().put('pTashaSodanJokyo', '');


        Apexpages.currentPage().getParameters().put('pToiawase', '葬儀依頼');
        Apexpages.currentPage().getParameters().put('pKonnyusaki', '斎場');
        Apexpages.currentPage().getParameters().put('pKonnyusakiJokyo', '非提携');
        Apexpages.currentPage().getParameters().put('pTashaSodanJokyo', '事前相談済');
        sts.setAnkenShubetsu();
        Apexpages.currentPage().getParameters().put('pToiawase', '');
        Apexpages.currentPage().getParameters().put('pKonnyusaki', '');
        Apexpages.currentPage().getParameters().put('pKonnyusakiJokyo', '');
        Apexpages.currentPage().getParameters().put('pTashaSodanJokyo', '');

        Apexpages.currentPage().getParameters().put('pToiawase', '葬儀依頼');
        Apexpages.currentPage().getParameters().put('pKonnyusaki', '斎場');
        Apexpages.currentPage().getParameters().put('pKonnyusakiJokyo', '非提携');
        Apexpages.currentPage().getParameters().put('pTashaSodanJokyo', '会員・積み立て');
        sts.setAnkenShubetsu();
        Apexpages.currentPage().getParameters().put('pToiawase', '');
        Apexpages.currentPage().getParameters().put('pKonnyusaki', '');
        Apexpages.currentPage().getParameters().put('pKonnyusakiJokyo', '');
        Apexpages.currentPage().getParameters().put('pTashaSodanJokyo', '');

        Apexpages.currentPage().getParameters().put('pToiawase', '葬儀依頼');
        Apexpages.currentPage().getParameters().put('pKonnyusaki', '斎場');
        Apexpages.currentPage().getParameters().put('pKonnyusakiJokyo', '非提携');
        Apexpages.currentPage().getParameters().put('pTashaSodanJokyo', '葬儀依頼済');
        sts.setAnkenShubetsu();
        Apexpages.currentPage().getParameters().put('pToiawase', '');
        Apexpages.currentPage().getParameters().put('pKonnyusaki', '');
        Apexpages.currentPage().getParameters().put('pKonnyusakiJokyo', '');
        Apexpages.currentPage().getParameters().put('pTashaSodanJokyo', '');


        Apexpages.currentPage().getParameters().put('pToiawase', '事前相談');
        Apexpages.currentPage().getParameters().put('pKonnyusaki', '斎場');
        Apexpages.currentPage().getParameters().put('pKonnyusakiJokyo', '非提携');
        Apexpages.currentPage().getParameters().put('pTashaSodanJokyo', '事前相談済');
        sts.setAnkenShubetsu();
        Apexpages.currentPage().getParameters().put('pToiawase', '');
        Apexpages.currentPage().getParameters().put('pKonnyusaki', '');
        Apexpages.currentPage().getParameters().put('pKonnyusakiJokyo', '');
        Apexpages.currentPage().getParameters().put('pTashaSodanJokyo', '');

        Apexpages.currentPage().getParameters().put('pToiawase', '事前相談');
        Apexpages.currentPage().getParameters().put('pKonnyusaki', '斎場');
        Apexpages.currentPage().getParameters().put('pKonnyusakiJokyo', '非提携');
        Apexpages.currentPage().getParameters().put('pTashaSodanJokyo', '会員・積み立て');
        sts.setAnkenShubetsu();
        Apexpages.currentPage().getParameters().put('pToiawase', '');
        Apexpages.currentPage().getParameters().put('pKonnyusaki', '');
        Apexpages.currentPage().getParameters().put('pKonnyusakiJokyo', '');
        Apexpages.currentPage().getParameters().put('pTashaSodanJokyo', '');

        Apexpages.currentPage().getParameters().put('pToiawase', '事前相談');
        Apexpages.currentPage().getParameters().put('pKonnyusaki', '斎場');
        Apexpages.currentPage().getParameters().put('pKonnyusakiJokyo', '非提携');
        Apexpages.currentPage().getParameters().put('pTashaSodanJokyo', '葬儀依頼済');
        sts.setAnkenShubetsu();
        Apexpages.currentPage().getParameters().put('pToiawase', '');
        Apexpages.currentPage().getParameters().put('pKonnyusaki', '');
        Apexpages.currentPage().getParameters().put('pKonnyusakiJokyo', '');
        Apexpages.currentPage().getParameters().put('pTashaSodanJokyo', '');


        Apexpages.currentPage().getParameters().put('pToiawase', '葬儀依頼');
        Apexpages.currentPage().getParameters().put('pKonnyusaki', '葬儀社');
        Apexpages.currentPage().getParameters().put('pKonnyusakiJokyo', '契約中');
        Apexpages.currentPage().getParameters().put('pTashaSodanJokyo', '事前相談済');
        sts.setAnkenShubetsu();
        Apexpages.currentPage().getParameters().put('pToiawase', '');
        Apexpages.currentPage().getParameters().put('pKonnyusaki', '');
        Apexpages.currentPage().getParameters().put('pKonnyusakiJokyo', '');
        Apexpages.currentPage().getParameters().put('pTashaSodanJokyo', '');

        Apexpages.currentPage().getParameters().put('pToiawase', '葬儀依頼');
        Apexpages.currentPage().getParameters().put('pKonnyusaki', '葬儀社');
        Apexpages.currentPage().getParameters().put('pKonnyusakiJokyo', '契約中');
        Apexpages.currentPage().getParameters().put('pTashaSodanJokyo', '会員・積み立て');
        sts.setAnkenShubetsu();
        Apexpages.currentPage().getParameters().put('pToiawase', '');
        Apexpages.currentPage().getParameters().put('pKonnyusaki', '');
        Apexpages.currentPage().getParameters().put('pKonnyusakiJokyo', '');
        Apexpages.currentPage().getParameters().put('pTashaSodanJokyo', '');

        Apexpages.currentPage().getParameters().put('pToiawase', '葬儀依頼');
        Apexpages.currentPage().getParameters().put('pKonnyusaki', '葬儀社');
        Apexpages.currentPage().getParameters().put('pKonnyusakiJokyo', '契約中');
        Apexpages.currentPage().getParameters().put('pTashaSodanJokyo', '葬儀依頼済');
        sts.setAnkenShubetsu();
        Apexpages.currentPage().getParameters().put('pToiawase', '');
        Apexpages.currentPage().getParameters().put('pKonnyusaki', '');
        Apexpages.currentPage().getParameters().put('pKonnyusakiJokyo', '');
        Apexpages.currentPage().getParameters().put('pTashaSodanJokyo', '');


        Apexpages.currentPage().getParameters().put('pToiawase', '事前相談');
        Apexpages.currentPage().getParameters().put('pKonnyusaki', '葬儀社');
        Apexpages.currentPage().getParameters().put('pKonnyusakiJokyo', '契約中');
        Apexpages.currentPage().getParameters().put('pTashaSodanJokyo', '事前相談済');
        sts.setAnkenShubetsu();
        Apexpages.currentPage().getParameters().put('pToiawase', '');
        Apexpages.currentPage().getParameters().put('pKonnyusaki', '');
        Apexpages.currentPage().getParameters().put('pKonnyusakiJokyo', '');
        Apexpages.currentPage().getParameters().put('pTashaSodanJokyo', '');

        Apexpages.currentPage().getParameters().put('pToiawase', '事前相談');
        Apexpages.currentPage().getParameters().put('pKonnyusaki', '葬儀社');
        Apexpages.currentPage().getParameters().put('pKonnyusakiJokyo', '契約中');
        Apexpages.currentPage().getParameters().put('pTashaSodanJokyo', '会員・積み立て');
        sts.setAnkenShubetsu();
        Apexpages.currentPage().getParameters().put('pToiawase', '');
        Apexpages.currentPage().getParameters().put('pKonnyusaki', '');
        Apexpages.currentPage().getParameters().put('pKonnyusakiJokyo', '');
        Apexpages.currentPage().getParameters().put('pTashaSodanJokyo', '');

        Apexpages.currentPage().getParameters().put('pToiawase', '事前相談');
        Apexpages.currentPage().getParameters().put('pKonnyusaki', '葬儀社');
        Apexpages.currentPage().getParameters().put('pKonnyusakiJokyo', '契約中');
        Apexpages.currentPage().getParameters().put('pTashaSodanJokyo', '葬儀依頼済');
        sts.setAnkenShubetsu();
        Apexpages.currentPage().getParameters().put('pToiawase', '');
        Apexpages.currentPage().getParameters().put('pKonnyusaki', '');
        Apexpages.currentPage().getParameters().put('pKonnyusakiJokyo', '');
        Apexpages.currentPage().getParameters().put('pTashaSodanJokyo', '');


        Apexpages.currentPage().getParameters().put('pToiawase', '葬儀依頼');
        Apexpages.currentPage().getParameters().put('pKonnyusaki', '葬儀社');
        Apexpages.currentPage().getParameters().put('pKonnyusakiJokyo', '非提携');
        Apexpages.currentPage().getParameters().put('pTashaSodanJokyo', '事前相談済');
        sts.setAnkenShubetsu();
        Apexpages.currentPage().getParameters().put('pToiawase', '');
        Apexpages.currentPage().getParameters().put('pKonnyusaki', '');
        Apexpages.currentPage().getParameters().put('pKonnyusakiJokyo', '');
        Apexpages.currentPage().getParameters().put('pTashaSodanJokyo', '');

        Apexpages.currentPage().getParameters().put('pToiawase', '葬儀依頼');
        Apexpages.currentPage().getParameters().put('pKonnyusaki', '葬儀社');
        Apexpages.currentPage().getParameters().put('pKonnyusakiJokyo', '非提携');
        Apexpages.currentPage().getParameters().put('pTashaSodanJokyo', '会員・積み立て');
        sts.setAnkenShubetsu();
        Apexpages.currentPage().getParameters().put('pToiawase', '');
        Apexpages.currentPage().getParameters().put('pKonnyusaki', '');
        Apexpages.currentPage().getParameters().put('pKonnyusakiJokyo', '');
        Apexpages.currentPage().getParameters().put('pTashaSodanJokyo', '');

        Apexpages.currentPage().getParameters().put('pToiawase', '葬儀依頼');
        Apexpages.currentPage().getParameters().put('pKonnyusaki', '葬儀社');
        Apexpages.currentPage().getParameters().put('pKonnyusakiJokyo', '非提携');
        Apexpages.currentPage().getParameters().put('pTashaSodanJokyo', '葬儀依頼済');
        sts.setAnkenShubetsu();
        Apexpages.currentPage().getParameters().put('pToiawase', '');
        Apexpages.currentPage().getParameters().put('pKonnyusaki', '');
        Apexpages.currentPage().getParameters().put('pKonnyusakiJokyo', '');
        Apexpages.currentPage().getParameters().put('pTashaSodanJokyo', '');


        Apexpages.currentPage().getParameters().put('pToiawase', '事前相談');
        Apexpages.currentPage().getParameters().put('pKonnyusaki', '葬儀社');
        Apexpages.currentPage().getParameters().put('pKonnyusakiJokyo', '非提携');
        Apexpages.currentPage().getParameters().put('pTashaSodanJokyo', '事前相談済');
        sts.setAnkenShubetsu();
        Apexpages.currentPage().getParameters().put('pToiawase', '');
        Apexpages.currentPage().getParameters().put('pKonnyusaki', '');
        Apexpages.currentPage().getParameters().put('pKonnyusakiJokyo', '');
        Apexpages.currentPage().getParameters().put('pTashaSodanJokyo', '');

        Apexpages.currentPage().getParameters().put('pToiawase', '事前相談');
        Apexpages.currentPage().getParameters().put('pKonnyusaki', '葬儀社');
        Apexpages.currentPage().getParameters().put('pKonnyusakiJokyo', '非提携');
        Apexpages.currentPage().getParameters().put('pTashaSodanJokyo', '会員・積み立て');
        sts.setAnkenShubetsu();
        Apexpages.currentPage().getParameters().put('pToiawase', '');
        Apexpages.currentPage().getParameters().put('pKonnyusaki', '');
        Apexpages.currentPage().getParameters().put('pKonnyusakiJokyo', '');
        Apexpages.currentPage().getParameters().put('pTashaSodanJokyo', '');

        Apexpages.currentPage().getParameters().put('pToiawase', '事前相談');
        Apexpages.currentPage().getParameters().put('pKonnyusaki', '葬儀社');
        Apexpages.currentPage().getParameters().put('pKonnyusakiJokyo', '非提携');
        Apexpages.currentPage().getParameters().put('pTashaSodanJokyo', '葬儀依頼済');
        sts.setAnkenShubetsu();
        Apexpages.currentPage().getParameters().put('pToiawase', '');
        Apexpages.currentPage().getParameters().put('pKonnyusaki', '');
        Apexpages.currentPage().getParameters().put('pKonnyusakiJokyo', '');
        Apexpages.currentPage().getParameters().put('pTashaSodanJokyo', '');

        sts.setAnkenShubetsu();

        Apexpages.currentPage().getParameters().put('pToiawase', 'aaa');
        Apexpages.currentPage().getParameters().put('pKonnyusaki', 'bbb');
        Apexpages.currentPage().getParameters().put('pKonnyusakiJokyo', 'ccc');
        Apexpages.currentPage().getParameters().put('pTashaSodanJokyo', 'ddd');
        sts.setAnkenShubetsu();
        Apexpages.currentPage().getParameters().put('pToiawase', '');
        Apexpages.currentPage().getParameters().put('pKonnyusaki', '');
        Apexpages.currentPage().getParameters().put('pKonnyusakiJokyo', '');
        Apexpages.currentPage().getParameters().put('pTashaSodanJokyo', '');

        Keiyaku__c k = [select Id from Keiyaku__c where Name = 'シンプル安豪契約'];
        Apexpages.currentPage().getParameters().put('pKonnyusakiSogishaId', k.Id);
        sts.checkTeikeiJokyoSogisha();
        Apexpages.currentPage().getParameters().put('pKonnyusakiSogishaId', '');

        Apexpages.currentPage().getParameters().put('pKonnyusakiSogishaName', 'システム動作確認用');
        sts.checkTeikeiJokyoSogisha();
        Apexpages.currentPage().getParameters().put('pKonnyusakiSogishaName', '');

        Shisetsu__c kasoba = [select Id from Shisetsu__c where Name = 'テスト火葬場'];
        Apexpages.currentPage().getParameters().put('pKonnyusakiKasobaId', kasoba.Id);
        sts.checkTeikeiJokyoKasoba();
        Apexpages.currentPage().getParameters().put('pKonnyusakiKasobaId', '');

        Apexpages.currentPage().getParameters().put('pKonnyusakiKasobaName', 'テスト火葬場');
        sts.checkTeikeiJokyoKasoba();
        Apexpages.currentPage().getParameters().put('pKonnyusakiKasobaName', '');

        Saijo__c saijo = [select Id from Saijo__c where Name = 'テスト斎場'];
        Apexpages.currentPage().getParameters().put('pKonnyusakiSaijoId', saijo.Id);
        sts.checkTeikeiJokyoSaijo();
        Apexpages.currentPage().getParameters().put('pKonnyusakiSaijoId', '');

        Apexpages.currentPage().getParameters().put('pKonnyusakiSaijoName', 'テスト斎場');
        sts.checkTeikeiJokyoSaijo();
        Apexpages.currentPage().getParameters().put('pKonnyusakiSaijoName', '');

        sts.konnyusakiSogishaTeikeiId = k.Id;
        sts.konnyusakiKasobaTeikeiId = kasoba.Id;
        sts.konnyusakiSaijoTeikeiId = saijo.Id;
        sts.ankenShubetsu = '除外';
        sts.toiawaseJogaiKubun = '直ぎれ／間違い電話';
        sts.ota.Konnyusaki__c = '葬儀社';
        sts.saijotoiawase();
        
        Test.stopTest();
    }

    @isTest static void testMethod_case3(){

        Opportunity opp = [select Id from Opportunity where Name = 'test'];

        Test.startTest();

        ApexPages.StandardController stdOpp = new ApexPages.StandardController(opp);

        ShinkiToiawaseSogiyoCtl sts = new ShinkiToiawaseSogiyoCtl(stdOpp);

        sts.init();

        sts.createShiryoSofu();

        SogiShiryoSofu__c shiryo = [select Id from SogiShiryoSofu__c];
        Shisetsu__c kasoba = [select Id from Shisetsu__c where Name = 'テスト火葬場'];
        Saijo__c saijo = [select Id from Saijo__c where Name = 'テスト斎場'];
        insert new List<SogiShiryoSofuMeisai__c>{
            new SogiShiryoSofuMeisai__c(SogiShiryoSofuRef__c=shiryo.Id, ShisetsuKubun__c='火葬場', ShisetsuRef__c=kasoba.Id),
            new SogiShiryoSofuMeisai__c(SogiShiryoSofuRef__c=shiryo.Id, ShisetsuKubun__c='斎場', SaijoRef__c=saijo.Id)
        };

        Apexpages.currentPage().getParameters().put('pShiryoSofuId', shiryo.Id);
        sts.referShiryoSofu();
        
        sts.inputSogiShiroSofuWrap.sofuJokyoValue = '印刷待ち';
        sts.inputSogiShiroSofuWrap.inputSogiShiryoSofu.sogiShiryoSofu.SofuShubetsu__c = 'メール';
        sts.inputSogiShiroSofuWrap.inputSogiShiryoSofu.sogiShiryoSofu.Atena__c = 'テスト宛名';
        sts.inputSogiShiroSofuWrap.inputSogiShiryoSofu.sogiShiryoSofu.Mail__c = 'test@yoriso.com';
        sts.inputSogiShiroSofuWrap.inputSogiShiryoSofu.sogiShiryoSofu.SofuShiryoURL__c = 'https://www.yoriso.com/';
        sts.inputSogiShiroSofuWrap.inputSogiShiryoSofu.sogiShiryoSofu.PassWord__c = 'yoriso';
        sts.inputSogiShiroSofuWrap.inputSogiShiryoSofu.sogiShiryoSofu.Template__c = 'よりそうのお葬式';
        sts.inputSogiShiroSofuWrap.inputSogiShiryoSofu.sogiShiryoSofu.InsatsubutsuIchiran__c = '送付状;首都圏案内文;斎場資料;提案書;事前割証書;';
        sts.saveSogiShiryoSofu();

        Apexpages.currentPage().getParameters().put('pShiryoSofuId', shiryo.Id);
        sts.referShiryoSofu();
        sts.sendMailSogiShiryoSofu();

        sts.shiryoSofuId = shiryo.Id;
        sts.getTeianList();

        Apexpages.currentPage().getParameters().put('pShiryoSofuId', shiryo.Id);
        sts.copyShiryoSofu();
        
        Test.stopTest();
    }

    @isTest static void testMethod_case4(){

        Opportunity opp = [select Id from Opportunity where Name = 'test'];

        Test.startTest();

        ApexPages.StandardController stdOpp = new ApexPages.StandardController(opp);

        ShinkiToiawaseSogiyoCtl sts = new ShinkiToiawaseSogiyoCtl(stdOpp);

        sts.init();

        sts.createShiryoSofu();

        SogiShiryoSofu__c shiryo = [select Id from SogiShiryoSofu__c];
        Shisetsu__c kasoba = [select Id from Shisetsu__c where Name = 'テスト火葬場'];
        Saijo__c saijo = [select Id from Saijo__c where Name = 'テスト斎場'];
        insert new List<SogiShiryoSofuMeisai__c>{
            new SogiShiryoSofuMeisai__c(SogiShiryoSofuRef__c=shiryo.Id, ShisetsuKubun__c='火葬場', ShisetsuRef__c=kasoba.Id),
            new SogiShiryoSofuMeisai__c(SogiShiryoSofuRef__c=shiryo.Id, ShisetsuKubun__c='斎場', SaijoRef__c=saijo.Id)
        };

        Apexpages.currentPage().getParameters().put('pShiryoSofuId', shiryo.Id);
        sts.referShiryoSofu();
        
        sts.inputSogiShiroSofuWrap.sofuJokyoValue = '印刷待ち';
        sts.inputSogiShiroSofuWrap.inputSogiShiryoSofu.sogiShiryoSofu.SofuShubetsu__c = 'メール';
        sts.inputSogiShiroSofuWrap.inputSogiShiryoSofu.sogiShiryoSofu.Atena__c = 'テスト宛名';
        sts.inputSogiShiroSofuWrap.inputSogiShiryoSofu.sogiShiryoSofu.Mail__c = 'test@yoriso.com';
        sts.inputSogiShiroSofuWrap.inputSogiShiryoSofu.sogiShiryoSofu.SofuShiryoURL__c = 'https://www.yoriso.com/';
        sts.inputSogiShiroSofuWrap.inputSogiShiryoSofu.sogiShiryoSofu.PassWord__c = 'yoriso';
        sts.inputSogiShiroSofuWrap.inputSogiShiryoSofu.sogiShiryoSofu.Template__c = 'よりそうのお葬式';
        sts.inputSogiShiroSofuWrap.inputSogiShiryoSofu.sogiShiryoSofu.InsatsubutsuIchiran__c = '送付状;首都圏案内文;斎場資料;提案書;事前割証書;';
        sts.saveSogiShiryoSofu();

        Apexpages.currentPage().getParameters().put('pShiryoSofuId', shiryo.Id);
        sts.referShiryoSofu();
        sts.faxPdfOutput();

        Test.stopTest();
    }

    @isTest static void testMethod_case5(){

        Opportunity opp = [select Id from Opportunity where Name = 'test'];

        Test.startTest();

        ApexPages.StandardController stdOpp = new ApexPages.StandardController(opp);

        ShinkiToiawaseSogiyoCtl sts = new ShinkiToiawaseSogiyoCtl(stdOpp);

        sts.init();

        sts.TaishoushaJokyo = '健在';
        sts.TaishoshaYomeiKikan = '2週間以内';
        sts.TaishoshaKyojuKeitai = '自宅';

        sts.setSogiKPI();

        sts.resetSogiKPI();

        sts.setOpportunityValue();

        list<Shisetsu__c> ShisetsuT = new list<Shisetsu__c>();
        ShisetsuT = SwitchRemoteAction.rmtActGetShisetsu('テスト火葬場','kaso');

        list<Shisetsu__c> ShisetsuT2 = new list<Shisetsu__c>();
        ShisetsuT2 = SwitchRemoteAction.rmtActGetShisetsu('テスト火葬場','');

        list<Shisetsu__c> ShisetsuT3 = new list<Shisetsu__c>();
        ShisetsuT3 = SwitchRemoteAction.rmtActGetKonnyusakiKasoba('テスト火葬場');

        list<Keiyaku__c> KeiyakuT = new list<Keiyaku__c>();
        KeiyakuT = SwitchRemoteAction.rmtActGetKonnyusakiSogisha('シンプル安豪契約');

        list<Saijo__c> SaijoT = new list<Saijo__c>();
        SaijoT = SwitchRemoteAction.rmtActGetSaijo('テスト斎場');

        list<Saijo__c> SaijoT2 = new list<Saijo__c>();
        SaijoT2 = SwitchRemoteAction.rmtActGetKonnyusakiSaijo('テスト斎場');

        Test.stopTest();
    }
}