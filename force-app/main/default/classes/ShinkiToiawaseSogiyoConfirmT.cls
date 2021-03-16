@isTest
private class ShinkiToiawaseSogiyoConfirmT {
    
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

        Case c = new Case();
        c.Status = '対応中';
        c.Origin = '電話';
        c.Priority = '中';
        c.Type = 'サービス利用';
        c.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SimpleYasugoOtoiawase').getRecordTypeId();
        c.ToiawaseDate__c = datetime.now();
        insert c;

        Opportunity opp = [select Id, AccountId, SimpleYasugoRef__r.TaishoshaRef__c from Opportunity where CaseRef__c = :c.Id];

        Account sodansha = new Account(
            LastNameFurigana__pc = 'ソウダンシャ',
            FirstNameFurigana__pc = 'テスト',
            LastName = '相談者',
            FirstName = 'テスト',
            Gender__pc = '男性',
            MobilePhone__c = '080-0001-0001',
            Phone = '090-0001-0001',
            YusenTelNoKubun__c = '携帯1',
            recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId()
            );
        insert sodansha;

        Account taishosha = new Account(
            LastNameFurigana__pc = 'タイショウシャ',
            FirstNameFurigana__pc = 'テスト',
            LastName = '対象者',
            FirstName = 'テスト',
            Gender__pc = '男性',
            recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId()
            );
        insert taishosha;

        opp.AccountId = sodansha.Id;
        opp.SimpleYasugoRef__r.TaishoshaRef__c = taishosha.Id;
        opp.SimpleYasugoRef__r.AnchiRyokin2hakuOr3haku__c = false;
        opp.SimpleYasugoRef__r.ShikijoShiyoryo2man5senOr5man__c = false;
        opp.SimpleYasugoRef__r.KasojoShiyoryo1man5sen__c = true;
        opp.SimpleYasugoRef__r.HansoKyori50km__c = true;
        update opp;

        ApexPages.StandardController stdOpp = new ApexPages.StandardController(opp);

        ShinkiToiawaseSogiyoCtl sts = new ShinkiToiawaseSogiyoCtl(stdOpp);
        sts.init();

        sts.ota.FreeText__c = 'フリーテキスト';
        sts.ota.SodanshaRef__c = sodansha.Id;
        sts.ota.TaishoshaRef__c = taishosha.Id;
        sts.ota.KeisatsuAnken__c = true;
        sts.ota.SosaiFujo__c = true;
        sts.ota.TashaAnchi__c = true;
        sts.ota.TaijiAnken__c = true;
        sts.ota.SodanshaSeiKana__c = 'アイ';
        sts.ota.SodanshaMeiKana__c = 'ウエ';
        sts.ota.SodanshaSei__c = '相';
        sts.ota.SodanshaMei__c = '上';
        sts.ota.SodanshaSeibetsu__c = '男性';
        sts.ota.BenefitOneID__c = '111';
        sts.ota.PostalClubKaiinBango__c = '222';
        sts.ota.MobilePhone__c = '080-0002-0002';
        sts.ota.Phone__c = '090-0002-0002';
        sts.ota.ShiryoseikyushaPostalCode__c = '150-0022';
        sts.ota.ShiryoseikyushaState__c = '東京都';
        sts.ota.ShiryoseikyushaCity__c = '渋谷区';
        sts.ota.ShiryoseikyushaStreet__c = '恵比寿南';
        sts.ota.TaishoshaSeiKana__c = 'カキ';
        sts.ota.TaishoshaMeiKana__c = 'クケ';
        sts.ota.TaishoshaSei__c = '夏季';
        sts.ota.TaishoshaMei__c = '久家';
        sts.ota.TaishoshaSeibetsu__c = '男性';
        sts.ota.ZokugaraSodanshaNitottenoTaishosha__c = '夫';
        sts.ota.SeinengappiSeireki__c = date.today();
        sts.ota.BotsunengappiSeireki__c = date.today();
        sts.ota.KiboKeishiki__c = '火葬式';
        sts.ota.KiboPlan__c = '無宗教';
        sts.ota.AnchiRyokin2hakuOr3haku__c = true;
        sts.ota.ShikijoShiyoryo2man5senOr5man__c = false;
        sts.ota.KasojoShiyoryo1man5sen__c = true;
        sts.ota.HansoKyori50km__c = false;

        sts.contactHistoryWrap.contactHistory.OpportunityRef__c = opp.Id;
        sts.contactHistoryWrap.contactHistory.ContactShubetsu__c = 'お客様';
        sts.contactHistoryWrap.contactHistory.OkyakusamaTaiosha__c = '相談者以外';
        sts.contactHistoryWrap.contactHistory.OkyakusamaSodanshaIgaiName__c = 'test';
        sts.contactHistoryWrap.contactHistory.OkyakusamaSodanshaIgaiKankei__c = '父';
        sts.contactHistoryWrap.contactHistory.OkyakusamaJuhasshinJokyo__c = '架電';
        sts.contactHistoryWrap.contactHistory.OkyakusamaKadenShubetsu__c = 'その他';
        sts.contactHistoryWrap.contactHistory.OkyakusamaKadenShubetsuSonota__c = 'test';
        sts.contactHistoryWrap.contactHistory.OkyakusamaTel__c = '080-0000-0000';
        sts.contactHistoryWrap.contactHistory.OkyakusamaTaishoshaJokyo__c = 'その他';
        sts.contactHistoryWrap.contactHistory.OkyakusamaTaishoshaJokyoSonota__c = 'test';
        sts.contactHistoryWrap.contactHistory.OkyakusamaSetsuzokuJokyo__c = 'test';
        sts.contactHistoryWrap.contactHistory.OkyakusamaRusudenMsg__c = 'test';
        sts.contactHistoryWrap.contactHistory.OkyakusamaShiryoTochakuKakunin__c = 'test';
        sts.contactHistoryWrap.contactHistory.OkyakusamaShiryoNaiyoKakunin__c = 'test';
        sts.contactHistoryWrap.contactHistory.OkyakusamaTaishoshaShozaichi__c = 'test';
        sts.contactHistoryWrap.contactHistory.OkyakusamaShiboShindansho__c = 'なし';
        sts.contactHistoryWrap.contactHistory.OkyakusamaShiboShindanshoShutokuYotei__c = 'test';
        sts.contactHistoryWrap.contactHistory.OkyakusamaTochakuJokyo__c = 'test';
        sts.contactHistoryWrap.contactHistory.OkyakusamaOmukaeJikan__c = 'test';
        sts.contactHistoryWrap.contactHistory.OkyakusamaOmukaeJikanShitei__c = '指定あり';
        sts.contactHistoryWrap.contactHistory.OkyakusamaOffering__c = 'test';
        sts.contactHistoryWrap.contactHistory.OkyakusamaOfferingKingaku__c = 0;
        sts.contactHistoryWrap.contactHistory.OkyakusamaFreeComment__c = 'test';
        sts.contactHistoryWrap.contactHistory.OkyakusamaPlanNaiyo__c = 'test';
        sts.contactHistoryWrap.contactHistory.OkyakusamaPlanKingaku__c = 'test';
        sts.contactHistoryWrap.contactHistory.OkyakusamaKasoRyokin__c = 0;
        sts.contactHistoryWrap.contactHistory.OkyakusamaSoryoTehaiAnnai__c = 'test';
        sts.contactHistoryWrap.contactHistory.OkyakusamaOptionRyori__c = true;
        sts.contactHistoryWrap.contactHistory.OkyakusamaOptionHenreihin__c = true;
        sts.contactHistoryWrap.contactHistory.OkyakusamaOptionKyoka__c = true;
        sts.contactHistoryWrap.contactHistory.OkyakusamaOptionYukan__c = true;
        sts.contactHistoryWrap.contactHistory.OkyakusamaOptionKoshikiYukan__c = true;
        sts.contactHistoryWrap.contactHistory.OkyakusamaOptionMake__c = true;
        sts.contactHistoryWrap.contactHistory.OkyakusamaOptionSonota__c = 'test';
        sts.contactHistoryWrap.contactHistory.OkyakusamaChuiJikoAnchiRyokinAnnai__c = true;
        sts.contactHistoryWrap.contactHistory.OkyakusamaChuiJikoPlannaiShikijoShiryory__c = true;
        sts.contactHistoryWrap.contactHistory.OkyakusamaChuiJikoKasojoShiyoryoPlangai__c = true;
        sts.contactHistoryWrap.contactHistory.OkyakusamaChuiJikoHansoKyori50km__c = true;
        sts.contactHistoryWrap.contactHistory.OkyakusamaChuiJikoHansoKaisu2KaiOr3Kai__c = true;
        sts.contactHistoryWrap.contactHistory.OkyakusamaChuiJikoChokusoPlanMenkaiFuka__c = true;
        sts.contactHistoryWrap.contactHistory.OkyakusamaMemberSeido__c = 'test';
        sts.contactHistoryWrap.contactHistory.OkyakusamaJizenSurveyWebAnnai__c = true;
        sts.contactHistoryWrap.contactHistory.OkyakusamaJizenSurveyYusoAnnai__c = true;
        sts.contactHistoryWrap.contactHistory.OkyakusamaJizenSurveyDairiNyuryokuTeian__c = true;
        sts.contactHistoryWrap.contactHistory.OkyakusamaJizenSurveyDairiNyuryokuTeianY__c = 'test';
        sts.contactHistoryWrap.contactHistory.OkyakusamaJizenSurveySodanshaFullNameKan__c = true;
        sts.contactHistoryWrap.contactHistory.OkyakusamaJizenSurveySodanshaFullName__c = true;
        sts.contactHistoryWrap.contactHistory.OkyakusamaJizenSurveySogiKiboChiiki__c = true;
        sts.contactHistoryWrap.contactHistory.OkyakusamaJizenSurveySodanshaJusho__c = true;
        sts.contactHistoryWrap.contactHistory.OkyakusamaJizenSurveySodanshaMail__c = true;
        sts.contactHistoryWrap.contactHistory.OkyakusamaJizenSurveySodanshaMobile__c = true;
        sts.contactHistoryWrap.contactHistory.OkyakusamaJizenSurveyTaishoshaJuminhyo__c = true;
        sts.contactHistoryWrap.contactHistory.OkyakusamaJizenSurveyTaishoshaJotai__c = true;
        sts.contactHistoryWrap.contactHistory.OkyakusamaJizenSurveyTaishoshaZokugara__c = true;
        sts.contactHistoryWrap.contactHistory.OkyakusamaJizenSurveyTaishoshaFullNameKa__c = true;
        sts.contactHistoryWrap.contactHistory.OkyakusamaJizenSurveyTaishoshaFullName__c = true;
        sts.contactHistoryWrap.contactHistory.OkyakusamaSurveywari__c = 'test';
        sts.contactHistoryWrap.contactHistory.OkyakusamaShiryoSeikyuYohi__c = 'test';
        sts.contactHistoryWrap.contactHistory.OkyakusamaSmsShisakuYohi__c = 'test';
        sts.contactHistoryWrap.contactHistory.OkyakusamaTaimenSodanYohi__c = 'test';
        sts.contactHistoryWrap.contactHistory.OkyakusamaOsoshiYoyaku__c = 'test';
        sts.contactHistoryWrap.contactHistory.OkyakusamaKeisatsuAnken__c = 'test';
        sts.contactHistoryWrap.contactHistory.OkyakusamaSosaiFujo__c = 'test';
        sts.contactHistoryWrap.contactHistory.OkyakusamaHenkinHosho__c = 'test';
        sts.contactHistoryWrap.contactHistory.OkyakusamaClaim__c = true;
        sts.contactHistoryWrap.contactHistory.OkyakusamaOndokanTakame__c = true;
        sts.contactHistoryWrap.contactHistory.OkyakusamaTokkijikoComment__c = 'test';
        sts.save();

        Test.startTest();

        ApexPages.currentPage().getParameters().put('otaid', sts.ota.Id);
        ApexPages.currentPage().getParameters().put('oppid', opp.Id);
        ShinkiToiawaseSogiyoConfirmCtl stsc = new ShinkiToiawaseSogiyoConfirmCtl();

        stsc.init();

        ApexPages.currentPage().getParameters().put('isToDoCreate', 'true');
        stsc.beforeStageName = '問合せ受付';
        stsc.beforeSubPhase = 'お客様情報一時聴取/入力中';
        stsc.setPhase();
        stsc.oppUpdate();

        Test.stopTest();
    }

    //issues3806--Start--
    @isTest static void testMethod_case2(){

        Account acc=new Account();
        acc.LastName='AAAdefualt';
        acc.Phone='077-0000-0001';
        acc.MobilePhone__c='777-0000-0001';
        acc.LastNameFurigana__pc = 'タイショウシャ';
        acc.FirstNameFurigana__pc = 'テスト';
        acc.FirstName = 'テスト';
        acc.Gender__pc = '男性';
        acc.BillingState = '東京';
        acc.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId();
        acc.NayoseTaisyoGaiKubun__c = '対象外';
        Database.SaveResult accl = Database.insert(acc);

        Account dacc=new Account();
        dacc.LastName='xxxdefualt';
        dacc.Phone='088-0000-0001';
        dacc.MobilePhone__c='888-0000-0001';
        dacc.LastNameFurigana__pc = 'ショウシャ';
        dacc.FirstNameFurigana__pc = 'テスト';
        dacc.FirstName = 'テスト';
        dacc.Gender__pc = '男性';
        dacc.BillingState = '東京';
        dacc.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId();
        dacc.NayoseTaisyoGaiKubun__c = '対象外';
        Database.SaveResult taishoshai = Database.insert(dacc);

        Account dacc2=new Account();
        dacc2.LastName='yyydefualt';
        dacc2.Phone='099-0000-0001';
        dacc2.MobilePhone__c='999-0000-0001';
        dacc2.LastNameFurigana__pc = 'タイショウ';
        dacc2.FirstNameFurigana__pc = 'テスト';
        dacc2.FirstName = 'テスト';
        dacc2.Gender__pc = '男性';
        dacc2.BillingState = '東京';
        dacc2.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId();
        dacc2.NayoseTaisyoGaiKubun__c = '対象外';
        Database.SaveResult sodanshai = Database.insert(dacc2);

        Opportunity OPP1 = new Opportunity(
            AccountId = sodanshai.getid(),				// お客様・提携先名
            Name = '新規_シンプル安豪',						  // 商談名
            CloseDate = Date.valueOf('2020-06-18'),		 // 完了予定日
            Probability = 0,								// 確度(%)
            StageName = '問合せ受付',							// フェーズ
            TesuryoKeisanzumi__c = false,				   // 手数料計算済
            SurveySendWayHopeSms__c = false,				// アンケートSMS送信希望
            SurveySendWayHopeEmail__c = false,			  // アンケートMail送信希望
            TaishoshaKyojuKeitai__c = '未聴取により不明',
            TaishoushaJokyo__c = '未聴取により不明',
            TaishoshaYomeiKikan__c = '未聴取により不明',
            TaishoshaKyojuKeitaiGenzai__c = '未聴取により不明',
            TaishoushaJokyoGenzai__c = '未聴取により不明',
            TaishoshaYomeiKikanGenzai__c = '未聴取により不明',
            BenefitOneID__c = '111',
            PostalClubKaiinBango__c = '222',
            RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId()
        );
        Database.SaveResult oppi = Database.insert(OPP1);

        Id pricebookId = Test.getStandardPricebookId();
        Product2 prod = new Product2(
            IsActive = true,                                  // 有効
            Name = '【19.12】よりそうのお葬式 一日葬 仏式プラン',               // 商品名
            ShohinKamoku__c = '通常',                           // 商品科目
            SireKingakuKeisanHousiki__c = '設定金額',             // 仕入金額計算方式
            SireKingaku__c = 327800,                          // 仕入金額
            TesuryoKingakuKeisanHoushiki__c = '計算しない',        // 手数料金額計算方式
            HanbaiKaishiBi__c = Date.valueOf('2019-12-26'),   // 販売開始日
            HanbaiSyuryoBi__c = Date.valueOf('2100-12-30')   // 販売終了日
        );
        Database.SaveResult prodi = Database.insert(prod);

        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = prodi.getId(),
            UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        
        List<String> crossSellIdList = new List<String>();
        CrossSellingTeian__c CST = new CrossSellingTeian__c();
        CST.OpportunityRef__c = oppi.getId();
        Database.SaveResult CSTi = Database.insert(CST);
        crossSellIdList.add((String)CSTi.getId());


        Shikugun__c sShikugunj = new Shikugun__c(
            Name = '東京都あきる野市'
        );
        Database.SaveResult Shikugunji = Database.insert(sShikugunj);
        
        OtaiShienSogiyo__c ota = new OtaiShienSogiyo__c();
        ota.OpportunityRef__c = oppi.getId();
        ota.FreeText__c = 'フリーテキスト';
        ota.SodanshaRef__c = accl.getId();
        ota.TaishoshaRef__c = taishoshai.getId();
        ota.KeisatsuAnken__c = true;
        ota.SosaiFujo__c = true;
        ota.TashaAnchi__c = true;
        ota.TaijiAnken__c = true;
        ota.SodanshaSeiKana__c = 'アイ';
        ota.SodanshaMeiKana__c = 'ウエ';
        ota.SodanshaSei__c = '';
        ota.SodanshaMei__c = '';
        ota.SodanshaSeibetsu__c = '女性';
        ota.BenefitOneID__c = '';
        ota.PostalClubKaiinBango__c = '';
        ota.MobilePhone__c = '080-0002-0002';
        ota.Phone__c = '090-0002-0002';
        ota.ShiryoseikyushaPostalCode__c = '150-0022';
        ota.ShiryoseikyushaState__c = '東京都';
        ota.ShiryoseikyushaCity__c = '渋谷区';
        ota.ShiryoseikyushaStreet__c = '恵比寿南';
        ota.TaishoshaSeiKana__c = 'カキ';
        ota.TaishoshaMeiKana__c = 'クケ';
        ota.TaishoshaSei__c = '';
        ota.TaishoshaMei__c = '久家';
        ota.TaishoshaSeibetsu__c = '女性';
        ota.ZokugaraSodanshaNitottenoTaishosha__c = '夫';
        ota.SeinengappiSeireki__c = date.today();
        ota.BotsunengappiSeireki__c = date.today();
        ota.KiboKeishiki__c = '火葬式';
        ota.KiboPlan__c = '無宗教';
        ota.AnchiRyokin2hakuOr3haku__c = true;
        ota.ShikijoShiyoryo2man5senOr5man__c = false;
        ota.KasojoShiyoryo1man5sen__c = true;
        ota.HansoKyori50km__c = false;
        ota.TaishoshaKyojuKeitai__c = 'その他';
        ota.TaishoushaJokyo__c = '健在';
        ota.TaishoshaYomeiKikan__c = '10年以内';
        ota.TaishoshaKyojuKeitaiGenzai__c = 'その他';
        ota.TaishoushaJokyoGenzai__c = '健在';
        ota.TaishoshaYomeiKikanGenzai__c = '10年以内';
        ota.SanretsushaShinzokuFrom__c = 'AAAA';
        ota.SanretsushaShinzokuTo__c = 'AAAA';
        ota.SanretsushaShinzokuigaiFrom__c = 'AAAA';
        ota.SanretsushaShinzokuigaiTo__c = 'AAAA';
        ota.KiboGoanchisaki__c = 'その他';
        ota.GoanchisakiJusho__c = 'AAAA';
        ota.BodaijinoUmu__c = '無';
        ota.HakaUmuKubun__c = '無';
        ota.Syushi__c = 'その他';
        ota.Syuha__c = 'その他';
        ota.MonkArrangements__c = '無';
        ota.Kaimyojuyo__c = '戒名の授与を希望しない';
        ota.Kaimyo__c = '無';
        ota.Ketteisha__c = 'その他';
        ota.Shiharaihouhou__c = '現金';
        ota.YusoYohiShubetsu__c = '不要';
        ota.MailSofuYohi__c = true;
        ota.ShiryoseikyushaMail__c = 'xxxdefualt@test.com';
        ota.FaxSofuYohi__c = true;
        ota.ShiroseikyushaFax__c = '666-0000-0001';
        ota.MemberSeidoGoannaiJokyo__c = '登録拒否';
        ota.SodanshaMemberTourokuZumi__c = true;
        ota.OfferingJokyo__c = 'お迎えフリー';
        ota.OmukaeSakiName__c = 'AAAA';
        ota.OmukaeSakiJusho__c = 'AAAAA';
        ota.TelNoPrimaryKubun__c = Shikugunji.getId();
        ota.PreExecuteArea__c = Shikugunji.getId();
        ota.PreExecuteArea2__c = Shikugunji.getId();
        ota.PreExecuteArea3__c = Shikugunji.getId();
        ota.PreExecuteArea4__c = Shikugunji.getId();
        ota.TaishoshaNoJuminhyoRef__c = Shikugunji.getId();

        Database.SaveResult otai = Database.insert(ota);

        Test.startTest();

        String oppiId = (String)oppi.getId();
        String prodiId = (String)prodi.getId();
        ShinkiToiawaseSogiyoConfirmCtl.insertShohin(oppiId,prodiId);
        ShinkiToiawaseSogiyoConfirmCtl.updateCrossSell(oppiId,crossSellIdList);

        
        ApexPages.currentPage().getParameters().put('otaid', otai.getId());
        ApexPages.currentPage().getParameters().put('oppid', oppi.getId());
        ShinkiToiawaseSogiyoConfirmCtl stsc = new ShinkiToiawaseSogiyoConfirmCtl();
        
        stsc.opp.StageName = '';
        stsc.opp.SubPhase__c = '';

        stsc.init();

        List<SelectOption> TESTcustomPickList = new List<SelectOption>();
        TESTcustomPickList = stsc.customPickList;
        List<SelectOption> TESTcustomPickList2 = new List<SelectOption>();
        TESTcustomPickList2 = stsc.customPickList2;
        stsc.valuePicked = '問合せ受付：3分コール接続待';
        TESTcustomPickList2 = stsc.customPickList2;

        Boolean TESTBoolean = True;
        String returnisMaruBatsuChange = stsc.isMaruBatsuChange(TESTBoolean);
        String returnisYoFuyoChange = stsc.isYoFuyoChange(TESTBoolean);
        String returnisSumiMiChange = stsc.isSumiMiChange(TESTBoolean);

        TESTBoolean = false;
        returnisMaruBatsuChange = stsc.isMaruBatsuChange(TESTBoolean);
        returnisYoFuyoChange = stsc.isYoFuyoChange(TESTBoolean);
        returnisSumiMiChange = stsc.isSumiMiChange(TESTBoolean);

        String TestString = '';
        String returnisAriNashiChange = stsc.isAriNashiChange(TestString);
        TestString = '戒名の授与を希望する';
        returnisAriNashiChange = stsc.isAriNashiChange(TestString);
        TestString = 'AAAA';
        returnisAriNashiChange = stsc.isAriNashiChange(TestString);

        Pagereference returnback = ApexPages.currentPage();
        returnback = stsc.back();

        ApexPages.currentPage().getParameters().put('isToDoCreate', 'true');
        stsc.beforeStageName = '問合せ受付';
        stsc.beforeSubPhase = '3分コール接続待';
        stsc.setPhase();
        stsc.oppUpdate();

        Test.stopTest();

    }
    //issues3806--End--

    @isTest static void testMethod_case3(){

        Case c = new Case();
        c.Status = '対応中';
        c.Origin = '電話';
        c.Priority = '中';
        c.Type = 'サービス利用';
        c.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SimpleYasugoOtoiawase').getRecordTypeId();
        c.ToiawaseDate__c = datetime.now();
        insert c;

        Opportunity opp = [select Id, AccountId, SimpleYasugoRef__r.TaishoshaRef__c from Opportunity where CaseRef__c = :c.Id];

        Account sodansha = new Account(
            LastNameFurigana__pc = 'ソウダンシャ',
            FirstNameFurigana__pc = 'テスト',
            LastName = '相談者',
            FirstName = 'テスト',
            Gender__pc = '男性',
            MobilePhone__c = '080-0001-0001',
            Phone = '090-0001-0001',
            YusenTelNoKubun__c = '携帯1',
            recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId()
            );
        insert sodansha;

        Account taishosha = new Account(
            LastNameFurigana__pc = 'タイショウシャ',
            FirstNameFurigana__pc = 'テスト',
            LastName = '対象者',
            FirstName = 'テスト',
            Gender__pc = '男性',
            recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId()
            );
        insert taishosha;

        opp.AccountId = sodansha.Id;
        opp.SimpleYasugoRef__r.TaishoshaRef__c = taishosha.Id;
        opp.SimpleYasugoRef__r.AnchiRyokin2hakuOr3haku__c = false;
        opp.SimpleYasugoRef__r.ShikijoShiyoryo2man5senOr5man__c = false;
        opp.SimpleYasugoRef__r.KasojoShiyoryo1man5sen__c = true;
        opp.SimpleYasugoRef__r.HansoKyori50km__c = true;
        update opp;

        ApexPages.StandardController stdOpp = new ApexPages.StandardController(opp);

        ShinkiToiawaseSogiyoCtl sts = new ShinkiToiawaseSogiyoCtl(stdOpp);
        sts.init();

        sts.ota.FreeText__c = 'フリーテキスト';
        sts.ota.SodanshaRef__c = sodansha.Id;
        sts.ota.TaishoshaRef__c = taishosha.Id;
        sts.ota.KeisatsuAnken__c = true;
        sts.ota.SosaiFujo__c = true;
        sts.ota.TashaAnchi__c = true;
        sts.ota.TaijiAnken__c = true;
        sts.ota.SodanshaSeiKana__c = 'アイ';
        sts.ota.SodanshaMeiKana__c = 'ウエ';
        sts.ota.SodanshaSei__c = '相';
        sts.ota.SodanshaMei__c = '上';
        sts.ota.SodanshaSeibetsu__c = '男性';
        sts.ota.BenefitOneID__c = '111';
        sts.ota.PostalClubKaiinBango__c = '222';
        sts.ota.MobilePhone__c = '080-0002-0002';
        sts.ota.Phone__c = '090-0002-0002';
        sts.ota.ShiryoseikyushaPostalCode__c = '150-0022';
        sts.ota.ShiryoseikyushaState__c = '東京都';
        sts.ota.ShiryoseikyushaCity__c = '渋谷区';
        sts.ota.ShiryoseikyushaStreet__c = '恵比寿南';
        sts.ota.TaishoshaSeiKana__c = 'カキ';
        sts.ota.TaishoshaMeiKana__c = 'クケ';
        sts.ota.TaishoshaSei__c = '夏季';
        sts.ota.TaishoshaMei__c = '久家';
        sts.ota.TaishoshaSeibetsu__c = '男性';
        sts.ota.ZokugaraSodanshaNitottenoTaishosha__c = '夫';
        sts.ota.SeinengappiSeireki__c = date.today();
        sts.ota.BotsunengappiSeireki__c = date.today();
        sts.ota.KiboKeishiki__c = '火葬式';
        sts.ota.KiboPlan__c = '無宗教';
        sts.ota.AnchiRyokin2hakuOr3haku__c = true;
        sts.ota.ShikijoShiyoryo2man5senOr5man__c = false;
        sts.ota.KasojoShiyoryo1man5sen__c = true;
        sts.ota.HansoKyori50km__c = false;

        sts.contactHistoryWrap.contactHistory.OpportunityRef__c = opp.Id;
        sts.contactHistoryWrap.contactHistory.ContactShubetsu__c = '葬儀社';
        sts.contactHistoryWrap.contactHistory.SogishaTaiosha__c = '決定葬儀社以外';
        sts.contactHistoryWrap.contactHistory.SogishaKetteiSogishaIgaiName__c = 'test';
        sts.contactHistoryWrap.contactHistory.SogishaKetteiSogishaIgaiTantosha__c = 'test';
        sts.contactHistoryWrap.contactHistory.SogishaJuhasshinJokyo__c = '架電';
        sts.contactHistoryWrap.contactHistory.SogishaTel__c = '080-0000-0000';
        sts.contactHistoryWrap.contactHistory.SogishaOmukaeJikan__c = 'test';
        sts.contactHistoryWrap.contactHistory.SogishaTsuyaDate__c = date.today();
        sts.contactHistoryWrap.contactHistory.SogishaTsuyaHour__c = 10;
        sts.contactHistoryWrap.contactHistory.SogishaTsuyaMinute__c = 10;
        sts.contactHistoryWrap.contactHistory.SogishaKokubetsushikiDate__c = date.today();
        sts.contactHistoryWrap.contactHistory.SogishaKokubetsushikiHour__c = 10;
        sts.contactHistoryWrap.contactHistory.SogishaKokubetsushikiMinute__c = 10;
        sts.contactHistoryWrap.contactHistory.SogishaKasoDate__c = date.today();
        sts.contactHistoryWrap.contactHistory.SogishaKasoHour__c = 10;
        sts.contactHistoryWrap.contactHistory.SogishaKasoMinute__c = 10;
        sts.contactHistoryWrap.contactHistory.SogishaPlan__c = 'test';
        sts.contactHistoryWrap.contactHistory.SogishaShiharaiHoho__c = 'test';
        sts.contactHistoryWrap.contactHistory.SogishaSoryoTehai__c = 'test';
        sts.contactHistoryWrap.contactHistory.SogishaSonotaShinchoku__c = 'test';
        sts.contactHistoryWrap.contactHistory.SogishaMitsumorishoSofuRenraku__c = 'test';
        sts.contactHistoryWrap.contactHistory.SogishaSeikyushoSofuRenraku__c = 'test';
        sts.contactHistoryWrap.contactHistory.SogishaTesuryoKingaku__c = 'test';
        sts.contactHistoryWrap.contactHistory.SogishaTeikeiKaijoKibo__c = 'test';
        sts.contactHistoryWrap.contactHistory.SogishaPlanToiawase__c = 'test';
        sts.contactHistoryWrap.contactHistory.SogishaPanfuSofuIrai__c = 'test';
        sts.contactHistoryWrap.contactHistory.SogishaSofubutsu__c = 'test';
        sts.contactHistoryWrap.contactHistory.SogishaPanfuAtena__c = 'test';
        sts.contactHistoryWrap.contactHistory.SogishaPanfuAtesaki__c = 'test';
        sts.contactHistoryWrap.contactHistory.SogishaTaimenSodanKekka__c = 'test';
        sts.contactHistoryWrap.contactHistory.SogishaSogishaTehai__c = 'test';
        sts.contactHistoryWrap.contactHistory.SogishaAkijokyoKakunin__c = 'test';
        sts.contactHistoryWrap.contactHistory.SogishaMitsumorishoSaisoku__c = 'test';
        sts.contactHistoryWrap.contactHistory.SogishaUchiawaseYotei__c = 'test';
        sts.contactHistoryWrap.contactHistory.SogishaMitsumorishoNaiyo__c = 'test';
        sts.contactHistoryWrap.contactHistory.SogishaTaimenSodanIrai__c = 'test';
        sts.contactHistoryWrap.contactHistory.SogishaAtooi__c = 'test';
        sts.contactHistoryWrap.contactHistory.SogishaClaim__c = true;
        sts.contactHistoryWrap.contactHistory.SogishaOndokanTakame__c = true;
        sts.contactHistoryWrap.contactHistory.SogishaTokkijikoComment__c = 'test';
        sts.contactHistoryWrap.contactHistory.SogishaOrikaeshiNaiyo__c = 'test';
        sts.contactHistoryWrap.contactHistory.SogishaOrikaeshiTantoshaName__c = 'test';
        sts.contactHistoryWrap.contactHistory.SogishaOrikaeshiRenrakusaki__c = 'test';
        sts.contactHistoryWrap.contactHistory.SogishaOrikaeshiRenrakuNichijiShitei__c = 'test';
        sts.contactHistoryWrap.contactHistory.SogishaOrikaeshiRenrakuNichiji__c = 'test';
        sts.contactHistoryWrap.contactHistory.SogishaFreeComment__c = 'test';
        // sts.contactHistoryWrap.contactHistory.SogishaKetteiSogishaName__c = 
        // sts.contactHistoryWrap.contactHistory.SogishaKetteiSogishaTantosha__c = 
        sts.save();

        Test.startTest();

        ApexPages.currentPage().getParameters().put('otaid', sts.ota.Id);
        ApexPages.currentPage().getParameters().put('oppid', opp.Id);
        ShinkiToiawaseSogiyoConfirmCtl stsc = new ShinkiToiawaseSogiyoConfirmCtl();

        stsc.init();

        ApexPages.currentPage().getParameters().put('isToDoCreate', 'true');
        stsc.beforeStageName = '問合せ受付';
        stsc.beforeSubPhase = 'お客様情報一時聴取/入力中';
        stsc.setPhase();
        stsc.oppUpdate();

        Test.stopTest();
    }
}