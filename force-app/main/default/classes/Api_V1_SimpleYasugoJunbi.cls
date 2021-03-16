@RestResource(urlMapping='/api/v1/simple_yasugo_junbi/*')
global class Api_V1_SimpleYasugoJunbi {

    @HttpPost
    global static void doPost() {
        System.debug('/api/v1/simple_yasugo_junbi/* doPost() start');
        System.debug('RestContext.request.requestBody.toString():' + RestContext.request.requestBody.toString());

        RestResponse res = RestContext.response;
        if (res == null) {
            res = new RestResponse();
            RestContext.response = res;
        }

        System.Savepoint sp = Database.setSavepoint();
        
        Api_V1_SimpleYasugoJunbi.Data theData = null;
        try {
            theData = (Api_V1_SimpleYasugoJunbi.Data)JSON.deserialize(RestContext.request.requestBody.toString(), Api_V1_SimpleYasugoJunbi.Data.class);

            // ケース作成
            Case newCase = new Case();
            newCase.RecordTypeId                                = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','SimpleYasugoJizenJunbiWebForm');
            newCase.Status                                      = '新規';
            newCase.Origin                                      = 'Web';
            newCase.GaClientId__c                               = theData.gaclient_id;
            newCase.uniq_id__c                                  = theData.mail_syori_id;
            newCase.ToiawaseDate__c                             = Com_Utility.toDateTime(theData.toiawase_date);
            //newCase.Entrance__c                                 = theData.iriguchi_name;
            newCase.LoginTorihikisakiBango__c                   = theData.customer_bango;
            newCase.Lastname__c                                 = theData.customer_sei;
            newCase.Firstname__c                                = theData.customer_mei;
            newCase.LastNameKana__c                             = theData.customer_sei_kana;
            newCase.FirstNameKana__c                            = theData.customer_mei_kana;
            newCase.Seinengappi__c                              = Com_Utility.toDate(theData.customer_birthday);
            if(Com_Utility.isMobile(theData.customer_tel)) {
                newCase.KeitaiDenwa__c       = theData.customer_tel;
            }
            else{
                newCase.TelNo__c             = theData.customer_tel;
            }
            newCase.MailAddress__c                              = theData.customer_mail;
            newCase.PostalCode__c                               = theData.customer_postal_code;
            newCase.State__c                                    = theData.customer_state;
            newCase.City__c                                     = theData.customer_city;
            newCase.Street__c                                   = theData.customer_street;
            newCase.TaishoushaJokyo__c                          = Api_V1_ItemValueMaster.getTaishoushaJokyo(theData.taisyosya_jokyo);
            newCase.TaishoshaSei__c                             = theData.taisyosya_sei;
            newCase.TaishoshaMei__c                             = theData.taisyosya_mei;
            newCase.TaishoshaSeiFurigana__c                     = theData.taisyosya_sei_kana;
            newCase.TaishoshaMeiFurigana__c                     = theData.taisyosya_mei_kana;
            newCase.TaishoshaSeinengappi__c                     = Com_Utility.toDate(theData.taisyosya_birthday);
            if(Com_Utility.isMobile(theData.taisyosya_tel)) {
                newCase.TaishoshaKeitaiDenwa__c       = theData.taisyosya_tel;
            }
            else{
                newCase.TaishoshaTelNo__c             = theData.taisyosya_tel;
            }
            newCase.TaishoshaZipCode__c                         = theData.taisyosya_postal_code;
            newCase.TaishoshaState__c                           = theData.taisyosya_state;
            newCase.TaishoshaCity__c                            = theData.taisyosya_city;
            newCase.TaishoshaStreet__c                          = theData.taisyosya_street;
            newCase.TaishoshaJuminhyoState__c                   = theData.taisyosya_juminhyo_state;
            newCase.TaishoshaJuminhyoCity__c                    = theData.taisyosya_juminhyo_city;
            newCase.Shuha__c                                    = theData.taisyosya_syuha;
            newCase.SonotanoSyukyoSyuha__c                      = theData.taisyosya_sonotasyuha;
            newCase.TaishoshaBodaijinoUmu__c                    = Api_V1_ItemValueMaster.getTaisyosyaBodaijiUmu(theData.taisyosya_bodaiji_umu);
            newCase.ZokugaraSodanshaNitottenoTaishosha__c       = Api_V1_ItemValueMaster.getTaisyosyaFromCustomer(theData.taisyosya_from_customer);
            newCase.ZokugaraSodanshaNitottenoTaishoshaSonota__c = theData.taisyosya_from_customer_sonota;
            newCase.OmukaesakiMeisho__c                         = theData.omukae_name;
            newCase.OmukaesakiZipCode__c                        = theData.omukae_postal_code;
            newCase.OmukaesakiState__c                          = theData.omukae_state;
            newCase.OmukaesakiCity__c                           = theData.omukae_city;
            newCase.OmukaesakiStreet__c                         = theData.omukae_street;
            newCase.AnchiKubun__c                               = Api_V1_ItemValueMaster.getAnchisakiKubun(theData.anchisaki_kubun);
            newCase.KiboAreaState__c                            = theData.sogi_yotei_area_state;
            newCase.KiboAreaCity__c                             = theData.sogi_yotei_area_city;
            newCase.KiboPlan__c                                 = Api_V1_ItemValueMaster.getSimpleyasugoPlan(theData.simpleyasugo_plan);
            newCase.ObosanbinOption__c                          = Api_V1_ItemValueMaster.getSimpleyasugoObousanbinPlan(theData.simpleyasugo_obousanbin_plan);
            newCase.SozokusodanKibo__c                          = Api_V1_ItemValueMaster.getSozokuSodanKibo(theData.sozoku_sodan_kibo);
            if( !String.isBlank(theData.yoriso_wo_sitta_kikkake) ){ newCase.YorisoWoSittaKikkake__c = theData.yoriso_wo_sitta_kikkake; }
            
            List<String> Listcampaign_id = new List<String>();
            if(String.isNotBlank(theData.campaign_id)){
                Listcampaign_id = theData.campaign_id.split(',');
                newCase.CampaignMoshikomiName__c = String.join(Listcampaign_id, ';');
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

        System.debug('/api/v1/simple_yasugo_junbi/* doPost() end');
    }

    public class Data{
        public String gaclient_id { get; set; }
        public String mail_syori_id { get; set; }
        public String toiawase_date { get; set; }
        //public String iriguchi_name { get; set; }
        public String customer_bango { get; set; }
        public String customer_sei { get; set; }
        public String customer_mei { get; set; }
        public String customer_sei_kana { get; set; }
        public String customer_mei_kana { get; set; }
        public String customer_birthday { get; set; }
        public String customer_tel { get; set; }
        public String customer_mail { get; set; }
        public String customer_postal_code { get; set; }
        public String customer_state { get; set; }
        public String customer_city { get; set; }
        public String customer_street { get; set; }
        public String taisyosya_jokyo { get; set; }
        public String taisyosya_sei { get; set; }
        public String taisyosya_mei { get; set; }
        public String taisyosya_sei_kana { get; set; }
        public String taisyosya_mei_kana { get; set; }
        public String taisyosya_birthday { get; set; }
        public String taisyosya_tel { get; set; }
        public String taisyosya_postal_code { get; set; }
        public String taisyosya_state { get; set; }
        public String taisyosya_city { get; set; }
        public String taisyosya_street { get; set; }
        public String taisyosya_juminhyo_state { get; set; }
        public String taisyosya_juminhyo_city { get; set; }
        public String taisyosya_syuha { get; set; }
        public String taisyosya_sonotasyuha { get; set; }
        public String taisyosya_bodaiji_umu { get; set; }
        public String taisyosya_from_customer { get; set; }
        public String taisyosya_from_customer_sonota { get; set; }
        public String omukae_name { get; set; }
        public String omukae_postal_code { get; set; }
        public String omukae_state { get; set; }
        public String omukae_city { get; set; }
        public String omukae_street { get; set; }
        public String anchisaki_kubun { get; set; }
        public String sogi_yotei_area_state { get; set; }
        public String sogi_yotei_area_city { get; set; }
        public String simpleyasugo_plan { get; set; }
        public String simpleyasugo_obousanbin_plan { get; set; }
        public String sozoku_sodan_kibo { get; set; }
        public String campaign_id { get; set; }
        public String yoriso_wo_sitta_kikkake { get; set; }
    }
}