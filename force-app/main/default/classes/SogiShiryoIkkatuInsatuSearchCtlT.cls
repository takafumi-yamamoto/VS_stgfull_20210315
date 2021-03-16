@isTest
private class SogiShiryoIkkatuInsatuSearchCtlT {

    @isTest
    static void testMethod_case1(){ 

        Account dacc=new Account();
        dacc.LastName='xxxdefualt';
        dacc.Phone='088-0000-0001';
        dacc.MobilePhone__c='888-0000-0001';
        dacc.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId();
        Database.SaveResult lsrdacc = Database.insert(dacc);


        //取引先のデータ作成
        Account acc=new Account();
        acc.name='defualt';
        acc.Phone='080-0000-0001';
        acc.MobilePhone__c='080-0000-0001';
        Database.SaveResult lsracc = Database.insert(acc);

        opportunity opp=new opportunity();
        opp.accountid=lsracc.getid();
        opp.Name='test';
        opp.StageName='商談開始';
        opp.Req_Day__c = Date.today();
        opp.CloseDate = Date.today();
        opp.KakuteibiSyodan__c = Date.today();
        opp.Utiagebi__c = Date.today();
        opp.accountid=acc.id;
        opp.TesuryoPartner__c = 5000;
        opp.TaishoushaJokyo__c = '_';
        opp.recordtypeid=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId();
        Database.SaveResult lsropp = Database.insert(opp);
            
        SogiShiryoSofu__c sobj = new SogiShiryoSofu__c(
            OpportunityRef__c = lsropp.getid(),                                     // 商談
            SofuJokyo__c = '印刷待ち',                                              // 送付状況
            SofuShubetsu__c = '郵便',                                             // 送付種別
            YusoShubetsu__c = '速達',                                             // 郵送種別
            Atena__c = 'AAAA',                                                      // 宛名
            PostalCode__c = '141-0031',                                             // 郵便番号
            State__c = '東京都',                                                   // 都道府県
            City__c = '品川区',                                                        // 市区郡
            Street__c = '西五反田',                                                 // 町名・番地
            InsatsubutsuIchiran__c = '送付状; 斎場資料; 見積書; 事前割証書',       // 印刷物一覧
            PamphletYohi__c = '要',                                                  // パンフレット要否
            SofuNichiji__c = Datetime.valueOf('2020-06-30 19:18:00'),               // 送付日時
            TaSofubutsu1__c = 'ベス仏カタログ',                                        // 他送付物1
            IsogiTaio__c = true,                                                    // 急ぎ対応
            SofuShiryoURL__c = 'https://opro.dev.yoriso.com/AAA.pdf',               // 送付資料URL
            HikitsugiJiko__c = 'あいうえお',                                     //引継事項
            InsatsuNichiji__c = Datetime.valueOf('2020-06-30 20:04:00')             // 印刷日時
        );
        Database.SaveResult lsrsobj = Database.insert(sobj);
        
        SogiShiryoSofu__c sobj2 = [select id ,SearchHikitsugiJikoUmu__c from SogiShiryoSofu__c where id = :lsrsobj.getid()];
        system.debug(sobj2);
        

        Shikugun__c Shikugun = new Shikugun__c(
          Name = '愛知県あま市',                     // 市区郡名称
          AreaCode__c = '23237',                 // エリアコード
          ShikugunMei__c = 'あま市',                // 市区郡名
          ShikugunMeiFurigana__c = 'あまし'        // 市区郡名(かな)
        );
        Database.SaveResult lShikugun = Database.insert(Shikugun);

        Test.startTest();

        SogiShiryoIkkatuInsatuSearchCtl ssds = new SogiShiryoIkkatuInsatuSearchCtl();
        ssds.init();
        
        ssds.searchJokenWrapper.SogiShiryoSofuJoken.SofuJokyo__c = '';
        ssds.searchJokenWrapper.SogiShiryoSofuJoken.SofuShubetsu__c = '';
        ssds.searchJokenWrapper.SogiShiryoSofuJoken.SearchKaishibiFrom__c = Date.valueOf('2020-06-30');
        ssds.searchData();
        ssds.resWrapList.get(0).isSelected = true;
        ssds.doInsatsuapex();

        ssds.resWrapList.get(0).isSelected = true;
        ssds.doSoufuZumiapex();

        ssds.SoufujoukyoSelect = '資料作成中';
        ssds.resWrapList.get(0).isSelected = true;
        ssds.doJotaiHenkoapex();


        ssds.searchJokenWrapper.SogiShiryoSofuJoken.SearchKaishibiTo__c = Date.valueOf('2020-06-30');
        ssds.searchData();
        ssds.searchJokenWrapper.SogiShiryoSofuJoken.YusoShubetsu__c = '速達';
        ssds.searchData();
        ssds.searchJokenWrapper.SogiShiryoSofuJoken.PamphletYohi__c = '要';
        ssds.searchData();
        ssds.searchJokenWrapper.SogiShiryoSofuJoken.SofuJokyo__c = '印刷待ち';
        ssds.searchData();
        ssds.searchJokenWrapper.SogiShiryoSofuJoken.SofuShubetsu__c = '郵便';
        ssds.searchData();
        ssds.searchJokenWrapper.SogiShiryoSofuJoken.SearchHikitsugiJikoUmu__c = '文言有';
        ssds.searchData();
        ssds.searchJokenWrapper.SogiShiryoSofuJoken.SearchKinkyudo__c = '急ぎ';
        ssds.searchData();
        ssds.searchJokenWrapper.SearchShodanBangoNyuryoku = '0000000';
        ssds.searchData();
        ssds.searchJokenWrapper.SearchNameNyuryoku = '0000000';
        ssds.searchData();
        ssds.searchJokenWrapper.SogiShiryoSofuJoken.SearchKiboAreaKensaku__c = lShikugun.getid();
        ssds.searchData();
        ssds.searchJokenWrapper.SearchOpp.StageName = 'フォロー';
        ssds.searchData();
        List<String> InsatsuSelect = new List<String>();
        InsatsuSelect.add('送付状');
        InsatsuSelect.add('事前割証書');
        ssds.searchJokenWrapper.InsatsubutsuIchiranSelect = InsatsuSelect;
        ssds.searchData();
        ssds.pSortItem = 'SofuJokyo__c';
        ssds.searchData();
        ssds.pSortKey = 'desc';
        ssds.searchData();

        ssds.searchJokenWrapper.SearchFreeWordNyuryoku = 'あいうえお';
        ssds.searchData();
        
        ssds.searchClear();

        Test.stopTest();
    }
}