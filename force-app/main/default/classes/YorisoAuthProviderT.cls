@isTest
public class YorisoAuthProviderT {
    @isTest
    public static void getCustomMetadataType(){
        System.assertEquals('YorisoAuthMetadataType__mdt', new YorisoAuthProvider().getCustomMetadataType());
        return;
    }
    
    @isTest
    public static void initiate(){
        Map<string,string> authProviderConfiguration = new Map<String,String>();
        authProviderConfiguration.put('openIdHost__c', 'https://test.test');
        authProviderConfiguration.put('clientId__c', 'test');
        authProviderConfiguration.put('clientSecret__c', 'test');
        authProviderConfiguration.put('callbackUrl__c', 'https://test.test/callback');
        String stateToPropagate = 'test';
          
        System.assertNotEquals(null, new YorisoAuthProvider().initiate(authProviderConfiguration, stateToPropagate));
    }
    
    @isTest
    public static void handleCallback(){
        Test.setMock( HttpCalloutMock.class, new HttpResponseMock().setStatusCode(200).setBody( JSON.serialize( new Map<String,String>() ) ) );
            
        Map<string,string> authProviderConfiguration = new Map<String,String>();
        authProviderConfiguration.put('openIdHost__c', 'https://test.test');
        authProviderConfiguration.put('clientId__c', 'test');
        authProviderConfiguration.put('clientSecret__c', 'test');
        authProviderConfiguration.put('callbackUrl__c', 'https://test.test/callback');
       
        Map<string,string> queryParameters = new Map<String,String>();
        queryParameters.put('code', 'test');
        queryParameters.put('state', 'test');       
        Auth.AuthProviderCallbackState state = new Auth.AuthProviderCallbackState(null, null, queryParameters);
      
        System.assertNotEquals(null, new YorisoAuthProvider().handleCallback(authProviderConfiguration, state));
    }
    
    @isTest
    public static void getUserInfo(){
        Test.setMock( HttpCalloutMock.class, new HttpResponseMock().setStatusCode(200).setBody( JSON.serialize( new Map<String,String>() ) ) );

        String provider;
        String oauthToken;
        String oauthSecretOrRefreshToken;
        String state;
        Auth.AuthProviderTokenResponse tokenResponse = new Auth.AuthProviderTokenResponse(provider, oauthToken, oauthSecretOrRefreshToken, state);
        System.assertNotEquals(null, new YorisoAuthProvider().getUserInfo(new Map<String,String>(), tokenResponse));
    }
}