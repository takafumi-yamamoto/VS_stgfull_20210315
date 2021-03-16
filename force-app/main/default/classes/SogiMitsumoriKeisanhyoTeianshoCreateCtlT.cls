@isTest
private class SogiMitsumoriKeisanhyoTeianshoCreateCtlT {
    
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
            new Product2(Name = '【19.12】よりそうのお葬式 お葬式予約メンバー割引 (一般葬)', IsActive = true, ShohinBango__c = 'SBG-0003199', k_ServiceRef__c = kServiceList.get(0).Id),
            new Product2(Name = '【20.11】よりそう家族葬 一日プラン', IsActive = true, ShohinBango__c = 'SBG-0005006', k_ServiceRef__c = kServiceList.get(0).Id),
            new Product2(Name = '【20.11】よりそう家族葬 二日プラン', IsActive = true, ShohinBango__c = 'SBG-0005002', k_ServiceRef__c = kServiceList.get(0).Id),
            new Product2(Name = '【20.11】よりそう家族葬 華やかプラン', IsActive = true, ShohinBango__c = 'SBG-0005003', k_ServiceRef__c = kServiceList.get(0).Id),
            new Product2(Name = '【20.11】よりそう火葬式 直葬プラン', IsActive = true, ShohinBango__c = 'SBG-0005007', k_ServiceRef__c = kServiceList.get(0).Id),
            new Product2(Name = '【20.11】よりそう火葬式 標準プラン', IsActive = true, ShohinBango__c = 'SBG-0005005', k_ServiceRef__c = kServiceList.get(0).Id),
            new Product2(Name = '【20.11】葬儀社オプション 火葬場料金', IsActive = true, ShohinBango__c = 'SBG-0005518', k_ServiceRef__c = kServiceList.get(0).Id),
            new Product2(Name = '【20.11】葬儀社オプション 斎場追加料金', IsActive = true, ShohinBango__c = 'SBG-0005519', k_ServiceRef__c = kServiceList.get(0).Id),
            new Product2(Name = '【20.11】よりそう会員割 (家族葬 一日プラン)', IsActive = true, ShohinBango__c = 'SBG-0005101', k_ServiceRef__c = kServiceList.get(0).Id),
            new Product2(Name = '【20.11】よりそう会員割 (家族葬 二日プラン)', IsActive = true, ShohinBango__c = 'SBG-0005102', k_ServiceRef__c = kServiceList.get(0).Id),
            new Product2(Name = '【20.11】よりそう会員割 (家族葬 華やかプラン)', IsActive = true, ShohinBango__c = 'SBG-0005103', k_ServiceRef__c = kServiceList.get(0).Id),
            new Product2(Name = '【20.11】よりそう会員割 (火葬式 直葬プラン)', IsActive = true, ShohinBango__c = 'SBG-0005104', k_ServiceRef__c = kServiceList.get(0).Id),
            new Product2(Name = '【20.11】よりそう会員割 (火葬式 標準プラン)', IsActive = true, ShohinBango__c = 'SBG-0005105', k_ServiceRef__c = kServiceList.get(0).Id),
            new Product2(Name = '【20.11】旧事前割 (2年) 割引 (家族葬 一日プラン)', IsActive = true, ShohinBango__c = 'SBG-0005109', k_ServiceRef__c = kServiceList.get(0).Id),
            new Product2(Name = '【20.11】旧事前割 (2年) 割引 (家族葬 二日プラン)', IsActive = true, ShohinBango__c = 'SBG-0005110', k_ServiceRef__c = kServiceList.get(0).Id),
            new Product2(Name = '【20.11】旧事前割 (2年) 割引 (家族葬 華やかプラン)', IsActive = true, ShohinBango__c = 'SBG-0005111', k_ServiceRef__c = kServiceList.get(0).Id),
            new Product2(Name = '【20.11】旧事前割 (2年) 割引 (火葬式 直葬プラン)', IsActive = true, ShohinBango__c = 'SBG-0005112', k_ServiceRef__c = kServiceList.get(0).Id),
            new Product2(Name = '【20.11】旧事前割 (2年) 割引 (火葬式 標準プラン)', IsActive = true, ShohinBango__c = 'SBG-0005113', k_ServiceRef__c = kServiceList.get(0).Id),
            new Product2(Name = '【20.11】お葬式予約会員割 (家族葬 一日プラン)', IsActive = true, ShohinBango__c = 'SBG-0005114', k_ServiceRef__c = kServiceList.get(0).Id),
            new Product2(Name = '【20.11】お葬式予約会員割 (家族葬 二日プラン)', IsActive = true, ShohinBango__c = 'SBG-0005115', k_ServiceRef__c = kServiceList.get(0).Id),
            new Product2(Name = '【20.11】お葬式予約会員割 (家族葬 華やかプラン)', IsActive = true, ShohinBango__c = 'SBG-0005116', k_ServiceRef__c = kServiceList.get(0).Id),
            new Product2(Name = '【20.11】お葬式予約会員割 (火葬式 直葬プラン)', IsActive = true, ShohinBango__c = 'SBG-0005117', k_ServiceRef__c = kServiceList.get(0).Id),
            new Product2(Name = '【20.11】お葬式予約会員割 (火葬式 標準プラン)', IsActive = true, ShohinBango__c = 'SBG-0005118', k_ServiceRef__c = kServiceList.get(0).Id),
            new Product2(Name = '【20.11】よりそう家族葬 直葬プラン', IsActive = true, ShohinBango__c = 'SBG-0005004', k_ServiceRef__c = kServiceList.get(0).Id),
            new Product2(Name = '【20.11】よりそう家族葬 一日プラン', IsActive = true, ShohinBango__c = 'SBG-0005008', k_ServiceRef__c = kServiceList.get(0).Id),
            new Product2(Name = '【20.11】よりそう家族葬 シンプルプラン', IsActive = true, ShohinBango__c = 'SBG-0005009', k_ServiceRef__c = kServiceList.get(0).Id),
            new Product2(Name = '【20.11】祭壇アップグレード M (家族葬 一日プラン)', IsActive = true, ShohinBango__c = 'SBG-0005401', k_ServiceRef__c = kServiceList.get(0).Id, NameForCustomer__c = '祭壇アップグレード M (家族葬 一日プラン)')
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
            new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = pList.get(27).Id,UnitPrice = 1000,IsActive = true),
            new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = pList.get(28).Id,UnitPrice = 1000,IsActive = true),
            new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = pList.get(29).Id,UnitPrice = 1000,IsActive = true),
            new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = pList.get(30).Id,UnitPrice = 1000,IsActive = true),
            new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = pList.get(31).Id,UnitPrice = 1000,IsActive = true),
            new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = pList.get(32).Id,UnitPrice = 1000,IsActive = true),
            new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = pList.get(33).Id,UnitPrice = 1000,IsActive = true),
            new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = pList.get(34).Id,UnitPrice = 1000,IsActive = true),
            new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = pList.get(35).Id,UnitPrice = 1000,IsActive = true),
            new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = pList.get(36).Id,UnitPrice = 1000,IsActive = true),
            new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = pList.get(37).Id,UnitPrice = 1000,IsActive = true),
            new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = pList.get(38).Id,UnitPrice = 1000,IsActive = true),
            new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = pList.get(39).Id,UnitPrice = 1000,IsActive = true),
            new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = pList.get(40).Id,UnitPrice = 1000,IsActive = true),
            new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = pList.get(41).Id,UnitPrice = 1000,IsActive = true),
            new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = pList.get(42).Id,UnitPrice = 1000,IsActive = true),
            new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = pList.get(43).Id,UnitPrice = 1000,IsActive = true),
            new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = pList.get(44).Id,UnitPrice = 1000,IsActive = true),
            new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = pList.get(45).Id,UnitPrice = 1000,IsActive = true),
            new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = pList.get(46).Id,UnitPrice = 1000,IsActive = true),
            new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = pList.get(47).Id,UnitPrice = 1000,IsActive = true),
            new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = pList.get(48).Id,UnitPrice = 1000,IsActive = true),
            new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = pList.get(49).Id,UnitPrice = 1000,IsActive = true),
            new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = pList.get(50).Id,UnitPrice = 1000,IsActive = true),
            new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = pList.get(51).Id,UnitPrice = 1000,IsActive = true),
            new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = pList.get(52).Id,UnitPrice = 1000,IsActive = true),
            new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = pList.get(53).Id,UnitPrice = 1000,IsActive = true)
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
        SogiShiryoSofu__c shiryo = new SogiShiryoSofu__c(OpportunityRef__c = opp.Id);
        insert shiryo;

        Test.startTest();

        ApexPages.StandardController stdOpp = new ApexPages.StandardController(shiryo);

        SogiMitsumoriKeisanhyoCtl smk = new SogiMitsumoriKeisanhyoCtl(stdOpp);
        smk.init();
        smk.displayKeisanhyoData.ryokinhyoShikiSoryoTehai.keisanhyoMeisai.SltFlg__c = true;
        smk.displayKeisanhyoData.ryokinhyoShikiKaimyojuyo.keisanhyoMeisai.SltFlg__c = true;

        smk.displayKeisanhyoData.ryokinhyoTeianTaisho.keisanhyoMeisai.Kazoku1nichiTeianTaisho__c = true;
        smk.displayKeisanhyoData.ryokinhyoTeianTaisho.keisanhyoMeisai.Kazoku2nichiTeianTaisho__c = true;
        smk.displayKeisanhyoData.ryokinhyoTeianTaisho.keisanhyoMeisai.KazokuhanayakaTeianTaisho__c = true;
        smk.displayKeisanhyoData.ryokinhyoTeianTaisho.keisanhyoMeisai.KasochokusoTeianTaisho__c = true;
        smk.displayKeisanhyoData.ryokinhyoTeianTaisho.keisanhyoMeisai.KasohyojunTeianTaisho__c = true;

        smk.displayKeisanhyoData.ryokinhyoSaidanUpGread.keisanhyoMeisai.SltFlg__c = true;
        smk.displayKeisanhyoData.ryokinhyoSaidanUpGread.keisanhyoMeisai.ItemCode__c = 'SBG-0005401';

        for(SogiMitsumoriKeisanhyoCtl.SwitchRyokinhyoMeisaiWrap wrap : smk.displayKeisanhyoData.ryokinhyoShikiKasobaRyokinList){
            wrap.keisanhyoMeisai.SltFlg__c = true;
        }

        smk.actInsertKeisanhyo();

        SogiMitsumoriKeisanhyoTeianshoCreateCtl smkt = new SogiMitsumoriKeisanhyoTeianshoCreateCtl(stdOpp);
        smkt.init();
        for(SogiMitsumoriKeisanhyoTeianshoCreateCtl.SogiMitsumoriKeisanhyoWrap wrap : smkt.keisanhyoWrapList){
            wrap.isSlt = true;
            wrap.keisanhyoObj.SoryoTehaiKibo__c = '希望する';
            wrap.keisanhyoObj.WaribikiService__c = 'よりそう会員';
        }
        
        smkt.actCreateTeiansho();

        Test.stopTest();
    }

    @isTest static void testMethod_case2(){

        Opportunity opp = [select Id from Opportunity where Name = 'test'];
        SogiShiryoSofu__c shiryo = new SogiShiryoSofu__c(OpportunityRef__c = opp.Id);
        insert shiryo;

        Test.startTest();

        ApexPages.StandardController stdOpp = new ApexPages.StandardController(shiryo);

        SogiMitsumoriKeisanhyoCtl smk = new SogiMitsumoriKeisanhyoCtl(stdOpp);
        smk.init();
        smk.displayKeisanhyoData.ryokinhyoTeianTaisho.keisanhyoMeisai.Kazoku1nichiTeianTaisho__c = true;
        smk.displayKeisanhyoData.ryokinhyoTeianTaisho.keisanhyoMeisai.Kazoku2nichiTeianTaisho__c = true;
        smk.displayKeisanhyoData.ryokinhyoTeianTaisho.keisanhyoMeisai.KazokuhanayakaTeianTaisho__c = true;
        smk.displayKeisanhyoData.ryokinhyoTeianTaisho.keisanhyoMeisai.KasochokusoTeianTaisho__c = true;
        smk.displayKeisanhyoData.ryokinhyoTeianTaisho.keisanhyoMeisai.KasohyojunTeianTaisho__c = true;

        for(SogiMitsumoriKeisanhyoCtl.SwitchRyokinhyoMeisaiWrap wrap : smk.displayKeisanhyoData.ryokinhyoShikiKasobaRyokinList){
            wrap.keisanhyoMeisai.SltFlg__c = true;
        }

        smk.actInsertKeisanhyo();

        SogiMitsumoriKeisanhyoTeianshoCreateCtl smkt = new SogiMitsumoriKeisanhyoTeianshoCreateCtl(stdOpp);
        smkt.init();
        for(SogiMitsumoriKeisanhyoTeianshoCreateCtl.SogiMitsumoriKeisanhyoWrap wrap : smkt.keisanhyoWrapList){
            wrap.isSlt = true;
            wrap.keisanhyoObj.SoryoTehaiKibo__c = '希望する';
            wrap.keisanhyoObj.WaribikiService__c = '旧よりそう会員';
        }
        
        smkt.actCreateTeiansho();

        Test.stopTest();
    }

    @isTest static void testMethod_case3(){

        Opportunity opp = [select Id from Opportunity where Name = 'test'];
        SogiShiryoSofu__c shiryo = new SogiShiryoSofu__c(OpportunityRef__c = opp.Id);
        insert shiryo;

        Test.startTest();

        ApexPages.StandardController stdOpp = new ApexPages.StandardController(shiryo);

        SogiMitsumoriKeisanhyoCtl smk = new SogiMitsumoriKeisanhyoCtl(stdOpp);
        smk.init();
        smk.displayKeisanhyoData.ryokinhyoTeianTaisho.keisanhyoMeisai.Kazoku1nichiTeianTaisho__c = true;
        smk.displayKeisanhyoData.ryokinhyoTeianTaisho.keisanhyoMeisai.Kazoku2nichiTeianTaisho__c = true;
        smk.displayKeisanhyoData.ryokinhyoTeianTaisho.keisanhyoMeisai.KazokuhanayakaTeianTaisho__c = true;
        smk.displayKeisanhyoData.ryokinhyoTeianTaisho.keisanhyoMeisai.KasochokusoTeianTaisho__c = true;
        smk.displayKeisanhyoData.ryokinhyoTeianTaisho.keisanhyoMeisai.KasohyojunTeianTaisho__c = true;

        for(SogiMitsumoriKeisanhyoCtl.SwitchRyokinhyoMeisaiWrap wrap : smk.displayKeisanhyoData.ryokinhyoShikiKasobaRyokinList){
            wrap.keisanhyoMeisai.SltFlg__c = true;
        }

        smk.actInsertKeisanhyo();

        SogiMitsumoriKeisanhyoTeianshoCreateCtl smkt = new SogiMitsumoriKeisanhyoTeianshoCreateCtl(stdOpp);
        smkt.init();
        for(SogiMitsumoriKeisanhyoTeianshoCreateCtl.SogiMitsumoriKeisanhyoWrap wrap : smkt.keisanhyoWrapList){
            wrap.isSlt = true;
            wrap.keisanhyoObj.SoryoTehaiKibo__c = '希望する';
            wrap.keisanhyoObj.WaribikiService__c = 'お葬式予約会員';
        }
        
        smkt.actCreateTeiansho();

        Test.stopTest();
    }

    
}