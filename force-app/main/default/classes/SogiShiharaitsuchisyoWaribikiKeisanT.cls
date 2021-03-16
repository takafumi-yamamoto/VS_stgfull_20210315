@isTest
public class SogiShiharaitsuchisyoWaribikiKeisanT {

    @isTest
    static void test_Case1() {
        Utility_Common.isMimicExecAsDataIkouProfile = true;

        Account dacc=new Account();
		dacc.LastName='xxxdefualt';
		dacc.Phone='088-0000-0001';
		dacc.MobilePhone__c='888-0000-0001';
		dacc.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId();
		insert dacc;

        //カスタム設定のTriggerIsActive__cのデータを作成
		TriggerIsActive__c TriggerIsActive=new TriggerIsActive__c();
		TriggerIsActive.name='default';
		TriggerIsActive.isActive__c=false;
        insert TriggerIsActive;
        
        //取引先のデータ作成
        Account acc=new Account();
        acc.name='defualt';
        acc.Phone='080-0000-0001';
        acc.MobilePhone__c='080-0000-0001';
        insert acc;

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
            MailAddress2__c = 'a1b2@aa.com',
            MailAddress__c = 'dev-test+2018@yoriso.com',
            MemberTourokuZumi__c = FALSE,
            KoukokuDmNg__c = FALSE,
            KoukokuFaxNg__c = FALSE,
            JizenwariMemberKa__c = FALSE,
            IsPersonAccount__c = FALSE,
            BetsuinKatsudoKibo__c = FALSE,
            SomeiTorokuKibo__c = FALSE,
            NayoseMailAddress__c = 'a1b2@aa.com',
            NayoseMailAddress2__c = 'dev-test+2018@yoriso.com',
            JushoFubi__c = FALSE,
            PtWebAcceptedDate__c = Date.today(),
            IsOboStLineAcnt__c = FALSE,
            KaihoshiNG__c = FALSE,
            KoukokuMailNg__c = FALSE,
            KoukokuSmsNg__c = FALSE,
            NameYagouFurigana__c = 'システムドウサカクニンヨウ',
            NameShogoFurigana__c = 'システムドウサカクニンヨウ',
            NameShogo__c = 'システム動作確認用',
            SeikyuSakiAtena__c = 'システム動作確認用'
        );
        Database.SaveResult lsracc2 = Database.insert(acc2);

        //パートナー契約の「シンプル安豪契約」データ作成
        Keiyaku__c keiyaku = new Keiyaku__c(
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
        insert keiyaku;
		k_ShohinCategory__c MainCIchinichisobj = new k_ShohinCategory__c(
			Name = '一日葬',	   // 商品カテゴリ名
			 ID__c = 'ichinichi'  // ID
        );
        Database.SaveResult MainCategoryIchinichi = Database.insert(MainCIchinichisobj);
        k_ShohinCategory__c MainCWaribikisobj = new k_ShohinCategory__c(
			Name = '割引',	   // 商品カテゴリ名
			 ID__c = 'waribiki'  // ID
        );
        Database.SaveResult MainCWaribiki= Database.insert(MainCWaribikisobj);
        Pricebook2 standardPricebook = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = true
        );
        update standardPricebook;

        Id pricebookId = Test.getStandardPricebookId();
        k_ShohinSyubetsu__c k_ShohinSyubetsu=new k_ShohinSyubetsu__c();
        k_ShohinSyubetsu.ID__c='1';
        insert k_ShohinSyubetsu;

        Product2 prod = new Product2(
            Name = '【20.11】よりそう家族葬 一日プラン',
            ProductCode = 'SBG-0005006',
            ShohinBango__c='SBG-0005006',
            DataKubun__c='1:通常商品',
            k_ShohinSyubetsuRef__c=k_ShohinSyubetsu.id,
            k_ShohinCategoryRef__c= MainCategoryIchinichi.id,
            isActive = true
        );

        insert prod;

        PricebookEntry pbEntry = new PricebookEntry(
            Pricebook2Id = pricebookId,
            Product2Id = prod.Id,
            UnitPrice = 333300.00,
            IsActive = true
        );
        insert pbEntry;

        Product2 prod2 = new Product2(
            Name = '【20.06】よりそうのお葬式 後葬サポート（よりそう火葬）50,000円',
            ProductCode = 'SBG-0003622',
            ShohinBango__c='SBG-0003622',
            DataKubun__c='3:クーポン',		
            k_ShohinSyubetsuRef__c=k_ShohinSyubetsu.id,
            k_ShohinCategoryRef__c= MainCWaribiki.id,
            isActive = true
        );
        insert prod2;
        
        PricebookEntry pbEntry2 = new PricebookEntry(
            Pricebook2Id = pricebookId,
            Product2Id = prod2.Id,
            UnitPrice = -55000.00,
            IsActive = true
        );
        insert pbEntry2;

        SimpleYasugo__c simpleYasugo1 = new SimpleYasugo__c();
        simpleYasugo1.SeikyushojuryoDay__c = Date.today();
        insert simpleYasugo1;

        Opportunity opp1 = new Opportunity();
        opp1.accountid=acc.id;
        opp1.Name='test1';
        opp1.StageName='施行完了';
        opp1.Req_Day__c = Date.today();
        opp1.CloseDate = Date.today();
        opp1.KakuteibiSyodan__c = Date.today();
        opp1.Utiagebi__c = Date.today();
        opp1.accountid=acc.id;
        opp1.TesuryoPartner__c = 5000;
        opp1.TaishoushaJokyo__c = '_';
        opp1.SimpleYasugoRef__c = simpleYasugo1.Id;
        opp1.recordtypeid=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId();
        insert opp1;

        OpportunityLineItem oli1 = new OpportunityLineItem(
            OpportunityId = opp1.Id,
            Quantity = 1,
            Product2Id = prod.Id,
            PricebookEntryId = pbEntry.Id,
            TotalPrice =  pbEntry.UnitPrice
        );
        insert oli1;

        OpportunityLineItem oli2 = new OpportunityLineItem(
            OpportunityId = opp1.Id,
            Quantity = 1,
            Product2Id = prod2.Id,
            PricebookEntryId = pbEntry2.Id,
            TotalPrice = pbEntry2.UnitPrice
        );
        insert oli2;

        OkyakusamaSeikyuMeisai__c oOkyakusamaSeikyuMeisai=new OkyakusamaSeikyuMeisai__c();
        oOkyakusamaSeikyuMeisai.OpportunityRef__c=opp1.id;
        oOkyakusamaSeikyuMeisai.SeikyuHouhou__c = 'Partner';
        oOkyakusamaSeikyuMeisai.SeikyuKingaku__c = 10000;
        oOkyakusamaSeikyuMeisai.Kessaibi__c = Date.today();
        insert oOkyakusamaSeikyuMeisai;
        
        PatnerUriage__c pturiage = new PatnerUriage__c();
        pturiage.Syodan__c = opp1.Id;
        pturiage.Kingaku__c = -1000;
        insert pturiage;

        new SogiShiharaitsuchisyoWaribikiKeisan().waribikiTotalization(opp1.Id);
    }

    @isTest
    static void test_Case2() {
        Utility_Common.isMimicExecAsDataIkouProfile = true;

        Account dacc=new Account();
		dacc.LastName='xxxdefualt';
		dacc.Phone='088-0000-0001';
		dacc.MobilePhone__c='888-0000-0001';
		dacc.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId();
		insert dacc;

        //カスタム設定のTriggerIsActive__cのデータを作成
		TriggerIsActive__c TriggerIsActive=new TriggerIsActive__c();
		TriggerIsActive.name='default';
		TriggerIsActive.isActive__c=false;
        insert TriggerIsActive;
        
        //取引先のデータ作成
        Account acc=new Account();
        acc.name='defualt';
        acc.Phone='080-0000-0001';
        acc.MobilePhone__c='080-0000-0001';
        insert acc;

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
            MailAddress2__c = 'a1b2@aa.com',
            MailAddress__c = 'dev-test+2018@yoriso.com',
            MemberTourokuZumi__c = FALSE,
            KoukokuDmNg__c = FALSE,
            KoukokuFaxNg__c = FALSE,
            JizenwariMemberKa__c = FALSE,
            IsPersonAccount__c = FALSE,
            BetsuinKatsudoKibo__c = FALSE,
            SomeiTorokuKibo__c = FALSE,
            NayoseMailAddress__c = 'a1b2@aa.com',
            NayoseMailAddress2__c = 'dev-test+2018@yoriso.com',
            JushoFubi__c = FALSE,
            PtWebAcceptedDate__c = Date.today(),
            IsOboStLineAcnt__c = FALSE,
            KaihoshiNG__c = FALSE,
            KoukokuMailNg__c = FALSE,
            KoukokuSmsNg__c = FALSE,
            NameYagouFurigana__c = 'システムドウサカクニンヨウ',
            NameShogoFurigana__c = 'システムドウサカクニンヨウ',
            NameShogo__c = 'システム動作確認用',
            SeikyuSakiAtena__c = 'システム動作確認用'
        );
        Database.SaveResult lsracc2 = Database.insert(acc2);

        //パートナー契約の「シンプル安豪契約」データ作成
        Keiyaku__c keiyaku = new Keiyaku__c(
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
        insert keiyaku;
		k_ShohinCategory__c MainCIchinichisobj = new k_ShohinCategory__c(
			Name = '一日葬',	   // 商品カテゴリ名
			 ID__c = 'ichinichi'  // ID
        );
        Database.SaveResult MainCategoryIchinichi = Database.insert(MainCIchinichisobj);
        k_ShohinCategory__c MainCWaribikisobj = new k_ShohinCategory__c(
			Name = '割引',	   // 商品カテゴリ名
			 ID__c = 'waribiki'  // ID
        );
        Database.SaveResult MainCWaribiki= Database.insert(MainCWaribikisobj);
        Pricebook2 standardPricebook = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = true
        );
        update standardPricebook;

        Id pricebookId = Test.getStandardPricebookId();
        k_ShohinSyubetsu__c k_ShohinSyubetsu=new k_ShohinSyubetsu__c();
        k_ShohinSyubetsu.ID__c='1';
        insert k_ShohinSyubetsu;

        Product2 prod = new Product2(
            Name = '【20.11】よりそう家族葬 一日プラン',
            ProductCode = 'SBG-0005006',
            ShohinBango__c='SBG-0005006',
            DataKubun__c='1:通常商品',
            k_ShohinSyubetsuRef__c=k_ShohinSyubetsu.id,
            k_ShohinCategoryRef__c= MainCategoryIchinichi.id,
            isActive = true
        );

        insert prod;

        PricebookEntry pbEntry = new PricebookEntry(
            Pricebook2Id = pricebookId,
            Product2Id = prod.Id,
            UnitPrice = 333300.00,
            IsActive = true
        );
        insert pbEntry;

        Product2 prod2 = new Product2(
            Name = '【20.06】よりそうのお葬式 後葬サポート（よりそう火葬）50,000円',
            ProductCode = 'SBG-0003622',
            ShohinBango__c='SBG-0003622',
            DataKubun__c='3:クーポン',		
            k_ShohinSyubetsuRef__c=k_ShohinSyubetsu.id,
            k_ShohinCategoryRef__c= MainCWaribiki.id,
            isActive = true
        );
        insert prod2;
        
        PricebookEntry pbEntry2 = new PricebookEntry(
            Pricebook2Id = pricebookId,
            Product2Id = prod2.Id,
            UnitPrice = -55000.00,
            IsActive = true
        );
        insert pbEntry2;

        SimpleYasugo__c simpleYasugo1 = new SimpleYasugo__c();
        simpleYasugo1.SeikyushojuryoDay__c = Date.today();
        insert simpleYasugo1;

        Opportunity opp1 = new Opportunity();
        opp1.accountid=acc.id;
        opp1.Name='test1';
        opp1.StageName='施行完了';
        opp1.Req_Day__c = Date.today();
        opp1.CloseDate = Date.today();
        opp1.KakuteibiSyodan__c = Date.today();
        opp1.Utiagebi__c = Date.today();
        opp1.accountid=acc.id;
        opp1.TesuryoPartner__c = 5000;
        opp1.TaishoushaJokyo__c = '_';
        opp1.SimpleYasugoRef__c = simpleYasugo1.Id;
        opp1.recordtypeid=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId();
        insert opp1;

        OpportunityLineItem oli1 = new OpportunityLineItem(
            OpportunityId = opp1.Id,
            Quantity = 1,
            Product2Id = prod.Id,
            PricebookEntryId = pbEntry.Id,
            TotalPrice =  pbEntry.UnitPrice
        );
        insert oli1;

        OpportunityLineItem oli2 = new OpportunityLineItem(
            OpportunityId = opp1.Id,
            Quantity = 1,
            Product2Id = prod2.Id,
            PricebookEntryId = pbEntry2.Id,
            TotalPrice = pbEntry2.UnitPrice
        );
        insert oli2;

        OkyakusamaSeikyuMeisai__c oOkyakusamaSeikyuMeisai=new OkyakusamaSeikyuMeisai__c();
        oOkyakusamaSeikyuMeisai.OpportunityRef__c=opp1.id;
        oOkyakusamaSeikyuMeisai.SeikyuHouhou__c = 'Partner';
        oOkyakusamaSeikyuMeisai.SeikyuKingaku__c = 10000;
        oOkyakusamaSeikyuMeisai.Kessaibi__c = Date.today();
        insert oOkyakusamaSeikyuMeisai;
        
        PatnerUriage__c pturiage = new PatnerUriage__c();
        pturiage.Syodan__c = opp1.Id;
        pturiage.Kingaku__c = 1000;
        insert pturiage;

        new SogiShiharaitsuchisyoWaribikiKeisan().waribikiTotalization(opp1.Id);
    }
}