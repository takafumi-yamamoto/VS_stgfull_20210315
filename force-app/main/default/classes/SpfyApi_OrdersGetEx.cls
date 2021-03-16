public class SpfyApi_OrdersGetEx {
    public class Request{
        public List<Decimal> ids; //Retrieve only orders specified by a comma-separated list of order IDs.
        public Integer limit_limit = 1;
    }
    public class Response{
        public List<Order> orders = new List<Order>();
    }
    public class Order{
        public Decimal id;
        public Decimal order_number;
        public String name; //eg.#1024
        public Datetime created_at;
        public Datetime updated_at;
        public Datetime closed_at;

        public Datetime cancelled_at;
        public String financial_status;
        public String fulfillment_status;

        public Decimal total_line_items_price = 0.0;
        public Decimal total_discounts = 0.0;
        public Decimal total_tax = 0.0;
        public Decimal subtotal_price = 0.0;
        public Decimal total_shipping_lines_price = 0.0;
        public Decimal total_price = 0.0;

        public String gateway; //eg.Epsilon代引き決済
        public String checkout_id;
        public String order_status_url;
        public Decimal user_id;
        public String email;
        public String phone;
        public String note;
        public Customer customer;
        public BillingAddress billing_address;
        public ShippingAddress shipping_address;
        public List<LineItem> line_items = new List<LineItem>();
        public List<DisCountCode> discount_codes = new List<DisCountCode>();
        
    }
    public class LineItem{
        public Decimal id;
        public String name;
        public String title;
        public String variant_title;
        public String sku;
        public Decimal quantity = 0;
        public Decimal price = 0;
        public List<Prop> properties = new List<Prop>();
        public String getPropsText(){
            List<String> thePropTexts = new List<String>();
            for(Prop aProp : this.properties){ thePropTexts.add( aProp.getPropText() ); }
            return String.join(thePropTexts, ' / ');
        }
    }
    public class Prop{
        public String name;
        public String value;
        public String getPropText(){
            return String.format('{0}: {1}', new List<String>{ this.name, this.value });
        }
    }
    public class DisCountCode{
        public String code;
        public String amount;
    }
    public class Customer{
        public Decimal id;
        public String first_name;
        public String last_name;
        public String email;
        public String phone; 
        public String zip;
        public String province;
        public String city;
        public String address1;
        public String address2;
    }
    public class BillingAddress{
        public String first_name;
        public String last_name;
        public String zip;
        public String province;
        public String city;
        public String address1;
        public String address2;
        public String phone;
    }
    public class ShippingAddress{
        public String first_name;
        public String last_name;
        public String zip;
        public String province;
        public String city;
        public String address1;
        public String address2;
        public String phone;
    }

    public class Result{
        public Boolean isSuccess = false;
        public SpfyApi_OrdersGet.Result apiResult;
        public Response response = new Response();
    }

    public interface IClient {
        Result sendRequest(Request pReq);
    }
    public class Client implements IClient{

        private SpfyConfs.Config mConfig;
        private SpfyApi_OrdersGet.IClient mApiClient;
        private ResponseConverter mResponseConverter;
        public Client(
            SpfyConfs.Config pConfig,
            SpfyApi_OrdersGet.IClient pApiClient,
            ResponseConverter pResponseConverter
        ){
            this.mConfig = pConfig;
            this.mApiClient = pApiClient;
            this.mResponseConverter = pResponseConverter;
        }

        public Result sendRequest(Request pReq){
            Result theResult = new Result();

            SpfyApi_OrdersGet.Request theApiReq = new SpfyApi_OrdersGet.Request();
            List<String> theIds = new List<String>();
            for(Decimal aId : pReq.ids){ theIds.add(String.valueOf(aId)); }
            theApiReq.ids = String.join(theIds,',');
            theApiReq.status = 'any';
            theApiReq.limit_limit = pReq.limit_limit;

            SpfyApi_OrdersGet.Result theApiResult = 
                this.mApiClient.sendRequest(
                    this.mConfig.basic_auth_username, 
                    this.mConfig.basic_auth_password,
                    this.mConfig.api_base_url,
                    theApiReq
                );

            theResult.isSuccess = theApiResult.isSuccess;
            theResult.apiResult = theApiResult;
            
            if( theApiResult.isSuccess ){
                theResult.response = this.mResponseConverter.convertResponse(theApiResult.response);
            }
            
            return theResult;
        }
    }

    public class ResponseConverter{
        public Response convertResponse(SpfyApi_OrdersGet.Response pApiResponse){
            Response theResponse = new Response();
            for( SpfyApi_OrdersGet.Order aApiOrder : pApiResponse.orders){
                theResponse.orders.add(
                    this.convertOrder(aApiOrder)
                );
            }
            return theResponse;
        }
        public Order convertOrder(SpfyApi_OrdersGet.Order pApiOrder){
            Order theOrder = new Order();

            theOrder.id = pApiOrder.id;
            theOrder.order_number = pApiOrder.order_number;
            theOrder.name = pApiOrder.name;
            theOrder.created_at = 
                String.isBlank(pApiOrder.created_at) 
                ? null
                : Datetime.valueOf(pApiOrder.created_at.replace('T',' '));
            theOrder.updated_at = 
                String.isBlank(pApiOrder.updated_at) 
                ? null
                : Datetime.valueOf(pApiOrder.updated_at.replace('T',' '));
                theOrder.closed_at = 
                String.isBlank(pApiOrder.closed_at) 
                ? null
                : Datetime.valueOf(pApiOrder.closed_at.replace('T',' '));        
            
            theOrder.cancelled_at = 
                String.isBlank(pApiOrder.cancelled_at) 
                ? null
                : Datetime.valueOf(pApiOrder.cancelled_at.replace('T',' ')); 
            theOrder.financial_status = pApiOrder.financial_status;
            theOrder.fulfillment_status = pApiOrder.fulfillment_status;

            
            theOrder.total_discounts = String.isBlank(pApiOrder.current_total_discounts)
                ? Decimal.valueOf(pApiOrder.total_discounts)
                : Decimal.valueOf(pApiOrder.current_total_discounts);

            theOrder.subtotal_price = String.isBlank(pApiOrder.current_subtotal_price)
                ? Decimal.valueOf(pApiOrder.subtotal_price)
                : Decimal.valueOf(pApiOrder.current_subtotal_price);

            theOrder.total_tax = String.isBlank(pApiOrder.current_total_tax)
                ? Decimal.valueOf(pApiOrder.total_tax)
                : Decimal.valueOf(pApiOrder.current_total_tax);

            for(SpfyApi_OrdersGet.ShippingLine aShippingLine : pApiOrder.shipping_lines){
                theOrder.total_shipping_lines_price += Decimal.valueOf(aShippingLine.price);
            }

            theOrder.total_price = String.isBlank(pApiOrder.current_total_price)
                ? Decimal.valueOf(pApiOrder.total_price)
                : Decimal.valueOf(pApiOrder.current_total_price);

            theOrder.total_line_items_price = theOrder.total_price;
            theOrder.total_line_items_price -= theOrder.total_shipping_lines_price;
            theOrder.total_line_items_price -= theOrder.total_tax;
            theOrder.total_line_items_price -= (theOrder.total_discounts * -1);
            

            theOrder.gateway = pApiOrder.gateway;
            theOrder.checkout_id = pApiOrder.checkout_id;
            theOrder.order_status_url = pApiOrder.order_status_url;
            theOrder.user_id = pApiOrder.user_id;
            theOrder.email = pApiOrder.email;
            theOrder.phone = pApiOrder.phone;
            if(!String.isBlank(theOrder.phone)) theOrder.phone = theOrder.phone.replace('+81', '0');
            theOrder.note = pApiOrder.note;

            Customer theCustomer = new Customer();
            theCustomer.id = pApiOrder.customer.id;
            theCustomer.first_name = pApiOrder.customer.first_name;
            theCustomer.last_name = pApiOrder.customer.last_name;
            theCustomer.email = pApiOrder.customer.email;
            theCustomer.phone = pApiOrder.customer.phone;
            if(!String.isBlank(theCustomer.phone)) theCustomer.phone = theCustomer.phone.replace('+81', '0');
            theCustomer.zip = pApiOrder.customer.default_address.zip;
            theCustomer.province = ProvinceCodes.getName(pApiOrder.customer.default_address.province_code);
            theCustomer.city = pApiOrder.customer.default_address.city;
            theCustomer.address1 = pApiOrder.customer.default_address.address1;
            theCustomer.address2 = pApiOrder.customer.default_address.address2;
            theOrder.customer = theCustomer;

            BillingAddress theBillingAddress = new BillingAddress();
            theBillingAddress.last_name = pApiOrder.billing_address.last_name;
            theBillingAddress.first_name = pApiOrder.billing_address.first_name;
            theBillingAddress.zip = pApiOrder.billing_address.zip;
            theBillingAddress.province = ProvinceCodes.getName(pApiOrder.billing_address.province_code);
            theBillingAddress.city = pApiOrder.billing_address.city;
            theBillingAddress.address1 = pApiOrder.billing_address.address1;
            theBillingAddress.address2 = pApiOrder.billing_address.address2;
            theBillingAddress.phone = pApiOrder.billing_address.phone;
            if(!String.isBlank(theBillingAddress.phone)) theBillingAddress.phone = theBillingAddress.phone.replace('+81', '0');
            theOrder.billing_address = theBillingAddress;

            ShippingAddress theShippingAddress = new ShippingAddress();
            theShippingAddress.last_name = pApiOrder.shipping_address.last_name;
            theShippingAddress.first_name = pApiOrder.shipping_address.first_name;
            theShippingAddress.zip = pApiOrder.shipping_address.zip;
            theShippingAddress.province = ProvinceCodes.getName(pApiOrder.shipping_address.province_code);
            theShippingAddress.city = pApiOrder.shipping_address.city;
            theShippingAddress.address1 = pApiOrder.shipping_address.address1;
            theShippingAddress.address2 = pApiOrder.shipping_address.address2;
            theShippingAddress.phone = pApiOrder.shipping_address.phone;
            if(!String.isBlank(theShippingAddress.phone)) theShippingAddress.phone = theShippingAddress.phone.replace('+81', '0');
            theOrder.shipping_address = theShippingAddress;

            for( SpfyApi_OrdersGet.LineItem aApiLineItem : pApiOrder.line_items){
                LineItem aLineItem = this.convertLineItem(aApiLineItem);
                Decimal theRefundQuantity = this.getRefundQuantityOfLineItem(pApiOrder, aApiLineItem.id);
                aLineItem.quantity -= theRefundQuantity;
                if( aLineItem.quantity != 0){
                    theOrder.line_items.add(aLineItem);
                }
            }

            for( SpfyApi_OrdersGet.DisCountCode aApiDiscountCode : pApiOrder.discount_codes ){
                DisCountCode aDisCountCode = new DisCountCode();
                aDisCountCode.code = aApiDiscountCode.code;
                aDisCountCode.amount = aApiDiscountCode.amount;
                theOrder.discount_codes.add(aDisCountCode);
            }

            return theOrder;
        }
        public LineItem convertLineItem(SpfyApi_OrdersGet.LineItem pApiLineItem){
            LineItem theLineItem = new LineItem();
            theLineItem.id = pApiLineItem.id;
            theLineItem.name = pApiLineItem.name;
            theLineItem.title = pApiLineItem.title;
            theLineItem.variant_title = pApiLineItem.variant_title;
            theLineItem.sku = pApiLineItem.sku;
            theLineItem.quantity = pApiLineItem.quantity;
            theLineItem.price = Decimal.valueOf( pApiLineItem.price );
            if(pApiLineItem.properties != null){
                for(SpfyApi_OrdersGet.Prop aProperty : pApiLineItem.properties){
                    Prop theProp = new Prop();
                    theProp.name = aProperty.name;
                    theProp.value = aProperty.value;
                    theLineItem.properties.add(theProp);
                }
            }
            return theLineItem;
        }
        public Decimal getRefundQuantityOfLineItem(SpfyApi_OrdersGet.Order pOrder, Decimal pLineItemId){
            Decimal theQuantityRefunded = 0;
            if(pOrder.refunds == null) return theQuantityRefunded;

            for( SpfyApi_OrdersGet.Refund aRefund : pOrder.refunds ){
                if(aRefund.refund_line_items == null) continue;
                for( SpfyApi_OrdersGet.RefundLineItem aRefundLineItem: aRefund.refund_line_items ){
                    if( aRefundLineItem.line_item_id == pLineItemId){
                        theQuantityRefunded += aRefundLineItem.quantity;
                    }
                }
            }
            return theQuantityRefunded;
        }
    }
}