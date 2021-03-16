public class ObosanbinShodanLinqs{

    public static List<Id> collectOppIds(List<ObosanbinShodan> pObosanbinShodans){
        Set<Id> theIds = new Set<Id>();
        for(ObosanbinShodan aObosanbinShodan : pObosanbinShodans){
            theIds.add( aObosanbinShodan.Opp.Id );
        }
        return new List<Id>(theIds);
    }

}