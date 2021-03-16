@isTest
public class Api_V1_OproAsynchronousT {
    @isTest
    static void test_method_one() {
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
        SogiShiryoSakuseiKekka__c kobj = new SogiShiryoSakuseiKekka__c (
            StatusCode__c = '',
            Message__c = '',
            Message_body__c =''
        );
        Database.SaveResult kres = Database.insert(kobj);
        OpfcConfs.Config theConfig = OpfcConfs.getConfig();
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
			SofuShiryoURL__c = theConfig.base_url + '/7b58bf8a99bb1f8a44f335643018efb349970493.pdf',
            HikitsugiJiko__c = 'あいうえお',										//引継事項
            KasoshikiyoMongon__c = false,                                          // 火葬式文言
            InsatsuNichiji__c = Datetime.valueOf('2020-06-30 20:04:00'),				// 印刷日時
            SogiShiryoSakuseiKekkaRef__c = kres.getid()
		);
        Database.SaveResult lsrsobj = Database.insert(sobj);

        RestRequest req = new RestRequest();
        RestResponse res = RestContext.response;
        String param = '{\"status\":200,\"statusDescription\":\"OK\",\"headers\":{\"content-type\":[{\"key\":\"Content-Type\",\"value\":\"application/json\"}]},\"body\":\"{\\\"path\\\":\\\"/7b58bf8a99bb1f8a44f335643018efb349970493.pdf\\\"}\"}';
        // '{\"status\":200,\"statusDescription\":\"OK\",\"headers\":{\"content-type\":[{\"key\":\"Content-Type\",\"value\":\"application/json\"}]},\"body\":\"{\\\"path\\\":\\\"/7b58bf8a99bb1f8a44f335643018efb349970493.pdf\\\"}\"}';
        
        Blob requestBodyBlob = Blob.valueOf(param);
        req.requestURI = '/api/v1/opro/7b58bf8a99bb1f8a44f335643018efb349970493/completed/';
        req.httpMethod = 'POST';
        req.requestBody = requestBodyBlob;
        RestContext.request = req;
        Test.startTest();
        Api_V1_OproAsynchronous.doPost();
        Test.stopTest();
    }

    @isTest
    static void test_method_two() {
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
        SogiShiryoSakuseiKekka__c kobj = new SogiShiryoSakuseiKekka__c (
            StatusCode__c = '',
            Message__c = '',
            Message_body__c =''
        );
        Database.SaveResult kres = Database.insert(kobj);
        OpfcConfs.Config theConfig = OpfcConfs.getConfig();
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
			SofuShiryoURL__c = theConfig.base_url +'/7b58bf8a99bb1f8a44f335643018efb349970493.pdf',
            HikitsugiJiko__c = 'あいうえお',										//引継事項
            KasoshikiyoMongon__c = false,                                          // 火葬式文言
            InsatsuNichiji__c = Datetime.valueOf('2020-06-30 20:04:00'),				// 印刷日時
            SogiShiryoSakuseiKekkaRef__c = kres.getid()
		);
        Database.SaveResult lsrsobj = Database.insert(sobj);

        RestRequest req = new RestRequest();
        RestResponse res = RestContext.response;
        String param = '{\"status\":500,\"statusDescription\":\"Internal Server Error\",\"headers\":{\"content-type\":[{\"key\":\"Content-Type\",\"value\":\"application/json\"}]},\"body\":\"{\\\"path\\\":\\\"null\\\"}\"}';
        // '{\"status\":200,\"statusDescription\":\"OK\",\"headers\":{\"content-type\":[{\"key\":\"Content-Type\",\"value\":\"application/json\"}]},\"body\":\"{\\\"path\\\":\\\"/7b58bf8a99bb1f8a44f335643018efb349970493.pdf\\\"}\"}';
        
        Blob requestBodyBlob = Blob.valueOf(param);
        req.requestURI = '/api/v1/opro/7b58bf8a99bb1f8a44f335643018efb349970493/completed/';
        req.httpMethod = 'POST';
        req.requestBody = requestBodyBlob;
        RestContext.request = req;
        Test.startTest();
        Api_V1_OproAsynchronous.doPost();
        Test.stopTest();
    }
    @isTest
    static void test_method_three() {
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
        SogiShiryoSakuseiKekka__c kobj = new SogiShiryoSakuseiKekka__c (
            StatusCode__c = '',
            Message__c = '',
            Message_body__c =''
        );
        Database.SaveResult kres = Database.insert(kobj);
        OpfcConfs.Config theConfig = OpfcConfs.getConfig();
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
			SofuShiryoURL__c = theConfig.base_url + '/7b58bf8a99bb1f8a44f335643018efb349970493.pdf',
            HikitsugiJiko__c = 'あいうえお',										//引継事項
            KasoshikiyoMongon__c = false,                                          // 火葬式文言
            InsatsuNichiji__c = Datetime.valueOf('2020-06-30 20:04:00'),				// 印刷日時
            SogiShiryoSakuseiKekkaRef__c = kres.getid()
		);
        Database.SaveResult lsrsobj = Database.insert(sobj);

        RestRequest req = new RestRequest();
        RestResponse res = RestContext.response;
        String param = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        // '{\"status\":200,\"statusDescription\":\"OK\",\"headers\":{\"content-type\":[{\"key\":\"Content-Type\",\"value\":\"application/json\"}]},\"body\":\"{\\\"path\\\":\\\"/7b58bf8a99bb1f8a44f335643018efb349970493.pdf\\\"}\"}';
        
        Blob requestBodyBlob = Blob.valueOf(param);
        req.requestURI = '/api/v1/opro/7b58bf8a99bb1f8a44f335643018efb349970493/completed/';
        req.httpMethod = 'POST';
        req.requestBody = requestBodyBlob;
        RestContext.request = req;
        Test.startTest();
        Api_V1_OproAsynchronous.doPost();
        Test.stopTest();
    }
}