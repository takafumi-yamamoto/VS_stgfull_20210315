@RestResource(urlMapping='/api/v1/shopify-webhooks/*')

global without sharing class Api_V1_SpfyWhk {

	public static Api_V1_SpfyWhkRvf.IVerifyWebhook mWebhookVerification 
		= new Api_V1_SpfyWhkRvf.WebhookVerification(
            SpfyConfs.getConfig().hmac_secret
        );

	@HttpPost
	global static void httpPost(){
		RestRequest theReq = RestContext.request;
        RestResponse theRes = RestContext.response;
        theRes.responseBody = Blob.valueOf('request_arrived');
        try{
            new Runner().run(theReq, theRes);
        }catch(Exception ex){
            Loggings.writeLog(
                Loggings.createLogEntry(Loggings.Level.Error, '20200618-1430', 'Api_V1_SpfyWhk.httpPost')
                    .putAttr('Exception', ex.getMessage())
                    .putAttr('LineNumber', '' + ex.getLineNumber())
                    .putAttr('getStackTraceString', ex.getStackTraceString())
            );
            throw ex;
        }
    }

    public class Runner{
        public void run(RestRequest pReq, RestResponse pRes){
            RestRequest theReq = pReq;
            RestResponse theRes = pRes;
    
            if(SpfyConfs.getConfig().hmac_enabled){
                if( !mWebhookVerification.verify(theReq) ){
                    theRes.statusCode = 401;
                    return;
                }
            }
    
            SpfyWhk__c theSpfyWhk = new SpfyWhk__c(
                X_Shopify_API_Version__c = theReq.headers.get('X-Shopify-API-Version'),
                X_Shopify_Hmac_Sha256__c = theReq.headers.get('X-Shopify-Hmac-Sha256'),
                X_Shopify_Shop_Domain__c = theReq.headers.get('X-Shopify-Shop-Domain'),
                X_Shopify_Topic__c =  theReq.headers.get('X-Shopify-Topic'),
                PayLoad__c = theReq.requestBody.toString()
            );
            INSERT theSpfyWhk;
    
            if(theSpfyWhk.X_Shopify_Topic__c == 'orders/updated'){
                try{
                    OrderIdData theOrderIdData = (OrderIdData)JSON.deserialize(theSpfyWhk.PayLoad__c,OrderIdData.class);
                    UPSERT new SpfyOppSyncQue__c(
                        orderId__c = theOrderIdData.id,
                        order_number__c = theOrderIdData.order_number,
                        name__c = theOrderIdData.name,
                        versionLatest__c = Datetime.now().format('yyyyMMddHHmmssSSS')
                    ) orderId__c;
                    SpfyOppSyncBat.start();
                }catch(Exception ex){
                    Loggings.writeLog(
                        Loggings.createLogEntry(Loggings.Level.Error, '20200618-1433', 'Api_V1_SpfyWhk.Runner.run')
                            .putAttr('theSpfyWhk.Id', theSpfyWhk.Id)
                            .putAttr('Exception', ex.getMessage())
                            .putAttr('LineNumber', '' + ex.getLineNumber())
                            .putAttr('getStackTraceString', ex.getStackTraceString())
                    );
                    throw ex;
                }
            }
        }
    }

    public class OrderIdData{
        public Decimal id;
        public Decimal order_number;
        public String name;
    }
}