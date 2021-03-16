public without sharing class SpfyLitmsSvc {
    @AuraEnabled(cacheable=true)
    public static List<SpfyLineItem__c> getSpfyLineItemsByOppId( String pOppId ){
        String theSpfyOrderId =
            [SELECT Id, RefHub4OppRef__r.SpfyOrderRef__c FROM Opportunity WHERE Id = :pOppId]
            .get(0)
            .RefHub4OppRef__r.SpfyOrderRef__c;
        
        if(String.isBlank(theSpfyOrderId)) return new List<SpfyLineItem__c>();

        return [
            SELECT Id, 
            title__c, 
            variant_title__c, 
            properties__c,
            sku__c,
            price__c,
            quantity__c,
            total_price_exp__c
            FROM SpfyLineItem__c
            WHERE SpfyOrderRef__c = :theSpfyOrderId
            ORDER BY CreatedDate
        ];
    }
}