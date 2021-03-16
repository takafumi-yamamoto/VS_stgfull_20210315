@isTest
public class SpfyCyumonJohoTxtT {
    @isTest public static void CyumonJohoTexter_getText() {
        SpfyApi_OrdersGetEx.Order theOrder = new SpfyApi_OrdersGetEx.Order();

        theOrder.line_items = new List<SpfyApi_OrdersGetEx.LineItem>();
        SpfyApi_OrdersGetEx.LineItem aLineItem = new SpfyApi_OrdersGetEx.LineItem();
        aLineItem.title = '_';
        aLineItem.variant_title = '_';
        aLineItem.sku = '_';
        aLineItem.quantity = 1;
        theOrder.line_items.add(aLineItem);

        theOrder.shipping_address = new SpfyApi_OrdersGetEx.ShippingAddress();
        theOrder.shipping_address.last_name  = '_';
        theOrder.shipping_address.first_name  = '_';
        theOrder.shipping_address.zip = '1410031';
        theOrder.shipping_address.province = '_';
        theOrder.shipping_address.city = '_';
        theOrder.shipping_address.address1 = '_';
        theOrder.shipping_address.address2 = '_';
        theOrder.shipping_address.phone = '08000000000';

        Test.startTest();
        new SpfyCyumonJohoTxt.CyumonJohoTexter().getText(theOrder);
        Test.stopTest();

    }
}