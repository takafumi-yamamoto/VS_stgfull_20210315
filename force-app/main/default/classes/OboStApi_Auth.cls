public class OboStApi_Auth {

	private static String accessTokenCacheKey = 'local.OboSt.AccessToken';

    public class Result{
            public Boolean isSuccess = false;
            public String endPoint = '';
            public Integer statusCode = 0;
            public String descr = '';
            public String reqBodyRaw = '';
            public String resBodyRaw = '';
            public ResBody resBody = null;
    }
    public class ReqBody{
    	public String grant_type;
    	public String client_id;
    	public String client_secret;
    	public String toPayload(){
    		String thePayload = '';
	        thePayload += 'grant_type=' + this.grant_type;
	        thePayload += '&client_id=' + this.client_id; 
	        thePayload += '&client_secret=' + this.client_secret;
	        return thePayload;
    	}
    }
    public class ResBody{
        public String token_type;
        public Integer expires_in;
        public String access_token;
    }

    public Result sendRequest(ReqBody pReqBody){
    	OboStConfig theConfig = new OboStConfig();

    	Result theResult = new Result();

    	try{
        	HttpRequest request = new HttpRequest(); 
	        request.setMethod('POST');
	        request.setHeader('Content-Type','application/x-www-form-urlencoded');

	        theResult.endPoint = theConfig.getBaseEndPoint() + '/api/oauth/token';
	        request.setEndpoint(theResult.endPoint);

	        theResult.reqBodyRaw = pReqBody.toPayload();
	        request.setBody(theResult.reqBodyRaw);

	        Http http = new Http();
	        HTTPResponse response = http.send(request);
	        theResult.statusCode = response.getStatusCode();
	        theResult.resBodyRaw = response.getBody();
	        theResult.isSuccess = theResult.statusCode == 200;
	 		if (theResult.isSuccess) {
				theResult.resBody = (ResBody)JSON.deserializeStrict(theResult.resBodyRaw,ResBody.class);
			}
    	}catch(Exception e){
            theResult.isSuccess = false;
            theResult.descr = e.getMessage();
            System.debug(theResult.descr);
    	}
    	
		if (!theResult.isSuccess) {
            Loggings.writeLog(
                Loggings.createLogEntry(Loggings.Level.Error, '20190410-1802-01', 'OboStApi_Auth.sendRequest')
                .putAttr('theResult.endPoint', theResult.endPoint)
                .putAttr('theResult.statusCode', String.valueOf(theResult.statusCode))
                //.putAttr('theResult.reqBodyRaw',theResult.reqBodyRaw) confidential-data
                //.putAttr('theResult.resBodyRaw',theResult.resBodyRaw) confidential-data
                .putAttr('theResult.descr',theResult.descr)
            );
		}
		return theResult;
    }

    public String getAccessToken(){
    	OboStConfig theConfig = new OboStConfig();

        String theAccessToken = this.tryGetAccessTokenFromCache();
        if(theAccessToken != null) return theAccessToken;

        ReqBody theReqBody = new ReqBody();
        theReqBody.grant_type = theConfig.getAuthGrantType();
        theReqBody.client_id = theConfig.getAuthClientId();
        theReqBody.client_secret = theConfig.getAuthClientSecret();

        Result theRes = this.sendRequest(theReqBody);
        if( theRes.isSuccess ){
        	this.resetAccessTokenCache(theRes.resBody);
        	theAccessToken = theRes.resBody.access_token;
        }

		return theAccessToken;
    }
    private String tryGetAccessTokenFromCache(){
    	if( Test.isRunningTest() ) return null;
    	if( !Cache.Org.contains(accessTokenCacheKey) ) return null;
		return (String)Cache.Org.get(accessTokenCacheKey);
    }
    private void resetAccessTokenCache(ResBody pResBody){
    	if( Test.isRunningTest() ) return;

	    Integer setExpiresIn = 0;
	    Integer resExpiresIn = pResBody.expires_in - 60; // Salesforce側のキャッシュは60秒短く設定する

	    if(resExpiresIn < 300){ setExpiresIn = 300; }// Salesforceで設定できる最小値(5分)を下回る場合
	    else if(resExpiresIn > 172800){ setExpiresIn = 172800; } // Salesforceで設定できる最大値(48時間)を上回る場合
	    else{ setExpiresIn = resExpiresIn; }

	    Cache.Org.put(accessTokenCacheKey, pResBody.access_token, setExpiresIn);
    }

    public void setAuthHeader(HttpRequest pRequest){
    	String theAccessToken = this.getAccessToken();
    	String theHeaderEntry = 'Bearer ';
    	if( theAccessToken != null ) theHeaderEntry += theAccessToken;
        pRequest.setHeader('Authorization', theHeaderEntry);
    }
}