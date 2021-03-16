@isTest
public class RsCoreKaikeiApi_T {
    
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

        KaiinkibanSetting__c Kaiinkibandefault = new KaiinkibanSetting__c(
            Name = 'default',
            client_id__c = '5',
            client_secret__c = 'EwbX0FwZGwnOHuvjty9PvjVIxbbNGeLDpeEqnmPh',
            grant_type__c = 'client_credentials',
            timeOutPeriod__c = 60000,
            Endpoint__c = 'https://dev-rakuso-core-api-external.minrevi.jp',
            KeiyakuCoreFlag__c = TRUE,
            IsShisetsuRenkeiYuko__c= TRUE,
            isActive__c= TRUE
        );
        insert Kaiinkibandefault;

        KaiinkibanSetting__c Kaiinkibandev = new KaiinkibanSetting__c(
            Name = 'dev',
            client_id__c = '5',
            client_secret__c = 'EwbX0FwZGwnOHuvjty9PvjVIxbbNGeLDpeEqnmPh',
            grant_type__c = 'client_credentials',
            timeOutPeriod__c = 60000,
            Endpoint__c = 'https://dev-rakuso-core-api-external.minrevi.jp',
            KeiyakuCoreFlag__c = TRUE,
            IsShisetsuRenkeiYuko__c= TRUE,
            isActive__c= TRUE
        );
        insert Kaiinkibandev;

        KaiinkibanSetting__c Kaiinkibanprod = new KaiinkibanSetting__c(
            Name = 'prod',
            client_id__c = '5',
            client_secret__c = 'EwbX0FwZGwnOHuvjty9PvjVIxbbNGeLDpeEqnmPh',
            grant_type__c = 'client_credentials',
            timeOutPeriod__c = 60000,
            Endpoint__c = 'https://dev-rakuso-core-api-external.minrevi.jp',
            KeiyakuCoreFlag__c = TRUE,
            IsShisetsuRenkeiYuko__c= TRUE,
            isActive__c= TRUE
        );
        insert Kaiinkibanprod;

        Insert new List<KaiinkibanSetting__c>{
            new KaiinkibanSetting__c(
                name='dev',
                client_id__c='',
                client_secret__c='',
                grant_type__c='',
                timeOutPeriod__c=60000,
                Endpoint__c='http://dev2-rakuso-coreapi-external-alb-767861573.ap-northeast-1.elb.amazonaws.com/',
                KeiyakuCoreFlag__c=true,
                isActive__c=true
            ),
            new KaiinkibanSetting__c(
                name='prod',
                client_id__c='',
                client_secret__c='',
                grant_type__c='',
                timeOutPeriod__c=60000,
                Endpoint__c='http://dev2-rakuso-coreapi-external-alb-767861573.ap-northeast-1.elb.amazonaws.com/',
                KeiyakuCoreFlag__c=true,
                isActive__c=true
            )
        };

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

        //標準価格表取得
        Id lsrstandardPricebook = Test.getStandardPricebookId();

        k_Service__c MainSsobj = new k_Service__c(
            Name = 'シンプルなお葬式',// サービス名
            ID__c = '1'             // ID
        );
        Database.SaveResult MainService = Database.insert(MainSsobj);
        
        k_ShohinCategory__c MainCsobj = new k_ShohinCategory__c(
            Name = '火葬式',    // 商品カテゴリ名
            ID__c = 'kasou' // ID
        );
        Database.SaveResult MainCategory = Database.insert(MainCsobj);
        
        k_ShohinSyubetsu__c MainShohin = new k_ShohinSyubetsu__c(
            Name = '本体（委託）',                    // 商品種別名
            ID__c = '1',                                // ID
            KeijouSyubetsu__c = 'グロス'   // 計上種別
        );
        Database.SaveResult MainSyubetsu = Database.insert(MainShohin);
        
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
            HanbaiKaishiBi__c = Date.valueOf('2019-12-01'),  // 販売開始日
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
            HanbaiKaishiBi__c = Date.valueOf('2019-12-01'),                  // 販売開始日
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
        Database.SaveResult lsrstandardPricebookEntry2 = Database.insert(sPEntry2);
        
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
            HanbaiKaishiBi__c = Date.valueOf('2019-12-01'),  // 販売開始日
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
        Database.SaveResult lsrstandardPricebookEntry3 = Database.insert(sPEntry3);

        k_WaribikiPlan__c WARIBIKI13sobj = new k_WaribikiPlan__c(
            Name = '事前割メンバー (30日未満) + 式後アンケート',// 割引プラン名
            ID__c = '13'                                                // ID
        );
        Database.SaveResult WARIBIKI13 = Database.insert(WARIBIKI13sobj);
        
        Product2 WARIBIKIHenkansobj = new Product2(
            ShohinBango__c = 'SBG-0003542',                                                                      // 商品番号
            IsActive = false,                                                                                                        // 有効
            Name = '【19.12】よりそうのお葬式 事前割メンバー割引 (火葬式) (30日未満) + 式後アンケート割引',                // 商品名
            NameForCustomer__c = 'よりそうのお葬式 事前割メンバー割引 (火葬式) (30日未満) + 式後アンケート割引',    // お客様向け商品名
            ShohinKamoku__c = '通常',                                                                                          // 商品科目
            SireKingakuKeisanHousiki__c = '設定金額',                                                                // 仕入金額計算方式
            SireKingaku__c = -11000,                                                                                             // 仕入金額
            TesuryoKingakuKeisanHoushiki__c = '計算しない',                                                      // 手数料金額計算方式
            TesuryoKingaku__c = 0,                                                                                              // 手数料金額
            TesuryoCyoseiKingakuKeisanHoushiki__c = '計算しない',                                            // 手数料調整金額計算方式
            HanbaiKaishiBi__c = Date.valueOf('2019-11-30'),                                          // 販売開始日
            HanbaiSyuryoBi__c = Date.valueOf('2100-12-30'),                                          // 販売終了日
            DataKubun__c = DATA_KUBUN_2,                                                                                         // データ区分
            k_ServiceRef__c = MainService.getId(),                                                                  // k_サービス
            k_ShohinCategoryRef__c = waribikiCategory.getId(),                                                   // k_商品カテゴリ
            k_ShohinSyubetsuRef__c = waribikiSyubetsu.getId(),                                                   // k_商品種別
            k_WaribikiPlan__c = WARIBIKI13.getId(),                                                             // k_割引プラン
            BunruiKensakuTag__c = '@@',                                                                                  // 分類検索タグ
            IsKingakuHenkouFuka__c = false,                                                                          // 金額変更不可
            SougiPlan__c = false                                                                                                 // 葬儀プラン
        );

        Database.SaveResult WARIBIKIHenkan = Database.insert(WARIBIKIHenkansobj);

        //価格表エントリオブジェクトに価格エントリ番号「StandardSBG-0003542」のデータを作成
        PricebookEntry sPEntry4 = new PricebookEntry(
            Pricebook2Id = lsrstandardPricebook,
            Product2Id = WARIBIKIHenkan.getId(),
            UnitPrice = -11000,
            UseStandardPrice = FALSE,
            IsActive = true,
            KakakuEntryBango__c = 'StandardSBG-0003542'
        );
        Database.SaveResult lsrstandardPricebookEntry4 = Database.insert(sPEntry4);

        k_Coupon__c Couponsobj = new k_Coupon__c(
            Name = '【19.12】よりそうのお葬式 オファリング 5,000円値引き',// クーポン名
            ID__c = '22'                                                             // ID
        );
        Database.SaveResult Coupon = Database.insert(Couponsobj);

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
            HanbaiKaishiBi__c = Date.valueOf('2019-12-01'),  // 販売開始日
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
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId()
        );
        Database.SaveResult lsracc = Database.insert(acc);

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
            AccountId = lsracc.getId(),
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
            AccountId = lsracc.getId(),
            RecordTypeId = Schema.getGlobalDescribe().get('Opportunity').getDescribe().getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId(),
            Pricebook2Id = lsrstandardPricebook,
            TorihikiShodanRef__c = lsrtorihikiopp.getId(),
            TaishosyaRef__c = lsracc.getId(),
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
        Database.SaveResult lsropp = Database.insert(opp1);
        
        //シンプル安豪のデータ更新
        opportunity opp2 = [SELECT Id , SimpleYasugoRef__c FROM Opportunity WHERE Id = :lsropp.getId() limit 1];

        System.test.startTest();  

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
            TaishoshaRef__c = lsracc.getId(),
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
            KeisatsuAnkenKenanryo__c = FALSE
        );

        update SimpleYasugo;

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
            Product2Id = WAP.getId(),
            OpportunityId = opp2.Id,
            Quantity = 1,
            PricebookEntryId = lsrstandardPricebookEntry2.Id,
            UnitPrice = -5500
            //TotalPrice = -5500
        );
        Listoitem.add(oli2);

        // 商談商品のデータ作成
        OpportunityLineItem oli3 = new OpportunityLineItem(
            Product2Id = WASP.getId(),
            OpportunityId = opp2.Id,
            Quantity = 1,
            PricebookEntryId = lsrstandardPricebookEntry3.Id,
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


        RsCoreKaikeiApi_JucyuDenpyoServices.JucyuDenpyoService service = new RsCoreKaikeiApi_JucyuDenpyoServices.JucyuDenpyoService();    

        Opportunity opp3 = [select Id, 
                                    IsWon, 
                                    ShodanBangoF__c, 
                                    SeikyuYoteiGakuPartnerExp__c, 
                                    SeikyushoHassoubiPartner__c, 
                                    Utiagebi__c, 
                                    SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__c, 
                                    NyukinSimekiriBiPartner__c
                           from Opportunity 
                           where Id = :opp2.Id];
        RsCoreKaikeiApi_JucyuDenpyoServices.JucyuDenpyoBuilder serJDB = new RsCoreKaikeiApi_JucyuDenpyoServices.JucyuDenpyoBuilder(opp3.Id);
        RsCoreKaikeiApi_JucyuDenpyoServices.JucyuDenpyoResult serJDR = serJDB.createByOppData();

        Test.setMock( HttpCalloutMock.class, new Testing_HttpResponseMock().setStatusCode(200) );
        service.runTesuryoKeisanProc(opp3);
        service.runProc(opp3);
        
        System.test.stopTest();
    }
    
    static testMethod void testCase2(){
        //標準価格表取得
        Id lsrstandardPricebook = Test.getStandardPricebookId();

        k_Service__c MainSsobj = new k_Service__c(
            Name = 'お坊さん便',// サービス名
            ID__c = '3'             // ID
        );
        Database.SaveResult MainService = Database.insert(MainSsobj);
        
        k_ShohinCategory__c MainCsobj = new k_ShohinCategory__c(
            Name = 'お坊さん便移行',    // 商品カテゴリ名
            ID__c = 'obou-ikou' // ID
        );
        Database.SaveResult MainCategory = Database.insert(MainCsobj);
        
        k_ShohinSyubetsu__c MainShohin = new k_ShohinSyubetsu__c(
            Name = '本体（手配）',                    // 商品種別名
            ID__c = '2',                                // ID
            KeijouSyubetsu__c = 'ネット'   // 計上種別
        );
        Database.SaveResult MainSyubetsu = Database.insert(MainShohin);
        
        Product2 MAINsobj = new Product2(
            ShohinBango__c = 'SBG-0000211',                              // 商品番号
            IsActive = true,                                                                    // 有効
            Name = '[移行データ]　お坊さん便',                         // 商品名
            NameForCustomer__c = 'お坊さん便',            // お客様向け商品名
            ShohinKamoku__c = '通常',                                                  // 商品科目
            SireKingaku__c = 0,                                                 // 仕入金額
            TesuryoKingakuKeisanHoushiki__c = '計算しない',              // 手数料金額計算方式
            TesuryoKingaku__c = 0,                                                      // 手数料金額
            TesuryoCyoseiKingakuKeisanHoushiki__c = '計算しない',    // 手数料調整金額計算方式
            HanbaiKaishiBi__c = Date.valueOf('2019-12-01'),  // 販売開始日
            HanbaiSyuryoBi__c = Date.valueOf('2100-12-31'),  // 販売終了日
            DataKubun__c = '1:通常商品',                                                    // データ区分
            k_ServiceRef__c = MainService.getId(),                          // k_サービス
            k_ShohinCategoryRef__c = MainCategory.getId(),           // k_商品カテゴリ
            k_ShohinSyubetsuRef__c = MainSyubetsu.getId(),           // k_商品種別
            BunruiKensakuTag__c = '@@OCU',                                      // 分類検索タグ
            IsKingakuHenkouFuka__c = false,                                  // 金額変更不可
            SougiPlan__c = false                                                            // 葬儀プラン
        );
        Database.SaveResult MainProduct = Database.insert(MAINsobj);

        //価格表エントリオブジェクトに価格エントリ番号「SBG-0000211」のデータを作成
        PricebookEntry sPEntry = new PricebookEntry(
            Pricebook2Id = lsrstandardPricebook,
            Product2Id = MainProduct.getId(),
            UnitPrice = 0,
            IsActive = true,
            KakakuEntryBango__c = 'StandardSBG-0000211'
        );
        Database.SaveResult lsrstandardPricebookEntry = Database.insert(sPEntry);

        Account okyaku = new Account(
            LastName ='TEST',
            FirstName ='特約店手数料対応',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId()
        );
        Database.SaveResult okyakuAcc = Database.insert(okyaku);

        Account kojin = new Account(
            LastName ='故人様姓',
            FirstName ='故人様名',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId()
        );
        Database.SaveResult kojinAcc = Database.insert(kojin);

        Opportunity sobjOpp = new Opportunity(
            RecordTypeId = Schema.getGlobalDescribe().get('Opportunity').getDescribe().getRecordTypeInfosByDeveloperName().get('Obosanbin').getRecordTypeId(),
            Name = 'TEST',
            SubPhase__c = '仮受注',                                                                     // サブフェーズ
            StageName = '予約',                                                                           // フェーズ
            CloseDate = Date.valueOf('2019-12-24'),                             // 完了予定日
            Req_Day__c = Datetime.valueOf('2019-12-24 17:34:00'),   // 問合せ日
            AccountId = okyakuAcc.getId(),                                               // お客様・提携先名
            Name__c = '自動試験 Ｗｅｂ受付テスト１_お坊さん便',                                           // 商談名
            Probability = 30,                                                                           // 確度(%)
            KetteiPlanName__c = '七回忌法要'                                                  // 決定プラン
        );
        Database.SaveResult Opp = Database.insert(sobjOpp);

        opportunity opp2 = [SELECT Id , ObosanbinRef__c FROM Opportunity WHERE Id = :Opp.getId() limit 1];
        
        Obosanbin__c Obosobj = new Obosanbin__c(
            Id = opp2.ObosanbinRef__c,
            StageName__c = '問合せ受付',                                                                                 // フェーズ
            Status__c = '問合せ受付',                                                                                             // ステータス
            KakuninRenrakuNoKiboUmu__c = '確認連絡を希望しない',                                               // 確認連絡の希望有無
            Riyokaisu__c = '初めて',                                                                                           // 利用回数
            ObosanbinOfuse__c = 0,                                                                                       // お坊さん便-お布施
            ClamAri__c = false,                                                                                             // クレーム有
            TsuikaHoyo__c = '位牌開眼法要',                                                                                   // 追加法要(Web)
            FamilyTempleObtainConsensus__c = false,                                                     // 菩提寺合意チェック
            MemorialServicePlan__c = '七回忌法要',                                                                   // お坊さん便-プラン
            Obon__c = false,                                                                                                     // お盆
            Hatsubon__c = false,                                                                                             // 初盆
            Kaimyojuyo__c = '戒名の授与を希望する',                                                                           // 戒名の授与
            Kaimyo__c = '信士・信女',                                                                                             // 戒名・法名
            Taishosha1Ref__c = kojinAcc.getId(),                                                            // 対象者1
            ZokugaraSodanshaNitottenoTaishosha1__c = '夫',                                           // 続柄：相談者にとっての対象者1
            HoyoBashoMei__c = '斎場・ホールのテキスト',                                                                     // 法要場所名
            HoyoBashoAddress__c = '1000001 東京都千代田区ちょうめいテスト千代田ａｂｃｄ１２３４５１２３４５',   // 法要場所住所
            SekouConfirmation2__c = false,                                                                       // 施行確認済
            SekouConfirmation__c = false                                                                            // 施行確認
        );
        update Obosobj;

        
        System.test.startTest();  
        // 商談商品のデータ作成
        OpportunityLineItem oli = new OpportunityLineItem(
            Product2Id = MainProduct.getId(),
            OpportunityId = opp2.Id,
            Quantity = 1,
            PricebookEntryId = lsrstandardPricebookEntry.Id,
            UnitPrice = 0
        );
        Database.SaveResult lsroli = Database.insert(oli);
        RsCoreKaikeiApi_JucyuDenpyoServices.JucyuDenpyoBuilder serJDB = new RsCoreKaikeiApi_JucyuDenpyoServices.JucyuDenpyoBuilder(opp2.Id);
        RsCoreKaikeiApi_JucyuDenpyoServices.JucyuDenpyoResult serJDR = serJDB.createByOppData();
        System.test.stopTest();
        
    }

    static testMethod void testCase3(){
        Account Use1 = new Account(
            LastName ='TEST',
            FirstName ='特約店手数料対応',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId()
        );
        Database.SaveResult Use1Acc = Database.insert(Use1);

        Opportunity sobjOpp = new Opportunity(
            RecordTypeId = Schema.getGlobalDescribe().get('Opportunity').getDescribe().getRecordTypeInfosByDeveloperName().get('Seizenkeiyaku').getRecordTypeId(),
            Name = 'TEST',
            StageName = '予約',                                                                           // フェーズ
            CloseDate = Date.valueOf('2019-12-24'),                             // 完了予定日
            Req_Day__c = Datetime.valueOf('2019-12-24 17:34:00'),   // 問合せ日
            AccountId = Use1Acc.getId()                                              // お客様・提携先名
        );
        Database.SaveResult Opp = Database.insert(sobjOpp);

        opportunity opp2 = [SELECT Id , ObosanbinRef__c FROM Opportunity WHERE Id = :Opp.getId() limit 1];
        
        System.test.startTest();  
        RsCoreKaikeiApi_JucyuDenpyoServices.JucyuDenpyoBuilder serJDB = new RsCoreKaikeiApi_JucyuDenpyoServices.JucyuDenpyoBuilder(opp2.Id);
        RsCoreKaikeiApi_JucyuDenpyoServices.JucyuDenpyoResult serJDR = serJDB.createByOppData();
        System.test.stopTest();
        
    }
    
    static testMethod void testCase4(){

        Account okyaku = new Account(
            LastName ='TEST',
            FirstName ='特約店手数料対応',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId()
        );
        Database.SaveResult okyakuAcc = Database.insert(okyaku);

        Account kojin = new Account(
            LastName ='故人様姓',
            FirstName ='故人様名',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId()
        );
        Database.SaveResult kojinAcc = Database.insert(kojin);

        Opportunity sobjOpp = new Opportunity(
            RecordTypeId = Schema.getGlobalDescribe().get('Opportunity').getDescribe().getRecordTypeInfosByDeveloperName().get('PerpetualMemorial').getRecordTypeId(),
            Name = 'TEST',
            SubPhase__c = '遺骨到着待ち-eitai',                                                                    // サブフェーズ
            StageName = '予約',                                                                           // フェーズ
            CloseDate = Date.valueOf('2019-12-24'),                             // 完了予定日
            Req_Day__c = Datetime.valueOf('2019-12-24 17:34:00'),   // 問合せ日
            KakuteibiSyodan__c = Datetime.valueOf('2019-10-21 0:00:00'),  // 確定日
            AccountId = okyakuAcc.getId(),                                               // お客様・提携先名
            Name__c = '𠮷田 克友_永代供養',                                            // 商談名
            Probability = 100                                                                           // 確度(%)
        );
        Database.SaveResult Opp = Database.insert(sobjOpp);

        opportunity opp2 = [SELECT Id , EitaiKuyoRef__c FROM Opportunity WHERE Id = :Opp.getId() limit 1];
        
        EitaiKuyo__c EitaiKuyosobj = new EitaiKuyo__c(
            Id = opp2.EitaiKuyoRef__c,
            StageName__c = '問合せ受付',                       // フェーズ
            DoishoJuryobi__c = Date.valueOf('2019-10-18'),  // 同意書受領日
            ClamAri__c = false,                             // クレーム有
            YoteiNinzuKojin__c = 1,                       // 予定人数（故人）
            TaishoshaRef__c = kojinAcc.getId(),            // 対象者
            ZokugaraSodanshaNitottenoTaishosha__c = '母',    // 続柄：相談者にとっての対象者
            KakuteiPlan__c = '永代供養墓',                       // 確定プラン
            IkotsuHikiwatashiHoho__c = '郵送'                // 遺骨引き渡し方法
        );

        update EitaiKuyosobj;

        
        System.test.startTest();  
        RsCoreKaikeiApi_JucyuDenpyoServices.JucyuDenpyoBuilder serJDB = new RsCoreKaikeiApi_JucyuDenpyoServices.JucyuDenpyoBuilder(opp2.Id);
        RsCoreKaikeiApi_JucyuDenpyoServices.JucyuDenpyoResult serJDR = serJDB.createByOppData();
        System.test.stopTest();
        
    }
    
    static testMethod void testCase5(){

        Account okyaku = new Account(
            LastName ='TEST',
            FirstName ='特約店手数料対応',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId()
        );
        Database.SaveResult okyakuAcc = Database.insert(okyaku);

        Account kojin = new Account(
            LastName ='故人様姓',
            FirstName ='故人様名',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId()
        );
        Database.SaveResult kojinAcc = Database.insert(kojin);

        Opportunity sobjOpp = new Opportunity(
            RecordTypeId = Schema.getGlobalDescribe().get('Opportunity').getDescribe().getRecordTypeInfosByDeveloperName().get('SougiRev').getRecordTypeId(),
            Name = 'TEST',
            SubPhase__c = '遺骨到着待ち-eitai',                                                                    // サブフェーズ
            StageName = '予約',                                                                           // フェーズ
            CloseDate = Date.valueOf('2019-12-24'),                             // 完了予定日
            Req_Day__c = Datetime.valueOf('2019-12-24 17:34:00'),   // 問合せ日
            KakuteibiSyodan__c = Datetime.valueOf('2019-10-21 0:00:00'),  // 確定日
            AccountId = okyakuAcc.getId(),                                               // お客様・提携先名
            Name__c = '𠮷田 克友_永代供養',                                            // 商談名
            Probability = 100                                                                           // 確度(%)
        );
        Database.SaveResult Opp = Database.insert(sobjOpp);

        opportunity opp2 = [SELECT Id , SogiReviRef__c FROM Opportunity WHERE Id = :Opp.getId() limit 1];
        
        SougiRev__c SougiRevsobj = new SougiRev__c(
            Id = opp2.SogiReviRef__c,
            StageName__c = '問合せ受付',                             // [削除]フェーズ
            Status__c = '問合せ受付',                                         // [削除]ステータス
            Syukyo__c = '無宗教',                                           // 宗教(Web受付時)
            CompetitiveQuotes__c = '相見積りなし',                 // 相見積り
            SougiKeishiki__c = '火葬式',                               // 葬儀形式
            Yosan__c = '20万',                                               // 予算
            SinzokuSu__c = '10名',                                       // 親族数
            KaisosyaSu__c = '10名',                                   // 会葬者数
            RyoriHenreihinTehai__c = '必要なし',                 // 料理、返礼品の手配
            KiboAreaStates__c = '埼玉県',                           // ご希望エリア 都道府県
            ShukyoshaNoTehai__c = '必要なし',                       // 宗教者の手配
            FamilyTempleObtainConsensus__c = false, // 菩提寺合意チェック
            Zokugara__c = '母',                                           // 続柄：相談者にとっての対象者
            Anchibasho__c = '自宅以外'                                  // 安置場所
        );
        update SougiRevsobj;

        
        System.test.startTest();  
        RsCoreKaikeiApi_JucyuDenpyoServices.JucyuDenpyoBuilder serJDB = new RsCoreKaikeiApi_JucyuDenpyoServices.JucyuDenpyoBuilder(opp2.Id);
        RsCoreKaikeiApi_JucyuDenpyoServices.JucyuDenpyoResult serJDR = serJDB.createByOppData();
        System.test.stopTest();
        
    }

    static testMethod void testCase6(){

        Account okyaku = new Account(
            LastName ='TEST',
            FirstName ='特約店手数料対応',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId()
        );
        Database.SaveResult okyakuAcc = Database.insert(okyaku);

        Account kojin = new Account(
            LastName ='故人様姓',
            FirstName ='故人様名',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId()
        );
        Database.SaveResult kojinAcc = Database.insert(kojin);

        Opportunity sobjOpp = new Opportunity(
            RecordTypeId = Schema.getGlobalDescribe().get('Opportunity').getDescribe().getRecordTypeInfosByDeveloperName().get('KaiyoUmie').getRecordTypeId(),
            Name = 'TEST',
            SubPhase__c = '遺骨到着待ち-eitai',                                                                    // サブフェーズ
            StageName = '予約',                                                                           // フェーズ
            CloseDate = Date.valueOf('2019-12-24'),                             // 完了予定日
            Req_Day__c = Datetime.valueOf('2019-12-24 17:34:00'),   // 問合せ日
            KakuteibiSyodan__c = Datetime.valueOf('2019-10-21 0:00:00'),  // 確定日
            AccountId = okyakuAcc.getId(),                                               // お客様・提携先名
            Name__c = '𠮷田 克友_永代供養',                                            // 商談名
            Probability = 100                                                                           // 確度(%)
        );
        Database.SaveResult Opp = Database.insert(sobjOpp);

        opportunity opp2 = [SELECT Id , KaiyoSankotsuUmieRef__c FROM Opportunity WHERE Id = :Opp.getId() limit 1];

        KaiyoSankotsuUmie__c Umiesobj = new KaiyoSankotsuUmie__c(
            Id = opp2.KaiyoSankotsuUmieRef__c,
            ClamAri__c = false,                                                  // [削除]クレーム有
            TaishoshaRef__c = okyakuAcc.getId(),                    // 対象者
            ZokugaraSodanshaNitottenoTaishosha__c = '母' // 続柄：相談者にとっての対象者
        );
        
        update Umiesobj;
        
        System.test.startTest();  
        RsCoreKaikeiApi_JucyuDenpyoServices.JucyuDenpyoBuilder serJDB = new RsCoreKaikeiApi_JucyuDenpyoServices.JucyuDenpyoBuilder(opp2.Id);
        RsCoreKaikeiApi_JucyuDenpyoServices.JucyuDenpyoResult serJDR = serJDB.createByOppData();
        System.test.stopTest();
        
    }

    static testMethod void testCase7(){

        Account okyaku = new Account(
            LastName ='TEST',
            FirstName ='特約店手数料対応',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId()
        );
        Database.SaveResult okyakuAcc = Database.insert(okyaku);

        Account kojin = new Account(
            LastName ='故人様姓',
            FirstName ='故人様名',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId()
        );
        Database.SaveResult kojinAcc = Database.insert(kojin);

        Opportunity sobjOpp = new Opportunity(
            RecordTypeId = Schema.getGlobalDescribe().get('Opportunity').getDescribe().getRecordTypeInfosByDeveloperName().get('KakuyasuButsudan').getRecordTypeId(),
            Name = 'TEST',
            SubPhase__c = '入金待ち-best',                                                                   // サブフェーズ
            StageName = '発注準備',                                                                         // フェーズ
            CloseDate = Date.valueOf('2019-12-24'),                             // 完了予定日
            Req_Day__c = Datetime.valueOf('2019-12-24 17:34:00'),   // 問合せ日
            KakuteibiSyodan__c = Datetime.valueOf('2019-10-21 0:00:00'),  // 確定日
            AccountId = okyakuAcc.getId(),                                               // お客様・提携先名
            Name__c = '𠮷田 克友_永代供養',                                            // 商談名
            Probability = 100,                                                                          // 確度(%)
            TaisyousyaNameTxt__c =  '𠮷田 克友_永代供養'
        );
        Database.SaveResult Opp = Database.insert(sobjOpp);

        opportunity opp2 = [SELECT Id , KaiyoSankotsuUmieRef__c FROM Opportunity WHERE Id = :Opp.getId() limit 1];
        
        System.test.startTest();  
        RsCoreKaikeiApi_JucyuDenpyoServices.JucyuDenpyoBuilder serJDB = new RsCoreKaikeiApi_JucyuDenpyoServices.JucyuDenpyoBuilder(opp2.Id);
        RsCoreKaikeiApi_JucyuDenpyoServices.JucyuDenpyoResult serJDR = serJDB.createByOppData();
        System.test.stopTest();
        
    }

    static testMethod void testCase8(){

        Account okyaku = new Account(
            LastName ='TEST',
            FirstName ='特約店手数料対応',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId()
        );
        Database.SaveResult okyakuAcc = Database.insert(okyaku);

        Account kojin = new Account(
            LastName ='故人様姓',
            FirstName ='故人様名',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId()
        );
        Database.SaveResult kojinAcc = Database.insert(kojin);

        Opportunity sobjOpp = new Opportunity(
            RecordTypeId = Schema.getGlobalDescribe().get('Opportunity').getDescribe().getRecordTypeInfosByDeveloperName().get('MosyuDaiko').getRecordTypeId(),
            Name = 'TEST',
            SubPhase__c = '遺骨到着待ち-eitai',                                                                    // サブフェーズ
            StageName = '予約',                                                                           // フェーズ
            CloseDate = Date.valueOf('2019-12-24'),                             // 完了予定日
            Req_Day__c = Datetime.valueOf('2019-12-24 17:34:00'),   // 問合せ日
            KakuteibiSyodan__c = Datetime.valueOf('2019-10-21 0:00:00'),  // 確定日
            AccountId = okyakuAcc.getId(),                                               // お客様・提携先名
            Name__c = '𠮷田 克友_永代供養',                                            // 商談名
            Probability = 100                                                                           // 確度(%)
        );
        Database.SaveResult Opp = Database.insert(sobjOpp);

        opportunity opp2 = [SELECT Id , MosyuDaikoRef__c FROM Opportunity WHERE Id = :Opp.getId() limit 1];

        MosyuDaiko__c Mosyusobj = new MosyuDaiko__c(
            Id = opp2.MosyuDaikoRef__c
        );
        
        update Mosyusobj;
        
        System.test.startTest();  
        RsCoreKaikeiApi_JucyuDenpyoServices.JucyuDenpyoBuilder serJDB = new RsCoreKaikeiApi_JucyuDenpyoServices.JucyuDenpyoBuilder(opp2.Id);
        RsCoreKaikeiApi_JucyuDenpyoServices.JucyuDenpyoResult serJDR = serJDB.createByOppData();
        System.test.stopTest();
        
    }

    static testMethod void testCase9(){

        //標準価格表取得
        Id lsrstandardPricebook = Test.getStandardPricebookId();

        k_Service__c MainSsobj = new k_Service__c(
            Name = 'シンプルなお葬式',// サービス名
            ID__c = '1'             // ID
        );
        Database.SaveResult MainService = Database.insert(MainSsobj);
        
        k_ShohinCategory__c MainCsobj = new k_ShohinCategory__c(
            Name = '火葬式',    // 商品カテゴリ名
            ID__c = 'kasou' // ID
        );
        Database.SaveResult MainCategory = Database.insert(MainCsobj);
        
        k_ShohinSyubetsu__c MainShohin = new k_ShohinSyubetsu__c(
            Name = '本体（委託）',                    // 商品種別名
            ID__c = '1',                                // ID
            KeijouSyubetsu__c = 'グロス'   // 計上種別
        );
        Database.SaveResult MainSyubetsu = Database.insert(MainShohin);
        
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
            HanbaiKaishiBi__c = Date.valueOf('2019-12-01'),  // 販売開始日
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
            HanbaiKaishiBi__c = Date.valueOf('2019-12-01'),                  // 販売開始日
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
        Database.SaveResult lsrstandardPricebookEntry2 = Database.insert(sPEntry2);
        
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
            HanbaiKaishiBi__c = Date.valueOf('2019-12-01'),  // 販売開始日
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
        Database.SaveResult lsrstandardPricebookEntry3 = Database.insert(sPEntry3);

        k_WaribikiPlan__c WARIBIKI13sobj = new k_WaribikiPlan__c(
            Name = '事前割メンバー (30日未満) + 式後アンケート',// 割引プラン名
            ID__c = '13'                                                // ID
        );
        Database.SaveResult WARIBIKI13 = Database.insert(WARIBIKI13sobj);
        
        Product2 WARIBIKIHenkansobj = new Product2(
            ShohinBango__c = 'SBG-0003542',                                                                      // 商品番号
            IsActive = false,                                                                                                        // 有効
            Name = '【19.12】よりそうのお葬式 事前割メンバー割引 (火葬式) (30日未満) + 式後アンケート割引',                // 商品名
            NameForCustomer__c = 'よりそうのお葬式 事前割メンバー割引 (火葬式) (30日未満) + 式後アンケート割引',    // お客様向け商品名
            ShohinKamoku__c = '通常',                                                                                          // 商品科目
            SireKingakuKeisanHousiki__c = '設定金額',                                                                // 仕入金額計算方式
            SireKingaku__c = -11000,                                                                                             // 仕入金額
            TesuryoKingakuKeisanHoushiki__c = '計算しない',                                                      // 手数料金額計算方式
            TesuryoKingaku__c = 0,                                                                                              // 手数料金額
            TesuryoCyoseiKingakuKeisanHoushiki__c = '計算しない',                                            // 手数料調整金額計算方式
            HanbaiKaishiBi__c = Date.valueOf('2019-11-30'),                                          // 販売開始日
            HanbaiSyuryoBi__c = Date.valueOf('2100-12-30'),                                          // 販売終了日
            DataKubun__c = DATA_KUBUN_2,                                                                                         // データ区分
            k_ServiceRef__c = MainService.getId(),                                                                  // k_サービス
            k_ShohinCategoryRef__c = waribikiCategory.getId(),                                                   // k_商品カテゴリ
            k_ShohinSyubetsuRef__c = waribikiSyubetsu.getId(),                                                   // k_商品種別
            k_WaribikiPlan__c = WARIBIKI13.getId(),                                                             // k_割引プラン
            BunruiKensakuTag__c = '@@',                                                                                  // 分類検索タグ
            IsKingakuHenkouFuka__c = false,                                                                          // 金額変更不可
            SougiPlan__c = false                                                                                                 // 葬儀プラン
        );

        Database.SaveResult WARIBIKIHenkan = Database.insert(WARIBIKIHenkansobj);

        //価格表エントリオブジェクトに価格エントリ番号「StandardSBG-0003542」のデータを作成
        PricebookEntry sPEntry4 = new PricebookEntry(
            Pricebook2Id = lsrstandardPricebook,
            Product2Id = WARIBIKIHenkan.getId(),
            UnitPrice = -11000,
            UseStandardPrice = FALSE,
            IsActive = true,
            KakakuEntryBango__c = 'StandardSBG-0003542'
        );
        Database.SaveResult lsrstandardPricebookEntry4 = Database.insert(sPEntry4);

        k_Coupon__c Couponsobj = new k_Coupon__c(
            Name = '【19.12】よりそうのお葬式 オファリング 5,000円値引き',// クーポン名
            ID__c = '22'                                                             // ID
        );
        Database.SaveResult Coupon = Database.insert(Couponsobj);

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
            HanbaiKaishiBi__c = Date.valueOf('2019-12-01'),  // 販売開始日
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
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId()
        );
        Database.SaveResult lsracc = Database.insert(acc);

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
            AccountId = lsracc.getId(),
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
            AccountId = lsracc.getId(),
            RecordTypeId = Schema.getGlobalDescribe().get('Opportunity').getDescribe().getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId(),
            Pricebook2Id = lsrstandardPricebook,
            TorihikiShodanRef__c = lsrtorihikiopp.getId(),
            TaishosyaRef__c = lsracc.getId(),
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
        Database.SaveResult lsropp = Database.insert(opp1);
        
        //シンプル安豪のデータ更新
        opportunity opp2 = [SELECT Id , SimpleYasugoRef__c FROM Opportunity WHERE Id = :lsropp.getId() limit 1];

        System.test.startTest();  

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
            TaishoshaRef__c = lsracc.getId(),
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
            KeisatsuAnkenKenanryo__c = FALSE
        );

        update SimpleYasugo;

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
            Product2Id = WAP.getId(),
            OpportunityId = opp2.Id,
            Quantity = 1,
            PricebookEntryId = lsrstandardPricebookEntry2.Id,
            UnitPrice = -5500
            //TotalPrice = -5500
        );
        Listoitem.add(oli2);

        // 商談商品のデータ作成
        OpportunityLineItem oli3 = new OpportunityLineItem(
            Product2Id = WASP.getId(),
            OpportunityId = opp2.Id,
            Quantity = 1,
            PricebookEntryId = lsrstandardPricebookEntry3.Id,
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

                // 商談商品のデータ作成
        OpportunityLineItem oli5 = new OpportunityLineItem(
            Product2Id = WAP.getId(),
            OpportunityId = opp2.Id,
            Quantity = 1,
            PricebookEntryId = lsrstandardPricebookEntry2.Id,
            UnitPrice = -5500
            //TotalPrice = -5500
        );
        Listoitem.add(oli5);

        List<Database.SaveResult> lsroli = Database.insert(Listoitem);

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


        RsCoreKaikeiApi_JucyuDenpyoServices.JucyuDenpyoService service = new RsCoreKaikeiApi_JucyuDenpyoServices.JucyuDenpyoService();    

        Opportunity opp3 = [select Id, 
                                    IsWon, 
                                    ShodanBangoF__c, 
                                    SeikyuYoteiGakuPartnerExp__c, 
                                    SeikyushoHassoubiPartner__c, 
                                    Utiagebi__c, 
                                    SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__c, 
                                    NyukinSimekiriBiPartner__c
                           from Opportunity 
                           where Id = :opp2.Id];
        RsCoreKaikeiApi_JucyuDenpyoServices.JucyuDenpyoBuilder serJDB = new RsCoreKaikeiApi_JucyuDenpyoServices.JucyuDenpyoBuilder(opp3.Id);
        RsCoreKaikeiApi_JucyuDenpyoServices.JucyuDenpyoResult serJDR = serJDB.createByOppData();

        Test.setMock( HttpCalloutMock.class, new Testing_HttpResponseMock().setStatusCode(200) );
        service.runTesuryoKeisanProc(opp3);
        service.runProc(opp3);
        
        System.test.stopTest();
    }
    
    static testMethod void testCase10(){

        //標準価格表取得
        Id lsrstandardPricebook = Test.getStandardPricebookId();

        k_Service__c MainSsobj = new k_Service__c(
            Name = 'シンプルなお葬式',// サービス名
            ID__c = '1'             // ID
        );
        Database.SaveResult MainService = Database.insert(MainSsobj);
        
        k_ShohinCategory__c MainCsobj = new k_ShohinCategory__c(
            Name = '一日葬',    // 商品カテゴリ名
            ID__c = 'ichinichi' // ID
        );
        Database.SaveResult MainCategory = Database.insert(MainCsobj);
        
        k_ShohinSyubetsu__c MainShohin = new k_ShohinSyubetsu__c(
            Name = '本体（委託）',                    // 商品種別名
            ID__c = '1',                                // ID
            KeijouSyubetsu__c = 'グロス'   // 計上種別
        );
        Database.SaveResult MainSyubetsu = Database.insert(MainShohin);
        
        Product2 MAINsobj = new Product2(
            ShohinBango__c = 'SBG-0005001',                 // 商品番号
            IsActive = true,                                  // 有効
            Name = '【20.11】よりそう家族葬 一日プラン',                    // 商品名
            NameForCustomer__c = 'よりそう火葬式 一日プラン',             // お客様向け商品名
            LatestFlg__c = true,                              // 新商品
            ShohinKamoku__c = '通常',                           // 商品科目
            SireKingakuKeisanHousiki__c = '設定金額',             // 仕入金額計算方式
            SireKingaku__c = 356400,                          // 仕入金額
            TesuryoKingakuKeisanHoushiki__c = '計算しない',        // 手数料金額計算方式
            TesuryoKingaku__c = 0,                            // 手数料金額
            TesuryoCyoseiKingakuKeisanHoushiki__c = '計算しない',  // 手数料調整金額計算方式
            HanbaiKaishiBi__c = Date.valueOf('2020-09-01'),   // 販売開始日
            HanbaiSyuryoBi__c = Date.valueOf('2100-12-30'),   // 販売終了日
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
            UnitPrice = 356400,
            UseStandardPrice = FALSE,
            IsActive = true,
            KakakuEntryBango__c = 'StandardSBG-0005001'
        );
        Database.SaveResult lsrstandardPricebookEntry = Database.insert(sPEntry);

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
            Name = 'よりそう会員割',// 割引プラン名
            ID__c = '27'                          // ID
        );
        Database.SaveResult WaribikiPlan= Database.insert(WaribikiPsobj);
        
        Product2 WARIBIKISYVsobj = new Product2(
            ShohinBango__c = 'SBG-0005101',                 // 商品番号
            IsActive = true,                                  // 有効
            Name = '【20.11】よりそう会員割 (家族葬 一日プラン)',              // 商品名
            NameForCustomer__c = 'よりそう会員割 (家族葬 一日プラン)',       // お客様向け商品名
            LatestFlg__c = true,                              // 新商品
            ShohinKamoku__c = '通常',                           // 商品科目
            SireKingakuKeisanHousiki__c = '設定金額',             // 仕入金額計算方式
            SireKingaku__c = 16500,                           // 仕入金額
            TesuryoKingakuKeisanHoushiki__c = '計算しない',        // 手数料金額計算方式
            TesuryoKingaku__c = 0,                            // 手数料金額
            TesuryoCyoseiKingakuKeisanHoushiki__c = '計算しない',  // 手数料調整金額計算方式
            HanbaiKaishiBi__c = Date.valueOf('2020-09-01'),   // 販売開始日
            HanbaiSyuryoBi__c = Date.valueOf('2100-12-30'),   // 販売終了日
            DataKubun__c = '2:割引プラン',                         // データ区分
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
            UnitPrice = -16500,
            UseStandardPrice = FALSE,
            IsActive = true,
            KakakuEntryBango__c = 'StandardSBG-0005101'
        );
        Database.SaveResult lsrstandardPricebookEntry3 = Database.insert(sPEntry3);

        k_ShohinCategory__c opCsobj = new k_ShohinCategory__c(
            Name = 'よりそうオプション',             // 商品カテゴリ名
            ID__c = 'yoriso-option'  // ID
        );
        Database.SaveResult opCategory = Database.insert(opCsobj);
        
        k_ShohinSyubetsu__c opShohin = new k_ShohinSyubetsu__c(
            Name = 'オプション（委託）',                       // 商品種別名
            ID__c = '3'                          // ID
        );
        Database.SaveResult opSyubetsu= Database.insert(opShohin);
        
        Product2 opYVsobj = new Product2(
            ShohinBango__c = 'SBG-0005413',                 // 商品番号
            IsActive = true,                                  // 有効
            Name = '【20.11】よりそうオプション 枕花 S',                   // 商品名
            NameForCustomer__c = 'よりそうお葬式 オプション 枕花 S',        // お客様向け商品名
            LatestFlg__c = true,                              // 新商品
            ShohinKamoku__c = '通常',                           // 商品科目
            SireKingakuKeisanHousiki__c = '設定金額',             // 仕入金額計算方式
            SireKingaku__c = 5500,                            // 仕入金額
            TesuryoKingakuKeisanHoushiki__c = '計算しない',        // 手数料金額計算方式
            TesuryoKingaku__c = 0,                            // 手数料金額
            TesuryoCyoseiKingakuKeisanHoushiki__c = '計算しない',  // 手数料調整金額計算方式
            HanbaiKaishiBi__c = Date.valueOf('2020-09-01'),   // 販売開始日
            HanbaiSyuryoBi__c = Date.valueOf('2100-12-31'),   // 販売終了日
            DataKubun__c = '1:通常商品',                          // データ区分
            k_ServiceRef__c = MainService.getId(),                          // k_サービス
            k_ShohinCategoryRef__c = opCategory.getId(),           // k_商品カテゴリ
            k_ShohinSyubetsuRef__c = opSyubetsu.getId(),           // k_商品種別
            BunruiKensakuTag__c = '@@',                                          // 分類検索タグ
            IsKingakuHenkouFuka__c = false,                                  // 金額変更不可
            SougiPlan__c = false                                                         // 葬儀プラン
        );
        Database.SaveResult opSP = Database.insert(opYVsobj);
        
        //価格表エントリオブジェクトに価格エントリ番号「StandardSBG-0003527」のデータを作成
        PricebookEntry opPEntry3 = new PricebookEntry(
            Pricebook2Id = lsrstandardPricebook,
            Product2Id = opSP.getId(),
            UnitPrice = 5500,
            UseStandardPrice = FALSE,
            IsActive = true,
            KakakuEntryBango__c = 'StandardSBG-0005413'
        );
        Database.SaveResult lsropEntry3 = Database.insert(opPEntry3);

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
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId()
        );
        Database.SaveResult lsracc = Database.insert(acc);

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
            AccountId = lsracc.getId(),
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
            AccountId = lsracc.getId(),
            RecordTypeId = Schema.getGlobalDescribe().get('Opportunity').getDescribe().getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId(),
            Pricebook2Id = lsrstandardPricebook,
            TorihikiShodanRef__c = lsrtorihikiopp.getId(),
            TaishosyaRef__c = lsracc.getId(),
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
        Database.SaveResult lsropp = Database.insert(opp1);
        
        //シンプル安豪のデータ更新
        opportunity opp2 = [SELECT Id , SimpleYasugoRef__c FROM Opportunity WHERE Id = :lsropp.getId() limit 1];

        System.test.startTest();  

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
            TaishoshaRef__c = lsracc.getId(),
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
            KeisatsuAnkenKenanryo__c = FALSE
        );

        update SimpleYasugo;

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
        OpportunityLineItem oli3 = new OpportunityLineItem(
            Product2Id = WASP.getId(),
            OpportunityId = opp2.Id,
            Quantity = 1,
            PricebookEntryId = lsropEntry3.Id,
            UnitPrice = -5500
            //TotalPrice = -5500
        );
        Listoitem.add(oli3);

        // 商談商品のデータ作成
        OpportunityLineItem oli4 = new OpportunityLineItem(
            Product2Id = opSP.getId(),
            OpportunityId = opp2.Id,
            Quantity = 1,
            PricebookEntryId = lsrstandardPricebookEntry3.Id,
            UnitPrice = 5500
            //TotalPrice = -5500
        );
        Listoitem.add(oli4);

        List<Database.SaveResult> lsroli = Database.insert(Listoitem);

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


        RsCoreKaikeiApi_JucyuDenpyoServices.JucyuDenpyoService service = new RsCoreKaikeiApi_JucyuDenpyoServices.JucyuDenpyoService();    

        Opportunity opp3 = [select Id, 
                                    IsWon, 
                                    ShodanBangoF__c, 
                                    SeikyuYoteiGakuPartnerExp__c, 
                                    SeikyushoHassoubiPartner__c, 
                                    Utiagebi__c, 
                                    SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__c, 
                                    NyukinSimekiriBiPartner__c
                           from Opportunity 
                           where Id = :opp2.Id];
        RsCoreKaikeiApi_JucyuDenpyoServices.JucyuDenpyoBuilder serJDB = new RsCoreKaikeiApi_JucyuDenpyoServices.JucyuDenpyoBuilder(opp3.Id);
        RsCoreKaikeiApi_JucyuDenpyoServices.JucyuDenpyoResult serJDR = serJDB.createByOppData();

        Test.setMock( HttpCalloutMock.class, new Testing_HttpResponseMock().setStatusCode(200) );
        service.runTesuryoKeisanProc(opp3);
        service.runProc(opp3);

        string strJsonBody = serJDB.getJsonBody();

        RsCoreKaikeiApi_JucyuDenpyoServices.Details c_Details = new RsCoreKaikeiApi_JucyuDenpyoServices.Details();
        c_Details.yoriso = 0.0;
        c_Details.sogisha = 0.0;

        RsCoreKaikeiApi_JucyuDenpyoServices.OptionTesuryo c_OptionTesuryo = new RsCoreKaikeiApi_JucyuDenpyoServices.OptionTesuryo();
        c_OptionTesuryo.total = 0.0;
        c_OptionTesuryo.details = c_Details;

        RsCoreKaikeiApi_JucyuDenpyoServices.RestResponseParam c_Param = new RsCoreKaikeiApi_JucyuDenpyoServices.RestResponseParam();
        c_Param.planTesuryo = 0.0;
        c_Param.optionTesuryo = c_OptionTesuryo;
        c_Param.jimuTesuryo = 0.0;
        
        RsCoreKaikeiApi_JucyuDenpyoServices.Deposit c_Deposit = new RsCoreKaikeiApi_JucyuDenpyoServices.Deposit();
        String paymentMasterId = c_Deposit.paymentMasterId;
        String depositSfId = c_Deposit.depositSfId;
        Decimal deposit  = c_Deposit.deposit;

        RsCoreKaikeiApi_JucyuDenpyoServices.Payment c_Payment = new RsCoreKaikeiApi_JucyuDenpyoServices.Payment();
        RsCoreKaikeiApi_JucyuDenpyoServices.Deposit c_Deposit2 = new RsCoreKaikeiApi_JucyuDenpyoServices.Deposit();
        c_Deposit2 = c_Payment.deposit;

        System.test.stopTest();
    }
}