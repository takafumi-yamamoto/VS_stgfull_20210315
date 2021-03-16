@RestResource(urlMapping='/api/v1/city_master/*')
global with sharing class Api_V1_Shikugun {

    @HttpGet
    global static void getAllData() {
        RestResponse res = RestContext.response;
        if (res == null) {
            res = new RestResponse();
            RestContext.response = res;
        }
        res.addHeader('Content-Type', 'application/json');

        try{

            List<Shikugun__c> shikugunList = Dao_Shikugun.getInstance().getAvaliableShikugunList();

            System.debug(JSON.serialize(shikugunList));

            res.statusCode = 200;
            res.responseBody = Blob.valueOf(JSON.serialize(shikugunList));

        } catch(Exception ex){
            res.statusCode = 500;
            res.responseBody = Blob.valueOf(JSON.serialize(ex.getMessage()));

            String err = '[エラーメッセージ]\r\n' + ex.getMessage() + '\r\n' + ex.getStackTraceString();
            String strText = '市区郡マスタの取得に失敗しました。\r\n\r\n' + err ;
            Utility_Common.sendEmail(System.Label.ErrorNotificationEmailAddress, '【市区郡マスタ取得エラー】', strText);
        }

    }
    
}