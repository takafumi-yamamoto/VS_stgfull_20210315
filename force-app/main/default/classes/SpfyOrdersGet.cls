public class SpfyOrdersGet {
    
    public interface IClient {
        SpfyApi_OrdersGetEx.Order getOrder(Decimal pOrderId);
    }
    public class Client implements IClient{
        private SpfyApi_OrdersGetEx.IClient mOrderApi;
        public Client(
            SpfyApi_OrdersGetEx.IClient pOrderApi
        ){
            this.mOrderApi = pOrderApi;
        }
        
        public SpfyApi_OrdersGetEx.Order getOrder(Decimal pOrderId){
            SpfyApi_OrdersGetEx.Request theOrderReq = new SpfyApi_OrdersGetEx.Request();
            theOrderReq.ids = new List<Decimal>{ pOrderId };
            theOrderReq.limit_limit = 1;
            SpfyApi_OrdersGetEx.Result theOrderResult = this.mOrderApi.sendRequest(theOrderReq);
            return theOrderResult.response.orders.get(0);
        }
    }
}