public class SeizenKeiyakuShodan {
    
    public Opportunity Opp { get; private set; }
    public SeizenKeiyaku__c SeizenKeiyaku { get; private set; }
    public static SeizenKeiyakuShodan create(Opportunity pOpp, SeizenKeiyaku__c pSeizenKeiyaku){
        SeizenKeiyakuShodan theSeizenKeiyakuShodan = new SeizenKeiyakuShodan();
        theSeizenKeiyakuShodan.Opp = pOpp;
        theSeizenKeiyakuShodan.SeizenKeiyaku = pSeizenKeiyaku;
        return theSeizenKeiyakuShodan;
    }
}