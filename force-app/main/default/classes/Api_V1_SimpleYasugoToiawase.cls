@RestResource(urlMapping='/api/v1/simple_yasugo_toiawase/*')
global with sharing class Api_V1_SimpleYasugoToiawase {

    @HttpPost
    global static void doPost() {
        System.debug('/api/v1/simple_yasugo_toiawase/* doPost() start');

        RestResponse res = RestContext.response;
        if (res == null) {
            res = new RestResponse();
            RestContext.response = res;
        }

        System.Savepoint sp = Database.setSavepoint();
        
        Api_V1_SimpleYasugoToiawase.Data theData = null;

        try {
            theData = (Api_V1_SimpleYasugoToiawase.Data)JSON.deserialize(RestContext.request.requestBody.toString(), Api_V1_SimpleYasugoToiawase.Data.class);

            // ケース作成
            Case newCase = new Case();
            newCase.RecordTypeId         = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','SimpleYasugoOtoiawaseWebForm');
            newCase.Status               = '新規';
            newCase.Origin               = 'Web';
            newCase.GaClientId__c        = theData.gaclient_id;
            newCase.uniq_id__c           = theData.mail_syori_id;
            newCase.ToiawaseDate__c      = Com_Utility.toDateTime(theData.toiawase_date);
            newCase.Entrance__c          = theData.iriguchi_name;
            newCase.Lastname__c          = theData.customer_sei;
            newCase.Firstname__c         = theData.customer_mei;
            newCase.LastNameKana__c      = theData.customer_sei_kana;
            newCase.FirstNameKana__c     = theData.customer_mei_kana;
            newCase.MailAddress__c       = theData.customer_mail;
            newCase.OkyakusamaCommnet__c = theData.customer_comment;
            insert newCase;

            res.responseBody = Blob.valueOf(JSON.serialize(theData));
            res.statusCode = 200;

        } catch(Exception e) {
            String err = '[エラーメッセージ]\r\n' + e.getMessage() + '\r\n' + e.getStackTraceString();
            Database.rollback(sp);
            res.responseBody = Blob.valueOf(err);
            res.statusCode = 500;

            String strText = 'ケースの作成が失敗しました。\r\n\r\n' + err + '\r\n\r\n' + '[問合せ内容]\r\n' + theData;
            Utility_Common.sendEmail(System.Label.ErrorNotificationEmailAddress, '【ケース作成エラー】', strText);
        }

        System.debug('/api/v1/simple_yasugo_toiawase/* doPost() start');
    }

    public class Data{
        public String gaclient_id { get;  set; }
        public String mail_syori_id { get;  set; }
        public String toiawase_date { get;  set; }
        public String iriguchi_name { get;  set; }
        public String customer_sei { get;  set; }
        public String customer_mei { get;  set; }
        public String customer_sei_kana { get;  set; }
        public String customer_mei_kana { get;  set; }
        public String customer_mail { get;  set; }
        public String customer_comment { get;  set; }
    }
}