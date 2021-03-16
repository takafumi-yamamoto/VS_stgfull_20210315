@isTest
private class SaijoToiawaseCtlT {
	
	@isTest static void test_method_1() {
        TriggerIsActive__c TriggerIsActive=new TriggerIsActive__c();
        TriggerIsActive.name='default';
        TriggerIsActive.isActive__c=true;
        insert TriggerIsActive;

        JizenWariPlan__c JizenWariPlan=new JizenWariPlan__c();
        JizenWariPlan.Code__c='Yoriso';
        insert JizenWariPlan;

        User u = new User();
        u.Id = UserInfo.getUserId();
        u.BizTelAgentId__c = '9999';
        update u;

        Task t = new Task();
        t.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('BizTel').getRecordTypeId();
        t.B_AgentIdTo__c = '9999';
        t.B_PhoneFrom__c = '9876543210';
        insert t;

        Account acc = new Account(RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId(),
                                lastname='新規');
        insert acc;

        // 都道府県
        TodoufuKen__c todoufuKen = new TodoufuKen__c();
        // todoufuken36.id = 'a177F000000NnHCQA0';    // カスタムオブジェクト ID
        todoufuKen.name = '東京都';   // 都道府県
        todoufuKen.kencode__c = '13';   // 県コード
        todoufuKen.pkey__c = '東京都';   // PKey
        insert todoufuKen;

        // 市区郡
        Shikugun__c shikugun = new Shikugun__c();
        // shikugun1271.id = 'a0v7F000000aRqIQAU';    // カスタムオブジェクト ID
        shikugun.name = '東京都品川区';   // 市区郡名称
        shikugun.areacode__c = '13109';   // エリアコード
        shikugun.chiriichijouhou__latitude__s = 35.6092261;   // 地理位置情報 (Latitude)
        shikugun.chiriichijouhou__longitude__s = 139.7301861;   // 地理位置情報 (Longitude)
        shikugun.shikugunmeifurigana__c = 'しながわく';   // 市区郡名(かな)
        shikugun.todoufukenref__c = todoufuKen.Id;   // 都道府県
        shikugun.shikugunmei__c = '品川区';   // 市区郡名
        //shikugun1271.mukobi__c = DateTime.now();   // 無効日
        insert shikugun;

        // 葬儀社
        Id sogisyaRecordtype = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Sogisya').getRecordTypeId();
        Account testSogisya  = new Account( Name = 'テスト葬儀社',
                                            ShikugunRef__c = shikugun.Id, 
                                            BillingPostalCode = '13109', 
                                            BillingState = '東京都', 
                                            BillingCity = '品川区', 
                                            BillingLatitude = 35.6092261, 
                                            BillingLongitude = 139.7301861,
                                            KinyukikanCodeTosha__c = '_', 
                                            KinyukikanMeiTosha__c = '_', 
                                            KozaShubetsuTosha__c = '普通', 
                                            KozaBangoTosha__c = '_', 
                                            KozaMeigiKanaTosha__c = '_',
                                            KozaMeigiTosha__c = '_', 
                                            ShitenCodeTosha__c = '_',
                                            ShitenMeiTosha__c = '_');
        insert testSogisya;

        // 契約
        Id keiyakuRecordtype = Schema.SObjectType.Keiyaku__c.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId();
        Keiyaku__c keiyaku = new Keiyaku__c( Name = 'テスト提携', Teikeisaki__c = testSogisya.Id, KeiyakuJokyo__c = '未契約', SeikyushoHassoCycle__c = '都度', NyukinSimekiriJouken__c = '月末締め翌月末', RecordTypeId = keiyakuRecordtype);
        insert keiyaku;

        k_Service__c kService = new k_Service__c( name='_', ID__c = '1' );
        insert kService;

        TesuryoPlan__c tesuryoPlan = new TesuryoPlan__c( 
            Name = '_',  CoreTesuryoPlanId__c = 1, ServiceRef__c = kService.Id,
            KobetsuPlanFlag__c = false, TesuryoNebikiSetteiKa__c = false );
        insert tesuryoPlan;

        TesuryoTekiyo__c tesuryoTekiyo = new TesuryoTekiyo__c(
            KeiyakuRef__c = keiyaku.Id,  
            ShoninStatus__c = 'ドラフト',
            TekiyoKaishiBi__c = Date.valueOf('1900-01-01'),
            TesuryoPlanRef__c = tesuryoPlan.Id,
            ServiceRef__c = kService.Id);
        insert tesuryoTekiyo;

        tesuryoTekiyo.ShoninStatus__c = '承認済';
        update tesuryoTekiyo;

        keiyaku.KeiyakuJokyo__c = '契約中';
        keiyaku.Keiyakukaishibi__c = Date.today();
        update keiyaku;

        Case c = new Case();
        c.Status = '対応中';
        c.Origin = '電話';
        c.Priority = '中';
        c.Type = 'サービス利用';
        c.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SimpleYasugoOtoiawase').getRecordTypeId();
        c.ToiawaseDate__c = datetime.now();
        insert c;

        Opportunity opp = [select Id, SimpleYasugoRef__c from Opportunity where CaseRef__c = :c.Id];

        Test.startTest();

        SaijoToiawaseCtl.futureSaijoJogai(opp.Id,
                                            opp.SimpleYasugoRef__c, 
                                            '葬儀依頼', 
                                            '葬儀社', 
                                            keiyaku.Id, 
                                            'テスト葬儀社', 
                                            '契約中', 
                                            '', 
                                            '', 
                                            '', 
                                            '', 
                                            '', 
                                            '', 
                                            '', 
                                            '葬儀依頼済', 
                                            '除外', 
                                            '斎場問い合わせ（提携先顧客）');

        Test.stopTest();
	}

        @isTest static void test_method_2() {
        TriggerIsActive__c TriggerIsActive=new TriggerIsActive__c();
        TriggerIsActive.name='default';
        TriggerIsActive.isActive__c=true;
        insert TriggerIsActive;

        JizenWariPlan__c JizenWariPlan=new JizenWariPlan__c();
        JizenWariPlan.Code__c='Yoriso';
        insert JizenWariPlan;

        User u = new User();
        u.Id = UserInfo.getUserId();
        u.BizTelAgentId__c = '9999';
        update u;

        Task t = new Task();
        t.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('BizTel').getRecordTypeId();
        t.B_AgentIdTo__c = '9999';
        t.B_PhoneFrom__c = '9876543210';
        insert t;

        Account acc = new Account(RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId(),
                                lastname='新規');
        insert acc;

        // 都道府県
        TodoufuKen__c todoufuKen = new TodoufuKen__c();
        // todoufuken36.id = 'a177F000000NnHCQA0';    // カスタムオブジェクト ID
        todoufuKen.name = '東京都';   // 都道府県
        todoufuKen.kencode__c = '13';   // 県コード
        todoufuKen.pkey__c = '東京都';   // PKey
        insert todoufuKen;

        // 市区郡
        Shikugun__c shikugun = new Shikugun__c();
        // shikugun1271.id = 'a0v7F000000aRqIQAU';    // カスタムオブジェクト ID
        shikugun.name = '東京都品川区';   // 市区郡名称
        shikugun.areacode__c = '13109';   // エリアコード
        shikugun.chiriichijouhou__latitude__s = 35.6092261;   // 地理位置情報 (Latitude)
        shikugun.chiriichijouhou__longitude__s = 139.7301861;   // 地理位置情報 (Longitude)
        shikugun.shikugunmeifurigana__c = 'しながわく';   // 市区郡名(かな)
        shikugun.todoufukenref__c = todoufuKen.Id;   // 都道府県
        shikugun.shikugunmei__c = '品川区';   // 市区郡名
        //shikugun1271.mukobi__c = DateTime.now();   // 無効日
        insert shikugun;

        // 葬儀社
        Id sogisyaRecordtype = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Sogisya').getRecordTypeId();
        Account testSogisya  = new Account( Name = 'テスト葬儀社',
                                            ShikugunRef__c = shikugun.Id, 
                                            BillingPostalCode = '13109', 
                                            BillingState = '東京都', 
                                            BillingCity = '品川区', 
                                            BillingLatitude = 35.6092261, 
                                            BillingLongitude = 139.7301861,
                                            KinyukikanCodeTosha__c = '_', 
                                            KinyukikanMeiTosha__c = '_', 
                                            KozaShubetsuTosha__c = '普通', 
                                            KozaBangoTosha__c = '_', 
                                            KozaMeigiKanaTosha__c = '_',
                                            KozaMeigiTosha__c = '_', 
                                            ShitenCodeTosha__c = '_',
                                            ShitenMeiTosha__c = '_');
        insert testSogisya;

        // 契約
        Id keiyakuRecordtype = Schema.SObjectType.Keiyaku__c.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId();
        Keiyaku__c keiyaku = new Keiyaku__c( Name = 'テスト提携', Teikeisaki__c = testSogisya.Id, KeiyakuJokyo__c = '未契約', SeikyushoHassoCycle__c = '都度', NyukinSimekiriJouken__c = '月末締め翌月末', RecordTypeId = keiyakuRecordtype);
        insert keiyaku;

        k_Service__c kService = new k_Service__c( name='_', ID__c = '1' );
        insert kService;

        TesuryoPlan__c tesuryoPlan = new TesuryoPlan__c( 
            Name = '_',  CoreTesuryoPlanId__c = 1, ServiceRef__c = kService.Id,
            KobetsuPlanFlag__c = false, TesuryoNebikiSetteiKa__c = false );
        insert tesuryoPlan;

        TesuryoTekiyo__c tesuryoTekiyo = new TesuryoTekiyo__c(
            KeiyakuRef__c = keiyaku.Id,  
            ShoninStatus__c = 'ドラフト',
            TekiyoKaishiBi__c = Date.valueOf('1900-01-01'),
            TesuryoPlanRef__c = tesuryoPlan.Id,
            ServiceRef__c = kService.Id);
        insert tesuryoTekiyo;

        tesuryoTekiyo.ShoninStatus__c = '承認済';
        update tesuryoTekiyo;

        keiyaku.KeiyakuJokyo__c = '契約中';
        keiyaku.Keiyakukaishibi__c = Date.today();
        update keiyaku;

        Saijo__c saijo = new Saijo__c();
        saijo.name = 'テスト五反田斎場';
        saijo.PostalCode__c = '141-0022';
        saijo.ShikugunRef__c = shikugun.Id;
        saijo.Street__c = '東五反田１丁目';
        saijo.IdoKedo__latitude__s = 35.6092261;
        saijo.IdoKedo__longitude__s = 139.7301861;
        insert saijo;

        Case c = new Case();
        c.Status = '対応中';
        c.Origin = '電話';
        c.Priority = '中';
        c.Type = 'サービス利用';
        c.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SimpleYasugoOtoiawase').getRecordTypeId();
        c.ToiawaseDate__c = datetime.now();
        insert c;

        Opportunity opp = [select Id, SimpleYasugoRef__c from Opportunity where CaseRef__c = :c.Id];

        Test.startTest();

        SaijoToiawaseCtl.futureSaijoJogai(opp.Id,
                                            opp.SimpleYasugoRef__c, 
                                            '葬儀依頼', 
                                            '斎場', 
                                            '', 
                                            '', 
                                            '', 
                                            '', 
                                            '', 
                                            saijo.Id, 
                                            'テスト五反田斎場', 
                                            '未提携', 
                                            '', 
                                            '', 
                                            '葬儀依頼済', 
                                            '除外', 
                                            '斎場問い合わせ（提携先顧客）');

        Test.stopTest();
        }


        @isTest static void test_method_3() {
        TriggerIsActive__c TriggerIsActive=new TriggerIsActive__c();
        TriggerIsActive.name='default';
        TriggerIsActive.isActive__c=true;
        insert TriggerIsActive;

        JizenWariPlan__c JizenWariPlan=new JizenWariPlan__c();
        JizenWariPlan.Code__c='Yoriso';
        insert JizenWariPlan;

        User u = new User();
        u.Id = UserInfo.getUserId();
        u.BizTelAgentId__c = '9999';
        update u;

        Task t = new Task();
        t.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('BizTel').getRecordTypeId();
        t.B_AgentIdTo__c = '9999';
        t.B_PhoneFrom__c = '9876543210';
        insert t;

        Account acc = new Account(RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId(),
                                lastname='新規');
        insert acc;

        // 都道府県
        TodoufuKen__c todoufuKen = new TodoufuKen__c();
        // todoufuken36.id = 'a177F000000NnHCQA0';    // カスタムオブジェクト ID
        todoufuKen.name = '東京都';   // 都道府県
        todoufuKen.kencode__c = '13';   // 県コード
        todoufuKen.pkey__c = '東京都';   // PKey
        insert todoufuKen;

        // 市区郡
        Shikugun__c shikugun = new Shikugun__c();
        // shikugun1271.id = 'a0v7F000000aRqIQAU';    // カスタムオブジェクト ID
        shikugun.name = '東京都品川区';   // 市区郡名称
        shikugun.areacode__c = '13109';   // エリアコード
        shikugun.chiriichijouhou__latitude__s = 35.6092261;   // 地理位置情報 (Latitude)
        shikugun.chiriichijouhou__longitude__s = 139.7301861;   // 地理位置情報 (Longitude)
        shikugun.shikugunmeifurigana__c = 'しながわく';   // 市区郡名(かな)
        shikugun.todoufukenref__c = todoufuKen.Id;   // 都道府県
        shikugun.shikugunmei__c = '品川区';   // 市区郡名
        //shikugun1271.mukobi__c = DateTime.now();   // 無効日
        insert shikugun;

        // 葬儀社
        Id sogisyaRecordtype = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Sogisya').getRecordTypeId();
        Account testSogisya  = new Account( Name = 'テスト葬儀社',
                                            ShikugunRef__c = shikugun.Id, 
                                            BillingPostalCode = '13109', 
                                            BillingState = '東京都', 
                                            BillingCity = '品川区', 
                                            BillingLatitude = 35.6092261, 
                                            BillingLongitude = 139.7301861,
                                            KinyukikanCodeTosha__c = '_', 
                                            KinyukikanMeiTosha__c = '_', 
                                            KozaShubetsuTosha__c = '普通', 
                                            KozaBangoTosha__c = '_', 
                                            KozaMeigiKanaTosha__c = '_',
                                            KozaMeigiTosha__c = '_', 
                                            ShitenCodeTosha__c = '_',
                                            ShitenMeiTosha__c = '_');
        insert testSogisya;

        // 契約
        Id keiyakuRecordtype = Schema.SObjectType.Keiyaku__c.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId();
        Keiyaku__c keiyaku = new Keiyaku__c( Name = 'テスト提携', Teikeisaki__c = testSogisya.Id, KeiyakuJokyo__c = '未契約', SeikyushoHassoCycle__c = '都度', NyukinSimekiriJouken__c = '月末締め翌月末', RecordTypeId = keiyakuRecordtype);
        insert keiyaku;

        k_Service__c kService = new k_Service__c( name='_', ID__c = '1' );
        insert kService;

        TesuryoPlan__c tesuryoPlan = new TesuryoPlan__c( 
            Name = '_',  CoreTesuryoPlanId__c = 1, ServiceRef__c = kService.Id,
            KobetsuPlanFlag__c = false, TesuryoNebikiSetteiKa__c = false );
        insert tesuryoPlan;

        TesuryoTekiyo__c tesuryoTekiyo = new TesuryoTekiyo__c(
            KeiyakuRef__c = keiyaku.Id,  
            ShoninStatus__c = 'ドラフト',
            TekiyoKaishiBi__c = Date.valueOf('1900-01-01'),
            TesuryoPlanRef__c = tesuryoPlan.Id,
            ServiceRef__c = kService.Id);
        insert tesuryoTekiyo;

        tesuryoTekiyo.ShoninStatus__c = '承認済';
        update tesuryoTekiyo;

        keiyaku.KeiyakuJokyo__c = '契約中';
        keiyaku.Keiyakukaishibi__c = Date.today();
        update keiyaku;

        Saijo__c saijo = new Saijo__c();
        saijo.name = 'テスト五反田斎場';
        saijo.PostalCode__c = '141-0022';
        saijo.ShikugunRef__c = shikugun.Id;
        saijo.Street__c = '東五反田１丁目';
        saijo.IdoKedo__latitude__s = 35.6092261;
        saijo.IdoKedo__longitude__s = 139.7301861;
        insert saijo;

        Case c = new Case();
        c.Status = '対応中';
        c.Origin = '電話';
        c.Priority = '中';
        c.Type = 'サービス利用';
        c.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SimpleYasugoOtoiawase').getRecordTypeId();
        c.ToiawaseDate__c = datetime.now();
        insert c;

        Opportunity opp = [select Id, SimpleYasugoRef__c from Opportunity where CaseRef__c = :c.Id];

        Test.startTest();

        SaijoToiawaseCtl.futureSaijoJogai(opp.Id,
                                            opp.SimpleYasugoRef__c, 
                                            '葬儀依頼', 
                                            '競合他社', 
                                            '', 
                                            '', 
                                            '', 
                                            '', 
                                            '', 
                                            '', 
                                            '', 
                                            '', 
                                            'その他ネット系葬儀サービス', 
                                            'やまもとそうぎ', 
                                            '葬儀依頼済', 
                                            '除外', 
                                            '斎場問い合わせ（提携先顧客）');

        Test.stopTest();
        }
}