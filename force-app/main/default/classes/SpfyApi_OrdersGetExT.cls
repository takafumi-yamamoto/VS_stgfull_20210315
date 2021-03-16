@isTest
public class SpfyApi_OrdersGetExT {

    public class ApiClientMock implements SpfyApi_OrdersGet.IClient{
        public SpfyApi_OrdersGet.Result sendRequest(
            String pBasicAuth_Username, String pBasicAuth_Password, 
            String pBaseUrl, SpfyApi_OrdersGet.Request pReq
        ){
            SpfyApi_OrdersGet.Result theResult = new SpfyApi_OrdersGet.Result();
            theResult.isSuccess = true;
            theResult.statusCode = 200;

            SpfyApi_OrdersGet.Response theResponse = new SpfyApi_OrdersGet.Response();
            theResult.response = theResponse;
            
            theResponse.orders = new List<SpfyApi_OrdersGet.Order>();
            SpfyApi_OrdersGet.Order theOrder = new SpfyApi_OrdersGet.Order();
            theOrder.total_line_items_price = '100';
            theOrder.total_discounts = '0';
            theOrder.subtotal_price = '100';
            theOrder.total_tax = '10';
            theOrder.total_price = '110';
            theResponse.orders.add(theOrder);

            SpfyApi_OrdersGet.Customer theCustomer = new SpfyApi_OrdersGet.Customer();
            theOrder.customer = theCustomer;

            SpfyApi_OrdersGet.DefaultAddress theDefaultAddress = new SpfyApi_OrdersGet.DefaultAddress();
            theCustomer.default_address = theDefaultAddress;

            SpfyApi_OrdersGet.BillingAddress theBillingAddress = new SpfyApi_OrdersGet.BillingAddress();
            theOrder.billing_address = theBillingAddress;

            SpfyApi_OrdersGet.ShippingAddress theShippingAddress = new SpfyApi_OrdersGet.ShippingAddress();
            theOrder.shipping_address = theShippingAddress;

            theOrder.line_items = new List<SpfyApi_OrdersGet.LineItem>();
            SpfyApi_OrdersGet.LineItem theLineItem = new SpfyApi_OrdersGet.LineItem();
            theLineItem.id = 1;
            theLineItem.name = '_';
            theLineItem.price = '1000';
            theLineItem.quantity = 10;
            theLineItem.title = '_';
            theLineItem.variant_title = '_';
            theOrder.line_items.add(theLineItem);

            theOrder.refunds = new List<SpfyApi_OrdersGet.Refund>();
            SpfyApi_OrdersGet.Refund theRefund = new SpfyApi_OrdersGet.Refund();
            theRefund.id = 1;
            theRefund.refund_line_items = new List<SpfyApi_OrdersGet.RefundLineItem>();
            SpfyApi_OrdersGet.RefundLineItem theRefundLineItem = new SpfyApi_OrdersGet.RefundLineItem();
            theRefundLineItem.line_item_id = 1;
            theRefundLineItem.quantity = 1;
            theRefund.refund_line_items.add(theRefundLineItem);
            theOrder.refunds.add(theRefund);

            theOrder.discount_codes = new List<SpfyApi_OrdersGet.DisCountCode>();
            theOrder.shipping_lines = new List<SpfyApi_OrdersGet.ShippingLine>();

            return theResult;
        }
    }
    @isTest public static void Client_sendRequest() {

        Test.startTest();
        SpfyApi_OrdersGetEx.Request theReq = new SpfyApi_OrdersGetEx.Request();
        theReq.ids = new List<Decimal>{1.0};

        new SpfyApi_OrdersGetEx.Client(
            new SpfyConfs.Config(),
            new ApiClientMock(),
            new SpfyApi_OrdersGetEx.ResponseConverter()
        ).sendRequest(theReq);
    
        Test.stopTest();
    }
}