public class RsCoreApi_AuthClients{

    public interface IAuthClient{
        String getAccessToken();
        Void setAuthHeader(HttpRequest pRequest);
    }

    private static IAuthClient instance;
    public static IAuthClient getInstance(){
        if(instance == null){ instance = new AuthClient(RsCoreApi_Configs.getConfig()); }
        return instance;
    }

    public class Result{
            public Boolean isSuccess = false;
            public String endPoint = '';
            public Integer statusCode = 0;
            public String descr = '';
            public String reqBodyRaw = '';
            public String resBodyRaw = '';
    }

    public class AuthClient implements IAuthClient{

        private KaiinkibanSetting__c f_setting;
        public AuthClient(KaiinkibanSetting__c pKaiinkibanSetting){
            this.f_setting = pKaiinkibanSetting;
        }
        
        public String getAccessToken(){
            Result theResult = new Result();
            String accessToken = '';
            if (!Test.isRunningTest() && Cache.Org.contains('local.CoreOauth.AccessToken')) {
                System.debug('トークン取得できた');
                accessToken = (String)Cache.Org.get('local.CoreOauth.AccessToken');
            }
            else{
                System.debug('トークン取得できなかった');
                HttpRequest request = new HttpRequest(); 
                request.setMethod('POST');
                request.setHeader('Content-Type','application/x-www-form-urlencoded');

                theResult.endPoint = this.f_setting.Endpoint__c + '/oauth/token';
                request.setEndpoint(theResult.endPoint);

                theResult.reqBodyRaw = 'grant_type=client_credentials' + 
                                        '&client_id=' + this.f_setting.client_id__c +
                                        '&client_secret=' + this.f_setting.client_secret__c;
                request.setBody(theResult.reqBodyRaw);

                Http http = new Http();
                HTTPResponse response = http.send(request);
                theResult.statusCode = response.getStatusCode();
                theResult.resBodyRaw = response.getBody();
                theResult.isSuccess = theResult.statusCode == 200;

                if (response.getStatusCode() == 200) {
                    //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'TOKEN RESPONSE: ' + response.toString()));
                    JSONTokenResponse tokenResponse = (JSONTokenResponse)JSON.deserializeStrict(response.getBody(),JSONTokenResponse.class);
                    if (!Test.isRunningTest()){
                        Integer setExpiresIn = 0;
                        // Salesforce側のキャッシュは60秒短く設定する
                        Integer resExpiresIn = Integer.valueOf(tokenResponse.expires_in) - 60;
                        
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
                        Cache.Org.put('local.CoreOauth.AccessToken', tokenResponse.access_token, setExpiresIn);
                        System.debug('setExpiresIn:' + setExpiresIn);
                    }
                    accessToken = tokenResponse.access_token;
                    System.debug('accessToken:' + accessToken);
                    //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'ACCESS TOKEN: ' + tokenResponse.access_token));
                }
                else {
                    Loggings.writeLog(
                        Loggings.createLogEntry(Loggings.Level.Error, '20180919-1755-01', 'AccessToken')
                        .putAttr('theResult.endPoint', theResult.endPoint)
                        .putAttr('theResult.statusCode', String.valueOf(theResult.statusCode))
                        .putAttr('theResult.reqBodyRaw',theResult.reqBodyRaw)
                        .putAttr('theResult.resBodyRaw',theResult.resBodyRaw)
                        .putAttr('theResult.descr',theResult.descr)
                    );
                }
            }

            return accessToken;
        }

        public void setAuthHeader(HttpRequest pRequest){
            String token = 'Bearer ' + this.getAccessToken();
            System.debug(token);
            pRequest.setHeader('Authorization', token);
        }
    }

    @TestVisible
    private class JSONTokenResponse {
        public String token_type;
        public String expires_in;
        public String access_token;
    }
}