@isTest
private class Tes_Aos_SMSSendingMessageProcessor {

	@isTest
	static void test_method_one() {

	    Test.startTest();

		RecordType customerRecordType = [SELECT Id FROM RecordType WHERE DeveloperName = 'Customer' LIMIT 1];
		RecordType soryoRecordType    = [SELECT Id FROM RecordType WHERE DeveloperName = 'SoryoAccount' LIMIT 1];
		System.debug('---soryoRecordType---' + soryoRecordType.Id);
		RecordType jiinRecordType     = [SELECT Id FROM RecordType WHERE DeveloperName = 'Jiin' LIMIT 1];
		
		List<Account> inserts = new List<Account>();

		// 寺院
		Account temple = new Account(
							          Name = 'テスト寺院',
									  JiinSyusi__c = '天台系',
									  JiinSyuha__c = '天台宗',
									  RecordTypeId = jiinRecordType.Id
									);
		inserts.add(temple);

		// 相談者
	    Account acc = new Account(
							      LastName  = '相談者セイ',
							      FirstName = '相談者メイ',
							      MobilePhone__c = '010-1111-1111',
							      RecordTypeId = customerRecordType.Id
					     	    );
		inserts.add(acc);

		// 対象者
	    Account taishosha = new Account(
							      LastName  = '対象者セイ',
							      FirstName = '対象者メイ',
							      MobilePhone__c = '030-1111-1111',
							      RecordTypeId = customerRecordType.Id
					     	    );
		inserts.add(taishosha);



		// 僧侶
	    Account monk = new Account(
							      Name  = '僧侶セイ 僧侶メイ',
							      MobilePhone__c = '020-1111-1111',
							      RecordTypeId = soryoRecordType.Id
							      );

		inserts.add(monk);

		insert inserts;


		// お坊さん便サービスレコード
		Obosanbin__c serviceObosanbin = new Obosanbin__c(
													      Taishosha1Ref__c = taishosha.Id
														);

		insert serviceObosanbin;

		// お坊さん便商談
		Opportunity opp = new Opportunity(
											Name = 'お坊さん便-商談',
											StageName = '施行待ち',
											ObosanbinRef__c = serviceObosanbin.Id,
											AccountId = acc.Id,
											CloseDate = Date.today(),
											TaishoushaJokyo__c = '_'
										 );

	    insert opp;

	    Opportunity oppObosanbin = [SELECT ShodanBangoF__c FROM Opportunity WHERE Id =:opp.Id];
	    Account accMonk = [SELECT TorihikisakiBangoF__c FROM Account WHERE Id =:monk.Id];

        RestRequest req = new RestRequest();
        RestResponse res = RestContext.response;
        String resparam =   '{"eventNotifications":' + 
              '[{"type":"DLR","dateTime":"2017/07/24 12:45:47",' +
              '"messageId":"00002891702242187613918627udCsC",' +
              '"phoneNumber":"+818037653209",' +
              '"smsCode":"80366",' +
              '"carrierId":"103",' +
              '"carrierName":"NTT Docomo",' +
              '"messageText":"test message",' +
              '"clientId":"289",' +
              '"clientTag":"ObouSekouKakunin,20170724163746,0000001,3209,'+ oppObosanbin.ShodanBangoF__c +',' + monk.TorihikisakiBangoF__c +',1' +'",' +
              '"statusId":"2",' +
              '"statusDescription":"Message delivered",' +
              '"rawdata":' +
              '{"carrier":"103",' +
              '"type":"",' +
              '"data":' +
              '{"code":"",' +
              '"submission_status":"",' +
              '"msgState":"",' +
              '"submission_err_code":"",' +
              '"ntwkErr":"",' +
              '"commandStatus":"",' +
              '"networkErrorCode":""}}}]}';

	    Blob requestBodyBlob = Blob.valueOf(json.serialize(resparam, true));
	    system.debug(requestBodyBlob);

	    req.requestBody = requestBodyBlob;
	    req.requestURI = '/v1/aossms/sendingstatuschanged';
	    req.resourcePath = '/services/apexrest/v1/aossms/sendingstatuschanged';
	    req.httpMethod = 'POST';
	    RestContext.request = req;
	    RestCOntext.response = res;

	    Aos_SMSSendingMessageProcessor aos = new Aos_SMSSendingMessageProcessor(); /*Constructor Coverage*/
	    Aos_SMSSendingMessageProcessor.SendingStatusChanged();

	    Test.stopTest();
	}

	@isTest
	static void test_method_two() {


        RestRequest  req = new RestRequest();
        RestResponse res = RestContext.response;

	    Test.startTest();

		RecordType customerRecordType = [SELECT Id FROM RecordType WHERE DeveloperName = 'Customer' LIMIT 1];

		// 相談者
	    Account newAcc = new Account(
							      LastName  = '相談者セイ',
							      FirstName = '相談者メイ',
							      MobilePhone__c = '010-1111-1111',
							      RecordTypeId = customerRecordType.Id
					     	    );
		insert newAcc;

	    Account acc = [SELECT Id, TorihikisakiBangoF__c FROM Account WHERE Id =: newAcc.Id];

        String resparam =   '{"eventNotifications":' + 
              '[{"type":"DLR","dateTimeString":"2017/02/24 21:45:47",' +
              '"messageId":"00002891702242187613918627udCsC",' +
              '"phoneNumber":"+818037653209",' +
              '"smsCode":"80366",' +
              '"carrierId":"103",' +
              '"carrierName":"NTT Docomo",' +
              '"messageText":"test message",' +
              '"clientId":"289",' +
              '"clientTag":"Campaign,20170619103746,0000001,3209,270516,' + acc.TorihikisakiBangoF__c + '",' +
              '"statusId":"2",' +
              '"statusDescription":"Message delivered",' +
              '"rawdata":' +
              '{"carrier":"103",' +
              '"type":"",' +
              '"data":' +
              '{"code":"",' +
              '"submission_status":"",' +
              '"msgState":"",' +
              '"submission_err_code":"",' +
              '"ntwkErr":"",' +
              '"commandStatus":"",' +
              '"networkErrorCode":""}}}]}';

        Blob requestBodyBlob = Blob.valueOf(json.serialize(resparam, true));



	    req.requestBody = requestBodyBlob;
	    req.requestURI = '/v1/aossms/sendingstatuschanged';
	    req.resourcePath = '/services/apexrest/v1/aossms/sendingstatuschanged';
	    req.httpMethod = 'POST';
	    RestContext.request = req;
	    RestCOntext.response = res;

	    Aos_SMSSendingMessageProcessor aos = new Aos_SMSSendingMessageProcessor(); /*Constructor Coverage*/
	    Aos_SMSSendingMessageProcessor.SendingStatusChanged();
	    
	    Test.stopTest();
	}

  static void test_method_trhee() {

    Test.startTest();
    Aos_SMSSendingMessageProcessor.SendingStatusChanged();
    Test.stopTest();
  }



}