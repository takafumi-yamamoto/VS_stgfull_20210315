public class PtWebApi_Auth {

    private class ReqBody{
        public String code = '';
        public String grant_type = '';
        public String redirect_uri = '';
    }

    private class ResBodyOnSuccess{
        public String access_token;
        public Integer expires_in;
        public String token_type;
    }

    public class Result{
        public Boolean isSuccess;
        public String endPoint;
        public Integer statusCode;
        public String reqBodyRaw;
        public String resBodyRaw;
        public String descr;
        public String access_token;
    }

    private static String ACCESS_TOKEN_CACHE_KEY = 'local.PartnerWeb.PtWebOauthAccessToken';

    public static Result getAccessToken(){
        Result theResult = new Result();
        theResult.isSuccess = false;

        if (!Test.isRunningTest() && Cache.Org.contains(ACCESS_TOKEN_CACHE_KEY)) {
            System.debug('トークン取得できた');
            theResult.access_token = (String)Cache.Org.get(ACCESS_TOKEN_CACHE_KEY);
            theResult.isSuccess = true;
            theResult.statusCode = 200;
        }
        else{
            System.debug('トークン取得できなかった');
            try{
                PtWebConfig__mdt theConfig = PtWebApi_Configs.getConfig();
                String theClientIdAndSecretOfBase64 = 
                    EncodingUtil.base64Encode(
                        Blob.valueOf( theConfig.client_id__c + ':' + theConfig.client_secret__c )
                    );
                String theAuthorizationHeaderValue = 'Basic ' + theClientIdAndSecretOfBase64;

                ReqBody theReqBody = new ReqBody();
                theReqBody.code = theConfig.code__c;
                theReqBody.grant_type = theConfig.grant_type__c;
                theReqBody.redirect_uri = theConfig.redirect_uri__c;

                HttpRequest request = new HttpRequest(); 
                request.setMethod('POST');
                request.setHeader('Content-Type','application/json');
                request.setHeader('Authorization',theAuthorizationHeaderValue);

                theResult.endPoint = theConfig.BaseEndPoint__c + '/api/oauth2/token';
                request.setEndpoint(theResult.endPoint);

                theResult.reqBodyRaw = JSON.serialize(theReqBody);
                request.setBody( theResult.reqBodyRaw );

                HttpResponse response = new http().send(request);
                theResult.statusCode = response.getStatusCode();  
                theResult.resBodyRaw = response.getBody();
                if(theResult.statusCode == 200){
                    ResBodyOnSuccess theResOnSuccess = (ResBodyOnSuccess)JSON.deserialize(theResult.resBodyRaw, ResBodyOnSuccess.class);
                    theResult.access_token = theResOnSuccess.access_token;
                    if (!Test.isRunningTest()){
                        Integer setExpiresIn = 0;
                        // Salesforce側のキャッシュは60秒短く設定する
                        Integer resExpiresIn = Integer.valueOf(theResOnSuccess.expires_in) - 60;
                        
                        // Salesforceで設定できる最小値(5分)を下回る場合
                        if(resExpiresIn < 300){
                            setExpiresIn = 300;
                        }
                        // Salesforceで設定できる最大値(48時間)を上回る場合
                        else if(resExpiresIn > 172800){
                            setExpiresIn = 172800;
                        }
                        else{
                            setExpiresIn = resExpiresIn;
                        }
                        Cache.Org.put(ACCESS_TOKEN_CACHE_KEY, theResOnSuccess.access_token, setExpiresIn);
                    }
                }
                else {
                    Loggings.writeLog(
                        Loggings.createLogEntry(Loggings.Level.Error, '20180920-1635-01', 'AccessToken')
                        .putAttr('theResult.endPoint', theResult.endPoint)
                        .putAttr('theResult.statusCode', String.valueOf(theResult.statusCode))
                        .putAttr('theResult.reqBodyRaw',theResult.reqBodyRaw)
                        .putAttr('theResult.resBodyRaw',theResult.resBodyRaw)
                        .putAttr('theResult.descr',theResult.descr)
                    );
                }
                theResult.isSuccess = theResult.statusCode == 200 ? true : false;
            }catch(Exception e){
                theResult.isSuccess = false;
                theResult.descr = e.getMessage();
                System.Debug(e.getMessage());
            }
        }

        return theResult;
    }

    public static void setAuthHeader(HttpRequest pRequest){
        String token = 'Bearer ' + getAccessToken().access_token;
        pRequest.setHeader('Authorization', token);
    }
}