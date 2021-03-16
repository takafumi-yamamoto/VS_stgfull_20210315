@isTest
public class Api_V1_OboTeikeiMoushikomiT {

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
    	

        Api_V1_OboTeikeiMoushikomi.ReqBody theReqBody = new Api_V1_OboTeikeiMoushikomi.ReqBody();
        theReqBody.last_name = 'テストよりそう';
        theReqBody.first_name = '太郎';
        theReqBody.sei_kana = 'てすとよりそう';
        theReqBody.mei_kana = 'たろう';
        theReqBody.postal_code = '1410031';
        theReqBody.state = '東京都';
        theReqBody.city = '品川区';
        theReqBody.street = '西五反田１－１';
        theReqBody.mobile_phone = '08000010001';
        theReqBody.email = 'takeharu-umezaki@yoriso.com';
        theReqBody.shuha = '浄土真宗本願寺派';
        theReqBody.jiinmei = 'よりそう寺';
        theReqBody.jiinmei_kana = 'よりそうじ';
        theReqBody.tani_shubetsu = '単立';
        theReqBody.tasha_toroku_kakunin = 'あり';
        theReqBody.moshikomi_keii = '知人からの口コミ';
        theReqBody.biko = 'お寺は実家の〇〇県〇〇市にあり現在〇〇市内で就職しているため現住所は普通の住宅であり寺院はありません事を事前にお伝え致します。';

        RestRequest theReq = new RestRequest();
		theReq.httpMethod = 'POST';
		theReq.requestBody = Blob.valueof( JSON.Serialize(theReqBody) );

        RestContext.request = theReq;
        RestContext.response= new RestResponse();

        Test.startTest();
        Api_V1_OboTeikeiMoushikomi.doPost();
        Test.stopTest();
	}
}