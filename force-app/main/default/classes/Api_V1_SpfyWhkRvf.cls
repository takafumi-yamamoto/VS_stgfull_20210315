public class Api_V1_SpfyWhkRvf {
	
	public interface IVerifyWebhook{
		Boolean verify(RestRequest pRestRequest);
	}

	public class WebhookVerification implements IVerifyWebhook{
        private String mHmacSecret;
        public WebhookVerification(String pHmacSecret){
            this.mHmacSecret = pHmacSecret;
        }
		public Boolean verify(RestRequest pRestRequest){
			String theSecret = this.mHmacSecret;
			
			RestRequest theReq = pRestRequest;
			Boolean isVerified = false;
			try{
				isVerified =
					Crypto.verifyHMac(
						'HmacSHA256', 
						theReq.requestBody, 
						Blob.valueOf(theSecret), 
						EncodingUtil.base64Decode(theReq.headers.get('X-Shopify-Hmac-Sha256'))
					);
			}
			catch(Exception ex){
				isVerified = false;
			}
			return isVerified;
		}
	}
}