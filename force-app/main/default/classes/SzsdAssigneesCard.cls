public class SzsdAssigneesCard {
    
    public static ICardFinder get_ICardFinder_instance(){
        return new CardFinder();
    }
    public interface ICardFinder {
        Boolean is_card_published_for_any_asignee(String p_opp_id);
    }
    public class CardFinder implements ICardFinder{
        public Boolean is_card_published_for_any_asignee(String p_opp_id){
            return 
            [SELECT Id FROM KrshSzkSdnShkCard__c WHERE OppRef__c = :p_opp_id LIMIT 1].size() > 0
            ||
            [SELECT Id FROM NcpSzkSdnShkCard__c WHERE OppRef__c = :p_opp_id LIMIT 1].size() > 0
            ;
        }
    }
}