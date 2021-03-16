global class YorisoAuthProvider extends Auth.AuthProviderPluginClass {

    private static String authorizationPath = '/oidc/2/auth';
    private static String tokenPath = '/oidc/2/token';
    private static String userInfoPath= '/oidc/2/me';

    global String getCustomMetadataType() {
        return 'YorisoAuthMetadataType__mdt';
    }

    global PageReference initiate(Map<string,string> authProviderConfiguration, String stateToPropagate) {
        return new PageReference(authProviderConfiguration.get('openIdHost__c') + authorizationPath + '?client_id=' + authProviderConfiguration.get('clientId__c') + '&redirect_uri=' + EncodingUtil.urlEncode(authProviderConfiguration.get('callbackUrl__c'), 'UTF-8') + '&scope=openid%20email%20profile&response_type=code&prompt=login&state=' + stateToPropagate);
    }
    
    global Auth.AuthProviderTokenResponse handleCallback(Map<string,string> authProviderConfiguration, Auth.AuthProviderCallbackState state ) {
        Map<String,String> queryParams = state.queryParameters;
        
        String code = queryParams.get('code');
        String sfdcState = queryParams.get('state');

        HttpRequest req = new HttpRequest();
        String url = authProviderConfiguration.get('openIdHost__c') +  tokenPath + '?state=' + sfdcState;
        req.setEndpoint(url);
        req.setHeader('Content-Type','application/x-www-form-urlencoded');
        req.setMethod('POST');
        req.setBody('code=' + code + '&client_id=' + authProviderConfiguration.get('clientId__c') +
            '&state=' + sfdcState +
            '&client_secret=' + authProviderConfiguration.get('clientSecret__c') + '&grant_type=authorization_code&redirect_uri=' + EncodingUtil.urlEncode(authProviderConfiguration.get('callbackUrl__c'), 'UTF-8'));

        Http http = new Http();
        HttpResponse res = http.send(req);
        String responseBody = res.getBody();

        String accessToken = getValueFromResponse(responseBody, 'access_token');
        String refreshToken = getValueFromResponse(responseBody, 'refresh_token');
        
        return new Auth.AuthProviderTokenResponse('YorisoAuthProvider', accessToken, refreshToken, sfdcState);
    }

    global Auth.UserData getUserInfo(Map<string,string> authProviderConfiguration, Auth.AuthProviderTokenResponse response) {
        String token = response.oauthToken;
        HttpRequest req = new HttpRequest();
        req.setEndpoint(authProviderConfiguration.get('openIdHost__c') + userInfoPath + '?access_token=' + token);
        req.setHeader('Content-Type','application/json');
        req.setMethod('GET');

        Http http = new Http();
        HttpResponse res = http.send(req);
        String responseBody = res.getBody();
        
        String id = getValueFromResponse(responseBody, 'sub');
        String fname = getValueFromResponse(responseBody, 'given_name');
        String lname = getValueFromResponse(responseBody, 'family_name');
        String flname = getValueFromResponse(responseBody, 'name');
        String email = getValueFromResponse(responseBody, 'email');
        String link = '';
        String locale = 'openid';
        Map<String,String> provMap = new Map<String,String>();
        
        return new Auth.UserData(id, fname, lname, flname, email, link, flname, locale, 'YorisoAuthProvider', null, provMap);
    }

    private String getValueFromResponse(String response, String key) {
        Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(response);
        return (String)responseMap.get(key);
    }
}