@isTest
private class SougiShiryoSakuseiT {


    @isTest
    static void doTest_case_one(){
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
			OpportunityRef__c = lsropp.getid(),										// 商談
			SofuJokyo__c = '印刷待ち',												// 送付状況
			SofuShubetsu__c = '郵便',												// 送付種別
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
			IsogiTaio__c = true,													// 急ぎ対応
			SofuShiryoURL__c = '',
            HikitsugiJiko__c = 'あいうえお',										//引継事項
            KasoshikiyoMongon__c = false,                                          // 火葬式文言
			InsatsuNichiji__c = Datetime.valueOf('2020-06-30 20:04:00')				// 印刷日時
		);
        Database.SaveResult lsrsobj = Database.insert(sobj);
        Test.setMock( HttpCalloutMock.class, new Testing_HttpResponseOproMock().setStatusCode(200) );
        Test.startTest();
        SougiShiryoSakusei sssi = new SougiShiryoSakusei();
        sssi.postOproPdf(sobj);
        Test.stopTest();
    }

    @isTest
    static void doTest_case_two(){
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
        System.debug('アチーブメントテスト');
        System.debug(achiveResult);
        Account aobj = [select id, Name , AcvmJizenWariMinDate__c,JizenwariKekaKikan__c FROM Account WHERE id = : lsrdacc.getid()];
        System.debug(aobj);
        SogiShiryoSofu__c sobj = new SogiShiryoSofu__c(
			OpportunityRef__c = lsropp.getid(),										// 商談
			SofuJokyo__c = '印刷待ち',												// 送付状況
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
        Database.SaveResult lsrsobj = Database.insert(sobj);
        Saijo__c saijyo = new Saijo__c (
            Name = 'testSaijyo',
            AccessHouhouDensha__c = 'atest\nbtest\nctest',
            AccessHohoKuruma__c = 'testcaraccess',
            AccessHohoBasu__c = 'testbasaccess',
            idokedo__latitude__s = 35.635430,
            idokedo__longitude__s = 139.883852,
            ChushaDaisu__c = 200
        );
        Saijo__c s = new Saijo__c();
        s.SaijoKeisaiJohoIdOld__c = '1111111111';
        s.SimpleHPKeisaiAri__c = false;
		s.Name = 'test';
		s.KeisaiSaijoMeiKana__c = 'テスト';
		s.TokuchoSaijo__c = '特徴';
		s.PostalCode__c = '141-0031';
		s.Street__c = '西五反田2-11-17　HI五反田ビル 4F';
        s.JushoKana__c = 'にしごたんだ';
        s.IdoKedo__Latitude__s = 35.626471;
        s.IdoKedo__longitude__s = 139.722161;
        s.AccessHohoKuruma__c = 'アクセス車';
        s.AccessHohoBasu__c = 'アクセスバス';
        s.AccessHouhouDensha__c = 'アクセス電車\ntest';
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
        Database.SaveResult saijo = Database.insert(s);
        Shisetsu__c shi = new Shisetsu__c(
            ShisetsuShubetsu__c='火葬場',
            Name='テスト用００１',
            State__c='東京都',
            City__c='中央区',
            Street__c='2-2-2',
            PostalCode__c='335-0016',
            Shikugun__c =null,
            KoeiMinei__c='自社'
        );
        Database.SaveResult Shisetsu = Database.insert(shi);
        for(Integer i = 0; i < 10; i++){
            SogiShiryoSofuMeisai__c meisai = new SogiShiryoSofuMeisai__c(
                SaijoRef__c = saijo.getId(),
                ShisetsuRef__c = null,
                ShisetsuKubun__c = '斎場',
                SogiShiryoSofuRef__c = lsrsobj.getId(),
                Hyojijun__c = i + 1
            );
            Database.SaveResult smeisai = Database.insert(meisai);
        }
        for(Integer i = 0; i < 2; i++){
            SogiShiryoSofuMeisai__c kasoumeisai = new SogiShiryoSofuMeisai__c(
                SaijoRef__c = null,
                ShisetsuRef__c = Shisetsu.getId(),
                ShisetsuKubun__c = '火葬場',
                SogiShiryoSofuRef__c = lsrsobj.getId(),
                Hyojijun__c = i + 1
            );
            Database.SaveResult kmeisai = Database.insert(kasoumeisai);
        }
       

        SogiShiryoSofu__c sofu = [select Id, Name, Fax__c, PamphletYohi__c, Mail__c, SofuShiryoURL__c, KasoshikiyoMongon__c,
        PassWord__c, Atena__c, SofuNichiji__c, InsatsubutsuIchiran__c, City__c, OpportunityRef__c, OpportunityRef__r.ShodanBangoF__c,OpportunityRef__r.Account.AcvmJizenWariMinDate__c,OpportunityRef__r.Account.JizenwariKekaKikan__c,
        OpportunityRef__r.Account.Name,SofuShubetsu__c, SofuJokyo__c, Street__c, State__c, YusoShubetsu__c, IsogiTaio__c, PostalCode__c, 
        HosokuSetsumei__c, HikitsugiJiko__c, TaSofubutsu1__c, TaSofubutsu2__c, TaSofubutsu3__c, 
        CreatedBy.LastName, 
        CreatedDate, 
        (
            select Id, 
                    SaijoRef__r.Name, 
                    SaijoRef__r.ShisetsuKubun__c, 
                    SaijoRef__r.ShikugunRef__r.Name, 
                    ShisetsuRef__r.Name, 
                    ShisetsuRef__r.KoeiMinei__c, 
                    ShisetsuRef__r.Shikugun__r.Name, 
                    ShisetsuKubun__c, 
                    SogiShiryoSofuRef__c, 
                    Hyojijun__c 
            from SogiShiryoSofuMeisais__r 
            order by Hyojijun__c 
        ) 
        from SogiShiryoSofu__c where  Id = : lsrsobj.getid() ];
        Test.setMock( HttpCalloutMock.class, new Testing_HttpResponseOproMock().setStatusCode(200) );
        Test.startTest();
        SougiShiryoSakusei sssi = new SougiShiryoSakusei();
        sssi.postOproPdf(sofu);
        Test.stopTest();
    }
    @isTest
    static void doTest_case_three(){
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
        System.debug('アチーブメントテスト');
        System.debug(achiveResult);
        Account aobj = [select id, Name , AcvmJizenWariMinDate__c,JizenwariKekaKikan__c FROM Account WHERE id = : lsrdacc.getid()];
        System.debug(aobj);
        SogiShiryoSofu__c sobj = new SogiShiryoSofu__c(
			OpportunityRef__c = lsropp.getid(),										// 商談
			SofuJokyo__c = '印刷待ち',												// 送付状況
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
        Database.SaveResult lsrsobj = Database.insert(sobj);
        for(Integer i = 0; i < 10; i++){
            Saijo__c s = new Saijo__c();
            s.SaijoKeisaiJohoIdOld__c = '111111111'+i.format();
            s.SimpleHPKeisaiAri__c = false;
            s.Name = 'test'+i.format();
            s.KeisaiSaijoMeiKana__c = 'テスト';
            s.TokuchoSaijo__c = '特徴';
            s.PostalCode__c = '141-0031';
            s.Street__c = '西五反田2-11-17　HI五反田ビル 4F';
            s.JushoKana__c = 'にしごたんだ';
            s.IdoKedo__Latitude__s = 35.626471;
            s.IdoKedo__longitude__s = 139.722161;
            s.AccessHohoKuruma__c = 'アクセス車';
            s.AccessHohoBasu__c = 'アクセスバス';
            if(i == 2){
                s.AccessHouhouDensha__c = 'アクセス電車\ntest';
            }else{
                s.AccessHouhouDensha__c = 'アクセス電車';
            }
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
            Database.SaveResult saijo = Database.insert(s);
            SaijoImg__c saiImg = new SaijoImg__c (
                CoreImgId__c = '1111'+i.format(),
                Purpose__c   = 'gaikan',
                ImageUrl__c  = 'https://cdn-rakuso-core.minrevi.jp/public/facility/144669-top.jpg',
                SaijoRef__c  = saijo.getId()
            );
            Database.SaveResult saijoImg = Database.insert(saiImg);

        
            SogiShiryoSofuMeisai__c meisai = new SogiShiryoSofuMeisai__c(
                SaijoRef__c = saijo.getId(),
                ShisetsuRef__c = null,
                ShisetsuKubun__c = '斎場',
                SogiShiryoSofuRef__c = lsrsobj.getId(),
                Hyojijun__c = i + 1
            );
            Database.SaveResult smeisai = Database.insert(meisai);
        }

        Shisetsu__c shi = new Shisetsu__c(
            ShisetsuShubetsu__c='火葬場',
            Name='テスト用００１',
            State__c='東京都',
            City__c='中央区',
            Street__c='2-2-2',
            PostalCode__c='335-0016',
            AccessHouhouDensha__c = 'test\naaaa',
            Shikugun__c =null,
            KoeiMinei__c='自社'
        );
        Database.SaveResult Shisetsu = Database.insert(shi);
        ShisetsuImg__c sseimg = new ShisetsuImg__c (
            CoreImgId__c = '11111',
            ImageUrl__c = 'https://cdn-rakuso-core.minrevi.jp/public/facility/144669-top.jpg',
            KasobaSaijo__c = 'Kasoba',
            Purpose__c = 'top',
            ShisetsuRef__c = Shisetsu.getId()
        );
        Database.SaveResult simg = Database.insert(sseimg);

        Shisetsu__c shi2 = new Shisetsu__c(
            ShisetsuShubetsu__c='火葬場',
            Name='テスト用００2',
            State__c='東京都',
            City__c='中央区',
            Street__c='2-2-2',
            PostalCode__c='335-0016',
            AccessHouhouDensha__c = 'testaaaa',
            Shikugun__c =null,
            KoeiMinei__c='自社'
        );
        Database.SaveResult Shisetsu2 = Database.insert(shi2);
        ShisetsuImg__c sseimg2 = new ShisetsuImg__c (
            CoreImgId__c = '22222',
            ImageUrl__c = 'https://cdn-rakuso-core.minrevi.jp/public/facility/144669-top.jpg',
            KasobaSaijo__c = 'Kasoba',
            Purpose__c = 'top',
            ShisetsuRef__c = Shisetsu2.getId()
        );
        Database.SaveResult simg2 = Database.insert(sseimg2);

        for(Integer i = 0; i < 2; i++){
            SogiShiryoSofuMeisai__c kasoumeisai = null;
            if(i==2){
                 kasoumeisai = new SogiShiryoSofuMeisai__c(
                    SaijoRef__c = null,
                    ShisetsuRef__c = Shisetsu2.getId(),
                    ShisetsuKubun__c = '火葬場',
                    SogiShiryoSofuRef__c = lsrsobj.getId(),
                    Hyojijun__c = i + 1
                );
            }else{
                 kasoumeisai = new SogiShiryoSofuMeisai__c(
                    SaijoRef__c = null,
                    ShisetsuRef__c = Shisetsu.getId(),
                    ShisetsuKubun__c = '火葬場',
                    SogiShiryoSofuRef__c = lsrsobj.getId(),
                    Hyojijun__c = i + 1
                );
            }
            Database.SaveResult kmeisai = Database.insert(kasoumeisai);
        }
       

        SogiShiryoSofu__c sofu = [select Id, Name, Fax__c, PamphletYohi__c, Mail__c, SofuShiryoURL__c, KasoshikiyoMongon__c,
        PassWord__c, Atena__c, SofuNichiji__c, InsatsubutsuIchiran__c, City__c, OpportunityRef__c, OpportunityRef__r.ShodanBangoF__c,OpportunityRef__r.Account.AcvmJizenWariMinDate__c,OpportunityRef__r.Account.JizenwariKekaKikan__c,
        OpportunityRef__r.Account.Name,SofuShubetsu__c, SofuJokyo__c, Street__c, State__c, YusoShubetsu__c, IsogiTaio__c, PostalCode__c, 
        HosokuSetsumei__c, HikitsugiJiko__c, TaSofubutsu1__c, TaSofubutsu2__c, TaSofubutsu3__c, 
        CreatedBy.LastName, 
        CreatedDate, 
        (
            select Id, 
                    SaijoRef__r.Name, 
                    SaijoRef__r.ShisetsuKubun__c, 
                    SaijoRef__r.ShikugunRef__r.Name, 
                    ShisetsuRef__r.Name, 
                    ShisetsuRef__r.KoeiMinei__c, 
                    ShisetsuRef__r.Shikugun__r.Name, 
                    ShisetsuKubun__c, 
                    SogiShiryoSofuRef__c, 
                    Hyojijun__c 
            from SogiShiryoSofuMeisais__r 
            order by Hyojijun__c 
        ) 
        from SogiShiryoSofu__c where  Id = : lsrsobj.getid() ];
        Test.setMock( HttpCalloutMock.class, new Testing_HttpResponseOproMock().setStatusCode(200) );
        Test.startTest();
        SougiShiryoSakusei sssi = new SougiShiryoSakusei();
        sssi.postOproPdf(sofu);
        Test.stopTest();
    }
    @isTest
    static void doTest_case_four(){
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
        System.debug('アチーブメントテスト');
        System.debug(achiveResult);
        Account aobj = [select id, Name , AcvmJizenWariMinDate__c,JizenwariKekaKikan__c FROM Account WHERE id = : lsrdacc.getid()];
        System.debug(aobj);
        SogiShiryoSofu__c sobj = new SogiShiryoSofu__c(
			OpportunityRef__c = lsropp.getid(),										// 商談
			SofuJokyo__c = '印刷待ち',												// 送付状況
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
            KasoshikiyoMongon__c = false,                                          // 火葬式文言
			SofuShiryoURL__c = '',
			HikitsugiJiko__c = 'あいうえお',										//引継事項
			InsatsuNichiji__c = Datetime.valueOf('2020-06-30 20:04:00')				// 印刷日時
		);
        Database.SaveResult lsrsobj = Database.insert(sobj);
        for(Integer i = 0; i < 8; i++){
            Saijo__c s = new Saijo__c();
            s.SaijoKeisaiJohoIdOld__c = '111111111'+i.format();
            s.SimpleHPKeisaiAri__c = false;
            s.Name = 'test'+i.format();
            s.KeisaiSaijoMeiKana__c = 'テスト';
            s.TokuchoSaijo__c = '特徴';
            s.PostalCode__c = '141-0031';
            s.Street__c = '西五反田2-11-17　HI五反田ビル 4F';
            s.JushoKana__c = 'にしごたんだ';
            s.IdoKedo__Latitude__s = 35.626471;
            s.IdoKedo__longitude__s = 139.722161;
            s.AccessHohoKuruma__c = 'アクセス車';
            s.AccessHohoBasu__c = 'アクセスバス';
            if(i == 2){
                s.AccessHouhouDensha__c = 'アクセス電車\ntest';
            }else{
                s.AccessHouhouDensha__c = 'アクセス電車';
            }
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
            Database.SaveResult saijo = Database.insert(s);
            SaijoImg__c saiImg = new SaijoImg__c (
                CoreImgId__c = '1111'+i.format(),
                Purpose__c   = 'gaikan',
                ImageUrl__c  = 'https://cdn-rakuso-core.minrevi.jp/public/facility/144669-top.jpg',
                SaijoRef__c  = saijo.getId()
            );
            Database.SaveResult saijoImg = Database.insert(saiImg);

        
            SogiShiryoSofuMeisai__c meisai = new SogiShiryoSofuMeisai__c(
                SaijoRef__c = saijo.getId(),
                ShisetsuRef__c = null,
                ShisetsuKubun__c = '斎場',
                SogiShiryoSofuRef__c = lsrsobj.getId(),
                Hyojijun__c = i + 1
            );
            Database.SaveResult smeisai = Database.insert(meisai);
        }

        Shisetsu__c shi = new Shisetsu__c(
            ShisetsuShubetsu__c='火葬場',
            Name='テスト用００１',
            State__c='東京都',
            City__c='中央区',
            Street__c='2-2-2',
            PostalCode__c='335-0016',
            AccessHouhouDensha__c = 'test\naaaa',
            Shikugun__c =null,
            KoeiMinei__c='自社'
        );
        Database.SaveResult Shisetsu = Database.insert(shi);
        ShisetsuImg__c sseimg = new ShisetsuImg__c (
            CoreImgId__c = '11111',
            ImageUrl__c = 'https://cdn-rakuso-core.minrevi.jp/public/facility/144669-top.jpg',
            KasobaSaijo__c = 'Kasoba',
            Purpose__c = 'top',
            ShisetsuRef__c = Shisetsu.getId()
        );
        Database.SaveResult simg = Database.insert(sseimg);

        Shisetsu__c shi2 = new Shisetsu__c(
            ShisetsuShubetsu__c='火葬場',
            Name='テスト用００2',
            State__c='東京都',
            City__c='中央区',
            Street__c='2-2-2',
            PostalCode__c='335-0016',
            AccessHouhouDensha__c = 'testaaaa',
            Shikugun__c =null,
            KoeiMinei__c='自社'
        );
        Database.SaveResult Shisetsu2 = Database.insert(shi2);
        ShisetsuImg__c sseimg2 = new ShisetsuImg__c (
            CoreImgId__c = '22222',
            ImageUrl__c = 'https://cdn-rakuso-core.minrevi.jp/public/facility/144669-top.jpg',
            KasobaSaijo__c = 'Kasoba',
            Purpose__c = 'top',
            ShisetsuRef__c = Shisetsu2.getId()
        );
        Database.SaveResult simg2 = Database.insert(sseimg2);

        for(Integer i = 0; i < 2; i++){
            SogiShiryoSofuMeisai__c kasoumeisai = null;
            if(i==2){
                 kasoumeisai = new SogiShiryoSofuMeisai__c(
                    SaijoRef__c = null,
                    ShisetsuRef__c = Shisetsu2.getId(),
                    ShisetsuKubun__c = '火葬場',
                    SogiShiryoSofuRef__c = lsrsobj.getId(),
                    Hyojijun__c = i + 1
                );
            }else{
                 kasoumeisai = new SogiShiryoSofuMeisai__c(
                    SaijoRef__c = null,
                    ShisetsuRef__c = Shisetsu.getId(),
                    ShisetsuKubun__c = '火葬場',
                    SogiShiryoSofuRef__c = lsrsobj.getId(),
                    Hyojijun__c = i + 1
                );
            }
            Database.SaveResult kmeisai = Database.insert(kasoumeisai);
        }
       

        SogiShiryoSofu__c sofu = [select Id, Name, Fax__c, PamphletYohi__c, Mail__c, SofuShiryoURL__c, KasoshikiyoMongon__c,
        PassWord__c, Atena__c, SofuNichiji__c, InsatsubutsuIchiran__c, City__c, OpportunityRef__c, OpportunityRef__r.ShodanBangoF__c,OpportunityRef__r.Account.AcvmJizenWariMinDate__c,OpportunityRef__r.Account.JizenwariKekaKikan__c,
        OpportunityRef__r.Account.Name,SofuShubetsu__c, SofuJokyo__c, Street__c, State__c, YusoShubetsu__c, IsogiTaio__c, PostalCode__c, 
        HosokuSetsumei__c, HikitsugiJiko__c, TaSofubutsu1__c, TaSofubutsu2__c, TaSofubutsu3__c, 
        CreatedBy.LastName, 
        CreatedDate, 
        (
            select Id, 
                    SaijoRef__r.Name, 
                    SaijoRef__r.ShisetsuKubun__c, 
                    SaijoRef__r.ShikugunRef__r.Name, 
                    ShisetsuRef__r.Name, 
                    ShisetsuRef__r.KoeiMinei__c, 
                    ShisetsuRef__r.Shikugun__r.Name, 
                    ShisetsuKubun__c, 
                    SogiShiryoSofuRef__c, 
                    Hyojijun__c 
            from SogiShiryoSofuMeisais__r 
            order by Hyojijun__c 
        ) 
        from SogiShiryoSofu__c where  Id = : lsrsobj.getid() ];
        Test.setMock( HttpCalloutMock.class, new Testing_HttpResponseOproMock().setStatusCode(200) );
        Test.startTest();
        SougiShiryoSakusei sssi = new SougiShiryoSakusei();
        sssi.postOproPdf(sofu);
        Test.stopTest();
    }
    @isTest
    static void doTest_case_five(){
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
        System.debug('アチーブメントテスト');
        System.debug(achiveResult);
        Account aobj = [select id, Name , AcvmJizenWariMinDate__c,JizenwariKekaKikan__c FROM Account WHERE id = : lsrdacc.getid()];
        System.debug(aobj);
        SogiShiryoSofu__c sobj = new SogiShiryoSofu__c(
			OpportunityRef__c = lsropp.getid(),										// 商談
			SofuJokyo__c = '印刷待ち',												// 送付状況
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
            KasoshikiyoMongon__c = false,                                          // 火葬式文言
			SofuShiryoURL__c = '',
			HikitsugiJiko__c = 'あいうえお',										//引継事項
			InsatsuNichiji__c = Datetime.valueOf('2020-06-30 20:04:00')				// 印刷日時
		);
        Database.SaveResult lsrsobj = Database.insert(sobj);
        for(Integer i = 0; i < 8; i++){
            Saijo__c s = new Saijo__c();
            s.SaijoKeisaiJohoIdOld__c = '111111111'+i.format();
            s.SimpleHPKeisaiAri__c = false;
            s.Name = 'test'+i.format();
            s.KeisaiSaijoMeiKana__c = 'テスト';
            s.TokuchoSaijo__c = '特徴';
            s.PostalCode__c = '141-0031';
            s.Street__c = '西五反田2-11-17　HI五反田ビル 4F';
            s.JushoKana__c = 'にしごたんだ';
            s.IdoKedo__Latitude__s = 35.626471;
            s.IdoKedo__longitude__s = 139.722161;
            s.AccessHohoKuruma__c = 'アクセス車';
            s.AccessHohoBasu__c = 'アクセスバス';
            if(i == 2){
                s.AccessHouhouDensha__c = 'アクセス電車\ntest';
            }else{
                s.AccessHouhouDensha__c = 'アクセス電車';
            }
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
            Database.SaveResult saijo = Database.insert(s);
            SaijoImg__c saiImg = new SaijoImg__c (
                CoreImgId__c = '1111'+i.format(),
                Purpose__c   = 'gaikan',
                ImageUrl__c  = 'https://cdn-rakuso-core.minrevi.jp/public/facility/144669-top.jpg',
                SaijoRef__c  = saijo.getId()
            );
            Database.SaveResult saijoImg = Database.insert(saiImg);

        
            SogiShiryoSofuMeisai__c meisai = new SogiShiryoSofuMeisai__c(
                SaijoRef__c = saijo.getId(),
                ShisetsuRef__c = null,
                ShisetsuKubun__c = '斎場',
                SogiShiryoSofuRef__c = lsrsobj.getId(),
                Hyojijun__c = i + 1
            );
            Database.SaveResult smeisai = Database.insert(meisai);
        }

        Shisetsu__c shi = new Shisetsu__c(
            ShisetsuShubetsu__c='火葬場',
            Name='テスト用００１',
            State__c='東京都',
            City__c='中央区',
            Street__c='2-2-2',
            PostalCode__c='335-0016',
            AccessHouhouDensha__c = 'test\naaaa',
            Shikugun__c =null,
            KoeiMinei__c='自社'
        );
        Database.SaveResult Shisetsu = Database.insert(shi);
        ShisetsuImg__c sseimg = new ShisetsuImg__c (
            CoreImgId__c = '11111',
            ImageUrl__c = 'https://cdn-rakuso-core.minrevi.jp/public/facility/144669-top.jpg',
            KasobaSaijo__c = 'Kasoba',
            Purpose__c = 'top',
            ShisetsuRef__c = Shisetsu.getId()
        );
        Database.SaveResult simg = Database.insert(sseimg);

        Shisetsu__c shi2 = new Shisetsu__c(
            ShisetsuShubetsu__c='火葬場',
            Name='テスト用００2',
            State__c='東京都',
            City__c='中央区',
            Street__c='2-2-2',
            PostalCode__c='335-0016',
            AccessHouhouDensha__c = 'testaaaa',
            Shikugun__c =null,
            KoeiMinei__c='自社'
        );
        Database.SaveResult Shisetsu2 = Database.insert(shi2);
        ShisetsuImg__c sseimg2 = new ShisetsuImg__c (
            CoreImgId__c = '22222',
            ImageUrl__c = 'https://cdn-rakuso-core.minrevi.jp/public/facility/144669-top.jpg',
            KasobaSaijo__c = 'Kasoba',
            Purpose__c = 'top',
            ShisetsuRef__c = Shisetsu2.getId()
        );
        Database.SaveResult simg2 = Database.insert(sseimg2);

        for(Integer i = 0; i < 2; i++){
            SogiShiryoSofuMeisai__c kasoumeisai = null;
            if(i==2){
                 kasoumeisai = new SogiShiryoSofuMeisai__c(
                    SaijoRef__c = null,
                    ShisetsuRef__c = Shisetsu2.getId(),
                    ShisetsuKubun__c = '火葬場',
                    SogiShiryoSofuRef__c = lsrsobj.getId(),
                    Hyojijun__c = i + 1
                );
            }else{
                 kasoumeisai = new SogiShiryoSofuMeisai__c(
                    SaijoRef__c = null,
                    ShisetsuRef__c = Shisetsu.getId(),
                    ShisetsuKubun__c = '火葬場',
                    SogiShiryoSofuRef__c = lsrsobj.getId(),
                    Hyojijun__c = i + 1
                );
            }
            Database.SaveResult kmeisai = Database.insert(kasoumeisai);
        }
       

        SogiShiryoSofu__c sofu = [select Id, Name, Fax__c, PamphletYohi__c, Mail__c, SofuShiryoURL__c, KasoshikiyoMongon__c,
        PassWord__c, Atena__c, SofuNichiji__c, InsatsubutsuIchiran__c, City__c, OpportunityRef__c, OpportunityRef__r.ShodanBangoF__c,OpportunityRef__r.Account.AcvmJizenWariMinDate__c,OpportunityRef__r.Account.JizenwariKekaKikan__c,
        OpportunityRef__r.Account.Name,SofuShubetsu__c, SofuJokyo__c, Street__c, State__c, YusoShubetsu__c, IsogiTaio__c, PostalCode__c, 
        HosokuSetsumei__c, HikitsugiJiko__c, TaSofubutsu1__c, TaSofubutsu2__c, TaSofubutsu3__c, 
        CreatedBy.LastName, 
        CreatedDate, 
        (
            select Id, 
                    SaijoRef__r.Name, 
                    SaijoRef__r.ShisetsuKubun__c, 
                    SaijoRef__r.ShikugunRef__r.Name, 
                    ShisetsuRef__r.Name, 
                    ShisetsuRef__r.KoeiMinei__c, 
                    ShisetsuRef__r.Shikugun__r.Name, 
                    ShisetsuKubun__c, 
                    SogiShiryoSofuRef__c, 
                    Hyojijun__c 
            from SogiShiryoSofuMeisais__r 
            order by Hyojijun__c 
        ) 
        from SogiShiryoSofu__c where  Id = : lsrsobj.getid() ];
        Test.setMock( HttpCalloutMock.class, new Testing_HttpResponseOproMock().setStatusCode(200) );
        Test.startTest();
        SougiShiryoSakusei sssi = new SougiShiryoSakusei();
        sssi.postOproPdf(sofu);
        Test.stopTest();
    }
    @isTest
    static void doTest_case_six(){
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
        System.debug('アチーブメントテスト');
        System.debug(achiveResult);
        Account aobj = [select id, Name , AcvmJizenWariMinDate__c,JizenwariKekaKikan__c FROM Account WHERE id = : lsrdacc.getid()];
        System.debug(aobj);
        SogiShiryoSofu__c sobj = new SogiShiryoSofu__c(
			OpportunityRef__c = lsropp.getid(),										// 商談
			SofuJokyo__c = '印刷待ち',												// 送付状況
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
            KasoshikiyoMongon__c = false,                                          // 火葬式文言
			SofuShiryoURL__c = '',
			HikitsugiJiko__c = 'あいうえお',										//引継事項
			InsatsuNichiji__c = Datetime.valueOf('2020-06-30 20:04:00')				// 印刷日時
		);
        Database.SaveResult lsrsobj = Database.insert(sobj);
        for(Integer i = 0; i < 6; i++){
            Saijo__c s = new Saijo__c();
            s.SaijoKeisaiJohoIdOld__c = '111111111'+i.format();
            s.SimpleHPKeisaiAri__c = false;
            s.Name = 'test'+i.format();
            s.KeisaiSaijoMeiKana__c = 'テスト';
            s.TokuchoSaijo__c = '特徴';
            s.PostalCode__c = '141-0031';
            s.Street__c = '西五反田2-11-17　HI五反田ビル 4F';
            s.JushoKana__c = 'にしごたんだ';
            s.IdoKedo__Latitude__s = 35.626471;
            s.IdoKedo__longitude__s = 139.722161;
            s.AccessHohoKuruma__c = 'アクセス車';
            s.AccessHohoBasu__c = 'アクセスバス';
            if(i == 2){
                s.AccessHouhouDensha__c = 'アクセス電車\ntest';
            }else{
                s.AccessHouhouDensha__c = 'アクセス電車';
            }
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
            Database.SaveResult saijo = Database.insert(s);
            SaijoImg__c saiImg = new SaijoImg__c (
                CoreImgId__c = '1111'+i.format(),
                Purpose__c   = 'gaikan',
                ImageUrl__c  = 'https://cdn-rakuso-core.minrevi.jp/public/facility/144669-top.jpg',
                SaijoRef__c  = saijo.getId()
            );
            Database.SaveResult saijoImg = Database.insert(saiImg);

        
            SogiShiryoSofuMeisai__c meisai = new SogiShiryoSofuMeisai__c(
                SaijoRef__c = saijo.getId(),
                ShisetsuRef__c = null,
                ShisetsuKubun__c = '斎場',
                SogiShiryoSofuRef__c = lsrsobj.getId(),
                Hyojijun__c = i + 1
            );
            Database.SaveResult smeisai = Database.insert(meisai);
        }

        Shisetsu__c shi = new Shisetsu__c(
            ShisetsuShubetsu__c='火葬場',
            Name='テスト用００１',
            State__c='東京都',
            City__c='中央区',
            Street__c='2-2-2',
            PostalCode__c='335-0016',
            AccessHouhouDensha__c = 'test\naaaa',
            Shikugun__c =null,
            KoeiMinei__c='自社'
        );
        Database.SaveResult Shisetsu = Database.insert(shi);
        ShisetsuImg__c sseimg = new ShisetsuImg__c (
            CoreImgId__c = '11111',
            ImageUrl__c = 'https://cdn-rakuso-core.minrevi.jp/public/facility/144669-top.jpg',
            KasobaSaijo__c = 'Kasoba',
            Purpose__c = 'top',
            ShisetsuRef__c = Shisetsu.getId()
        );
        Database.SaveResult simg = Database.insert(sseimg);

        Shisetsu__c shi2 = new Shisetsu__c(
            ShisetsuShubetsu__c='火葬場',
            Name='テスト用００2',
            State__c='東京都',
            City__c='中央区',
            Street__c='2-2-2',
            PostalCode__c='335-0016',
            AccessHouhouDensha__c = 'testaaaa',
            Shikugun__c =null,
            KoeiMinei__c='自社'
        );
        Database.SaveResult Shisetsu2 = Database.insert(shi2);
        ShisetsuImg__c sseimg2 = new ShisetsuImg__c (
            CoreImgId__c = '22222',
            ImageUrl__c = 'https://cdn-rakuso-core.minrevi.jp/public/facility/144669-top.jpg',
            KasobaSaijo__c = 'Kasoba',
            Purpose__c = 'top',
            ShisetsuRef__c = Shisetsu2.getId()
        );
        Database.SaveResult simg2 = Database.insert(sseimg2);

        for(Integer i = 0; i < 2; i++){
            SogiShiryoSofuMeisai__c kasoumeisai = null;
            if(i==2){
                 kasoumeisai = new SogiShiryoSofuMeisai__c(
                    SaijoRef__c = null,
                    ShisetsuRef__c = Shisetsu2.getId(),
                    ShisetsuKubun__c = '火葬場',
                    SogiShiryoSofuRef__c = lsrsobj.getId(),
                    Hyojijun__c = i + 1
                );
            }else{
                 kasoumeisai = new SogiShiryoSofuMeisai__c(
                    SaijoRef__c = null,
                    ShisetsuRef__c = Shisetsu.getId(),
                    ShisetsuKubun__c = '火葬場',
                    SogiShiryoSofuRef__c = lsrsobj.getId(),
                    Hyojijun__c = i + 1
                );
            }
            Database.SaveResult kmeisai = Database.insert(kasoumeisai);
        }
       

        SogiShiryoSofu__c sofu = [select Id, Name, Fax__c, PamphletYohi__c, Mail__c, SofuShiryoURL__c, KasoshikiyoMongon__c,
        PassWord__c, Atena__c, SofuNichiji__c, InsatsubutsuIchiran__c, City__c, OpportunityRef__c, OpportunityRef__r.ShodanBangoF__c,OpportunityRef__r.Account.AcvmJizenWariMinDate__c,OpportunityRef__r.Account.JizenwariKekaKikan__c,
        OpportunityRef__r.Account.Name,SofuShubetsu__c, SofuJokyo__c, Street__c, State__c, YusoShubetsu__c, IsogiTaio__c, PostalCode__c, 
        HosokuSetsumei__c, HikitsugiJiko__c, TaSofubutsu1__c, TaSofubutsu2__c, TaSofubutsu3__c, 
        CreatedBy.LastName, 
        CreatedDate, 
        (
            select Id, 
                    SaijoRef__r.Name, 
                    SaijoRef__r.ShisetsuKubun__c, 
                    SaijoRef__r.ShikugunRef__r.Name, 
                    ShisetsuRef__r.Name, 
                    ShisetsuRef__r.KoeiMinei__c, 
                    ShisetsuRef__r.Shikugun__r.Name, 
                    ShisetsuKubun__c, 
                    SogiShiryoSofuRef__c, 
                    Hyojijun__c 
            from SogiShiryoSofuMeisais__r 
            order by Hyojijun__c 
        ) 
        from SogiShiryoSofu__c where  Id = : lsrsobj.getid() ];
        Test.setMock( HttpCalloutMock.class, new Testing_HttpResponseOproMock().setStatusCode(200) );
        Test.startTest();
        SougiShiryoSakusei sssi = new SougiShiryoSakusei();
        sssi.postOproPdf(sofu);
        Test.stopTest();
    }
    @isTest
    static void doTest_case_seven(){
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
        System.debug('アチーブメントテスト');
        System.debug(achiveResult);
        Account aobj = [select id, Name , AcvmJizenWariMinDate__c,JizenwariKekaKikan__c FROM Account WHERE id = : lsrdacc.getid()];
        System.debug(aobj);
        SogiShiryoSofu__c sobj = new SogiShiryoSofu__c(
			OpportunityRef__c = lsropp.getid(),										// 商談
			SofuJokyo__c = '印刷待ち',												// 送付状況
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
            KasoshikiyoMongon__c = false,                                          // 火葬式文言
			SofuShiryoURL__c = '',
			HikitsugiJiko__c = 'あいうえお',										//引継事項
			InsatsuNichiji__c = Datetime.valueOf('2020-06-30 20:04:00')				// 印刷日時
		);
        Database.SaveResult lsrsobj = Database.insert(sobj);
        for(Integer i = 0; i < 4; i++){
            Saijo__c s = new Saijo__c();
            s.SaijoKeisaiJohoIdOld__c = '111111111'+i.format();
            s.SimpleHPKeisaiAri__c = false;
            s.Name = 'test'+i.format();
            s.KeisaiSaijoMeiKana__c = 'テスト';
            s.TokuchoSaijo__c = '特徴';
            s.PostalCode__c = '141-0031';
            s.Street__c = '西五反田2-11-17　HI五反田ビル 4F';
            s.JushoKana__c = 'にしごたんだ';
            s.IdoKedo__Latitude__s = 35.626471;
            s.IdoKedo__longitude__s = 139.722161;
            s.AccessHohoKuruma__c = 'アクセス車';
            s.AccessHohoBasu__c = 'アクセスバス';
            if(i == 2){
                s.AccessHouhouDensha__c = 'アクセス電車\ntest';
            }else{
                s.AccessHouhouDensha__c = 'アクセス電車';
            }
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
            Database.SaveResult saijo = Database.insert(s);
            SaijoImg__c saiImg = new SaijoImg__c (
                CoreImgId__c = '1111'+i.format(),
                Purpose__c   = 'gaikan',
                ImageUrl__c  = 'https://cdn-rakuso-core.minrevi.jp/public/facility/144669-top.jpg',
                SaijoRef__c  = saijo.getId()
            );
            Database.SaveResult saijoImg = Database.insert(saiImg);

        
            SogiShiryoSofuMeisai__c meisai = new SogiShiryoSofuMeisai__c(
                SaijoRef__c = saijo.getId(),
                ShisetsuRef__c = null,
                ShisetsuKubun__c = '斎場',
                SogiShiryoSofuRef__c = lsrsobj.getId(),
                Hyojijun__c = i + 1
            );
            Database.SaveResult smeisai = Database.insert(meisai);
        }

        Shisetsu__c shi = new Shisetsu__c(
            ShisetsuShubetsu__c='火葬場',
            Name='テスト用００１',
            State__c='東京都',
            City__c='中央区',
            Street__c='2-2-2',
            PostalCode__c='335-0016',
            AccessHouhouDensha__c = 'test\naaaa',
            Shikugun__c =null,
            KoeiMinei__c='自社'
        );
        Database.SaveResult Shisetsu = Database.insert(shi);
        ShisetsuImg__c sseimg = new ShisetsuImg__c (
            CoreImgId__c = '11111',
            ImageUrl__c = 'https://cdn-rakuso-core.minrevi.jp/public/facility/144669-top.jpg',
            KasobaSaijo__c = 'Kasoba',
            Purpose__c = 'top',
            ShisetsuRef__c = Shisetsu.getId()
        );
        Database.SaveResult simg = Database.insert(sseimg);

        Shisetsu__c shi2 = new Shisetsu__c(
            ShisetsuShubetsu__c='火葬場',
            Name='テスト用００2',
            State__c='東京都',
            City__c='中央区',
            Street__c='2-2-2',
            PostalCode__c='335-0016',
            AccessHouhouDensha__c = 'testaaaa',
            Shikugun__c =null,
            KoeiMinei__c='自社'
        );
        Database.SaveResult Shisetsu2 = Database.insert(shi2);
        ShisetsuImg__c sseimg2 = new ShisetsuImg__c (
            CoreImgId__c = '22222',
            ImageUrl__c = 'https://cdn-rakuso-core.minrevi.jp/public/facility/144669-top.jpg',
            KasobaSaijo__c = 'Kasoba',
            Purpose__c = 'top',
            ShisetsuRef__c = Shisetsu2.getId()
        );
        Database.SaveResult simg2 = Database.insert(sseimg2);

        for(Integer i = 0; i < 2; i++){
            SogiShiryoSofuMeisai__c kasoumeisai = null;
            if(i==2){
                 kasoumeisai = new SogiShiryoSofuMeisai__c(
                    SaijoRef__c = null,
                    ShisetsuRef__c = Shisetsu2.getId(),
                    ShisetsuKubun__c = '火葬場',
                    SogiShiryoSofuRef__c = lsrsobj.getId(),
                    Hyojijun__c = i + 1
                );
            }else{
                 kasoumeisai = new SogiShiryoSofuMeisai__c(
                    SaijoRef__c = null,
                    ShisetsuRef__c = Shisetsu.getId(),
                    ShisetsuKubun__c = '火葬場',
                    SogiShiryoSofuRef__c = lsrsobj.getId(),
                    Hyojijun__c = i + 1
                );
            }
            Database.SaveResult kmeisai = Database.insert(kasoumeisai);
        }
       

        SogiShiryoSofu__c sofu = [select Id, Name, Fax__c, PamphletYohi__c, Mail__c, SofuShiryoURL__c, KasoshikiyoMongon__c,
        PassWord__c, Atena__c, SofuNichiji__c, InsatsubutsuIchiran__c, City__c, OpportunityRef__c, OpportunityRef__r.ShodanBangoF__c,OpportunityRef__r.Account.AcvmJizenWariMinDate__c,OpportunityRef__r.Account.JizenwariKekaKikan__c,
        OpportunityRef__r.Account.Name,SofuShubetsu__c, SofuJokyo__c, Street__c, State__c, YusoShubetsu__c, IsogiTaio__c, PostalCode__c, 
        HosokuSetsumei__c, HikitsugiJiko__c, TaSofubutsu1__c, TaSofubutsu2__c, TaSofubutsu3__c, 
        CreatedBy.LastName, 
        CreatedDate, 
        (
            select Id, 
                    SaijoRef__r.Name, 
                    SaijoRef__r.ShisetsuKubun__c, 
                    SaijoRef__r.ShikugunRef__r.Name, 
                    ShisetsuRef__r.Name, 
                    ShisetsuRef__r.KoeiMinei__c, 
                    ShisetsuRef__r.Shikugun__r.Name, 
                    ShisetsuKubun__c, 
                    SogiShiryoSofuRef__c, 
                    Hyojijun__c 
            from SogiShiryoSofuMeisais__r 
            order by Hyojijun__c 
        ) 
        from SogiShiryoSofu__c where  Id = : lsrsobj.getid() ];
        Test.setMock( HttpCalloutMock.class, new Testing_HttpResponseOproMock().setStatusCode(200) );
        Test.startTest();
        SougiShiryoSakusei sssi = new SougiShiryoSakusei();
        sssi.postOproPdf(sofu);
        Test.stopTest();
    }
    @isTest
    static void doTest_case_eight(){
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
        System.debug('アチーブメントテスト');
        System.debug(achiveResult);
        Account aobj = [select id, Name , AcvmJizenWariMinDate__c,JizenwariKekaKikan__c FROM Account WHERE id = : lsrdacc.getid()];
        System.debug(aobj);
        SogiShiryoSofu__c sobj = new SogiShiryoSofu__c(
			OpportunityRef__c = lsropp.getid(),										// 商談
			SofuJokyo__c = '印刷待ち',												// 送付状況
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
            KasoshikiyoMongon__c = false,                                          // 火葬式文言
			SofuShiryoURL__c = '',
			HikitsugiJiko__c = 'あいうえお',										//引継事項
			InsatsuNichiji__c = Datetime.valueOf('2020-06-30 20:04:00')				// 印刷日時
		);
        Database.SaveResult lsrsobj = Database.insert(sobj);
        for(Integer i = 0; i < 2; i++){
            Saijo__c s = new Saijo__c();
            s.SaijoKeisaiJohoIdOld__c = '111111111'+i.format();
            s.SimpleHPKeisaiAri__c = false;
            s.Name = 'test'+i.format();
            s.KeisaiSaijoMeiKana__c = 'テスト';
            s.TokuchoSaijo__c = '特徴';
            s.PostalCode__c = '141-0031';
            s.Street__c = '西五反田2-11-17　HI五反田ビル 4F';
            s.JushoKana__c = 'にしごたんだ';
            s.IdoKedo__Latitude__s = 35.626471;
            s.IdoKedo__longitude__s = 139.722161;
            s.AccessHohoKuruma__c = 'アクセス車';
            s.AccessHohoBasu__c = 'アクセスバス';
            if(i == 2){
                s.AccessHouhouDensha__c = 'アクセス電車\ntest';
            }else{
                s.AccessHouhouDensha__c = 'アクセス電車';
            }
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
            Database.SaveResult saijo = Database.insert(s);
            SaijoImg__c saiImg = new SaijoImg__c (
                CoreImgId__c = '1111'+i.format(),
                Purpose__c   = 'gaikan',
                ImageUrl__c  = 'https://cdn-rakuso-core.minrevi.jp/public/facility/144669-top.jpg',
                SaijoRef__c  = saijo.getId()
            );
            Database.SaveResult saijoImg = Database.insert(saiImg);

        
            SogiShiryoSofuMeisai__c meisai = new SogiShiryoSofuMeisai__c(
                SaijoRef__c = saijo.getId(),
                ShisetsuRef__c = null,
                ShisetsuKubun__c = '斎場',
                SogiShiryoSofuRef__c = lsrsobj.getId(),
                Hyojijun__c = i + 1
            );
            Database.SaveResult smeisai = Database.insert(meisai);
        }

        Shisetsu__c shi = new Shisetsu__c(
            ShisetsuShubetsu__c='火葬場',
            Name='テスト用００１',
            State__c='東京都',
            City__c='中央区',
            Street__c='2-2-2',
            PostalCode__c='335-0016',
            AccessHouhouDensha__c = 'test\naaaa',
            Shikugun__c =null,
            KoeiMinei__c='自社'
        );
        Database.SaveResult Shisetsu = Database.insert(shi);
        ShisetsuImg__c sseimg = new ShisetsuImg__c (
            CoreImgId__c = '11111',
            ImageUrl__c = 'https://cdn-rakuso-core.minrevi.jp/public/facility/144669-top.jpg',
            KasobaSaijo__c = 'Kasoba',
            Purpose__c = 'top',
            ShisetsuRef__c = Shisetsu.getId()
        );
        Database.SaveResult simg = Database.insert(sseimg);

        Shisetsu__c shi2 = new Shisetsu__c(
            ShisetsuShubetsu__c='火葬場',
            Name='テスト用００2',
            State__c='東京都',
            City__c='中央区',
            Street__c='2-2-2',
            PostalCode__c='335-0016',
            AccessHouhouDensha__c = 'testaaaa',
            Shikugun__c =null,
            KoeiMinei__c='自社'
        );
        Database.SaveResult Shisetsu2 = Database.insert(shi2);
        ShisetsuImg__c sseimg2 = new ShisetsuImg__c (
            CoreImgId__c = '22222',
            ImageUrl__c = 'https://cdn-rakuso-core.minrevi.jp/public/facility/144669-top.jpg',
            KasobaSaijo__c = 'Kasoba',
            Purpose__c = 'top',
            ShisetsuRef__c = Shisetsu2.getId()
        );
        Database.SaveResult simg2 = Database.insert(sseimg2);

        for(Integer i = 0; i < 2; i++){
            SogiShiryoSofuMeisai__c kasoumeisai = null;
            if(i==2){
                 kasoumeisai = new SogiShiryoSofuMeisai__c(
                    SaijoRef__c = null,
                    ShisetsuRef__c = Shisetsu2.getId(),
                    ShisetsuKubun__c = '火葬場',
                    SogiShiryoSofuRef__c = lsrsobj.getId(),
                    Hyojijun__c = i + 1
                );
            }else{
                 kasoumeisai = new SogiShiryoSofuMeisai__c(
                    SaijoRef__c = null,
                    ShisetsuRef__c = Shisetsu.getId(),
                    ShisetsuKubun__c = '火葬場',
                    SogiShiryoSofuRef__c = lsrsobj.getId(),
                    Hyojijun__c = i + 1
                );
            }
            Database.SaveResult kmeisai = Database.insert(kasoumeisai);
        }
       

        SogiShiryoSofu__c sofu = [select Id, Name, Fax__c, PamphletYohi__c, Mail__c, SofuShiryoURL__c, KasoshikiyoMongon__c,
        PassWord__c, Atena__c, SofuNichiji__c, InsatsubutsuIchiran__c, City__c, OpportunityRef__c, OpportunityRef__r.ShodanBangoF__c,OpportunityRef__r.Account.AcvmJizenWariMinDate__c,OpportunityRef__r.Account.JizenwariKekaKikan__c,
        OpportunityRef__r.Account.Name,SofuShubetsu__c, SofuJokyo__c, Street__c, State__c, YusoShubetsu__c, IsogiTaio__c, PostalCode__c, 
        HosokuSetsumei__c, HikitsugiJiko__c, TaSofubutsu1__c, TaSofubutsu2__c, TaSofubutsu3__c, 
        CreatedBy.LastName, 
        CreatedDate, 
        (
            select Id, 
                    SaijoRef__r.Name, 
                    SaijoRef__r.ShisetsuKubun__c, 
                    SaijoRef__r.ShikugunRef__r.Name, 
                    ShisetsuRef__r.Name, 
                    ShisetsuRef__r.KoeiMinei__c, 
                    ShisetsuRef__r.Shikugun__r.Name, 
                    ShisetsuKubun__c, 
                    SogiShiryoSofuRef__c, 
                    Hyojijun__c 
            from SogiShiryoSofuMeisais__r 
            order by Hyojijun__c 
        ) 
        from SogiShiryoSofu__c where  Id = : lsrsobj.getid() ];
        Test.setMock( HttpCalloutMock.class, new Testing_HttpResponseOproMock().setStatusCode(200) );
        Test.startTest();
        SougiShiryoSakusei sssi = new SougiShiryoSakusei();
        sssi.postOproPdf(sofu);
        Test.stopTest();
    }
    @isTest
    static void doTest_case_nine(){
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
        System.debug('アチーブメントテスト');
        System.debug(achiveResult);
        Account aobj = [select id, Name , AcvmJizenWariMinDate__c,JizenwariKekaKikan__c FROM Account WHERE id = : lsrdacc.getid()];
        System.debug(aobj);
        SogiShiryoSofu__c sobj = new SogiShiryoSofu__c(
			OpportunityRef__c = lsropp.getid(),										// 商談
			SofuJokyo__c = '印刷待ち',												// 送付状況
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
            KasoshikiyoMongon__c = false,                                          // 火葬式文言
			SofuShiryoURL__c = '',
			HikitsugiJiko__c = 'あいうえお',										//引継事項
			InsatsuNichiji__c = Datetime.valueOf('2020-06-30 20:04:00')				// 印刷日時
		);
        Database.SaveResult lsrsobj = Database.insert(sobj);

        for(Integer i = 0; i < 4; i++){
            Saijo__c s = new Saijo__c();
            s.SaijoKeisaiJohoIdOld__c = '111111111'+i.format();
            s.SimpleHPKeisaiAri__c = false;
            s.Name = 'test'+i.format();
            s.KeisaiSaijoMeiKana__c = 'テスト';
            s.TokuchoSaijo__c = '特徴';
            s.PostalCode__c = '141-0031';
            s.Street__c = '西五反田2-11-17　HI五反田ビル 4F';
            s.JushoKana__c = 'にしごたんだ';
            s.IdoKedo__Latitude__s = 35.626471;
            s.IdoKedo__longitude__s = 139.722161;
            s.AccessHohoKuruma__c = 'アクセス車';
            s.AccessHohoBasu__c = 'アクセスバス';
            if(i == 2){
                s.AccessHouhouDensha__c = 'アクセス電車\ntest';
            }else{
                s.AccessHouhouDensha__c = 'アクセス電車';
            }
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
            Database.SaveResult saijo = Database.insert(s);
            if(i == 2){
                SaijoHall__c hall = new SaijoHall__c (
                    Name = 'test',
                    X1ShiyoRyokinIppan__c = 1000,
                    X1ShiyoRyokinShimin__c = 2000,
                    X1ShiyoRyokinSonota__c = 3000,
                    X2ShiyoRyokinIppan__c = 4000,
                    X2ShiyoRyokinShimin__c = 5000,
                    X2ShiyoRyokinSonota__c = 6000,
                    SaijoRef__c = saijo.getId(),
                    SaijoHallKana__c = 'test',
                    ShiyoRyokinBiko__c = 'biko',
                    ShikijonoYokohabaShaku__c = 30000,
                    JogenKaisoshasu__c = 200,
                    Sekisu__c = 200,
                    TaioShikishubetsu__c = '一日葬'
                );
                Database.SaveResult rhall = Database.insert(hall);
            }
            SaijoImg__c saiImg = new SaijoImg__c (
                CoreImgId__c = '1111'+i.format(),
                Purpose__c   = 'gaikan',
                ImageUrl__c  = 'https://cdn-rakuso-core.minrevi.jp/public/facility/144669-top.jpg',
                SaijoRef__c  = saijo.getId()
            );
            Database.SaveResult saijoImg = Database.insert(saiImg);

        
            SogiShiryoSofuMeisai__c meisai = new SogiShiryoSofuMeisai__c(
                SaijoRef__c = saijo.getId(),
                ShisetsuRef__c = null,
                ShisetsuKubun__c = '斎場',
                SogiShiryoSofuRef__c = lsrsobj.getId(),
                Hyojijun__c = i + 1
            );
            Database.SaveResult smeisai = Database.insert(meisai);
        }

        Shisetsu__c shi = new Shisetsu__c(
            ShisetsuShubetsu__c='火葬場',
            Name='テスト用００１',
            State__c='東京都',
            City__c='中央区',
            Street__c='2-2-2',
            PostalCode__c='335-0016',
            AccessHouhouDensha__c = 'test\naaaa',
            Shikugun__c =null,
            KoeiMinei__c='自社'
        );
        Database.SaveResult Shisetsu = Database.insert(shi);
        ShisetsuImg__c sseimg = new ShisetsuImg__c (
            CoreImgId__c = '11111',
            ImageUrl__c = 'https://cdn-rakuso-core.minrevi.jp/public/facility/144669-top.jpg',
            KasobaSaijo__c = 'Kasoba',
            Purpose__c = 'top',
            ShisetsuRef__c = Shisetsu.getId()
        );
        Database.SaveResult simg = Database.insert(sseimg);

        Shisetsu__c shi2 = new Shisetsu__c(
            ShisetsuShubetsu__c='火葬場',
            Name='テスト用００2',
            State__c='東京都',
            City__c='中央区',
            Street__c='2-2-2',
            PostalCode__c='335-0016',
            AccessHouhouDensha__c = 'testaaaa',
            Shikugun__c =null,
            KoeiMinei__c='自社'
        );
        Database.SaveResult Shisetsu2 = Database.insert(shi2);
        ShisetsuImg__c sseimg2 = new ShisetsuImg__c (
            CoreImgId__c = '22222',
            ImageUrl__c = 'https://cdn-rakuso-core.minrevi.jp/public/facility/144669-top.jpg',
            KasobaSaijo__c = 'Kasoba',
            Purpose__c = 'top',
            ShisetsuRef__c = Shisetsu2.getId()
        );
        Database.SaveResult simg2 = Database.insert(sseimg2);

        for(Integer i = 0; i < 2; i++){
            SogiShiryoSofuMeisai__c kasoumeisai = null;
            if(i==2){
                 kasoumeisai = new SogiShiryoSofuMeisai__c(
                    SaijoRef__c = null,
                    ShisetsuRef__c = Shisetsu2.getId(),
                    ShisetsuKubun__c = '火葬場',
                    SogiShiryoSofuRef__c = lsrsobj.getId(),
                    Hyojijun__c = i + 1
                );
            }else{
                 kasoumeisai = new SogiShiryoSofuMeisai__c(
                    SaijoRef__c = null,
                    ShisetsuRef__c = Shisetsu.getId(),
                    ShisetsuKubun__c = '火葬場',
                    SogiShiryoSofuRef__c = lsrsobj.getId(),
                    Hyojijun__c = i + 1
                );
            }
            Database.SaveResult kmeisai = Database.insert(kasoumeisai);
        }
       

        SogiShiryoSofu__c sofu = [select Id, Name, Fax__c, PamphletYohi__c, Mail__c, SofuShiryoURL__c, KasoshikiyoMongon__c,
        PassWord__c, Atena__c, SofuNichiji__c, InsatsubutsuIchiran__c, City__c, OpportunityRef__c, OpportunityRef__r.ShodanBangoF__c,OpportunityRef__r.Account.AcvmJizenWariMinDate__c,OpportunityRef__r.Account.JizenwariKekaKikan__c,
        OpportunityRef__r.Account.Name,SofuShubetsu__c, SofuJokyo__c, Street__c, State__c, YusoShubetsu__c, IsogiTaio__c, PostalCode__c, 
        HosokuSetsumei__c, HikitsugiJiko__c, TaSofubutsu1__c, TaSofubutsu2__c, TaSofubutsu3__c, 
        CreatedBy.LastName, 
        CreatedDate, 
        (
            select Id, 
                    SaijoRef__r.Name, 
                    SaijoRef__r.ShisetsuKubun__c, 
                    SaijoRef__r.ShikugunRef__r.Name, 
                    ShisetsuRef__r.Name, 
                    ShisetsuRef__r.KoeiMinei__c, 
                    ShisetsuRef__r.Shikugun__r.Name, 
                    ShisetsuKubun__c, 
                    SogiShiryoSofuRef__c, 
                    Hyojijun__c 
            from SogiShiryoSofuMeisais__r 
            order by Hyojijun__c 
        ) 
        from SogiShiryoSofu__c where  Id = : lsrsobj.getid() ];
        Test.setMock( HttpCalloutMock.class, new Testing_HttpResponseOproMock().setStatusCode(200) );
        Test.startTest();
        SougiShiryoSakusei sssi = new SougiShiryoSakusei();
        sssi.postOproPdf(sofu);
        Test.stopTest();
    }
    @isTest
    static void doTest_case_ten(){
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
        System.debug('アチーブメントテスト');
        System.debug(achiveResult);
        Account aobj = [select id, Name , AcvmJizenWariMinDate__c,JizenwariKekaKikan__c FROM Account WHERE id = : lsrdacc.getid()];
        System.debug(aobj);
        SogiShiryoSofu__c sobj = new SogiShiryoSofu__c(
			OpportunityRef__c = lsropp.getid(),										// 商談
			SofuJokyo__c = '印刷待ち',												// 送付状況
			SofuShubetsu__c = 'メール',												// 送付種別
			YusoShubetsu__c = '速達',												// 郵送種別
			Atena__c = 'AAAA',														// 宛名
			PostalCode__c = '141-0031',												// 郵便番号
			State__c = '東京都',													// 都道府県
			City__c = '品川区',														// 市区郡
			Street__c = '西五反田',													// 町名・番地
			InsatsubutsuIchiran__c = '送付状;首都圏案内文;斎場資料;提案書;会員案内;',		// 印刷物一覧
			PamphletYohi__c = '要',													// パンフレット要否
			SofuNichiji__c = Datetime.valueOf('2020-06-30 19:18:00'),				// 送付日時
            TaSofubutsu1__c = 'ベス仏カタログ',										// 他送付物1
            TaSofubutsu2__c = 'その他カタログ2',
            TaSofubutsu3__c = 'その他カタログ3',
            IsogiTaio__c = true,													// 急ぎ対応
            KasoshikiyoMongon__c = false,                                          // 火葬式文言
			SofuShiryoURL__c = '',
			HikitsugiJiko__c = 'あいうえお',										//引継事項
			InsatsuNichiji__c = Datetime.valueOf('2020-06-30 20:04:00')				// 印刷日時
		);
        Database.SaveResult lsrsobj = Database.insert(sobj);

        for(Integer i = 0; i < 4; i++){
            Saijo__c s = new Saijo__c();
            s.SaijoKeisaiJohoIdOld__c = '111111111'+i.format();
            s.SimpleHPKeisaiAri__c = false;
            s.Name = 'test'+i.format();
            s.KeisaiSaijoMeiKana__c = 'テスト';
            s.TokuchoSaijo__c = '特徴';
            s.PostalCode__c = '141-0031';
            s.Street__c = '西五反田2-11-17　HI五反田ビル 4F';
            s.JushoKana__c = 'にしごたんだ';
            s.IdoKedo__Latitude__s = 35.626471;
            s.IdoKedo__longitude__s = 139.722161;
            s.AccessHohoKuruma__c = 'アクセス車';
            s.AccessHohoBasu__c = 'アクセスバス';
            if(i == 2){
                s.AccessHouhouDensha__c = 'アクセス電車\ntest';
            }else{
                s.AccessHouhouDensha__c = 'アクセス電車';
            }
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
            Database.SaveResult saijo = Database.insert(s);
            if(i == 2){
                SaijoHall__c hall = new SaijoHall__c (
                    Name = 'test',
                    X1ShiyoRyokinIppan__c = 1000,
                    X1ShiyoRyokinShimin__c = 2000,
                    X1ShiyoRyokinSonota__c = 3000,
                    X2ShiyoRyokinIppan__c = 4000,
                    X2ShiyoRyokinShimin__c = 5000,
                    X2ShiyoRyokinSonota__c = 6000,
                    SaijoRef__c = saijo.getId(),
                    SaijoHallKana__c = 'test',
                    ShiyoRyokinBiko__c = 'biko',
                    ShikijonoYokohabaShaku__c = 30000,
                    JogenKaisoshasu__c = 200,
                    Sekisu__c = 200,
                    TaioShikishubetsu__c = '一日葬'
                );
                Database.SaveResult rhall = Database.insert(hall);
            }
            SaijoImg__c saiImg = new SaijoImg__c (
                CoreImgId__c = '1111'+i.format(),
                Purpose__c   = 'gaikan',
                ImageUrl__c  = 'https://cdn-rakuso-core.minrevi.jp/public/facility/144669-top.jpg',
                SaijoRef__c  = saijo.getId()
            );
            Database.SaveResult saijoImg = Database.insert(saiImg);

        
            SogiShiryoSofuMeisai__c meisai = new SogiShiryoSofuMeisai__c(
                SaijoRef__c = saijo.getId(),
                ShisetsuRef__c = null,
                ShisetsuKubun__c = '斎場',
                SogiShiryoSofuRef__c = lsrsobj.getId(),
                Hyojijun__c = i + 1
            );
            Database.SaveResult smeisai = Database.insert(meisai);
        }

        Shisetsu__c shi = new Shisetsu__c(
            ShisetsuShubetsu__c='火葬場',
            Name='テスト用００１',
            State__c='東京都',
            City__c='中央区',
            Street__c='2-2-2',
            PostalCode__c='335-0016',
            AccessHouhouDensha__c = 'test\naaaa',
            Shikugun__c =null,
            KoeiMinei__c='自社'
        );
        Database.SaveResult Shisetsu = Database.insert(shi);
        ShisetsuImg__c sseimg = new ShisetsuImg__c (
            CoreImgId__c = '11111',
            ImageUrl__c = 'https://cdn-rakuso-core.minrevi.jp/public/facility/144669-top.jpg',
            KasobaSaijo__c = 'Kasoba',
            Purpose__c = 'top',
            ShisetsuRef__c = Shisetsu.getId()
        );
        Database.SaveResult simg = Database.insert(sseimg);

        Shisetsu__c shi2 = new Shisetsu__c(
            ShisetsuShubetsu__c='火葬場',
            Name='テスト用００2',
            State__c='東京都',
            City__c='中央区',
            Street__c='2-2-2',
            PostalCode__c='335-0016',
            AccessHouhouDensha__c = 'testaaaa',
            Shikugun__c =null,
            KoeiMinei__c='自社'
        );
        Database.SaveResult Shisetsu2 = Database.insert(shi2);
        ShisetsuImg__c sseimg2 = new ShisetsuImg__c (
            CoreImgId__c = '22222',
            ImageUrl__c = 'https://cdn-rakuso-core.minrevi.jp/public/facility/144669-top.jpg',
            KasobaSaijo__c = 'Kasoba',
            Purpose__c = 'top',
            ShisetsuRef__c = Shisetsu2.getId()
        );
        Database.SaveResult simg2 = Database.insert(sseimg2);

        for(Integer i = 0; i < 2; i++){
            SogiShiryoSofuMeisai__c kasoumeisai = null;
            if(i==2){
                 kasoumeisai = new SogiShiryoSofuMeisai__c(
                    SaijoRef__c = null,
                    ShisetsuRef__c = Shisetsu2.getId(),
                    ShisetsuKubun__c = '火葬場',
                    SogiShiryoSofuRef__c = lsrsobj.getId(),
                    Hyojijun__c = i + 1
                );
            }else{
                 kasoumeisai = new SogiShiryoSofuMeisai__c(
                    SaijoRef__c = null,
                    ShisetsuRef__c = Shisetsu.getId(),
                    ShisetsuKubun__c = '火葬場',
                    SogiShiryoSofuRef__c = lsrsobj.getId(),
                    Hyojijun__c = i + 1
                );
            }
            Database.SaveResult kmeisai = Database.insert(kasoumeisai);
        }
        TeianSho__c teiansho = new TeianSho__c (
            SogiShiryoSofuRef__c = lsrsobj.getid(),
            KasobaName__c = 'sample',
            KasobaMeisaiKingaku__c = 10000,
            KasobaMeisaiHyokiName__c = 'hyokiName',
            Waribiki1_Kingaku__c = 2200,
            Plan__c = 'よりそう家族葬 一日プラン',
            Service__c = 'よりそうのお葬式',
            Waribiki1_Hinmei__c = 'test品名1',
            Waribiki1_KingakuZeinuki__c = 2000,
            Waribiki2_Hinmei__c = 'test品名2',
            Waribiki2_KingakuZeinuki__c = 4000,
            Waribiki3_Hinmei__c = 'test品名3',
            Waribiki3_KingakuZeinuki__c = 5000,
            Waribiki4_Hinmei__c = 'test品名4',
            Waribiki4_KingakuZeinuki__c = 6000,
            TsuikaRyokin1_Hinmei__c = '追加料金1',
            TsuikaRyokin2_Hinmei__c = '追加料金2',
            TsuikaRyokin3_Hinmei__c = '追加料金3',
            TsuikaRyokin4_Hinmei__c = '追加料金4',
            TsuikaRyokin5_Hinmei__c = '追加料金5',
            TsuikaRyokin6_Hinmei__c = '追加料金6'
        );
        Database.SaveResult teianshoData = Database.insert(teiansho);

        SogiShiryoSofu__c sofu = [select Id, Name, Fax__c, PamphletYohi__c, Mail__c, SofuShiryoURL__c, KasoshikiyoMongon__c,
        PassWord__c, Atena__c, SofuNichiji__c, InsatsubutsuIchiran__c, City__c, OpportunityRef__c, OpportunityRef__r.ShodanBangoF__c,OpportunityRef__r.Account.AcvmJizenWariMinDate__c,OpportunityRef__r.Account.JizenwariKekaKikan__c,
        OpportunityRef__r.Account.Name,SofuShubetsu__c, SofuJokyo__c, Street__c, State__c, YusoShubetsu__c, IsogiTaio__c, PostalCode__c, 
        HosokuSetsumei__c, HikitsugiJiko__c, TaSofubutsu1__c, TaSofubutsu2__c, TaSofubutsu3__c, 
        CreatedBy.LastName, 
        CreatedDate, 
        (
            select Id, 
                    SaijoRef__r.Name, 
                    SaijoRef__r.ShisetsuKubun__c, 
                    SaijoRef__r.ShikugunRef__r.Name, 
                    ShisetsuRef__r.Name, 
                    ShisetsuRef__r.KoeiMinei__c, 
                    ShisetsuRef__r.Shikugun__r.Name, 
                    ShisetsuKubun__c, 
                    SogiShiryoSofuRef__c, 
                    Hyojijun__c 
            from SogiShiryoSofuMeisais__r 
            order by Hyojijun__c 
        ) 
        from SogiShiryoSofu__c where  Id = : lsrsobj.getid() ];
        Test.setMock( HttpCalloutMock.class, new Testing_HttpResponseOproMock().setStatusCode(200) );
        Test.startTest();
        SougiShiryoSakusei sssi = new SougiShiryoSakusei();
        sssi.postOproPdf(sofu);
        Test.stopTest();
    }

    @isTest
    static void doTest_case_eleven(){
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
        System.debug('アチーブメントテスト');
        System.debug(achiveResult);
        Account aobj = [select id, Name , AcvmJizenWariMinDate__c,JizenwariKekaKikan__c FROM Account WHERE id = : lsrdacc.getid()];
        System.debug(aobj);
        SogiShiryoSofu__c sobj = new SogiShiryoSofu__c(
			OpportunityRef__c = lsropp.getid(),										// 商談
			SofuJokyo__c = '印刷待ち',												// 送付状況
			SofuShubetsu__c = '郵送',												// 送付種別
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
        Database.SaveResult lsrsobj = Database.insert(sobj);
        Saijo__c saijyo = new Saijo__c (
            Name = 'testSaijyo',
            AccessHouhouDensha__c = 'atest\nbtest\nctest',
            AccessHohoKuruma__c = 'testcaraccess',
            AccessHohoBasu__c = 'testbasaccess',
            idokedo__latitude__s = 35.635430,
            idokedo__longitude__s = 139.883852,
            ChushaDaisu__c = 200
        );


       
        for(Integer i = 0; i < 20; i++){
            Saijo__c s = new Saijo__c();
            s.SaijoKeisaiJohoIdOld__c = '1111111111'+i.format();
            s.SimpleHPKeisaiAri__c = false;
            s.Name = 'test'+ i.format();
            s.KeisaiSaijoMeiKana__c = 'テスト';
            s.TokuchoSaijo__c = '特徴';
            s.PostalCode__c = '141-0031';
            s.Street__c = '西五反田2-11-17　HI五反田ビル 4F';
            s.JushoKana__c = 'にしごたんだ';
            s.IdoKedo__Latitude__s = 35.626471;
            s.IdoKedo__longitude__s = 139.722161;
            s.AccessHohoKuruma__c = 'アクセス車';
            s.AccessHohoBasu__c = 'アクセスバス';
            s.AccessHouhouDensha__c = 'アクセス電車\ntest';
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
            Database.SaveResult saijo = Database.insert(s);
            SogiShiryoSofuMeisai__c meisai = new SogiShiryoSofuMeisai__c(
                SaijoRef__c = saijo.getId(),
                ShisetsuRef__c = null,
                ShisetsuKubun__c = '斎場',
                SogiShiryoSofuRef__c = lsrsobj.getId(),
                Hyojijun__c = i + 1
            );
            Database.SaveResult smeisai = Database.insert(meisai);
        }
        for(Integer i = 0; i < 2; i++){
            Shisetsu__c shi = new Shisetsu__c(
                ShisetsuShubetsu__c='火葬場',
                Name='テスト用００１'+ i.format(),
                State__c='東京都',
                City__c='中央区',
                Street__c='2-2-2',
                PostalCode__c='335-0016',
                Shikugun__c =null,
                KoeiMinei__c='自社'
            );
            Database.SaveResult Shisetsu = Database.insert(shi);
            SogiShiryoSofuMeisai__c kasoumeisai = new SogiShiryoSofuMeisai__c(
                SaijoRef__c = null,
                ShisetsuRef__c = Shisetsu.getId(),
                ShisetsuKubun__c = '火葬場',
                SogiShiryoSofuRef__c = lsrsobj.getId(),
                Hyojijun__c = i + 1
            );
            Database.SaveResult kmeisai = Database.insert(kasoumeisai);
        }
       

        SogiShiryoSofu__c sofu = [select Id, Name, Fax__c, PamphletYohi__c, Mail__c, SofuShiryoURL__c, KasoshikiyoMongon__c,
        PassWord__c, Atena__c, SofuNichiji__c, InsatsubutsuIchiran__c, City__c, OpportunityRef__c, OpportunityRef__r.ShodanBangoF__c,OpportunityRef__r.Account.AcvmJizenWariMinDate__c,OpportunityRef__r.Account.JizenwariKekaKikan__c,
        OpportunityRef__r.Account.Name,SofuShubetsu__c, SofuJokyo__c, Street__c, State__c, YusoShubetsu__c, IsogiTaio__c, PostalCode__c, 
        HosokuSetsumei__c, HikitsugiJiko__c, TaSofubutsu1__c, TaSofubutsu2__c, TaSofubutsu3__c, 
        CreatedBy.LastName, 
        CreatedDate, 
        (
            select Id, 
                    SaijoRef__r.Name, 
                    SaijoRef__r.ShisetsuKubun__c, 
                    SaijoRef__r.ShikugunRef__r.Name, 
                    ShisetsuRef__r.Name, 
                    ShisetsuRef__r.KoeiMinei__c, 
                    ShisetsuRef__r.Shikugun__r.Name, 
                    ShisetsuKubun__c, 
                    SogiShiryoSofuRef__c, 
                    Hyojijun__c 
            from SogiShiryoSofuMeisais__r 
            order by Hyojijun__c 
        ) 
        from SogiShiryoSofu__c where  Id = : lsrsobj.getid() ];
        System.debug(sofu);
        Test.setMock( HttpCalloutMock.class, new Testing_HttpResponseOproMock().setStatusCode(200) );
        Test.startTest();
        SougiShiryoSakusei sssi = new SougiShiryoSakusei();
        sssi.postOproPdf(sofu);
        Test.stopTest();
    }
}