@isTest
public class Api_V1_SpfyWhkRvfT {
    @isTest public static void WebhookVerification_verify() {
        RestRequest theReuest = new RestRequest();
        theReuest.requestBody = Blob.valueOf('request-body');
        theReuest.addHeader('X-Shopify-Hmac-Sha256', 'messagehash');
        Test.startTest();
        new Api_V1_SpfyWhkRvf.WebhookVerification('secret').verify(theReuest);
        Test.stopTest();
    }
}