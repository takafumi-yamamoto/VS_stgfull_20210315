public class SpfyApi_OrdersGet {

    public class Request{
        public String ids; //Retrieve only orders specified by a comma-separated list of order IDs.
        public String status = 'any'; //Filter orders by their status.
        public Integer limit_limit = 1;
    }
    public class Response{
        public List<Order> orders;
    }
    public class Order{
        public Decimal id;
        public Decimal order_number;
        public String name; //eg.#1024
        public String created_at;
        public String updated_at;
        public String closed_at;

        public String cancelled_at;
        public String financial_status;
        public String fulfillment_status;

        public String total_line_items_price;
        
        public String total_discounts;
        public String current_total_discounts = null;
        public String subtotal_price;
        public String current_subtotal_price = null;
        public String total_tax;
        public String current_total_tax = null;
        public String total_price;
        public String current_total_price = null;
        public List<Refund> refunds = new List<Refund>();

        public String gateway; //eg.Epsilon代引き決済
        public String checkout_id;
        public String order_status_url;
        public Decimal user_id;
        public String email;
        public String phone;
        public Customer customer;
        public BillingAddress billing_address;
        public ShippingAddress shipping_address;
        public List<LineItem> line_items;
        public List<DiscountCode> discount_codes;
        public List<ShippingLine> shipping_lines;
        public String note;
    }
    public class LineItem{
        public Decimal id;
        public String name;
        public String title;
        public String variant_title;
        public String sku;
        public Decimal quantity;
        public String price;
        public List<Prop> properties;
        public List<TaxLine> tax_lines;
    }
    public class Prop{
        public String name;
        public String value;
    }
    public class TaxLine{
        public Decimal rate;
        public String price;
    }
    public class DisCountCode{
        public String code;
        public String amount;
    }
    public class Refund{
        public Decimal id;
        public List<RefundLineItem> refund_line_items;

    }
    public class RefundLineItem{
        public Decimal line_item_id;
        public Decimal quantity;
    }
    public class ShippingLine{
        public Decimal id;
        public String title;
        public String price;
    }
    public class Customer{
        public Decimal id;
        public String email;
        public String first_name;
        public String last_name;
        public String phone; 
        public DefaultAddress default_address;
    }
    public class DefaultAddress{
        public Decimal id;
        public String first_name;
        public String last_name;
        public String zip;
        public String province_code;
        public String city;
        public String address1;
        public String address2;
    }
    public class BillingAddress{
        public String first_name;
        public String last_name;
        public String zip;
        public String province_code;
        public String city;
        public String address1;
        public String address2;
        public String phone;
    }
    public class ShippingAddress{
        public String first_name;
        public String last_name;
        public String zip;
        public String province_code;
        public String city;
        public String address1;
        public String address2;
        public String phone;
    }
    public class Result{
        public Boolean isSuccess = false;
        public Integer statusCode = 0;
        public String endPoint = '';
        public String reqBodyRaw = '';
        public String resBodyRaw = '';
        public Response response = new Response();
    }

    public interface IClient {
        Result sendRequest(
            String pBasicAuth_Username, String pBasicAuth_Password, 
            String pBaseUrl, Request pReq
        );
    }
    public class Client implements IClient{

        public Result sendRequest(
            String pBasicAuth_Username, String pBasicAuth_Password, 
            String pBaseUrl, Request pReq
        ){
            Result theResult = new Result();

        	HttpRequest theHttpReq = new HttpRequest(); 
            theHttpReq.setMethod('GET');

            String theCredential = pBasicAuth_Username + ':' + pBasicAuth_Password;
            String theToken = EncodingUtil.base64Encode(Blob.valueOf(theCredential));
            theHttpReq.setHeader('Authorization','Basic ' + theToken);
            
            String queryParam = '?limit=' + String.valueOf(pReq.limit_limit);
            if(!String.isBlank(pReq.ids)){ queryParam += '&ids=' + pReq.ids; }
            if(!String.isBlank(pReq.status)){ queryParam += '&status=' + pReq.status; }

            String theEndPoint = pBaseUrl + '/admin/api/2020-04/orders.json' + queryParam;
            theHttpReq.setEndpoint(theEndPoint);
            theResult.endPoint = theEndPoint;

            HTTPResponse theHttpRes = new Http().send(theHttpReq);
            Integer theStatusCode = theHttpRes.getStatusCode();
            theResult.statusCode = theStatusCode;

            String theResBody = theHttpRes.getBody();
            theResult.resBodyRaw = theResBody;
            if(theStatusCode == 200){
                theResult.response = (Response)JSON.deserialize(theResBody,Response.class);
                theResult.isSuccess = true;
            }
            
            return theResult;
        }
    }
}