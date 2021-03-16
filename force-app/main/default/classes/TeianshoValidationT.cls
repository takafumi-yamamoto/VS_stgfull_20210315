@isTest
private class TeianshoValidationT {

    @testSetup
    static void initializeTestData() {
        Account dacc=new Account();
        dacc.LastName='xxxdefualt';
        dacc.Phone='088-0000-0001';
        dacc.MobilePhone__c='888-0000-0001';
        dacc.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId();
        Database.SaveResult lsrdacc = Database.insert(dacc);
        
        opportunity opp=new opportunity();
        opp.accountid=lsrdacc.getid();
        opp.Name='test';
        opp.StageName='商談開始';
        opp.Req_Day__c = Date.today();
        opp.CloseDate = Date.today();
        opp.KakuteibiSyodan__c = Date.today();
        opp.Utiagebi__c = Date.today();
        opp.TesuryoPartner__c = 5000;
        opp.TaishoushaJokyo__c = '_';
        opp.recordtypeid=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId();
        Database.SaveResult lsropp = Database.insert(opp);
        Achievement__c achivement = new Achievement__c(
            TorihikiSakiRef__c = lsrdacc.getid(),
            SourceShodanRef__c = lsropp.getid(),
            Syubetsu__c = 'YorisoJizenWari',
            YukoFlag__c = true, 
            JizenwariMemberKisanbi__c = Date.today(),
            YukoKaishiBi__c = Date.today()
        );
        Database.SaveResult achiveResult = Database.insert(achivement);
        Account aobj = [select id, Name , AcvmJizenWariMinDate__c,JizenwariKekaKikan__c FROM Account WHERE id = : lsrdacc.getid()];
        SogiShiryoSofu__c sobj = new SogiShiryoSofu__c(
            OpportunityRef__c = lsropp.getid(),										// 商談
            SofuJokyo__c = '印刷待ち',										     // 送付状況
            SofuShubetsu__c = 'メール',												// 送付種別
            YusoShubetsu__c = '速達',												// 郵送種別
            Atena__c = 'AAAA',														// 宛名
            PostalCode__c = '141-0031',												// 郵便番号
            State__c = '東京都',													// 都道府県
            City__c = '品川区',														// 市区郡
            Street__c = '西五反田',													// 町名・番地
            InsatsubutsuIchiran__c = '送付状;斎場資料;提案書;事前割証書',		// 印刷物一覧
            PamphletYohi__c = '要',													// パンフレット要否
            SofuNichiji__c = Datetime.valueOf('2020-06-30 19:18:00'),				// 送付日時
            TaSofubutsu1__c = 'ベス仏カタログ',										// 他送付物1
            TaSofubutsu2__c = 'その他カタログ2',
            TaSofubutsu3__c = 'その他カタログ3',
            IsogiTaio__c = true,													// 急ぎ対応
            SofuShiryoURL__c = '',
            KasoshikiyoMongon__c = false,                                          // 火葬式文言
            HikitsugiJiko__c = 'あいうえお',										//引継事項
            InsatsuNichiji__c = Datetime.valueOf('2020-06-30 20:04:00')				// 印刷日時
        );
        insert sobj;

        MitsumoriTeiansyo__c mitsumori = new MitsumoriTeiansyo__c(ShodanRef__c = opp.Id);
        Insert mitsumori;

        TeianSho__c teiansho = new TeianSho__c (
            Service__c = 'よりそうのお葬式',
            Plan__c = '火葬式　無宗教プラン',
            PlanKihonKingaku__c = 180000,
            PlanKihonKingakZeinuki__c = 170000,
            MemberSeido__c = '事前割 (０～２９日 )',
            KasobaName__c = 'テスト火葬場名',
            KasobaMeisaiKingaku__c = 30000,
            KasobaMeisaiHyokiName__c = '火葬場利用料',
            SogiShiryoSofuRef__c = sobj.Id,
            MitsumoriTeianshoRef__c = mitsumori.Id
        );
        insert teiansho;

        Insert new TriggerIsActive__c( name='default', isActive__c=true );
        Utility_Common.isMimicExecAsDataIkouProfile = false;
    }

    @isTest
    static void doTest_case_1(){

        Opportunity opp = [select Id from Opportunity order by CreatedDate limit 1];
        SogiShiryoSofu__c sobj = [select Id, SofuJokyo__c, (select Id, Plan__c from Teianshos__r) from SogiShiryoSofu__c];
        
        Test.startTest();

        MitsumoriTeiansyo__c mitsumori = new MitsumoriTeiansyo__c(ShodanRef__c = opp.Id);
        Insert mitsumori;
        
        TeianSho__c teiansho1 = new TeianSho__c (
            Service__c = 'よりそうのお葬式',
            Plan__c = '火葬式　無宗教プラン',
            PlanKihonKingaku__c = 180000,
            PlanKihonKingakZeinuki__c = 170000,
            MemberSeido__c = '事前割 (０～２９日 )',
            KasobaName__c = 'テスト火葬場名',
            KasobaMeisaiKingaku__c = 30000,
            KasobaMeisaiHyokiName__c = '火葬場利用料',
            SogiShiryoSofuRef__c = sobj.Id,
            MitsumoriTeianshoRef__c = mitsumori.Id
        );

        try{
            insert teiansho1;
        }
        catch(DmlException e){

        }

        Test.stopTest();
    }

    @isTest
    static void doTest_case_2(){

        SogiShiryoSofu__c sobj = [select Id, SofuJokyo__c, (select Id, Plan__c from Teianshos__r) from SogiShiryoSofu__c];
        
        Test.startTest();

        TeianSho__c teiansho2 = sobj.Teianshos__r.get(0);
        teiansho2.Plan__c = '火葬式　仏式プラン';

        try{
            update teiansho2;
        }
        catch(DmlException e){

        }

        Test.stopTest();
    }


    @isTest
    static void doTest_case_3(){

        Opportunity opp = [select Id from Opportunity order by CreatedDate limit 1];
        SogiShiryoSofu__c sobj = [select Id, SofuJokyo__c, (select Id, Plan__c from Teianshos__r) from SogiShiryoSofu__c];

        Test.startTest();

        try{
            delete sobj.Teianshos__r;
        }
        catch(DmlException e){

        }

        Test.stopTest();
    }
}