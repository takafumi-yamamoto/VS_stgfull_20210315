public without sharing class SpfyOppLitmsSvc {

    @AuraEnabled(cacheable=true)
    public static List<OpportunityLineItem> getOppLineItems( String pOppId ){

        return [
            SELECT Id, Product2.Name, TotalPrice
            FROM OpportunityLineItem 
            WHERE OpportunityId = :pOppId
        ];
    }
}