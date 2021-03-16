@RestResource(urlMapping='/api/v1/umie_moushikomi/*')
global with sharing class Api_V1_UmieMoushikomi {

    @HttpPost
    global static void doPost() {
        System.debug('/api/v1/umie_moushikomi/* doPost() start');

        RestResponse res = RestContext.response;
        if (res == null) {
            res = new RestResponse();
            RestContext.response = res;
        }

        System.Savepoint sp = Database.setSavepoint();
        
        try {
            Api_V1_UmieMoushikomi.Data theData = (Api_V1_UmieMoushikomi.Data)JSON.deserialize(RestContext.request.requestBody.toString(), Api_V1_UmieMoushikomi.Data.class);

            // ケース作成
            Case newCase = new Case();
            newCase.RecordTypeId                                = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','KaiyosankotsuMoshikomiWebForm');
            newCase.Status                                      = '新規';
            newCase.Origin                                      = 'Web';
            newCase.uniq_id__c                                  = theData.mail_syori_id;
            newCase.ToiawaseDate__c                             = Com_Utility.toDateTime(theData.toiawase_date);
            newCase.Entrance__c                                 = theData.iriguchi_name;
            newCase.Lastname__c                                 = theData.customer_sei;
            newCase.Firstname__c                                = theData.customer_mei;
            newCase.LastNameKana__c                             = theData.customer_sei_kana;
            newCase.FirstNameKana__c                            = theData.customer_mei_kana;
            newCase.KeitaiDenwa__c                              = theData.customer_keitai_denwa;
            newCase.TelNo__c                                    = theData.customer_kotei_denwa;
            newCase.MailAddress__c                              = theData.customer_mail;
            newCase.PostalCode__c                               = theData.customer_postal_code;
            newCase.State__c                                    = theData.customer_state;
            newCase.City__c                                     = theData.customer_city;
            newCase.Street__c                                   = theData.customer_street;
            newCase.TaishoshaSei__c                             = theData.taisyosya_sei;
            newCase.TaishoshaMei__c                             = theData.taisyosya_mei;
            newCase.TaishoshaSeiFurigana__c                     = theData.taisyosya_sei_kana;
            newCase.TaishoshaMeiFurigana__c                     = theData.taisyosya_mei_kana;
            newCase.ZokugaraSodanshaNitottenoTaishosha__c       = Api_V1_ItemValueMaster.getTaisyosyaFromCustomer(theData.taisyosya_from_customer);
            newCase.ZokugaraSodanshaNitottenoTaishoshaSonota__c = theData.taisyosya_from_customer_sonota;
            newCase.SankotsuKaiiki__c                           = Api_V1_ItemValueMaster.getSankotsuKaiiki(theData.sankotsu_kaiiki);
            newCase.OkyakusamaCommnet__c                        = theData.customer_comment;
            newCase.SozokusodanKibo__c                          = Api_V1_ItemValueMaster.getSozokuSodanKibo(theData.sozoku_sodan_kibo);
            insert newCase;

            res.responseBody = Blob.valueOf(JSON.serialize(theData));
            res.statusCode = 200;

        } catch(Exception e) {
            String err = 'エラーメッセージ:' + e.getMessage() + '\n' + e.getStackTraceString();
            System.debug('err:' + err);
            Database.rollback(sp);
            res.responseBody = Blob.valueOf(err);
            res.statusCode = 500;
        }

        System.debug('/api/v1/umie_moushikomi/* doPost() end');
    }

    public class Data{
        public String mail_syori_id { get; set; }
        public String toiawase_date { get; set; }
        public String iriguchi_name { get; set; }
        public String customer_sei { get; set; }
        public String customer_mei { get; set; }
        public String customer_sei_kana { get; set; }
        public String customer_mei_kana { get; set; }
        public String customer_keitai_denwa { get; set; }
        public String customer_kotei_denwa { get; set; }
        public String customer_mail { get; set; }
        public String customer_postal_code { get; set; }
        public String customer_state { get; set; }
        public String customer_city { get; set; }
        public String customer_street { get; set; }
        public String taisyosya_sei { get; set; }
        public String taisyosya_mei { get; set; }
        public String taisyosya_sei_kana { get; set; }
        public String taisyosya_mei_kana { get; set; }
        public String taisyosya_from_customer { get; set; }
        public String taisyosya_from_customer_sonota { get; set; }
        public String sankotsu_kaiiki { get; set; }
        public String customer_comment { get; set; }
        public String sozoku_sodan_kibo { get; set; }
    }
}