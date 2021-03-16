/*
* テスト対象クラス:Ctl_Opportunity
* テスト対象メソッド:processOppStageNameShodanCloseList
*/
@isTest
public class Tes_Opp_pOSSCL {

    @testSetup
    static void initializeTestData() {

        RecordType defualtAccountRT = new RecordTypeDao().selectRecordBySobjectTypeDeveloperName('Account', 'null');
        Account dacc=new Account();
        dacc.LastName='xxxdefualt';
        dacc.Phone='088-0000-0001';
        dacc.MobilePhone__c='888-0000-0001';
        dacc.recordTypeId = defualtAccountRT.Id;
        insert dacc;

        //カスタム設定のTriggerIsActive__cのデータを作成
        TriggerIsActive__c TriggerIsActive=new TriggerIsActive__c();
        TriggerIsActive.name='default';
        TriggerIsActive.isActive__c=true;
        insert TriggerIsActive;

        JizenWariPlan__c JizenWariPlan=new JizenWariPlan__c();
        JizenWariPlan.Code__c='Yoriso';
        insert JizenWariPlan;

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

    /**
     * 商談のフェーズが「商談クローズ」時に、特約店手数料（基本分）に金額が設定されることを確認する
     * （シンプル安豪の場合）
     */

    static testMethod void testCase(){

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
            SeikyuSakiAtena__c = 'システム動作確認用',
            KinyukikanCodeTosha__c = '_', 
            KinyukikanMeiTosha__c = '_', 
            KozaShubetsuTosha__c = '普通', 
            KozaBangoTosha__c = '_',
            KozaMeigiKanaTosha__c = '_',
            KozaMeigiTosha__c = '_',
            ShitenCodeTosha__c = '_',
            ShitenMeiTosha__c = '_'
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
            KeiyakuJokyo__c = '未契約',
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
        insert Keiyaku;

        TesuryoPlan__c tesuryoPlan = new TesuryoPlan__c( 
            Name = '_',  CoreTesuryoPlanId__c = 1, ServiceRef__c = Service_k.Id,
            KobetsuPlanFlag__c = false, TesuryoNebikiSetteiKa__c = false );
        insert tesuryoPlan;

        TesuryoTekiyo__c tesuryoTekiyo = new TesuryoTekiyo__c(
            KeiyakuRef__c = keiyaku.Id,  
            ShoninStatus__c = 'ドラフト',
            TekiyoKaishiBi__c = Date.valueOf('1900-01-01'),
            TesuryoPlanRef__c = tesuryoPlan.Id,
            ServiceRef__c = Service_k.Id);
        insert tesuryoTekiyo;

        tesuryoTekiyo.ShoninStatus__c = '承認済';
        update tesuryoTekiyo;

        Keiyaku.KeiyakuJokyo__c = '契約中';
        Keiyaku.Keiyakukaishibi__c = Date.today();
        Database.SaveResult lsrKeiyaku = Database.update(Keiyaku);

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
        opportunity opp1 = new opportunity(
            AccountId = lsracc.getId(),
            RecordTypeId = oppSYRdId,
            Pricebook2Id = lsrstandardPricebook,
            TorihikiShodanRef__c = lsrtorihikiopp.getId(),
            //SimpleYasugoRef__c = lsrSimpleYasugo.getId(),
            TaishosyaRef__c = lsracc.getId(),
            Name = 'TEST特約店手数料',
            StageName = '問合せ受付',
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
        Database.SaveResult lsropp = Database.insert(opp1);
        
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

        Test.startTest();   

        update SimpleYasugo;

        Test.setMock( HttpCalloutMock.class, new Testing_HttpResponseMock().setStatusCode(200) );
        // 商談商品のデータ作成
        OpportunityLineItem oli = new OpportunityLineItem(
            Product2Id = lsrProdOne.getId(),
            OpportunityId = lsropp.Id,
            Quantity = 1,
            PricebookEntryId = lsrstandardPricebookEntry.Id,
            TotalPrice = 294800
        );
        Database.SaveResult lsroli = Database.insert(oli);
        
        // 商談クローズするために「請求方法」「請求金額」「決済日」を設定
        OkyakusamaSeikyuMeisai__c oOkyakusamaSeikyuMeisai = new OkyakusamaSeikyuMeisai__c(
            RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('OkyakusamaSeikyuMeisai__c','KobetsuSeikyu'),
            OpportunityRef__c = lsropp.Id,
            ServiceSyubetsu__c = 'シンプル安豪',
            SeikyuHouhou__c = 'Partner',
            SeikyuKingaku__c = 294800,
            Kessaibi__c = Date.today(),
            SeikyuHohoCode__c = '1'
        );
        Database.SaveResult lsroOkyakusamaSeikyuMeisai = Database.insert(oOkyakusamaSeikyuMeisai);

        // 商談クローズ
        Opportunity opp3 = [SELECT Id , StageName , ShoriStatus__c , KakuteibiSyodan__c ,Utiagebi__c ,CloseDate FROM Opportunity WHERE Id = :lsropp.getId() ];
        opp3.StageName = '商談クローズ';
        opp3.ShoriStatus__c = '連携中';
        opp3.KiboShiharaiHouhou__c = '現金';
        opp3.Amount = 294800;
        opp3.SimpleYasugoRef__c = opp2.SimpleYasugoRef__c;
        opp3.Req_Day__c = Date.today();
        opp3.KakuteibiSyodan__c = Date.today();
        opp3.Utiagebi__c = Date.today();
        opp3.CloseDate = Date.today();
        update opp3;
        
        /*
        Opportunity opp4 = [SELECT Id , StageName , ShoriStatus__c , KakuteibiSyodan__c ,Utiagebi__c ,CloseDate FROM Opportunity WHERE Id = :lsropp.getId() ];
        opp3.StageName = '施行完了';
        update opp4;

        k_ShohinCategory__c k_ShohinCategory2Up = [SELECT Id , ID__c FROM k_ShohinCategory__c WHERE Id = :lsrShohinCategory_k.getId() ];
        k_ShohinCategory2Up.ID__c = 'chokusou';
        update k_ShohinCategory2Up;

        Opportunity opp5 = [SELECT Id , StageName , ShoriStatus__c , KakuteibiSyodan__c ,Utiagebi__c ,CloseDate FROM Opportunity WHERE Id = :lsropp.getId() ];
        opp5.StageName = '商談クローズ';
        opp5.ShoriStatus__c = '連携中';
        opp5.KiboShiharaiHouhou__c = '現金';
        opp5.Amount = 294800;
        opp5.SimpleYasugoRef__c = opp2.SimpleYasugoRef__c;
        opp5.Req_Day__c = Date.today();
        opp5.KakuteibiSyodan__c = Date.today();
        opp5.Utiagebi__c = Date.today();
        opp5.CloseDate = Date.today();
        update opp5;

		*/
        Opportunity opp6 = [SELECT Id , StageName , ShoriStatus__c , KakuteibiSyodan__c ,Utiagebi__c ,CloseDate, ShitchuYoin__c,ShicchuKakuteibiSyodan__c FROM Opportunity WHERE Id = :lsropp.getId() ];
        opp6.StageName = '失注';
        opp6.ShitchuYoin__c = '提携葬儀社がない';
		list<Opportunity> ListOpp6 = new list<Opportunity>();
        ListOpp6.add(opp6);
        new StageNameShicchu().SetShicchuKakuteibiSyodanSimpleShodan(ListOpp6);
        Test.stopTest();
    }
}