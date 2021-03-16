public class ObosanbinShodan {
    
    public Opportunity Opp { get; private set; }
    public Obosanbin__c Obosanbin { get; private set; }
    public static ObosanbinShodan create(Opportunity pOpp, Obosanbin__c pObosanbin){
        ObosanbinShodan theObosanbinShodan = new ObosanbinShodan();
        theObosanbinShodan.Opp = pOpp;
        theObosanbinShodan.Obosanbin = pObosanbin;
        return theObosanbinShodan;
    }
}