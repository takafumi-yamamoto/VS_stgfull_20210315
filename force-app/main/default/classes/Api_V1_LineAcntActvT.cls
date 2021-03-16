@isTest
public class Api_V1_LineAcntActvT {

    private static void setUp(){
        Insert new TriggerIsActive__c( name='default', isActive__c=true );
        Insert new JizenWariPlan__c( Code__c='Yoriso' );
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
        Insert new Account(
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId(),
            FirstName = '_', LastName = '_'
        );
    }

	@isTest static void doTest_Success(){
    	setup();
    	
        Map<String,Account> theAccounts = new Map<String, Account>{
            '1' => new Account( 
                RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('SoryoAccount').getRecordTypeId(),
                Name = '_', Seinengappi__c = Date.newInstance(1980,1,1), MobilePhone__c = '080-0000-0001'
                )
        };
        Insert theAccounts.values();

        Api_V1_LineAcntActv.ReqBody theReqBody = new Api_V1_LineAcntActv.ReqBody();
        theReqBody.birth_date = '1980-01-01';
        theReqBody.mobile_phone_no = '08000000001';

        RestRequest theReq = new RestRequest();
		theReq.httpMethod = 'POST';
		theReq.requestBody = Blob.valueof( JSON.Serialize(theReqBody) );

        RestContext.request = theReq;
        RestContext.response= new RestResponse();

        Test.startTest();
        Api_V1_LineAcntActv.doPost();
        Test.stopTest();
	}

	@isTest static void doTest_NoMatch(){
    	setup();
    	
        Map<String,Account> theAccounts = new Map<String, Account>{
            '1' => new Account( 
                RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('SoryoAccount').getRecordTypeId(),
                Name = '_', Seinengappi__c = Date.newInstance(1980,1,1)
                )
        };
        Insert theAccounts.values();

        Api_V1_LineAcntActv.ReqBody theReqBody = new Api_V1_LineAcntActv.ReqBody();
        theReqBody.birth_date = '1980-01-01';
        theReqBody.mobile_phone_no = '08000000001';

        RestRequest theReq = new RestRequest();
		theReq.httpMethod = 'POST';
		theReq.requestBody = Blob.valueof( JSON.Serialize(theReqBody) );

        RestContext.request = theReq;
        RestContext.response= new RestResponse();

        Test.startTest();
        Api_V1_LineAcntActv.doPost();
        Test.stopTest();
	}
}