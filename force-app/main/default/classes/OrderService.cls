@RestResource(urlMapping='/Order/*')
global with sharing class OrderService  {

    @HttpPost
    global static OpportunityWrapper doPost(OpportunityWrapper order) {
        System.debug('===order===' + order);
        return order;
    }

    @HttpDelete
    global static void remove() {
        System.debug('===order Delete===');
    }

    global class OpportunityWrapper {
        public String sfId {get; set;}
        public String rootSfId {get; set;}
        public String userId {get; set;}
        public String salesDate {get; set;}
        public String partnerMasterId {get; set;}
        public String subTotal {get; set;}                              
        public String totalAmount {get; set;}
        public List<ShohinWrapper> items {get; set;}
        public List<Payment> payments {get; set;}
    }

    global class ShohinWrapper {
        public String orderDate {get; set;}
        public String serviceAccountMasterId {get; set;}
        public String itemId {get; set;}
        public String itemName {get; set;}
        public String categoryCode {get; set;}
        public String partnerMasterId {get; set;}
        public String price {get; set;}
        public List<UserDiscount> userDiscounts {get; set;}
        public List<PartnerChargeDiscount> partnerChargeDiscounts {get; set;}
    }

    global class Payment {
        public String paymentMasterId {get; set;}
        public String paymentDate {get; set;}
        public String payment {get; set;}
    }

    global class UserDiscount {
        public String recordType {get; set;}
        public String discountPlanMasterId {get; set;}
        public String couponMasterId {get; set;}
        public String price {get; set;}
    }

    global class PartnerChargeDiscount {
        public String rebateAmount {get; set;}
    }

    global class JSONTokenResponse {
        public String token_type;
        public String expires_in;
        public String access_token;
    }

    global class OrderWrapper {
        String sfId;
        String rootSfId;
        String userId;
        String salesDate;
        Integer subTotal;
        Integer totalAmount;   
    }

}