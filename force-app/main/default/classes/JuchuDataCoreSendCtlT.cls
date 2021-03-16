@isTest
public class JuchuDataCoreSendCtlT {

    private static List<Product2> createProduct2s() {
        k_Service__c k1 = new k_Service__c(
            Name='シンプルなお葬式',
            ID__c='1'
        );
        k_Service__c k2 = new k_Service__c(
            Name='安くて豪華なお葬式',
            ID__c='2'
        );
        List<k_Service__c> kList = new List<k_Service__c>();
        kList.add(k1);
        kList.add(k2);
        insert kList;

        Product2 p1 = new Product2(
            Name = '_',
            IsActive = true,
            ShohinBango__c = '1',
            k_ServiceRef__c = kList.get(0).Id
        );
        Product2 p2 = new Product2(
            Name = '_',
            IsActive = true,
            ShohinBango__c = '2',
            k_ServiceRef__c = kList.get(1).Id
        );
        List<Product2> pList = new List<Product2>();
        pList.add(p1);
        pList.add(p2);
        insert pList;

        return pList;
    }

    private static Account genAcc() {
        return new Account(
            LastName ='TEST',
            FirstName ='特約店手数料対応',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId()
        );
    }

    private static Keiyaku__c createKeiyaku() {
        Account accSogisha = new Account(
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Sogisya').getRecordTypeId(),
            Name = '_'
        );
        insert accSogisha;

        Keiyaku__c theKeiyaku = new Keiyaku__c(
            RecordTypeId = Schema.SObjectType.Keiyaku__c.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId(),
            Teikeisaki__c = accSogisha.Id
        );
        insert theKeiyaku;

        return theKeiyaku;
    }

    private static List<TesuryoTekiyo__c> createTesuryoTekiyos(
        String keiyakuId, Date beforeOneTekiyoSyuryobi
    ) {
        List<TesuryoPlan__c> tesuryoPlans = new List<TesuryoPlan__c>();
        TesuryoPlan__c theTesuryoPlanBeforeOne = new TesuryoPlan__c( CoreTesuryoPlanId__c = 2 );
        tesuryoPlans.add(theTesuryoPlanBeforeOne);
        TesuryoPlan__c theTesuryoPlanCurrent = new TesuryoPlan__c( CoreTesuryoPlanId__c = 6 );
        tesuryoPlans.add(theTesuryoPlanCurrent);
        insert tesuryoPlans;

        List<TesuryoTekiyo__c> tesuryoTekiyos = new List<TesuryoTekiyo__c>();
        TesuryoTekiyo__c theTesuryoTekiyoBeforeOne = new TesuryoTekiyo__c(
            KeiyakuRef__c = keiyakuId,
            TekiyoKaishiBi__c = Date.today().addDays(-365),
            TekiyoSyuryoBi__c = beforeOneTekiyoSyuryobi,
            TesuryoPlanRef__c = tesuryoPlans.get(0).Id,
            ShoninStatus__c = '承認済'
        );
        tesuryoTekiyos.add(theTesuryoTekiyoBeforeOne);
        TesuryoTekiyo__c theTesuryoTekiyoCurrent = new TesuryoTekiyo__c(
            KeiyakuRef__c = keiyakuId,
            TekiyoKaishiBi__c = Date.today().addDays(-10),
            TekiyoSyuryoBi__c = Date.newInstance(2100, 12, 31),
            TesuryoPlanRef__c = tesuryoPlans.get(1).Id,
            ShoninStatus__c = '承認済'
        );
        tesuryoTekiyos.add(theTesuryoTekiyoCurrent);
        insert tesuryoTekiyos;

        return tesuryoTekiyos;
    }

    private static Opportunity genOpp(
        String accId, String taishosyaId,
        Datetime kakuteibi, Date uriagebi
    ) {
        return new Opportunity(
            AccountId = accId,
            RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId(),
            TaishosyaRef__c = taishosyaId,
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
            Req_Day__c = Date.today(),
            CloseDate = Date.today(),
            ClamAri__c = FALSE,
            KakuteibiSyodan__c = kakuteibi,
            KetteiKeinsyaHearingZumi__c = FALSE,
            KiboShiharaiHouhou__c = '現金',
            MosyuTourokuKubun__c = '本人',
            RyosyuAtenaIsSodansha__c = FALSE,
            RyosyuYou__c = FALSE,
            SiryoSeikyoAri__c = FALSE,
            SiryoSoufuSakiIsSoudansya__c = FALSE,
            TryCount__c = 0,
            TryLimit__c = 3,
            Utiagebi__c = uriagebi,
            TesuryoPartner__c = 0,
            SodanshaNameTxt__c = 'TEST特約店手数料対応',
            TaisyousyaNameTxt__c = 'TEST特約店手数料対応',
            KetteiSakiKanaSerch__c = 'TEST特約店手数料対応',
            JimuTesuryo__c = 0
          );
    }

    private static SimpleYasugo__c genSimpleYasugo(
        String simpleYasugoId, String taishoshaId,
        Date seikyushojuryobi
    ) {
        return new SimpleYasugo__c(
            Id = simpleYasugoId,
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
            SeikyushojuryoDay__c = seikyushojuryobi,
            ShiryoSofuJokyo__c  ='未送付',
            SogiPlanToSogiPlanGaKotonaru__c = FALSE,
            SokyakugoPlanHenkoUmu__c = FALSE,
            SougisyaKaisyuAmount__c = 0,
            TaishoshaRef__c = taishoshaId,
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
    }

    static testMethod void test1_success() {

        List<Product2> pList = createProduct2s();

        //取引先の「お客様」データ作成
        Account acc = genAcc();
        Database.SaveResult lsracc = Database.insert(acc);

        Keiyaku__c theKeiyaku = createKeiyaku();

        List<TesuryoTekiyo__c> tesuryoTekiyos = createTesuryoTekiyos(
            theKeiyaku.Id, Date.today().addDays(-11)
        );

        //商談のデータ作成
        opportunity opp1 = genOpp(
            lsracc.getId(), lsracc.getId(),
            Date.today(), Date.today()
        );
        Database.SaveResult lsropp = Database.insert(opp1);

        Opportunity opp = [select Id, SimpleYasugoRef__c from Opportunity where Id = :opp1.Id];

        //シンプル安豪のデータ作成
        SimpleYasugo__c simpleYasugo = genSimpleYasugo(
            opp.SimpleYasugoRef__c, lsracc.getId(),
            Date.today()
        );
        simpleYasugo.SimpleYasugoKeiyakuRef__c = theKeiyaku.Id;
        Database.SaveResult lsrSimpleYasugo = Database.update(simpleYasugo);

        List<String> errMsgs = JuchuDataCoreSendCtl.sltCheckOpportunity(opp1.Id);
        System.assertEquals(errMsgs.size(), 0);
        JuchuDataCoreSendCtl.doJuchuDataCoreSend(opp1.Id);
    }

    static testMethod void test2_validation_error_required() {
        Insert new TriggerIsActive__c( name='default', isActive__c=true );
        Insert new JizenWariPlan__c( Code__c='Yoriso' );
        Insert new Account(
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId(),
            FirstName = '_', LastName = '_'
        );

        List<Product2> pList = createProduct2s();

        PricebookEntry pe1 = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(),
            Product2Id = pList.get(0).Id,
            UnitPrice = 1000,
            IsActive = true
        );
        PricebookEntry pe2 = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(),
            Product2Id = pList.get(1).Id,
            UnitPrice = 1000,
            IsActive = true
        );
        List<PricebookEntry> peList = new List<PricebookEntry>();
        peList.add(pe1);
        peList.add(pe2);
        insert peList;

        //取引先の「お客様」データ作成
        Account acc = genAcc();
        Database.SaveResult lsracc = Database.insert(acc);

        Keiyaku__c theKeiyaku = createKeiyaku();

        List<TesuryoTekiyo__c> tesuryoTekiyos = createTesuryoTekiyos(
            theKeiyaku.Id, Date.today().addDays(-11)
        );

        //商談のデータ作成
        opportunity opp1 = genOpp(
            lsracc.getId(), lsracc.getId(),
            null, null
        );
        opp1.Pricebook2Id = Test.getStandardPricebookId();
        opp1.Amount = 12345;
        Database.SaveResult lsropp = Database.insert(opp1);

        Opportunity opp = [select Id, SimpleYasugoRef__c from Opportunity where Id = :opp1.Id];

        //シンプル安豪のデータ作成
        SimpleYasugo__c simpleYasugo = genSimpleYasugo(
            opp.SimpleYasugoRef__c, lsracc.getId(),
            null
        );
        Database.SaveResult lsrSimpleYasugo = Database.update(simpleYasugo);

        OpportunityLineItem oli1 = new OpportunityLineItem(
            OpportunityId = opp.Id,
            Product2Id = pList.get(0).Id,
            TotalPrice = 1000
        );
        OpportunityLineItem oli2 = new OpportunityLineItem(
            OpportunityId = opp.Id,
            Product2Id = pList.get(1).Id,
            TotalPrice = 1000
        );
        List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();
        oliList.add(oli1);
        oliList.add(oli2);
        Insert oliList;

        List<String> errMsgs = JuchuDataCoreSendCtl.sltCheckOpportunity(opp1.Id);
        System.assertEquals(errMsgs.get(0), '【確定日】を入力してください');
        System.assertEquals(errMsgs.get(1), '【売上日】を入力してください');
        System.assertEquals(errMsgs.get(2), '【請求書受領日】を入力してください');
        System.assertEquals(errMsgs.get(3), '【請求残高】を￥0にしてください');
        System.assertEquals(errMsgs.get(4), '異なるサービスの商品が設定されています');
    }

    static testMethod void test3_validation_error_no_valid_tesuryotekiyo() {

        List<Product2> pList = createProduct2s();

        //取引先の「お客様」データ作成
        Account acc = genAcc();
        Database.SaveResult lsracc = Database.insert(acc);

        Keiyaku__c theKeiyaku = createKeiyaku();

        List<TesuryoTekiyo__c> tesuryoTekiyos = createTesuryoTekiyos(
            theKeiyaku.Id, Date.today().addDays(-12)
        );

        //商談のデータ作成
        opportunity opp1 = genOpp(
            lsracc.getId(), lsracc.getId(),
            Date.today().addDays(-11), Date.today()
        );
        Database.SaveResult lsropp = Database.insert(opp1);

        Opportunity opp = [select Id, SimpleYasugoRef__c from Opportunity where Id = :opp1.Id];

        //シンプル安豪のデータ作成
        SimpleYasugo__c simpleYasugo = genSimpleYasugo(
            opp.SimpleYasugoRef__c, lsracc.getId(),
            Date.today()
        );
        simpleYasugo.SimpleYasugoKeiyakuRef__c = theKeiyaku.Id;
        Database.SaveResult lsrSimpleYasugo = Database.update(simpleYasugo);

        List<String> errMsgs = JuchuDataCoreSendCtl.sltCheckOpportunity(opp1.Id);
        System.assertEquals(errMsgs.get(0), '確定日に対して、アクティブな手数料適用がありません');
    }

    static testMethod void test4_validation_error_duplicate_valid_tesuryotekiyo() {

        List<Product2> pList = createProduct2s();

        //取引先の「お客様」データ作成
        Account acc = genAcc();
        Database.SaveResult lsracc = Database.insert(acc);

        Keiyaku__c theKeiyaku = createKeiyaku();

        List<TesuryoTekiyo__c> tesuryoTekiyos = createTesuryoTekiyos(
            theKeiyaku.Id, Date.newInstance(2100, 12, 30)
        );

        //商談のデータ作成
        opportunity opp1 = genOpp(
            lsracc.getId(), lsracc.getId(),
            Date.today().addDays(-10), Date.today()
        );
        Database.SaveResult lsropp = Database.insert(opp1);

        Opportunity opp = [select Id, SimpleYasugoRef__c from Opportunity where Id = :opp1.Id];

        //シンプル安豪のデータ作成
        SimpleYasugo__c simpleYasugo = genSimpleYasugo(
            opp.SimpleYasugoRef__c, lsracc.getId(),
            Date.today()
        );
        simpleYasugo.SimpleYasugoKeiyakuRef__c = theKeiyaku.Id;
        Database.SaveResult lsrSimpleYasugo = Database.update(simpleYasugo);

        List<String> errMsgs = JuchuDataCoreSendCtl.sltCheckOpportunity(opp1.Id);
        System.assertEquals(errMsgs.get(0), 'アクティブな手数料適用が複数存在しています');
    }
}