@isTest
public class SpfyOrdersGetT {

    public class OrderApiMock implements SpfyApi_OrdersGetEx.IClient{
        public SpfyApi_OrdersGetEx.Result sendRequest(SpfyApi_OrdersGetEx.Request pReq){
            SpfyApi_OrdersGetEx.Result theResult = new SpfyApi_OrdersGetEx.Result();
            theResult.isSuccess = true;
            SpfyApi_OrdersGetEx.Response theResponse = new SpfyApi_OrdersGetEx.Response();
            theResult.response = theResponse;
            theResponse.orders = new List<SpfyApi_OrdersGetEx.Order>();
            SpfyApi_OrdersGetEx.Order theOrder = new SpfyApi_OrdersGetEx.Order();
            theResponse.orders.add(theOrder);
            return theResult;
        }
    }
    @isTest public static void Client_getOrder() {
        Test.startTest();
        new SpfyOrdersGet.Client( new OrderApiMock() ).getOrder(1.0);
        Test.stopTest();
    }
}