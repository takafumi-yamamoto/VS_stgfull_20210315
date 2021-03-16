@RestResource(urlMapping='/api/v1/obousanbin_siryoseikyu/*')
global with sharing class Api_V1_ObousanbinSiryoSeikyu {

    @HttpPost
    global static void doPost() {
    	System.debug('/api/v1/obousanbin_siryoseikyu/* doPost() start');
        RestResponse res = RestContext.response;
        if (res == null) {
            res = new RestResponse();
            RestContext.response = res;
        }
        
        System.Savepoint sp = Database.setSavepoint();
        
        Api_V1_ObousanbinSiryoSeikyu.Data theData = null;
        try {
            theData = (Api_V1_ObousanbinSiryoSeikyu.Data)JSON.deserialize(RestContext.request.requestBody.toString(), Api_V1_ObousanbinSiryoSeikyu.Data.class);

            // ケース作成
            Case newCase = new Case();
            //レコードタイプID
            newCase.RecordTypeId         = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','ObousanbinShiryoSeikyu');
            newCase.Status               = '新規';
            newCase.Origin               = 'Web';           
            // gaclient_id
            newCase.GaClientId__c        = theData.gaclient_id;
           //メール処理Id
            newCase.uniq_id__c           = theData.mail_syori_id;
            //問合せ日
            newCase.ToiawaseDate__c      = Com_Utility.toDateTime(theData.toiawase_date);
            //入口
            newCase.Entrance__c          = theData.iriguchi_name;
            //申込者姓
            newCase.LastName__c          = theData.customer_sei;
            //申込者名
            newCase.FirstName__c         = theData.customer_mei;
            //申込者姓(カナ)
            newCase.LastNameKana__c      = theData.customer_sei_kana;
            //申込者名(カナ)
            newCase.FirstNameKana__c     = theData.customer_mei_kana;
            //考え中のプラン
            newCase.HojiHoyo__c       = Api_V1_ItemValueMaster.getHojiHoyo(theData.hoyo);

            if(Com_Utility.isMobile(theData.customer_tel)) {
                //申込者携帯電話番号
                newCase.KeitaiDenwa__c       = theData.customer_tel;
            }
            else{
                //申込者固定電話番号
                newCase.TelNo__c             = theData.customer_tel;
            }
            //申込者メールアドレス
            newCase.MailAddress__c       = theData.customer_mail; 
            //法要日時の予定状況
            newCase.HoyouYoteiStaus__c       = Api_V1_ItemValueMaster.getHoyouYoteiStaus(theData.hoyo_yotei_jokyo); 
            //メンバー登録希望
            newCase.MemberTourokuKibo__c       = Api_V1_ItemValueMaster.getMemberTourokuKibo(theData.member_touroku_kibo);

            newCase.ShiryoSoufuHoho__c  = Api_V1_ItemValueMaster.getShiryoSoufuHoho(theData.shiryo_soufu_hoho);    // 資料送付方法
            newCase.ShiryoSoufuSakiAtena__c = theData.shiryo_soufusaki_atena;   // 資料送付 宛名
            newCase.ShiryoSoufuSakiAtenaKana__c = theData.shiryo_soufusaki_atenakana;   // 資料送付先 宛名(カナ)
            newCase.ShiryohassosakiZipCode__c   = theData.shiryo_soufusaki_postalcode;  // 資料送付先 郵便番号
            newCase.ShiryohassosakiState__c = theData.shiryo_soufusaki_state;   // 資料送付先 都道府県
            newCase.ShiryohassosakiCity__c  = theData.shiryo_soufusaki_city;    // 資料送付先 市区郡
            newCase.ShiryohassosakiStreet__c    = theData.shiryo_soufusaki_street;  // 資料送付先 町名番地
            newCase.ShiryoSoufuSakiMailAddress__c   = theData.shiryo_soufusaki_mailaddress; // 資料送付先 メールアドレス
 			// 資料送付先 メールマガジン
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

            String title = 'お坊さん便資料請求Exception';
            Loggings.writeLog(
               Loggings.createLogEntry(Loggings.Level.Error, '20181022-1800-00', 'Api_V1_ObousanbinSiryoSeikyu', title)
                   .putAttr('RequestBody', RestContext.request.requestBody.toString())
                   .putAttr('Description', 'お坊さん便資料請求Exception')
                   .putAttr('Exception', e.getMessage())
           );
        }
        System.debug('/api/v1/obousanbin_siryoseikyu/* doPost() end');
                            
    }

    public class Data{
        // gaclient_id
        public String gaclient_id   { get; set; }
    	//メール処理Id
        public String mail_syori_id { get;  set; }
        //問合せ日
        public String toiawase_date { get;  set; }
        //入口
        public String iriguchi_name	{ get;  set; }   
        //申込者姓
        public String customer_sei	{ get;  set; }
        //申込者名
        public String customer_mei	{ get;  set; }
        //申込者姓(カナ)
        public String customer_sei_kana	{ get;  set; }
        //申込者名(カナ)
        public String customer_mei_kana	{ get;  set; }
        //お考え中のプラン
        public String hoyo { get;  set; }
        //申込者電話番号
        public String customer_tel	{ get;  set; }
        //申込者メールアドレス
        public String customer_mail	{ get;  set; }
        //法要日時の予定状況
        public String hoyo_yotei_jokyo  { get;  set; }
        //メンバー登録希望
        public String member_touroku_kibo	{ get;  set; }

        public String shiryo_soufu_hoho   { get;  set; }            // 資料送付方法
        public String shiryo_soufusaki_atena  { get;  set; }            // 資料送付 宛名
        public String shiryo_soufusaki_atenakana  { get;  set; }            // 資料送付先 宛名(カナ)
        public String shiryo_soufusaki_postalcode { get;  set; }            // 資料送付先 郵便番号
        public String shiryo_soufusaki_state  { get;  set; }            // 資料送付先 都道府県
        public String shiryo_soufusaki_city   { get;  set; }            // 資料送付先 市区郡
        public String shiryo_soufusaki_street { get;  set; }            // 資料送付先 町名番地
        public String shiryo_soufusaki_mailaddress    { get;  set; }            // 資料送付先 メールアドレス
        public String mailmagazine { get; set; }                        // 資料送付先 メールマガジン
    }
}