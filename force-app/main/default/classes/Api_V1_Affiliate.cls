@RestResource(urlMapping='/api/v1/affiliate_uketsuke/*')
global with sharing class Api_V1_Affiliate {
    
    @HttpPost
    global static void create() {
        RestResponse res = RestContext.response;
        if (res == null) {
            res = new RestResponse();
            RestContext.response = res;
        }

        System.Savepoint sp = Database.setSavepoint();

        AffiCaseCreTask.Data theData = null;
        try {
            String jsonData = RestContext.request.requestBody.toString();
            theData = (AffiCaseCreTask.Data)JSON.deserialize(jsonData, AffiCaseCreTask.Data.class);

            insert new AffiCaseCreTask__c(data__c=jsonData, parent_mailshori_id__c=theData.parent_mailshori_id, shoriStatus__c='Created');

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

    }

}