@RestResource(urlMapping='/api/v1/hakapita/*')
global with sharing class Api_V1_Hakapita {
    @HttpPost
    global static void doPost() {
    	System.debug('/api/v1/hakapita/* doPost() start');
        RestResponse res = RestContext.response;
        if (res == null) {
            res = new RestResponse();
            RestContext.response = res;
        }
        
        System.Savepoint sp = Database.setSavepoint();
        
        Api_V1_Hakapita.Data theData = null;
        try {
            theData = (Api_V1_Hakapita.Data)JSON.deserialize(RestContext.request.requestBody.toString(), Api_V1_Hakapita.Data.class);        
            // ケース作成
            Case newCase = new Case();
            //レコードタイプID
            newCase.RecordTypeId         = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','HakapitaWebForm');
            newCase.Status               = '新規';
            newCase.Origin               = 'Web';           
           //メール処理Id
            newCase.uniq_id__c           = theData.uniq_id;
            //問合せ日
            newCase.ToiawaseDate__c      = Com_Utility.toDateTime(theData.req_day);           
            //入口
            newCase.Entrance__c          = theData.entrance;            
            //管理画面URL
            newCase.KanriGamenUrl__c     = theData.manage_screen_url;
            //最終見学日
            newCase.SaishuKengakubi__c   = Com_Utility.toDate(theData.last_tour_day); 
            //メールテキスト
            newCase.qa_mail__c           = theData.qa_mail;             
            //申込者姓
            newCase.LastName__c          = theData.last_name;
            //申込者名
            newCase.FirstName__c         = theData.first_name;
            //申込者姓(カナ)
            newCase.LastNameKana__c      = theData.last_name_kana;
            //申込者名(カナ)
            newCase.FirstNameKana__c     = theData.first_name_kana;            
            //申込者電話番号            
            if(Com_Utility.isMobile(theData.mobile)) {
                newCase.KeitaiDenwa__c       = theData.mobile;
            }
            else{
                newCase.TelNo__c             = theData.mobile;
            }
            //申込者メールアドレス
            newCase.MailAddress__c       = theData.email;
            //申込者住所.郵便番号
            newCase.PostalCode__c        = theData.address_zip_code;
            //申込者住所.都道府県
            newCase.State__c             = theData.address_state;
            //申込者住所.市区郡
            newCase.City__c              = theData.address_city;   
            //申込者住所.町名番地        
            newCase.Street__c            = theData.address_street;            
            //説明
            newCase.Description          = RestContext.request.requestBody.toString();
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
        System.debug('/api/v1/Api_V1_Hakapita/* doPost() start');
                            
    }    
    public class Data{
    	//メール処理Id
        public String uniq_id { get;  set; }
        //問合せ日
        public String req_day { get;  set; }
        //入口
        public String entrance	{ get;  set; }
        //管理画面URL
        public String manage_screen_url	{ get;  set; } 
        //最終見学日
        public String last_tour_day	{ get;  set; }
        //お問合せメール
        public String qa_mail	{ get;  set; }          
        //申込者姓
        public String last_name	{ get;  set; } 
        //申込者名
        public String first_name	{ get;  set; } 
        //申込者姓(カナ)
        public String last_name_kana	{ get;  set; } 
        //申込者名(カナ)
        public String first_name_kana	{ get;  set; } 
        //申込者電話番号
        public String mobile	{ get;  set; } 
        //申込者メールアドレス
        public String email	{ get;  set; } 
        //申込者住所.郵便番号
        public String address_zip_code	{ get;  set; } 
        //申込者住所.都道府県
        public String address_state	{ get;  set; }  
        //申込者住所.市区郡      
        public String address_city	{ get;  set; } 
        //申込者住所.町名番地
        public String address_street	{ get;  set; }                               
    }                       
}