public class SeizenKeiyakuShodanLinqs{

    public static List<Id> collectOppIds(List<SeizenKeiyakuShodan> pSeizenKeiyakuShodans){
        Set<Id> theIds = new Set<Id>();
        for(SeizenKeiyakuShodan aSeizenKeiyakuShodan : pSeizenKeiyakuShodans){
            theIds.add( aSeizenKeiyakuShodan.Opp.Id );
        }
        return new List<Id>(theIds);
    }

}