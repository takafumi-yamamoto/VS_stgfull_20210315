public class RyunyuBaitaiBangos {

    @TestVisible
    private static IRyunyuBaitaiBango_Is_Mandatory IRyunyuBaitaiBango_Is_Mandatory_instance;
    public static IRyunyuBaitaiBango_Is_Mandatory get_IRyunyuBaitaiBango_Is_Mandatory_instance(){
        if( IRyunyuBaitaiBango_Is_Mandatory_instance == null ) IRyunyuBaitaiBango_Is_Mandatory_instance = new RyunyuBaitaiBango_Is_Mandatory();
        return IRyunyuBaitaiBango_Is_Mandatory_instance;
    }
    
    public interface IRyunyuBaitaiBango_Is_Mandatory{
        void on_opp_before_update(List<Opportunity> p_new_ones, Map<Id, Opportunity> p_old_ones);
    }
    public class RyunyuBaitaiBango_Is_Mandatory implements IRyunyuBaitaiBango_Is_Mandatory{
        public void on_opp_before_update(List<Opportunity> p_new_ones, Map<Id, Opportunity> p_old_ones){
            for(Opportunity a_new_one : p_new_ones){
                Opportunity a_old_one = p_old_ones.get(a_new_one.Id);
                if( a_new_one.Iriguchi__c != a_old_one.Iriguchi__c){
                    if( a_new_one.Iriguchi__c == '折込チラシ' && String.isBlank(a_new_one.RyunyuBaitaiBango__c) ){
                        a_new_one.addError('流入経路が折込チラシの場合は、流入媒体管理番号は必須です');
                    }
                }
            }
        }
    }
}