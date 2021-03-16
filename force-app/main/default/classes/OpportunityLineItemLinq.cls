public class OpportunityLineItemLinq{

    public static List<Id> collectProductIds(List<OpportunityLineItem> entries){
        Set<Id> theIds = new Set<Id>();
        for(OpportunityLineItem aEntry : entries){
            theIds.add(aEntry.Product2Id);
        }
        return new List<Id>( theIds );
    }
    
}