@isTest
public class Api_V1_SpfyWhkT {

    public class VerifyWebhookMock implements Api_V1_SpfyWhkRvf.IVerifyWebhook{
        public Boolean verify(RestRequest pRestRequest){return true;}
    }
    @isTest public static void httpPost() {

        Api_V1_SpfyWhk.OrderIdData theOrderData = new Api_V1_SpfyWhk.OrderIdData();
        theOrderData.id = 1.0;
        theOrderData.name = '#1';
        theOrderData.order_number = 1.0;

        Api_V1_SpfyWhk.mWebhookVerification = new VerifyWebhookMock();

        RestRequest theRequest = new RestRequest();
        theRequest.addHeader('X-Shopify-API-Version', '_');
        theRequest.addHeader('X-Shopify-Hmac-Sha256', '_');
        theRequest.addHeader('X-Shopify-Shop-Domain','_');
        theRequest.addHeader('X-Shopify-Topic', 'orders/updated');
        theRequest.requestBody = Blob.valueOf( JSON.serialize(theOrderData) );

        RestContext.request = theRequest;
        RestContext.response = new RestResponse();

        Test.startTest();
        Api_V1_SpfyWhk.httpPost();
        Test.stopTest();
    }

    @isTest public static void httpPost_exception() {

        Api_V1_SpfyWhk.OrderIdData theOrderData = new Api_V1_SpfyWhk.OrderIdData();
        theOrderData.id = 1.0;
        theOrderData.name = '#1';
        theOrderData.order_number = 1.0;

        Api_V1_SpfyWhk.mWebhookVerification = new VerifyWebhookMock();

        RestRequest theRequest = new RestRequest();
        theRequest.addHeader('X-Shopify-API-Version', '_');
        theRequest.addHeader('X-Shopify-Hmac-Sha256', '_');
        theRequest.addHeader('X-Shopify-Shop-Domain','_');
        theRequest.addHeader('X-Shopify-Topic', 'orders/updated');
        theRequest.requestBody = Blob.valueOf( '_' );

        RestContext.request = theRequest;
        RestContext.response = new RestResponse();

        Test.startTest();
        try{
            Api_V1_SpfyWhk.httpPost();
        }catch(Exception ex){}
        
        Test.stopTest();
    }
}