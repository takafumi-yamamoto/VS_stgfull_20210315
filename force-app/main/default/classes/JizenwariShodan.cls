public class JizenwariShodan {
    
    public Opportunity Opp { get; private set; }
    public Jizenwari__c Jizenwari { get; private set; }
    public static JizenwariShodan create(Opportunity pOpp, Jizenwari__c pJizenwari){
        JizenwariShodan theJizenwariShodan = new JizenwariShodan();
        theJizenwariShodan.Opp = pOpp;
        theJizenwariShodan.Jizenwari = pJizenwari;
        return theJizenwariShodan;
    }
}