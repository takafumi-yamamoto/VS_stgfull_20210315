@RestResource(urlMapping='/api/v1/simple_yasugo_endingnote/*')
global with sharing class Api_V1_SimpleYasugoEndingNote {

    @HttpPost
    global static void doPost() {
        System.debug('/api/v1/simple_yasugo_endingnote/* doPost() start');

        RestResponse res = RestContext.response;
        if (res == null) {
            res = new RestResponse();
            RestContext.response = res;
        }

        System.Savepoint sp = Database.setSavepoint();
        
        Api_V1_SimpleYasugoEndingNote.Data theData = null;
        try {
            theData = (Api_V1_SimpleYasugoEndingNote.Data)JSON.deserialize(RestContext.request.requestBody.toString(), Api_V1_SimpleYasugoEndingNote.Data.class);

            // ケース作成
            Case newCase = new Case();
            newCase.RecordTypeId         = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','SimpleYasugoEndingnoteWebForm');
            newCase.GaClientId__c        = theData.gaclient_id;
            newCase.Status               = '新規';
            newCase.Origin               = 'Web';
            newCase.uniq_id__c           = theData.mail_syori_id;
            newCase.ToiawaseDate__c      = Com_Utility.toDateTime(theData.toiawase_date);
            newCase.Entrance__c          = theData.iriguchi_name;
            newCase.MemberTourokuKibo__c = Api_V1_ItemValueMaster.getMemberTourokuKibo(theData.member_touroku_kibo);
            newCase.WebAccountKibo__c    = Api_V1_ItemValueMaster.getWebAccountKibo(theData.web_account_kibo);
            newCase.Lastname__c          = theData.customer_sei;
            newCase.Firstname__c         = theData.customer_mei;
            newCase.LastNameKana__c      = theData.customer_sei_kana;
            newCase.FirstNameKana__c     = theData.customer_mei_kana;
            if(Com_Utility.isMobile(theData.customer_tel)) {
                newCase.KeitaiDenwa__c       = theData.customer_tel;
            }
            else{
                newCase.TelNo__c             = theData.customer_tel;
            }
            newCase.MailAddress__c       = theData.customer_mail;
            newCase.PostalCode__c        = theData.customer_postal_code;
            newCase.State__c             = theData.customer_state;
            newCase.City__c              = theData.customer_city;
            newCase.Street__c            = theData.customer_street;
            newCase.KiboAreaState__c     = theData.sogi_yotei_area_state;
            newCase.KiboAreaCity__c      = theData.sogi_yotei_area_city;
            if(theData.mailmagazine == '1'){
	            newCase.PermissionFlag__c                    = TRUE ;
            }
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

        System.debug('/api/v1/simple_yasugo_endingnote/* doPost() end');
    }

    public class Data{
        public String gaclient_id { get;  set; }
        public String mail_syori_id { get;  set; }
        public String toiawase_date { get;  set; }
        public String iriguchi_name { get;  set; }
        public String member_touroku_kibo { get;  set; }
        public String web_account_kibo { get;  set; }
        public String customer_sei { get;  set; }
        public String customer_mei { get;  set; }
        public String customer_sei_kana { get;  set; }
        public String customer_mei_kana { get;  set; }
        public String customer_tel { get;  set; }
        public String customer_mail { get;  set; }
        public String customer_postal_code { get;  set; }
        public String customer_state { get;  set; }
        public String customer_city { get;  set; }
        public String customer_street { get;  set; }
        public String sogi_yotei_area_state { get;  set; }
        public String sogi_yotei_area_city { get;  set; }
        public String sozoku_sodan_kibo { get;  set; }
        public String mailmagazine { get; set; }
    }
}