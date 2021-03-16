/**
* 決済結果通知受信
* https://minrevi.atlassian.net/wiki/spaces/dev/pages/642383873/SF+API
*/
@RestResource(urlMapping='/api/v1/webpay/*')
global with sharing class Api_V1_WepPayKekkaUketsuke {
    
    @HttpPost
    global static void kekka() {
        RestResponse res = RestContext.response;
        if (res == null) {
            res = new RestResponse();
            RestContext.response = res;
        }

        System.Savepoint sp = Database.setSavepoint();

        Data theData = null;
        try {
            theData = (Data)JSON.deserialize(RestContext.request.requestBody.toString(), Data.class);

            insert theData.getWepPayKekkaUketsukeTask();

            res.responseBody = Blob.valueOf(JSON.serialize(theData));
            res.statusCode = 200;

        } catch(Exception ex) {
            String err = '[エラーメッセージ]\r\n' + ex.getMessage() + '\r\n' + ex.getStackTraceString();
            Database.rollback(sp);
            res.responseBody = Blob.valueOf(err);
            res.statusCode = 500;

            String title = '決済結果通知受信Exception';
            Loggings.writeLog(
               Loggings.createLogEntry(Loggings.Level.Error, Datetime.now().format('yyyyMMdd-HHmm-ss'), 'CoreKessai.Api_V1_WepPayKekkaUketsuke', title)
                   .putAttr('RequestBody', RestContext.request.requestBody.toString())
                   .putAttr('Description', '決済結果受付タスクの作成エラー')
                   .putAttr('Exception', ex.getMessage())
           );
        }

    }

    public class Data{
        public String seikyu_bango { get; set; }                    // 請求番号
        public String status { get; set; }                  // 処理結果
		public Boolean sokujiUriage { get; set; }					// 即時売上
        public List<Errors> errors { get; set; }                   // エラーメッセージ

        public WepPayKekkaUketsukeTask__c getWepPayKekkaUketsukeTask(){
            WepPayKekkaUketsukeTask__c weppaykekkauketsuketask = new WepPayKekkaUketsukeTask__c();
            weppaykekkauketsuketask.ErrorMessage__c = getErrorMessage();    //ErrorMessage
            weppaykekkauketsuketask.Status__c = status;    //Status
            weppaykekkauketsuketask.SeikyuBango__c = seikyu_bango;    //請求番号

            weppaykekkauketsuketask.ShoriStatus__c = '未処理';    //処理ステータス
            return weppaykekkauketsuketask;
        }

        private String getErrorMessage(){
            String errorMsg = JSON.serializePretty(errors);
            if(String.isNotBlank(errorMsg)){
                errorMsg = errorMsg.left(32768);
            }
            return errorMsg;
        }
    }

    public class Errors {
        public String error_descr;
        public String error_code;
    }

}