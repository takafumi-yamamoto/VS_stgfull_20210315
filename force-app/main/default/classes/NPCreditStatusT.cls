@isTest
private class NPCreditStatusT {
	
	@isTest static void test_method_one() {
		// Implement test code

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
		//====================カスタム設定データ準備===================
		KaiinkibanSetting__c KaiinkibanSetting1=new KaiinkibanSetting__c();
		KaiinkibanSetting1.name='dev';
		KaiinkibanSetting1.client_id__c='5';
		KaiinkibanSetting1.client_secret__c='EwbX0FwZGwnOHuvjty9PvjVIxbbNGeLDpeEqnmPh';
		KaiinkibanSetting1.grant_type__c='client_credentials';
		KaiinkibanSetting1.timeOutPeriod__c=60000;
		KaiinkibanSetting1.Endpoint__c='http://dev2-rakuso-coreapi-external-alb-767861573.ap-northeast-1.elb.amazonaws.com/';
		KaiinkibanSetting1.isActive__c=True;
        KaiinkibanSetting1.KeiyakuCoreFlag__c=true;
		insert KaiinkibanSetting1;
		KaiinkibanSetting__c KaiinkibanSetting2=new KaiinkibanSetting__c();
		KaiinkibanSetting2.name='prod';
		KaiinkibanSetting2.client_id__c='5';
		KaiinkibanSetting2.client_secret__c='EwbX0FwZGwnOHuvjty9PvjVIxbbNGeLDpeEqnmPh';
		KaiinkibanSetting2.grant_type__c='client_credentials';
		KaiinkibanSetting2.timeOutPeriod__c=60000;
		KaiinkibanSetting2.Endpoint__c='http://dev2-rakuso-coreapi-external-alb-767861573.ap-northeast-1.elb.amazonaws.com/';
		KaiinkibanSetting2.isActive__c=True;
        KaiinkibanSetting2.KeiyakuCoreFlag__c=true;
		insert KaiinkibanSetting2;
		
		Yosin__c yosin = new Yosin__c();
		Insert yosin;

		SampleData sample = new SampleData();
		Account soryo = sample.getAccountSoryoAccount();
		soryo.YosinRef__c = yosin.Id;
		insert soryo;

		String buyserId = [Select TorihikisakiBango__c From Account Where Id = :soryo.Id].get(0).TorihikisakiBango__c;
		String responseBody = '{'
			+ '    "root": {'
			+ '        "creditStatusResult": {'
			+ '            "creditGuaranteeStatusLists": ['
			+ '                {'
			+ '                    "npBuyerId": "20181210000000", '
			+ '                    "buyerId": "' + buyserId + '", '
			+ '                    "companyName": "03", '
			+ '                    "department": "20190630", '
			+ '                    "customerName": "300000", '
			+ '                    "creditGuaranteeExpireDate": "20181210", '
			+ '                    "creditGuaranteeStatus": "1", '
			+ '                    "creditGuaranteeStatusUpdateDate": "20181110", '
			+ '                    "transactionRegistrationDueDate": "20181210", '
			+ '                    "transactionRegistrationStatus": "1", '
			+ '                    "billedAmount": 30000'
			+ '                }'
			+ '            ], '
			+ '            "errorResultLists": ['
			+ '                {'
			+ '                    "errorLists": ['
			+ '                        {'
			+ '                            "errorLevel": "E", '
			+ '                            "errorContents": "購入企業IDが存在しません。", '
			+ '                            "errorNo": "C20405"'
			+ '                        }'
			+ '                    ], '
			+ '                    "buyerId": "B6220"'
			+ '                }, '
			+ '                {'
			+ '                    "errorLists": ['
			+ '                        {'
			+ '                            "errorLevel": "E", '
			+ '                            "errorContents": "購入企業IDが存在しません。", '
			+ '                            "errorNo": "C20405"'
			+ '                        }'
			+ '                    ], '
			+ '                    "buyerId": "B6221"'
			+ '                }'
			+ '            ]'
			+ '        }'
			+ '    }'
			+ '}';
        Test.setMock(HttpCalloutMock.class, new Testing_HttpResponseMock().setStatusCode(201).setBody( responseBody ));     
        Test.startTest();	

        new NPCreditStatus().execute(null);

        Test.stopTest();
	}
	
	@isTest static void test_method_2() {
		// Implement test code

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
		//====================カスタム設定データ準備===================
		KaiinkibanSetting__c KaiinkibanSetting1=new KaiinkibanSetting__c();
		KaiinkibanSetting1.name='dev';
		KaiinkibanSetting1.client_id__c='5';
		KaiinkibanSetting1.client_secret__c='EwbX0FwZGwnOHuvjty9PvjVIxbbNGeLDpeEqnmPh';
		KaiinkibanSetting1.grant_type__c='client_credentials';
		KaiinkibanSetting1.timeOutPeriod__c=60000;
		KaiinkibanSetting1.Endpoint__c='http://dev2-rakuso-coreapi-external-alb-767861573.ap-northeast-1.elb.amazonaws.com/';
		KaiinkibanSetting1.isActive__c=True;
        KaiinkibanSetting1.KeiyakuCoreFlag__c=true;
		insert KaiinkibanSetting1;
		KaiinkibanSetting__c KaiinkibanSetting2=new KaiinkibanSetting__c();
		KaiinkibanSetting2.name='prod';
		KaiinkibanSetting2.client_id__c='5';
		KaiinkibanSetting2.client_secret__c='EwbX0FwZGwnOHuvjty9PvjVIxbbNGeLDpeEqnmPh';
		KaiinkibanSetting2.grant_type__c='client_credentials';
		KaiinkibanSetting2.timeOutPeriod__c=60000;
		KaiinkibanSetting2.Endpoint__c='http://dev2-rakuso-coreapi-external-alb-767861573.ap-northeast-1.elb.amazonaws.com/';
		KaiinkibanSetting2.isActive__c=True;
        KaiinkibanSetting2.KeiyakuCoreFlag__c=true;
		insert KaiinkibanSetting2;
		
		SampleData sample = new SampleData();
		Account soryo = sample.getAccountSoryo();
		insert soryo;

		String buyserId = [Select TorihikisakiBango__c From Account Where Id = :soryo.Id].get(0).TorihikisakiBango__c;
		String responseBody = '{'
			+ '    "root": {'
			+ '        "creditStatusResult": {'
			+ '            "creditGuaranteeStatusLists": ['
			+ '                {'
			+ '                    "npBuyerId": "20181210000000", '
			+ '                    "buyerId": "' + buyserId + '" '
			+ '                    "companyName": "03", '
			+ '                    "department": "20190630", '
			+ '                    "customerName": "300000", '
			+ '                    "creditGuaranteeExpireDate": "20181210", '
			+ '                    "creditGuaranteeStatus": "1", '
			+ '                    "creditGuaranteeStatusUpdateDate": "20181110", '
			+ '                    "transactionRegistrationDueDate": "20181210", '
			+ '                    "transactionRegistrationStatus": "1", '
			+ '                    "billedAmount": 30000'
			+ '                }'
			+ '            ], '
			+ '            "errorResultLists": ['
			+ '                {'
			+ '                    "errorLists": ['
			+ '                        {'
			+ '                            "errorLevel": "E", '
			+ '                            "errorContents": "購入企業IDが存在しません。", '
			+ '                            "errorNo": "C20405"'
			+ '                        }'
			+ '                    ], '
			+ '                    "buyerId": "B6220"'
			+ '                }, '
			+ '                {'
			+ '                    "errorLists": ['
			+ '                        {'
			+ '                            "errorLevel": "E", '
			+ '                            "errorContents": "購入企業IDが存在しません。", '
			+ '                            "errorNo": "C20405"'
			+ '                        }'
			+ '                    ], '
			+ '                    "buyerId": "B6221"'
			+ '                }'
			+ '            ]'
			+ '        }'
			+ '    }'
			+ '}';
        Test.setMock(HttpCalloutMock.class, new Testing_HttpResponseMock().setStatusCode(201).setBody( responseBody ));     
        Test.startTest();	

        new NPCreditStatus().execute(null);

        Test.stopTest();
	}
	
}